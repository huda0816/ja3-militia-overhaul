PlaceObj("XTemplate", {
    group = "Zulu PDA",
    id = "PDAMilitiaShopProduct",
    PlaceObj("XTemplateWindow", {
        "IdNode",
        true,
        "id",
        "idProduct",
        "OnLayoutComplete",
        function(self)
            self.idProductImage:SetImage(self.idProductName.context.image)
        end,
        "Margins",
        box(0, 10, 0, 10),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20,
        "Background",
        RGBA(255, 255, 255, 255)
    }, {
        PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 0, 0, 0),
            "Background",
            RGBA(230, 222, 202, 255)
        }, {
            PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "MinWidth",
                140,
                "MinHeight",
                140,
                "MaxWidth",
                140,
                "MaxHeight",
                140,
                "Image",
                "UI/Hud/portrait_background",
                "ImageColor",
                RGBA(255, 255, 255, 120),
                "ImageFit",
                "stretch"
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idProductImage",
                "MinWidth",
                130,
                "MinHeight",
                130,
                "MaxWidth",
                130,
                "MaxHeight",
                130,
                "Image",
                "UI/MercsPortraits/Igor",
                "VAlign",
                "center",
                "HAlign",
                "center",
                "ImageFit",
                "width",
            })
        }),
        PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 5, 0, 5),
            "HAlign",
            "left",
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            0
        }, {
            PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 0, 0),
                "VAlign",
                "center",
                "Dock",
                "top",
                "LayoutMethod",
                "HList",
                "LayoutVSpacing",
                0
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idProductName",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAIMPMercName",
                    "TextHAlign",
                    "left",
                    "OnLayoutComplete",
                    function(self)
                        self:SetText(self.context.name)
                    end
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idProductCount",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAIMPMercName",
                    "TextHAlign",
                    "left",
                    "OnLayoutComplete",
                    function(self)
                        self:SetTextStyle(self.context.stock > 0 and "PDAIMPMercName" or "HUDAProductOutOfStock")
                        self:SetText("(" .. (self.context.stock > 0 and self.context.stock or "out of stock") .. ")")
                    end
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idProductPrice",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAIMPMercName",
                    "Translate",
                    true,
                    "TextHAlign",
                    "right",
                    "TextVAlign",
                    "center",
                    "OnLayoutComplete",
                    function(self)
                        self:SetText(self.context.basePrice .. "$")
                    end,
                })
            }),
            PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idProductDescription",
                "HandleMouse",
                false,
                "MaxWidth",
                480,
                "MaxHeight",
                80,
                "TextStyle",
                "PDAIMPGalleryName",
                "Translate",
                true,
                "TextHAlign",
                "left",
                "OnLayoutComplete",
                function(self)
                    self:SetText(self.context.description)
                end,
            }),
            PlaceObj("XTemplateWindow", {
                "Margins",
                box(0, 0, 0, 0),
                "HAlign",
                "left",
                "LayoutMethod",
                "HList",
                "Dock",
                "bottom",
                "LayoutHSpacing",
                5
            }, {
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idAddToCart",
                    "TextHAlign",
                    "Right",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "OnLayoutComplete",
                    function(self)
                        if (self.context.stock == 0) then
                            self:SetTransparency(150)
                            self:SetMouseCursor("UI/Cursors/Pda_Cursor.tga")
                            return
                        end
                    end,
                    "Text",
                    "<underline>Add to cart</underline>"
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:AddToCart(self.context, 1)
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                        end
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "__condition",
                    function(parent, context)
                        return context.stock > 1
                    end,
                    "Id",
                    "idAdd5ToCart",
                    "TextHAlign",
                    "Right",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "OnLayoutComplete",
                    function(self)
                        if (self.context.stock < 5) then
                            self:SetText("<underline>Add " .. self.context.stock .. "x to cart</underline>")
                        end
                    end,
                    "Text",
                    "<underline>Add 5x to cart</underline>"
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)
                            HUDA_ShopController:AddToCart(self.context, Min(5, self.context.stock))
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                        end
                    })
                }),
                PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "__condition",
                    function(parent, context)
                        return context.category ~= "ammo" and context.caliber ~= nil and HUDA_ShopController:HasAmmo(context.caliber)
                    end,
                    "Id",
                    "idBuyAmmo",
                    "TextHAlign",
                    "Right",
                    "MouseCursor",
                    "UI/Cursors/Pda_Hand.tga",
                    "TextStyle",
                    "PDABrowserThievesBoxLinks",
                    "Translate",
                    true,
                    "Text",
                    "<underline>Buy ammo</underline>"
                }, {
                    PlaceObj("XTemplateFunc", {
                        "name",
                        "OnMouseButtonDown(self, pos, button)",
                        "func",
                        function(self, pos, button)

                            print("buy ammo click")

                            local dlg = GetDialog(self.parent)

                            dlg:SetMode("trick",
                                { query = { category = "ammo", caliber = self.context.caliber },
                                    item = { name = self.context.caliberName .. " ammunition", description = "Get " .. self.context.caliberName .. " ammunition" } })
                            ObjModified(dlg)
                            ObjModified("right panel")
                            ObjModified("left panel")
                            ObjModified("militia header")
                            ObjModified("pda_url")
                        end
                    })
                })
            })
        })
    })
})
