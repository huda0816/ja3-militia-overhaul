PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaSidebarRIP",
    PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
            return "sidebar rip"
        end,
        "__class",
        "XContentTemplate",
        "LayoutMethod",
        "VList"
    }, {
        PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "__context",
            function(parent, context)
                local deadMilitia = table.filter(gv_UnitData, function(k, v)
                    return v.militia and v.HireStatus == "Dead"
                end)

                local deadMilitiaArr = HUDA_ReindexTable(deadMilitia)

                table.sort(deadMilitiaArr, function(a, b)
                    return a.HiredUntil > b.HiredUntil
                end)

                local featured = {}

                for i, v in ipairs(deadMilitiaArr) do
                    if i <= 3 then
                        table.insert(featured, v)
                    end
                end
                return featured
            end,
            "__condition",
            function(parent, context)
                return #context > 0
            end,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            10,
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "TextStyle",
                "PDAIMPMercName",
                "Translate",
                true,
                "Text",
                "Rest in Peace"
            }),
            PlaceObj("XTemplateWindow", {
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                10,
            }, {
                PlaceObj("XTemplateForEach", {
                    "__context",
                    function(parent, context, item, i, n)
                        return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                        child.idSoldierName:SetText(item.Nick)
                        child.idSoldierHome:SetText(HUDA_GetSectorNamePure(HUDA_GetSectorById(item.JoinLocation)))
                        child.idPortrait:SetImage(item.Portrait)
                    end
                }, {
                    PlaceObj("XTemplateWindow", {
                        "IdNode",
                        true,
                        "Margins",
                        box(0, 0, 0, 0),
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        0,
                        "Background",
                        RGBA(255, 255, 255, 255),
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "Margins",
                            box(0, 0, 0, 0)
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XImage",
                                "Id",
                                "idPortraitBG",
                                "IdNode",
                                false,
                                "MinHeight",
                                90,
                                "MaxHeight",
                                90,
                                "Image",
                                "UI/Hud/portrait_background",
                                "ImageColor",
                                RGBA(0, 0, 0, 255),
                                "Desaturation",
                                255,
                                "ImageFit",
                                "stretch"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XImage",
                                "Id",
                                "idPortrait",
                                "MinWidth",
                                80,
                                "MinHeight",
                                90,
                                "MaxWidth",
                                80,
                                "MaxHeight",
                                90,
                                "Image",
                                "UI/MercsPortraits/Igor",
                                "ImageFit",
                                "width",
                                "Desaturation",
                                255,
                                "ImageRect",
                                box(36, 0, 264, 251)
                            })
                        }),
                        PlaceObj("XTemplateWindow", {
                            "Margins",
                            box(5, 5, 5, 5),
                            "LayoutMethod",
                            "VList",
                            "LayoutVSpacing",
                            0,
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idSoldierName",
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
                                "idSoldierHome",
                                "HandleMouse",
                                false,
                                "TextStyle",
                                "PDABrowserThievesBoxLinksSuffix",
                                "Translate",
                                true,
                                "TextHAlign",
                                "left"
                            })
                        })
                    })
                })
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Margins",
                box(0, 0, 0, 0),
                "MouseCursor",
                "UI/Cursors/Pda_Hand.tga",
                "TextStyle",
                "PDAIMPHyperLinkSmall",
                "IdNode",
                true,
                "Translate",
                true,
                "Text",
                Untranslated("<underline>Send Flowers</underline>"),
            }, {
                PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                        local pda_browser_dialog = GetPDABrowserDialog()
                        if pda_browser_dialog then
                            pda_browser_dialog:SetMode("banner_page", "PDABrowserMortuary")
                        end
                    end
                })
            }),
        })
    })
})
