UndefineClass('Capturing')
DefineClass.Capturing = {
	__parents = { "StatusEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "StatusEffect",
	unit_reactions = {
		PlaceObj('UnitReaction', {
			Event = "OnBeginTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:CapturingBeginTurn(self, target)
			end,
		}),
		PlaceObj('UnitReaction', {
			Event = "OnEndTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:CapturingEndTurn(self, target)
			end,
		}),
	},
	DisplayName = T(319577241264, --[[ModItemCharacterEffectCompositeDef Capturing DisplayName]] "Capturing"),
	Description = T(802939443992, --[[ModItemCharacterEffectCompositeDef Capturing Description]] "Capturing a downed or unconscious enemy. No more actions available this turn."),
	AddEffectText = T(386858606898, --[[ModItemCharacterEffectCompositeDef Capturing AddEffectText]] "Capturing"),
	OnAdded = function (self, obj)
		HUDA_MilitiaPOW:CapturingOnAdded(self, obj)
	end,
	OnRemoved = function (self, obj)
		HUDA_MilitiaPOW:CapturingOnRemoved(self, obj)
	end,
	Icon = "Mod/LXPER6t/Icons/capture.png",
	RemoveOnSatViewTravel = true,
	Shown = true,
	HasFloatingText = true,
}

