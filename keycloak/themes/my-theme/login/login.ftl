<#import "template.ftl" as layout>

<@layout.registrationLayout displayInfo=social.displayInfo; section>
    <#if section = "title">
        ${msg("loginTitle",(realm.displayName!''))}
    <#elseif section = "header">
<link href="${url.resourcesPath}/img/favicon.png" rel="icon"/>
    <#elseif section = "form">
        <#if realm.password>
            <div class="text-center">
                <div class="mb-4">
                    <h3 class="mb-1">Developer Portal</h3>
                    <p>Please enter your credentials to sign in!</p>
                </div>
                <div>
                    <#--                                    New Keycloak Login-->
                    <div>
                        <form id="kc-form-login" class="form" onsubmit="return true;"
                              action="${url.loginAction}" method="post">
                            <div class="form-item vertical">
                                <label class="form-label mb-2">User Name</label>
                                <div>
                                    <input id="username"
                                           class="input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"
                                           placeholder="${msg("username")}" type="text"
                                           name="username" tabindex="1">
                                </div>
                            </div>
                            <div class="form-item vertical">
                                <label
                                        class="form-label mb-2">Password</label>
                                <div class="">

                                    <span class="input-wrapper">
                                     <input id="password"
                                            class="input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"
                                            placeholder="${msg("password")}"
                                            type="password"
                                            name="password" tabindex="2">
                                     </span>
                                </div>
                            </div>

                            <div>
                                <#--                                remember me and forgot password-->
                                <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
                                    <div id="kc-form-options">
                                        <#if realm.rememberMe && !usernameHidden??>
                                            <div style="display: flex; align-items: center; width:100% ; margin-top:10px;margin-bottom:10px;">
                                                <label>
                                                    <#if login.rememberMe??>
                                                        <input tabindex="3" class="checkbox" id="rememberMe"
                                                               name="rememberMe" type="checkbox"
                                                               checked> ${msg("rememberMe")}
                                                    <#else>
                                                        <input tabindex="3" class="checkbox" id="rememberMe"
                                                               name="rememberMe" type="checkbox"> ${msg("rememberMe")}
                                                    </#if>
                                                </label>
                                            </div>
                                        </#if>
                                    </div>

                                </div>


                            </div>
                            <input class="button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full"
                                   type="submit" value="${msg("doLogIn")}"
                                   tabindex="3">


                            <div class="${properties.kcFormOptionsWrapperClass!}"
                                 style="margin-top:10px;margin-bottom:10px;">
                                <#if realm.resetPasswordAllowed>
                                    <span><a tabindex="5"
                                             href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a></span>
                                </#if>
                            </div>


                            <div>
                                <p class="copyright">
                                    &copy; ${msg("copyright", "${.now?string('yyyy')}")}
                                </p>
                            </div>


                            <#if recaptchaRequired??>
                            <script>
                                function onSubmit(token) {
                                    // Handle the form submission and reCAPTCHA token
                                    console.log("Submitting Captcha Result");
                                    var form = document.getElementById('kc-form-login');
                                    var recaptchaResponseInput = document.createElement('input');
                                    recaptchaResponseInput.setAttribute('type', 'hidden');
                                    recaptchaResponseInput.setAttribute('name', 'g-recaptcha-response');
                                    recaptchaResponseInput.setAttribute('value', token);
                                    form.appendChild(recaptchaResponseInput);
                                    form.submit();
                                }

                                document.getElementById('kc-form-login').addEventListener('submit', function (event) {
                                    console.log("Submit");
                                    event.preventDefault(); // Prevent the form from submitting immediately
                                    grecaptcha.enterprise.execute('6Ldh-espAAAAAGMD9FUearLzwA4Xy1qkfj_Ls0LA', {action: 'submit'})
                                        .then(function (token) {
                                            console.log("Token " + token)
                                            onSubmit(token);
                                        });

                                });
                            </script>
                            </#if>

                        </form>
                    </div>
                </div>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>