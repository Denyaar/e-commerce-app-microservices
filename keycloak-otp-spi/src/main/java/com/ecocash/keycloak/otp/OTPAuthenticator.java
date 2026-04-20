package com.ecocash.keycloak.otp;

import org.jboss.logging.Logger;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.AuthenticationFlowError;
import org.keycloak.authentication.Authenticator;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;

import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import java.util.List;

/**
 * Custom OTP Authenticator for Keycloak
 */
public class OTPAuthenticator implements Authenticator {

    private static final Logger logger = Logger.getLogger(OTPAuthenticator.class);
    private static final SMSService smsService = new SMSService();
    private static final EmailService emailService = new EmailService();

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        UserModel user = context.getUser();

        if (user == null) {
            logger.error("User is null in OTP authentication");
            context.failure(AuthenticationFlowError.INVALID_USER);
            return;
        }

        // Generate and send OTP
        String otpCode = OTPGenerator.generateOTP();
        long expiryTimestamp = OTPGenerator.getExpiryTimestamp();

        // Store OTP in user attributes
        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_CODE, otpCode);
        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY, String.valueOf(expiryTimestamp));

        // Determine OTP delivery method based on user preference or configuration
        String otpType = determineOTPType(user);
        user.setSingleAttribute(OTPConfig.USER_ATTR_OTP_TYPE, otpType);

        boolean sent = sendOTP(user, otpCode, otpType);

        if (!sent) {
            logger.errorf("Failed to send OTP to user: %s", user.getUsername());
            context.failureChallenge(
                AuthenticationFlowError.INTERNAL_ERROR,
                context.form()
                    .setError("Failed to send verification code. Please try again.")
                    .createForm("login-otp-error.ftl")
            );
            return;
        }

        logger.infof("OTP sent successfully to user: %s via %s", user.getUsername(), otpType);

        // Show OTP input form
        Response challenge = context.form()
            .setAttribute("otpType", otpType)
            .createForm("login-otp.ftl");

        context.challenge(challenge);
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        String enteredOTP = formData.getFirst("otp");

        if (enteredOTP == null || enteredOTP.trim().isEmpty()) {
            context.failureChallenge(
                AuthenticationFlowError.INVALID_CREDENTIALS,
                context.form()
                    .setError("Please enter the verification code")
                    .createForm("login-otp.ftl")
            );
            return;
        }

        UserModel user = context.getUser();
        String storedOTP = user.getFirstAttribute(OTPConfig.USER_ATTR_OTP_CODE);
        String expiryStr = user.getFirstAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY);

        if (storedOTP == null || expiryStr == null) {
            logger.error("OTP data not found for user: " + user.getUsername());
            context.failureChallenge(
                AuthenticationFlowError.INTERNAL_ERROR,
                context.form()
                    .setError("Verification code expired. Please try again.")
                    .createForm("login-otp.ftl")
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

        // Validate OTP
        if (!OTPGenerator.validateOTP(enteredOTP, storedOTP, expiryTimestamp)) {
            logger.warnf("Invalid OTP attempt for user: %s", user.getUsername());

            if (OTPGenerator.isExpired(expiryTimestamp)) {
                context.failureChallenge(
                    AuthenticationFlowError.EXPIRED_CODE,
                    context.form()
                        .setError("Verification code has expired. Please request a new code.")
                        .createForm("login-otp.ftl")
                );
            } else {
                context.failureChallenge(
                    AuthenticationFlowError.INVALID_CREDENTIALS,
                    context.form()
                        .setError("Invalid verification code. Please try again.")
                        .createForm("login-otp.ftl")
                );
            }
            return;
        }

        // Clear OTP data after successful validation
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_CODE);
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_EXPIRY);
        user.removeAttribute(OTPConfig.USER_ATTR_OTP_TYPE);

        logger.infof("OTP validated successfully for user: %s", user.getUsername());
        context.success();
    }

    @Override
    public boolean requiresUser() {
        return true;
    }

    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        // Check if user has phone number or email for OTP
        String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
        String email = user.getEmail();

        return (phoneNumber != null && !phoneNumber.isEmpty()) ||
               (email != null && !email.isEmpty());
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // No required actions needed
    }

    @Override
    public void close() {
        // Cleanup if needed
    }

    /**
     * Determine which OTP type to use (SMS or Email)
     */
    private String determineOTPType(UserModel user) {
        String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
        String email = user.getEmail();

        // Prefer SMS if phone number is available and SMS is configured
        if (phoneNumber != null && !phoneNumber.isEmpty() && smsService.isConfigured()) {
            return OTPConfig.OTP_TYPE_SMS;
        }

        // Fall back to email
        if (email != null && !email.isEmpty() && emailService.isConfigured()) {
            return OTPConfig.OTP_TYPE_EMAIL;
        }

        // Default to SMS
        return OTPConfig.OTP_TYPE_SMS;
    }

    /**
     * Send OTP via SMS or Email
     */
    private boolean sendOTP(UserModel user, String otpCode, String otpType) {
        String username = user.getUsername();

        if (OTPConfig.OTP_TYPE_SMS.equals(otpType)) {
            String phoneNumber = user.getFirstAttribute(OTPConfig.USER_ATTR_PHONE);
            if (phoneNumber == null || phoneNumber.isEmpty()) {
                logger.error("Phone number not found for SMS OTP: " + username);
                return false;
            }
            return smsService.sendOTP(phoneNumber, otpCode, username);
        } else {
            String email = user.getEmail();
            if (email == null || email.isEmpty()) {
                logger.error("Email not found for Email OTP: " + username);
                return false;
            }
            return emailService.sendOTP(email, otpCode, username);
        }
    }
}