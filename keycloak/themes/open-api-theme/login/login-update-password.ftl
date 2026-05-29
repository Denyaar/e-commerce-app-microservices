<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("updatePasswordTitle")} | EcoCash Developer SandBox</title>
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

    <p class="eyebrow">Account security</p>
    <h1>${msg("updatePasswordTitle")}</h1>
    <p class="subtext">Choose a new password for your EcoCash Developer SandBox account.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-passwd-update-form" action="${url.loginAction}" method="post" novalidate>
        <div>
            <label for="password-new">${msg("passwordNew")}</label>
            <div class="field-wrap">
                <input id="password-new"
                       name="password-new"
                       type="password"
                       autocomplete="new-password"
                       placeholder="${msg("passwordNew")}"
                       required
                       aria-invalid="<#if messagesPerField.existsError('password')>true</#if>">
                <button class="password-toggle" type="button" data-target="password-new" aria-label="Show password" title="Show password">◐</button>
            </div>
            <#if messagesPerField.existsError('password')>
                <div class="field-error" id="input-error-password" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('password'))?no_esc}
                </div>
            </#if>
        </div>

        <div>
            <label for="password-confirm">${msg("passwordConfirm")}</label>
            <div class="field-wrap">
                <input id="password-confirm"
                       name="password-confirm"
                       type="password"
                       autocomplete="new-password"
                       placeholder="${msg("passwordConfirm")}"
                       required
                       aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>">
                <button class="password-toggle" type="button" data-target="password-confirm" aria-label="Show password" title="Show password">◐</button>
            </div>
            <#if messagesPerField.existsError('password-confirm')>
                <div class="field-error" id="input-error-password-confirm" aria-live="polite">
                    ${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}
                </div>
            </#if>
        </div>

        <div class="action-row">
            <button class="submit-btn" type="submit">${msg("doSubmit")}</button>
            <#if isAppInitiatedAction??>
                <button class="secondary-btn" type="submit" name="cancel-aia" value="true">${msg("doCancel")}</button>
            </#if>
        </div>
    </form>
</main>

<script>
    (function () {
        Array.prototype.slice.call(document.querySelectorAll('.password-toggle')).forEach(function (toggle) {
            toggle.addEventListener('click', function () {
                var input = document.getElementById(toggle.getAttribute('data-target'));
                if (!input) return;
                var hidden = input.type === 'password';
                input.type = hidden ? 'text' : 'password';
                toggle.setAttribute('aria-label', hidden ? 'Hide password' : 'Show password');
                toggle.setAttribute('title', hidden ? 'Hide password' : 'Show password');
            });
        });
    })();
</script>
</body>
</html>
