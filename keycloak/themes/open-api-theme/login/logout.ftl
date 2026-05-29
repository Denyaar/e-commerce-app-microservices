<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Logging out | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
    <style>
        .logout-spinner {
            width: 36px;
            height: 36px;
            border: 3px solid rgba(255,255,255,0.1);
            border-top-color: var(--eco-blue);
            border-radius: 50%;
            animation: spin 0.8s linear infinite;
            margin: 28px auto 0;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body class="open-api-auth compact-auth">
<div class="background-grid"></div>
<svg class="background-wave" viewBox="0 0 1440 320" preserveAspectRatio="none" aria-hidden="true">
    <path fill="#0052A5" d="M0,96L48,112C96,128,192,160,288,165.3C384,171,480,149,576,133.3C672,117,768,107,864,122.7C960,139,1056,181,1152,181.3C1248,181,1344,139,1392,117.3L1440,96L1440,320L0,320Z"></path>
</svg>

<main class="verify-card">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>
    <p class="eyebrow">Session</p>
    <h1>Logging out</h1>
    <p class="subtext">Please wait while we securely sign you out.</p>
    <div class="logout-spinner" aria-hidden="true"></div>
</main>

<form id="kc-logout-form" action="${url.logoutConfirmAction!url.loginUrl}" method="post" style="display:none">
    <input type="hidden" name="confirmLogout" value="${msg('doLogout')}">
</form>
<script>
    document.getElementById('kc-logout-form').submit();
</script>
</body>
</html>