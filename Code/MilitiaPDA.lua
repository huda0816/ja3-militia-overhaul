if FirstLoad then
    local pda_mode_container = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDABrowser"],
        "__template",
        "PDAAIMBrowser")

    if pda_mode_container then
        table.insert(pda_mode_container.ancestors[2], PlaceObj("XTemplateMode", { "mode", "militia" }, {
            PlaceObj("XTemplateTemplate", {
                "__template",
                "PDAMilitiaDialog",
                "Id",
                "idBrowserContent"
            })
        }))
    end
end

PDABrowser.InternalModes = PDABrowser.InternalModes .. ", militia"

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
    pda.idContent:SetMode("militia")

    -- if pda.idContent.Mode ~= "militia" then
    --     pda.idContent:SetMode("militia")
    --     print(pda.idContent.Mode)
    --     return
    -- end
end

local HUDA_OriginalPDAUrl = TFormat.PDAUrl

function TFormat.PDAUrl(context_obj)
    local pda = GetDialog("PDADialog")
    if not pda then
        return false
    end
    local content = pda:ResolveId("idContent")
    local mercBrowser = IsKindOf(content, "PDABrowser") and content
    local browserContent = mercBrowser.idBrowserContent

    if mercBrowser and mercBrowser:GetMode() == "militia" then
        local mode = browserContent:GetMode()
        local mode_param = browserContent.mode_param

        local url = browserContent:GetURL(mode, mode_param)

        return url or
            T(846448600633, "http://www.gc-militia.org/")
    end

    return HUDA_OriginalPDAUrl(context_obj)
end

function TFormat.MilitiaName(context_obj)
    return context_obj.Name
end

function _ENV:PDAImpHeaderEnable()
    -- local header_button = GetDialog(self):ResolveId("idHeader"):ResolveId("idLeftLinks"):ResolveId(self:GetProperty("HeaderButtonId"))
    -- header_button:ResolveId("idLink"):SetTextStyle("PDAIMPContentTitleSelected")
  end
  function _ENV:PDAImpHeaderDisable()
    -- local header_button = GetDialog(self):ResolveId("idHeader"):ResolveId("idLeftLinks"):ResolveId(self:GetProperty("HeaderButtonId"))
    -- header_button:ResolveId("idLink"):SetTextStyle("PDAIMPContentTitleActive")
  end
