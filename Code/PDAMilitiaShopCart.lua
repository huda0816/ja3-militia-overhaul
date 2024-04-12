function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaShopCart",
        PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
                return "shop cart"
            end,
            "__class",
            "XContentTemplate",
            "LayoutMethod",
            "VList",
            "Padding",
            box(5, 5, 5, 5),
            "Background",
            RGBA(255, 255, 255, 255)
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "TextStyle",
                "PDAIMPMercName",
                "Translate",
                true,
                "Text",
                Untranslated("Shopping Cart")
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
                "__condition",
                function(parent, context)
                    return not next(gv_HUDA_ShopCart.products)
                end,
                "Margins",
                box(0, 0, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "TextStyle",
                "PDAIMPGalleryName",
                "Translate",
                true,
                "Text",
                Untranslated("Your cart is empty")
            }),
            PlaceObj("XTemplateGroup", {
                "__condition",
                function(parent, context)
                    return next(gv_HUDA_ShopCart.products)
                end,
            }, {
                PlaceObj("XTemplateWindow", {
                    "IdNode",
                    false,
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    5
                }, {
                    PlaceObj("XTemplateForEach", {
                        "array",
                        function(parent, context)
                            return gv_HUDA_ShopCart.products or {}
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            child.idCartProduct:SetText(Untranslated(item.count) .. Untranslated(" x ") .. item.name or Untranslated(item.id))
                            child:SetContext(item)
                        end
                    }, {
                        PlaceObj("XTemplateWindow", {
                            "__class",
                            "XContextWindow",
                            "LayoutMethod",
                            "VList",
                            "IdNode",
                            true,
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XText",
                                "Margins",
                                box(0, 0, 0, 0),
                                "Id",
                                "idCartProduct",
                                "TextStyle",
                                "PDAIMPMercBio",
                                "Translate",
                                true,
                                "Text",
                                Untranslated("Placeholder")
                            }),
                            PlaceObj("XTemplateWindow", {
                                "LayoutMethod",
                                "HList",
                                "LayoutHSpacing",
                                5,
                                "BorderWidth",
                                2,
                                "Padding",
                                box(5, 0, 5, 0),
                                "Margins",
                                box(2, 2, 2, 2),
                                "IdNode",
                                true,
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "comment",
                                    "plus",
                                    "__class",
                                    "XImage",
                                    "MinWidth",
                                    16,
                                    "MinHeight",
                                    16,
                                    "MaxWidth",
                                    16,
                                    "MaxHeight",
                                    16,
                                    "ImageFit",
                                    "height",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "HandleMouse",
                                    true,
                                    "HAlign",
                                    "left",
                                    "VAlign",
                                    "center",
                                    "Image",
                                    "UI/PDA/Quest/T_Icon_Plus"
                                }, {
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "OnMouseButtonDown(self, pos, button)",
                                        "func",
                                        function(self, pos, button)
                                            HUDA_ShopController:AddToCart(self.parent.parent.context, 1)
                                            ObjModified("right panel")
                                            ObjModified("left panel")
                                            ObjModified("militia header")
                                        end
                                    })
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "comment",
                                    "minus",
                                    "__class",
                                    "XImage",
                                    "MinWidth",
                                    16,
                                    "MinHeight",
                                    16,
                                    "MaxWidth",
                                    16,
                                    "MaxHeight",
                                    16,
                                    "ImageFit",
                                    "height",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "HandleMouse",
                                    true,
                                    "HAlign",
                                    "left",
                                    "VAlign",
                                    "center",
                                    "Image",
                                    "UI/PDA/Quest/T_Icon_Minus"
                                }, {
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "OnMouseButtonDown(self, pos, button)",
                                        "func",
                                        function(self, pos, button)
                                            HUDA_ShopController:RemoveFromCart(
                                                self.parent.parent.context, 1)
                                            ObjModified("right panel")
                                            ObjModified("left panel")
                                            ObjModified("militia header")
                                        end
                                    })
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "comment",
                                    "remove",
                                    "__class",
                                    "XText",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "HandleMouse",
                                    true,
                                    "HAlign",
                                    "left",
                                    "VAlign",
                                    "center",
                                    "Text",
                                    Untranslated("remove"),
                                    "TextStyle",
                                    "PDABrowserThievesBoxLinks"
                                }, {
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "OnMouseButtonDown(self, pos, button)",
                                        "func",
                                        function(self, pos, button)
                                            HUDA_ShopController:RemoveFromCart(
                                                self.parent.parent.context)
                                            ObjModified("right panel")
                                            ObjModified("left panel")
                                            ObjModified("militia header")
                                        end
                                    })
                                })
                            })
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "line",
                    "__class",
                    "XImage",
                    "Margins",
                    box(0, 10, 0, 5),
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
                    "LayoutMethod",
                    "VList",
                    "Margins",
                    box(0, 0, 0, 0),
                    "IdNode",
                    true,
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Margins",
                        box(0, 0, 0, 0),
                        "Id",
                        "idCartProduct",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "Translate",
                        true,
                        "Text",
                        Untranslated("Delivery Type")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextWindow",
                        "__context",
                        function(parent, context)
                            return HUDA_ShopController:GetDeliveryTypes()
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "FXMouseIn",
                        "buttonRollover",
                        "FXPress",
                        "buttonPress",
                        "FXPressDisabled",
                        "IactDisabled",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "Translate",
                        true,
                        "LayoutMethod",
                        "VList",
                        "ContextUpdateOnOpen",
                        true,
                    }, {
                        PlaceObj("XTemplateForEach", {
                            "array",
                            function(parent, context)
                                local deliveryTypes = HUDA_ShopController:GetDeliveryTypes()

                                table.sort(deliveryTypes, function(a, b)
                                    return a.duration > b.duration
                                end)

                                return deliveryTypes
                            end,
                            "run_after",
                            function(child, context, item, i, n, last)
                                child.idDeliveryType:SetText(Untranslated(item.title ..
                                    "(" .. item.duration .. "d)"))

                                child:SetContext(item)

                                if gv_HUDA_ShopCart.deliveryType then
                                    if gv_HUDA_ShopCart.deliveryType.id == item.id then
                                        -- child:Toggle(true)
                                        child.idbtnChecked:SetToggled(true)
                                        child.idbtnChecked:SetIconRow(true and 2 or 1)
                                    end
                                elseif item.default then
                                    -- child:Toggle(true)
                                    HUDA_ShopController:SetDeliveryType(item)
                                    child.idbtnChecked:SetToggled(true)
                                    child.idbtnChecked:SetIconRow(true and 2 or 1)
                                end
                            end
                        }, {
                            PlaceObj("XTemplateWindow", {
                                "__class",
                                "XContextFrame",
                                "LayoutMethod",
                                "HList",
                                "LayoutHSpacing",
                                5,
                                "HandleMouse",
                                true,
                                "MouseCursor",
                                "UI/Cursors/Pda_Hand.tga",
                                "IdNode",
                                true,
                                "FXMouseIn",
                                "buttonRollover",
                                "FXPress",
                                "buttonPress",
                                "FXPressDisabled",
                                "IactDisabled",
                                "Background",
                                RGBA(0, 0, 0, 0),
                                "FrameBox",
                                box(0, 0, 0, 0)
                            }, {
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "Toggle(self, toggled)",
                                    "func",
                                    function(self, toggled)
                                        local answers = self.parent
                                        self.idbtnChecked:SetToggled(toggled)
                                        self.idbtnChecked:SetIconRow(toggled and 2 or 1)
                                        local deliveryTypes = HUDA_ShopController:GetDeliveryTypes()
                                        local item_idx = table.find(deliveryTypes, "id",
                                            self.context.id)
                                        if toggled then
                                            HUDA_ShopController:SetDeliveryType(self.context)
                                            -- for i = 1, #answers do
                                            --     if i ~= item_idx then
                                            --         answers[i]:Toggle(false)
                                            --     end
                                            -- end
                                        end
                                        ObjModified("right panel")
                                    end
                                }),
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnMouseButtonDown(self, pos, button)",
                                    "func",
                                    function(self, pos, button)
                                        if button == "L" then
                                            self.idbtnChecked:OnPress()
                                            PlayFX("buttonPress", "start")
                                            return "break"
                                        end
                                    end
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XToggleButton",
                                    "Id",
                                    "idbtnChecked",
                                    "Margins",
                                    box(0, 0, 0, 0),
                                    "HAlign",
                                    "center",
                                    "VAlign",
                                    "center",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "FXMouseIn",
                                    "buttonRollover",
                                    "FXPress",
                                    "buttonPress",
                                    "FXPressDisabled",
                                    "IactDisabled",
                                    "Background",
                                    RGBA(0, 0, 0, 0),
                                    "OnPress",
                                    function(self, gamepad)
                                        XTextButton.OnPress(self)
                                        self.parent:Toggle(not self.Toggled)
                                    end,
                                    "RolloverBackground",
                                    RGBA(255, 255, 255, 0),
                                    "PressedBackground",
                                    RGBA(255, 255, 255, 0),
                                    "Icon",
                                    "UI/PDA/imp_radio_button",
                                    "IconRows",
                                    2
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "Id",
                                    "idBack",
                                    "Margins",
                                    box(35, 4, 4, 4),
                                    "Dock",
                                    "box"
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idDeliveryType",
                                    "Margins",
                                    box(0, 0, 8, 0),
                                    "VAlign",
                                    "center",
                                    "MouseCursor",
                                    "UI/Cursors/Pda_Hand.tga",
                                    "FXMouseIn",
                                    "buttonRollover",
                                    "FXPress",
                                    "buttonPress",
                                    "FXPressDisabled",
                                    "IactDisabled",
                                    "TextStyle",
                                    "PDAIMPMercBio",
                                    "Translate",
                                    true
                                }, {
                                    PlaceObj("XTemplateFunc", {
                                        "name",
                                        "OnMouseButtonDown(self, pos, button)",
                                        "func",
                                        function(self, pos, button)
                                            XText.OnMouseButtonDown(self, pos, button)
                                            if button == "L" then
                                                self.parent.idbtnChecked:OnPress()
                                                PlayFX("buttonPress", "start")
                                                return "break"
                                            end
                                        end
                                    })
                                })
                            })
                        })
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "comment",
                    "line",
                    "__class",
                    "XImage",
                    "Margins",
                    box(0, 10, 0, 5),
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
                    "XFrame",
                    "Margins",
                    box(0, 5, 0, 5),
                    "Id",
                    "idCouponFrame",
                    "VAlign",
                    "center",
                    "MinHeight",
                    30,
                    "Image",
                    "UI/PDA/imp_bar",
                    "FrameBox",
                    box(5, 5, 5, 5)
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XEdit",
                        "Margins",
                        box(5, 0, 5, 0),
                        "BorderWidth",
                        0,
                        "HAlign",
                        "stretch",
                        "VAlign",
                        "center",
                        "Background",
                        RGBA(240, 240, 240, 0),
                        "MouseCursor",
                        "UI/Cursors/Pda_Hand.tga",
                        "FocusOrder",
                        point(0, 0),
                        "FocusedBorderColor",
                        RGBA(240, 240, 240, 0),
                        "FocusedBackground",
                        RGBA(240, 240, 240, 0),
                        "DisabledBorderColor",
                        RGBA(240, 240, 240, 0),
                        "DisabledBackground",
                        RGBA(240, 240, 240, 0),
                        "TextStyle",
                        "PDAMilitiaShopCouponCode",
                        "OnContextUpdate",
                        function(self, context, ...)
                            if gv_HUDA_ShopCart.coupon then
                                self:SetText(gv_HUDA_ShopCart.coupon.id)
                            end
                        end,
                        "OnTextChanged",
                        function(self)
                            local text = self:GetText()

                            if HUDA_ShopController:VerifyCoupon(text) then
                                self:SetTextStyle("PDAMilitiaShopCouponCodeValid")
                                self:SetFocus(false)
                                HUDA_ShopController:AddCouponToCart(text)
                            else
                                self:SetTextStyle("PDAMilitiaShopCouponCode")
                                HUDA_ShopController:RemoveCouponFromCart()
                            end

                            PlayFX("Typing", "start")
                        end,
                        "MaxLen",
                        16,
                        "Hint",
                        "Coupon Code"
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Margins",
                    box(0, -5, 0, 0),
                    "HAlign",
                    "left",
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "VAlign",
                    "top",
                    "TextStyle",
                    "PDABrowserThievesBoxLinksSuffix",
                    "Translate",
                    true,
                    "OnLayoutComplete",
                    function(self)
                        if gv_HUDA_ShopCart.coupon then
                            self:SetText(Untranslated("Discount: " .. gv_HUDA_ShopCart.coupon.discount .. "%"))
                            self:SetVisible(true)
                        end
                    end,
                    "Text",
                    Untranslated("Discout")
                }),
                PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "Grid",
                }, {
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "GridX",
                        1,
                        "GridY",
                        1,
                        "Translate",
                        true,
                        "Text",
                        Untranslated("Products:")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "__context",
                        function()
                            return "shop product cost"
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "right",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "GridX",
                        2,
                        "GridY",
                        1,
                        "Translate",
                        true,
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(Untranslated(HUDA_ShopController:GetProductPrice() .. "$"))
                        end,
                        "Text",
                        Untranslated("Products")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "GridX",
                        1,
                        "GridY",
                        2,
                        "Translate",
                        true,
                        "Text",
                        Untranslated("Delivery:")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "__context",
                        function()
                            return "shop delivery cost"
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "right",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "GridX",
                        2,
                        "GridY",
                        2,
                        "Translate",
                        true,
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(Untranslated(HUDA_ShopController:GetDeliveryCosts() .. "$"))
                        end,
                        "Text",
                        Untranslated("Delivery")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercName",
                        "GridX",
                        1,
                        "GridY",
                        3,
                        "Translate",
                        true,
                        "Text",
                        Untranslated("Total:")
                    }),
                    PlaceObj("XTemplateWindow", {
                        "__class",
                        "XText",
                        "__context",
                        function()
                            return "total price"
                        end,
                        "Margins",
                        box(0, 0, 0, 0),
                        "HAlign",
                        "right",
                        "VAlign",
                        "top",
                        "TextStyle",
                        "PDAIMPMercName",
                        "GridX",
                        2,
                        "GridY",
                        3,
                        "Translate",
                        true,
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(Untranslated(HUDA_ShopController:GetTotalPrice() .. "$"))
                        end
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "__condition",
                    function(parent, context)
                        return next(gv_HUDA_ShopCart.products)
                    end,
                    "TextHAlign",
                    "center",
                    "Margins",
                    box(0, 5, 0, 5),
                    "Padding",
                    box(2, 5, 2, 5),
                    "BorderWidth",
                    1,
                    "BorderColor",
                    RGBA(255, 255, 255, 255),
                    "Background",
                    RGBA(88, 92, 68, 255),
                    "RolloverBorderColor",
                    RGBA(65, 65, 65, 255),
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserColaCopyright",
                    "Text",
                    Untranslated("Order now")
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:Order()
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                            ObjModified("order list")
                        end
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "__condition",
                    function(parent, context)
                        return next(gv_HUDA_ShopCart.products)
                    end,
                    "TextHAlign",
                    "Right",
                    "Margins",
                    box(0, 0, 0, 0),
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "Text",
                    Untranslated("<underline>Clear cart</underline>")
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:ClearCart()
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                        end
                    })
                })
            })
        })
    })
end
