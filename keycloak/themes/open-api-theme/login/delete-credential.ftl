<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Delete Credential | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("deleteCredentialTitle", credentialLabel)}</h1>
    <p class="subtext" style="margin-top:8px;">${msg("deleteCredentialMessage", credentialLabel)}</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert" style="margin-top:16px;">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form action="${url.loginAction}" method="POST" style="margin-top:28px;">
        <div class="action-row">
            <button class="submit-btn" name="accept" id="kc-accept" type="submit">Confirm deletion</button>
            <button class="secondary-btn" name="cancel-aia" id="kc-decline" value="true" type="submit">Cancel</button>
        </div>
    </form>
</main>
</body>
</html>
