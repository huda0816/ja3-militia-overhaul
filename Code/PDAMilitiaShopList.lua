function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaShopList",
        PlaceObj("XTemplateProperty", {
            "id",
            "NavButtonId",
            "editor",
            "text",
            "translate",
            false,
            "Set",
            function(self, value)
                self.NavButtonId = value
            end,
            "Get",
            function(self)
                return self.NavButtonId
            end,
            "name",
            T(536912996016, "NavButtonId")
        }),
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
            "__class",
            "XContentTemplate",
            "__context",
            function(parent, context)
                return "shop list"
            end
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
            PlaceObj("XTemplateFunc", {
                "name",
                "RespawnContent(self)",
                "func",
                function(self)
                    local scroll = self[1][2].idScroll

                    local list = self[1][2].idScrollArea

                    local lastScrollPos = scroll and scroll:GetScroll()

                    local lastSelected = list and list.selection and #list.selection >= 1 and list.selection

                    XContentTemplate.RespawnContent(self)
                    RunWhenXWindowIsReady(self, function()
                        if self[1][2].idScroll and lastScrollPos then
                            self[1][2].idScroll:SetScroll(lastScrollPos)
                        end
                        if self[1][2].idScrollArea and lastScrollPos then
                            self[1][2].idScrollArea:ScrollTo(0, lastScrollPos)
                        end
                    end)
                end
            }),
            PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                    local dlg = GetDialog(parent)
                    if dlg.mode_param then
                        context = dlg.mode_param
                    end
                    return context
                end,
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
                        AddPageToBrowserHistory("shop_list")
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
                        "LayoutVSpacing",
                        10,
                        "OnLayoutComplete",
                        function(self)
                            if self.parent.context.item.image and self[1] then
                                self[1]:SetImage(self.parent.context.item.image)
                            end
                        end
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "__class",
                            "XImage",
                            "__condition",
                            function(parent, context)
                                return context.item and context.item.image or false
                            end,
                            "Id",
                            "idCategoryImage",
                            "ImageFit",
                            "stretch",
                            "MinWidth",
                            647,
                            "MinHeight",
                            120,
                            "MaxWidth",
                            647,
                            "MaxHeight",
                            120,
                        }),
                        PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "__condition",
                            function(parent, context)
                                return context.item.title and context.item.title ~= ""
                            end,
                            "Id",
                            "idTitle",
                            "FoldWhenHidden",
                            true,
                            "Padding",
                            box(0, 0, 0, 0),
                            "HAlign",
                            "left",
                            "VAlign",
                            "top",
                            "TextStyle",
                            "PDAIMPContentTitle",
                            "OnLayoutComplete",
                            function(self)
                                self:SetText(Untranslated(self.context.item.title))
                            end,
                            "Translate",
                            true,
                            "Text",
                            Untranslated("<name>")
                        }),
                        PlaceObj("XTemplateWindow", {
                            "__class",
                            "XText",
                            "__condition",
                            function(parent, context)
                                return context.item.description and context.item.description ~= ""
                            end,
                            "Padding",
                            box(0, 0, 0, 0),
                            "HAlign",
                            "left",
                            "VAlign",
                            "top",
                            "TextStyle",
                            "PDAIMPContentText",
                            "OnLayoutComplete",
                            function(self)
                                self:SetText(Untranslated(self.context.item.description))
                            end,
                            "Translate",
                            true,
                            "Text",
                            Untranslated("<item<description>>")
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
                        "idScroll"
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "__condition",
                            function(parent, context)
                                local query = table.copy(context.query)

                                query.new = true

                                local products = HUDA_ShopController:GetProducts(query)

                                return #products > 0
                            end,
                            "Margins",
                            box(0, 0, 0, 0),
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
                                Untranslated("New Arrivals")
                            }),
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
                                        local query = table.copy(context.query)

                                        query.new = true

                                        local products = HUDA_ShopController:GetProducts(query)

                                        return products
                                    end
                                }, {
                                    PlaceObj("XTemplateTemplate", {
                                        "__template",
                                        "PDAMilitiaShopProduct"
                                    })
                                })
                            })
                        }),
                        PlaceObj("XTemplateWindow", {
                            "__condition",
                            function(parent, context)
                                local query = table.copy(context.query)

                                query.new = false

                                local products = HUDA_ShopController:GetProducts(query)

                                return #products > 0
                            end,
                            "Margins",
                            box(0, 0, 0, 0),
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
                                Untranslated("Products")
                            }),
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
                                        local query = table.copy(context.query)

                                        query.new = false

                                        local products = HUDA_ShopController:GetProducts(query)

                                        return products
                                    end
                                }, {
                                    PlaceObj("XTemplateTemplate", {
                                        "__template",
                                        "PDAMilitiaShopProduct"
                                    })
                                })
                            })
                        })
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XZuluScroll",
                        "Id",
                        "idScroll",
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
    })
end
