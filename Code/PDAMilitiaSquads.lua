PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMilitiaSquads",
  PlaceObj("XTemplateProperty", {
    "id",
    "HeaderButtonId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.HeaderButtonId = value
    end,
    "Get",
    function(self)
      return self.HeaderButtonId
    end,
    "name",
    T(781809329109, "HeaderButtonId")
  }),
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    8
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XWindow.Open(self, ...)
        PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        PDAImpHeaderDisable(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Image",
      "UI/PDA/imp_panel",
      "FrameBox",
      box(8, 8, 8, 8),
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "IdNode",
        false,
        "Margins",
        box(20, 20, 20, 20),
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "VScroll",
        "idScrollbar"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPContentTitle",
          "Translate",
          true,
          "Text",
          T(361347984095, "MILITIA SQUADS")
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 10, 0, 0),
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          10
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList",
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryName",
              "TextHAlign",
              "left",
              "MinWidth",
              300,
              "MaxWidth",
              300,
              "Text",
              "Squad Name"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryBottom",
              "MinWidth",
              70,
              "MaxWidth",
              70,
              "TextHAlign",
              "left",
              "Text",
              "Units"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryBottom",
              "MinWidth",
              100,
              "MaxWidth",
              100,
              "TextHAlign",
              "left",
              "Text",
              "Location"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryBottom",
              "MinWidth",
              130,
              "MaxWidth",
              130,
              "TextHAlign",
              "left",
              "Text",
              "Status"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryBottom",
              "MinWidth",
              100,
              "MaxWidth",
              100,
              "TextHAlign",
              "left",
              "Text",
              "Costs"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "line",
            "__class",
            "XImage",
            "Margins",
            box(0, 5, 0, 5),
            "VAlign",
            "center",
            "Transparency",
            141,
            "Image",
            "UI/PDA/separate_line_vertical",
            "ImageFit",
            "stretch-x"
          }),
          PlaceObj("XTemplateForEach", {
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "array",
            function(parent, context)
              local squads = HUDA_TableValues(table.filter(gv_Squads, function(i, squad)
                return squad.militia
              end))

              table.sort(squads, function(a, b)
                return a.UniqueId < b.UniqueId
              end)

              return squads

            end,
            "run_after",
            function(child, context, item, i, n, last)
              child.idSquadName:SetText(item.Name)
              child.idSquadLocation:SetText(item.CurrentSector)
              if gv_Sectors[item.CurrentSector].conflict then
                child.idSquadStatus:SetText("In Conflict")
              elseif item.route and item.route.displayedSectionEnd then
                child.idSquadStatus:SetText("Moves towards: " .. item.route.displayedSectionEnd)
              else
                child.idSquadStatus:SetText("Defending")
              end
              child.idSquadUnits:SetText(#item.units)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "LayoutMethod",
              "HList",
              "Background",
              RGBA(255, 255, 255, 0),
              "MouseCursor",
              "UI/Cursors/Pda_Hand.tga",
              "FocusedBackground",
              RGBA(255, 255, 255, 0),
              "OnPress",
              function(self, gamepad)
                local dlg = GetDialog(self)
                dlg:SetMode("squad", { selected_squad = self.context })
              end,
              "RolloverBackground",
              RGBA(255, 255, 255, 0),
              "PressedBackground",
              RGBA(255, 255, 255, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadName",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryName",
                "TextHAlign",
                "left",
                "MinWidth",
                300,
                "MaxWidth",
                300,
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadUnits",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryBottom",
                "Translate",
                true,
                "TextHAlign",
                "left",
                "MinWidth",
                70,
                "MaxWidth",
                70,
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadLocation",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryBottom",
                "Translate",
                true,
                "TextHAlign",
                "left",
                "MinWidth",
                100,
                "MaxWidth",
                100,
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadStatus",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryBottom",
                "Translate",
                true,
                "TextHAlign",
                "left",
                "MinWidth",
                130,
                "MaxWidth",
                130,
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idSquadCosts",
                "HandleMouse",
                false,
                "TextStyle",
                "PDAIMPGalleryBottom",
                "Translate",
                true,
                "TextHAlign",
                "left",
                "MinWidth",
                100,
                "MaxWidth",
                100,
                "Text",
                Untranslated("<MilitiaSquadCosts(context)>$")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "line",
              "__class",
              "XImage",
              "Margins",
              box(0, 5, 0, 5),
              "VAlign",
              "center",
              "Transparency",
              141,
              "Image",
              "UI/PDA/separate_line_vertical",
              "ImageFit",
              "stretch-x"
            }),
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XZuluScroll",
        "Id",
        "idScrollbar",
        "Margins",
        box(0, 5, 5, 5),
        "Dock",
        "right",
        "UseClipBox",
        false,
        "Target",
        "idScrollArea",
        "AutoHide",
        true
      })
    })
  })
})
