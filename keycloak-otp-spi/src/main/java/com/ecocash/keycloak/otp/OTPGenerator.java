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
     * Generate a random OTP code with default length
     */
    public static String generateOTP() {
        return generateOTP(OTPConfig.OTP_LENGTH);
    }

    /**
     * Generate a random OTP code with specified length
     */
    public static String generateOTP(int length) {
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(OTPConfig.OTP_CHARS.length());
            otp.append(OTPConfig.OTP_CHARS.charAt(index));
        }
        return otp.toString();
    }

    /**
     * Get OTP expiry timestamp with default expiry time
     */
    public static long getExpiryTimestamp() {
        return getExpiryTimestamp(OTPConfig.OTP_EXPIRY_MINUTES);
    }

    /**
     * Get OTP expiry timestamp with specified expiry time in minutes
     */
    public static long getExpiryTimestamp(int expiryMinutes) {
        return Instant.now()
                .plus(expiryMinutes, ChronoUnit.MINUTES)
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