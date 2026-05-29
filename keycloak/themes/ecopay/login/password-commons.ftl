<#macro logoutOtherSessions>
    <div id="kc-form-options" class="${properties.kcFormOptionsClass!}">
        <div class="flex flex-col mb-4 input-block">
            <div class="flex items-center group gap-2">
                <input
                        type="checkbox"
                        id="logout-sessions" name="logout-sessions"
                        class="w-4 h-4 text-primary bg-secondary border-border rounded focus:ring-primary/80 focus:ring-2"
                        value="on" checked
                />
                <label
                        for="accept-terms"
                        class="text-sm font-medium group-[[data-error]]:hidden"
                >${msg("logoutOtherSessions")}</label
                >
            </div>
        </div>
    </div>
</#macro>
