DefineClass.XDragContextWindowTransfer = {
    __parents = { "XContentTemplate", "XDragAndDropControl" },
    properties = {
        { category = "General", id = "slot_name",    name = "Slot Name",    editor = "text", default = "", },
        { category = "General", id = "disable_drag", name = "Disable Drag", editor = "bool", default = false, },
    },

    ClickToDrag = true,
    ClickToDrop = true,
}

function XDragContextWindowTransfer:OnMouseButtonClick(pos, button)
    return XDragAndDropControl.OnMouseButtonClick(self, pos, button)
end

function XDragContextWindowTransfer:OnMouseButtonDoubleClick(pos, button)
    if button == "L" then
        -- if not IsMouseViaGamepadActive() then
        local ctrl = self.drag_win

        -- if not ctrl then return "break" end
        -- if not ctrl.idItem:GetEnabled() then return "break" end

        local operation_id = self.context[1].operation
        local dlg = GetDialog(self)
        local dlg_context = dlg and dlg.context
        local sector = dlg_context
        local sector_id = dlg_context.Id

        local queue, all = HUDA_MilitiaTransfer:GetTables(sector_id, operation_id)

        if self.Id == "idAllItems" then
            local item, idx = table.find_value(all, "id", ctrl.context.id)
            local itm = item and SectorOperationRepairItems_GetItemFromData(item)

            local itm_width = itm and itm:IsLargeItem() and 2 or 1
            -- if SectorOperationItems_ItemsCount(queue) + itm_width <= 9 then
            table.remove(all, idx)
            table.insert(queue, item)
            -- end
        else
            local item, idx = table.find_value(queue, "id", ctrl.context.id)
            table.remove(queue, idx)
            table.insert(all, item)
        end
        self.drag_win:delete()
        self.drag_win = false
        self:StopDrag()
        NetSyncEvent("HudaOperationItemsUpdateLists", sector_id, operation_id, TableWithItemsToNet(all),
            TableWithItemsToNet(queue))
        SectorOperation_ItemsUpdateItemLists(dlg:ResolveId("node"))
        return "break"
        ---end
    end
end

function XDragContextWindowTransfer:OnDragStart(pt, button)
    if self.disable_drag then return false end
    for i, wnd in ipairs(self) do
        if wnd:MouseInWindow(pt) and not IsKindOf(wnd.idItem, "XTransferItemTile") and wnd.idItem:GetEnabled() then
            return wnd
        end
    end

    return false
end

function XDragContextWindowTransfer:OnHoldDown(pt, button) end

function XDragContextWindowTransfer:IsDropTarget(drag_win, pt, source) return not self.disable_drag end

function XDragContextWindowTransfer:OnDrop(drag_win, pt, drag_source_win) end

function XDragContextWindowTransfer:OnDropEnter(drag_win, pt, drag_source_win) end

function XDragContextWindowTransfer:OnDropLeave(drag_win, pt, source) end

function XDragContextWindowTransfer:OnDragDrop(target, drag_win, drop_res, pt)
    if not drag_win or drag_win == target then
        return
    end
    target = target or self
    local self_slot = self.slot_name
    local target_slot = target.slot_name
    local target_wnd = target
    for i, wnd in ipairs(target) do
        if wnd:MouseInWindow(pt) then
            target_wnd = wnd
            break
        end
    end

    local operation_id   = self.context[1].operation
    local dlg            = GetDialog(self) or GetDialog(target_wnd)
    local dlg_context    = dlg and dlg.context
    target_wnd           = target_wnd or drag_win
    local context        = drag_win.context
    local target_context = target_wnd:GetContext()
    local sector         = dlg_context
    local sector_id      = dlg_context.Id
    local self_queue, target_queue

    local a_queue, a_all = HUDA_MilitiaTransfer:GetTables(sector_id, operation_id)

    if self_slot == "ItemsQueue" then
        self_queue = a_queue
    elseif self_slot == "AllItems" then
        self_queue = a_all or {}
    end
    if target_slot == "ItemsQueue" then
        target_queue = a_queue
    elseif target_slot == "AllItems" then
        target_queue = a_all or {}
    end

    local cur_idx    = table.find(self_queue, "id", context.id)
    local target_idx = table.find(target_queue, "id", target_context.id)
    local itm        = self_queue[cur_idx]
    local item       = itm and SectorOperationRepairItems_GetItemFromData(itm)
    local itm_width  = item and item:IsLargeItem() and 2 or 1

    if self_slot == target_slot then
        if cur_idx then
            if target_idx then
                target_queue[cur_idx], target_queue[target_idx] = target_queue[target_idx], target_queue[cur_idx]
            else
                local itm = table.remove(self_queue, cur_idx)
                target_queue[#target_queue + 1] = itm
            end
        end
    else
        local itm
        itm = table.remove(self_queue, cur_idx)
        if not target_idx then
            target_queue[#target_queue + 1] = itm
        else
            table.insert(target_queue, target_idx, itm)
        end
    end
    local s_queue, s_all = HUDA_MilitiaTransfer:GetTables(sector_id, operation_id)
    local all            = target_slot == "AllItems" and target_queue or self_slot == "AllItems" and self_queue or s_all
    local queued         = target_slot == "ItemsQueue" and target_queue or self_slot == "ItemsQueue" and self_queue or
        s_queue

    drag_win:delete()
    NetSyncEvent("HudaOperationItemsUpdateLists", sector_id, operation_id, TableWithItemsToNet(all),
        TableWithItemsToNet(queued))
    local mercs = GetOperationProfessionals(sector_id, operation_id)
    local eta = next(mercs) and GetOperationTimeLeft(mercs[1], operation_id) or 0
    local timeLeft = eta and Game.CampaignTime + eta
    AddTimelineEvent("activity-temp", timeLeft, "operation", { operationId = operation_id, sectorId = sector_id })

    self:RespawnContent()
    target:RespawnContent()
    local node = self:ResolveId("node")
    node:OnContextUpdate(node:GetContext())
    local node = target:ResolveId("node")
    node:OnContextUpdate(node:GetContext())
    ObjModified(target_queue)
    ObjModified(self_queue)
end