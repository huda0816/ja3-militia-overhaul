GameVar("gv_HUDA_MilitiaOperationCooldowns", {})

function OnMsg.ZuluGameLoaded(game)
	HUDA_MilitiaOperations:InitCooldownVar()
end


DefineClass.HUDA_MilitiaOperations = {
    operations = {
        "HUDA_MilitiaHumanitarianAid",
        "HUDA_MilitiaRecruitmentDrive",
        "HUDA_MilitiaBase"
    }
}

function HUDA_MilitiaOperations:InitCooldownVar()
    gv_HUDA_MilitiaOperationCooldowns = {}

    local cities = gv_Cities or {}

    for _, operationId in ipairs(self.operations) do

        gv_HUDA_MilitiaOperationCooldowns[operationId] = gv_HUDA_MilitiaOperationCooldowns[operationId] or {}
    
        for k, city in pairs(cities) do
            gv_HUDA_MilitiaOperationCooldowns[operationId][k] = gv_HUDA_MilitiaOperationCooldowns[operationId][k] or {}
        end
    
    end
end

function HUDA_MilitiaOperations:SetCooldown(operationId, sector, cooldown)
    local op = gv_HUDA_MilitiaOperationCooldowns[operationId][sector.City]

    op.ongoing = false
    op.lastOperation = Game.CampaignTime
    op.cooldown = cooldown * 3600
end

function HUDA_MilitiaOperations:HasCooldown(operationId, sector)
    local op = gv_HUDA_MilitiaOperationCooldowns[operationId][sector.City]

    if not op.cooldown or not op.lastOperation then
        return false
    end

    local timeLeft = DivRound(op.lastOperation + op.cooldown - Game.CampaignTime, 3600)
    
    return op.lastOperation or 0 + op.cooldown < Game.CampaignTime, timeLeft
end

function HUDA_MilitiaOperations:HasOngoingOperation(operationId, sector)
    return gv_HUDA_MilitiaOperationCooldowns[operationId][sector.City].ongoing or false
end

function HUDA_MilitiaOperations:SetOngoingOperation(operationId, sector, ongoing)
    gv_HUDA_MilitiaOperationCooldowns[operationId][sector.City].ongoing = ongoing
end
