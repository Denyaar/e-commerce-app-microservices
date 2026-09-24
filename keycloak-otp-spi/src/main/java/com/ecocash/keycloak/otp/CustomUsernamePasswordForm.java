package com.ecocash.keycloak.otp;

import jakarta.ws.rs.core.MultivaluedMap;
import org.jboss.logging.Logger;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordForm;

/**
 * Custom Username/Password Form that captures OTP method selection
 */
public class CustomUsernamePasswordForm extends UsernamePasswordForm implements Authenticator {

    private static final Logger logger = Logger.getLogger(CustomUsernamePasswordForm.class);

    @Override
    public void action(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();

        // Capture OTP method selection from login form
        String otpMethod = formData.getFirst("otpType");
        if (otpMethod == null) {
            otpMethod = formData.getFirst("selectedOtpTypeHidden");
        }

        logger.infof("CustomUsernamePasswordForm: Captured OTP method: %s", otpMethod);

        // Store in authentication session for OTP authenticator to use
        if (otpMethod != null && !otpMethod.isEmpty()) {
            context.getAuthenticationSession().setAuthNote("otp_method", otpMethod);
            logger.infof("CustomUsernamePasswordForm: Stored otp_method in session: %s", otpMethod);
        } else {
            // Default to SMS if not specified
            context.getAuthenticationSession().setAuthNote("otp_method", "sms");
            logger.info("CustomUsernamePasswordForm: No OTP method selected, defaulting to SMS");
        }

        // Continue with normal username/password validation
        super.action(context);
    }
}