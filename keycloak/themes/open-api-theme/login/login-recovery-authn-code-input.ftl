<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Recovery Code | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("auth-recovery-code-header")}</h1>
    <p class="subtext" style="margin-top:8px;">${msg("auth-recovery-code-prompt", recoveryAuthnCodesInputBean.codeNumber?c)}</p>

    <#if message?has_content && !messagesPerField.existsError('recoveryCodeInput')>
        <div class="message-banner message-${message.type}" role="alert" style="margin-top:16px;">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-recovery-code-login-form" action="${url.loginAction}" method="post"
          onsubmit="this.querySelector('button[type=submit]').disabled = true; return true;"
          style="margin-top:24px;">
        <div>
            <label for="recoveryCodeInput">Recovery code ${recoveryAuthnCodesInputBean.codeNumber?c}</label>
            <input id="recoveryCodeInput"
                   name="recoveryCodeInput"
                   type="text"
                   autocomplete="off"
                   autofocus
                   placeholder="xxxx-xxxx-xxxx"
                   style="margin-top:6px;"
                   aria-invalid="<#if messagesPerField.existsError('recoveryCodeInput')>true</#if>">
            <#if messagesPerField.existsError('recoveryCodeInput')>
                <div class="field-error" style="margin-top:6px;">${kcSanitize(messagesPerField.get('recoveryCodeInput'))?no_esc}</div>
            </#if>
        </div>

        <div class="action-row" style="margin-top:24px;">
            <button class="submit-btn" type="submit">Verify</button>
        </div>
    </form>
</main>
</body>
</html>
