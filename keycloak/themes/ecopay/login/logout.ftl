<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <style>
            body { background: #07091A !important; }
            .logout-overlay {
                position: fixed;
                inset: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #07091A;
                z-index: 9999;
            }
            .logout-box {
                text-align: center;
                color: #EEF2FF;
                font-family: Arial, sans-serif;
            }
            .logout-spinner {
                width: 36px;
                height: 36px;
                border: 3px solid rgba(255,255,255,0.1);
                border-top-color: #0052A5;
                border-radius: 50%;
                animation: spin 0.8s linear infinite;
                margin: 16px auto;
            }
            @keyframes spin { to { transform: rotate(360deg); } }
        </style>
    <#elseif section = "form">
        <div class="logout-overlay">
            <div class="logout-box">
                <div class="logout-spinner"></div>
                <p style="color:#8B9CC8; font-size:14px; margin:0;">Signing you out...</p>
            </div>
        </div>
        <script>
            (function () {
                <#if url.logoutConfirmAction?has_content>
                window.location.replace('${url.logoutConfirmAction}');
                <#else>
                window.location.replace('${url.loginUrl}');
                </#if>
            })();
        </script>
    </#if>
</@layout.registrationLayout>
