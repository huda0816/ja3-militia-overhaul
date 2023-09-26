function ShowToggleMilitiaTutorial()
    if TutorialHintsState.ToggleMilitia then
        return
    end
    local dlg = GetDialog("PDADialogSatellite")
    local toggleBtn = dlg and dlg:ResolveId("idContent"):ResolveId("idPartyContainer"):ResolveId("idMilitiaToggleButton")
    if not toggleBtn or toggleBtn.box == empty_box then
        return
    end
    local preset = TutorialHints.ToggleMilitia
    local popup = OpenTutorialPopupSatelliteMap(toggleBtn, false, preset)
    if not popup then
        return
    end
    popup.parent.DrawOnTop = true
    TutorialHintsState.ToggleMilitiaShown = true
    popup:CreateThread("observe-popup", function()
        while popup.window_state ~= "destroying" and popup.window_state ~= "closing" do
            if TutorialHintsState.ToggleMilitia then
                CloseCurrentTutorialPopup()
            end
            Sleep(100)
        end
    end)
end

PlaceObj('TutorialHint', {
    Comment = "Triggers after trained militia",
    Text = Untranslated("Use this button to toggle between Militia and Mercenary squads."),
    group = "TutorialPopups",
    id = "ToggleMilitia",
})
