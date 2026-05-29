<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Confirm logout | EcoCash Developer SandBox</title>
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

    <p class="eyebrow">Session</p>
    <h1>Confirm logout</h1>
    <p class="subtext">${msg("logoutConfirmHeader")}</p>

    <form class="otp-form" action="${url.logoutConfirmAction}" method="post">
        <input type="hidden" name="session_code" value="${logoutConfirm.code}">
        <div class="action-row">
            <button class="submit-btn" name="confirmLogout" id="kc-logout" type="submit">Log out</button>
            <button class="secondary-btn" name="cancelLogout" id="kc-logout-go-back" type="button" onclick="history.back()">${msg("doLogoutGoBack")}</button>
        </div>
    </form>

    <#if !logoutConfirm.skipLink && (client.baseUrl)?has_content>
        <p class="footer-note"><a href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a></p>
    </#if>
</main>
</body>
</html>
