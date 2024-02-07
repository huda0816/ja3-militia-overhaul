UndefineClass('BleedingOut')
DefineClass.BleedingOut = {
	__parents = { "CharacterEffect" },
	__generated_by_class = "ModItemCharacterEffectCompositeDef",


	object_class = "CharacterEffect",
	unit_reactions = {
		PlaceObj('UnitReaction', {
			Event = "OnEndTurn",
			Handler = function (self, target)
				HUDA_MilitiaPOW:HandleBleedingOut(self,target)
			end,
		}),
	},
	Conditions = {
		PlaceObj('CombatIsActive', {}),
	},
	DisplayName = T(235925290124, --[[ModItemCharacterEffectCompositeDef BleedingOut DisplayName]] "Downed"),
	Description = T(231665814225, --[[ModItemCharacterEffectCompositeDef BleedingOut Description]] "This character is in <color EmStyle>Critical condition</color> and will bleed out unless treated with the <color EmStyle>Bandage</color> action or gets <color EmStyle>Captured</color>. The character remains alive if a successful check against Health is made next turn."),
	OnAdded = function (self, obj)  end,
	Icon = "UI/Hud/Status effects/bleedingout",
	Shown = true,
}

