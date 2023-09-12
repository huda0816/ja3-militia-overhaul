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
        --   PDAImpHeaderEnable(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        XWindow.OnDelete(self, ...)
        --   PDAImpHeaderDisable(self)
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
        "Margins",
        box(20, 20, 20, 20),
        "LayoutMethod",
        "VList"
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
          "HAlign",
          "center",
          "VAlign",
          "top",
          "LayoutMethod",
          "VList",
          "LayoutHSpacing",
          50,
          "LayoutVSpacing",
          30
        }, {
          PlaceObj("XTemplateForEach", {
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "array",
            function(parent, context)
              return HUDA_TableValues(table.filter(gv_Squads, function(i, squad)
                return squad.militia
              end))
            end,
            "run_after",
            function(child, context, item, i, n, last)
              child.idSquadName:SetText(item.Name)
              child.idSquadLocation:SetText(item.CurrentSector)
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XButton",
              "HAlign",
              "left",
              "VAlign",
              "top",
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
                dlg:SetMode("squad", {selected_squad = self.context})
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
                "left"
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
                "right"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idBottom",
          "Margins",
          box(0, 40, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "HandleMouse",
          false,
          "TextStyle",
          "PDAIMPGalleryBottom",
          "Translate",
          true,
          "Text",
          T(509636760606, "Last updated Fri, Jan 21:39:09 2001")
        })
      })
    })
  })
})
