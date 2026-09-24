package com.ecocash.keycloak.otp;

import org.keycloak.Config;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.AuthenticatorFactory;
import org.keycloak.models.AuthenticationExecutionModel;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.provider.ProviderConfigProperty;

import java.util.Arrays;
import java.util.List;

/**
 * Factory for OTP Authenticator with configurable options
 */
public class OTPAuthenticatorFactory implements AuthenticatorFactory {

    public static final String PROVIDER_ID = "ecocash-otp-authenticator";
    private static final OTPAuthenticator SINGLETON = new OTPAuthenticator();

    // Configuration property keys
    public static final String CONFIG_OTP_METHOD = "otp.method";
    public static final String CONFIG_OTP_LENGTH = "otp.length";
    public static final String CONFIG_OTP_EXPIRY = "otp.expiry";
    public static final String CONFIG_ALLOW_RESEND = "otp.allowResend";
    public static final String CONFIG_REQUIRE_PHONE = "otp.requirePhone";

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public String getDisplayType() {
        return "EcoCash OTP Authentication";
    }

    @Override
    public String getHelpText() {
        return "Sends OTP via SMS or Email for two-factor authentication. Configure delivery method, code length, and expiry time.";
    }

    @Override
    public String getReferenceCategory() {
        return "otp";
    }

    @Override
    public boolean isConfigurable() {
        return true;  // Enable configuration in admin console
    }

    @Override
    public boolean isUserSetupAllowed() {
        return false;
    }

    @Override
    public AuthenticationExecutionModel.Requirement[] getRequirementChoices() {
        return new AuthenticationExecutionModel.Requirement[]{
            AuthenticationExecutionModel.Requirement.REQUIRED,
            AuthenticationExecutionModel.Requirement.ALTERNATIVE,
            AuthenticationExecutionModel.Requirement.DISABLED
        };
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        ProviderConfigProperty otpMethod = new ProviderConfigProperty();
        otpMethod.setName(CONFIG_OTP_METHOD);
        otpMethod.setLabel("OTP Delivery Method");
        otpMethod.setType(ProviderConfigProperty.LIST_TYPE);
        otpMethod.setOptions(Arrays.asList("auto", "sms", "email"));
        otpMethod.setDefaultValue("auto");
        otpMethod.setHelpText("Choose how to deliver OTP: Auto (SMS if available, else Email), SMS only, or Email only");

        ProviderConfigProperty otpLength = new ProviderConfigProperty();
        otpLength.setName(CONFIG_OTP_LENGTH);
        otpLength.setLabel("OTP Code Length");
        otpLength.setType(ProviderConfigProperty.STRING_TYPE);
        otpLength.setDefaultValue("6");
        otpLength.setHelpText("Length of OTP code (4-8 digits recommended)");

        ProviderConfigProperty otpExpiry = new ProviderConfigProperty();
        otpExpiry.setName(CONFIG_OTP_EXPIRY);
        otpExpiry.setLabel("OTP Expiry (minutes)");
        otpExpiry.setType(ProviderConfigProperty.STRING_TYPE);
        otpExpiry.setDefaultValue("5");
        otpExpiry.setHelpText("How long the OTP code is valid (in minutes)");

        ProviderConfigProperty allowResend = new ProviderConfigProperty();
        allowResend.setName(CONFIG_ALLOW_RESEND);
        allowResend.setLabel("Allow Resend OTP");
        allowResend.setType(ProviderConfigProperty.BOOLEAN_TYPE);
        allowResend.setDefaultValue(true);
        allowResend.setHelpText("Allow users to request a new OTP code if they didn't receive it");

        ProviderConfigProperty requirePhone = new ProviderConfigProperty();
        requirePhone.setName(CONFIG_REQUIRE_PHONE);
        requirePhone.setLabel("Require Phone Number");
        requirePhone.setType(ProviderConfigProperty.BOOLEAN_TYPE);
        requirePhone.setDefaultValue(false);
        requirePhone.setHelpText("Require users to have a phone number attribute. If false, will fall back to email.");

        return Arrays.asList(otpMethod, otpLength, otpExpiry, allowResend, requirePhone);
    }

    @Override
    public Authenticator create(KeycloakSession session) {
        return SINGLETON;
    }

    @Override
    public void init(Config.Scope config) {
        // Initialization logic if needed
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
        // Post-initialization logic if needed
    }

    @Override
    public void close() {
        // Cleanup logic if needed
    }
}