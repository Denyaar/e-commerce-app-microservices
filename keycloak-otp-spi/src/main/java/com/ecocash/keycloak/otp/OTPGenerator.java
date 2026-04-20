package com.ecocash.keycloak.otp;

import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

/**
 * Utility class for generating and validating OTP codes
 */
public class OTPGenerator {

    private static final SecureRandom random = new SecureRandom();

    /**
     * Generate a random OTP code
     */
    public static String generateOTP() {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < OTPConfig.OTP_LENGTH; i++) {
            int index = random.nextInt(OTPConfig.OTP_CHARS.length());
            otp.append(OTPConfig.OTP_CHARS.charAt(index));
        }
        return otp.toString();
    }

    /**
     * Get OTP expiry timestamp
     */
    public static long getExpiryTimestamp() {
        return Instant.now()
                .plus(OTPConfig.OTP_EXPIRY_MINUTES, ChronoUnit.MINUTES)
                .toEpochMilli();
    }

    /**
     * Check if OTP has expired
     */
    public static boolean isExpired(long expiryTimestamp) {
        return Instant.now().toEpochMilli() > expiryTimestamp;
    }

    /**
     * Validate OTP code against stored code
     */
    public static boolean validateOTP(String inputOTP, String storedOTP, long expiryTimestamp) {
        if (inputOTP == null || storedOTP == null) {
            return false;
        }

        if (isExpired(expiryTimestamp)) {
            return false;
        }

        return inputOTP.trim().equals(storedOTP.trim());
    }
}