<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('totp'); section>
    <#if section="header">
        ${msg("doLogIn")}
    <#elseif section="form">

        <div>
            <form id="kc-totp-login-form" class="form" onsubmit="return true;" action="${url.loginAction}"
                  method="post">
                <div class="form-item vertical">
                    <label class="form-label mb-2">${msg("loginTotpOneTime")}</label>
                    <div>
                        <input id="totp" name="totp"
                               class="input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"

                               autofocus aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>"

                               type="text"
                               tabindex="1">

                        <#--                    needs styling-->
                        <#if messagesPerField.existsError('totp')>
                            <span id="input-error-otp-code" class="message-text text-red-600"
                                  aria-live="polite">
                        ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                    </span>
                        </#if>
                    </div>

                </div>

                <div>
                    <div class="${properties.kcFormGroupClass!}">
                        <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                            <div class="${properties.kcFormOptionsWrapperClass!}">
                            </div>
                        </div>


                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <input
                                    class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                                    name="login" id="kc-login" type="submit" value="${msg("doLogIn")}" />
                        </div>

<#--                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">-->
<#--                            <div class="${properties.kcFormButtonsWrapperClass!}">-->
<#--                                <input-->
<#--                                        class="button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full"-->
<#--                                        name="login" id="kc-login" type="submit" value="${msg("doLogIn")}"/>-->
<#--                            </div>-->
<#--                        </div>-->
                    </div>
                </div>
                <div>
                    <p class="copyright">
                        &copy; ${msg("copyright", "${.now?string('yyyy')}")}
                    </p>
                </div>
            </form>
        </div>


    </#if>
</@layout.registrationLayout>