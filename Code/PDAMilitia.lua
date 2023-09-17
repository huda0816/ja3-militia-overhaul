PlaceObj("XTemplate", {
    __is_kind_of = "XDialog",
    group = "Zulu PDA",
    id = "PDAMilitiaDialog",
    PlaceObj("XTemplateWindow", {
        "__class",
        "XDialog",
        "Background",
        RGBA(215, 159, 80, 255),
        "MouseCursor",
        "UI/Cursors/Pda_Cursor.tga",
        "Id",
        "idPDAMilitiaDialog",
        "InitialMode",
        "home",
        "InternalModes",
        "home,finances,squads,squad,soldier,construction,shop,orders,shop_list,trick,shop_closed, conditions"
    }, {
        PlaceObj("XTemplateFunc", {
            "name",
            "Open",
            "func",
            function(self, ...)
                self.clicked_links = {}
                AddPageToBrowserHistory("militia")
                XDialog.Open(self, ...)
                self:SetFocus()
                ObjModified("right panel")
                ObjModified("left panel")
                ObjModified("militia header")
            end
        }),
        PlaceObj("XTemplateFunc", {
            "name",
            "CanClose()",
            "func",
            function()
                return true
            end
        }),
        PlaceObj("XTemplateFunc", {
            "name",
            "OnDialogModeChange(self, mode, dialog)",
            "func",
            function(self, mode, dialog)
                -- if mode == "start_page" then
                --     self:SetMode("home")
                --     return
                -- end
                ObjModified("pda_url")
            end
        }),
        PlaceObj("XTemplateFunc", {
            "name",
            "GetURL(self, mode, mode_param)",
            "func",
            function(self, mode, mode_param)
                if mode == "finances" then
                    return Untranslated("http://www.gc-militia.org/finances")
                elseif mode == "squads" then
                    return Untranslated("http://www.gc-militia.org/squads")
                elseif mode == "squad" then
                    return Untranslated("http://www.gc-militia.org/squads?id=" .. mode_param.selected_squad.UniqueId)
                elseif mode == "soldier" then
                    return Untranslated("http://www.gc-militia.org/squads?soldier=" .. mode_param.soldier.Nick)
                elseif mode == "construction" then
                    return Untranslated("http://www.gc-militia.org/construction")
                elseif mode == "shop" then
                    return Untranslated("http://www.gc-militia.org/shop")
                elseif mode == "shop_list" then
                    return Untranslated("http://www.gc-militia.org/shop" ..
                        (mode_param.query and HUDA_ShopController:GetQueryUrlParams(mode_param.query) or ""))
                elseif mode == "orders" then
                    return Untranslated("http://www.gc-militia.org/shop?orders=1")
                end

                ObjModified("pda_url")
            end
        }),
        PlaceObj("XTemplateFunc", {
            "name",
            "SetMode(self, mode,...)",
            "func",
            function(self, mode, ...)
                if mode ~= self.Mode then
                    XDialog.SetMode(self, mode, ...)
                end
            end
        }),
        PlaceObj("XTemplateFunc", {
            "name",
            "OnShortcut(self, shortcut, source, ...)",
            "func",
            function(self, shortcut, source, ...)
                if shortcut == "ButtonB" or shortcut == "Escape" then
                    local host = self.parent
                    host = GetDialog(GetDialog(host).parent)
                    if host then
                        host:CloseAction(host)
                    end
                    return "break"
                end
                local mode = self:GetMode()
                local actions = self:GetShortcutActions(shortcut)
                for _, action in ipairs(actions) do
                    local state = action:ActionState(self)
                    if state ~= "disabled" and state ~= "hidden" then
                        action:OnAction(self, "gamepad")
                        return "break"
                    end
                end
            end
        }),
        PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Dock",
            "box",
            "Image",
            "UI/PDA/imp_background",
            "ImageFit",
            "stretch"
        }),
        PlaceObj("XTemplateAction", {
            "ActionId",
            "idCloseAction",
            "ActionName",
            T(208185069032, "Close"),
            "ActionShortcut",
            "Escape",
            "ActionGamepad",
            "ButtonB",
            "OnAction",
            function(self, host, source, ...)
                local pda = GetDialog("PDADialog")
                pda:CloseAction(host)
            end,
            "FXMouseIn",
            "buttonRollover",
            "FXPress",
            "buttonPress",
            "FXPressDisabled",
            "IactDisabled"
        }),
        PlaceObj("XTemplateWindow", {
            "__class",
            "VirtualCursorManager",
            "Reason",
            "Militia"
        }),
        PlaceObj("XTemplateWindow", {
            "HAlign",
            "center",
            "MinWidth",
            1076,
            "MaxWidth",
            1076
        }, {
            PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "header",
                    "__context",
                    function(parent, context)
                        return "militia header"
                    end,
                    "Id",
                    "idHeader",
                    "IdNode",
                    true,
                    "Margins",
                    box(0, 4, 0, 0),
                    "Dock",
                    "top",
                    "HAlign",
                    "center",
                    "VAlign",
                    "top",
                    "MinWidth",
                    1076,
                    "MinHeight",
                    136,
                    "MaxWidth",
                    1076,
                }, {
                    PlaceObj("XTemplateWindow", {
                        "Margins",
                        box(0, 40, 0, 40),
                        "Background",
                        RGBA(88, 92, 68, 255)
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "Margins",
                            box(190, 0, 0, 0),
                            "Padding",
                            box(0, 0, 0, 0),
                            "HAlign",
                            "left",
                            "VAlign",
                            "top",
                            "MinWidth",
                            56,
                            "MinHeight",
                            50,
                            "MaxHeight",
                            50,
                            "LayoutMethod",
                            "HList"
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idPageTitle",
                                "TextStyle",
                                "PDAIMPPageTitle",
                                "Translate",
                                true,
                                "Text",
                                "Grand Chien Militia Headquarters",
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Margins",
                                box(5, 0, 0, 6),
                                "HAlign",
                                "left",
                                "VAlign",
                                "bottom",
                                "TextStyle",
                                "PDAIMPCopyrightText",
                                "Translate",
                                true,
                                "Text",
                                "powered by I.M.P."
                            }),
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "line",
                            "Margins",
                            box(26, 0, 26, 48),
                            "VAlign",
                            "bottom",
                            "MinHeight",
                            2,
                            "MaxHeight",
                            2,
                            "Background",
                            RGBA(124, 130, 96, 255)
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "links left",
                            "__context",
                            function(parent, context)
                                return "header links"
                            end,
                            "__class",
                            "XContextWindow",
                            "Id",
                            "idLeftLinks",
                            "IdNode",
                            true,
                            "Margins",
                            box(190, 0, 0, 0),
                            "MaxHeight",
                            48,
                            "HAlign",
                            "left",
                            "VAlign",
                            "bottom",
                            "LayoutMethod",
                            "HList",
                            "LayoutHSpacing",
                            6,
                            "ContextUpdateOnOpen",
                            true
                        }, {
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "home",
                                "__template",
                                "PDAMilitiaHyperlinkHeader",
                                "Id",
                                "idHome",
                                "LinkId",
                                "home",
                                "dlg_mode",
                                "home",
                                "Text",
                                "Home"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                22,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                22,
                                "Background",
                                RGBA(124, 130, 96, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "finances",
                                "__template",
                                "PDAMilitiaHyperlinkHeader",
                                "Id",
                                "idFinances",
                                "LinkId",
                                "finances",
                                "dlg_mode",
                                "finances",
                                "Text",
                                "FINANCES"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                22,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                22,
                                "Background",
                                RGBA(124, 130, 96, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "squads",
                                "__template",
                                "PDAMilitiaHyperlinkHeader",
                                "Id",
                                "idSquads",
                                "LinkId",
                                "squads",
                                "dlg_mode",
                                "squads",
                                "Text",
                                "SQUADS"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                22,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                22,
                                "Background",
                                RGBA(124, 130, 96, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "shop",
                                "__template",
                                "PDAMilitiaHyperlinkHeader",
                                "Id",
                                "idShop",
                                "LinkId",
                                "shop",
                                "dlg_mode",
                                "shop",
                                "Text",
                                "SHOP"
                            })
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "links right",
                            "__context",
                            function(parent, context)
                                return "header links"
                            end,
                            "__class",
                            "XContextWindow",
                            "IdNode",
                            true,
                            "Margins",
                            box(0, 0, 30, 0),
                            "MaxHeight",
                            48,
                            "HAlign",
                            "right",
                            "VAlign",
                            "bottom",
                            "ContextUpdateOnOpen",
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                                -- local dlg = GetDialog(self)
                                -- self.idLogOut:SetEnabled(dlg.logined)
                            end
                        }, {
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "log out",
                                "__template",
                                "PDAMilitiaHyperlinkHeader",
                                "Id",
                                "idLogOut",
                                "LinkId",
                                "logout",
                                "dlg_mode",
                                "logout",
                                "Text",
                                "Log out"
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnClick(self, dlg)",
                                    "func",
                                    function(self, dlg)
                                        local pda = GetDialog("PDADialog")

                                        if pda then
                                            pda:CloseAction()
                                        end

                                        return "break"
                                    end
                                })
                            })
                        })
                    }),
                    PlaceObj("XTemplateWindow", {
                        "comment",
                        "logo",
                        "__class",
                        "XImage",
                        "MinWidth",
                        180,
                        "MinHeight",
                        180,
                        "MaxWidth",
                        180,
                        "MaxHeight",
                        180,
                        "ImageFit",
                        "height",
                        "HAlign",
                        "left",
                        "VAlign",
                        "center",
                        "Image",
                        "Mod/LXPER6t/Icons/grandchienwappenbig.png"
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "footer",
                    "__context",
                    function(parent, context)
                        return "militia footer"
                    end,
                    "Id",
                    "idFooter",
                    "Margins",
                    box(0, 10, 0, 15),
                    "Dock",
                    "bottom",
                    "VAlign",
                    "bottom"
                }, {
                    PlaceObj("XTemplateWindow", {
                        "LayoutMethod",
                        "VList",
                        "LayoutVSpacing",
                        20
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "links",
                            "HAlign",
                            "center",
                            "VAlign",
                            "top",
                            "LayoutMethod",
                            "HList",
                            "LayoutHSpacing",
                            8
                        }, {
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "rss feed",
                                "__template",
                                "PDAImpHyperlink",
                                "HAlign",
                                "center",
                                "MinHeight",
                                20,
                                "LinkId",
                                "browse",
                                "Text",
                                T(212384058717, "RSS Feed"),
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center",
                                "ErrParam",
                                "Error404"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                20,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                20,
                                "Background",
                                RGBA(76, 62, 255, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "service",
                                "__template",
                                "PDAImpHyperlink",
                                "HAlign",
                                "center",
                                "MinHeight",
                                20,
                                "LinkId",
                                "service",
                                "Text",
                                T(821269390672, "Services"),
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center",
                                "ErrParam",
                                "Error408"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                20,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                20,
                                "Background",
                                RGBA(76, 62, 255, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "search",
                                "__template",
                                "PDAImpHyperlink",
                                "HAlign",
                                "center",
                                "MinHeight",
                                20,
                                "OnContextUpdate",
                                function(self, context, ...)
                                    XContextWindow.OnContextUpdate(self, context)
                                    local dlg = GetDialog(self)
                                    local pdaBrowser = GetPDABrowserDialog()
                                    if HyperlinkVisited(pdaBrowser, self:GetProperty("LinkId")) then
                                        self.idLink:SetTextStyle("PDAIMPHyperLinkClicked")
                                        self.idLink:OnSetRollover(true)
                                    end
                                end,
                                "LinkId",
                                "search",
                                "Text",
                                T(111393156310, "Search"),
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center",
                                "ErrParam",
                                "Error500"
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                20,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                20,
                                "Background",
                                RGBA(76, 62, 255, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "help",
                                "__template",
                                "PDAImpHyperlink",
                                "HAlign",
                                "center",
                                "MinHeight",
                                20,
                                "LinkId",
                                "help",
                                "Text",
                                T(296296892071, "Help"),
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center",
                                "ErrParam",
                                "UnderConstruction"
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnClick(self, dlg)",
                                    "func",
                                    function(self, dlg)
                                        dlg:SetMode("home")
                                    end
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "comment",
                                "line",
                                "HAlign",
                                "center",
                                "VAlign",
                                "center",
                                "MinWidth",
                                2,
                                "MinHeight",
                                20,
                                "MaxWidth",
                                2,
                                "MaxHeight",
                                20,
                                "Background",
                                RGBA(76, 62, 255, 255)
                            }),
                            PlaceObj("XTemplateTemplate", {
                                "comment",
                                "contacts",
                                "__template",
                                "PDAImpHyperlink",
                                "HAlign",
                                "center",
                                "MinHeight",
                                20,
                                "LinkId",
                                "contacts",
                                "Text",
                                T(687237737248, "Contacts"),
                                "TextHAlign",
                                "center",
                                "TextVAlign",
                                "center"
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnClick(self, dlg)",
                                    "func",
                                    function(self, dlg)
                                        dlg:SetMode("home")
                                    end
                                })
                            })
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContentTemplate",
                    "IdNode",
                    false,
                    "HAlign",
                    "center",
                    "MinWidth",
                    1076,
                    "MaxWidth",
                    1076
                }, {
                    PlaceObj("XTemplateWindow", {
                        "Margins",
                        box(0, 16, 0, 8)
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "left",
                            "__context",
                            function(parent, context)
                                return "left panel"
                            end,
                            "__class",
                            "XContentTemplate",
                            "Id",
                            "idLeft",
                            "IdNode",
                            false,
                            "Dock",
                            "left",
                            "HAlign",
                            "left",
                            "VAlign",
                            "top",
                            "MinWidth",
                            180,
                            "MinHeight",
                            560,
                            "MaxWidth",
                            180,
                            "Background",
                            RGBA(230, 222, 202, 255)
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XScrollArea",
                                "Id",
                                "idScrollLeft",
                                "IdNode",
                                false,
                                "Margins",
                                box(0, 0, 0, 0),
                                "VAlign",
                                "top",
                                "LayoutMethod",
                                "VList",
                                "VScroll",
                                "idScrollbar"
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "Margins",
                                    box(10, 10, 10, 10),
                                    "LayoutMethod",
                                    "VList",
                                    "LayoutVSpacing",
                                    10
                                }, {
                                    PlaceObj("XTemplateMode", {
                                        "mode",
                                        "shop, orders, shop_list"
                                    }, {
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaShopNav"
                                        })
                                    }),
                                    PlaceObj("XTemplateMode", {
                                        "mode",
                                        "home, squads, squad"
                                    }, {
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaSidebarRIP"
                                        })
                                    })
                                }),
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XZuluScroll",
                                "Id",
                                "idScrollbar",
                                "Margins",
                                box(0, 0, 0, 0),
                                "Dock",
                                "right",
                                "UseClipBox",
                                false,
                                "Target",
                                "idScrollLeft",
                                "AutoHide",
                                true
                            }),
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "right",
                            "__context",
                            function(parent, context)
                                return "right panel"
                            end,
                            "__class",
                            "XContentTemplate",
                            "Id",
                            "idRight",
                            "IdNode",
                            true,
                            "Dock",
                            "right",
                            "HAlign",
                            "right",
                            "VAlign",
                            "top",
                            "MinWidth",
                            180,
                            "MinHeight",
                            560,
                            "MaxWidth",
                            180,
                            "LayoutMethod",
                            "VList",
                            "Background",
                            RGBA(230, 222, 202, 255),

                        }, {
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "RespawnContent(self)",
                                "func",
                                function(self)
                                    print("RespawnContent")

                                    local scroll = self.idScrollbar

                                    local list = self.idScrollArea

                                    local lastScrollPos = scroll and scroll:GetScroll()

                                    XContentTemplate.RespawnContent(self)
                                    RunWhenXWindowIsReady(self, function()
                                        if self.idScroll and lastScrollPos then
                                            self.idScroll:SetScroll(lastScrollPos)
                                        end
                                        if self.idScrollArea and lastScrollPos then
                                            self.idScrollArea:ScrollTo(0, lastScrollPos)
                                        end
                                    end)
                                end
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XScrollArea",
                                "Id",
                                "idScrollArea",
                                "IdNode",
                                false,
                                "Margins",
                                box(0, 0, 0, 0),
                                "VAlign",
                                "top",
                                "LayoutMethod",
                                "VList",
                                "VScroll",
                                "idScrollbar"
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "Margins",
                                    box(10, 10, 10, 10),
                                    "LayoutMethod",
                                    "VList",
                                    "LayoutVSpacing",
                                    10
                                }, {
                                    PlaceObj("XTemplateMode", {
                                        "mode",
                                        "shop, orders, shop_list, conditions"
                                    }, {
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaShopCart"
                                        }),
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaShopAddress"
                                        }),
                                    }),
                                    PlaceObj("XTemplateMode", {
                                        "mode",
                                        "squads, squad"
                                    }, {
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaSidebarBattle"
                                        })
                                    }),
                                    PlaceObj("XTemplateMode", {
                                        "mode",
                                        "home"
                                    }, {
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaSidebarPromotions"
                                        }),
                                        PlaceObj("XTemplateTemplate", {
                                            "__template",
                                            "PDAMilitiaSidebarNewbies"
                                        })
                                    })
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XZuluScroll",
                                "Id",
                                "idScrollbar",
                                "Margins",
                                box(0, 0, 0, 0),
                                "Dock",
                                "right",
                                "UseClipBox",
                                false,
                                "Target",
                                "idScrollArea",
                                "AutoHide",
                                true
                            }),
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "center",
                            "__class",
                            "XContentTemplate",
                            "Id",
                            "idContent",
                            "Margins",
                            box(8, 0, 8, 0),
                            "HAlign",
                            "center",
                            "VAlign",
                            "top",
                            "MinWidth",
                            700,
                            "MinHeight",
                            560,
                            "MaxWidth",
                            700,
                            "LayoutMethod",
                            "VList",
                        }, {
                            PlaceObj("XTemplateMode", { "mode", "finances" }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaConstruction",
                                    "HeaderButtonId",
                                    "idFinances"
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "trick"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShopTrick"
                                }),
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "squads"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaSquads",
                                    "HeaderButtonId",
                                    "idSquads"
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "squad"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaSquad",
                                    "HeaderButtonId",
                                    "idSquads"
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "soldier"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaSoldier",
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "shop"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShop",
                                    "HeaderButtonId",
                                    "idShop"
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "shop_list"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShopList",
                                    "HeaderButtonId",
                                    "idShop"
                                })
                            }),
                            PlaceObj("XTemplateMode", {
                                "mode",
                                "orders"
                            }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaShopOrders",
                                    "HeaderButtonId",
                                    "idShopOrders"
                                })
                            }),
                            PlaceObj("XTemplateMode", { "mode", "home" }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaHome",
                                    "HeaderButtonId",
                                    "idHome"
                                })
                            })
                        })
                    })
                })
            })
        }),
        PlaceObj("XTemplateTemplate", {
            "__condition",
            function(parent, context)
                return not InitialConflictNotStarted()
            end,
            "__template",
            "PDAStartButton",
            "Dock",
            "box",
            "VAlign",
            "bottom",
            "MinWidth",
            200
        }, {
            PlaceObj("XTemplateFunc", {
                "name",
                "SetOutsideScale(self, scale)",
                "func",
                function(self, scale)
                    local dlg = GetDialog("PDADialog")
                    local screen = dlg.idPDAScreen
                    XWindow.SetOutsideScale(self, screen.scale)
                end
            })
        })
    })
})
