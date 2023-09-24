-- GCMilita Perk Effects
-- Militia Soldiers cleaning their gear daily
function OnMsg.NewDay()
    
    local repairThreshold = tonumber(HUDA_GetModOptions("MilitiaRepairThreshold", 80))

    if repairThreshold == 0 then
        return
    end
    
    local militia = HUDA_GetMilitia()

    for _, unit in pairs(militia) do
        
        local armor = unit:GetEquipedArmour()
        local weapons = unit:GetHandheldItems()
        local conditionPerDay = 20

        for _, item in ipairs(armor) do
            if item.Repairable and item.Condition < repairThreshold then
                item.Condition = Min(repairThreshold, item.Condition + conditionPerDay)
            end
        end

        for _, item in ipairs(weapons) do
            if item.Repairable and item.Condition < repairThreshold
            then
                item.Condition = Min(repairThreshold, item.Condition + conditionPerDay)
            end
        end
    end
end
