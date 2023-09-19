PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaSidebarNewbies",
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
                local newbieMilitia = table.filter(gv_UnitData, function(k, v)
                    return v.militia and string.gmatch(v.session_id, "Rookie") and v.HireStatus ~= "Dead" and v.Squad
                end)

                newbieMilitia = HUDA_ReindexTable(newbieMilitia)

                if #newbieMilitia == 0 then
                    return {}
                end

                table.sort(newbieMilitia, function(a, b)
                    return a.session_id > b.session_id
                end)

                local squad = newbieMilitia[1].Squad

                local squadNewbs = table.filter(newbieMilitia, function(k, v)
                    return v.Squad == squad and v.JoinDate < (Game.CampaignTime + 48 * 60 * 60)
                end)

                return squadNewbs
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
                "New Recruits"
            }),
            PlaceObj("XTemplateWindow", {
                "LayoutMethod",
                "VList",
                "LayoutVSpacing",
                0,
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "TextStyle",
                    "PDAIMPGalleryName",
                    "OnLayoutComplete",
                    function(self)
                        local squadName = HUDA_GetSquadName(self.context[1].Squad)
                        local sectorName = TDevModeGetEnglishText(HUDA_GetSectorNamePure(HUDA_GetSector(self.context[1].session_id)))
                        self:SetText((squadName or "Squad") .. " / " .. (sectorName or "Sector"))
                    end
                }),
                PlaceObj("XTemplateForEach", {
                    "__context",
                    function(parent, context, item, i, n)
                        return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                        child.idSoldierName:SetText(item.Nick)
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

                        })
                    })
                })
            })
        })
    })
})
