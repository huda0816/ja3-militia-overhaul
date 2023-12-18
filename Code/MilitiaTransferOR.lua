function OnMsg.DataLoaded()
    local SectorOperationUI = XTemplates.SectorOperationMainUI

    local OpenFunc = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"], "name",
        "Open")

    if OpenFunc then
        local OriginalFunc = OpenFunc.element.func

        OpenFunc.element.func = function(self, ...)
            local host = GetActionsHost(self, true)
            local operation_id = host.mode_param.operation

            if HUDA_MilitiaTransfer:GetOpId() ~= operation_id then
                OriginalFunc(self, ...)
                return
            end

            XDialog.Open(self, ...)

            local sector = host.context
            local mode = sector.started_operations and sector.started_operations[operation_id] and "progress" or "change"
            if mode == "progress" and sector.operations_temp_data and sector.operations_temp_data[operation_id] then
                sector.operations_temp_data[operation_id].pick_item_to_sell = false
            end
            if sector.operations_temp_data and sector.operations_temp_data[operation_id] and sector.operations_temp_data[operation_id].pick_item_to_sell then
                mode = "pick_item_to_sell"
            end
            self:SetMode(mode, self:GetContext())
        end
    end

    local ActionBar = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationsUI"], "Id",
        "idActionBar")

    if ActionBar then
        ActionBar.element.ButtonTemplate = "PDAHUDAOPActionButton"
    end

    SectorOperationUI[1].InternalModes = SectorOperationUI[1].InternalModes .. ", pick_item_to_sell"

    local backAction = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationsUI"],
        "ActionId",
        "idClose", "all")

    if backAction then
        local backActionOnAction = backAction[2].element.OnAction

        backAction[2].element.OnAction = function(self, host, source, ...)
            local dlg = GetDialog("SectorOperationsAssignDlgUI")
            if dlg then
                dlg:Close()
            end

            for i = #host, 1, -1 do
                if host[i].Id == "idStatsPopup" then
                    host[i]:Close()
                    break
                end
            end

            local subdlg = host.idBase.idMain
            local mode = subdlg and subdlg:GetMode()

            if mode == "pick_item_to_sell" then
                CreateRealTimeThread(function()
                    local subdlg = host.idBase.idMain
                    local mode = subdlg and subdlg:GetMode()
                    if mode == "progress" then
                        SetBackDialogMode(host)
                        return
                    end
                    local operation_id = host.mode_param.operation
                    local cancel = false
                    local drag = subdlg.idQueueList.idQueue
                    if drag and drag.drag_win then
                        drag.drag_win:delete()
                        drag.drag_win = false
                        drag:StopDrag()
                        cancel = true
                    end
                    drag = subdlg.idAllList.idAllItems
                    if drag and drag.drag_win then
                        drag.drag_win:delete()
                        drag.drag_win = false
                        drag:StopDrag()
                        cancel = true
                    end
                    if cancel then
                        --NetSyncEvent("SectorOperationItemsUpdateLists", sector_id, operation_id, TableWithItemsToNet(all), TableWithItemsToNet(queue))
                        SectorOperation_ItemsUpdateItemLists(subdlg)
                        return
                    end
                    local sector = host.context
                    if not sector.operations_temp_data or not sector.operations_temp_data[operation_id] then
                        SetBackDialogMode(host)
                        return
                    end
                    --local question_text = T(382184936324, "Are you sure you want to leave? Mercs will be unassigned from this Operation.")
                    local question_text = T(616270408863,
                        "Are you sure you want to cancel? All changes will be reverted and returned to the previous state of the operation")
                    local qdlg = CreateQuestionBox(
                        GetDialog("PDADialog"),
                        T(824112417429, "Warning"),
                        question_text,
                        T(1138, "Yes"), T(1139, "No"))
                    qdlg:SetModal()

                    local res = qdlg:Wait() == "ok"
                    if res then
                        -- restore prev variant
                        local start_time = sector.operations_prev_data and sector.operations_prev_data.prev_start_time
                        SectorOperations_InterruptCurrent(sector, operation_id, "no log")
                        SectorOperations_RestorePrev(host, sector, operation_id, start_time)
                        -- leave
                        SetBackDialogMode(host)
                        return
                    end
                    if not res then
                        return
                    end
                end)
            else
                backActionOnAction(self, host, source, ...)
            end
        end
    end

    local startAction = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"],
        "ActionId",
        "Start")

    if startAction then
        local originalState = startAction.element.ActionState

        startAction.element.ActionState = function(self, host)
            local operation_id = host.mode_param.operation

            if operation_id == HUDA_MilitiaTransfer:GetOpId() then
                return "hidden"
            end

            return originalState(self, host)
        end
    end

    local ChangeMode = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"], "mode",
        "change")

    if ChangeMode then
        table.insert(ChangeMode.element, PlaceObj('XTemplateAction', {
            'comment', "sell items",
            'ActionId', "PickTransferItem",
            'ActionName', T(6304237736690816, --[[XTemplate SectorOperationMainUI ActionName]] "Pick Items"),
            'ActionToolbar', "ActionBar",
            'ActionShortcut', "P",
            'ActionGamepad', "ButtonY",
            'ActionState', function(self, host)
            local operation_id = host.mode_param.operation
            local sector = host.context
            local operation = SectorOperations[operation_id]
            if operation_id ~= HUDA_MilitiaTransfer:GetOpId() then
                return "hidden"
            end
            if GetDialog("SectorOperationsAssignDlgUI") then
                return "disabled"
            end
            for _, prof in ipairs(operation.Professions) do
                local profession = prof.id
                if #GetOperationProfessionals(sector.Id, operation_id, profession) <= 0 then
                    return "disabled"
                end
            end
            return "enabled"
        end,
            'OnAction', function(self, host, source, ...)
            local dlg = GetDialog("SectorOperationsAssignDlgUI")
            if dlg then dlg:Close() end

            local dlg = host.idBase.idMain
            if dlg then
                local sector = host.context
                local operation_id = host.mode_param.operation
                sector.operations_temp_data = sector.operations_temp_data or {}
                sector.operations_temp_data[operation_id] = sector.operations_temp_data[operation_id] or
                    {}
                sector.operations_temp_data[operation_id].pick_item_to_sell = true
                -- if IsCraftOperationId(operation_id) then
                --     SectorOperationValidateItemsToCraft(sector.Id, operation_id)
                --     local qid, aid = GetCraftOperationListsIds(operation_id)
                --     local tbl = GetCraftOperationQueueTable(sector, operation_id)
                --     NetSyncEvent("ChangeSectorOperationItemsOrder", sector.Id, operation_id,
                --         TableWithItemsToNet(sector[aid]), TableWithItemsToNet(tbl))
                -- end
                dlg:SetMode("pick_item_to_sell")
            end
        end,
            'FXMouseIn', "activityAssignStartHover",
            'FXPress', "activityAssignStartPress",
            'FXPressDisabled', "activityAssignStartDisabled",
            'replace_matching_id', true,
        }))
    end

    local ActionModes = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"], "Id",
        "idLeft")

    if ActionModes then
        table.insert(ActionModes.element, 1, PlaceObj('XTemplateMode', {
            'comment', "sell items",
            'mode', "pick_item_to_sell",
        }, {
            PlaceObj('XTemplateWindow', {
                '__class', "XContentTemplate",
                'IdNode', false,
            }, {
                PlaceObj('XTemplateTemplate', {
                    '__template', "MilitiaItemsTransferSelectItemsUI",
                    'VAlign', "top",
                }),
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "PickSeller",
                'ActionName', T(1982441778220815, "Logistician"),
                'ActionToolbar', "ActionBar",
                'ActionShortcut', "P",
                'ActionGamepad', "LeftShoulder",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = host.idBase.idMain
                if dlg then
                    local sector = host.context
                    local operation_id = host.mode_param.operation
                    sector.operations_temp_data[operation_id].pick_item_to_sell = false
                    dlg:SetMode("change")
                end
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "AddAll",
                'ActionName', T(2378413941050816, "Add all"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:AddAll(sector.Id)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "ClearAll",
                'ActionName', T(2378413941050817, "Clear all"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:ClearAll(sector.Id)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "FilterWeapons",
                'ActionName', T(2378413941050818, "W"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:Filter(sector.Id, "Weapons", source)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "FilterArmor",
                'ActionName', T(2378413941050819, "A"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:Filter(sector.Id, "Armor", source)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "FilterAmmo",
                'ActionName', T(2378413941050820, "M"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:Filter(sector.Id, "Ammo", source)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            }),
            PlaceObj('XTemplateAction', {
                'ActionId', "FilterOther",
                'ActionName', T(2378413941050821, "O"),
                'ActionToolbar', "ActionBar",
                'ActionGamepad', "ButtonY",
                'ActionState', function(self, host)
                return "enabled"
            end,
                'OnAction', function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                    dlg:Close()
                end
                local sector = host.context
                HUDA_MilitiaTransfer:Filter(sector.Id, "Other", source)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
            end,
                'FXMouseIn', "activityAssignStartHover",
                'FXPress', "activityAssignStartPress",
                'FXPressDisabled', "activityAssignStartDisabled",
                'replace_matching_id', true,
            })
        }))
    end

    local OpModes = HUDA_CustomSettingsUtils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"], "Id",
        "idMain")

    if OpModes and OpModes.element[5] then
        table.insert(OpModes.element[5], 1, PlaceObj('XTemplateMode', {
            'mode', "pick_item_to_sell",
        }, {
            PlaceObj('XTemplateTemplate', {
                '__context', function(parent, context)
                return {
                    operation = SectorOperations
                        [GetActionsHost(parent, true).mode_param.operation],
                    sector = GetActionsHost(parent, true).context
                }
            end,
                '__template', "MilitiaItemsTransferSectorPicker",
            }),
        })
        )
    end
end

local HUDA_OriginlXActivityItemOnContextUpdate = XActivityItem.OnContextUpdate

function XActivityItem:OnContextUpdate(item, ...)
    HUDA_OriginlXActivityItemOnContextUpdate(self, item, ...)

    local itm = rawget(self, "item")

    if itm.context == "transfer" then
        if IsKindOfClasses(item, "Armor", "Firearm", "HeavyWeapon", "MeleeWeapon", "ToolItem", "Medicine") and not IsKindOf(item, "InventoryStack") then
            self.idText:SetText(T { 641971138327224, "<style InventoryItemsCountMax><percent(condPercent)></style>", condPercent = item.Condition })
        else
            self.idText:SetText(T { 641971138327222, "<style InventoryItemsCountMax><amount></style>", amount = itm.amount })
        end

        local price = (HUDA_MilitiaTransfer:GetItemPrice(itm) or 0) * (itm.amount or 1)

        self.idTopRightText:SetText(T { 641971138327228, "<style InventoryItemsCountMax>$<mon></style>", mon = price })
    end
end
