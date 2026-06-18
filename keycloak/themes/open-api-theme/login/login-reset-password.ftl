<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("emailForgotTitle")} | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
    <#if recaptchaRequired??>
        <script src="https://www.google.com/recaptcha/enterprise.js?render=6Ldh-espAAAAAGMD9FUearLzwA4Xy1qkfj_Ls0LA"></script>
    </#if>
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
    <p class="eyebrow">Account recovery</p>
    <h1>${msg("emailForgotTitle")}</h1>
    <p class="subtext">Enter your username or email address and we will send you instructions to create a new password.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-reset-password-form" action="${url.loginAction}" method="post" novalidate>
        <div>
            <label for="username"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
            <div class="field-wrap">
                <input id="username" name="username" type="text" autocomplete="username" placeholder="developer@example.com" value="${(auth.attemptedUsername!'')}" autofocus required aria-invalid="<#if messagesPerField.existsError('username')>true</#if>">
                <span class="field-icon" aria-hidden="true">@</span>
            </div>
            <#if messagesPerField.existsError('username')>
                <div class="field-error" id="input-error-username" aria-live="polite">${kcSanitize(messagesPerField.get('username'))?no_esc}</div>
            </#if>
        </div>

        <button class="submit-btn" type="submit">Reset Password</button>
    </form>

    <p class="footer-note">Remember your password? <a href="${url.loginUrl}">Login here.</a></p>
</main>

<#if recaptchaRequired??>
    <script>
        (function () {
            var form = document.getElementById('kc-reset-password-form');
            form.addEventListener('submit', function (event) {
                event.preventDefault();
                grecaptcha.enterprise.execute('6Ldh-espAAAAAGMD9FUearLzwA4Xy1qkfj_Ls0LA', {action: 'reset'}).then(function (token) {
                    var recaptchaResponseInput = document.createElement('input');
                    recaptchaResponseInput.setAttribute('type', 'hidden');
                    recaptchaResponseInput.setAttribute('name', 'g-recaptcha-response');
                    recaptchaResponseInput.setAttribute('value', token);
                    form.appendChild(recaptchaResponseInput);
                    form.submit();
                });
            });
        })();
    </script>
</#if>
</body>
</html>
