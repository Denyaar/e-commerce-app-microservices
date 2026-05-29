<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
            "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="robots" content="noindex, nofollow">

        <title><#nested "title"></title>
        <#if properties.styles?has_content>
            <#list properties.styles?split(' ') as style>
                <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <head>

        </head>


    </head>

    <body>

    <div id="root">
        <div class="app-layout-blank flex flex-auto flex-col h-[100vh]">
            <div class="h-full flex flex-auto flex-col justify-between">
                <main class="h-full">
                    <div class="page-container relative h-full flex flex-auto flex-col">
                        <div class="h-full">
                            <div class="container mx-auto flex flex-col flex-auto items-center justify-center min-w-0 h-full">
                                <div class="card min-w-[320px] md:min-w-[450px] card-shadow" role="presentation">
                                    <div class="card-body md:p-10">
                                        <div class="text-center">
                                            <div class="logo" style="width: auto;"><img class="mx-auto"
                                                                                        src="${url.resourcesPath}/img/ecocash-logo.png"
                                                                                        alt="Ecocash Logo">
                                            </div>

                                            <#nested "header">
                                            <div class="login-content">
                                                <div class="box">
                                                    <#if displayMessage && message? has_content>
                                                        <div class="alert alert-${message.type}">
                                                            <#if message.type = 'success'><span
                                                                class="${properties.kcFeedbackSuccessIcon!}"></span></#if>
                                                            <#if message.type = 'warning'><span
                                                                class="${properties.kcFeedbackWarningIcon!}"></span></#if>
                                                            <#if message.type = 'error'><span
                                                                class="${properties.kcFeedbackErrorIcon!}"></span></#if>
                                                            <#if message.type = 'info'><span
                                                                class="${properties.kcFeedbackInfoIcon!}"></span></#if>
                                                            <p style="width:50%;margin:auto;">
                                                                <span class="message-text text-red-600">${message.summary?no_esc}</span>
                                                            </p>
                                                        </div>
                                                    </#if>
                                                    <#nested "form">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>

            <div class="text-2xl header-action-item header-action-item-hoverable hidden">
                <svg stroke="currentColor"
                     fill="none" stroke-width="2" viewBox="0 0 24 24" aria-hidden="true" height="1em" width="1em"
                     xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round"
                          d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z">
                    </path>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </svg>
            </div>
        </div>
    </div>
    </body>
    </html>
</#macro>
