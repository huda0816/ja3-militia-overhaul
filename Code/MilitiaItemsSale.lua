GameVar("gv_HUDA_Item_Transfer", {})

function OnMsg.SatelliteTick()
	HUDA_MilitiaTransfer:CheckShipments()
end

DefineClass.HUDA_MilitiaTransfer = {
    opId = "HUDA_MilitiaSellItems",
    aid = "sector_transfer",
    csId = "city_stash",
    qid = "sector_transfer_queue",
    destId = "sector_destination",
    locations = {
        {
            type = "export",
            name = "Arulco"
        }
    }
}

function HUDA_MilitiaTransfer:GetIds()
    return self.qid, self.aid
end

function HUDA_MilitiaTransfer:GetOpId()
    return self.opId
end

function HUDA_MilitiaTransfer:CheckShipments()

end

function HUDA_MilitiaTransfer:QueueHasItems(sectorId)
    local queue = self:GetTables(sectorId, self.opId) or {}

    return #queue > 0
end

function HUDA_MilitiaTransfer:GetTotalPrice(sectorId)
    
    local sector = gv_Sectors[sectorId]

    local queue = self:GetTables(sectorId, self.opId) or {}

    local total = 0

    for idx, itm in ipairs(queue) do
        total = total + self:GetItemPrice(itm)
    end

    return total
end

-- function HUDA_MilitiaTransfer:OnComplete(op, sector, mercs)
function HUDA_MilitiaTransfer:OnComplete(sectorId)

    local order_id = Game.CampaignTime .. "_" .. sectorId
    local due_time = Game.CampaignTime + 1 * const.Scale.day
    local shipment_context = { sectorId = sectorId, items = {} }
    local shipment_items = {}
	AddTimelineEvent(
		"bla_send_items", 
		due_time, 
		"sector_shipment", 
		shipment_context
	)

    gv_HUDA_Item_Transfer = gv_HUDA_Item_Transfer or {}

    gv_HUDA_Item_Transfer[order_id] = { order_id = order_id, departure_time = Game.CampaignTime, due_time = due_time, items = shipment_items, sector_id = sectorId }

    local shipment_details = gv_HUDA_Item_Transfer[order_id]
	
	Msg("HUDAItemsTransferSent", shipment_details)

end

function HUDA_MilitiaTransfer:GetItemPrice(item)
    return item.cost and MulDivRound(item.cost, item.condition, 750) or 0
end

function HUDA_MilitiaTransfer:AddAll(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue, all = self:GetTables(sectorId, self.opId)

    for idx, item in ipairs(all) do
        if not table.find(queue, "id", item.id) then
            table.insert(queue, item)
        end
    end

    all = {}

    self:SetQueue(sector, self.opId, queue)
    self:SetAll(sector, self.opId, all)

    NetSyncEvent("HudaOperationItemsUpdateLists", sectorId, self.opId, TableWithItemsToNet(all),
        TableWithItemsToNet(queue))
end

function HUDA_MilitiaTransfer:ClearAll(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue, all = self:GetTables(sectorId, self.opId)

    for idx, item in ipairs(queue) do
        if not table.find(all, "id", item.id) then
            table.insert(all, item)
        end
    end

    queue = {}

    self:SetQueue(sector, self.opId, queue)
    self:SetAll(sector, self.opId, all)

    NetSyncEvent("HudaOperationItemsUpdateLists", sectorId, self.opId, TableWithItemsToNet(all),
        TableWithItemsToNet(queue))
end

function HUDA_MilitiaTransfer:SetTransferDesitination(currentSectorId, sectorId)
    local sector = gv_Sectors[currentSectorId]
    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}
    sector.custom_operations[self.opId][self.destId] = sectorId
    return sector.custom_operations[self.opId][self.destId]
end

function HUDA_MilitiaTransfer:SetCraftOperation()
    local id = CraftOperationId:new()
    id:SetGroup("Default")
    id:SetId(self.opId)
    CraftOperationId:SaveAll("force")
end

function HUDA_MilitiaTransfer:GetTransferLocations(currentSectorId)
    local locations = table.copy(self.locations)

    table.insert(locations, 1, {
        type = "own",
        sectorId = currentSectorId,
        travelTime = 0
    })

    for sectorId, sector in pairs(gv_Sectors) do
        if sectorId ~= currentSectorId and sector.Side == "player1" then -- and (sector.MilitiaBase or sector.Guardpost) then
            local travelTime = GetSectorTravelTime(currentSectorId, sectorId)

            local location = {
                type = "base",
                sectorId = sectorId,
                travelTime = DivRound(travelTime, 3600)
            }

            table.insert(locations, location)
        end
    end

    return locations
end

function HUDA_MilitiaTransfer:GetItemsFromCity(sectorId)
    local sector = gv_Sectors[sectorId]

    sector.custom_operations = sector.custom_operations or {}

    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}

    local cityStash = sector.custom_operations[self.opId][self.csId] or nil

    if next(cityStash) then
        return cityStash
    end

    local city = sector.City

    local citySectors = HUDA_GetControlledCitySectors(city)

    local cityStash = {}

    for _, sId in ipairs(citySectors) do
        if sId ~= sectorId then
            local sector = gv_Sectors[sId]
            local stash = sector.sector_inventory or empty_table

            for cidx, container in ipairs(stash) do
                if container[2] then -- is opened
                    local items = container[3] or empty_table

                    for idx, item in ipairs(items) do
                        if not table.find(cityStash, "id", item.id) then
                            table.insert(cityStash,
                                {
                                    unit = "stash",
                                    id = item.id,
                                    amount = item.Amount or 1,
                                    context = "transfer",
                                    cost = item.Cost,
                                    condition = item.Condition
                                })
                        end
                    end
                end
            end
        end
    end

    sector.custom_operations[self.opId][self.csId] = cityStash

    return cityStash
end

function HUDA_MilitiaTransfer:GetItemsToTransfer(sector_id, operation_id)
    if next(gv_Sectors[sector_id].custom_operations[operation_id] and gv_Sectors[sector_id].custom_operations[operation_id][self.aid] or 0) then
        return gv_Sectors[sector_id].custom_operations[operation_id][self.aid]
    end

    local all_to_sell = {}

    local queue = empty_table

    if gv_Sectors[sector_id].custom_operations and gv_Sectors[sector_id].custom_operations[operation_id] then
        queue = gv_Sectors[sector_id].custom_operations[operation_id][self.qid] or empty_table
    end

    local stash = gv_Sectors[sector_id].sector_inventory or empty_table

    for cidx, container in ipairs(stash) do
        if container[2] then -- is opened
            local items = container[3] or empty_table

            for idx, item in ipairs(items) do
                if not table.find(all_to_sell, "id", item.id) and not table.find(queue, "id", item.id) then
                    table.insert(all_to_sell,
                        {
                            unit = "stash",
                            id = item.id,
                            amount = item.Amount or 1,
                            context = "transfer",
                            cost = item
                                .Cost,
                            condition = item.Condition
                        })
                end
            end
        end
    end

    gv_Sectors[sector_id].custom_operations[operation_id] = gv_Sectors[sector_id].custom_operations[operation_id] or {}

    gv_Sectors[sector_id].custom_operations[operation_id][self.aid] = all_to_sell
    return all_to_sell
end

function HUDA_MilitiaTransfer:GetItemDef(data)
    return data and (data.id and g_ItemIdToItem[data.id] or data[1])
end

function HUDA_MilitiaTransfer:GetTables(sector_id, operation_id, qid, aid)
    local sector = gv_Sectors[sector_id]

    local all, queue = {}, {}

    qid = qid or self.qid
    aid = aid or self.aid

    if sector.custom_operations and sector.custom_operations[operation_id] then
        all = sector.custom_operations[operation_id][aid] or {}

        ObjModified(sector.custom_operations[operation_id][aid])

        queue = sector.custom_operations[operation_id][qid] or {}

        ObjModified(sector.custom_operations[operation_id][qid])
    end

    return queue, all
end

function HUDA_MilitiaTransfer:SetQueue(sector, operation_id, queue)
    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[operation_id] = sector.custom_operations[operation_id] or {}
    sector.custom_operations[operation_id][self.qid] = queue
    return sector.custom_operations[operation_id][self.qid]
end

function HUDA_MilitiaTransfer:SetAll(sector, operation_id, all)
    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[operation_id] = sector.custom_operations[operation_id] or {}
    sector.custom_operations[operation_id][self.aid] = all
    return sector.custom_operations[operation_id][self.aid]
end

function NetSyncEvents.HudaOperationItemsUpdateLists(sector_id, operation_id, sector_items, sector_items_queued)
    OperationsSync_SuspendObjModified()
    local sector = gv_Sectors[sector_id]
    NetSyncEvents.HudaChangeSectorOperationItemsOrder(sector_id, operation_id, sector_items, sector_items_queued)
    local s_queued, s_all = HUDA_MilitiaTransfer:GetTables(sector_id, operation_id)
    SectorOperation_CraftTotalTime(sector_id, operation_id)
    RecalcOperationETAs(sector, operation_id, "stopped")
    ObjModified(sector)
    ObjModified(s_queued)
    ObjModified(s_all)
    --SectorOperation_ItemsUpdateItemLists() --not needed it seems	
end

function NetSyncEvents.HudaChangeSectorOperationItemsOrder(sector_id, operation_id, sector_items, sector_items_queued)
    OperationsSync_SuspendObjModified()
    local sector = gv_Sectors[sector_id]
    local quid, allid = HUDA_MilitiaTransfer:GetIds()

    sector.custom_operations[operation_id] = sector.custom_operations[operation_id] or {}

    sector.custom_operations[operation_id][allid] = TableWithItemsFromNet(sector_items)
    sector.custom_operations[operation_id][quid] = TableWithItemsFromNet(sector_items_queued)

    ObjModified(sector.custom_operations[operation_id][allid])
    ObjModified(sector.custom_operations[operation_id][quid])

    local tbl = HUDA_MilitiaTransfer:SetQueue(sector, operation_id, TableWithItemsFromNet(sector_items_queued))
    -- ObjModified(sector)
    ObjModified(tbl)
end

PlaceObj('XTemplate', {
    __is_kind_of = "XDialog",
    group = "Zulu",
    id = "MilitiaItemsSaleSelectItemsUI",
    PlaceObj('XTemplateWindow', {
        '__class', "XDialog",
        'Id', "idList",
        'IdNode', false,
        'Dock', "box",
        'OnContextUpdate', function(self, context, ...)
        print("hi i am there")
        --local node= self:ResolveId("node")
        --node.idMercsList:OnContextUpdate(GetOperationMercsListContext(context, GetActionsHost(self, true).mode_param))
    end,
        'HostInParent', true,
        'FocusOnOpen', "child",
    }, {
        PlaceObj('XTemplateFunc', {
            'name', "delete(self, ...)",
            'func', function(self, ...)
            if DragSource then
                DragSource:InternalDragStop(terminal.GetMousePos())
            end
            return XDialog.delete(self, ...)
        end,
        }),
        PlaceObj('XTemplateFunc', {
            'name', "OnKillFocus(self)",
            'func', function(self)
            if DragSource then
                DragSource:InternalDragStop(terminal.GetMousePos())
            end
            XDialog.OnKillFocus(self)
        end,
        }),
        PlaceObj('XTemplateWindow', {
            '__context', function(parent, context)
            return GetOperationMercsListContext(context,
                GetActionsHost(parent, true).mode_param)
        end,
            '__class', "XContextWindow",
            'VAlign', "top",
            'Clip', "self",
        }, {
            PlaceObj('XTemplateWindow', {
                '__class', "XContentTemplate",
                'Id', "idMercsList",
                'IdNode', false,
                'VAlign', "top",
                'MaxWidth', 800,
                'Clip', "self",
            }, {
                PlaceObj('XTemplateWindow', {
                    '__class', "XText",
                    'Id', "idText",
                    'VAlign', "top",
                    'FoldWhenHidden', true,
                    'HandleMouse', false,
                    'TextStyle', "PDAActivitiesSubTitleDark",
                    'Translate', true,
                    'HideOnEmpty', true,
                    'TextVAlign', "center",
                }),
                PlaceObj('XTemplateWindow', {
                    'Margins', box(24, 18, 24, 18),
                    'LayoutMethod', "VList",
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__condition', function(parent, context)
                        -- local operation = context.operation or context[1] and context[1].operation
                        return true
                    end,
                        'LayoutMethod', "HList",
                    }, {
                        PlaceObj('XTemplateWindow', {
                            'comment', "items queue",
                            'VAlign', "top",
                            'LayoutMethod', "VList",
                            'Dock', "right",
                            'HAlign', "right",
                            'MinWidth', 340,
                            'MaxWidth', 340,
                            'Clip', "parent & self",
                        }, {
                            PlaceObj('XTemplateWindow', {
                                'comment', "items title",
                                'LayoutMethod', "VList",
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XText",
                                    'Id', "idQueuedText",
                                    'VAlign', "top",
                                    'FoldWhenHidden', true,
                                    'HandleMouse', false,
                                    'TextStyle', "PDAActivitiesSubTitleDark",
                                    'Translate', true,
                                    'Text', T(7145947544250815, --[[XTemplate SectorOperationSelectItemsUI Text]]
                                    "Items to Transfer"),
                                    'HideOnEmpty', true,
                                    'TextVAlign', "center",
                                }),
                                PlaceObj('XTemplateWindow', {
                                    'VAlign', "top",
                                    'MinHeight', 2,
                                    'MaxHeight', 2,
                                    'Background', RGBA(124, 130, 96, 255),
                                    'Transparency', 160,
                                }),
                            }),
                            PlaceObj('XTemplateWindow', {
                                '__class', "XContentTemplate",
                                'Id', "idQueueList",
                                'Margins', box(0, 0, 0, 0),
                                'OnContextUpdate', function(self, context, ...)
                                XContextWindow.OnContextUpdate(self, context, ...)
                                local node = self.parent:ResolveId("node")
                                local sector = GetDialog(self.parent).context
                                local sector_id = sector.Id
                                local operation_id = context[1].operation
                                local mercs = GetOperationProfessionals(sector_id, operation_id)
                                local time = next(mercs) and mercs[1].OperationInitialETA or 0
                                if time < 0 then time = 0 end
                                node.idQueuedText:SetText(T { 5393018983390829, "Items to Transfer<right><GameColorF><image UI/SectorOperations/T_Icon_Activity_Resting 1500 130 128 120><timeDuration(time)>", time = time })
                                local timeLeft = time and Game.CampaignTime + time
                                AddTimelineEvent("activity-temp", timeLeft, "operation",
                                    { operationId = operation_id, sectorId = sector_id })
                            end,
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XScrollArea",
                                    'Id', "idItemsQueue",
                                    'IdNode', false,
                                    'Margins', box(0, 10, 0, 0),
                                    'VAlign', "top",
                                    'MinHeight', 440,
                                    'MaxHeight', 440,
                                    'UniformColumnWidth', true,
                                    'UniformRowHeight', true,
                                    'Clip', "self",
                                    'VScroll', "idScrollbarQueue",
                                    'MouseWheelStep', 100,
                                }, {
                                    -- PlaceObj('XTemplateFunc', {
                                    --     'name', "OnShortcut(self, shortcut, source, ...)",
                                    --     'func', function(self, shortcut, source, ...)
                                    --     if shortcut == "RightThumbDown" then
                                    --         return self:OnMouseWheelBack()
                                    --     elseif shortcut == "RightThumbUp" then
                                    --         return self:OnMouseWheelForward()
                                    --     end
                                    --     return XScrollArea.OnShortcut(self, shortcut, source, ...)
                                    -- end,
                                    -- }),
                                    -- PlaceObj('XTemplateFunc', {
                                    --     'name', "Open(self)",
                                    --     'func', function(self)
                                    --     XScrollArea.Open(self)
                                    --     self:SetFocus()
                                    --     self.LeftThumbScroll = true
                                    -- end,
                                    -- }),
                                    -- PlaceObj('XTemplateFunc', {
                                    --     'name', "Open(self)",
                                    --     'func', function(self)
                                    --     XContentTemplate.Open(self)
                                    --     self:OnContextUpdate(self.context, true)
                                    -- end,
                                    -- }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XDragContextWindowSale",
                                        'Id', "idQueue",
                                        'Margins', box(0, 0, 0, 0),
                                        'GridStretchX', false,
                                        'GridStretchY', false,
                                        'LayoutMethod', "HWrap",
                                        'LayoutHSpacing', 6,
                                        'LayoutVSpacing', 10,
                                        'ChildrenHandleMouse', true,
                                        'ContextUpdateOnOpen', false,
                                        'slot_name', "ItemsQueue",
                                    }, {
                                        PlaceObj('XTemplateForEach', {
                                            'comment', "item",
                                            'array', function(parent, context)
                                            local sector_id = GetDialog(parent).context.Id
                                            -- Inspect(HUDA_MilitiaTransfer:GetTables(sector_id, "HUDA_MilitiaSellItems"))
                                            local queue = HUDA_MilitiaTransfer:GetTables(sector_id,
                                                "HUDA_MilitiaSellItems")
                                            return queue
                                        end,
                                            '__context', function(parent, context, item, i, n)
                                            return
                                                HUDA_MilitiaTransfer:GetItemDef(item)
                                        end,
                                            'run_after', function(child, context, item, i, n, last)
                                            rawset(child, "slot_idx", i)
                                            local ctx = HUDA_MilitiaTransfer:GetItemDef(item)
                                            child:SetContext(ctx)
                                            rawset(child.idItem, "slot", item.slot)
                                            rawset(child.idItem, "item", item)
                                            child.idItem:SetContext(ctx)
                                            child.idItem.idText:SetVisible(true)
                                            child.parent:SetChildrenHandleMouse(true)
                                            -- child.idItem.idText:SetText(T { 6419711383270828, "$<money> | <amount>", amount = item.amount, money = "1000" })
                                            child.idItem.idText:SetText("blu")
                                        end,
                                        }, {
                                            PlaceObj('XTemplateWindow', {
                                                '__class', "XContextWindow",
                                                'IdNode', true,
                                                'HAlign', "left",
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XFrame",
                                                    'IdNode', false,
                                                    'HAlign', "left",
                                                    'BorderColor', RGBA(255, 255, 255, 0),
                                                    'Background', RGBA(255, 255, 255, 0),
                                                    'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBackground', RGBA(255, 255, 255, 0),
                                                    'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XActivityItem",
                                                        'Id', "idItem",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'VAlign', "center",
                                                        'OnLayoutComplete', function(self)
                                                        self.idText:SetPadding(box(2, 2, 2, 2))
                                                        self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                    end,
                                                        'UniformColumnWidth', true,
                                                        'UniformRowHeight', true,
                                                    }, {
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "IsDropTarget(self,drag_win, pt, source)",
                                                            'func', function(self, drag_win, pt, source)
                                                            return false
                                                        end,
                                                        }),
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "Open(self, ...)",
                                                            'func', function(self, ...)
                                                            local node = self:ResolveId("node")
                                                            XInventoryItem.Open(self, ...)
                                                            self.idItemPad:SetImage(false)
                                                            self.idItemPad:SetMinWidth(self:GetMinWidth())
                                                            self.idItemPad:SetMaxWidth(self:GetMaxWidth())
                                                            self.idItemPad:SetBackground(GameColors.B)
                                                            self.idText:SetPadding(box(2, 2, 2, 2))
                                                            self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                        end,
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                        PlaceObj('XTemplateForEach', {
                                            'comment', "item empty",
                                            'array', function(parent, context)
                                            local sector     = GetDialog(parent).context.Id
                                            local queue      = HUDA_MilitiaTransfer:GetTables(sector,
                                                "HUDA_MilitiaSellItems")
                                            local full_table = queue
                                            local to_return  = {}
                                            local count      = 6
                                            for i, itm_data in ipairs(full_table) do
                                                local itm = HUDA_MilitiaTransfer:GetItemDef(itm_data)
                                                count = count - (itm:IsLargeItem() and 2 or 1)
                                            end
                                            count = Max(3, count)
                                            for i = 1, count do
                                                to_return[i] = i
                                            end
                                            return to_return
                                        end,
                                        }, {
                                            PlaceObj('XTemplateWindow', {
                                                '__class', "XContextWindow",
                                                'IdNode', true,
                                                'HAlign', "left",
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XFrame",
                                                    'IdNode', false,
                                                    'HAlign', "left",
                                                    'BorderColor', RGBA(255, 255, 255, 0),
                                                    'Background', RGBA(255, 255, 255, 0),
                                                    'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBackground', RGBA(255, 255, 255, 0),
                                                    'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XOperationItemTile",
                                                        'Id', "idItem",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'VAlign', "center",
                                                        'MinWidth', 72,
                                                        'MinHeight', 72,
                                                        'MaxWidth', 72,
                                                        'MaxHeight', 72,
                                                        'UniformColumnWidth', true,
                                                        'UniformRowHeight', true,
                                                    }, {
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "IsDropTarget(self,drag_win, pt, source)",
                                                            'func', function(self, drag_win, pt, source)
                                                            return false
                                                        end,
                                                        }),
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "Open(self, ...)",
                                                            'func', function(self, ...)
                                                            local node = self:ResolveId("node")
                                                            XInventoryItem.Open(self, ...)
                                                            self.idBackImage:SetImage(false)
                                                            self.idBackImage:SetMinWidth(self:GetMinWidth())
                                                            self.idBackImage:SetMaxWidth(self:GetMaxWidth())
                                                            self.idBackImage:SetBackground(GameColors.B)
                                                        end,
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                    }),
                                }),
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XZuluScroll",
                                    'Id', "idScrollbarQueue",
                                    'Margins', box(0, 10, 0, 0),
                                    'Dock', "right",
                                    'HAlign', "right",
                                    'ScaleModifier', point(800, 800),
                                    'Transparency', 125,
                                    'Target', "idItemsQueue",
                                    'AutoHide', true,
                                }),
                            }),
                        }),
                        PlaceObj('XTemplateWindow', {
                            'comment', "repair items",
                            'VAlign', "top",
                            'LayoutMethod', "VList",
                            'Dock', "left",
                            'HAlign', "left",
                            'MinWidth', 340,
                            'MaxWidth', 340,
                            'Clip', "parent & self",
                        }, {
                            PlaceObj('XTemplateWindow', {
                                'comment', "items title",
                                'LayoutMethod', "VList",
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XText",
                                    'Id', "idRepairItems",
                                    'VAlign', "top",
                                    'FoldWhenHidden', true,
                                    'HandleMouse', false,
                                    'TextStyle', "PDAActivitiesSubTitleDark",
                                    'Translate', true,
                                    'Text', T(9134641120670815, --[[XTemplate SectorOperationSelectItemsUI Text]]
                                    "Available Items"),
                                    'HideOnEmpty', true,
                                    'TextVAlign', "center",
                                }),
                                PlaceObj('XTemplateWindow', {
                                    'VAlign', "top",
                                    'MinHeight', 2,
                                    'MaxHeight', 2,
                                    'Background', RGBA(124, 130, 96, 255),
                                    'Transparency', 160,
                                }),
                            }),
                            PlaceObj('XTemplateWindow', {
                                '__class', "XContentTemplate",
                                'Id', "idAllList",
                                'Margins', box(0, 0, 0, 0),
                                'OnContextUpdate', function(self, context, ...)
                                XContextWindow.OnContextUpdate(self, context, ...)
                                local node = self.parent:ResolveId("node")
                                local sector_id = GetDialog(self.parent).context.Id
                                local operation_id = context[1].operation
                                local count = #(HUDA_MilitiaTransfer:GetItemsToTransfer(sector_id, operation_id) or empty_table)
                                local text = T { 9487645669860816, "Available Items<right><GameColorF><count>", count = count }
                                node.idRepairItems:SetText(text)
                            end,
                            }, {
                                -- PlaceObj('XTemplateFunc', {
                                --     'name', "Open(self)",
                                --     'func', function(self)
                                --     XContentTemplate.Open(self)
                                --     self:OnContextUpdate(self.context, true)
                                -- end,
                                -- }),
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XScrollArea",
                                    'Id', "idItemsList",
                                    'IdNode', false,
                                    'Margins', box(0, 10, 0, 0),
                                    'VAlign', "top",
                                    'MinHeight', 440,
                                    'MaxHeight', 440,
                                    'UniformColumnWidth', true,
                                    'UniformRowHeight', true,
                                    'Clip', "self",
                                    'VScroll', "idScrollbarAll",
                                    'MouseWheelStep', 100,
                                }, {
                                    PlaceObj('XTemplateFunc', {
                                        'name', "OnShortcut(self, shortcut, source, ...)",
                                        'func', function(self, shortcut, source, ...)
                                        if shortcut == "RightThumbDown" then
                                            return self:OnMouseWheelBack()
                                        elseif shortcut == "RightThumbUp" then
                                            return self:OnMouseWheelForward()
                                        end
                                        return XScrollArea.OnShortcut(self, shortcut, source, ...)
                                    end,
                                    }),
                                    PlaceObj('XTemplateFunc', {
                                        'name', "Open(self)",
                                        'func', function(self)
                                        XScrollArea.Open(self)
                                        self:SetFocus()
                                        self.LeftThumbScroll = true
                                    end,
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XDragContextWindowSale",
                                        'Id', "idAllItems",
                                        'HAlign', "left",
                                        'GridStretchX', false,
                                        'GridStretchY', false,
                                        'LayoutMethod', "HWrap",
                                        'LayoutHSpacing', 6,
                                        'LayoutVSpacing', 10,
                                        'ChildrenHandleMouse', true,
                                        'ContextUpdateOnOpen', false,
                                        'slot_name', "AllItems",
                                    }, {
                                        PlaceObj('XTemplateForEach', {
                                            'comment', "item",
                                            'array', function(parent, context)
                                            local sector_id = GetDialog(parent).context.Id
                                            local operation_id = context[1].operation
                                            return HUDA_MilitiaTransfer:GetItemsToTransfer(sector_id, operation_id) or
                                                empty_table
                                        end,
                                            'condition', function(parent, context, item, i) return not item.hidden end,
                                            '__context', function(parent, context, item, i, n)
                                            return
                                                HUDA_MilitiaTransfer:GetItemDef(item)
                                        end,
                                            'run_after', function(child, context, item, i, n, last)
                                            rawset(child, "slot_idx", i)
                                            local ctx = HUDA_MilitiaTransfer:GetItemDef(item)
                                            child:SetContext(ctx)
                                            rawset(child.idItem, "slot", item.slot)
                                            rawset(child.idItem, "item", item)
                                            child.idItem:SetContext(ctx)
                                            child.idItem.idText:SetVisible(true)
                                            child.parent:SetChildrenHandleMouse(true)
                                            -- child.idItem.idText:SetText(T { 6419711383270828, "bla", amount = item.amount, money = "1000" })
                                            child.idItem.idText:SetText("blu")
                                        end,
                                        }, {
                                            PlaceObj('XTemplateWindow', {
                                                '__class', "XContextWindow",
                                                'IdNode', true,
                                                'HAlign', "left",
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XFrame",
                                                    'IdNode', false,
                                                    'HAlign', "left",
                                                    'BorderColor', RGBA(255, 255, 255, 0),
                                                    'Background', RGBA(255, 255, 255, 0),
                                                    'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBackground', RGBA(255, 255, 255, 0),
                                                    'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XActivityItem",
                                                        'Id', "idItem",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'VAlign', "center",
                                                        'OnLayoutComplete', function(self)
                                                        self.idText:SetPadding(box(2, 2, 2, 2))
                                                        self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                    end,
                                                        'UniformColumnWidth', true,
                                                        'UniformRowHeight', true,
                                                    }, {
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "IsDropTarget(self,drag_win, pt, source)",
                                                            'func', function(self, drag_win, pt, source)
                                                            return false
                                                        end,
                                                        }),
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "Open(self, ...)",
                                                            'func', function(self, ...)
                                                            local node = self:ResolveId("node")
                                                            XInventoryItem.Open(self, ...)
                                                            self.idItemPad:SetImage(false)
                                                            self.idItemPad:SetMinWidth(self:GetMinWidth())
                                                            self.idItemPad:SetMaxWidth(self:GetMaxWidth())
                                                            self.idItemPad:SetBackground(GameColors.B)
                                                            self.idText:SetPadding(box(2, 2, 2, 2))
                                                            self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                        end,
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                        PlaceObj('XTemplateForEach', {
                                            'comment', "item empty",
                                            'array', function(parent, context)
                                            local sector     = GetDialog(parent).context.Id
                                            local queue, all = HUDA_MilitiaTransfer:GetTables(sector,
                                                "HUDA_MilitiaSellItems")
                                            local to_return  = {}
                                            local count      = next(all or {}) and 0 or 4
                                            for i = 1, count do
                                                to_return[i] = i
                                            end
                                            return to_return
                                        end,
                                        }, {
                                            PlaceObj('XTemplateWindow', {
                                                '__class', "XContextWindow",
                                                'IdNode', true,
                                                'HAlign', "left",
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XFrame",
                                                    'IdNode', false,
                                                    'HAlign', "left",
                                                    'BorderColor', RGBA(255, 255, 255, 0),
                                                    'Background', RGBA(255, 255, 255, 0),
                                                    'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                    'FocusedBackground', RGBA(255, 255, 255, 0),
                                                    'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XOperationItemTile",
                                                        'Id', "idItem",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'VAlign', "center",
                                                        'MinWidth', 72,
                                                        'MinHeight', 72,
                                                        'MaxWidth', 72,
                                                        'MaxHeight', 72,
                                                        'UniformColumnWidth', true,
                                                        'UniformRowHeight', true,
                                                    }, {
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "IsDropTarget(self,drag_win, pt, source)",
                                                            'func', function(self, drag_win, pt, source)
                                                            return false
                                                        end,
                                                        }),
                                                        PlaceObj('XTemplateFunc', {
                                                            'name', "Open(self, ...)",
                                                            'func', function(self, ...)
                                                            local node = self:ResolveId("node")
                                                            XInventoryItem.Open(self, ...)
                                                            self.idBackImage:SetImage(false)
                                                            self.idBackImage:SetMinWidth(self:GetMinWidth())
                                                            self.idBackImage:SetMaxWidth(self:GetMaxWidth())
                                                            self.idBackImage:SetBackground(GameColors.B)
                                                        end,
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                    }),
                                }),
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XZuluScroll",
                                    'Id', "idScrollbarAll",
                                    'Margins', box(0, 10, 0, 0),
                                    'Dock', "right",
                                    'HAlign', "right",
                                    'ScaleModifier', point(800, 800),
                                    'Transparency', 125,
                                    'Target', "idItemsList",
                                    'AutoHide', true,
                                }),
                            }),
                        }),
                    }),
                }),
            }),
        }),
    }),
})







local SectorOperationUI = XTemplates.SectorOperationMainUI



local OriginalFunc = SectorOperationUI[1].func

SectorOperationUI[1][1].func = function(self, ...)
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

if FirstLoad then
    SectorOperationUI[1].InternalModes = SectorOperationUI[1].InternalModes .. ", pick_item_to_sell"

    local backAction = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SectorOperationsUI"],
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

    local startAction = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["SectorOperationMainUI"],
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

    table.insert(SectorOperationUI[1][5][3][1][1], PlaceObj('XTemplateAction', {
        'comment', "sell items",
        'ActionId', "PickSaleItem",
        'ActionName', T(6304237736690816, --[[XTemplate SectorOperationMainUI ActionName]] "Pick Items"),
        'ActionToolbar', "ActionBar",
        'ActionShortcut', "P",
        'ActionGamepad', "ButtonY",
        'ActionState', function(self, host)
        local operation_id = host.mode_param.operation
        local sector = host.context
        local operation = SectorOperations[operation_id]
        if not operation_id == HUDA_MilitiaTransfer:GetOpId() then
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

    table.insert(SectorOperationUI[1][5][3][1], 1, PlaceObj('XTemplateMode', {
        'comment', "sell items",
        'mode', "pick_item_to_sell",
    }, {
        PlaceObj('XTemplateWindow', {
            '__class', "XContentTemplate",
            'IdNode', false,
        }, {
            PlaceObj('XTemplateTemplate', {
                '__template', "MilitiaItemsSaleSelectItemsUI",
                'VAlign', "top",
            }),
        }),
        PlaceObj('XTemplateAction', {
            'ActionId', "PickSeller",
            'ActionName', T(1982441778220815, --[[XTemplate SectorOperationMainUI ActionName]] "Pick Logistician"),
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
            'ActionName', T(2378413941050816, --[[XTemplate SectorOperationMainUI ActionName]] "Add all"),
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
            -- NetSyncEvent("RecalcOperationETAs", sector.Id, "RepairItems", true)
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
            'ActionName', T(2378413941050816, --[[XTemplate SectorOperationMainUI ActionName]] "Clear all"),
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
            -- NetSyncEvent("RecalcOperationETAs", sector.Id, "RepairItems", true)
            local dlg = host.idBase.idMain
            SectorOperation_ItemsUpdateItemLists(dlg)
        end,
            'FXMouseIn', "activityAssignStartHover",
            'FXPress', "activityAssignStartPress",
            'FXPressDisabled', "activityAssignStartDisabled",
            'replace_matching_id', true,
        }),
    }))

    table.insert(SectorOperationUI[1][5], 1, PlaceObj('XTemplateMode', {
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
            '__template', "MilitiaItemsSaleSectorPicker",
        }),
    })
    )
end


DefineClass.XDragContextWindowSale = {
    __parents = { "XContentTemplate", "XDragAndDropControl" },
    properties = {
        { category = "General", id = "slot_name",    name = "Slot Name",    editor = "text", default = "", },
        { category = "General", id = "disable_drag", name = "Disable Drag", editor = "bool", default = false, },
    },

    ClickToDrag = true,
    ClickToDrop = true,
}

function XDragContextWindowSale:OnMouseButtonClick(pos, button)
    return XDragAndDropControl.OnMouseButtonClick(self, pos, button)
end

function XDragContextWindowSale:OnMouseButtonDoubleClick(pos, button)
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

function XDragContextWindowSale:OnDragStart(pt, button)
    if self.disable_drag then return false end
    for i, wnd in ipairs(self) do
        if wnd:MouseInWindow(pt) and not IsKindOf(wnd.idItem, "XOperationItemTile") and wnd.idItem:GetEnabled() then
            return wnd
        end
    end

    return false
end

function XDragContextWindowSale:OnHoldDown(pt, button) end

function XDragContextWindowSale:IsDropTarget(drag_win, pt, source) return not self.disable_drag end

function XDragContextWindowSale:OnDrop(drag_win, pt, drag_source_win) end

function XDragContextWindowSale:OnDropEnter(drag_win, pt, drag_source_win) end

function XDragContextWindowSale:OnDropLeave(drag_win, pt, source) end

function XDragContextWindowSale:OnDragDrop(target, drag_win, drop_res, pt)
    
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

PlaceObj('XTemplate', {
    __is_kind_of = "XContextWindow",
    group = "Zulu",
    id = "MilitiaItemsSaleSectorPicker",
    PlaceObj('XTemplateWindow', {
        '__class', "XContextWindow",
        'Id', "idOperationDescr",
        'Margins', box(26, 25, 26, 16),
        'Dock', "left",
        'MinWidth', 366,
        'MaxWidth', 366,
        'LayoutMethod', "VList",
    }, {
        PlaceObj('XTemplateWindow', {
            'comment', "title",
            'Dock', "top",
            'LayoutMethod', "HList",
        }, {
            PlaceObj('XTemplateWindow', {
                'Padding', box(2, 2, 2, 2),
            }, {
                PlaceObj('XTemplateWindow', {
                    '__condition', function(parent, context) return not context.operation end,
                    '__class', "XSquareWindow",
                    'IdNode', true,
                    'VAlign', "top",
                    'MinWidth', 54,
                    'MinHeight', 54,
                    'MaxHeight', 54,
                    'FoldWhenHidden', true,
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__class', "XText",
                        'Id', "idSector",
                        'HAlign', "center",
                        'VAlign', "center",
                        'Clip', false,
                        'TextStyle', "PDAActivitiesSectorIdBig",
                        'Translate', true,
                        'TextHAlign', "center",
                        'TextVAlign', "center",
                    }),
                    PlaceObj('XTemplateCode', {
                        'run', function(self, parent, context)
                        local sector = context.sector or GetDialog(parent).context
                        if sector then
                            local color, _, _, textColor = GetSectorControlColor(sector.Side)
                            local text = textColor .. sector.Id .. "</color>"
                            parent:SetBackground(color)
                            parent.idSector:SetText(T { 764093693143, "<SectorIdColored(id)>", id = sector.Id })
                        end
                    end,
                    }),
                }),
            }),
            PlaceObj('XTemplateWindow', {
                '__condition', function(parent, context) return not context.operation end,
                'MinWidth', 10,
                'MaxWidth', 10,
                'FoldWhenHidden', true,
            }),
            PlaceObj('XTemplateWindow', {
                '__class', "XContextWindow",
                'Margins', box(0, -10, 0, 0),
                'LayoutMethod', "VList",
                'LayoutVSpacing', -10,
                'UseClipBox', false,
                'ContextUpdateOnOpen', true,
                'OnContextUpdate', function(self, context, ...)
                local id = context.operation
                local operation = type(id) == "string" and SectorOperations[id] or id
                if context.operation then
                    local c_title = self:ResolveId("idTitle")
                    local c_subtitle = self:ResolveId("idSubtitle")
                    c_title:SetText(operation.display_name)
                    c_subtitle:SetText(operation.sub_title or "")
                end
            end,
            }, {
                PlaceObj('XTemplateWindow', {
                    '__class', "XText",
                    'Id', "idTitle",
                    'HAlign', "left",
                    'VAlign', "center",
                    'Clip', false,
                    'UseClipBox', false,
                    'TextStyle', "PDAActivitiesTitle",
                    'Translate', true,
                    'Text', T(502856071518, --[[XTemplate SectorOperationDescrUI Text]] "Operations"),
                    'TextVAlign', "center",
                }),
                PlaceObj('XTemplateWindow', {
                    '__class', "XText",
                    'Id', "idSubtitle",
                    'Margins', box(0, 4, 0, 0),
                    'VAlign', "top",
                    'Clip', false,
                    'UseClipBox', false,
                    'FoldWhenHidden', true,
                    'TextStyle', "PDAActivitiesSubTitle",
                    'Translate', true,
                    'HideOnEmpty', true,
                }, {
                    PlaceObj('XTemplateCode', {
                        'run', function(self, parent, context)
                        if IsKindOf(context, "SectorOperation") then
                            parent:SetText(context.sub_title)
                        else
                            local sector = context.sector
                            local operations = GetOperationsInSector(sector.Id)
                            local max = #operations
                            local num = table.count(operations, "enabled", true)
                            parent:SetText(T { 992386523035, "AVAILABLE <count>/<max>", count = num, max = max })
                        end
                    end,
                    }),
                }),
            }),
        }),
        PlaceObj('XTemplateWindow', {
            'comment', "line",
            '__class', "XFrame",
            'Dock', "top",
            'VAlign', "top",
            'Image', "UI/PDA/separate_line_vertical",
            'FrameBox', box(2, 0, 2, 0),
            'SqueezeY', false,
        }),
        PlaceObj('XTemplateWindow', {
            '__context', function(parent, context) return context.operation end,
            '__class', "XText",
            'Margins', box(0, 18, 0, 18),
            'Id', "idOperationDescrText",
            'HandleMouse', false,
            'TextStyle', "PDAActivityDescription",
            'Translate', true,
            'Text', T(4259299964110819, "Choose a transfer location to start the operation."),
            'Shorten', true,
        }),
        PlaceObj('XTemplateWindow', {
            'LayoutMethod', "VList",
        }, {
            PlaceObj('XTemplateWindow', {
                '__class', "XScrollArea",
                'Id', "idLocations",
                'IdNode', false,
                'Margins', box(0, 0, 10, 0),
                'VAlign', "top",
                'MinHeight', 340,
                'MaxHeight', 340,
                'UniformColumnWidth', true,
                'UniformRowHeight', true,
                'Clip', "self",
                'VScroll', "idScrollbarLocations",
                'MouseWheelStep', 100,
            }, {
                PlaceObj('XTemplateWindow', {
                    'LayoutMethod', "VList",
                }, {
                    PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                            return HUDA_MilitiaTransfer:GetTransferLocations(context.sector.Id)
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                            return item
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            local sectorId = item.sectorId
                            local sector = gv_Sectors[sectorId]
                            local currentSectorId = child.parent.parent.parent.parent.context.sector.Id
                            local currentSector = gv_Sectors[currentSectorId]

                            local text = ""
                            local iconText = "M"
                            local colorSide = "player1"

                            child:SetEnabled(false)

                            if context.type == "export" then
                                local total = HUDA_MilitiaTransfer:GetTotalPrice(currentSectorId)
                                text = "Sell to " .. context.name .. " (+$" .. total .. ")"
                                child:SetMargins(box(0, 0, 0, 15))
                                iconText = "$"
                                colorSide = "enemy1"
                                if HUDA_MilitiaTransfer:QueueHasItems(currentSectorId) then
                                    child:SetEnabled(true)
                                end
                            elseif context.type == "own" then
                                local cityItems = HUDA_MilitiaTransfer:GetItemsFromCity(sectorId)
                                if next(cityItems) then
                                    text = "Collect from " .. currentSector.City .. " (" .. #cityItems .. ")"
                                    child:SetMargins(box(0, 0, 0, 15))
                                    iconText = context.sectorId
                                    child:SetEnabled(true)
                                    child:SetVisible(true)
                                else
                                    child:SetVisible(false)
                                    child:SetFoldWhenHidden(true)
                                end
                            else
                                text = "Transfer: " ..
                                    sector.display_name ..
                                    (context.travelTime and " (" .. context.travelTime .. "h)" or "")
                                iconText = sectorId
                                if HUDA_MilitiaTransfer:QueueHasItems(currentSectorId) then
                                    child:SetEnabled(true)
                                end
                            end

                            local color, c2, c3, c4 = GetSectorControlColor(colorSide)

                            child.idSectorId:SetText(c4 .. iconText .. "</color>")
                            child.idSectorSquare:SetBackground(color)
                            child:SetText(text)
                        end
                    }, {
                        PlaceObj("XTemplateTemplate", {
                            "__template",
                            "PDACommonButton",
                            'Margins',
                            box(2, 0, 2, 0),
                            "Padding",
                            box(0, 0, 8, 0),
                            "MinHeight",
                            40,
                            "MaxHeight",
                            40,
                            "LayoutMethod",
                            "HList",
                            "LayoutHSpacing",
                            0,
                            "OnPress",
                            function(self, gamepad)
                                local sectorId = self.context.sectorId or "export"

                                HUDA_MilitiaTransfer:SetTransferDesitination(self.parent.context.sector.Id, sectorId)

                                local host = GetActionsHost(self, true)

                                host.idBase.idMain:StartOperation(host)
                            end
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XSquareWindow",
                                "Id",
                                "idSectorSquare",
                                "Margins",
                                box(0, 0, 5, 0),
                                "HAlign",
                                "left",
                                "VAlign",
                                "top",
                                "MinWidth",
                                38,
                                "MaxWidth",
                                38
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSectorId",
                                    "Margins",
                                    box(2, 0, 0, 0),
                                    "HAlign",
                                    "center",
                                    "VAlign",
                                    "center",
                                    "Clip",
                                    false,
                                    "TextStyle",
                                    "PDASatelliteRollover_SectorTitle",
                                    "Translate",
                                    true,
                                    "TextHAlign",
                                    "center",
                                    "TextVAlign",
                                    "center"
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idSectorGuards",
                                "Margins",
                                box(2, 0, 0, 0),
                                "HAlign",
                                "right",
                                "VAlign",
                                "center",
                                "Dock",
                                "right",
                                "Clip",
                                false,
                                "TextStyle",
                                "PDACommonButton",
                                "Translate",
                                true,
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center"
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnSetRollover(self, rollover)",
                                "func",
                                function(self, rollover)
                                    if not rollover then
                                        return
                                    end
                                    local sectorId = self.context.Id
                                end
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "IsSelectable(self)",
                                "func",
                                function(self)
                                    return true
                                end
                            }),
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "SetSelected(self, selected)",
                                "func",
                                function(self, selected)
                                    self:SetFocus(selected)
                                    self:SetImage(selected and "UI/PDA/os_system_buttons_yellow" or
                                        "UI/PDA/os_system_buttons")
                                end
                            })
                        })
                    })
                })
            }),
            PlaceObj('XTemplateWindow', {
                '__class', "XZuluScroll",
                'Id', "idScrollbarLocations",
                'Margins', box(0, 0, 10, 0),
                'Dock', "right",
                'HAlign', "right",
                'ScaleModifier', point(800, 800),
                'Transparency', 125,
                'Target', "idLocations",
                'AutoHide', true,
            }),
        })
    })
})


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


PlaceObj('SatelliteTimelineEventDef', {
	GetAssociatedMercs = function (self,eventCtx)
		return false
	end,
	GetDescriptionText = function (self,eventCtx)
		return T{9410283425210815, "The shipped items will arrive in <em><sector></em>", sector = eventCtx.sectorId}, self.Title, self.Hint
	end,
	GetIcon = function (self,eventCtx)
		return "UI/Icons/SateliteView/icon_ally", "UI/Icons/SateliteView/weapon_shipments"
	end,
	GetMapLocation = function (self,eventCtx)
		local sectorId = eventCtx.sectorId
		local sector = gv_Sectors[sectorId]
		if sector then
			return sector.XMapPosition
		end
	end,
	OnClick = function (self,eventCtx)
		return false
	end,
	Text = T(9410283425210815, "The shipped items will arrive"),
	Title = T(7701766354240816, "Shipment arrives"),
	group = "Default",
	id = "sector_shipment",
})