if FirstLoad then
    local HUDA_hyperlink_function = CustomSettingsMod.Utils.XTemplate_FindElementsByProp(XTemplates["PDAQuests_Email"],
        "name", "OnHyperLink(self, hyperlink, argument, hyperlink_box, pos, button)")

    if HUDA_hyperlink_function then
        HUDA_hyperlink_function.element.func = function(self, hyperlink, argument, hyperlink_box, pos, button)
            if hyperlink == "OpenIMPPage" then
                OpenIMPPage()
            end
            if hyperlink == "OpenShopPage" then
                HUDA_OpenShopPage()
            end
            if hyperlink == "OpenSectorInventory" then
                HUDA_OpenSectorInventory()
            end
        end
    end
end


function HUDA_OpenShopPage()
    local pda = GetDialog("PDADialog")
    pda = pda or OpenDialog("PDADialog", GetInGameInterface(), { Mode = "browser" })
    if pda.Mode ~= "browser" then
        pda:SetMode("browser")
    end
    local dlg = pda.idContent
    if dlg and dlg.Mode ~= "militia" then
        dlg:SetMode("militia")
    end
    local militia = dlg.idBrowserContent
    if militia and militia.Mode ~= "shop" then
        militia:SetMode("shop")
    end
end

function HUDA_OpenSectorInventory()
    local sectorId = "H2"

    local unitsInSector = GetPlayerSectorUnits(sectorId)

    if not next(unitsInSector) then
        local popupHost = GetDialog("PDADialog")
        popupHost = popupHost and popupHost:ResolveId("idPDAContainer")

        local dlg = CreateMessageBox(popupHost, "No Units in sector",
            "Move units to sector " .. sectorId .. ", to open the inventory.")
    else
        local unit = unitsInSector[1]

        OpenInventory(unit, GetSectorInventory(sectorId))
    end
end

PlaceObj('Email', {
    body =
    "Dear customer,\n\nHold onto your helmets, because the Grand Chien Militia Staff Shop has just received a top-secret shipment of game-changing gear!\n\nPrepare for action with our latest additions:\n\n<equipment>\n\n<h OpenShopPage><underline><em>Equip Now</em></underline></h>\n\nSincerely,\n I.M.P.M.S.S. Customer Service",
    group = "Militia",
    label = "Important",
    id = "HUDA_NewArrivals",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Incoming Tactical Advancements",
    repeatable = true,
})


PlaceObj('Email', {
    body =
    "Dear customer,\n\nWe are happy to inform you that your order has been delivered to <h OpenSectorInventory><underline><em><location></em></underline></h>.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P.M.S.S. Customer Service",
    group = "Militia",
    label = "Important",
    id = "HUDA_ShipmentArrived",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Order delivered",
    repeatable = true,
})

PlaceObj('Email', {
    body =
    "Dear customer,\n\nWe received your order and are preparing it for delivery.\n\nThank you for choosing I.M.P.M.S.S.!\n\nSincerely,\n I.M.P.M.S.S. Customer Service",
    group = "Militia",
    id = "HUDA_OrderPlaced",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Thank you for your order",
    repeatable = true,
})

PlaceObj('Email', {
    body =
    "Dear customer,\n\nWe noticed that you recently visited the I.M.P. Militia Staff Shop and filled your cart with top-notch weaponry, ammunition, and essential equipment. But it seems like your virtual shopping spree got interrupted, and your cart has been sitting there, waiting for you.\n\nDon't let your gear slip away! Click below to complete your purchase and ensure you're fully equipped for your next mission.\n\n<h OpenShopPage><underline><em>complete purchase</em></underline></h>\n\nSincerely,\n I.M.P.M.S.S. Customer Service\n\nP.S. Consider this your final warning. Your gear won't stay in that cart forever. Time is running out, and the battlefield is unforgiving. Don't let your indecision become your downfall. Act now, or the consequences will be dire.",
    group = "Militia",
    label = "Important",
    id = "HUDA_AbandonedCart",
    sender = "shop@imp.net",
    title = "I.M.P.M.S.S. - Don't Let Your Gear Slip Away!",
    repeatable = true,
})
