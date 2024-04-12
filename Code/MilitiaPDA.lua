GameVar("gv_HUDA_Website_Status", {})

function OnMsg.DataLoaded()
    local pda_mode_container = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["PDABrowser"],
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

function OnMsg.ZuluGameLoaded(game)
    if gv_HUDA_Website_Status.launched then
        InitBrowserModes()
        return
    end

    local militia = HUDA_TableFind(gv_UnitData, function(k, unit)
        return unit.militia and unit.HireStatus ~= "Dead"
    end)

    if militia then
        HUDA_LaunchWebsite()
    end
end

function InitBrowserModes()
    PDABrowser.InternalModes = PDABrowser.InternalModes .. ", militia"

    if PDABrowserTabData and not table.find(PDABrowserTabData, "id", "militia") then
        table.insert(PDABrowserTabData, {
            id = "militia",
            DisplayName = Untranslated("Militia"),
        })
    end
end

-- function OnMsg.SquadSpawned(id)
--     if gv_HUDA_Website_Status.launched then
--         return
--     end

--     local squad = gv_Squads[id]

--     if not squad or not squad.militia then
--         return
--     end

--     HUDA_LaunchWebsite()
-- end

function OnMsg.OperationCompleted(operation, mercs, sector)
    if gv_HUDA_Website_Status.launched then
        return
    end

    if operation.id ~= "HUDA_MilitiaBase" then
        return
    end

    HUDA_LaunchWebsite()
end

function HUDA_LaunchWebsite()
    InitBrowserModes()

    gv_HUDA_Website_Status.launched = true

    HUDA_PublishNews("WebsiteLaunched")

    HUDA_ShopController:Init()

    OpenMilitiaPDA("home")
end

function OpenMilitiaPDA(mode, params)
    local full_screen = GetDialog("FullscreenGameDialogs")
    if full_screen and full_screen.window_state == "open" then
        full_screen:Close()
    end

    local pda = OpenDialog("PDADialog", GetInGameInterface(), { Mode = "browser" })

    local dlg = pda.idContent

    if dlg.Mode ~= "militia" then
        dlg:SetMode("militia")
    end

    local content = dlg.idBrowserContent

    if content:GetMode() ~= mode then
        content:SetMode(mode, params)
    end
end

-------------------------- TFormat --------------------------


local HUDA_OriginalPDAUrl = TFormat.PDAUrl

function TFormat.PDAUrl(context_obj)
    -- local pda = GetDialog("PDADialog")
    -- if not pda then
    --     return false
    -- end
    -- local content = pda:ResolveId("idContent")
    -- local mercBrowser = IsKindOf(content, "PDABrowser") and content

    -- local browserContent = mercBrowser.idBrowserContent

    -- if mercBrowser and mercBrowser:GetMode() == "militia" then
    --     local mode = browserContent:GetMode()
    --     local mode_param = browserContent.mode_param

    --     local url = browserContent:GetURL(mode, mode_param)

    --     return url or "http://www.gc-militia.org/"
    -- end

    return Untranslated(HUDA_OriginalPDAUrl(context_obj))
end

function TFormat.MilitiaName(context_obj)
    return Untranslated(context_obj.Name)
end

function TFormat.AAR(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return Untranslated(HUDA_AARGenerator:PrintAAR(conflict))
end

function TFormat.AARTitle(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return Untranslated(HUDA_AARGenerator:PrintAARTitle(conflict))
end

function TFormat.ConflictDaysAgo(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return Untranslated(HUDA_GetDaysSinceTime(conflict.endTime))
end

function TFormat.ConflictResult(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    if (conflict.playerWon and conflict.playerWon == true) then
        return Untranslated("Victory")
    else
        return Untranslated("Defeat")
    end
end

function TFormat.ConflictLocation(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return Untranslated(GetSectorName(gv_Sectors[conflict.sectorId]))
end

function TFormat.ConflictDirection(conflict)
    conflict = conflict or gv_HUDA_ConflictTracker[#gv_HUDA_ConflictTracker]

    return Untranslated(conflict.playerAttacked and "Offensive" or "Defensive")
end

function TFormat.MilitiaSquadCosts(squad)
    return Untranslated(HUDA_MilitiaFinances:GetDailyCostsPerSquad(squad))
end

function TFormat.MilitiaSupplyBase(squad)
    return Untranslated(HUDA_MilitiaFinances:GetSupplyBase(squad))
end

function TFormat.MilitiaSquadOrigin(squad)
    if squad.BornInSector == "" then
        return Untranslated("Unknown")
    end

    return Untranslated(HUDA_GetClosestCity(squad.BornInSector))
end

function TFormat.MilitiaStatus(item)
    if gv_Sectors[item.CurrentSector].conflict then
        return Untranslated("In Battle")
    elseif item.route and item.route.displayedSectionEnd then
        return Untranslated("Moves towards: " .. item.route.displayedSectionEnd)
    else
        return Untranslated("Defending")
    end
end

function TFormat.NewsMeta(item)
    local date, city = HUDA_NewsController:GetNewsMeta(item)

    return date .. (date and city and  Untranslated(" - ")) .. city
end

function TFormat.GetDateFromTime(context)
    return Untranslated(HUDA_GetDateFromTime(context.aar.endTime))
end
