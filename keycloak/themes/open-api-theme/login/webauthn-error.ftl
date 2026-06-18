<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="${url.resourcesPath}/js/auth-theme.js"></script>
    <title>Passkey Error | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("webauthn-error-title")}</h1>
    <p class="subtext" style="margin-top:8px;">${msg("webauthn-error-registration")}</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert" style="margin-top:16px;">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <script type="text/javascript">
        <#outputformat "JavaScript">
        function refreshPage() {
            document.getElementById('isSetRetry').value = 'retry';
            document.getElementById('executionValue').value = ${execution?c};
            document.getElementById('kc-error-credential-form').requestSubmit();
        }
        </#outputformat>
    </script>

    <form id="kc-error-credential-form" action="${url.loginAction}" method="post" style="margin-top:28px;">
        <input type="hidden" id="executionValue" name="authenticationExecution"/>
        <input type="hidden" id="isSetRetry" name="isSetRetry"/>

        <div class="action-row">
            <button class="submit-btn" id="kc-try-again" type="button" onclick="refreshPage()">Try again</button>
        </div>
    </form>

    <#if isAppInitiatedAction??>
        <form action="${url.loginAction}" id="kc-webauthn-settings-form" method="post" style="margin-top:10px;">
            <button class="secondary-btn" name="cancel-aia" value="true" type="submit">Cancel</button>
        </form>
    </#if>
</main>
</body>
</html>
