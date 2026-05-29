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

<main class="verify-card">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Two-step verification</p>
    <h1>Enter your 6 digit PIN</h1>
    <p class="subtext">Enter the one-time password from your authenticator app to complete sign in.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="kc-otp-login-form" class="otp-form" action="${url.loginAction}" method="post" novalidate>
        <#if otpLogin.userOtpCredentials?has_content && otpLogin.userOtpCredentials?size gt 1>
            <fieldset class="otp-methods">
                <legend>Authenticator</legend>
                <#list otpLogin.userOtpCredentials as otpCredential>
                    <label class="otp-method" for="kc-otp-credential-${otpCredential?index}">
                        <input id="kc-otp-credential-${otpCredential?index}"
                               type="radio"
                               name="selectedCredentialId"
                               value="${otpCredential.id}"
                               <#if otpCredential.id == otpLogin.selectedCredentialId>checked</#if>>
                        <span>${otpCredential.userLabel}</span>
                    </label>
                </#list>
            </fieldset>
        </#if>

        <div id="otp-error" class="message-banner message-error hidden" role="alert">Enter the complete 6 digit PIN to continue.</div>
        <div class="otp-inputs" aria-label="Six digit verification PIN">
            <input type="text" inputmode="numeric" autocomplete="one-time-code" maxlength="1" aria-label="Digit 1">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 2">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 3">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 4">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 5">
            <input type="text" inputmode="numeric" maxlength="1" aria-label="Digit 6">
        </div>
        <input id="otp" name="otp" type="hidden" aria-invalid="<#if messagesPerField.existsError('totp')>true</#if>">
        <#if messagesPerField.existsError('totp')>
            <div class="field-error" aria-live="polite">${kcSanitize(messagesPerField.get('totp'))?no_esc}</div>
        </#if>

        <button class="submit-btn" type="submit">Verify account</button>
    </form>

    <div class="footer-actions">
        <a href="${url.loginRestartFlowUrl}">Back to sign in</a>
    </div>
</main>

<script>
    (function () {
        var form = document.getElementById('kc-otp-login-form');
        var hiddenOtp = document.getElementById('otp');
        var error = document.getElementById('otp-error');
        var inputs = Array.prototype.slice.call(document.querySelectorAll('.otp-inputs input'));

        function updateHiddenValue() {
            hiddenOtp.value = inputs.map(function (input) { return input.value; }).join('');
        }

        inputs.forEach(function (input, index) {
            input.addEventListener('input', function () {
                input.value = input.value.replace(/\D/g, '').slice(0, 1);
                updateHiddenValue();
                error.classList.add('hidden');
                if (input.value && inputs[index + 1]) inputs[index + 1].focus();
            });

            input.addEventListener('keydown', function (event) {
                if (event.key === 'Backspace' && !input.value && inputs[index - 1]) inputs[index - 1].focus();
            });

            input.addEventListener('paste', function (event) {
                var pasted = (event.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '').slice(0, 6);
                if (!pasted) return;
                event.preventDefault();
                inputs.forEach(function (field, fieldIndex) { field.value = pasted[fieldIndex] || ''; });
                updateHiddenValue();
                inputs[Math.min(pasted.length, 6) - 1].focus();
            });
        });

        form.addEventListener('submit', function (event) {
            updateHiddenValue();
            if (!/^\d{6}$/.test(hiddenOtp.value)) {
                event.preventDefault();
                error.classList.remove('hidden');
                (inputs.find(function (input) { return !input.value; }) || inputs[0]).focus();
                return;
            }
            form.querySelector('.submit-btn').disabled = true;
            form.querySelector('.submit-btn').textContent = 'Verifying...';
        });

        if (inputs[0]) inputs[0].focus();
    })();
</script>
</body>
</html>