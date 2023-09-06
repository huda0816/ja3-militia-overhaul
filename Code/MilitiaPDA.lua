-- if FirstLoad then

    PDABrowser.InternalModes = PDABrowser.InternalModes .. ", militia"

    local pda_mode_container = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDABrowser"],
        "__template",
        "PDAAIMBrowser")

    if pda_mode_container then
        table.insert(pda_mode_container.ancestors[2], PlaceObj("XTemplateMode", { "mode", "militia" }, {
            PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAMilitiaDialog"
            })
        }))
    end
-- end

-- DockBrowserTab("militia")

if PDABrowserTabData and not table.find(PDABrowserTabData, "id", "militia") then
    table.insert(PDABrowserTabData, {
        id = "militia",
        DisplayName = "Militia",
    })
end

DefineClass.PDAMilitia = {
    __parents = { "XDialog" },
}

function PDAMilitia:Open()
    local mode_param = GetDialogModeParam(self.parent) or GetDialogModeParam(GetDialog("PDADialog")) or
        GetDialog("PDADialog").context
    print("PDAMilitia:Open", mode_param)
    XDialog.Open(self)
end

function OpenMilitiaPDA()
    local full_screen = GetDialog("FullscreenGameDialogs")
    if full_screen and full_screen.window_state == "open" then
        full_screen:Close()
    end
    local pda = GetDialog("PDADialog")
    print("pda", pda.Mode)
    -- local mode_param = { browser_page = "militia" }
    -- if not pda then
    --     mode_param.Mode = "browser"
    --     pda = OpenDialog("PDADialog", GetInGameInterface(), mode_param)
    --     return
    -- end
    if pda.Mode ~= "browser" then
        pda:SetMode("browser")
        return
    end
    print("id content", pda.idContent)
    pda.idContent:SetMode("militia")

    print("mode", pda.idContent.Mode)

    -- if pda.idContent.Mode ~= "militia" then
    --     pda.idContent:SetMode("militia")
    --     print(pda.idContent.Mode)
    --     return
    -- end
end
