package com.ecocash.keycloak.otp;

/**
 * Configuration class for OTP settings
 */
public class OTPConfig {

    // OTP Settings
    public static final int OTP_LENGTH = 6;
    public static final int OTP_EXPIRY_MINUTES = 5;
    public static final String OTP_CHARS = "0123456789";

    // SMS Settings (Twilio)
    public static final String TWILIO_ACCOUNT_SID_ENV = "TWILIO_ACCOUNT_SID";
    public static final String TWILIO_AUTH_TOKEN_ENV = "TWILIO_AUTH_TOKEN";
    public static final String TWILIO_PHONE_NUMBER_ENV = "TWILIO_PHONE_NUMBER";

    // Email Settings (SMTP)
    public static final String SMTP_HOST_ENV = "SMTP_HOST";
    public static final String SMTP_PORT_ENV = "SMTP_PORT";
    public static final String SMTP_USERNAME_ENV = "SMTP_USERNAME";
    public static final String SMTP_PASSWORD_ENV = "SMTP_PASSWORD";
    public static final String SMTP_FROM_EMAIL_ENV = "SMTP_FROM_EMAIL";
    public static final String SMTP_FROM_NAME_ENV = "SMTP_FROM_NAME";
    public static final String SMTP_USE_TLS_ENV = "SMTP_USE_TLS";

    // User Attributes
    public static final String USER_ATTR_PHONE = "phoneNumber";
    public static final String USER_ATTR_OTP_CODE = "otpCode";
    public static final String USER_ATTR_OTP_EXPIRY = "otpExpiry";
    public static final String USER_ATTR_OTP_TYPE = "otpType";

    // OTP Types
    public static final String OTP_TYPE_SMS = "sms";
    public static final String OTP_TYPE_EMAIL = "email";
}