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
        "InitialMode",
        "start_page",
        "InternalModes",
        "start_page,home,finances,squads,squad,soldier,login,logout,construction,shop,edit_squad"
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
                print("OnDialogModeChange", mode)
                if mode == "start_page" then
                    self:SetMode("home")
                    return
                end
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
                elseif mode == "construction" then
                    return Untranslated("http://www.gc-militia.org/bla")
                end
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
                if mode == "squad" then
                    -- local list = self.idContent.idAnswers.idList
                    -- if shortcut == "DPadUp" or shortcut == "Up" then
                    --     list:SelPrev()
                    -- end
                    -- if shortcut == "DPadDown" or shortcut == "Down" then
                    --     list:SelNext()
                    -- end
                end
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
                            "__class",
                            "XText",
                            "Id",
                            "idPageTitle",
                            "Margins",
                            box(170, 0, 0, 0),
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
                            "TextStyle",
                            "PDAIMPPageTitle",
                            "Translate",
                            true,
                            "Text",
                            T(589427374438, "Grand Chien Militia Headquarters"),
                            "TextHAlign",
                            "center",
                            "TextVAlign",
                            "center"
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
                            "Margins",
                            box(0, 24, 0, 0),
                            "HAlign",
                            "right",
                            "VAlign",
                            "top",
                            "LayoutMethod",
                            "VList"
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
                            box(170, 0, 0, 0),
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
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                                -- local dlg = GetDialog(self)
                                -- local test_completed = g_ImpTest and g_ImpTest.confirmed
                                -- self:ResolveId("idLogIn"):SetEnabled(not dlg.logined and
                                -- (not test_completed or not g_ImpTest.final.created))
                                -- self:ResolveId("idIntroduction"):SetEnabled(dlg.logined and not test_completed)
                                -- self:ResolveId("idTest"):SetEnabled(dlg.logined and not test_completed)
                                -- self:ResolveId("idProfile"):SetEnabled(dlg.logined and test_completed)
                                -- self:ResolveId("idHome"):SetEnabled(true)
                            end
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
                                T(805144021337, "Home")
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
                                T(126748905760, "FINANCES")
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
                                T(126748905760, "SQUADS")
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
                                T(761514198458, "Log out")
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnClick(self, dlg)",
                                    "func",
                                    function(self, dlg)
                                        -- g_ImpTest.loggedin = false
                                        -- dlg:SetMode(self.dlg_mode)
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
                        170,
                        "MinHeight",
                        180,
                        "MaxWidth",
                        170,
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
                        box(0, 56, 0, 8)
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
                                "Margins",
                                box(20, 20, 0, 0),
                                "LayoutMethod",
                                "VList"
                            }, {
                                PlaceObj("XTemplateMode", {
                                    "mode",
                                    "home"
                                }, {
                                    PlaceObj("XTemplateForEach", {
                                        "array",
                                        function(parent, context)
                                            return ImpLeftPageLinks()
                                        end,
                                        "run_after",
                                        function(child, context, item, i, n, last)
                                            child.idLink:SetLinkId(item.link_id)
                                            child.idLink:SetText(item.text)
                                            local dlg = GetDialog(child)
                                            child.idLink.idLink:SetTextStyle(dlg.clicked_links and
                                                dlg.clicked_links[item.link_id] and "PDAIMPHyperLinkClicked" or
                                                "PDAIMPHyperLink")
                                            if item.error then
                                                child.idLink:SetErrParam(item.error)
                                            end
                                            if item.link_id == "mercs" then
                                                function child.idLink.OnClick(this, dlg)
                                                    dlg:SetMode("squads")
                                                end
                                            end
                                            if item.link_id == "gallery" then
                                                function child.idLink.OnClick(this, dlg)
                                                    dlg:SetMode("squads")
                                                end
                                            end
                                        end
                                    }, {
                                        PlaceObj("XTemplateWindow", {
                                            "IdNode",
                                            true,
                                            "LayoutMethod",
                                            "HList"
                                        }, {
                                            PlaceObj("XTemplateWindow", {
                                                "__class",
                                                "XImage",
                                                "Image",
                                                "UI/PDA/hm_circle",
                                                "ImageScale",
                                                point(600, 600),
                                                "ImageColor",
                                                RGBA(0, 0, 0, 255)
                                            }),
                                            PlaceObj("XTemplateTemplate", {
                                                "__template",
                                                "PDAImpHyperlink",
                                                "Id",
                                                "idLink",
                                                "Margins",
                                                box(5, 0, 0, 0)
                                            })
                                        })
                                    })
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Margins",
                                box(10, 0, 10, 20),
                                "Dock",
                                "box",
                                "HAlign",
                                "left",
                                "VAlign",
                                "bottom",
                                "TextStyle",
                                "PDAIMPCopyrightText",
                                "Translate",
                                true,
                                "Text",
                                "powered by IMP"
                            })
                        }),
                        PlaceObj("XTemplateWindow", {
                            "comment",
                            "right",
                            "__context",
                            function(parent, context)
                                return "right panel"
                            end,
                            "__class",
                            "XContextWindow",
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
                            "ContextUpdateOnOpen",
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                                XContextWindow.OnContextUpdate(self, context, ...)
                                local hyperlink = Untranslated("<h OpenMonthMerc month_merc IMP underline>")
                                self.idText:SetText(T({
                                    225920505057,
                                    "<hl><underline>A.I.M. merc of the month<underline></h>",
                                    hl = hyperlink
                                }))
                                self.idDots:SetText(T({
                                    312104275561,
                                    "<hl><underline>...<underline></h>",
                                    hl = hyperlink
                                }))
                                local dlg = GetDialog(self)
                                self.idText:SetTextStyle(dlg.clicked_links.month_merc and "PDAIMPHyperLinkClicked" or
                                    "PDAIMPHyperLink")
                                local data = ImpMercOfTheMonth()
                                if data then
                                    self.idPortrait:SetImage(data.Portrait)
                                    self.idName:SetText(data.Name)
                                    self.idBio:SetText(data.Bio)
                                end
                            end
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idText",
                                "Margins",
                                box(16, 20, 16, 0),
                                "Dock",
                                "top",
                                "HAlign",
                                "left",
                                "VAlign",
                                "top",
                                "MinWidth",
                                140,
                                "MaxWidth",
                                140,
                                "MouseCursor",
                                "UI/Cursors/Pda_Hand.tga",
                                "FXMouseIn",
                                "buttonRollover",
                                "FXPress",
                                "buttonPress",
                                "FXPressDisabled",
                                "IactDisabled",
                                "TextStyle",
                                "PDAIMPHyperLink",
                                "Translate",
                                true
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                                    "func",
                                    function(self, hyperlink, argument, hyperlink_box, pos, button)
                                        if hyperlink == "OpenMonthMerc" then
                                            PlayFX("buttonPress", "start")
                                            self:SetTextStyle("PDAIMPHyperLinkClicked")
                                            local dlg = GetDialog(self)
                                            dlg.clicked_links[argument] = true
                                            OpenAIMAndSelectMerc(g_ImpTest.month_merc)
                                        end
                                    end
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "Margins",
                                box(16, 0, 16, 0),
                                "Dock",
                                "top",
                                "HAlign",
                                "left"
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XImage",
                                    "Id",
                                    "idPortraitBG",
                                    "IdNode",
                                    false,
                                    "MinWidth",
                                    120,
                                    "MinHeight",
                                    136,
                                    "MaxWidth",
                                    120,
                                    "MaxHeight",
                                    136,
                                    "Image",
                                    "UI/Hud/portrait_background",
                                    "ImageFit",
                                    "stretch"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XImage",
                                    "Id",
                                    "idPortrait",
                                    "MinWidth",
                                    120,
                                    "MinHeight",
                                    136,
                                    "MaxWidth",
                                    120,
                                    "MaxHeight",
                                    136,
                                    "Image",
                                    "UI/MercsPortraits/Igor",
                                    "ImageFit",
                                    "stretch",
                                    "ImageRect",
                                    box(36, 0, 264, 251)
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idName",
                                "Margins",
                                box(16, 10, 16, 0),
                                "Dock",
                                "top",
                                "MinWidth",
                                140,
                                "MaxWidth",
                                140,
                                "TextStyle",
                                "PDAIMPMercName",
                                "Translate",
                                true
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idDots",
                                "Margins",
                                box(16, -10, 16, 16),
                                "Padding",
                                box(4, 2, 2, 2),
                                "Dock",
                                "bottom",
                                "HAlign",
                                "left",
                                "VAlign",
                                "top",
                                "MinWidth",
                                140,
                                "MaxWidth",
                                140,
                                "MouseCursor",
                                "UI/Cursors/Pda_Hand.tga",
                                "FXMouseIn",
                                "buttonRollover",
                                "FXPress",
                                "buttonPress",
                                "FXPressDisabled",
                                "IactDisabled",
                                "TextStyle",
                                "PDAIMPHyperLink",
                                "Translate",
                                true,
                                "Text",
                                T(804387271590, "...")
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)",
                                    "func",
                                    function(self, hyperlink, argument, hyperlink_box, pos, button)
                                        if hyperlink == "OpenMonthMerc" then
                                            PlayFX("buttonPress", "start")
                                            self:SetTextStyle("PDAIMPHyperLinkClicked")
                                            local dlg = GetDialog(self)
                                            dlg.clicked_links[argument] = true
                                            OpenAIMAndSelectMerc(g_ImpTest.month_merc)
                                        end
                                    end
                                })
                            }),
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Id",
                                "idBio",
                                "Margins",
                                box(16, 5, 16, 0),
                                "Dock",
                                "top",
                                "VAlign",
                                "top",
                                "MinWidth",
                                140,
                                "MinHeight",
                                276,
                                "MaxWidth",
                                140,
                                "MaxHeight",
                                276,
                                "OnLayoutComplete",
                                function(self)
                                    local old_height = self.content_box:maxy() - self.content_box:miny()
                                    local line_height = self.font_height + self.font_linespace
                                    local new_height = floatfloor(old_height / line_height) * line_height
                                    if (0.0 + old_height) / line_height % 1 <= 0.9 then
                                        local cb = self.content_box
                                        self.content_box = box(cb:minx(), cb:miny(), cb:maxx(), cb:miny() + new_height)
                                    end
                                end,
                                "TextStyle",
                                "PDAIMPMercBio",
                                "Translate",
                                true
                            })
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
                            "OnContextUpdate",
                            function(self, context, ...)
                                XContentTemplate.OnContextUpdate(self, context, ...)
                                local dlg = GetDialog(self)
                                if dlg:GetMode() == "test" then
                                    dlg.mode_param = Untranslated("Question" .. context.question)
                                    ObjModified("pda_url")
                                end
                            end
                        }, {
                            PlaceObj("XTemplateMode", { "mode", "finances" }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaFinances",
                                    "HeaderButtonId",
                                    "idFinances"
                                })
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
                                    "idProfile"
                                })
                            }),
                            PlaceObj("XTemplateMode", { "mode", "home" }, {
                                PlaceObj("XTemplateTemplate", {
                                    "__template",
                                    "PDAMilitiaStartPage",
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
