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
    if not gv_HUDA_Item_Transfer then
        return
    end

    local timeNow = Game.CampaignTime

    for id, shipment in pairs(gv_HUDA_Item_Transfer) do
        if shipment.due_time < timeNow then
            self:CompleteShipment(shipment, id)
        end
    end
end

function HUDA_MilitiaTransfer:CompleteShipment(shipment, id)
    local sector = gv_Sectors[shipment.destinationId]

    AddToSectorInventory(sector.Id, shipment.items)

    gv_HUDA_Item_Transfer[id] = nil

    CombatLog("important",
        T { 2580831680090825, "<em><itemnum> items</em> transfered from <em><sector></em> arrived in <em><destination></em>", itemnum = #shipment.items, destination = shipment.destinationId, sector = shipment.sectorId })
end

function HUDA_MilitiaTransfer:QueueHasItems(sectorId)
    local queue = self:GetTables(sectorId, self.opId) or {}

    return #queue > 0
end

function HUDA_MilitiaTransfer:GetFilter(sectorId)

    local sector = gv_Sectors[sectorId]

    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}

    return sector.custom_operations[self.opId].filter or {}

end

function HUDA_MilitiaTransfer:SetFilter(sectorId, filter)
    
    local sector = gv_Sectors[sectorId]

    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}

    sector.custom_operations[self.opId].filter = filter
end

function HUDA_MilitiaTransfer:Filter(sectorId, category, source)
    local sector = gv_Sectors[sectorId]

    local categories = self:GetFilter(sectorId)

    if table.find(categories, category) then
        table.remove_value(categories, category)
        if source then
            source:SetTextColor(GameColors.grey_70)
        end
    else
        table.insert(categories, category)
        if source then
            source:SetTextColor(GameColors.Player)
        end
    end

    self:SetFilter(sectorId, categories)
end

function HUDA_MilitiaTransfer:SetButtonState(button)

    local active = self:GetFilterState(button)

    if active then
        button:SetTextColor(GameColors.Player)
        button:SetRolloverText(T{ 258083168009082612, "Click to disable filter" })
    else
        button:SetTextColor(GameColors.grey_70)
        button:SetRolloverText(T{ 258083168009082713, "Click to enable filter" })
    end

end

function HUDA_MilitiaTransfer:GetFilterState(button)

    local sectorId = button.context.Id

    local filter = self:GetFilter(sectorId)

    local buttonCat

    local text = TDevModeGetEnglishText(button.Text)

    if text == "W" then
        buttonCat = "Weapons"
    elseif text == "A" then
        buttonCat = "Armor"
    elseif text == "M" then
        buttonCat = "Ammo"
    elseif text == "O" then
        buttonCat = "Other"
    end

    if not buttonCat then
        return false
    end

    return table.find(filter, buttonCat) and true or false

end

function HUDA_MilitiaTransfer:GetTotalPrice(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue = self:GetTables(sectorId, self.opId) or {}

    local total = 0

    for idx, itm in ipairs(queue) do
        total = total + self:GetItemPrice(itm)
    end

    local mercs = GetOperationProfessionals(sector.Id, self.opId)

    if next(mercs) and HasPerk(mercs[1], "Negotiator") then
        local discount = CharacterEffectDefs.Negotiator:ResolveValue("discountPercent")
        total = total + MulDivRound(total, discount + 100, 100)
    end

    return total
end

function HUDA_MilitiaTransfer:GetTransferTime(start, destination)
    return GetSectorTravelTime(start, destination) * 2
end

function HUDA_MilitiaTransfer:TransferItems(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue = self:GetTables(sectorId, self.opId) or {}

    local stash = sector.sector_inventory

    local newStash = {}

    local transferItems = {}

    for cidx, container in ipairs(stash) do
        if container[2] then -- is opened
            local items = container[3] or empty_table
            for idx, item in ipairs(items) do
                if table.find(queue, "id", item.id) then
                    table.insert(transferItems, item)
                else
                    table.insert(newStash, item)
                end
            end
        end
    end

    sector.sector_inventory = nil

    AddToSectorInventory(sectorId, newStash)

    local destinationId = self:GetDestination(sectorId)

    local due_time = Game.CampaignTime + self:GetTransferTime(sectorId, destinationId)

    local shipId = sectorId .. "_transfer_items_to_" .. destinationId .. Game.CampaignTime

    local shipment = {
        sectorId = sectorId,
        destinationId = destinationId,
        items = transferItems,
        due_time = due_time,
    }

    AddTimelineEvent(
        shipId,
        due_time,
        "sector_shipment",
        shipment
    )

    gv_HUDA_Item_Transfer = gv_HUDA_Item_Transfer or {}

    gv_HUDA_Item_Transfer[shipId] = shipment

    CombatLog("important",
        T { 2580831680090819, "<em><itemnum> items</em> from <em><sector></em> will be transfered to <em><destination></em> and arrive in about <em><due> hours</em>", itemnum = #transferItems, sector = sectorId, destination = destinationId, due = DivRound(due_time - Game.CampaignTime, 3600) })
end

function HUDA_MilitiaTransfer:SellItems(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue = self:GetTables(sectorId, self.opId) or {}

    local stash = sector.sector_inventory

    local newStash = {}

    local sellItems = {}

    for cidx, container in ipairs(stash) do
        if container[2] then -- is opened
            local items = container[3] or empty_table
            for idx, item in ipairs(items) do
                if table.find(queue, "id", item.id) then
                    table.insert(sellItems, item)
                else
                    table.insert(newStash, item)
                end
            end
        end
    end

    sector.sector_inventory = nil

    AddToSectorInventory(sectorId, newStash)

    local price = HUDA_MilitiaTransfer:GetTotalPrice(sectorId)

    AddMoney(price, "export", true)

    CombatLog("important",
        T { 2580831680090817, "<em><itemnum> items</em> from <em><sector></em> sold to Arulco for <em>$<money></em>", itemnum = #sellItems, sector = sectorId, money = price })
end

function HUDA_MilitiaTransfer:GetDestination(sectorId)
    local sector = gv_Sectors[sectorId]

    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}
    sector.custom_operations[self.opId][self.destId] = sector.custom_operations[self.opId][self.destId] or nil

    return sector.custom_operations[self.opId][self.destId]
end

function HUDA_MilitiaTransfer:OnComplete(op, sector, mercs)
    local type = sector.custom_operations[self.opId].actionType

    if type == "collect" then
        self:CollectItemsFromCity(sector.Id)
    end

    if type == "transfer" then
        self:TransferItems(sector.Id)
    end

    if type == "export" then
        self:SellItems(sector.Id)
    end

    sector.operations_temp_data[self.opId] = false
    sector.custom_operations[self.opId] = nil
end

function HUDA_MilitiaTransfer:GetItemPrice(item)
    return item.cost and MulDivRound(item.cost, item.condition, 750) or 0
end

function HUDA_MilitiaTransfer:AddAll(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue, all = self:GetTables(sectorId, self.opId)

    local filter = self:GetFilter(sectorId)

    local allC = table.copy(all)

    for _, item in ipairs(allC) do
        if not next(filter) or table.find(filter, item.category) then
            table.remove_value(all, item)
            table.insert(queue, item)
        end
    end

    self:SetQueue(sector, self.opId, queue)
    self:SetAll(sector, self.opId, all)

    NetSyncEvent("HudaOperationItemsUpdateLists", sectorId, self.opId, TableWithItemsToNet(all),
        TableWithItemsToNet(queue))
end

function HUDA_MilitiaTransfer:ClearAll(sectorId)
    local sector = gv_Sectors[sectorId]

    local queue, all = self:GetTables(sectorId, self.opId)

    local filter = self:GetFilter(sectorId)

    local queueC = table.copy(queue)

    for _, item in ipairs(queueC) do
        if not next(filter) or table.find(filter, item.category) then
            table.remove_value(queue, item)
            table.insert(all, item)
        end
    end

    self:SetQueue(sector, self.opId, queue)
    self:SetAll(sector, self.opId, all)

    NetSyncEvent("HudaOperationItemsUpdateLists", sectorId, self.opId, TableWithItemsToNet(all),
        TableWithItemsToNet(queue))
end

function HUDA_MilitiaTransfer:HandleAction(currentSectorId, action)
    local sector = gv_Sectors[currentSectorId]

    local type = action.type or "transfer"

    sector.custom_operations = sector.custom_operations or {}
    sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}
    sector.custom_operations[self.opId].actionType = type

    if action.sectorId then
        sector.custom_operations = sector.custom_operations or {}
        sector.custom_operations[self.opId] = sector.custom_operations[self.opId] or {}
        sector.custom_operations[self.opId][self.destId] = action.sectorId
    end
end

function HUDA_MilitiaTransfer:GetTransferLocations(currentSectorId)
    local locations = table.copy(self.locations)

    table.insert(locations, 1, {
        type = "collect",
        sectorId = currentSectorId,
        travelTime = 0
    })

    for sectorId, sector in pairs(gv_Sectors) do
        if sectorId ~= currentSectorId and sector.Side == "player1" and (sector.MilitiaBase or sector.Guardpost) then
            local travelTime = HUDA_MilitiaTransfer:GetTransferTime(currentSectorId, sectorId)

            local location = {
                type = "transfer",
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
                            local category = item:GetCategory()

                            category = category and category.id or "Other"

                            table.insert(cityStash,
                                {
                                    unit = "stash",
                                    id = item.id,
                                    amount = item.Amount or 1,
                                    category = category,
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

function HUDA_MilitiaTransfer:CollectItemsFromCity(sectorId)
    local sector = gv_Sectors[sectorId]

    local city = sector.City

    local citySectors = HUDA_GetControlledCitySectors(city)

    local cityStash = {}

    local counter = 0

    for _, sId in ipairs(citySectors) do
        local sector = gv_Sectors[sId]
        local stash = sector.sector_inventory or empty_table


        for cidx, container in ipairs(stash) do
            if container[2] then -- is opened
                local items = container[3] or empty_table

                for idx, item in ipairs(items) do
                    if not table.find(cityStash, "id", item.id) then
                        table.insert(cityStash, item)

                        if sId ~= sectorId then
                            counter = counter + 1
                        end
                    end
                end
            end
        end

        sector.sector_inventory = {}
    end

    self:AddToSector(cityStash, sectorId)

    CombatLog("important",
        T { 2580831680090825, "<em><itemnum> items</em> from <em><city></em> were collected and brought to <em><sector></em>", itemnum = counter, sector = sectorId, city = city })
end

function HUDA_MilitiaTransfer:AddToSector(items, sectorId)
    -- TODO: merge items
    -- local mergedItems = {}

    -- for i, item in ipairs(items) do
    --     local maxStack = item.MaxStacks or 1

    --     local numOfItems = item.count / maxStack

    --     local remainder = item.count % maxStack

    --     if remainder > 0 then
    --         numOfItems = numOfItems + 1
    --     end

    --     for j = 1, numOfItems do
    --         local it = PlaceInventoryItem(item.id)

    --         if it == nil then
    --             return
    --         end

    --         if j == numOfItems and remainder > 0 then
    --             item.Amount = remainder
    --         else
    --             item.Amount = maxStack
    --         end

    --         table.insert(mergedItems, item)
    --     end
    -- end

    AddToSectorInventory(sectorId, items)
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
                    local category = item:GetCategory()

                    category = category and category.id or "Other"

                    table.insert(all_to_sell,
                        {
                            unit = "stash",
                            id = item.id,
                            amount = item.Amount or 1,
                            category = category,
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

PlaceObj('SatelliteTimelineEventDef', {
    GetAssociatedMercs = function(self, eventCtx)
        return false
    end,
    GetDescriptionText = function(self, eventCtx)
        return T { 9410283425210815, "The transfered items will arrive in <em><sector></em>", sector = eventCtx.sectorId },
            self.Title, self.Hint
    end,
    GetIcon = function(self, eventCtx)
        return "UI/Icons/SateliteView/icon_ally", "UI/Icons/SateliteView/weapon_shipments"
    end,
    GetMapLocation = function(self, eventCtx)
        local sectorId = eventCtx.sectorId
        local sector = gv_Sectors[sectorId]
        if sector then
            return sector.XMapPosition
        end
    end,
    OnClick = function(self, eventCtx)
        return false
    end,
    Text = T(9410283425210815, "The shipped items will arrive"),
    Title = T(7701766354240816, "Shipment arrives"),
    group = "Default",
    id = "sector_shipment",
})
