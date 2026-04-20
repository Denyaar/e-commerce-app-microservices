<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('otp'); section>
    <#if section = "header">
        <span class="kc-logo-text">EcoCash</span>
        ${msg("loginOtpTitle")}
    <#elseif section = "form">

    <div id="kc-otp-container">
        <p class="instruction">
            <#if otpType?? && otpType == "sms">
                ${msg("loginOtpSmsInstruction")}
            <#else>
                ${msg("loginOtpEmailInstruction")}
            </#if>
        </p>

        <form id="kc-otp-form" action="${url.loginAction}" method="post">
            <div class="form-group">
                <label for="otp" class="${properties.kcLabelClass!}">${msg("loginOtpCode")}</label>

                <input tabindex="1" id="otp" name="otp" type="text" class="${properties.kcInputClass!}"
                       autofocus autocomplete="off"
                       maxlength="6"
                       pattern="[0-9]*"
                       inputmode="numeric"
                       placeholder="000000"
                       aria-invalid="<#if messagesPerField.existsError('otp')>true</#if>"
                       style="text-align: center; font-size: 24px; letter-spacing: 0.5em; font-family: 'Courier New', monospace;"
                />

                <#if messagesPerField.existsError('otp')>
                    <span id="input-error-otp" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('otp'))?no_esc}
                    </span>
                </#if>
            </div>

            <div id="kc-form-buttons" class="form-group">
                <input tabindex="2" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                       name="login" id="kc-login" type="submit" value="${msg("doSubmit")}"/>
            </div>

            <div class="form-group" style="text-align: center; margin-top: 1rem;">
                <p style="font-size: 13px; color: var(--text-muted);">
                    ${msg("loginOtpExpiry", OTPConfig.OTP_EXPIRY_MINUTES)}
                </p>
            </div>
        </form>

        <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--border);">
            <p style="font-size: 14px; color: var(--text-secondary);">
                ${msg("loginOtpDidNotReceive")}
            </p>
            <form id="kc-otp-resend-form" action="${url.loginAction}" method="post" style="margin-top: 0.75rem;">
                <input type="hidden" name="resend" value="true"/>
                <button type="submit" style="background: none; border: none; color: var(--eco-blue); font-weight: 600; font-size: 14px; cursor: pointer; text-decoration: underline;">
                    ${msg("loginOtpResend")}
                </button>
            </form>
        </div>
    </div>

    <script>
        // Auto-format OTP input
        document.getElementById('otp').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        // Auto-submit when 6 digits entered
        document.getElementById('otp').addEventListener('input', function(e) {
            if (this.value.length === 6) {
                setTimeout(function() {
                    document.getElementById('kc-otp-form').submit();
                }, 300);
            }
        });
    </script>

    <#elseif section = "info">
    </#if>
</@layout.registrationLayout>