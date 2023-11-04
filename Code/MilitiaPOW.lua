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
        unit:SetActionCommand("Bandage", self.id, ap, ...)
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
        const.Scale.AP                                                      -- free move is already accounted for in apCost
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

local HUDA_OriginalUpdateCursorImage =  IModeCommonUnitControl.UpdateCursorImage

function IModeCommonUnitControl:UpdateCursorImage()

    if self.action == CombatActions.CapturePOW then
		if self.potential_target and CanCaptureUI(SelectedObj, { target = self.potential_target }) then
			self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor_valid.png")
		else
			self.desktop:SetMouseCursor("Mod/LXPER6t/Icons/capture_cursor_invalid.png")
		end
    else
        HUDA_OriginalUpdateCursorImage(self)
    end
end