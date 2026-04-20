<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true displayMessage=!messagesPerField.existsError('username'); section>
    <#if section = "header">
        <span class="kc-logo-text">EcoCash</span>
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
    <div id="kc-form">
        <p class="instruction">${msg("emailInstruction")}</p>
        <form id="kc-reset-password-form" action="${url.loginAction}" method="post">
            <div class="form-group">
                <label for="username" class="${properties.kcLabelClass!}">
                    <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                </label>

                <input type="text" id="username" name="username" class="${properties.kcInputClass!}"
                       autofocus autocomplete="username"
                       value="${(auth.attemptedUsername!'')}"
                       placeholder="<#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>"
                       aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                />

                <#if messagesPerField.existsError('username')>
                    <span id="input-error-username" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('username'))?no_esc}
                    </span>
                </#if>
            </div>

            <div id="kc-form-buttons" class="form-group">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                       type="submit" value="${msg("doSubmit")}"/>
            </div>

            <div class="form-group" style="text-align: center; margin-top: 1rem;">
                <a href="${url.loginUrl}" style="font-size: 14px; color: var(--eco-blue); font-weight: 600; text-decoration: none;">
                    « ${msg("backToLogin")}
                </a>
            </div>
        </form>
    </div>
    <#elseif section = "info" >
        <#if realm.duplicateEmailsAllowed>
            ${msg("emailInstructionUsername")}
        <#else>
            ${msg("emailInstruction")}
        </#if>
    </#if>
</@layout.registrationLayout>