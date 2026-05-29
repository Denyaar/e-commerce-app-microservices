<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>OTP Authentication | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<div class="background-grid"></div>
<svg class="background-wave" viewBox="0 0 1440 320" preserveAspectRatio="none" aria-hidden="true">
    <path fill="#0052A5" d="M0,96L48,112C96,128,192,160,288,165.3C384,171,480,149,576,133.3C672,117,768,107,864,122.7C960,139,1056,181,1152,181.3C1248,181,1344,139,1392,117.3L1440,96L1440,320L0,320Z"></path>
</svg>

<main class="verify-card text-left">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Two-step verification</p>
    <h1>OTP Authentication</h1>
    <p class="subtext">Please check your authenticator app for the one-time password required to complete sign in.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-form-login" class="otp-form" action="${url.loginAction}" method="post" novalidate>
        <div>
            <label for="totp">${msg("loginTotpOneTime")}</label>
            <div class="field-wrap">
                <input id="totp"
                       name="totp"
                       type="text"
                       inputmode="numeric"
                       autocomplete="one-time-code"
                       placeholder="One-time code"
                       autofocus
                       required
                       aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
                <span class="field-icon" aria-hidden="true">#</span>
            </div>
            <#if messagesPerField.existsError('totp')>
                <div class="field-error" id="input-error-otp-code" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                </div>
            </#if>
        </div>

        <div class="action-row">
            <button class="submit-btn" name="login" id="kc-login" type="submit">${msg("doLogIn")}</button>
            <#if isAppInitiatedAction??>
                <button class="secondary-btn" name="cancel-aia" value="true" type="submit">${msg("doCancel")}</button>
            </#if>
        </div>
    </form>

    <p class="footer-note"><a href="${url.loginUrl}">Back to sign in</a></p>
</main>
</body>
</html>
