<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("loginTitle",(realm.displayName!'Open API'))}</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth">
<div class="background-grid"></div>
<svg class="background-wave" viewBox="0 0 1440 320" preserveAspectRatio="none" aria-hidden="true">
    <path fill="#0052A5" d="M0,96L48,112C96,128,192,160,288,165.3C384,171,480,149,576,133.3C672,117,768,107,864,122.7C960,139,1056,181,1152,181.3C1248,181,1344,139,1392,117.3L1440,96L1440,320L0,320Z"></path>
</svg>

<main class="auth-shell">
    <section class="intro-panel" aria-label="Developer portal introduction">
        <div>
            <div class="brand-lockup" aria-label="EcoCash Developer SandBox">
                <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
            </div>
            <p class="eyebrow">Developer authentication</p>
            <h1>EcoCash Developer Portal</h1>
            <p class="lead">Sign in to manage API credentials, sandbox transactions, whitelisted numbers, and production access requests.</p>
        </div>
        <div class="feature-list">
            <div class="feature"><span class="feature-icon">✓</span><span>Secure Access </span></div>
            <div class="feature"><span class="feature-icon">✓</span><span>Build with EcoCash APIs.</span></div>
            <div class="feature"><span class="feature-icon">✓</span><span>Request Production Access</span></div>
        </div>
    </section>

    <section class="auth-card" aria-label="Sign in form">
        <p class="eyebrow">Welcome To EcoCash Developer Portal</p>
        <h2>Sign in</h2>
        <p class="subtext">Use the username and password sent to your registered email.</p>

        <#if message?has_content>
            <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
        </#if>

        <#if realm.password>
            <form id="kc-form-login" action="${url.loginAction}" method="post" novalidate>
                <div>
                    <label for="username"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
                    <div class="field-wrap">
                        <input id="username" name="username" type="text" autocomplete="username" placeholder="developer@example.com" value="${(login.username!'')}" autofocus required>
                        <span class="field-icon" aria-hidden="true">@</span>
                    </div>
                </div>

                <div>
                    <div class="label-row">
                        <label for="password">${msg("password")}</label>
                        <#if realm.resetPasswordAllowed>
                            <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
                        </#if>
                    </div>
                    <div class="field-wrap">
                        <input id="password" name="password" type="password" autocomplete="current-password" placeholder="${msg("password")}" required>
                        <button class="password-toggle" type="button" aria-label="Show password" title="Show password">◐</button>
                    </div>
                </div>

                <#if realm.rememberMe && !usernameEditDisabled??>
                    <label class="remember" for="rememberMe">
                        <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
                        ${msg("rememberMe")}
                    </label>
                </#if>

                <#if auth.selectedCredential?has_content>
                    <input type="hidden" name="credentialId" value="${auth.selectedCredential}">
                </#if>

                <button class="submit-btn" type="submit">${msg("doLogIn")}</button>
            </form>
        </#if>

        <p class="footer-note">New to the sandbox? Register from the EcoCash Developer Portal.</p>
    </section>
</main>

<script>
    (function () {
        var form = document.getElementById('kc-form-login');
        var password = document.getElementById('password');
        var toggle = document.querySelector('.password-toggle');
        if (!form || !password || !toggle) return;

        toggle.addEventListener('click', function () {
            var isHidden = password.type === 'password';
            password.type = isHidden ? 'text' : 'password';
            toggle.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');
            toggle.setAttribute('title', isHidden ? 'Hide password' : 'Show password');
        });

        form.addEventListener('submit', function () {
            var button = form.querySelector('.submit-btn');
            if (button) {
                button.disabled = true;
                button.textContent = 'Signing in...';
            }
        });
    })();
</script>
</body>
</html>
