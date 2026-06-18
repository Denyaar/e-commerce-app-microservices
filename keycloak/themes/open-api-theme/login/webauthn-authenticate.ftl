<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="${url.resourcesPath}/js/auth-theme.js"></script>
    <title>${msg("webauthn-login-title")} | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left setup-card">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>${msg("webauthn-login-title")}</h1>
    <p class="subtext">Use your passkey, biometric sensor, or security key to continue securely.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="webauth" action="${url.loginAction}" method="post">
        <input type="hidden" id="clientDataJSON" name="clientDataJSON"/>
        <input type="hidden" id="authenticatorData" name="authenticatorData"/>
        <input type="hidden" id="signature" name="signature"/>
        <input type="hidden" id="credentialId" name="credentialId"/>
        <input type="hidden" id="userHandle" name="userHandle"/>
        <input type="hidden" id="error" name="error"/>
    </form>

    <#if authenticators??>
        <form id="authn_select" class="hidden" aria-hidden="true">
            <#list authenticators.authenticators as authenticator>
                <input type="hidden" name="authn_use_chk" value="${authenticator.credentialId}"/>
            </#list>
        </form>

        <#if shouldDisplayAuthenticators?? && shouldDisplayAuthenticators>
            <div class="passkey-credential-list" aria-label="${msg("webauthn-available-authenticators")}">
                <#if authenticators.authenticators?size gt 1>
                    <p class="passkey-credential-title">${msg("webauthn-available-authenticators")}</p>
                </#if>

                <#list authenticators.authenticators as authenticator>
                    <div class="passkey-credential" id="kc-webauthn-authenticator-item-${authenticator?index}">
                        <span class="passkey-icon" aria-hidden="true">K</span>
                        <div>
                            <div class="passkey-label" id="kc-webauthn-authenticator-label-${authenticator?index}">
                                ${authenticator.label}
                            </div>

                            <#if authenticator.transports?? && authenticator.transports.displayNameProperties?has_content>
                                <div class="passkey-meta" id="kc-webauthn-authenticator-transport-${authenticator?index}">
                                    <#list authenticator.transports.displayNameProperties as nameProperty>
                                        <span>${msg(nameProperty)}</span><#if nameProperty?has_next><span>, </span></#if>
                                    </#list>
                                </div>
                            </#if>

                            <div class="passkey-meta">
                                <span id="kc-webauthn-authenticator-createdlabel-${authenticator?index}">
                                    ${msg("webauthn-createdAt-label")}
                                </span>
                                <span id="kc-webauthn-authenticator-created-${authenticator?index}">
                                    ${authenticator.createdAt}
                                </span>
                            </div>
                        </div>
                    </div>
                </#list>
            </div>
        </#if>
    </#if>

    <div class="action-row" style="margin-top:24px;">
        <button id="authenticateWebAuthnButton" class="submit-btn" type="button" autofocus>
            ${msg("webauthn-doAuthenticate")}
        </button>
    </div>

    <#if realm.registrationAllowed && !registrationDisabled??>
        <p class="footer-note">${msg("noAccount")} <a href="${url.registrationUrl}">${msg("doRegister")}</a></p>
    </#if>
</main>

<script>
<#outputformat "JavaScript">
(function () {
    var abortController;
    var b64url = {
        stringify: function(bytes, opts) {
            var str = btoa(String.fromCharCode.apply(null, Array.from(bytes)))
                .replace(/\+/g, "-").replace(/\//g, "_");
            return (opts && opts.pad === false) ? str.replace(/=+$/, "") : str;
        },
        parse: function(str, opts) {
            if (opts && opts.loose) str = str.replace(/-/g, "+").replace(/_/g, "/");
            while (str.length % 4) str += "=";
            var raw = atob(str);
            var out = new Uint8Array(raw.length);
            for (var i = 0; i < raw.length; i++) out[i] = raw.charCodeAt(i);
            return out;
        }
    };

    function signal() {
        if (abortController) {
            var abortError = new Error("Cancelling pending WebAuthn call");
            abortError.name = "AbortError";
            abortController.abort(abortError);
        }
        abortController = new AbortController();
        return abortController.signal;
    }

    function returnSuccess(result) {
        document.getElementById("clientDataJSON").value = b64url.stringify(new Uint8Array(result.response.clientDataJSON), {pad: false});
        document.getElementById("authenticatorData").value = b64url.stringify(new Uint8Array(result.response.authenticatorData), {pad: false});
        document.getElementById("signature").value = b64url.stringify(new Uint8Array(result.response.signature), {pad: false});
        document.getElementById("credentialId").value = result.id;
        if (result.response.userHandle) {
            document.getElementById("userHandle").value = b64url.stringify(new Uint8Array(result.response.userHandle), {pad: false});
        }
        document.getElementById("webauth").requestSubmit();
    }

    function returnFailure(err) {
        document.getElementById("error").value = err;
        document.getElementById("webauth").requestSubmit();
    }

    function getAllowCredentials() {
        var allowCredentials = [];
        var form = document.forms.authn_select;
        var authnUse = form ? form.authn_use_chk : undefined;
        if (authnUse !== undefined) {
            if (authnUse.length === undefined) {
                allowCredentials.push({id: b64url.parse(authnUse.value, {loose: true}), type: "public-key"});
            } else {
                Array.prototype.forEach.call(authnUse, function (entry) {
                    allowCredentials.push({id: b64url.parse(entry.value, {loose: true}), type: "public-key"});
                });
            }
        }
        return allowCredentials;
    }

    async function authenticateByWebAuthn(input) {
        if (!window.PublicKeyCredential) {
            returnFailure(input.errmsg);
            return;
        }

        var publicKey = {
            rpId: input.rpId,
            challenge: b64url.parse(input.challenge, {loose: true})
        };

        if (input.createTimeout !== 0) publicKey.timeout = input.createTimeout * 1000;
        if (input.isUserIdentified) {
            var allowCredentials = getAllowCredentials();
            if (allowCredentials.length) publicKey.allowCredentials = allowCredentials;
        }
        if (input.userVerification !== "not specified") publicKey.userVerification = input.userVerification;

        try {
            var result = await navigator.credentials.get({publicKey: publicKey, signal: signal()});
            returnSuccess(result);
        } catch (error) {
            returnFailure(error);
        }
    }

    document.getElementById("authenticateWebAuthnButton").addEventListener("click", function () {
        authenticateByWebAuthn({
            isUserIdentified: ${isUserIdentified},
            challenge: ${challenge?c},
            userVerification: ${userVerification?c},
            rpId: ${rpId?c},
            createTimeout: ${createTimeout?c},
            errmsg: ${msg("webauthn-unsupported-browser-text")?c}
        });
    }, {once: true});
})();
</#outputformat>
</script>
</body>
</html>
