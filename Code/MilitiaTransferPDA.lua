DefineClass.XTransferItemTile = {
    __parents = { "XOperationItemTile" },
    slot_image = "UI/SectorOperations/T_Icon_Activity_Traveling",
}

DefineClass.PDAHUDAOPActionButtonClass = {
    __parents = { "PDACommonButtonClass" },
    shortcut = false,
    shortcut_gamepad = false,
    applied_gamepad_margin = false,
    FXMouseIn = "buttonRollover",
    FXPress = "buttonPress",
    FXPressDisabled = "IactDisabled",
    Padding = box(8, 0, 8, 0),
    MinHeight = 26,
    MaxHeight = 26,
    MinWidth = 0,
    SqueezeX = true,
    MouseCursor = "UI/Cursors/Pda_Hand.tga",
}

function OnMsg.DataLoaded()
    PlaceObj('XTemplate', {
        __is_kind_of = "PDAHUDAOPActionButtonClass",
        group = "Zulu PDA",
        id = "PDAHUDAOPActionButton",
        PlaceObj('XTemplateWindow', {
            '__class', "PDAHUDAOPActionButtonClass",
            'LayoutMethod', "Box",
            'DisabledBackground', RGBA(255, 255, 255, 255),
            'Image', "UI/PDA/os_system_buttons",
            'FrameBox', box(10, 10, 10, 10),
            'TextStyle', "PDACommonButton",
            'Translate', true,
            'ColumnsUse', "abcca",
        }, {
            PlaceObj('XTemplateFunc', {
                'name', "Open",
                'func', function(self, ...)
                PDACommonButtonClass.Open(self)
                HUDA_MilitiaTransfer:SetButtonState(self)
            end,
            })
        }),
    })

    PlaceObj('XTemplate', {
        __is_kind_of = "XDialog",
        group = "Zulu",
        id = "MilitiaItemsTransferSelectItemsUI",
        PlaceObj('XTemplateWindow', {
            '__class', "XDialog",
            'Id', "idList",
            'IdNode', false,
            'Dock', "box",
            'OnContextUpdate', function(self, context, ...)
            --local node= self:ResolveId("node")
            --node.idMercsList:OnContextUpdate(GetOperationMercsListContext(context, GetActionsHost(self, true).mode_param))
        end,
            'HostInParent', true,
            'FocusOnOpen', "child",
        }, {
            PlaceObj('XTemplateFunc', {
                'name', "delete(self, ...)",
                'func', function(self, ...)
                if DragSource then
                    DragSource:InternalDragStop(terminal.GetMousePos())
                end
                return XDialog.delete(self, ...)
            end,
            }),
            PlaceObj('XTemplateFunc', {
                'name', "OnKillFocus(self)",
                'func', function(self)
                if DragSource then
                    DragSource:InternalDragStop(terminal.GetMousePos())
                end
                XDialog.OnKillFocus(self)
            end,
            }),
            PlaceObj('XTemplateWindow', {
                '__context', function(parent, context)
                return GetOperationMercsListContext(context,
                    GetActionsHost(parent, true).mode_param)
            end,
                '__class', "XContextWindow",
                'VAlign', "top",
                'Clip', "self",
            }, {
                PlaceObj('XTemplateWindow', {
                    '__class', "XContentTemplate",
                    'Id', "idMercsList",
                    'IdNode', false,
                    'VAlign', "top",
                    'MaxWidth', 800,
                    'Clip', "self",
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__class', "XText",
                        'Id', "idText",
                        'VAlign', "top",
                        'FoldWhenHidden', true,
                        'HandleMouse', false,
                        'TextStyle', "PDAActivitiesSubTitleDark",
                        'Translate', true,
                        'HideOnEmpty', true,
                        'TextVAlign', "center",
                    }),
                    PlaceObj('XTemplateWindow', {
                        'Margins', box(24, 18, 24, 18),
                        'LayoutMethod', "VList",
                    }, {
                        PlaceObj('XTemplateWindow', {
                            '__condition', function(parent, context)
                            -- local operation = context.operation or context[1] and context[1].operation
                            return true
                        end,
                            'LayoutMethod', "HList",
                        }, {
                            PlaceObj('XTemplateWindow', {
                                'comment', "items queue",
                                'VAlign', "top",
                                'LayoutMethod', "VList",
                                'Dock', "right",
                                'HAlign', "right",
                                'MinWidth', 340,
                                'MaxWidth', 340,
                                'Clip', "parent & self",
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    'comment', "items title",
                                    'LayoutMethod', "VList",
                                }, {
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XText",
                                        'Id', "idQueuedText",
                                        'VAlign', "top",
                                        'FoldWhenHidden', true,
                                        'HandleMouse', false,
                                        'TextStyle', "PDAActivitiesSubTitleDark",
                                        'Translate', true,
                                        'Text', T(7145947544250815, --[[XTemplate SectorOperationSelectItemsUI Text]]
                                        "Items to Transfer"),
                                        'HideOnEmpty', true,
                                        'TextVAlign', "center",
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        'VAlign', "top",
                                        'MinHeight', 2,
                                        'MaxHeight', 2,
                                        'Background', RGBA(124, 130, 96, 255),
                                        'Transparency', 160,
                                    }),
                                }),
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XContentTemplate",
                                    'Id', "idQueueList",
                                    'Margins', box(0, 0, 0, 0),
                                    'OnContextUpdate', function(self, context, ...)
                                    XContextWindow.OnContextUpdate(self, context, ...)
                                    local node = self.parent.parent:ResolveId("node")
                                    local sector = GetDialog(self.parent).context
                                    local sector_id = sector.Id
                                    local operation_id = context[1].operation
                                    local mercs = GetOperationProfessionals(sector_id, operation_id)
                                    local time = next(mercs) and mercs[1].OperationInitialETA or 0
                                    if time < 0 then time = 0 end
                                    local timeLeft = time and Game.CampaignTime + time
                                    local queue = HUDA_MilitiaTransfer:GetTables(sector_id, operation_id)
                                    local count = #(queue or empty_table)
                                    local text = T { 9487645669860816, "Items to Transfer<right><GameColorF><count>", count = count }
                                    node.idQueuedText:SetText(text)
                                    AddTimelineEvent("activity-temp", timeLeft, "operation",
                                        { operationId = operation_id, sectorId = sector_id })
                                end,
                                }, {
                                    PlaceObj('XTemplateFunc', {
                                        'name', "Open(self)",
                                        'func', function(self)
                                        XContentTemplate.Open(self)
                                        self:OnContextUpdate(self.context, true)
                                    end,
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XScrollArea",
                                        'Id', "idItemsQueue",
                                        'IdNode', false,
                                        'Margins', box(0, 10, 0, 0),
                                        'VAlign', "top",
                                        'MinHeight', 440,
                                        'MaxHeight', 440,
                                        'UniformColumnWidth', true,
                                        'UniformRowHeight', true,
                                        'Clip', "self",
                                        'VScroll', "idScrollbarQueue",
                                        'MouseWheelStep', 100,
                                    }, {
                                        PlaceObj('XTemplateWindow', {
                                            '__class', "XDragContextWindowTransfer",
                                            'Id', "idQueue",
                                            'Margins', box(0, 0, 0, 0),
                                            'GridStretchX', false,
                                            'GridStretchY', false,
                                            'LayoutMethod', "HWrap",
                                            'LayoutHSpacing', 0,
                                            'LayoutVSpacing', 10,
                                            'ChildrenHandleMouse', true,
                                            'ContextUpdateOnOpen', false,
                                            'slot_name', "ItemsQueue",
                                            'Margins', box(-3, 0, -3, 0),
                                        }, {
                                            PlaceObj('XTemplateForEach', {
                                                'comment', "item",
                                                'array', function(parent, context)
                                                local sector_id = GetDialog(parent).context.Id
                                                local queue = HUDA_MilitiaTransfer:GetTables(sector_id,
                                                    "HUDA_MilitiaSellItems")

                                                return queue
                                            end,
                                                '__context', function(parent, context, item, i, n)
                                                return
                                                    HUDA_MilitiaTransfer:GetItemDef(item)
                                            end,
                                                'run_after', function(child, context, item, i, n, last)
                                                rawset(child, "slot_idx", i)
                                                local ctx = HUDA_MilitiaTransfer:GetItemDef(item)
                                                child:SetContext(ctx)
                                                rawset(child.idItem, "slot", item.slot)
                                                rawset(child.idItem, "item", item)
                                                child.idItem:SetContext(ctx)
                                                child.idItem.idText:SetVisible(true)
                                                child.parent:SetChildrenHandleMouse(true)

                                                local currentSectorId = GetDialog(child.parent).context.Id

                                                local filter = HUDA_MilitiaTransfer:GetFilter(currentSectorId)

                                                child:SetFoldWhenHidden(true)

                                                if next(filter) and not table.find(filter, item.category) then
                                                    child:SetVisible(false)
                                                else
                                                    child:SetVisible(true)
                                                end
                                            end,
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XContextWindow",
                                                    'IdNode', true,
                                                    'HAlign', "left",
                                                    'Margins', box(3, 0, 3, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XFrame",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'BorderColor', RGBA(255, 255, 255, 0),
                                                        'Background', RGBA(255, 255, 255, 0),
                                                        'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBackground', RGBA(255, 255, 255, 0),
                                                        'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                    }, {
                                                        PlaceObj('XTemplateWindow', {
                                                            '__class', "XActivityItem",
                                                            'Id', "idItem",
                                                            'IdNode', false,
                                                            'HAlign', "left",
                                                            'VAlign', "center",
                                                            'OnLayoutComplete', function(self)
                                                            self.idText:SetPadding(box(2, 2, 2, 2))
                                                            self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                        end,
                                                            'UniformColumnWidth', true,
                                                            'UniformRowHeight', true,
                                                        }, {
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "IsDropTarget(self,drag_win, pt, source)",
                                                                'func', function(self, drag_win, pt, source)
                                                                return false
                                                            end,
                                                            }),
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "Open(self, ...)",
                                                                'func', function(self, ...)
                                                                local node = self:ResolveId("node")
                                                                XInventoryItem.Open(self, ...)
                                                                self.idItemPad:SetImage(false)
                                                                self.idItemPad:SetMinWidth(self:GetMinWidth())
                                                                self.idItemPad:SetMaxWidth(self:GetMaxWidth())
                                                                self.idItemPad:SetBackground(GameColors.B)
                                                                self.idText:SetPadding(box(2, 2, 2, 2))
                                                                self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                            end,
                                                            }),
                                                        }),
                                                    }),
                                                }),
                                            }),
                                            PlaceObj('XTemplateForEach', {
                                                'comment', "item empty",
                                                'array', function(parent, context)
                                                local sector     = GetDialog(parent).context.Id
                                                local queue      = HUDA_MilitiaTransfer:GetTables(sector,
                                                    "HUDA_MilitiaSellItems")
                                                local full_table = queue
                                                local to_return  = {}
                                                local count      = 4
                                                -- for i, itm_data in ipairs(full_table) do
                                                --     local itm = HUDA_MilitiaTransfer:GetItemDef(itm_data)
                                                --     count = count - (itm:IsLargeItem() and 2 or 1)
                                                -- end
                                                -- count = Max(3, count)
                                                for i = 1, count do
                                                    to_return[i] = i
                                                end
                                                return to_return
                                            end,
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XContextWindow",
                                                    'IdNode', true,
                                                    'HAlign', "left",
                                                    'Margins', box(3, 0, 3, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XFrame",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'BorderColor', RGBA(255, 255, 255, 0),
                                                        'Background', RGBA(255, 255, 255, 0),
                                                        'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBackground', RGBA(255, 255, 255, 0),
                                                        'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                    }, {
                                                        PlaceObj('XTemplateWindow', {
                                                            '__class', "XTransferItemTile",
                                                            'Id', "idItem",
                                                            'IdNode', false,
                                                            'HAlign', "left",
                                                            'VAlign', "center",
                                                            'MinWidth', 72,
                                                            'MinHeight', 72,
                                                            'MaxWidth', 72,
                                                            'MaxHeight', 72,
                                                            'UniformColumnWidth', true,
                                                            'UniformRowHeight', true,
                                                        }, {
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "IsDropTarget(self,drag_win, pt, source)",
                                                                'func', function(self, drag_win, pt, source)
                                                                return false
                                                            end,
                                                            }),
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "Open(self, ...)",
                                                                'func', function(self, ...)
                                                                local node = self:ResolveId("node")
                                                                XInventoryItem.Open(self, ...)
                                                                self.idBackImage:SetImage(false)
                                                                self.idBackImage:SetMinWidth(self:GetMinWidth())
                                                                self.idBackImage:SetMaxWidth(self:GetMaxWidth())
                                                                self.idBackImage:SetBackground(GameColors.B)
                                                            end,
                                                            }),
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XZuluScroll",
                                        'Id', "idScrollbarQueue",
                                        'Margins', box(0, 10, 0, 0),
                                        'Dock', "right",
                                        'HAlign', "right",
                                        'ScaleModifier', point(800, 800),
                                        'Transparency', 125,
                                        'Target', "idItemsQueue",
                                        'AutoHide', true,
                                    }),
                                }),
                            }),
                            PlaceObj('XTemplateWindow', {
                                'comment', "repair items",
                                'VAlign', "top",
                                'LayoutMethod', "VList",
                                'Dock', "left",
                                'HAlign', "left",
                                'MinWidth', 340,
                                'MaxWidth', 340,
                                'Clip', "parent & self",
                            }, {
                                PlaceObj('XTemplateWindow', {
                                    'comment', "items title",
                                    'LayoutMethod', "VList",
                                }, {
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XText",
                                        'Id', "idRepairItems",
                                        'VAlign', "top",
                                        'FoldWhenHidden', true,
                                        'HandleMouse', false,
                                        'TextStyle', "PDAActivitiesSubTitleDark",
                                        'Translate', true,
                                        'Text', T(9134641120670815, --[[XTemplate SectorOperationSelectItemsUI Text]]
                                        "Available Items"),
                                        'HideOnEmpty', true,
                                        'TextVAlign', "center",
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        'VAlign', "top",
                                        'MinHeight', 2,
                                        'MaxHeight', 2,
                                        'Background', RGBA(124, 130, 96, 255),
                                        'Transparency', 160,
                                    }),
                                }),
                                PlaceObj('XTemplateWindow', {
                                    '__class', "XContentTemplate",
                                    'Id', "idAllList",
                                    'Margins', box(0, 0, 0, 0),
                                    'OnContextUpdate', function(self, context, ...)
                                    XContextWindow.OnContextUpdate(self, context, ...)
                                    local node = self.parent:ResolveId("node")
                                    local sector_id = GetDialog(self.parent).context.Id
                                    local operation_id = context[1].operation
                                    local count = #(HUDA_MilitiaTransfer:GetItemsToTransfer(sector_id, operation_id) or empty_table)
                                    local text = T { 9487645669860816, "Available Items<right><GameColorF><count>", count = count }
                                    node.idRepairItems:SetText(text)
                                end,
                                }, {
                                    PlaceObj('XTemplateFunc', {
                                        'name', "Open(self)",
                                        'func', function(self)
                                        XContentTemplate.Open(self)
                                        self:OnContextUpdate(self.context, true)
                                    end,
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XScrollArea",
                                        'Id', "idItemsList",
                                        'IdNode', false,
                                        'Margins', box(0, 10, 0, 0),
                                        'VAlign', "top",
                                        'MinHeight', 440,
                                        'MaxHeight', 440,
                                        'UniformColumnWidth', true,
                                        'UniformRowHeight', true,
                                        'Clip', "self",
                                        'VScroll', "idScrollbarAll",
                                        'MouseWheelStep', 100,
                                    }, {
                                        PlaceObj('XTemplateFunc', {
                                            'name', "OnShortcut(self, shortcut, source, ...)",
                                            'func', function(self, shortcut, source, ...)
                                            if shortcut == "RightThumbDown" then
                                                return self:OnMouseWheelBack()
                                            elseif shortcut == "RightThumbUp" then
                                                return self:OnMouseWheelForward()
                                            end
                                            return XScrollArea.OnShortcut(self, shortcut, source, ...)
                                        end,
                                        }),
                                        PlaceObj('XTemplateFunc', {
                                            'name', "Open(self)",
                                            'func', function(self)
                                            XScrollArea.Open(self)
                                            self:SetFocus()
                                            self.LeftThumbScroll = true
                                        end,
                                        }),
                                        PlaceObj('XTemplateWindow', {
                                            '__class', "XDragContextWindowTransfer",
                                            'Id', "idAllItems",
                                            'HAlign', "left",
                                            'GridStretchX', false,
                                            'GridStretchY', false,
                                            'LayoutMethod', "HWrap",
                                            'LayoutHSpacing', 0,
                                            'LayoutVSpacing', 10,
                                            'ChildrenHandleMouse', true,
                                            'ContextUpdateOnOpen', false,
                                            'slot_name', "AllItems",
                                            'Margins', box(-3, 0, -3, 0),
                                        }, {
                                            PlaceObj('XTemplateForEach', {
                                                'comment', "item",
                                                'array', function(parent, context)
                                                local sector_id = GetDialog(parent).context.Id
                                                local operation_id = context[1].operation

                                                local items = HUDA_MilitiaTransfer:GetItemsToTransfer(sector_id,
                                                        operation_id) or
                                                    empty_table

                                                return items
                                            end,
                                                'condition', function(parent, context, item, i) return not item.hidden end,
                                                '__context', function(parent, context, item, i, n)
                                                return
                                                    HUDA_MilitiaTransfer:GetItemDef(item)
                                            end,
                                                'run_after', function(child, context, item, i, n, last)
                                                rawset(child, "slot_idx", i)
                                                local ctx = HUDA_MilitiaTransfer:GetItemDef(item)
                                                child:SetContext(ctx)
                                                rawset(child.idItem, "slot", item.slot)
                                                rawset(child.idItem, "item", item)
                                                child.idItem:SetContext(ctx)
                                                child.idItem.idText:SetVisible(true)
                                                child.parent:SetChildrenHandleMouse(true)

                                                local currentSectorId = GetDialog(child.parent).context.Id

                                                local filter = HUDA_MilitiaTransfer:GetFilter(currentSectorId)

                                                child:SetFoldWhenHidden(true)

                                                if next(filter) and not table.find(filter, item.category) then
                                                    child:SetVisible(false)
                                                else
                                                    child:SetVisible(true)
                                                end
                                            end,
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XContextWindow",
                                                    'IdNode', true,
                                                    'HAlign', "left",
                                                    'Margins', box(3, 0, 3, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XFrame",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'BorderColor', RGBA(255, 255, 255, 0),
                                                        'Background', RGBA(255, 255, 255, 0),
                                                        'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBackground', RGBA(255, 255, 255, 0),
                                                        'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                    }, {
                                                        PlaceObj('XTemplateWindow', {
                                                            '__class', "XActivityItem",
                                                            'Id', "idItem",
                                                            'IdNode', false,
                                                            'HAlign', "left",
                                                            'VAlign', "center",
                                                            'OnLayoutComplete', function(self)
                                                            self.idText:SetPadding(box(2, 2, 2, 2))
                                                            self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                        end,
                                                            'UniformColumnWidth', true,
                                                            'UniformRowHeight', true,
                                                        }, {
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "IsDropTarget(self,drag_win, pt, source)",
                                                                'func', function(self, drag_win, pt, source)
                                                                return false
                                                            end,
                                                            }),
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "Open(self, ...)",
                                                                'func', function(self, ...)
                                                                local node = self:ResolveId("node")
                                                                XInventoryItem.Open(self, ...)
                                                                self.idItemPad:SetImage(false)
                                                                self.idItemPad:SetMinWidth(self:GetMinWidth())
                                                                self.idItemPad:SetMaxWidth(self:GetMaxWidth())
                                                                self.idItemPad:SetBackground(GameColors.B)
                                                                self.idText:SetPadding(box(2, 2, 2, 2))
                                                                self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                                                            end,
                                                            }),
                                                        }),
                                                    }),
                                                }),
                                            }),
                                            PlaceObj('XTemplateForEach', {
                                                'comment', "item empty",
                                                'array', function(parent, context)
                                                local sector     = GetDialog(parent).context.Id
                                                local queue, all = HUDA_MilitiaTransfer:GetTables(sector,
                                                    "HUDA_MilitiaSellItems")
                                                local to_return  = {}
                                                local count      = 4 --next(all or {}) and 0 or 4
                                                for i = 1, count do
                                                    to_return[i] = i
                                                end
                                                return to_return
                                            end,
                                            }, {
                                                PlaceObj('XTemplateWindow', {
                                                    '__class', "XContextWindow",
                                                    'IdNode', true,
                                                    'HAlign', "left",
                                                    'Margins', box(3, 0, 3, 0),
                                                }, {
                                                    PlaceObj('XTemplateWindow', {
                                                        '__class', "XFrame",
                                                        'IdNode', false,
                                                        'HAlign', "left",
                                                        'BorderColor', RGBA(255, 255, 255, 0),
                                                        'Background', RGBA(255, 255, 255, 0),
                                                        'BackgroundRectGlowColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBorderColor', RGBA(255, 255, 255, 0),
                                                        'FocusedBackground', RGBA(255, 255, 255, 0),
                                                        'DisabledBorderColor', RGBA(255, 255, 255, 0),
                                                    }, {
                                                        PlaceObj('XTemplateWindow', {
                                                            '__class', "XTransferItemTile",
                                                            'Id', "idItem",
                                                            'IdNode', false,
                                                            'HAlign', "left",
                                                            'VAlign', "center",
                                                            'MinWidth', 72,
                                                            'MinHeight', 72,
                                                            'MaxWidth', 72,
                                                            'MaxHeight', 72,
                                                            'UniformColumnWidth', true,
                                                            'UniformRowHeight', true,
                                                        }, {
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "IsDropTarget(self,drag_win, pt, source)",
                                                                'func', function(self, drag_win, pt, source)
                                                                return false
                                                            end,
                                                            }),
                                                            PlaceObj('XTemplateFunc', {
                                                                'name', "Open(self, ...)",
                                                                'func', function(self, ...)
                                                                local node = self:ResolveId("node")
                                                                XInventoryItem.Open(self, ...)
                                                                self.idBackImage:SetImage(false)
                                                                self.idBackImage:SetMinWidth(self:GetMinWidth())
                                                                self.idBackImage:SetMaxWidth(self:GetMaxWidth())
                                                                self.idBackImage:SetBackground(GameColors.B)
                                                            end,
                                                            }),
                                                        }),
                                                    }),
                                                }),
                                            }),
                                        }),
                                    }),
                                    PlaceObj('XTemplateWindow', {
                                        '__class', "XZuluScroll",
                                        'Id', "idScrollbarAll",
                                        'Margins', box(0, 10, 0, 0),
                                        'Dock', "right",
                                        'HAlign', "right",
                                        'ScaleModifier', point(800, 800),
                                        'Transparency', 125,
                                        'Target', "idItemsList",
                                        'AutoHide', true,
                                    }),
                                }),
                            }),
                        }),
                    }),
                }),
            }),
        }),
    })


    PlaceObj('XTemplate', {
        __is_kind_of = "XContextWindow",
        group = "Zulu",
        id = "MilitiaItemsTransferSectorPicker",
        PlaceObj('XTemplateWindow', {
            '__class', "XContextWindow",
            'Id', "idOperationDescr",
            'Margins', box(26, 25, 26, 16),
            'Dock', "left",
            'MinWidth', 366,
            'MaxWidth', 366,
            'LayoutMethod', "VList",
        }, {
            PlaceObj('XTemplateWindow', {
                'comment', "title",
                'Dock', "top",
                'LayoutMethod', "HList",
            }, {
                PlaceObj('XTemplateWindow', {
                    'Padding', box(2, 2, 2, 2),
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__condition', function(parent, context) return not context.operation end,
                        '__class', "XSquareWindow",
                        'IdNode', true,
                        'VAlign', "top",
                        'MinWidth', 54,
                        'MinHeight', 54,
                        'MaxHeight', 54,
                        'FoldWhenHidden', true,
                    }, {
                        PlaceObj('XTemplateWindow', {
                            '__class', "XText",
                            'Id', "idSector",
                            'HAlign', "center",
                            'VAlign', "center",
                            'Clip', false,
                            'TextStyle', "PDAActivitiesSectorIdBig",
                            'Translate', true,
                            'TextHAlign', "center",
                            'TextVAlign', "center",
                        }),
                        PlaceObj('XTemplateCode', {
                            'run', function(self, parent, context)
                            local sector = context.sector or GetDialog(parent).context
                            if sector then
                                local color, _, _, textColor = GetSectorControlColor(sector.Side)
                                local text = textColor .. sector.Id .. "</color>"
                                parent:SetBackground(color)
                                parent.idSector:SetText(T { 764093693143, "<SectorIdColored(id)>", id = sector.Id })
                            end
                        end,
                        }),
                    }),
                }),
                PlaceObj('XTemplateWindow', {
                    '__condition', function(parent, context) return not context.operation end,
                    'MinWidth', 10,
                    'MaxWidth', 10,
                    'FoldWhenHidden', true,
                }),
                PlaceObj('XTemplateWindow', {
                    '__class', "XContextWindow",
                    'Margins', box(0, -10, 0, 0),
                    'LayoutMethod', "VList",
                    'LayoutVSpacing', -10,
                    'UseClipBox', false,
                    'ContextUpdateOnOpen', true,
                    'OnContextUpdate', function(self, context, ...)
                    local id = context.operation
                    local operation = type(id) == "string" and SectorOperations[id] or id
                    if context.operation then
                        local c_title = self:ResolveId("idTitle")
                        local c_subtitle = self:ResolveId("idSubtitle")
                        c_title:SetText(operation.display_name)
                        c_subtitle:SetText(operation.sub_title or "")
                    end
                end,
                }, {
                    PlaceObj('XTemplateWindow', {
                        '__class', "XText",
                        'Id', "idTitle",
                        'HAlign', "left",
                        'VAlign', "center",
                        'Clip', false,
                        'UseClipBox', false,
                        'TextStyle', "PDAActivitiesTitle",
                        'Translate', true,
                        'Text', T(502856071518, --[[XTemplate SectorOperationDescrUI Text]] "Operations"),
                        'TextVAlign', "center",
                    }),
                    PlaceObj('XTemplateWindow', {
                        '__class', "XText",
                        'Id', "idSubtitle",
                        'Margins', box(0, 4, 0, 0),
                        'VAlign', "top",
                        'Clip', false,
                        'UseClipBox', false,
                        'FoldWhenHidden', true,
                        'TextStyle', "PDAActivitiesSubTitle",
                        'Translate', true,
                        'HideOnEmpty', true,
                    }, {
                        PlaceObj('XTemplateCode', {
                            'run', function(self, parent, context)
                            if IsKindOf(context, "SectorOperation") then
                                parent:SetText(context.sub_title)
                            else
                                local sector = context.sector
                                local operations = GetOperationsInSector(sector.Id)
                                local max = #operations
                                local num = table.count(operations, "enabled", true)
                                parent:SetText(T { 992386523035, "AVAILABLE <count>/<max>", count = num, max = max })
                            end
                        end,
                        }),
                    }),
                }),
            }),
            PlaceObj('XTemplateWindow', {
                'comment', "line",
                '__class', "XFrame",
                'Dock', "top",
                'VAlign', "top",
                'Image', "UI/PDA/separate_line_vertical",
                'FrameBox', box(2, 0, 2, 0),
                'SqueezeY', false,
            }),
            PlaceObj('XTemplateWindow', {
                '__context', function(parent, context) return context.operation end,
                '__class', "XText",
                'Margins', box(0, 18, 0, 18),
                'Id', "idOperationDescrText",
                'HandleMouse', false,
                'TextStyle', "PDAActivityDescription",
                'Translate', true,
                'Text', T(4259299964110819, "Choose a transfer location or collect items from this city"),
                'Shorten', true,
            }),
            PlaceObj('XTemplateWindow', {
                'LayoutMethod', "VList",
            }, {
                PlaceObj('XTemplateWindow', {
                    '__class', "XScrollArea",
                    'Id', "idLocations",
                    'IdNode', false,
                    'Margins', box(0, 0, 10, 0),
                    'VAlign', "top",
                    'MinHeight', 340,
                    'MaxHeight', 340,
                    'UniformColumnWidth', true,
                    'UniformRowHeight', true,
                    'Clip', "self",
                    'VScroll', "idScrollbarLocations",
                    'MouseWheelStep', 100,
                }, {
                    PlaceObj('XTemplateWindow', {
                        'LayoutMethod', "VList",
                    }, {
                        PlaceObj("XTemplateForEach", {
                            "array",
                            function(parent, context)
                                return HUDA_MilitiaTransfer:GetTransferLocations(context.sector.Id)
                            end,
                            "__context",
                            function(parent, context, item, i, n)
                                return item
                            end,
                            "run_after",
                            function(child, context, item, i, n, last)
                                local sectorId = item.sectorId
                                local sector = gv_Sectors[sectorId]
                                local currentSectorId = child.parent.parent.parent.parent.context.sector.Id
                                local currentSector = gv_Sectors[currentSectorId]

                                local text = ""
                                local iconText = "M"
                                local colorSide = "player1"

                                child:SetEnabled(false)

                                if context.type == "export" then
                                    local total = HUDA_MilitiaTransfer:GetTotalPrice(currentSectorId)
                                    text = "Sell to " .. context.name .. " (+$" .. total .. ")"
                                    child:SetMargins(box(0, 0, 0, 15))
                                    iconText = "$"
                                    colorSide = "enemy1"
                                    if HUDA_MilitiaTransfer:QueueHasItems(currentSectorId) then
                                        child:SetEnabled(true)
                                    end
                                elseif context.type == "collect" then
                                    local cityItems = HUDA_MilitiaTransfer:GetItemsFromCity(sectorId)
                                    if next(cityItems) then
                                        text = "Collect from " .. currentSector.City .. " (" .. #cityItems .. ")"
                                        child:SetMargins(box(0, 0, 0, 15))
                                        iconText = context.sectorId
                                        child:SetEnabled(true)
                                        child:SetVisible(true)
                                    else
                                        child:SetVisible(false)
                                        child:SetFoldWhenHidden(true)
                                    end
                                else
                                    text = sector.display_name ..
                                        (context.travelTime and " (~" .. context.travelTime .. "h)" or "")
                                    iconText = sectorId
                                    if HUDA_MilitiaTransfer:QueueHasItems(currentSectorId) then
                                        child:SetEnabled(true)
                                    end
                                end

                                local color, c2, c3, c4 = GetSectorControlColor(colorSide)

                                child.idSectorId:SetText(c4 .. iconText .. "</color>")
                                child.idSectorSquare:SetBackground(color)
                                child:SetText(text)
                            end
                        }, {
                            PlaceObj("XTemplateTemplate", {
                                "__template",
                                "PDACommonButton",
                                'Margins',
                                box(2, 0, 2, 0),
                                "Padding",
                                box(0, 0, 8, 0),
                                "MinHeight",
                                40,
                                "MaxHeight",
                                40,
                                "LayoutMethod",
                                "HList",
                                "LayoutHSpacing",
                                0,
                                "OnPress",
                                function(self, gamepad)
                                    HUDA_MilitiaTransfer:HandleAction(self.parent.parent.parent.parent.context.sector.Id,
                                        self.context)

                                    local host = GetActionsHost(self, true)

                                    host.idBase.idMain:StartOperation(host)
                                end
                            }, {
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XSquareWindow",
                                    "Id",
                                    "idSectorSquare",
                                    "Margins",
                                    box(0, 0, 5, 0),
                                    "HAlign",
                                    "left",
                                    "VAlign",
                                    "top",
                                    "MinWidth",
                                    38,
                                    "MaxWidth",
                                    38
                                }, {
                                    PlaceObj("XTemplateWindow", {
                                        "__class",
                                        "XText",
                                        "Id",
                                        "idSectorId",
                                        "Margins",
                                        box(2, 0, 0, 0),
                                        "HAlign",
                                        "center",
                                        "VAlign",
                                        "center",
                                        "Clip",
                                        false,
                                        "TextStyle",
                                        "PDASatelliteRollover_SectorTitle",
                                        "Translate",
                                        true,
                                        "TextHAlign",
                                        "center",
                                        "TextVAlign",
                                        "center"
                                    })
                                }),
                                PlaceObj("XTemplateWindow", {
                                    "__class",
                                    "XText",
                                    "Id",
                                    "idSectorGuards",
                                    "Margins",
                                    box(2, 0, 0, 0),
                                    "HAlign",
                                    "right",
                                    "VAlign",
                                    "center",
                                    "Dock",
                                    "right",
                                    "Clip",
                                    false,
                                    "TextStyle",
                                    "PDACommonButton",
                                    "Translate",
                                    true,
                                    "TextHAlign",
                                    "center",
                                    "TextVAlign",
                                    "center"
                                }),
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "OnSetRollover(self, rollover)",
                                    "func",
                                    function(self, rollover)
                                        if not rollover then
                                            return
                                        end
                                        local sectorId = self.context.Id
                                    end
                                }),
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "IsSelectable(self)",
                                    "func",
                                    function(self)
                                        return true
                                    end
                                }),
                                PlaceObj("XTemplateFunc", {
                                    "name",
                                    "SetSelected(self, selected)",
                                    "func",
                                    function(self, selected)
                                        self:SetFocus(selected)
                                        self:SetImage(selected and "UI/PDA/os_system_buttons_yellow" or
                                            "UI/PDA/os_system_buttons")
                                    end
                                })
                            })
                        })
                    })
                }),
                PlaceObj('XTemplateWindow', {
                    '__class', "XZuluScroll",
                    'Id', "idScrollbarLocations",
                    'Margins', box(0, 0, 10, 0),
                    'Dock', "right",
                    'HAlign', "right",
                    'ScaleModifier', point(800, 800),
                    'Transparency', 125,
                    'Target', "idLocations",
                    'AutoHide', true,
                }),
            })
        })
    })
end
