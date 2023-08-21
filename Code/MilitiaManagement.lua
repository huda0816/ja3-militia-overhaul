const.Satellite.MercSquadMaxPeople = 8


function GetSquadManagementSquads(mercs)
    local last_squad_in_table = gv_Squads and gv_Squads[#gv_Squads] or nil

    if (last_squad_in_table and last_squad_in_table.joining_squad) then
        local joining_squad = gv_Squads[last_squad_in_table.joining_squad]        

        if joining_squad.militia then
            last_squad_in_table.militia = true
            g_PlayerSquads = table.filter(g_PlayerSquads, function(i, v)
                return v.UniqueId ~= last_squad_in_table.UniqueId
            end)
            ObjModified("ui_player_squads")
            return GetSquadManagementMilitiaSquads()
        end
    end

    if not mercs and last_squad_in_table and last_squad_in_table.militia then
        return GetSquadManagementMilitiaSquads()
    end
    local squads = GetPlayerMercSquads()
    local items = {}
    for _, squad in ipairs(squads) do
        if squad.CurrentSector then
            local item = { squad = squad }
            for i = 1, const.Satellite.MercSquadMaxPeople do
                item[#item + 1] = squad.units[i] or "empty"
            end
            items[#items + 1] = item
        end
    end
    table.sort(items, function(a, b)
        return a.squad.UniqueId < b.squad.UniqueId
    end)
    return items
end

function GetSquadManagementMilitiaSquads()
    local squads = GetPlayerMercSquads(true)
    local items = {}
    for _, squad in ipairs(squads) do
        if squad.militia then
            local item = { squad = squad }
            for i = 1, const.Satellite.MercSquadMaxPeople do
                item[#item + 1] = squad.units[i] or "empty"
            end
            items[#items + 1] = item
        end
    end
    table.sort(items, function(a, b)
        return a.squad.UniqueId < b.squad.UniqueId
    end)
    return items
end

if FirstLoad then

    local sm_content = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASquadManagement"], "Id", "idContent")

    if sm_content then
        sm_content.element.__context = function(parent, context) return GetSquadManagementSquads(true) end
    end

    for _, v in ipairs(CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASquadManagement"], "ActionId", "idFilters", "first_on_branch")) do
        table.insert(v.ancestors[1], 1, PlaceObj("XTemplateAction", {
            "ActionId",
            "idMilitia",
            "ActionName",
            "Militia",
            "ActionToolbar",
            "ActionBar",
            "ActionShortcut",
            "S",
            "ActionGamepad",
            "ButtonA",
            "OnAction",
            function(self, host, source, ...)
                if self.ActionName == "Militia" then
                    source:SetText(Untranslated("Mercs"))
                    self:SetProperty("ActionName", "Mercs")
                    host.idContent:SetContext(GetSquadManagementMilitiaSquads())
                else
                    source:SetText(Untranslated("Militia"))
                    self:SetProperty("ActionName", "Militia")
                    host.idContent:SetContext(GetSquadManagementSquads(true))
                end
            end
        })
        )
    end
end

function OpenSquadCreation(squad_id)
    local dlg = GetDialog("PDASquadManagement")
    local context = gv_Squads[squad_id]

    local unit = gv_UnitData[context.units[1]]

    if unit and unit.militia then
        local squad = gv_Squads[squad_id]

        if not squad.militia then
            squad.militia = true
            squad.Name = HUDAGetRandomSquadName(squad.CurrentSector)
            squad.image = ""
        end

        g_PlayerSquads = table.filter(g_PlayerSquads, function(i, v)
            return v.UniqueId ~= squad_id
        end)

        local dlg = GetDialog("PDASquadManagement")
        if dlg then
            dlg.idContent:SetContext(GetSquadManagementMilitiaSquads())
        end

        ObjModified("ui_player_squads")
        return
    end

    if dlg and context then
        local squadCreation = XTemplateSpawn("PDASquadCreation", dlg, context)
        squadCreation:Open()
    end
end
