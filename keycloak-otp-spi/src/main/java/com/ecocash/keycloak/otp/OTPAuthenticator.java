package com.ecocash.keycloak.otp;

import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import org.jboss.logging.Logger;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.AuthenticationFlowError;
import org.keycloak.authentication.Authenticator;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;

/**
 * Custom OTP Authenticator for Keycloak with multi-method support
 */
public class OTPAuthenticator implements Authenticator {

    private static final Logger logger = Logger.getLogger(OTPAuthenticator.class);

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        UserModel user = context.getUser();

        if (user == null) {
            logger.error("User is null in OTP authentication");
            context.failure(AuthenticationFlowError.INVALID_USER);
            return;
        }

        boolean requirePhone = getConfigBoolean(context, OTPAuthenticatorFactory.CONFIG_REQUIRE_PHONE, false);
        if (requirePhone) {
            String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
            if (phoneNumber == null || phoneNumber.isEmpty()) {
                logger.warnf("User %s does not have phone number but it's required", user.getUsername());
                context.failureChallenge(
                    AuthenticationFlowError.INVALID_USER,
                    context.form()
                        .setError("Phone number is required for OTP authentication. Please contact support.")
                        .createErrorPage(Response.Status.BAD_REQUEST)
                );
                return;
            }
        }

        clearOtpState(user);

        List<String> availableOtpTypes = getAvailableOtpTypes(user);
        if (availableOtpTypes.isEmpty()) {
            logger.errorf("No available OTP delivery methods for user: %s", user.getUsername());
            context.failure(AuthenticationFlowError.INTERNAL_ERROR);
            return;
        }

        String selectedOtpType = resolveOtpType(
            context,
            availableOtpTypes,
            context.getAuthenticationSession().getAuthNote("otp_method"),
            null
        );

        logger.infof("Authenticating user %s with OTP delivery method %s", user.getUsername(), selectedOtpType);
        challengeWithSentOtp(context, user, selectedOtpType, null);
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        UserModel user = context.getUser();
        if (user == null) {
            logger.error("User is null in OTP action");
            context.failure(AuthenticationFlowError.INVALID_USER);
            return;
        }

        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        List<String> availableOtpTypes = getAvailableOtpTypes(user);
        String enteredOTP = formData.getFirst("otp");
        String otpType = resolveOtpType(
            context,
            availableOtpTypes,
            formData.getFirst("otpType"),
            user.getFirstAttribute(OTPConfig.USER_ATTR_OTP_TYPE)
        );
        boolean resend = "true".equals(formData.getFirst("resend"));

        if (resend || enteredOTP == null || enteredOTP.trim().isEmpty()) {
            challengeWithSentOtp(
                context,
                user,
                otpType,
                resend ? "A new verification code has been sent." : null
            );
            return;
        }

        String storedOTP = user.getFirstAttribute(OTPConfig.USER_ATTR_OTP_CODE);
        String expiryStr = user.getFirstAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY);

        if (storedOTP == null || expiryStr == null) {
            logger.error("OTP data not found for user: " + user.getUsername());
            context.failureChallenge(
                AuthenticationFlowError.INTERNAL_ERROR,
                createOtpForm(context, otpType, "Verification code expired. Please request a new code.")
            );
            return;
        }

        long expiryTimestamp;
        try {
            expiryTimestamp = Long.parseLong(expiryStr);
        } catch (NumberFormatException e) {
            logger.error("Invalid expiry timestamp for user: " + user.getUsername());
            context.failure(AuthenticationFlowError.INTERNAL_ERROR);
            return;
        }

        if (!OTPGenerator.validateOTP(enteredOTP, storedOTP, expiryTimestamp)) {
            logger.warnf("Invalid OTP attempt for user: %s", user.getUsername());

            if (OTPGenerator.isExpired(expiryTimestamp)) {
                context.failureChallenge(
                    AuthenticationFlowError.EXPIRED_CODE,
                    createOtpForm(context, otpType, "Verification code has expired. Please request a new code.")
                );
            } else {
                context.failureChallenge(
                    AuthenticationFlowError.INVALID_CREDENTIALS,
                    createOtpForm(context, otpType, "Invalid verification code. Please try again.")
                );
            }
            return;
        }

        clearOtpState(user);
        logger.infof("OTP validated successfully for user: %s", user.getUsername());
        context.success();
    }

    @Override
    public boolean requiresUser() {
        return true;
    }

    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return !getAvailableOtpTypes(user).isEmpty();
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // No required actions needed
    }

    @Override
    public void close() {
        // Cleanup if needed
    }

    private List<String> getAvailableOtpTypes(UserModel user) {
        List<String> availableOtpTypes = new ArrayList<>();
        String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
        String email = user.getEmail();

        if (phoneNumber != null && !phoneNumber.isEmpty()) {
            try {
                SMSService smsService = new SMSService();
                if (smsService.isConfigured()) {
                    availableOtpTypes.add(OTPConfig.OTP_TYPE_SMS);
                }
            } catch (Throwable t) {
                logger.warnf("SMS OTP unavailable: %s", t.getMessage());
            }
        }

        if (email != null && !email.isEmpty()) {
            try {
                EmailService emailService = new EmailService();
                if (emailService.isConfigured()) {
                    availableOtpTypes.add(OTPConfig.OTP_TYPE_EMAIL);
                }
            } catch (Throwable t) {
                logger.warnf("Email OTP unavailable: %s", t.getMessage());
            }
        }

        return availableOtpTypes;
    }

    private void challengeWithSentOtp(AuthenticationFlowContext context, UserModel user, String otpType, String successMessage) {
        int otpLength = getConfigInt(context, OTPAuthenticatorFactory.CONFIG_OTP_LENGTH, OTPConfig.OTP_LENGTH);
        int otpExpiry = getConfigInt(context, OTPAuthenticatorFactory.CONFIG_OTP_EXPIRY, OTPConfig.OTP_EXPIRY_MINUTES);
        String otpCode = OTPGenerator.generateOTP(otpLength);
        long expiryTimestamp = OTPGenerator.getExpiryTimestamp(otpExpiry);
        String username = user.getUsername();
        String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
        String email = user.getEmail();

        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_CODE, otpCode);
        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY, String.valueOf(expiryTimestamp));
        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_TYPE, otpType);

        sendOTPAsync(username, phoneNumber, email, otpCode, otpType);
        logger.infof("OTP verification page opened for user: %s via %s", username, otpType);
        context.challenge(createOtpForm(
            context,
            otpType,
            successMessage != null ? successMessage : "Verification code is being sent."
        ));
    }

    private Response createOtpForm(AuthenticationFlowContext context, String otpType, String message) {
        var form = context.form();

        if (otpType != null) {
            form.setAttribute("otpType", otpType);
        }

        if (message != null && !message.isBlank()) {
            form.setInfo(message);
        }

        return form.createForm("login-otp.ftl");
    }

    private String resolveOtpType(
        AuthenticationFlowContext context,
        List<String> availableOtpTypes,
        String requestedOtpType,
        String fallbackOtpType
    ) {
        String otpType = normalizeOtpType(requestedOtpType);
        if (otpType != null && availableOtpTypes.contains(otpType)) {
            return otpType;
        }

        otpType = normalizeOtpType(fallbackOtpType);
        if (otpType != null && availableOtpTypes.contains(otpType)) {
            return otpType;
        }

        String configuredOtpType = normalizeOtpType(
            getConfigString(context, OTPAuthenticatorFactory.CONFIG_OTP_METHOD, "auto")
        );
        if (configuredOtpType != null && availableOtpTypes.contains(configuredOtpType)) {
            return configuredOtpType;
        }

        if (availableOtpTypes.contains(OTPConfig.OTP_TYPE_SMS)) {
            return OTPConfig.OTP_TYPE_SMS;
        }

        return availableOtpTypes.get(0);
    }

    private String normalizeOtpType(String otpType) {
        if (OTPConfig.OTP_TYPE_SMS.equals(otpType) || OTPConfig.OTP_TYPE_EMAIL.equals(otpType)) {
            return otpType;
        }
        return null;
    }

    private void clearOtpState(UserModel user) {
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_CODE);
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY);
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_TYPE);
    }

    private void sendOTPAsync(String username, String phoneNumber, String email, String otpCode, String otpType) {
        CompletableFuture.runAsync(() -> {
            boolean sent = sendOTP(username, phoneNumber, email, otpCode, otpType);
            if (sent) {
                logger.infof("OTP sent successfully to user: %s via %s", username, otpType);
            } else {
                logger.errorf("Failed to send OTP to user: %s via %s", username, otpType);
            }
        });
    }

    private boolean sendOTP(String username, String phoneNumber, String email, String otpCode, String otpType) {
        if (OTPConfig.OTP_TYPE_SMS.equals(otpType)) {
            SMSService smsService;
            try {
                smsService = new SMSService();
            } catch (Throwable t) {
                logger.errorf("SMS service unavailable: %s", t.getMessage());
                return false;
            }

            if (phoneNumber == null || phoneNumber.isEmpty()) {
                logger.error("Phone number not found for SMS OTP: " + username);
                return false;
            }
            return smsService.sendOTP(phoneNumber, otpCode, username);
        }

        EmailService emailService;
        try {
            emailService = new EmailService();
        } catch (Throwable t) {
            logger.errorf("Email service unavailable: %s", t.getMessage());
            return false;
        }

        if (email == null || email.isEmpty()) {
            logger.error("Email not found for Email OTP: " + username);
            return false;
        }
        return emailService.sendOTP(email, otpCode, username);
    }

    private String getConfigString(AuthenticationFlowContext context, String key, String defaultValue) {
        String value = context.getAuthenticatorConfig() != null
            ? context.getAuthenticatorConfig().getConfig().get(key)
            : null;
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }

    private int getConfigInt(AuthenticationFlowContext context, String key, int defaultValue) {
        String value = getConfigString(context, key, String.valueOf(defaultValue));
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            logger.warnf("Invalid integer config for %s: %s, using default: %d", key, value, defaultValue);
            return defaultValue;
        }
    }

    private boolean getConfigBoolean(AuthenticationFlowContext context, String key, boolean defaultValue) {
        String value = getConfigString(context, key, String.valueOf(defaultValue));
        return Boolean.parseBoolean(value);
    }
}
