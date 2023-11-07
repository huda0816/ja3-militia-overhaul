function Unit:ShouldGetDowned(hit_descr)
    if hit_descr and hit_descr.was_downed then
        return false
    end

    -- if not self:IsMerc() and not self.militia then
    --     return false
    -- end

    -- if not self:IsMerc() or not self.militia then

    --     if not g_Combat then
    --         return false
    --     end

    --     local downroll = InteractionRand(10, "Downed")

    --     local overkill = hit_descr.raw_damage - hit_descr.prev_hit_points

    --     print("downroll", downroll)
    --     print("overkill", overkill)

    --     local threshold = 20

    --     if downroll + overkill > threshold then
    --         return false
    --     end
    -- end

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

function GetUnitEquippedCaptureItems(unit)
    -- try to find medkit first and than first aid
    local item
    local res = unit:ForEachItem("Medkit", function(itm, slot)
        if itm.Condition > 0 then
            item = itm
            return "break"
        end
    end, item)
    if res == "break" and item then
        return item
    end
    local res = unit:ForEachItem("FirstAidKit", function(itm, slot)
        if itm.Condition > 0 then
            item = itm
            return "break"
        end
    end, item)
    return item
end

function Unit:EndCombatCapture(no_ui_update, instant)
    print("Unit:EndCombatCapture", self.command)
    local target = self:GetCaptureTarget()
    self:RemoveStatusEffect("Capturing")
    ObjModified(self)
    if IsValid(target) then
        target:RemoveStatusEffect("BeingCaptured")
        ObjModified(target)
    end

    local normal_anim = self:TryGetActionAnim("Idle", self.stance)
    if not instant then
        self:PlayTransitionAnims(normal_anim)
    end
    self:SetCombatBehavior()
    self:SetBehavior()
    if not no_ui_update and ((self == SelectedObj or target == SelectedObj)) and g_Combat then
        SetInGameInterfaceMode("IModeCombatMovement") -- force update to redraw the combat path areas now that movement is allowed
    end

    if self.command == "EndCombatCapture" then
        self:SetCommand("Idle")
    end
end

function Unit:CombatCapturePOW(target, medicine)
    print("Unit:CombatCapturePOW")
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

        print("---------------")

        self:AddStatusEffect("Capturing")
        if not GetMercInventoryDlg() then
            SetInGameInterfaceMode("IModeCombatMovement")
        end
        ObjModified(self)
        Halt()
    else
        self:PushDestructor(function()
            self:SetCombatBehavior()
            self:SetBehavior()
            self:RemoveStatusEffect("Capturing")
            target:RemoveStatusEffect("BeingCaptured")
            ObjModified(target)
            ObjModified(self)
        end)
        self:AddStatusEffect("Capturing")
        while IsValid(target) and not target:IsDead() and (target.HitPoints < target.MaxHitPoints or target:HasStatusEffect("Bleeding")) and medicine.Condition > 0 do
            Sleep(5000)
            target:GetBandaged(medicine, self)
        end
        self:SetState(self == target and "nw_Bandaging_Self_End" or "nw_Bandaging_End")
        Sleep(self:TimeToAnimEnd() or 100)
        self:PopAndCallDestructor()
    end
end

function Unit:CapturePOW(action_id, cost_ap, args)
    print("Unit:CapturePOW")
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
    local medicine = GetUnitEquippedMedicine(self)
    if not medicine then
        if self.behavior == "CapturePOW" then
            self:SetBehavior()
        end
        if self.combat_behavior == "CapturePOW" then
            self:SetCombatBehavior()
        end
        self:GainAP(action_cost)
        return
    end

    self:SetBehavior("CapturePOW", { action_id, cost_ap, args })
    self:SetCombatBehavior("CapturePOW", { action_id, cost_ap, args })

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
            self:SetBehavior("CapturePOW", { action_id, cost_ap, args })
            self:SetCombatBehavior("CapturePOW", { action_id, cost_ap, args })
        end
        self:SetState(target_self and "nw_Bandaging_Self_Idle" or "nw_Bandaging_Idle")
        if not g_Combat and not GetMercInventoryDlg() then
            SetInGameInterfaceMode("IModeExploration")
        end
    end

    self:SetCommand("CombatCapturePOW", target, medicine)
end

DefineClass.HUDA_MilitiaPOW = {}

function HUDA_MilitiaPOW:CapturingBeginTurn(eff, unit)
    Inspect(unit)

    local pow = unit:GetCaptureTarget()
    local tool = unit:GetCaptureMedicine()
    if not pow or not tool or pow.command == "Die" or pow:IsDead() then
        unit:RemoveStatusEffect("Capturing")
    end
end

function HUDA_MilitiaPOW:CapturingEndTurn(eff, unit)
    local pow = unit:GetCaptureTarget()
    local tool = unit:GetCaptureMedicine()
    if not IsValid(pow) or pow.command == "Die" or pow:IsDead() then
        unit:RemoveStatusEffect("Capturing")
        return
    end
    if pow:IsDowned() then
        -- local stabilized = patient:GetStatusEffect("Stabilized")
        -- stabilized = stabilized and stabilized:ResolveValue("stabilized")
        -- if stabilized or RollSkillCheck(target, "Medical") then
        -- 	patient:SetCommand("DownedRally", target, medicine)
        -- else
        -- 	patient:AddStatusEffect("Stabilized")
        -- end
    else
        -- patient:GetBandaged(medicine, target)
        -- if patient.HitPoints >= patient.MaxHitPoints then
        -- 	patient:RemoveStatusEffect("BeingBandaged")
        -- 	target:RemoveStatusEffect(self.class)
        -- end
    end
end

function HUDA_MilitiaPOW:CapturingOnAdded(eff, unit)
    print("HUDA_MilitiaPOW:CapturingOnAdded")

    local pow = unit:GetCaptureTarget()

    if pow then
        pow:RemoveStatusEffect("Downed")
        pow:RemoveStatusEffect("Unconscious")
        pow:RemoveStatusEffect("BleedingOut")
    end
    unit:RemoveStatusEffect("FreeMove")
end

function HUDA_MilitiaPOW:CapturingOnRemoved(eff, unit)
    local pow = unit:GetCaptureTarget()

    if pow and not pow:IsDead() and pow:IsDowned() then
        pow:RemoveStatusEffect("Stabilized")
        pow:AddStatusEffect("BleedingOut")
        pow:RemoveStatusEffect("BeingCaptured")
    elseif pow and not pow:IsDead() and pow:HasStatusEffect("Unconscious") then
        -- bla
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
    Description = T(1344589948720816, --[[CombatAction StopBandaging Description]] "Cancel the capturing action."),
    DisplayName = T(8561536980410816, --[[CombatAction StopBandaging DisplayName]] "Stop Capturing"),
    GetActionDescription = function(self, units)
        local unit = units[1]
        if unit:IsBeingCaptured() then
            return T(540349977342,
                "Cancel the capturing action. The unit will be able to move but not regain any more HP.")
        end
        if not g_Combat then
            return T(151546259528, "Cancel the capturing action.")
        end
        return self.Description
    end,
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
    id = "StopCapturing",
})

PlaceObj('CombatAction', {
    ActionPoints = 2000,
    ActivePauseBehavior = "queue",
    AimType = "melee",
    ConfigurableKeybind = false,
    Description = T(105765420738, --[[CombatAction CapturePOW Description]] "Capture downed enemy soldiers"),
    DisplayName = T(0816615556944457, --[[CombatAction CapturePOW DisplayName]] "Capture POW"),
    EvalTarget = function(self, units, target, args)
        local unit = units[1]
        if not target or not unit:IsOnEnemySide(target) then return -1 end
        if not target:IsDowned() and not target:HasStatusEffect("Unconscious") then return -1 end

        return true
    end,
    GetAPCost = function(self, unit, args)
        local medicine = self:GetAttackWeapons(unit, args)
        if not medicine then return -1 end -- can be valid in AI PrecalcAction
        return self.ActionPoints
    end,
    GetActionDescription = function(self, units)
        local unit = units[1]
        local medkit = self:GetAttackWeapons(unit)
        local hp = unit:CalcHealAmount(medkit) or 0
        local percent = MulDivRound(100, hp, unit.MaxHitPoints)
        if LastLoadedOrLoadingIMode == "IModeCombatMelee" then
            return T { 930612158384, "Select the unit you would like to bandage, healing them for <hp>% of their max HP.", hp =
                percent }
        end

        return T { self.Description, hp = percent }
    end,
    GetAnyTarget = function(self, units)
        return GetCaptureTargets(units[1], "any", "ignore")
    end,
    GetAttackWeapons = function(self, unit, args)
        return GetUnitEquippedMedicine(unit)
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
            return "disabled", AttackDisableReasons.NoBandageTarget
        end

        return "enabled"
    end,
    Icon = "Mod/LXPER6t/Icons/capture_pow.png",
    IdDefault = "Capturedefault",
    IsAimableAttack = false,
    -- KeybindingFromAction = "actionRedirectBandage",
    MoveStep = true,
    MultiSelectBehavior = "first",
    Parameters = {
        PlaceObj('PresetParamPercent', {
            'Name', "selfheal",
            'Value', 70,
            'Tag', "<selfheal>%",
        }),
        PlaceObj('PresetParamPercent', {
            'Name', "base_heal",
            'Value', 20,
            'Tag', "<base_heal>%",
        }),
        PlaceObj('PresetParamPercent', {
            'Name', "medical_max_heal",
            'Value', 30,
            'Tag', "<medical_max_heal>%",
        }),
        PlaceObj('PresetParamNumber', {
            'Name', "ReviveConditionLoss",
            'Value', 10,
            'Tag', "<ReviveConditionLoss>",
        }),
        PlaceObj('PresetParamNumber', {
            'Name', "MaxConditionHPRestore",
            'Value', 120,
            'Tag', "<MaxConditionHPRestore>",
        }),
    },
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
                    return a.Medical > b.Medical and self:GetAttackWeapons(a)
                end)
            end
            CombatActionAttackStart(self, units, args, "IModeCombatMelee")
        end
    end,
    group = "Default",
    id = "CapturePOW",
})

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

function CombatActionInteractablesChoice(self, units, args)
    local mode_dlg = GetInGameInterfaceModeDlg()
    if IsKindOf(mode_dlg, "IModeCommonUnitControl") then
        local targets = self:GetTargets(units)
        local combatChoiceUI = mode_dlg:ShowCombatActionTargetChoice(self, units, targets)
        if combatChoiceUI then
            combatChoiceUI.OnDelete = function(self)
                for i, t in ipairs(targets) do
                    t:HighlightIntensely(false, "actionsChoice")
                end
            end
        end
    else
        self:Execute(units[1], args)
    end
end

if FirstLoad then
    CombatActionStartThread = false
end

function CombatActionAttackStart(self, units, args, mode, noChangeAction)
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

        local isFreeAimMode = mode == "IModeCombatAttack" or mode == "IModeCombatMelee"
        if not isFreeAimMode and mode == "IModeCombatAreaAim" then
            local weapon = self:GetAttackWeapons(unit)
            isFreeAimMode = not IsOverwatchAction(self.id) and IsKindOf(weapon, "Firearm") and
                not IsKindOfClasses(weapon, "HeavyWeapon", "FlareGun")
        end
        isFreeAimMode = isFreeAimMode and self.id ~= "Bandage" and self.id ~= "CapturePOW"

        if isFreeAimMode and not self.RequireTargets and (not target) and freeAim then
            CreateRealTimeThread(function()
                local prompt = "ok"
                if (not args or not args.free_aim) and g_Combat then
                    local modeDlg = GetInGameInterfaceModeDlg()
                    local text = T(871884306956,
                        "There are no valid enemy targets in range. You can target the attack freely instead. <em>Free Aim</em> ranged attacks consume AP normally and can target anything, even empty spaces.")
                    if mode == "IModeCombatMelee" then
                        text = T(306912792200,
                            "There are no valid enemy targets in range. If you wish to attack a non-hostile target, you can target the attack freely instead. <em>Free Aim</em> melee attacks consume AP normally and can target any adjacent unit.")
                    end
                    local choiceUI = CreateQuestionBox(
                        modeDlg,
                        T(333335408841, "Free Aim"),
                        text,
                        T(333335408841, "Free Aim"),
                        T(1000246, "Cancel"))
                    prompt = choiceUI:Wait()
                end
                if prompt == "ok" then
                    args = args or {}
                    args.free_aim = true
                    CombatActionAttackStart(self, units, args, "IModeCombatFreeAim", noChangeAction)
                end
            end)
            return
        elseif mode == "IModeCombatMelee" and target then
            local weapon = self:GetAttackWeapons(unit)
            local ok, reason = unit:CanAttack(target, weapon, self)
            if not ok then
                ReportAttackError(args.target, reason)
                return
            end
            --if not IsMeleeRangeTarget(unit, nil, nil, target) then			
            --ReportAttackError(args.target, AttackDisableReasons.CantReach)
            --return
            --end
        end

        -- Check what actually needs switching
        local changeNeeded, dlg, targetGiven = CombatActionChangeNeededTryRetainTarget(mode, self, unit, target, freeAim)
        if mode == "IModeCombatAttack" and changeNeeded then
            target = targetGiven
        end

        -- Clicking a single target skill twice will cause the attack to proceed
        if not changeNeeded then
            if dlg.crosshair then
                dlg.crosshair:Attack()
            else
                dlg:Confirm()
            end
            return
        end

        -- This should prob have something to do with action.RequireTarget
        -- but that isn't a reliable indicator.
        if mode == "IModeCombatAttack" and not target then return end

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

        if mode == "IModeCombatAttack" and self.id ~= "MarkTarget" then
            -- The unit might step out of cover, changing their position. We want to calculate the action camera from
            -- the position where the unit will be rather than where it is, as it could show an angle we dont want (ex. crosshair on unit)
            assert(IsValid(unit))

            local action = self
            if self.group == "FiringModeMetaAction" then
                action = GetUnitDefaultFiringModeActionFromMetaAction(unit, self)
            end

            NetSyncEvent("Aim", unit, action.id, target)
            WaitMsg("AimIdleLoop", 800)
        end

        -- Patch selection outside of combat to remove multiselection
        -- We're not doing this through SelectObj as the selection changed msg
        -- will cancel the action.
        if not g_Combat then
            Selection = { unit }
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

function Targeting_UnitInMelee(dialog, blackboard, command, pt)
    local action = dialog.action
    local attacker = dialog.attacker
    local action_pos = attacker:GetPos()
    local bandaging = dialog.action.id == "Bandage"
    local capturing = dialog.action.id == "CapturePOW"
    local brutalize = dialog.action.id == "Brutalize"
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
    else
        if not bandaging and not capturing and g_Combat and not IsValid(blackboard.actor_tile_mesh) then
            blackboard.contour_target_action = "TargetMelee"
            local style = g_ActionTextStyles[blackboard.contour_target_action] or blackboard.contour_target_action
            blackboard.actor_tile_mesh = PlaceSingleTileStaticContourMesh(style, action_pos)
        end
        if not blackboard.melee_area and not free_aim then
            blackboard.melee_area = CombatActionCreateMeleeRangeArea(attacker)
        end
        blackboard.action_targets = blackboard.action_targets or action:GetTargets({ SelectedObj })
    end

    -- Check if can bandage potential_target
    local potential_target = dialog.potential_target
    local bandageError = false
    local captureError = false
    local canAttack, attackError

    -- if (potential_target) then
    --     Inspect(dialog)
    -- end

    if free_aim and not potential_target then
        local _, target_obj = dialog:GetFreeAttackTarget(dialog.potential_target, attacker)
        if IsValid(target_obj) then
            potential_target = target_obj
        end
    end

    if potential_target then
        if bandaging then
            local _, err = CanBandageUI(attacker, { target = potential_target })
            bandageError = err and Untranslated(_InternalTranslate(err, { ["flavor"] = "", ["/flavor"] = "" }))
        elseif capturing then
            local _, err = CanCaptureUI(attacker, { target = potential_target })
            captureError = err and Untranslated(_InternalTranslate(err, { ["flavor"] = "", ["/flavor"] = "" }))
        elseif potential_target ~= attacker then
            local weapon = action:GetAttackWeapons(attacker)
            canAttack, attackError = attacker:CanAttack(potential_target, weapon, action, 0, nil, nil, free_aim)
        end
    end

    for _, unit in ipairs(g_Units) do
        local melee_target, bandage_target = false, false
        if potential_target == unit then
            if bandaging and not bandageError then
                bandage_target = true
            elseif capturing and not captureError then
                bandage_target = true
            elseif not bandaging and not capturing and canAttack then
                melee_target = true
            end
        end
        unit:SetHighlightReason("melee-target", melee_target)
        unit:SetHighlightReason("bandage-target", bandage_target)
    end

    local avatar_pos

    if bandaging then
        if bandageError then
            SetAPIndicator(false, "melee-attack")
            SetAPIndicator(0, "bandage-error", bandageError, nil, "force")
        else
            SetAPIndicator(false, "bandage-error")
            local apCost = action:GetAPCost(SelectedObj, { target = potential_target })
            SetAPIndicator(apCost, "melee-attack")
            dialog.target = potential_target

            if IsValid(potential_target) and potential_target ~= attacker then
                avatar_pos = SelectedObj:GetClosestMeleeRangePos(potential_target)
            end
        end
    elseif capturing then
        if captureError then
            SetAPIndicator(false, "melee-attack")
            SetAPIndicator(0, "bandage-error", captureError, nil, "force")
        else
            SetAPIndicator(false, "bandage-error")
            local apCost = action:GetAPCost(SelectedObj, { target = potential_target })
            SetAPIndicator(apCost, "melee-attack")
            dialog.target = potential_target

            if IsValid(potential_target) and potential_target ~= attacker then
                avatar_pos = SelectedObj:GetClosestMeleeRangePos(potential_target)
            end
        end
    else
        local args = { target = potential_target, ap_cost_breakdown = {} }
        local apCost = action:GetAPCost(SelectedObj, args)
        local free_move_ap_used = Min(args.ap_cost_breakdown.move_cost or 0, SelectedObj.free_move_ap)
        apCost = apCost - Max(0, free_move_ap_used)
        -- round the cost to match before/after AP readings
        local before = SelectedObj:GetUIActionPoints() / const.Scale.AP
        local after = (SelectedObj:GetUIActionPoints() - apCost) /
            const.Scale
            .AP -- free move is already accounted for in apCost
        apCost = (before - after) * const.Scale.AP

        if APIndicator and #APIndicator > 1 then
            SetAPIndicator(false, "brutalize")
        end
        if action.id == "Brutalize" then
            local num = SelectedObj:GetNumBrutalizeAttacks()
            SetAPIndicator(0, "brutalize", T { 145407413631, "<num> attacks", num = num }, "append", "force")
        end
        if canAttack then
            dialog.target = potential_target
            if IsValid(potential_target) then
                avatar_pos = SelectedObj:GetClosestMeleeRangePos(potential_target)
                for _, api in ipairs(APIndicator) do
                    if api.reason == "attack" then
                        api.ap = apCost
                    end
                end
                ObjModified(APIndicator)
            end
            ApplyDamagePrediction(SelectedObj, action, { target = potential_target })
        else
            dialog.target = nil
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

function CanCaptureUI(attacker, args)
    local target = args and args.target
    local pos = args and args.goto_pos
    if not target then return false, AttackDisableReasons.NoTarget end
    if not target:IsOnEnemySide(attacker) then return false, AttackDisableReasons.InvalidTarget end

    local action = CombatActions.CapturePOW
    local err = false

    local state, reason = action:GetUIState({ attacker }, args)
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

            --err = AttackDisableReasons.NotInBandageRange
        end
    end
    if g_Combat and cost >= 0 and not attacker:UIHasAP(cost) then
        err = g_Combat and AttackDisableReasons.NoAP or AttackDisableReasons.TooFar
    end

    if not err and not target:IsDowned() and not target:HasStatusEffect("Unconscious") then
        err = AttackDisableReasons.FullHP
    end

    return not err, err
end

local HUDA_OriginalUpdateCursorImage = IModeCommonUnitControl.UpdateCursorImage

function IModeCommonUnitControl:UpdateCursorImage()
    if self.action == CombatActions.CapturePOW then
        if self.potential_target and CanCaptureUI(SelectedObj, { target = self.potential_target }) then
            self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor.png")
        else
            self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor.png")
        end
    else
        HUDA_OriginalUpdateCursorImage(self)
    end
end

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
            if not allMatch or force then ObjModified("combat_bar") end
        end

        return ui_actions
    end

    return HUDA_OriginalRecalcUIActions(self, force)
end
