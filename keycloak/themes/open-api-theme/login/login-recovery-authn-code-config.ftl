<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${msg("recovery-code-config-header")} | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
    <style>
        .recovery-codes-list {
            margin: 20px 0;
            padding: 16px 20px;
            background: #F9FAFB;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 6px 24px;
            list-style: none;
            counter-reset: code-counter;
        }
        .recovery-codes-list li {
            font-family: 'Courier New', Courier, monospace;
            font-size: 13.5px;
            color: #1F2937;
            font-weight: 600;
            counter-increment: code-counter;
        }
        .recovery-codes-list li::before {
            content: counter(code-counter) ". ";
            color: #9CA3AF;
            font-weight: 400;
        }
        .code-actions { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px; }
        .code-action-btn {
            border: 1px solid #D1D5DB;
            border-radius: 8px;
            background: #fff;
            color: #1F2937;
            font-size: 13px;
            font-weight: 600;
            padding: 6px 14px;
            cursor: pointer;
        }
        .code-action-btn:hover { background: #F3F4F6; }
        .warning-box {
            background: #FFFBEB;
            border: 1px solid #FCD34D;
            border-radius: 8px;
            padding: 12px 16px;
            margin: 16px 0;
            color: #92400E;
            font-size: 14px;
        }
        .warning-box strong { display: block; margin-bottom: 4px; }
    </style>
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left setup-card" style="max-width:640px;">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("recovery-code-config-header")}</h1>

    <div class="warning-box">
        <strong>${msg("recovery-code-config-warning-title")}</strong>
        ${msg("recovery-code-config-warning-message")}
    </div>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <ol id="kc-recovery-codes-list" class="recovery-codes-list">
        <#list recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesList as code>
            <li>${code[0..3]}-${code[4..7]}-${code[8..]}</li>
        </#list>
    </ol>

    <div class="code-actions">
        <button class="code-action-btn" type="button" onclick="printRecoveryCodes()">Print</button>
        <button class="code-action-btn" type="button" onclick="downloadRecoveryCodes()">Download</button>
        <button class="code-action-btn" type="button" onclick="copyRecoveryCodes()">Copy</button>
    </div>

    <form action="${url.loginAction}" id="kc-recovery-codes-settings-form" method="post">
        <input type="hidden" name="generatedRecoveryAuthnCodes" value="${recoveryAuthnCodesConfigBean.generatedRecoveryAuthnCodesAsString}"/>
        <input type="hidden" name="generatedAt" value="${recoveryAuthnCodesConfigBean.generatedAt?c}"/>
        <input type="hidden" id="userLabel" name="userLabel" value="${msg("recovery-codes-label-default")}"/>

        <label class="remember" style="margin-bottom:12px;display:flex;gap:9px;">
            <input type="checkbox" id="kcRecoveryCodesConfirmationCheck" name="kcRecoveryCodesConfirmationCheck"
                   onchange="document.getElementById('saveRecoveryAuthnCodesBtn').disabled = !this.checked;">
            ${msg("recovery-codes-confirmation-message")}
        </label>

        <label class="remember" style="margin-bottom:24px;display:flex;gap:9px;">
            <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked>
            Sign out from other devices
        </label>

        <div class="action-row">
            <input type="submit" class="submit-btn" id="saveRecoveryAuthnCodesBtn"
                   value="${msg("recovery-codes-action-complete")}" disabled/>
            <#if isAppInitiatedAction??>
                <button type="submit" class="secondary-btn" id="cancelRecoveryAuthnCodesBtn"
                        name="cancel-aia" value="true">${msg("recovery-codes-action-cancel")}</button>
            </#if>
        </div>
    </form>

    <script>
        function getCodeText() {
            var items = document.querySelectorAll('#kc-recovery-codes-list li');
            var text = '';
            for (var i = 0; i < items.length; i++) {
                text += (i + 1) + '. ' + items[i].textContent.trim() + '\n';
            }
            return text;
        }

        function copyRecoveryCodes() {
            var text = getCodeText();
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text);
            } else {
                var ta = document.createElement('textarea');
                ta.value = text;
                document.body.appendChild(ta);
                ta.select();
                document.execCommand('copy');
                document.body.removeChild(ta);
            }
        }

        function downloadRecoveryCodes() {
            var a = document.createElement('a');
            a.href = 'data:text/plain;charset=utf-8,' + encodeURIComponent(getCodeText());
            a.download = 'recovery-codes.txt';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
        }

        function printRecoveryCodes() {
            var w = window.open();
            var codes = document.getElementById('kc-recovery-codes-list').outerHTML;
            w.document.write('<html><body style="font-family:monospace;padding:24px"><h2>Recovery Codes</h2>' + codes + '</body></html>');
            w.print();
            w.close();
        }
    </script>
</main>
</body>
</html>
