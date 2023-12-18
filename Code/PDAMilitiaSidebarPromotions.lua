function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaSidebarPromotions",
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                return "sidebar promotions"
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
                    local promotedMilitia = table.filter(gv_UnitData, function(k, v)
                        return v.militia and next(v.OldSessionIds)
                    end)

                    promotedMilitia = HUDA_ReindexTable(promotedMilitia)

                    table.sort(promotedMilitia, function(a, b)
                        return a.session_id > b.session_id
                    end)

                    local latestPromotions = {}

                    for i, v in ipairs(promotedMilitia) do
                        if i <= 3 then
                            table.insert(latestPromotions, v)
                        end
                    end

                    return latestPromotions
                end,
                "__condition",
                function(parent, context)
                    return #context > 0
                end,
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                5,
                "Background",
                RGBA(255, 255, 255, 255),
                "Padding",
                box(5, 5, 5, 5),
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "TextStyle",
                    "PDAIMPMercName",
                    "Translate",
                    true,
                    "Text",
                    "Promotions"
                }),
                PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    3,
                }, {
                    PlaceObj("XTemplateForEach", {
                        "__context",
                        function(parent, context, item, i, n)
                            return item
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            child.idSoldierName:SetText(item.Nick)
                            child.idSoldierRank:SetText(Untranslated('<em>to: ' .. HUDA_GetRank(item) .. '</em>'))
                        end
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "IdNode",
                            true,
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
                                "idSoldierRank",
                                "Margins",
                                box(0, -3, 0, 0),
                                "HandleMouse",
                                false,
                                "TextStyle",
                                "PDAIMPGalleryName",
                                "Translate",
                                true,
                                "TextHAlign",
                                "left"
                            })
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(0, 0, 0, 0),
                    "TextStyle",
                    "HandleMouse",
                    false,
                    "PDAIMPGalleryName",
                    "IdNode",
                    true,
                    "Translate",
                    true,
                    "Text",
                    "We congratulate our soldiers on their promotions and wish them good luck."
                })
            })
        })
    })
end
