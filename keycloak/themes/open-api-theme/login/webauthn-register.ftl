<!doctype html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="${url.resourcesPath}/js/auth-theme.js"></script>
    <title>Register a Passkey | EcoCash Developer SandBox</title>
    <link href="${url.resourcesPath}/css/open-api-auth.css" rel="stylesheet">
</head>
<body class="open-api-auth compact-auth">
<main class="verify-card text-left setup-card">
    <div class="brand-lockup">
        <img src="${url.resourcesPath}/img/ecocash-logo.png" alt="EcoCash" class="brand-logo">
    </div>

    <p class="eyebrow">Account security</p>
    <h1>Register a Passkey</h1>
    <p class="subtext">Your browser will prompt you to use your device's biometric sensor or security key to create a passkey.</p>

    <#if message?has_content>
        <div class="message-banner message-${message.type}" role="alert">${kcSanitize(message.summary)?no_esc}</div>
    </#if>

    <form id="register" action="${url.loginAction}" method="post" style="margin-top:24px;">
        <input type="hidden" id="clientDataJSON"        name="clientDataJSON"/>
        <input type="hidden" id="attestationObject"     name="attestationObject"/>
        <input type="hidden" id="publicKeyCredentialId" name="publicKeyCredentialId"/>
        <input type="hidden" id="authenticatorLabel"    name="authenticatorLabel"/>
        <input type="hidden" id="transports"            name="transports"/>
        <input type="hidden" id="error"                 name="error"/>

        <label class="remember">
            <input type="checkbox" id="logout-sessions" name="logout-sessions" value="on" checked>
            Sign out from other devices
        </label>

        <div class="action-row" style="margin-top:24px;">
            <button class="submit-btn" id="registerWebAuthn" type="button">Register Passkey</button>
        </div>
    </form>

    <#if !isSetRetry?has_content && isAppInitiatedAction?has_content>
        <form action="${url.loginAction}" id="kc-webauthn-settings-form" method="post" style="margin-top:10px;">
            <button class="secondary-btn" name="cancel-aia" value="true" type="submit">Cancel</button>
        </form>
    </#if>

    <script>
    <#outputformat "JavaScript">
    (function() {
        /* inline base64url — avoids the rfc4648 bare-specifier import that
           requires an importmap not present in standalone login pages */
        var b64url = {
            stringify: function(bytes, opts) {
                var str = btoa(String.fromCharCode.apply(null, Array.from(bytes)))
                    .replace(/\+/g, '-').replace(/\//g, '_');
                return (opts && opts.pad === false) ? str.replace(/=+$/, '') : str;
            },
            parse: function(str, opts) {
                if (opts && opts.loose) str = str.replace(/-/g, '+').replace(/_/g, '/');
                while (str.length % 4) str += '=';
                var raw = atob(str);
                var out = new Uint8Array(raw.length);
                for (var i = 0; i < raw.length; i++) out[i] = raw.charCodeAt(i);
                return out;
            }
        };

        function getPubKeyCredParams(algs) {
            if (!algs.length) return [{type:'public-key', alg:-7}];
            return algs.map(function(a){return{type:'public-key',alg:a};});
        }

        function getExcludeCredentials(ids) {
            if (!ids) return [];
            return ids.split(',').filter(Boolean).map(function(id){
                return {type:'public-key', id: b64url.parse(id,{loose:true})};
            });
        }

        function returnSuccess(result, initLabel, initLabelPrompt) {
            document.getElementById('clientDataJSON').value       = b64url.stringify(new Uint8Array(result.response.clientDataJSON),  {pad:false});
            document.getElementById('attestationObject').value    = b64url.stringify(new Uint8Array(result.response.attestationObject),{pad:false});
            document.getElementById('publicKeyCredentialId').value= b64url.stringify(new Uint8Array(result.rawId),                    {pad:false});
            if (typeof result.response.getTransports === 'function') {
                var t = result.response.getTransports();
                if (t) document.getElementById('transports').value = t.join();
            }
            var label = window.prompt(initLabelPrompt, initLabel);
            document.getElementById('authenticatorLabel').value = label !== null ? label : initLabel;
            document.getElementById('register').requestSubmit();
        }

        function returnFailure(err) {
            document.getElementById('error').value = err;
            document.getElementById('register').requestSubmit();
        }

        async function doRegister() {
            var errmsg    = ${msg("webauthn-unsupported-browser-text")?c};
            if (!window.PublicKeyCredential) { returnFailure(errmsg); return; }

            var challenge            = ${challenge?c};
            var userid               = ${userid?c};
            var username             = ${username?c};
            var rpId                 = ${rpId?c};
            var rpEntityName         = ${rpEntityName?c};
            var attestation          = ${attestationConveyancePreference?c};
            var attachment           = ${authenticatorAttachment?c};
            var residentKey          = ${requireResidentKey?c};
            var uvr                  = ${userVerificationRequirement?c};
            var createTimeout        = ${createTimeout?c};
            var excludeCredentialIds = ${excludeCredentialIds?c};
            var signatureAlgorithms  = [<#list signatureAlgorithms as s>${s?c}<#sep>,</#sep></#list>];
            var initLabel            = ${msg("webauthn-registration-init-label")?c};
            var initLabelPrompt      = ${msg("webauthn-registration-init-label-prompt")?c};

            var publicKey = {
                challenge: b64url.parse(challenge, {loose:true}),
                rp: {id: rpId, name: rpEntityName},
                user: {id: b64url.parse(userid,{loose:true}), name: username, displayName: username},
                pubKeyCredParams: getPubKeyCredParams(signatureAlgorithms)
            };

            if (attestation !== 'not specified') publicKey.attestation = attestation;

            var authSel = {}, hasAuthSel = false;
            if (attachment !== 'not specified')  { authSel.authenticatorAttachment = attachment; hasAuthSel = true; }
            if (residentKey !== 'not specified') { authSel.requireResidentKey = residentKey === 'Yes'; hasAuthSel = true; }
            if (uvr !== 'not specified')          { authSel.userVerification = uvr; hasAuthSel = true; }
            if (hasAuthSel) publicKey.authenticatorSelection = authSel;

            if (createTimeout !== 0) publicKey.timeout = createTimeout * 1000;
            var excl = getExcludeCredentials(excludeCredentialIds);
            if (excl.length) publicKey.excludeCredentials = excl;

            try {
                var result = await navigator.credentials.create({publicKey: publicKey});
                returnSuccess(result, initLabel, initLabelPrompt);
            } catch(e) {
                returnFailure(e);
            }
        }

        document.getElementById('registerWebAuthn').addEventListener('click', function() {
            doRegister();
        }, {once:true});
    })();
    </#outputformat>
    </script>
</main>
</body>
</html>
