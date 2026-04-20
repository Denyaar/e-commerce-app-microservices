<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <span class="kc-logo-text">EcoCash</span>
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
    <div id="kc-form">
        <p class="instruction">${msg("updatePasswordDescription")}</p>
        <form id="kc-passwd-update-form" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username"
                   readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <div class="form-group">
                <label for="password-new" class="${properties.kcLabelClass!}">${msg("passwordNew")}</label>

                <input type="password" id="password-new" name="password-new" class="${properties.kcInputClass!}"
                       autofocus autocomplete="new-password"
                       placeholder="${msg("passwordNew")}"
                       aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                />

                <#if messagesPerField.existsError('password')>
                    <span id="input-error-password" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="form-group">
                <label for="password-confirm" class="${properties.kcLabelClass!}">${msg("passwordConfirm")}</label>

                <input type="password" id="password-confirm" name="password-confirm" class="${properties.kcInputClass!}"
                       autocomplete="new-password"
                       placeholder="${msg("passwordConfirm")}"
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                />

                <#if messagesPerField.existsError('password-confirm')>
                    <span id="input-error-password-confirm" class="${properties.kcInputErrorMessageClass!}" aria-live="polite">
                        ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                    </span>
                </#if>
            </div>

            <div class="form-group" style="margin-top: 1.5rem;">
                <div style="background: rgba(0, 82, 165, 0.15); border: 1px solid rgba(0, 82, 165, 0.3); border-radius: 8px; padding: 12px; font-size: 13px; color: var(--text-accent);">
                    <strong>${msg("passwordRequirements")}</strong>
                    <ul style="margin: 8px 0 0 20px; padding: 0;">
                        <li>${msg("passwordMinLength")}</li>
                        <li>${msg("passwordRequireDigit")}</li>
                        <li>${msg("passwordRequireLowerCase")}</li>
                        <li>${msg("passwordRequireUpperCase")}</li>
                    </ul>
                </div>
            </div>

            <div id="kc-form-buttons" class="form-group">
                <input class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                       type="submit" value="${msg("doSubmit")}" />
            </div>

            <#if isAppInitiatedAction??>
                <div class="form-group" style="text-align: center; margin-top: 1rem;">
                    <a href="${url.loginUrl}" style="font-size: 14px; color: var(--text-muted); text-decoration: none;">
                        ${msg("doCancel")}
                    </a>
                </div>
            </#if>
        </form>
    </div>
    </#if>
</@layout.registrationLayout>