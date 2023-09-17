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
    print("I got opened")
end

function OpenMilitiaPDA(mode)
    local full_screen = GetDialog("FullscreenGameDialogs")
    if full_screen and full_screen.window_state == "open" then
        full_screen:Close()
    end
    local pda = GetDialog("PDADialog")
    -- print("pda", pda.Mode)
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

function TFormat.AAR(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return HUDA_AARGenerator:PrintAAR(conflict)
end

function TFormat.AARTitle(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return HUDA_AARGenerator:PrintAARTitle(conflict)
end

function TFormat.ConflictDaysAgo(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return HUDA_GetDaysSinceTime(conflict.endTime)
end

function TFormat.ConflictResult(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    if (conflict.playerWon and conflict.playerWon == true) then
        return "Victory"
    else
        return "Defeat"
    end
end

function TFormat.ConflictLocation(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return GetSectorName(gv_Sectors[conflict.sectorId])
end

function TFormat.ConflictDirection(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return conflict.playerAttacked and "Offensive" or "Defensive"
end

function TFormat.MilitiaSquadCosts(squad)
    return HUDA_MilitiaFinances:GetDailyCostsPerSquad(squad)
end

function TFormat.MilitiaSquadOrigin(squad)
    if squad.BornInSector == "" then
        return "Unknown"
    end

    return HUDA_GetClosestCity(squad.BornInSector)
end

function TFormat.MilitiaStatus(item)
    if gv_Sectors[item.CurrentSector].conflict then
        return "In Battle"
    elseif item.route and item.route.displayedSectionEnd then
        return "Moves towards: " .. item.route.displayedSectionEnd
    else
        return "Defending"
    end
end

function TFormat.NewsMeta(item)
    local sector, date

    if (item.sector) then
        sector = GetSectorName(HUDA_GetSectorById(item.sector))
    end

    if (item.date) then
        date = HUDA_GetDateFromTime(item.date)
    end

    return date .. (date and sector and " - ") .. sector
end
