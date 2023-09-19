-- GCMilita Perk Effects
-- Militia Soldiers cleaning their gear daily
function OnMsg.NewDay()
    local militia = HUDA_GetMilitia()

    for _, unit in pairs(militia) do
        
        local armor = unit:GetEquipedArmour()
        local weapons = unit:GetHandheldItems()
        local conditionPerDay = 20

        for _, item in ipairs(armor) do
            if item.Repairable and item.Condition < 80 then
                item.Condition = Min(80, item.Condition + conditionPerDay)
            end
        end

        for _, item in ipairs(weapons) do
            if item.Repairable and item.Condition < 80
            then
                item.Condition = Min(80, item.Condition + conditionPerDay)
            end
        end
    end
end
