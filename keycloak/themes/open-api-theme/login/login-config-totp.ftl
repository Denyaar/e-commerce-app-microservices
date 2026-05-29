<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("loginTotpTitle")} | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<div class="background-grid"></div>
<svg class="background-wave" viewBox="0 0 1440 320" preserveAspectRatio="none" aria-hidden="true">
    <path fill="#0052A5" d="M0,96L48,112C96,128,192,160,288,165.3C384,171,480,149,576,133.3C672,117,768,107,864,122.7C960,139,1056,181,1152,181.3C1248,181,1344,139,1392,117.3L1440,96L1440,320L0,320Z"></path>
</svg>

<main class="verify-card text-left setup-card">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("loginTotpTitle")}</h1>
    <p class="subtext">${msg("configureTotpMessage")}</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <div class="setup-steps">
        <div class="setup-step">
            <span class="step-index">1</span>
            <p>${msg("loginTotpStep1")}</p>
        </div>
        <div class="setup-step">
            <span class="step-index">2</span>
            <p>${msg("loginTotpStep2")}</p>
        </div>
    </div>

    <div class="qr-panel">
        <img id="kc-totp-secret-qr-code" src="data:image/png;base64, ${totp.totpSecretQrCode}" alt="${msg("loginTotpScanBarcode")}">
        <p><a href="${totp.manualUrl}" id="mode-manual">${msg("loginTotpUnableToScan")}</a></p>
    </div>

    <form id="kc-totp-settings-form" class="otp-form" action="${url.loginAction}" method="post" novalidate>
        <div>
            <label for="totp">${msg("loginTotpOneTime")}</label>
            <input id="totp"
                   name="totp"
                   type="text"
                   inputmode="numeric"
                   autocomplete="one-time-code"
                   placeholder="${msg("loginTotpOneTime")}"
                   required
                   aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
            <#if messagesPerField.existsError('totp')>
                <div class="field-error" id="input-error-otp-code" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('totp'))?no_esc}
                </div>
            </#if>
        </div>

        <div>
            <label for="userLabel">Device name</label>
            <input id="userLabel"
                   name="userLabel"
                   type="text"
                   placeholder="Device name"
                   aria-invalid="<#if messagesPerField.existsError('userLabel')>true</#if>"
                   <#if totp.otpCredentials?has_content>required</#if>>
            <#if messagesPerField.existsError('userLabel')>
                <div class="field-error" id="input-error-otp-label" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('userLabel'))?no_esc}
                </div>
            </#if>
        </div>

        <label class="remember" for="logout-sessions">
            <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked>
            Log out from other devices
        </label>

        <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}">

        <div class="action-row">
            <button class="submit-btn" id="saveTOTPBtn" type="submit">${msg("doSubmit")}</button>
            <#if isAppInitiatedAction??>
                <button class="secondary-btn" id="cancelTOTPBtn" name="cancel-aia" value="true" type="submit">${msg("doCancel")}</button>
            </#if>
        </div>
    </form>
</main>
</body>
</html>
