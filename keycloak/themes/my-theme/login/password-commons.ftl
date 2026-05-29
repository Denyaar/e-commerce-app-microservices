<#macro logoutOtherSessions>
    <div id="kc-form-options" class="${properties.kcFormOptionsClass!}" style="margin-top: 10px;">
        <div class="${properties.kcFormOptionsWrapperClass!}">
            <div class="" style="display: flex; align-items: center; width:100%">
                <label style="flex: 1; display: flex; align-items: center;">
                    <input type="checkbox" id="logout-sessions" name="logout-sessions"
                           class="checkbox"
                           value="on" checked>
                    <span style="margin: 10px;">${msg("logoutOtherSessions")}</span>
                </label>
            </div>
        </div>
    </div>
</#macro>
