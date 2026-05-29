<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register | EcoCash Developer SandBox</title>
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

    <p class="eyebrow">Developer access</p>
    <h1>Register</h1>
    <p class="subtext">Create an account for the EcoCash Developer SandBox.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-register-form" action="${url.registrationAction}" method="post" novalidate>
        <div class="form-grid">
            <div>
                <label for="firstName">${msg("firstName")}</label>
                <input type="text" id="firstName" name="firstName" value="${(register.formData.firstName!'')}" autocomplete="given-name">
                <#if messagesPerField.existsError('firstName')>
                    <div class="field-error">${kcSanitize(messagesPerField.get('firstName'))?no_esc}</div>
                </#if>
            </div>
            <div>
                <label for="lastName">${msg("lastName")}</label>
                <input type="text" id="lastName" name="lastName" value="${(register.formData.lastName!'')}" autocomplete="family-name">
                <#if messagesPerField.existsError('lastName')>
                    <div class="field-error">${kcSanitize(messagesPerField.get('lastName'))?no_esc}</div>
                </#if>
            </div>
        </div>

        <div>
            <label for="email">${msg("email")}</label>
            <input type="text" id="email" name="email" value="${(register.formData.email!'')}" autocomplete="email">
            <#if messagesPerField.existsError('email')>
                <div class="field-error">${kcSanitize(messagesPerField.get('email'))?no_esc}</div>
            </#if>
        </div>

        <#if !realm.registrationEmailAsUsername>
            <div>
                <label for="username">${msg("username")}</label>
                <input type="text" id="username" name="username" value="${(register.formData.username!'')}" autocomplete="username">
                <#if messagesPerField.existsError('username')>
                    <div class="field-error">${kcSanitize(messagesPerField.get('username'))?no_esc}</div>
                </#if>
            </div>
        </#if>

        <#if passwordRequired>
            <div>
                <label for="password">${msg("password")}</label>
                <input type="password" id="password" name="password" autocomplete="new-password">
                <#if messagesPerField.existsError('password')>
                    <div class="field-error">${kcSanitize(messagesPerField.get('password'))?no_esc}</div>
                </#if>
            </div>

            <div>
                <label for="password-confirm">${msg("passwordConfirm")}</label>
                <input type="password" id="password-confirm" name="password-confirm" autocomplete="new-password">
                <#if messagesPerField.existsError('password-confirm')>
                    <div class="field-error">${kcSanitize(messagesPerField.get('password-confirm'))?no_esc}</div>
                </#if>
            </div>
        </#if>

        <#if recaptchaRequired??>
            <div class="g-recaptcha" data-size="compact" data-sitekey="${recaptchaSiteKey}"></div>
        </#if>

        <button class="submit-btn" id="RegisterButton" type="submit">${msg("doRegister")}</button>
    </form>

    <p class="footer-note"><a href="${url.loginUrl}">${kcSanitize(msg("backToLogin"))?no_esc}</a></p>
</main>
</body>
</html>
