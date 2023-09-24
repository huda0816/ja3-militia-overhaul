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

function HUDAOpenTutorialPopupSatelliteMap(onWindow, parent, preset, textContext)
    if not preset then
      return false
    end
    local enabled_option = GetAccountStorageOptionValue("HintsEnabled")
    if not enabled_option then
      return false
    end
    if not CanShowTutorialPopup then
      return
    end
    local state = TutorialHintsState.mode[preset.id]
    if preset.id ~= "Aiming" and state == "dismissed" then
      return false
    end
    if not parent then
      parent = GetDialog("PDADialogSatellite")
      parent = parent and parent:ResolveId("idTutorialPopup")
      parent.DrawOnTop = true
    end
    local popup = XTemplateSpawn("TutorialPopup", parent, preset)
    if onWindow then
      popup:SetAnchor(onWindow.box)
    end
    popup.idTitle:SetText(T(630309726328, "TUTORIAL"))
    popup:Open()
    popup.preset = preset
    popup.textContext = textContext
    popup:UpdateText()
    if IsKindOf(onWindow, "XMapRolloverable") then
      onWindow:SetupMapSafeArea(popup)
      popup:CreateThread("update-pos", function()
        while popup.window_state ~= "destroying" do
          onWindow:SetupMapSafeArea(popup)
          popup:InvalidateLayout()
          Sleep(16)
        end
      end)
    end
    popup:SetVisible(true)
    CurrentTutorialPopup = popup
    CanShowTutorialPopup = false
    return popup
  end

PlaceObj('TutorialHint', {
    Comment = "Triggers after trained militia",
    Text = Untranslated("Use this button to toggle between Militia and Mercenary squads."),
    group = "TutorialPopups",
    id = "ToggleMilitia",
})
