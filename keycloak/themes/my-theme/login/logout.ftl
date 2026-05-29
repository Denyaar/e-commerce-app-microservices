<#import "template.ftl" as layout>
<@layout.registrationLayout; section>
    <#if section = "header">
        <style>
            body, html { margin: 0; padding: 0; background: #07091A !important; }
            .logout-overlay {
                position: fixed;
                inset: 0;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #07091A;
                z-index: 9999;
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
            .logout-text { color: #8B9CC8; font-family: Arial, sans-serif; font-size: 14px; text-align: center; }
        </style>
    <#elseif section = "form">
        <div class="logout-overlay">
            <div>
                <div class="logout-spinner"></div>
                <p class="logout-text">Signing you out...</p>
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