function OnMsg.DataLoaded()
    PlaceObj("XTemplate", {
        group = "Zulu PDA",
        id = "PDAMilitiaShopOrder",
        PlaceObj('XTemplateWindow', {
            "IdNode",
            true,
            "id",
            "idOrder",
            "Background",
            RGBA(255, 255, 255, 255),
            "LayoutMethod",
            "VList",
        }, {
            PlaceObj('XTemplateWindow', {
                "comment",
                "header",
                "LayoutMethod",
                "HList",
                "Margins",
                box(5, 5, 5, 5),
            }, {
                PlaceObj('XTemplateWindow', {
                    '__class',
                    "XText",
                    'Text',
                    "Datum",
                    "Id",
                    "idDate",
                    "Dock",
                    "left",
                    "TextStyle",
                    "PDAIMPMercBio",
                    "OnLayoutComplete",
                    function(self)
                        self:SetText(Untranslated("Order date: " .. HUDA_ShopController:DateFromTime(self.context.orderTime)))
                    end,
                }),
                PlaceObj('XTemplateWindow', {
                    '__class',
                    "XText",
                    'Text',
                    "Ordernummer",
                    "Id",
                    "idOrderNumber",
                    "Dock",
                    "right",
                    "TextStyle",
                    "PDAIMPMercBio",
                    "OnLayoutComplete",
                    function(self)
                        self:SetText(Untranslated("Nr. " .. self.context.id))
                    end,
                }),
            }),
            PlaceObj("XTemplateWindow", {
                "comment",
                "line",
                "__class",
                "XImage",
                "Margins",
                box(0, 0, 0, 0),
                "VAlign",
                "center",
                "Transparency",
                141,
                "Image",
                "UI/PDA/separate_line_vertical",
                "ImageFit",
                "stretch-x"
            }),
            PlaceObj('XTemplateWindow', {
                "comment",
                "content",
                "LayoutMethod",
                "HList",
                "Margins",
                box(5, 5, 5, 5),
            }, {
                PlaceObj('XTemplateWindow', {
                    "comment",
                    "produkte",
                    "Dock",
                    "left",
                    "LayoutMethod",
                    "VList",
                }, {
                    PlaceObj('XTemplateForEach', {
                        "__context",
                        function(parent, context, item, i, n)
                            return item
                        end,
                        "array",
                        function(parent, context)
                            return context.products
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                            child.idProductName:SetText(Untranslated(item.name .. " x " .. item.count))
                        end
                    }, {
                        PlaceObj('XTemplateWindow', {
                            "comment",
                            "produkt",
                            "IdNode",
                            true,
                            "LayoutMethod",
                            "HList"
                        }, {
                            PlaceObj('XTemplateWindow', {
                                '__class',
                                "XText",
                                'Text',
                                "Produktname x 5",
                                "Id",
                                "idProductName",
                                "TextStyle",
                                "PDAIMPMercBio",
                            }),
                        }),
                    }),
                }),
                PlaceObj('XTemplateWindow', {
                    "comment",
                    "rightbox",
                    "Dock",
                    "right",
                    "LayoutMethod",
                    "VList",
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__class',
                        "XText",
                        "Id",
                        "idLocation",
                        'Text',
                        "Location",
                        "HAlign",
                        "right",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(Untranslated("Location: " .. self.context.sector))
                        end,
                    }),
                    PlaceObj('XTemplateWindow', {
                        '__class',
                        "XText",
                        "Id",
                        "idStatus",
                        'Text',
                        "Status / Lieferdatum",
                        "HAlign",
                        "right",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "OnLayoutComplete",
                        function(self)
                            if self.context.status == "pending" then
                                self:SetText(Untranslated("ETA: " .. HUDA_ShopController:GetETA(self.context) .. "d"))
                            else
                                self:SetText(Untranslated("Deliverd: " .. HUDA_ShopController:GetETA(self.context) * -1 .. "d"))
                            end
                        end,
                    }),
                    PlaceObj('XTemplateWindow', {
                        '__class',
                        "XText",
                        "__condition",
                        function(parent, context)
                            return context.coupon
                        end,
                        'Text',
                        "Total",
                        "Id",
                        "idCoupon",
                        "HAlign",
                        "right",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "OnLayoutComplete",
                        function(self)
                            self:SetText((Untranslated(string.upper(self.context.coupon.id))))
                        end,
                    }),
                    PlaceObj('XTemplateWindow', {
                        '__class',
                        "XText",
                        'Text',
                        "Total",
                        "Id",
                        "idTotal",
                        "HAlign",
                        "right",
                        "TextStyle",
                        "PDAIMPMercBio",
                        "OnLayoutComplete",
                        function(self)
                            self:SetText(Untranslated((self.context.total or 0) .. "$"))
                        end,
                    }),
                    PlaceObj('XTemplateWindow', {
                        'LayoutMethod',
                        "HList",
                        "Dock",
                        "bottom",
                        "HAlign",
                        "right",
                        'LayoutHSpacing',
                        5
                    }, {
                        PlaceObj('XTemplateWindow', {
                            '__class',
                            "XText",
                            "MouseCursor",
                            "UI/Cursors/Pda_Hand.tga",
                            'Text',
                            "<underline>Buy again</underline>",
                            "TextStyle",
                            "PDABrowserThievesBoxLinks",
                        }, {
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnMouseButtonDown(self, pos, button)",
                                "func",
                                function(self, pos, button)
                                    HUDA_ShopController:OrderToCart(self.context)
                                    ObjModified("order list")
                                    ObjModified("right panel")
                                    ObjModified("left panel")
                                    ObjModified("militia header")
                                end
                            })
                        }),
                        PlaceObj('XTemplateWindow', {
                            '__class',
                            "XText",
                            "__condition",
                            function(parent, context)
                                return context.status == "pending"
                            end,
                            "MouseCursor",
                            "UI/Cursors/Pda_Hand.tga",
                            'Text',
                            "<underline>Refund</underline>",
                            "TextStyle",
                            "PDABrowserThievesBoxLinks",
                        }, {
                            PlaceObj("XTemplateFunc", {
                                "name",
                                "OnMouseButtonDown(self, pos, button)",
                                "func",
                                function(self, pos, button)
                                    HUDA_ShopController:Refund(self.context)
                                    ObjModified("order list")
                                    ObjModified("right panel")
                                    ObjModified("left panel")
                                    ObjModified("militia header")
                                end
                            })
                        })
                    }),
                })
            }),
        })
    })
end
