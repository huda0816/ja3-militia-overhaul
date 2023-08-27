-- This is needed
const.Satellite.MercSquadMaxPeople = const.Satellite.MercSquadMaxPeople ~= 6 and const.Satellite.MercSquadMaxPeople or 8

DefaultMaxMercs = const.Satellite.MercSquadMaxPeople

function OnMsg.Autorun()
    DefaultMaxMercs = const.Satellite.MercSquadMaxPeople ~= 6 and const.Satellite.MercSquadMaxPeople or 8
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
        return a.squad.CurrentSector < b.squad.CurrentSector
    end)
    return items
end

local sat_conflict = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SatelliteConflict"], "ActionId",
    "actionFight")

if sat_conflict then
    sat_conflict.element.ActionState = function(self, host)
        local sector = host.context
        return CanGoInMap(sector.Id) and
            #GetSquadsInSector(sector.Id, "excludeTravelling", true, "excludeArriving", "excludeRetreating") > 0
    end
end

if FirstLoad then
    local sm_content = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASquadManagement"], "Id",
        "idContent")

    if sm_content then
        sm_content.element.__context = function(parent, context) return GetSquadManagementSquads() end

        sm_content.element[2][1].MinWidth = 950
        sm_content.element[2][1].MaxWidth = 950

        XTemplates["PDASquadManagement"][1][4].MinWidth = 1300
        XTemplates["PDASquadManagement"][1][4].MaxWidth = 1300
    end

    local drag_a_merc = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASquadManagement"], "Id",
        "idDragAMerc")

    if drag_a_merc then
        drag_a_merc.element.Text = Untranslated("Drag here to create squad")
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
                    const.Satellite.MercSquadMaxPeople = SatelliteSector.MaxMilitia or 8
                    host.idToolBar.ididMilitia:SetText(Untranslated("Mercs"))
                    self:SetProperty("ActionName", "Mercs")
                    host.idContent:SetContext(GetSquadManagementMilitiaSquads())
                else
                    const.Satellite.MercSquadMaxPeople = DefaultMaxMercs
                    host.idToolBar.ididMilitia:SetText(Untranslated("Militia"))
                    self:SetProperty("ActionName", "Militia")
                    host.idContent:SetContext(GetSquadManagementSquads(true))
                end
            end
        })
        )
    end


    local squad_names = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDASquadManagement"], "Id",
        "idSquadName", "all")

    if squad_names then
        for _, v in ipairs(squad_names) do
            table.insert(v.ancestors[1], 3, PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadNameFull",
                "Margins",
                box(4, 24, 4, 0),
                "Padding",
                box(0, 0, 0, 0),
                "HAlign",
                "left",
                "FoldWhenHidden",
                true,
                "Visible",
                false,
                "TextStyle",
                "HUDASMALLPDASM",
                "ContextUpdateOnOpen",
                true,
                "Translate",
                true,
                "Text",
                Untranslated("I am text"),
                "OnContextUpdate",
                function(self, context, ...)
                    self.parent[2]:SetProperty("FoldWhenHidden", true)
                    self.parent[1]:SetProperty("FoldWhenHidden", true)

                    if context.militia then
                        self.parent[1]:SetVisible(false)
                        self.parent[2]:SetVisible(false)

                        self:SetText(Untranslated(context.Name))
                        self:SetVisible(true)
                    else
                        self.parent[1]:SetVisible(true)
                        self.parent[2]:SetVisible(true)
                        self:SetVisible(false)
                    end
                end
            }))
        end
    end
end


-- Prevent Icon Popup if militia
local HUDA_OldOpenSquadCreation = OpenSquadCreation

function OpenSquadCreation(squad_id)
    local context = gv_Squads[squad_id]

    if context.militia then
        return
    end

    local unit = gv_UnitData[context.units[1]]

    if unit and unit.militia then
        return
    end

    HUDA_OldOpenSquadCreation(squad_id)
end

-- Add predef props
local HUDA_OldCreateNewSatelliteSquad = CreateNewSatelliteSquad

function CreateNewSatelliteSquad(predef_props, unit_ids, days, seed, enemy_squad_def, reason)
    if unit_ids then
        for _, v in ipairs(unit_ids) do
            local unit = gv_UnitData[v]
            if unit and unit.militia then
                predef_props.militia = true
                predef_props.image = ""
                if type(predef_props.Name) ~= "table" then
                    local name = HUDA_MilitiaPersonalization:GetRandomSquadName(HUDA_GetSectorId(unit))
                    predef_props.Name = name
                    predef_props.ShortName = name
                end
                break
            end
        end
    end

    return HUDA_OldCreateNewSatelliteSquad(predef_props, unit_ids, days, seed, enemy_squad_def, reason)
end

function OnMsg.UnitJoinedPlayerSquad(squad_id)
    local dlg = GetDialog("PDASquadManagement")
    if dlg then
        local squad = gv_Squads[squad_id]
        if squad.militia then
            dlg.idContent:SetContext(GetSquadManagementMilitiaSquads())
        else
            dlg.idContent:SetContext(GetSquadManagementSquads())
        end
    end
end

-- reset max mercs
function OnMsg.DialogClose(dlg)
    if dlg.XTemplate == "PDASquadManagement" then
        const.Satellite.MercSquadMaxPeople = DefaultMaxMercs
    end
end

-- reset all trainables
function OnMsg.DialogClose(dlg)
    if dlg.XTemplate == "PDASquadManagement" then
        local sectors_with_militia = table.filter(gv_Sectors, function(i, v) return v.militia_squad_id or v.militia_squads end)

        for k, v in pairs(sectors_with_militia) do
            if v.militia_squad_id then
                local squad = gv_Squads[v.militia_squad_id]
                if HUDA_IsSquadFull(squad, v) then
                    v.militia_squad_id = HUDA_GetTrainableMilitiaSquad(v, squad.UniqueId)
                end
            else
                v.militia_squad_id = HUDA_GetTrainableMilitiaSquad(v)
            end
        end
    end
end
