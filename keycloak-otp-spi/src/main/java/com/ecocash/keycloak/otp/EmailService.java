package com.ecocash.keycloak.otp;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import org.jboss.logging.Logger;

import java.util.Properties;

/**
 * Service for sending Email via SMTP
 */
public class EmailService {

    private static final Logger logger = Logger.getLogger(EmailService.class);

    private final String smtpHost;
    private final String smtpPort;
    private final String smtpUsername;
    private final String smtpPassword;
    private final String fromEmail;
    private final String fromName;
    private final boolean useTLS;

    public EmailService() {
        this.smtpHost = getEnv(OTPConfig.SMTP_HOST_ENV, "smtp.gmail.com");
        this.smtpPort = getEnv(OTPConfig.SMTP_PORT_ENV, "587");
        this.smtpUsername = getEnv(OTPConfig.SMTP_USERNAME_ENV);
        this.smtpPassword = getEnv(OTPConfig.SMTP_PASSWORD_ENV);
        this.fromEmail = getEnv(OTPConfig.SMTP_FROM_EMAIL_ENV, "noreply@ecocash.co.zw");
        this.fromName = getEnv(OTPConfig.SMTP_FROM_NAME_ENV, "EcoCash");
        this.useTLS = Boolean.parseBoolean(getEnv(OTPConfig.SMTP_USE_TLS_ENV, "true"));
    }

    /**
     * Check if SMTP is properly configured
     */
    public boolean isConfigured() {
        return smtpHost != null && !smtpHost.isEmpty()
            && smtpUsername != null && !smtpUsername.isEmpty()
            && smtpPassword != null && !smtpPassword.isEmpty();
    }

    /**
     * Send OTP code via Email
     */
    public boolean sendOTP(String toEmail, String otpCode, String username) {
        if (!isConfigured()) {
            logger.error("SMTP not configured. Cannot send email.");
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.host", smtpHost);
            props.put("mail.smtp.port", smtpPort);

            if (useTLS) {
                props.put("mail.smtp.starttls.enable", "true");
            }

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(smtpUsername, smtpPassword);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail, fromName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Your EcoCash Verification Code");

            String htmlContent = buildEmailHTML(otpCode, username);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);

            logger.infof("Email sent successfully to %s", toEmail);
            return true;

        } catch (Exception e) {
            logger.errorf("Failed to send email to %s: %s", toEmail, e.getMessage());
            return false;
        }
    }

    private String buildEmailHTML(String otpCode, String username) {
        return String.format("""
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>EcoCash Verification Code</title>
            </head>
            <body style="margin: 0; padding: 0; font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background-color: #07091A;">
                <div style="max-width: 600px; margin: 40px auto; background-color: #0A0F28; border: 1px solid #1A2248; border-radius: 16px; overflow: hidden;">
                    <!-- Header -->
                    <div style="background: linear-gradient(135deg, #0052A5, #00398A); padding: 32px; text-align: center;">
                        <h1 style="color: #FFFFFF; margin: 0; font-size: 24px; font-weight: 700;">EcoCash Developer Portal</h1>
                    </div>

                    <!-- Body -->
                    <div style="padding: 40px 32px;">
                        <p style="color: #EEF2FF; font-size: 16px; margin: 0 0 24px;">Hello %s,</p>

                        <p style="color: #8B9CC8; font-size: 14px; line-height: 1.6; margin: 0 0 32px;">
                            You requested a verification code to access your account. Use the code below to complete your sign in:
                        </p>

                        <!-- OTP Code Box -->
                        <div style="background-color: #0D1230; border: 2px solid #0052A5; border-radius: 12px; padding: 24px; text-align: center; margin: 0 0 32px;">
                            <div style="color: #8B9CC8; font-size: 12px; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 12px;">Your Verification Code</div>
                            <div style="color: #0052A5; font-size: 36px; font-weight: 700; letter-spacing: 0.2em; font-family: 'Courier New', monospace;">%s</div>
                        </div>

                        <p style="color: #8B9CC8; font-size: 13px; line-height: 1.6; margin: 0 0 16px;">
                            This code will expire in <strong style="color: #EEF2FF;">%d minutes</strong>.
                        </p>

                        <p style="color: #8B9CC8; font-size: 13px; line-height: 1.6; margin: 0;">
                            If you didn't request this code, please ignore this email or contact support if you have concerns.
                        </p>
                    </div>

                    <!-- Footer -->
                    <div style="background-color: #090D22; padding: 24px 32px; border-top: 1px solid #1A2248;">
                        <p style="color: #4A5680; font-size: 12px; margin: 0; text-align: center;">
                            © 2025 EcoCash. All rights reserved.
                        </p>
                    </div>
                </div>
            </body>
            </html>
            """,
            username != null ? username : "User",
            otpCode,
            OTPConfig.OTP_EXPIRY_MINUTES
        );
    }

    private String getEnv(String key) {
        return System.getenv(key);
    }

    private String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value != null && !value.isEmpty()) ? value : defaultValue;
    }
}
