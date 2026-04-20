package com.ecocash.keycloak.otp;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.jboss.logging.Logger;

/**
 * Service for sending SMS via Twilio
 */
public class SMSService {

    private static final Logger logger = Logger.getLogger(SMSService.class);

    private final String accountSid;
    private final String authToken;
    private final String fromPhoneNumber;

    public SMSService() {
        this.accountSid = getEnv(OTPConfig.TWILIO_ACCOUNT_SID_ENV);
        this.authToken = getEnv(OTPConfig.TWILIO_AUTH_TOKEN_ENV);
        this.fromPhoneNumber = getEnv(OTPConfig.TWILIO_PHONE_NUMBER_ENV);
    }

    /**
     * Check if Twilio is properly configured
     */
    public boolean isConfigured() {
        return accountSid != null && !accountSid.isEmpty()
            && authToken != null && !authToken.isEmpty()
            && fromPhoneNumber != null && !fromPhoneNumber.isEmpty();
    }

    /**
     * Send OTP code via SMS
     */
    public boolean sendOTP(String toPhoneNumber, String otpCode, String username) {
        if (!isConfigured()) {
            logger.error("Twilio not configured. Cannot send SMS.");
            return false;
        }

        try {
            Twilio.init(accountSid, authToken);

            String messageBody = String.format(
                "Your EcoCash verification code is: %s\n\nThis code will expire in %d minutes.\n\nIf you didn't request this code, please ignore this message.",
                otpCode,
                OTPConfig.OTP_EXPIRY_MINUTES
            );

            Message message = Message.creator(
                new PhoneNumber(toPhoneNumber),
                new PhoneNumber(fromPhoneNumber),
                messageBody
            ).create();

            logger.infof("SMS sent successfully to %s. SID: %s", toPhoneNumber, message.getSid());
            return true;

        } catch (Exception e) {
            logger.errorf("Failed to send SMS to %s: %s", toPhoneNumber, e.getMessage());
            return false;
        }
    }

    private String getEnv(String key) {
        return System.getenv(key);
    }
}
