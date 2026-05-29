<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">
        <form id="kc-otp-login-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
              method="post">
            <#if otpLogin.userOtpCredentials?size gt 1>
                <div class="${properties.kcFormGroupClass!}">
                    <div class="${properties.kcInputWrapperClass!}">
                        <#list otpLogin.userOtpCredentials as otpCredential>
                            <input id="kc-otp-credential-${otpCredential?index}"
                                   class="${properties.kcLoginOTPListInputClass!}" type="radio"
                                   name="selectedCredentialId" value="${otpCredential.id}"
                                   <#if otpCredential.id == otpLogin.selectedCredentialId>checked="checked"</#if>>
                            <label for="kc-otp-credential-${otpCredential?index}"
                                   class="${properties.kcLoginOTPListClass!}" tabindex="${otpCredential?index}">
                                <span class="${properties.kcLoginOTPListItemHeaderClass!}">
                                    <span class="${properties.kcLoginOTPListItemIconBodyClass!}">
                                      <i class="${properties.kcLoginOTPListItemIconClass!}" aria-hidden="true"></i>
                                    </span>
                                    <span class="${properties.kcLoginOTPListItemTitleClass!}">${otpCredential.userLabel}</span>
                                </span>
                            </label>
                        </#list>
                    </div>
                </div>
            </#if>

            <div class="${properties.kcFormGroupClass!}">

                <div style="margin: auto; width: 50%" class="otp-message">
                    <p>Dear User,</p>
                    <p>Please check your authenticator app for the One-Time Password (OTP) required to complete the
                        authentication process.</p>
                    <p>If you haven't received the OTP, please ensure your authenticator app is properly set up and try
                        again. Make sure the app is open or refresh it to generate a new code.</p>
                    <p>Thank you for using our secure authentication system!</p>
                </div>


                <div class="${properties.kcLabelWrapperClass!}">
                    <label for="otp" class="${properties.kcLabelClass!}">${msg("loginOtpOneTime")}</label>
                </div>

                <div class="${properties.kcInputWrapperClass!}" style="margin-top: 20px;">
                    <input id="otp" name="otp" autocomplete="off" type="text"
                           class="${properties.kcInputClass!} input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"
                           autofocus aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"/>

                    <#if messagesPerField.existsError('totp')>
                        <p style="width:50%;margin:auto;">
                        <span id="input-error-otp-code"
                              class="${properties.kcInputErrorMessageClass!} message-text text-red-600"
                              aria-live="polite">
                        ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                    </span>
                        </p>
                    </#if>
                </div>
            </div>

            <div class="${properties.kcFormGroupClass!} " style="margin-top: 20px;">
                <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                    <div class="${properties.kcFormOptionsWrapperClass!}">
                    </div>
                </div>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input
                            class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!} button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full"
                            name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>
                </div>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>