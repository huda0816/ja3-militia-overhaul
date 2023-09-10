PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaStartPage",
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
      T(536912996016, "HeaderButtonId")
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
        "Dock",
        "top",
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
          "VList",
          "ChildrenHandleMouse",
          false
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
            "TextStyle",
            "PDAIMPContentTitle",
            "Translate",
            true,
            "Text",
            "Welcome to the Grand Chien Militia Headquarters!"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Padding",
            box(0, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "TextStyle",
            "PDAIMPContentText",
            "Translate",
            true,
            "Text",
            "XYZ"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextFrame",
        "Dock",
        "box",
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
          box(20, 20, 0, 20),
          "VAlign",
          "top",
          "LayoutMethod",
          "VList",
          "VScroll",
          "idScrollbar"
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 0, 20, 0),
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
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
              T(157984480848, "Latest Battle Report")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Padding",
              box(0, 0, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPContentText",
              "Translate",
              true,
              "Text",
              T(543112840540, "<LatestAAR()>")
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
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
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
              T(466440547454, "What do you need to do")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Padding",
              box(0, 0, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPContentText",
              "Translate",
              true,
              "Text",
              T(646954510709, "You only need to fill a short survey of 10 questions: the P.E.T. The test can be taken as soon as you want, and you will get immediate results within the same hour. That's how fast our computers are!")
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XZuluScroll",
            "Id",
            "idScrollbar",
            "Margins",
            box(0, 0, 10, 0),
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
  })
  