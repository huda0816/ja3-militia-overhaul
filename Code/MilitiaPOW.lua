GameVar("gv_HUDA_CapturedPows", {})

g_MilitiaInterrogationCompleteCounter = 0
g_MilitiaInterrogationCompletePopups = {}

function OnMsg.ClosePDA()
    local units = g_Units

    for _, unit in ipairs(units) do
        if unit.HireStatus == "Captured" then
            unit:Captured()
        end
    end
end

function OnMsg.RevisedSlotConfigAddedToItemProperties()

    HUDA_Zipties.PocketL_amount = 10
    HUDA_Zipties.PocketML_amount = 5
    HUDA_Zipties.PocketM_amount = 2
    HUDA_Zipties.PocketS_amount = 1

end

function OnMsg.OpenSatelliteView()
    HUDA_MilitiaPOW:DeliverPOWs()
end

function OnMsg.NewDay()
    HUDA_MilitiaPOW:RollForRevolt()
end

DefineClass.HUDA_MilitiaPOW = {
    revoltWeapons = {"AK47", "Famas", "Machete", "Knife", "DoubleBarrelShotgun", "UZI", "Glock18", "ColtPeacemaker"}
}

function HUDA_MilitiaPOW:RollForRevolt()
    if not gv_HUDA_CapturedPows then
        return
    end

    for sectorId, prisoners in pairs(gv_HUDA_CapturedPows) do
        if sectorId ~= "LOCALE" then
            local prisonData = self:GetPrisonData(sectorId)

            if prisonData then
                local roll = InteractionRandRange(20, 100)

                if roll < prisonData.riskPercent then
                    self:Revolt(sectorId)
                end
            end
        end
    end
end

function HUDA_MilitiaPOW:FreePOWs(sectorId)
    local sector = gv_Sectors[sectorId]

    if not sector then
        return
    end

    local pows = gv_HUDA_CapturedPows[sectorId]

    if not pows then
        return
    end

    local enemySquad = sector.enemy_squads and sector.enemy_squads[1] or nil

    if not enemySquad then
        return
    end

    local unit = gv_UnitData[enemySquad.units[1]]

    if not unit then
        return
    end

    local affiliation = unit.Affiliation

    local freedPows = {}

    for _, powId in ipairs(pows) do
        local pow = gv_UnitData[powId]
        if pow and pow.Affiliation == affiliation then
            self:ArmPOW(pow)
            table.insert(freedPows, powId)
        else
            pow:Die()
        end
    end

    gv_HUDA_CapturedPows[sectorId] = nil

    local freedSquad = CreateNewSatelliteSquad({
        Side = "enemy1",
        CurrentSector = sectorId,
        Name = T(1215602053470890, "Freed POWs")
    }, freedPows)

    CombatLog("important", T {
        964788160766,
        "<number> were freed from your prison in sector <sector>",
        number = #freedPows,
        sector = sectorId
    })
end

function HUDA_MilitiaPOW:Revolt(sectorId)
    local unitIds = {}

    for _, powId in ipairs(gv_HUDA_CapturedPows[sectorId]) do
        local unit = gv_UnitData[powId]
        if unit then
            self:ArmPOW(unit)
            table.insert(unitIds, powId)
        end
    end

    gv_HUDA_CapturedPows[sectorId] = nil

    CreateNewSatelliteSquad({
        Side = "enemy1",
        CurrentSector = sectorId,
        Name = T(12156020534708170, "Revolting Prisoners")
    }, unitIds)

    local popupHost = GetDialog("PDADialogSatellite")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

    local sector = gv_Sectors[sectorId]

    local ownUnits = sector.ally_and_militia_squads and #sector.ally_and_militia_squads > 0

    local revoltResult = ownUnits and T {964788160766081423, "have engaged the guards in combat!"} or
                             T {964788160766081512, "have successfully seized control of the sector!"}

    local dlg = CreateMessageBox(popupHost, Untranslated("Prison Break!"), TConcat({T {
        9647881607660815,
        "An uprising has occurred in sector <em><sector></em>. The prisoners ",
        sector = sectorId
    }, revoltResult}, ""))
end

function wadd(sessionId)
    local unit = gv_UnitData[sessionId]
    if unit then
        HUDA_MilitiaPOW:ArmPOW(unit)
    end
end

function HUDA_MilitiaPOW:ArmPOW(unit)
    local weaponId = self.revoltWeapons[InteractionRandRange(1, #self.revoltWeapons)]

    local weapon = PlaceInventoryItem(weaponId)

    unit:AddItem("Handheld A", weapon)

    if (weapon.Caliber) then
        -- to load the gun:
        local ammo = GetAmmosWithCaliber(weapon.Caliber, "sort")[1]
        if ammo then
            local tempAmmo = PlaceInventoryItem(ammo.id)
            tempAmmo.Amount = tempAmmo.MaxStacks
            weapon:Reload(tempAmmo, "suspend_fx")
            unit:AddItem("Inventory", tempAmmo)
        end
    end
end

function HUDA_MilitiaPOW:HasPOWs(sectorId)
    local powNum = 0

    gv_HUDA_CapturedPows = gv_HUDA_CapturedPows or {}

    if not sectorId then
        for s, pows in pairs(gv_HUDA_CapturedPows) do
            powNum = powNum + #pows
        end
    else
        local pows = gv_HUDA_CapturedPows[sectorId]

        if pows then
            powNum = #pows
        end
    end

    return powNum > 0, powNum
end

function HUDA_MilitiaPOW:DeliverPOWs()
    if not gv_CurrentSectorId then
        return
    end

    local sector = gv_Sectors[gv_CurrentSectorId]

    if not sector then
        return
    end

    local enemies = false
    local pows = {}

    for _, squad in ipairs(sector.enemy_squads) do
        if squad.Side ~= "neutral" then
            enemies = true
        end
    end

    if enemies then
        return
    end

    for _, squad in ipairs(sector.enemy_squads) do
        if squad.Side == "neutral" then
            for _, unitId in ipairs(squad.units) do

                local unit = g_Units[unitId] or gv_UnitData[unitId]

                unit.HireStatus = "Captured"
                unit.villain = false
                unit:RemoveStatusEffect("Downed")
                unit:RemoveStatusEffect("Unconscious")
                unit:RemoveStatusEffect("BleedingOut")
                unit:SyncWithSession("map")
                local container = GetDropContainer(unit)
                unit:DropLoot(container)
                table.insert(pows, unit.session_id)

            end
        end
    end

    if not next(pows) then
        return
    end

    self:ChoosePrison(pows)
end

function HUDA_MilitiaPOW:GetNumberOfGuards(sectorId)
    local sector = gv_Sectors[sectorId]

    local guards = 0

    for _, squad in ipairs(sector.ally_and_militia_squads) do
        guards = guards + #squad.units
    end

    return guards
end

function HUDA_MilitiaPOW:CalculateRisk(sectorId, new)
    local reasons = {}

    local num = (new or 0) + self:GetCurrentPrisonersNumber(sectorId)

    if num == 0 then
        return 0, 100, 0, reasons
    end

    local max = self:GetMaxPrisoners(sectorId)

    local guards = self:GetNumberOfGuards(sectorId)

    local prisonerPercent = Max(MulDivScaled(num, 100, max), 100)

    if prisonerPercent > 100 then
        table.insert(reasons, "too many prisoners")
    end

    local neededGuards = MulDivScaled(num, prisonerPercent, 500)

    local guardsCoverage = (guards > 0) and MulDivRound(guards, 100, neededGuards) or 0

    if guardsCoverage < 100 then
        table.insert(reasons, "not enough guards")
    end

    local risk = Max(100 - guardsCoverage, 0)

    return risk, guardsCoverage, neededGuards, reasons
end

function HUDA_MilitiaPOW:GetRiskString(sectorId, new)
    local risk, guardsCoverage, neededGuards, reasons = self:CalculateRisk(sectorId, new)

    local riskString = "none"

    if risk > 80 then
        riskString = "very high"
    elseif risk > 60 then
        riskString = "high"
    elseif risk > 40 then
        riskString = "medium"
    elseif risk > 20 then
        riskString = "low"
    end

    return riskString, risk, guardsCoverage, neededGuards, reasons
end

function HUDA_MilitiaPOW:GetMaxPrisoners(sectorId)
    local sector = gv_Sectors[sectorId]

    local maxPrisoners = 0

    if sector.MilitiaBase then
        maxPrisoners = 10
    elseif sector.Guardpost then
        maxPrisoners = 10
    elseif sectorId == "L6" then
        maxPrisoners = 40
    end

    return maxPrisoners
end

function HUDA_MilitiaPOW:GetCurrentPrisoners(sectorId)
    local currentPrisoners = {}

    if gv_HUDA_CapturedPows and gv_HUDA_CapturedPows[sectorId] then
        currentPrisoners = gv_HUDA_CapturedPows[sectorId]
    end

    return currentPrisoners
end

function HUDA_MilitiaPOW:GetCurrentPrisonersNumber(sectorId)
    local currentPrisoners = self:GetCurrentPrisoners(sectorId)

    return #currentPrisoners
end

function HUDA_MilitiaPOW:GetPrisonData(sectorId, new)
    local currentPrisoners = self:GetCurrentPrisoners(sectorId)
    local maxPrisoners = self:GetMaxPrisoners(sectorId)
    local guards = self:GetNumberOfGuards(sectorId)
    local riskString, risk, guardsCoverage, neededGuards, reasons = self:GetRiskString(sectorId, new)

    return {
        Id = sectorId,
        max = maxPrisoners,
        current = #currentPrisoners,
        currentPrisoners = currentPrisoners,
        guards = guards,
        neededGuards = neededGuards,
        risk = riskString,
        riskPercent = risk,
        reasons = reasons,
        new = new or 0
    }
end

function HUDA_MilitiaPOW:GetPrisonDescription(sectorId)
    local prisonInfo = self:GetPrisonData(sectorId)

    if prisonInfo then
        return T {
            1000999105101280817,
            Untranslated(
                "<newline><em>POW INFORMATION</em><newline><newline>Prisoners: <prisoners>/<capacity><newline>Revolt risk: <risk>"),
            prisoners = Untranslated(prisonInfo.current),
            capacity = Untranslated(prisonInfo.max),
            risk = Untranslated(prisonInfo.risk)
        }
    end
end

function HUDA_MilitiaPOW:ChoosePrison(pows)
    local sectors = gv_Sectors

    local sector_posibilities = {}

    local powsNum = #(pows or {})

    for sector_id, sector in pairs(sectors) do
        if (sector.MilitiaBase or sector.Guardpost or sector_id == "L6") and sector.Side == "player1" then
            local prisonInfo = self:GetPrisonData(sector_id, powsNum)

            if (prisonInfo.current + powsNum) <= prisonInfo.max * 2 then
                table.insert(sector_posibilities, prisonInfo)
            end
        end
    end

    local popupHost = GetDialog("PDADialogSatellite")
    popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")

    local pickDlg = XTemplateSpawn("PDAMilitiaPrisonPicker", popupHost, {
        sectors = sector_posibilities,
        prisoners = pows
    })
    pickDlg:Open()
    return pickDlg
end

function HUDA_MilitiaPOW:SetPrisonersSector(pows, sectorId)
    sectorId = sectorId or "LOCALE"

    gv_HUDA_CapturedPows = gv_HUDA_CapturedPows or {}
    gv_HUDA_CapturedPows[sectorId] = gv_HUDA_CapturedPows[sectorId] or {}

    for _, unitId in ipairs(pows) do
        table.insert(gv_HUDA_CapturedPows[sectorId], unitId)

        RemoveUnitFromSquad(gv_UnitData[unitId])

        local mapUnit = g_Units[unitId]

        if mapUnit then
            DoneObject(mapUnit)
        end
    end
end

function HUDA_MilitiaPOW:HandleBleedingOut(bo, target)
    if not IsInCombat() then
        return
    end
    target.downed_check_penalty = target.downed_check_penalty == 0 and bo:ResolveValue("add_initial_bonus") or
                                      (target.downed_check_penalty + bo:ResolveValue("add_penalty"))
    if not RollSkillCheck(target, "Health", nil, target.downed_check_penalty) then
        CombatLog("important", T {290150299208, "<em><LogName></em> has <em>bled out</em>", target})
        target.downing_action_start_time = target.downing_action_start_time and target.downing_action_start_time - 1 or
                                               -1
        target:TakeDirectDamage(target:GetTotalHitPoints())
    else
        CombatLog("short", T {333799512710, "<em><LogName></em> is <em>bleeding</em>", target})
    end
end

function HUDA_MilitiaPOW:IsNoDowner(unit)
    if unit.species ~= "Human" or unit.villain or unit.ImportantNPC or unit.infected or unit.group == "NPC" then
        return true
    end

	local excludedAffiliations = {"Thugs", "SuperSoldiers"}

    if HUDA_ArrayContains(excludedAffiliations, unit.Affiliation) then
        return true
    end

    local excludedSectors = {"L12", "L18", "L17", "G8"}

    if HUDA_ArrayContains(excludedSectors, gv_CurrentSectorId) then
        return true
    end

    local excludedList = {"LegionRaider_Jose", "JoseFamily_All", "HermanRaiders", "AbuserPoacher_All", "Crocs",
                          "Knights", "Nobles", "RimvilleGuardsAll", "SmileyThugs", "RefugeeRaiders", "PierreAndGuards",
                          "LegionImpostors", "Fighters", "AL_Pirate_Thugs"}

    if not unit.Groups or #unit.Groups < 1 then
        return false
    end

    for _, group in ipairs(unit.Groups) do
        if HUDA_ArrayContains(excludedList, group) then
            return true
        end
    end

    local valuableCarrier = false;

    unit:ForEachItem(false, function(item, slot_name)
        if IsKindOfClasses(item, "Valuables", "ValuablesStack", "ValuableItemContainer", "QuestItem") then
			valuableCarrier = true
            return "break"
        end
    end)

    if valuableCarrier then
        return true
    end

    return false
end

local HUDA_OriginalShouldGetDowned = Unit.ShouldGetDowned

function Unit:ShouldGetDowned(hit_descr)
    if CurrentModOptions["huda_MilitiaNoDownedEnemies"] or HUDA_MilitiaPOW:IsNoDowner(self) then
        return HUDA_OriginalShouldGetDowned(self, hit_descr)
    end

    if hit_descr and hit_descr.was_downed then
        return false
    end

    if hit_descr and hit_descr.spot == "Head" then
        return false
    end

    if not self:IsMerc() then
        if not g_Combat then
            return false
        end

        local downroll = InteractionRand(7, "Downed")

        local overkill = hit_descr and (hit_descr.raw_damage - hit_descr.prev_hit_points) or 0

        local threshold = 10

        CombatLog("debug", Untranslated {
            "Should get downed roll. roll: <downr>, overkill: <overk>, threshold: <thres>",
            downr = downroll,
            overk = overkill,
            thres = threshold
        })

        if downroll + overkill > threshold then
            return false
        end
    end

    if self.team and self.team:IsDefeated() then
        return false
    end
    if IsGameRuleActive("LethalWeapons") then
        return false
    end
    if IsGameRuleActive("ForgivingMode") and self:IsMerc() then
        return true
    end
    if hit_descr then
        local value = GameDifficulties[Game.game_difficulty]:ResolveValue("InstantDeathHp") or -50
        if hit_descr.prev_hit_points - hit_descr.raw_damage <= value then
            return false
        end
    end
    if g_Combat then
        return not self:IsDowned()
    end
    return hit_descr and hit_descr.prev_hit_points > 1
end

function Unit:Captured()
    self.command = "VillainDefeat"

    if not self.villain or not self.villain_defeated then
        if self.behavior == "VillainDefeat" then
            self:SetBehavior()
        end
        if self.combat_behavior == "VillainDefeat" then
            self:SetCombatBehavior()
        end
        return
    end

    SetCombatActionState(self, nil)

    self:SetBehavior("VillainDefeat")
    self:SetCombatBehavior("VillainDefeat")

    -- self.invulnerable = true
    self.conflict_ignore = true -- prevent ambient life from messing around with this unit
    self.neutral_retaliate = false
    -- self.HitPoints = 1
    self:DoChangeStance("Crouch")
    self.ActionPoints = 0
    self.villain_defeated = true
    self:ClearPath()

    self:InterruptPreparedAttack()
    self:RemoveAllStatusEffects()
    self.HireStatus = "Captured"

    local squad = gv_Squads[self.Squad]
    if squad then
        local newSquadId = SplitSquad(squad, {self.session_id})
        assert(self.Squad == newSquadId)
        SetSatelliteSquadSide(self.Squad, "neutral")
    end
    self:SetSide("neutral")

    if g_Combat and not g_AIExecutionController then
        g_Combat:EndCombatCheck()
    end

    self:RemoveEnemyPindown()

    -- temporary anim
    self.command_specific_params = self.command_specific_params or {}
    self.command_specific_params.VillainDefeat = {
        weapon_anim_prefix = "civ_"
    }
    self:SetRandomAnim(self:GetIdleBaseAnim("Crouch"), const.eKeepComponentTargets, 0)
    self:SyncWithSession("map")
    Msg("VillainDefeated", self, self.on_die_attacker)
    Halt()
end

function Unit:IsBeingCaptured()
    for _, unit in ipairs(g_Units) do
        if unit:GetCaptureTarget() == self then
            return true
        end
    end
end

function Unit:GetCaptureTarget()
    if self.combat_behavior == "CapturePOW" and not self:IsDead() then
        local args = self.combat_behavior_params[3]
        return args.target
    end
end

function Unit:GetCaptureItems()
    if self.combat_behavior == "CapturePOW" and not self:IsDead() then
        return GetUnitEquippedCaptureItems(self)
    end
end

function Unit:EndCombatCapture(no_ui_update, instant)
    -- local target = self:GetCaptureTarget()
    self:RemoveStatusEffect("Capturing")
    ObjModified(self)
    -- if IsValid(target) then
    --     target:RemoveStatusEffect("BeingCaptured")
    --     ObjModified(target)
    -- end

    local normal_anim = self:TryGetActionAnim("Idle", self.stance)
    if not instant then
        self:PlayTransitionAnims(normal_anim)
    end

    self:SetCombatBehavior()
    self:SetBehavior()
    if not no_ui_update and self == SelectedObj and g_Combat then
        SetInGameInterfaceMode("IModeCombatMovement") -- force update to redraw the combat path areas now that movement is allowed
    end

    if self.command == "EndCombatCapture" then
        self:SetCommand("Idle")
    end
end

function Unit:CombatCapturePOW(target, ties)
    self.command = "CombatBandage"

    target:AddStatusEffect("BeingCaptured")
    ObjModified(target)
    if IsValid(target) then
        self:Face(target, 0)
    end

    if g_Combat then
        -- play anim, etc
        local heal_anim
        heal_anim = "nw_Bandaging_Idle"
        self:SetState(heal_anim, const.eKeepComponentTargets)

        self:AddStatusEffect("Capturing")
        if not GetMercInventoryDlg() then
            SetInGameInterfaceMode("IModeCombatMovement")
        end
        ObjModified(self)
        Halt()
    end
end

function Unit:CapturePOW(action_id, cost_ap, args)
    local goto_ap = args.goto_ap or 0
    local action_cost = cost_ap - goto_ap
    local pos = args.goto_pos
    local target = args.target
    local sat_view = args.sat_view or false -- in sat_view form inventory, skip all sleeps and anims
    local target_self = target == self

    if g_Combat then
        if goto_ap > 0 then
            self:PushDestructor(function(self)
                self:GainAP(action_cost)
            end)
            local result = self:CombatGoto(action_id, goto_ap, args.goto_pos)
            self:PopDestructor()
            if not result then
                self:GainAP(action_cost)
                return
            end
        end
    elseif not target_self then
        self:GotoSlab(pos)
    end

    local myVoxel = SnapToPassSlab(self:GetPos())
    if pos and myVoxel:Dist(pos) ~= 0 then
        if self.behavior == "CapturePOW" then
            self:SetBehavior()
        end
        if self.combat_behavior == "CapturePOW" then
            self:SetCombatBehavior()
        end
        self:GainAP(action_cost)
        return
    end
    local action = CombatActions[action_id]
    local ties = GetUnitEquippedCaptureItems(self)
    if not ties then
        if self.behavior == "CapturePOW" then
            self:SetBehavior()
        end
        if self.combat_behavior == "CapturePOW" then
            self:SetCombatBehavior()
        end
        self:GainAP(action_cost)
        return
    end

    self:SetBehavior("CapturePOW", {action_id, cost_ap, args})
    self:SetCombatBehavior("CapturePOW", {action_id, cost_ap, args})

    if not target_self then
        self:Face(target, 200)
        Sleep(200)
    end

    if not sat_view then
        if self.stance ~= "Crouch" then
            self:ChangeStance(false, 0, "Crouch")
        end
        self:SetState(target_self and "nw_Bandaging_Self_Start" or "nw_Bandaging_Start")
        Sleep(self:TimeToAnimEnd() or 100)
        if not args.provoked then
            self:ProvokeOpportunityAttacks("attack interrupt")
            args.provoked = true
            self:SetBehavior("CapturePOW", {action_id, cost_ap, args})
            self:SetCombatBehavior("CapturePOW", {action_id, cost_ap, args})
        end
        self:SetState(target_self and "nw_Bandaging_Self_Idle" or "nw_Bandaging_Idle")
        if not g_Combat and not GetMercInventoryDlg() then
            SetInGameInterfaceMode("IModeExploration")
        end
    end

    self:SetCommand("CombatCapturePOW", target, ties)
end

function HUDA_MilitiaPOW:CapturingBeginTurn(eff, unit)
    -- Inspect(unit)

    -- local pow = unit:GetCaptureTarget()
    -- local tool = unit:GetCaptureMedicine()
    -- if not pow or not tool or pow.command == "Die" or pow:IsDead() then
    --     unit:RemoveStatusEffect("Capturing")
    -- end
end

function HUDA_MilitiaPOW:CapturingEndTurn(eff, unit)
    local pow = unit:GetCaptureTarget()
    unit:RemoveStatusEffect("Capturing")
    -- local pos = pow:GetPos()
    -- local newPos = pos + point(const.SlabSizeX, const.SlabSizeY, 0)
    -- print("CapturingEndTurn", pos, newPos)
    -- local container = GetDropContainer(pow)
    -- pow:DropLoot(container)
    pow.villain = true
    pow.villain_defeated = true
    pow:SetCommand("Captured")
end

function HUDA_MilitiaPOW:CapturingOnAdded(eff, unit)
    local pow = unit:GetCaptureTarget()
    pow:RemoveStatusEffect("BleedingOut")
    unit:RemoveStatusEffect("FreeMove")
end

function HUDA_MilitiaPOW:CapturingOnRemoved(eff, unit)
    local pow = unit:GetCaptureTarget()

    if pow and not pow:IsDead() and pow:IsDowned() then
        pow:RemoveStatusEffect("Stabilized")
        pow:AddStatusEffect("BleedingOut")
        pow:RemoveStatusEffect("BeingCaptured")
    elseif pow and not pow:IsDead() and pow:HasStatusEffect("Unconscious") then

    end

    if not unit:IsDead() then
        unit:ClearBehaviors("CapturePOW")
        if CurrentThread() == unit.command_thread then
            unit:QueueCommand("EndCombatCapture") -- make sure it does not break the RemoveStatusEffect call
        else
            unit:SetCommand("EndCombatCapture")
        end
    end
end

PlaceObj('CombatAction', {
    ActivePauseBehavior = "instant",
    ConfigurableKeybind = false,
    Description = T(1344589948720816, --[[CombatAction StopBandaging Description]]
        "Cancel the capturing action. The unit will be able to move but not regain any more HP."),
    DisplayName = T(8561536980410816, --[[CombatAction StopBandaging DisplayName]] "Stop Capturing"),
    GetUIState = function(self, units, args)
        local unit = units[1]

        if unit:GetCaptureTarget() or unit:IsBeingCaptured() then
            return "enabled"
        end
        return "hidden"
    end,
    Icon = "Mod/LXPER6t/Icons/stop_capture_pow",
    IdDefault = "StopCapturingdefault",
    IsAimableAttack = false,
    -- KeybindingFromAction = "actionRedirectBandage",
    MultiSelectBehavior = "first",
    RequireState = "any",
    Run = function(self, unit, ap, ...)
        if unit:GetCaptureTarget() then
            unit:SetActionCommand("EndCombatCapture")
        end
    end,
    SortKey = 9,
    group = "Default",
    id = "StopCapturing"
})

PlaceObj('CombatAction', {
    ActionPoints = 2000,
    ActivePauseBehavior = "queue",
    AimType = "melee",
    ConfigurableKeybind = false,
    Description = T(1057654207380817, --[[CombatAction CapturePOW Description]] "Capture downed enemy soldiers"),
    DisplayName = T(0816615556944457, --[[CombatAction CapturePOW DisplayName]] "Capture POW"),
    EvalTarget = function(self, units, target, args)
        local unit = units[1]
        if not target or not unit:IsOnEnemySide(target) then
            return -1
        end
        if not target:IsDowned() and not target:HasStatusEffect("Unconscious") then
            return -1
        end
        return true
    end,
    GetAPCost = function(self, unit, args)
        local zips = self:GetAttackWeapons(unit, args)
        if not zips then
            return -1
        end -- can be valid in AI PrecalcAction
        return self.ActionPoints
    end,
    GetAnyTarget = function(self, units)
        return GetCaptureTargets(units[1], "any", "ignore")
    end,
    GetAttackWeapons = function(self, unit, args)
        return GetUnitEquippedCaptureItems(unit)
    end,
    GetDefaultTarget = function(self, unit)
        return false
    end,
    GetTargets = function(self, units)
        return GetCaptureTargets(units[1], "all", "ignore")
    end,
    GetUIState = function(self, units, args)
        local unit = units[1]

        if g_Combat and not unit:HasAP(self.ActionPoints) then
            return "disabled", GetUnitNoApReason(unit)
        end

        if not GetCaptureTargets(unit, "any", "reachable") then
            return "disabled", AttackDisableReasons.NoTarget
        end

        return "enabled"
    end,
    Icon = "Mod/LXPER6t/Icons/capture_pow.png",
    IdDefault = "Capturedefault",
    IsAimableAttack = false,
    -- KeybindingFromAction = "actionRedirectBandage",
    MoveStep = true,
    MultiSelectBehavior = "first",
    Parameters = {},
    QueuedBadgeText = T(989605585095, --[[CombatAction Bandage QueuedBadgeText]] "CAPTURE"),
    RequireState = "any",
    RequireWeapon = true,
    Run = function(self, unit, ap, ...)
        unit:SetActionCommand("CapturePOW", self.id, ap, ...)
    end,
    SortKey = 10,
    UIBegin = function(self, units, args)
        if self:GetAnyTarget(units) then
            if units then
                table.sort(units, function(a, b)
                    return a.Dexterity > b.Dexterity and self:GetAttackWeapons(a)
                end)
            end
            CombatActionCaptureStart(self, units, args, "IModeCombatMelee")
        end
    end,
    group = "Default",
    id = "CapturePOW"
})

function GetUnitEquippedCaptureItems(unit)
    -- try to find medkit first and than first aid
    local item
    local res = unit:ForEachItem("HUDA_Zipties", function(itm, slot)
        if itm.Condition > 0 then
            item = itm
            return "break"
        end
    end, item)
    return item
end

function GetCaptureTargets(unit, mode, range_mode)
    local targets = (mode ~= "any") and {}
    local enemies = GetAllEnemyUnits(unit)

    local base_cost = CombatActions.CapturePOW:GetAPCost(unit)
    for _, enemy in ipairs(enemies) do
        if not enemy:IsDead() and (enemy:IsDowned() or enemy:HasStatusEffect("Unconscious")) then
            local range_ok = range_mode == "ignore" or IsMeleeRangeTarget(unit, nil, nil, enemy)

            if range_mode == "reachable" and base_cost > 0 then
                if g_Combat then
                    local pos = unit:GetClosestMeleeRangePos(enemy)
                    if pos then
                        local path = GetCombatPath(unit)
                        local ap = path:GetAP(pos)
                        if ap then
                            local cost = base_cost + Max(0, ap - unit.free_move_ap)
                            range_ok = unit:HasAP(cost)
                        end
                    end
                else
                    range_ok = true
                end
            end

            if range_ok then
                if mode == "any" then
                    return enemy
                end
                targets[#targets + 1] = enemy
            end
        end
    end

    return targets
end

-- Not sure if needed

if FirstLoad then
    CombatActionStartThread = false
end

function CombatActionCaptureStart(self, units, args, mode, noChangeAction)
    mode = mode or "IModeCombatAttackBase"

    local unit = units[1]
    if IsValidThread(CombatActionStartThread) then
        DeleteThread(CombatActionStartThread)
    end
    CombatActionStartThread = CreateRealTimeThread(function()
        if g_Combat then
            WaitCombatActionsEnd(unit)
        end
        if not IsValid(unit) or unit:IsDead() or not unit:CanBeControlled() then
            return
        end
        if PlayerActionPending(unit) then
            return
        end
        if not g_Combat and not unit:IsIdleCommand() then
            NetSyncEvent("InterruptCommand", unit, "Idle")
        end

        local target = args and args.target
        local freeAim = args and args.free_aim or not UIAnyEnemyAttackGood(self)
        if freeAim and not g_Combat and self.basicAttack and self.ActionType == "Melee Attack" then
            local action = GetMeleeAttackAction(self, unit)
            freeAim = action.id ~= "CancelMark"
        end
        freeAim = freeAim and (self.id ~= "CancelMark")
        if not self.IsTargetableAttack and IsValid(target) and freeAim then
            local ap = self:GetAPCost(unit, args)
            NetStartCombatAction(self.id, unit, ap, args)
            return
        end

        if mode == "IModeCombatMelee" and target then
            local weapon = self:GetAttackWeapons(unit)
            local ok, reason = unit:CanAttack(target, weapon, self)
            if not ok then
                ReportAttackError(args.target, reason)
                return
            end
            -- if not IsMeleeRangeTarget(unit, nil, nil, target) then			
            -- ReportAttackError(args.target, AttackDisableReasons.CantReach)
            -- return
            -- end
        end

        -- Check what actually needs switching
        local changeNeeded, dlg, targetGiven =
            CombatActionChangeNeededTryRetainTarget(mode, self, unit, target, freeAim)

        -- Clicking a single target skill twice will cause the attack to proceed
        if not changeNeeded then
            if dlg.crosshair then
                dlg.crosshair:Attack()
            else
                dlg:Confirm()
            end
            return
        end

        -- Changing actions requires notifying the dialog to exit quietly.
        if changeNeeded == "change-action" then
            dlg.context.changing_action = true
        end

        -- It is possible for the unit to have been deselected in all our waiting.
        -- Of for the action to have been disabled.
        local state = self:GetUIState(units)
        if not SelectedObj or state ~= "enabled" then
            return
        end

        -- Patch selection outside of combat to remove multiselection
        -- We're not doing this through SelectObj as the selection changed msg
        -- will cancel the action.
        if not g_Combat then
            Selection = {unit}
        end

        local modeDlg = GetInGameInterfaceModeDlg()
        modeDlg.dont_return_camera_on_close = true
        SetInGameInterfaceMode(mode, {
            action = self,
            attacker = unit,
            target = target,
            aim = args and args.aim,
            free_aim = freeAim,
            changing_action = changeNeeded == "change-action"
        })
    end)
end

local HUDA_OriginalTargeting_UnitInMelee = Targeting_UnitInMelee

function Targeting_UnitInMelee(dialog, blackboard, command, pt)
    if dialog.action.id ~= "CapturePOW" then
        return HUDA_OriginalTargeting_UnitInMelee(dialog, blackboard, command, pt)
    end

    local action = dialog.action
    local attacker = dialog.attacker
    local free_aim = IsKindOf(dialog, "IModeCombatFreeAim")

    if dialog:PlayerActionPending(attacker) then
        command = "delete"
    end

    if command == "delete" then
        SetAPIndicator(false, "melee-attack")
        SetAPIndicator(false, "bandage-error")
        SetAPIndicator(false, "brutalize")

        for _, unit in ipairs(g_Units) do
            unit:SetHighlightReason("melee-target", false)
            unit:SetHighlightReason("bandage-target", false)
        end

        if IsValid(blackboard.actor_tile_mesh) then
            DoneObject(blackboard.actor_tile_mesh)
            blackboard.actor_tile_mesh = nil
        end
        if blackboard.melee_area then
            DoneObject(blackboard.melee_area)
            blackboard.melee_area = nil
        end
        if blackboard.movement_avatar then
            UpdateMovementAvatar(dialog, point20, nil, "delete")
        end
        return
    end

    if not blackboard.melee_area and not free_aim then
        blackboard.melee_area = CombatActionCreateMeleeRangeArea(attacker)
    end
    blackboard.action_targets = blackboard.action_targets or action:GetTargets({SelectedObj})

    -- Check if can bandage potential_target
    local potential_target = dialog.potential_target
    local captureError = false
    local canAttack, attackError

    if free_aim and not potential_target then
        local _, target_obj = dialog:GetFreeAttackTarget(dialog.potential_target, attacker)
        if IsValid(target_obj) then
            potential_target = target_obj
        end
    end

    if potential_target then
        local _, err = CanCaptureUI(attacker, {
            target = potential_target
        })
        captureError = err and Untranslated(_InternalTranslate(err, {
            ["flavor"] = "",
            ["/flavor"] = ""
        }))
    end

    for _, unit in ipairs(g_Units) do
        local melee_target, bandage_target = false, false
        if potential_target == unit then
            if not captureError then
                bandage_target = true
            end
        end
        unit:SetHighlightReason("bandage-target", bandage_target)
    end

    local avatar_pos

    if captureError then
        SetAPIndicator(false, "melee-attack")
        SetAPIndicator(0, "bandage-error", captureError, nil, "force")
    else
        SetAPIndicator(false, "bandage-error")
        local apCost = action:GetAPCost(SelectedObj, {
            target = potential_target
        })
        SetAPIndicator(apCost, "melee-attack")
        dialog.target = potential_target

        if IsValid(potential_target) and potential_target ~= attacker then
            avatar_pos = SelectedObj:GetClosestMeleeRangePos(potential_target)
        end
    end

    if avatar_pos then
        if not blackboard.movement_avatar then
            UpdateMovementAvatar(dialog, point20, nil, "setup")
        end
        blackboard.movement_avatar:SetHierarchyEnumFlags(const.efVisible)
        MeleeTargetingUpdateMovementAvatar(dialog, blackboard, avatar_pos)
    elseif blackboard.movement_avatar then
        blackboard.movement_avatar:ClearHierarchyEnumFlags(const.efVisible)
    end
end

-- This is done

function CanCaptureUI(attacker, args)
    local target = args and args.target
    if not target then
        return false, AttackDisableReasons.NoTarget
    end
    if not target:IsOnEnemySide(attacker) then
        return false, AttackDisableReasons.InvalidTarget
    end

    local action = CombatActions.CapturePOW
    local err = false

    local state, reason = action:GetUIState({attacker}, args)
    if state ~= "enabled" then
        return false, reason
    end

    local cost = action:GetAPCost(attacker, args)

    if target ~= attacker and g_Combat then
        if not IsMeleeRangeTarget(attacker, nil, nil, target) then
            local pos = attacker:GetClosestMeleeRangePos(target)
            local cpath = GetCombatPath(attacker)
            local ap = cpath:GetAP(pos)
            if not ap then
                err = AttackDisableReasons.NoAP
            else
                cost = cost + Max(0, ap - attacker.free_move_ap)
            end
        end
    end
    if g_Combat and cost >= 0 and not attacker:UIHasAP(cost) then
        err = g_Combat and AttackDisableReasons.NoAP or AttackDisableReasons.TooFar
    end

    if not err and not target:IsDowned() and not target:HasStatusEffect("Unconscious") then
        err = AttackDisableReasons.InvalidTarget
    end

    return not err, err
end

-- Needs alt icon for cursor

local HUDA_OriginalUpdateCursorImage = IModeCommonUnitControl.UpdateCursorImage

function IModeCommonUnitControl:UpdateCursorImage()
    if self.action == CombatActions.CapturePOW then
        if self.potential_target and CanCaptureUI(SelectedObj, {
            target = self.potential_target
        }) then
            self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor.png")
        else
            self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor.png")
        end
    else
        HUDA_OriginalUpdateCursorImage(self)
    end
end

-- That works witout problemo

local HUDA_OriginalRecalcUIActions = Unit.RecalcUIActions

function Unit:RecalcUIActions(force)
    local actions

    if self:HasStatusEffect("Capturing") then
        local ui_actions = {
            StopCapturing = "enabled",
            ItemSkills = false
        }

        ui_actions[#ui_actions + 1] = "StopCapturing"

        local old_actions = self.ui_actions

        self.ui_actions = ui_actions

        if self == Selection[1] then
            local allMatch = false
            -- Verify that any actions have changed.
            if old_actions then
                allMatch = true
                for i, a in ipairs(old_actions) do
                    if ui_actions[i] ~= a or old_actions[a] ~= ui_actions[a] then
                        allMatch = false
                        break
                    end
                end
            end
            if not allMatch or force then
                ObjModified("combat_bar")
            end
        end

        return ui_actions
    end

    return HUDA_OriginalRecalcUIActions(self, force)
end

local HUDA_OriginalExitCombat = Unit.ExitCombat

function Unit:ExitCombat()
    if self:IsDowned() then
        local squad = self.Squad and gv_Squads[self.Squad] or false

        if squad and squad.Side == "enemy1" then
            self:Die()
            return
        end
    end

    HUDA_OriginalExitCombat(self)
end
