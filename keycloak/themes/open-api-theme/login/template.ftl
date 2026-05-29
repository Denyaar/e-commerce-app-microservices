<#global globalDisplayMessage = true>
<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=globalDisplayMessage>
    <!doctype html>
    <html
            lang="en"
            x-data="{ darkMode: localStorage.getItem('darkMode') || localStorage.setItem('darkMode', 'system')}"
            x-init="$watch('darkMode', val => localStorage.setItem('darkMode', val))"
            x-bind:class="{'dark': darkMode === 'dark' || (darkMode === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches)}">
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width"/>
        <link rel="icon" type="image/svg+xml" href="favicon.svg"/>
        <meta name="generator" content="Astro v4.9.3"/>
        <title>EcoCash Developer SandBox</title>
        <script defer
                src="https://unpkg.com/@colinaut/alpinejs-plugin-simple-validate@1/dist/alpine.validate.min.js"></script>
        <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

        <#if properties.styles?has_content>
            <#list properties.styles?split(' ') as style>
                <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <style>html, body { background: #004B95 !important; }</style>

    </head>
    <body class="antialiased font-sans text-sm text-foreground flex flex-col w-full h-full min-h-screen bg-secondary z-0">

    <#nested "header">

    <div class="fixed inset-0 z-10 mx-0 max-w-none overflow-hidden">
        <div class="absolute left-1/2 top-0 ml-[-38rem] h-[25rem] w-[81.25rem]">
            <div
                    class="absolute inset-0 opacity-20 [mask-image:radial-gradient(farthest-side_at_top,white,transparent)]">
                <svg
                        aria-hidden="true"
                        class="absolute inset-x-0 inset-y-[-50%] h-[200%] w-full skew-y-[-18deg] fill-black/40 stroke-black/50 mix-blend-overlay">
                    <defs>
                        <pattern
                                id=":S1:"
                                width="72"
                                height="56"
                                patternUnits="userSpaceOnUse"
                                x="-12"
                                y="4">
                            <path d="M.5 56V.5H72" fill="none"></path>
                        </pattern>
                    </defs>
                    <rect
                            width="100%"
                            height="100%"
                            stroke-width="0"
                            fill="url(#:S1:)"></rect>
                </svg>
            </div>
        </div>
    </div>

    <div class="fixed top-0 w-full h-[40vh] bg-primary/80 inset-x-0">
        <figure class="absolute -bottom-0 left-0 w-full block -mb-3 z-index-9">
            <svg
                    class="fill-secondary"
                    width="100%"
                    height="150"
                    viewBox="0 0 500 150"
                    preserveAspectRatio="none">
                <path d="M0,150 L0,40 Q250,150 500,40 L580,150 Z"></path>
            </svg>
        </figure>
    </div>

    <div class="relative z-10 max-w-xl w-full mx-auto my-0 px-6 md:px-12 py-12">

        <#nested "form">
    </div>

    <script>
        (function () {
            var logoutConfirm = document.getElementById('kc-logout-confirm');
            if (logoutConfirm) {
                logoutConfirm.click();
                return;
            }
            var logoutDiv = document.getElementById('kc-logout');
            if (logoutDiv) {
                var form = logoutDiv.closest('form') || document.querySelector('form');
                if (form) { form.submit(); }
            }
        })();
    </script>
    </body>
    </html>
</#macro>
