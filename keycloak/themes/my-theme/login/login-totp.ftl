<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        ${msg("doLogIn")}
    <#elseif section = "form">



        <div>
            <form id="kc-form-login" class="form" onsubmit="return true;"
                  action="${url.loginAction}" method="post">
                <div class="form-item vertical">
                    <label class="form-label mb-2">${msg("loginTotpOneTime")}</label>
                    <div>
                        <input id="totp" name="totp"
                               class="input input-md h-11 focus:ring-indigo-600 focus-within:ring-indigo-600 focus-within:border-indigo-600 focus:border-indigo-600"
                               type="text"
                             tabindex="1">
                    </div>
                </div>

                <div>
                    <div class="${properties.kcFormGroupClass!}">
                        <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
                            <div class="${properties.kcFormOptionsWrapperClass!}">
                            </div>
                        </div>

                        <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                            <div class="${properties.kcFormButtonsWrapperClass!}">
                                <input class="button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full" name="login" id="kc-login" type="submit" value="${msg("doLogInButton")}"/>
                                <input class="button bg-indigo-600 hover:bg-indigo-500 active:bg-indigo-700 text-white radius-round h-11 px-8 py-2 w-full" name="cancel" id="kc-cancel" type="submit" value="${msg("doCancel")}"/>
                            </div>
                        </div>
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
