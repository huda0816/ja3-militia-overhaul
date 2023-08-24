-- GCMilita Perk Effects
function OnMsg.NewHour()
    local militia = HUDA_GetAllMilitiaSoldiers()

    for _, unit in pairs(militia) do
        
        local armor = unit:GetEquipedArmour()
        local weapons = unit:GetHandheldItems()
        local conditionPerHour = 1

        for _, item in ipairs(armor) do
            if item.Repairable and item.Condition < 80 then
                item.Condition = item.Condition + conditionPerHour
            end
        end

        for _, item in ipairs(weapons) do
            if item.Repairable and item.Condition < 80
            then
                item.Condition = item.Condition + conditionPerHour
            end
        end
    end
end
