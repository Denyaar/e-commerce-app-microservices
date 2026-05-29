<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcFormGroupClass!}">
                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="username"
                           class="${properties.kcLabelClass!} form-label mb-2"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                </div>
                <div class="${properties.kcInputWrapperClass!}">
                    <input type="text" id="username" name="username" class="${properties.kcInputClass!}
                    input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"
                           autofocus value="${(auth.attemptedUsername!'')}" aria-invalid="
                    <#if messagesPerField.existsError('username')>true</#if>"/>
                    <#if messagesPerField.existsError('username')>
                        <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}"
                              aria-live="polite">
                                    ${kcSanitize(messagesPerField.get('username'))?no_esc}
                        </span>
                    </#if>
                </div>
            </div>
            <div style="margin-top: 10px;margin-bottom: 10px;" class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                        <span><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></span>
                    </div>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}  button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full"
                           type="submit" value="${msg("doSubmit")}"/>
                </div>

                <#if recaptchaRequired??>
                    <script>
                        function onSubmit(token) {
                            // Handle the form submission and reCAPTCHA token
                            console.log("Submitting Captcha Result");
                            var form = document.getElementById('kc-reset-password-form');
                            var recaptchaResponseInput = document.createElement('input');
                            recaptchaResponseInput.setAttribute('type', 'hidden');
                            recaptchaResponseInput.setAttribute('name', 'g-recaptcha-response');
                            recaptchaResponseInput.setAttribute('value', token);
                            form.appendChild(recaptchaResponseInput);
                            form.submit();
                        }

                        document.getElementById('kc-reset-password-form').addEventListener('submit', function (event) {
                            console.log("Submit");
                            event.preventDefault(); // Prevent the form from submitting immediately
                            grecaptcha.enterprise.execute('6Ldh-espAAAAAGMD9FUearLzwA4Xy1qkfj_Ls0LA', {action: 'reset'})
                                .then(function (token) {
                                    console.log("Token " + token)
                                    onSubmit(token);
                                });

                        });
                    </script>
                </#if>

            </div>
        </form>
    <#elseif section = "info" >
        <#if realm.duplicateEmailsAllowed>
            ${msg("emailInstructionUsername")}
        <#else>
            ${msg("emailInstruction")}
        </#if>
    </#if>
</@layout.registrationLayout>