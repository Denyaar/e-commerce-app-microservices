<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        <span class="kc-logo-text">EcoCash</span>
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
    <div id="kc-form">
      <div id="kc-form-wrapper">
        <#if realm.password>
            <form id="kc-form-login" onsubmit="return submitLoginForm();" action="${url.loginAction}" method="post">
                <#if !usernameHidden??>
                    <div class="form-group">
                        <label for="username" class="${properties.kcLabelClass!}">
                            <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                        </label>

                        <input tabindex="1" id="username" class="${properties.kcInputClass!}" name="username" value="${(login.username!'')}" type="text" autofocus autocomplete="username"
                               aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                               placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                        />

                        <#if messagesPerField.existsError('username','password')>
                            <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                            </span>
                        </#if>

                    </div>
                </#if>

                <div class="form-group">
                    <div class="field-header">
                        <label for="password" class="${properties.kcLabelClass!}">${msg("password")}</label>
                        <#if realm.resetPasswordAllowed>
                            <a tabindex="5" class="field-link" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>

                    <input tabindex="2" id="password" class="${properties.kcInputClass!}" name="password" type="password" autocomplete="current-password"
                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                           placeholder="${msg("password")}"
                    />

                    <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                        <span id="input-error" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                                ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                        </span>
                    </#if>

                </div>

                <div class="form-group" style="margin-top: 1.5rem;">
                    <label class="${properties.kcLabelClass!}" style="margin-bottom: 0.75rem; display: block;">${msg("loginOtpDeliveryMethod")}</label>
                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 0.75rem; border: 2px solid #ddd; border-radius: 6px; transition: all 0.2s;">
                            <input type="radio" id="otp-sms" name="otpType" value="sms" checked
                                   style="margin-right: 0.75rem; cursor: pointer; width: 18px; height: 18px; accent-color: #0066cc;">
                            <div style="flex: 1;">
                                <div style="font-weight: 600; margin-bottom: 0.25rem;">${msg("loginOtpSmsOption")}</div>
                                <div style="font-size: 0.875rem; color: #666;">${msg("loginOtpSmsOptionHelp")}</div>
                            </div>
                        </label>
                        <label style="display: flex; align-items: center; cursor: pointer; padding: 0.75rem; border: 2px solid #ddd; border-radius: 6px; transition: all 0.2s;">
                            <input type="radio" id="otp-email" name="otpType" value="email"
                                   style="margin-right: 0.75rem; cursor: pointer; width: 18px; height: 18px; accent-color: #0066cc;">
                            <div style="flex: 1;">
                                <div style="font-weight: 600; margin-bottom: 0.25rem;">${msg("loginOtpEmailOption")}</div>
                                <div style="font-size: 0.875rem; color: #666;">${msg("loginOtpEmailOptionHelp")}</div>
                            </div>
                        </label>
                    </div>
                </div>

                <div class="form-group">
                    <#if realm.rememberMe && !usernameHidden??>
                        <div class="checkbox">
                            <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                            <label for="rememberMe">${msg("rememberMe")}</label>
                        </div>
                    </#if>
                  </div>

                <div id="kc-form-buttons" class="form-group">
                    <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                    <input type="hidden" id="selected-otp-type-hidden" name="selectedOtpTypeHidden" value="email"/>
                    <input tabindex="4" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                </div>
            </form>
        </#if>
        </div>
    </div>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container">
                <div id="kc-registration">
                    <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
                </div>
            </div>
        </#if>
    <#elseif section = "socialProviders" >
        <#if realm.password && social.providers??>
            <div id="kc-social-providers" class="social-providers">
                <hr/>
                <h4>${msg("identity-provider-login-label")}</h4>

                <ul class="social-links">
                    <#list social.providers as p>
                        <li><a id="social-${p.alias}" class="social-link-${p.providerId}" href="${p.loginUrl}">
                                <#if p.iconClasses?has_content>
                                    <i class="${p.iconClasses!}" aria-hidden="true"></i>
                                    <span class="social-text">${p.displayName!}</span>
                                <#else>
                                    <span class="social-text">${p.displayName!}</span>
                                </#if>
                            </a></li>
                    </#list>
                </ul>
            </div>
        </#if>
    </#if>

    <script>
        // Update hidden field when radio selection changes
        document.querySelectorAll('input[name="otpType"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                document.getElementById('selected-otp-type-hidden').value = this.value;
            });
        });

        // Set initial value
        var checkedRadio = document.querySelector('input[name="otpType"]:checked');
        if (checkedRadio) {
            document.getElementById('selected-otp-type-hidden').value = checkedRadio.value;
        }

        function submitLoginForm() {
            // Get selected OTP type
            var otpType = document.querySelector('input[name="otpType"]:checked')?.value || 'email';

            // Update hidden field
            document.getElementById('selected-otp-type-hidden').value = otpType;

            // Store in cookie for OTP authenticator to read
            document.cookie = "selectedOtpType=" + otpType + "; path=/; SameSite=Lax; max-age=300";

            // Store in sessionStorage as backup
            try {
                sessionStorage.setItem('selectedOtpType', otpType);
            } catch(e) {}

            // Disable submit button to prevent double submission
            document.getElementById('kc-login').disabled = true;

            return true;
        }
    </script>

</@layout.registrationLayout>
