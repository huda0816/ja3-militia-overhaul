PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAMilitiaHome",
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
        false,
        "LayoutVSpacing",
        10
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
          "Welcome to the Grand Chien Militia Hub!"
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
          "At the Grand Chien Militia, we're not just about duty and discipline; we're also a tightly-knit family."
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
        box(20, 20, 20, 20),
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "VScroll",
        "idScrollbar"
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(0, 0, 0, 0),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateForEach", {
            "__context",
            function(parent, context, item, i, n)
              return item
            end,
            "array",
            function(parent, context)
              return table.move(gv_HUDA_News, 1, 10, 1, {})
            end,
            "run_after",
            function(child, context, item, i, n, last)
              
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Padding",
              box(0, 0, 0, 0),
              "Margins",
              box(0, 0, 0, 5),
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
              Untranslated("<title>")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Padding",
              box(0, 0, 0, 0),
              "Margins",
              box(0, 0, 0, 5),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "HandleMouse",
              false,
              "TextStyle",
              "PDAIMPGalleryName",
              "Translate",
              true,
              "Text",
              Untranslated("<NewsMeta(context)>")
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
              Untranslated("<text>")
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "line",
              "__class",
              "XImage",
              "Margins",
              box(0, 10, 0, 10),
              "VAlign",
              "center",
              "Transparency",
              141,
              "Image",
              "UI/PDA/separate_line_vertical",
              "ImageFit",
              "stretch-x"
            }),
          }),
        }),
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
