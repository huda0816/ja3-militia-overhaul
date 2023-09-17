GameVar("gv_HUDA_News", {})


MercHiredHeadlines = {
    "Elite Mercenary <mercName> Joins Our Ranks from <affiliation>!",
    "Militia Strengthens Its Forces with Distinguished Mercenary <mercName>",
    "Distinguished Mercenary <mercName> Enlisted from <affiliation> to Boost Our Forces!",
    "Renowned Mercenary <mercName> from <affiliation> Now Part of Our struggle!",
    "Militia Gains a Strategic Edge with Mercenary <mercName> from <affiliation>!",
    "Militia Welcomes Expert Mercenary <mercName> from <affiliation>!",
    "Mercenary <mercName> Joins Our Ranks, Fortifying Militia's Capabilities!",
    "Militia's Forces Enhanced as Mercenary <mercName> Comes Aboard from <affiliation>!",
    "Militia Celebrates New Recruit: Mercenary <mercName> from <affiliation>!",
    "Distinguished Mercenary <mercName> from <affiliation> to Strengthen Militia!",
    "Militia's Readiness Fortified by Mercenary <mercName> from <affiliation>!",
    "Roster Enriched with Mercenary <mercName> from <affiliation>!",
    "Elite Mercenary <mercName> from <affiliation> Now Part of Our struffle !",
    "Mercenary <mercName> from <affiliation> Enhances Militia's Capabilities!"
}

MercHiredTexts = {
    "In a significant development, <mercName> has been enlisted as a distinguished mercenary with a stellar background in various fields of warfare. Hailing from the renowned <affiliation> organization, <mercName>'s expertise will undoubtedly enhance our militia's capabilities and readiness for any challenge that lies ahead. This pivotal recruitment underscores our unwavering commitment to strengthening our forces.",
    "A remarkable addition to our ranks, <mercName> now stands among us as a seasoned mercenary, bringing a wealth of experience from the esteemed <affiliation> organization. His expertise is poised to elevate our militia's capabilities, preparing us for whatever challenges may arise. This recruitment exemplifies our dedication to bolstering our forces.",
    "We are pleased to announce the enlistment of <mercName>, a distinguished mercenary renowned for his expertise across various warfare domains. Originating from the prestigious <affiliation> organization, <mercName> now joins our militia, enhancing our capabilities and fortifying us for the challenges ahead. His arrival signals a critical step in our mission.",
    "A pivotal moment has arrived as we welcome <mercName> to our militia's ranks. As a distinguished mercenary with an impressive background in warfare, <mercName> brings invaluable expertise from the esteemed <affiliation> organization. Our militia's capabilities and readiness receive a substantial boost with this recruitment, reinforcing our mission's importance.",
    "Our militia's strength grows with the addition of <mercName>, a seasoned mercenary celebrated for his prowess in various warfare disciplines. With roots in the renowned <affiliation> organization, <mercName> lends his expertise to bolster our capabilities and prepare us for the challenges that lie ahead. This recruitment signifies a crucial step forward in our mission.",
    "It is with great pride that we introduce <mercName>, a distinguished mercenary whose extensive experience in warfare comes from the revered <affiliation> organization. As <mercName> joins our militia, his expertise promises to enhance our capabilities and readiness for future challenges. This recruitment stands as a testament to our unwavering commitment to progress.",
    "Join us in welcoming <mercName> to our militia's distinguished roster. Hailing from the esteemed <affiliation> organization, <mercName> brings invaluable expertise that will undoubtedly fortify our capabilities and readiness for whatever challenges the future holds. This recruitment reinforces our dedication to fortify our ranks with battle-tested talent.",
    "A momentous occasion has arrived with the enlistment of <mercName> into our militia's ranks. As a distinguished mercenary with a stellar background in warfare, <mercName> brings extensive expertise from the renowned <affiliation> organization. Our militia's capabilities and preparedness are significantly bolstered by this recruitment, emphasizing our commitment to progress and strength.",
    "Our militia celebrates a noteworthy addition in the form of <mercName>, a distinguished mercenary with a wealth of experience across diverse warfare disciplines. Drawing from the illustrious <affiliation> organization, <mercName> stands ready to enhance our capabilities and fortify our militia for impending challenges. This recruitment underscores our mission's significance.",
    "We proudly introduce <mercName> as our latest recruit, a distinguished mercenary renowned for his mastery in the art of warfare. From the esteemed <affiliation> organization, <mercName> brings unparalleled expertise, enhancing our militia's capabilities and fortifying our readiness for the battles that await. This recruitment symbolizes our unwavering commitment to excellence.",
    "A new era dawns as we welcome <mercName> to our militia's fold, a distinguished mercenary with an illustrious history in warfare. Rooted in the revered <affiliation> organization, <mercName> joins us to elevate our capabilities and prepare us for the challenges ahead. This recruitment highlights our dedication to progress and strength.",
    "With great excitement, we introduce <mercName> as our newest member—a distinguished mercenary hailed for his expertise in warfare. Emerging from the esteemed <affiliation> organization, <mercName> will undoubtedly augment our militia's capabilities and readiness for future trials. This recruitment reaffirms our commitment to excellence.",
    "Our militia takes a significant stride forward with the enlistment of <mercName>, a distinguished mercenary boasting extensive experience across warfare domains. From the prestigious <affiliation> organization, <mercName> joins our ranks to bolster our capabilities and fortify us for the battles that lie ahead. This recruitment underscores our unwavering commitment to progress and resilience.",
    "We extend a warm welcome to <mercName>, our newest recruit—a distinguished mercenary renowned for his prowess in warfare. With a background rooted in the esteemed <affiliation> organization, <mercName> joins us to enhance our capabilities and fortify our readiness for the challenges of tomorrow. This recruitment embodies our commitment to growth and strength."
}


function OnMsg.MercHired(mercId, price, days, alreadyHired)
    
    if (alreadyHired) then
        return
    end

    local merc = gv_UnitData[mercId]

    local name = merc.Name or merc.Nick or merc.session_id

    local affiliation = merc.Affiliation or "AIM"

    local portrait = merc.Portrait

    local text = HUDA_T(MercHiredTexts[InteractionRandRange(1, #MercHiredTexts)],
        { mercName = name, affiliation = affiliation })

    local title = HUDA_T(MercHiredHeadlines[InteractionRandRange(1, #MercHiredHeadlines)], {
        mercName = name, affiliation = affiliation
    })

    HUDA_AddNews({
        title = title,
        text = text,
        date = Game.CampaignTime,
        sector = "H2",
        type = "News",
        Image = portrait,
    })
end

HUDA_AddDummyNews = function()
    HUDA_AddNews({
        title = "Dummy News",
        text = "This is a dummy news",
        date = Game.CampaignTime,
        sector = "H2",
        type = "News",
    })
end


HUDA_AddNews = function(news)
    HUDA_NewsController:AddNews(news)
end

DefineClass.HUDA_NewsController = {

}

function HUDA_NewsController:AddNews(news)
    gv_HUDA_News = gv_HUDA_News or {}

    table.insert(gv_HUDA_News, 1, news)

    Msg("HUDA_NewsAdded", news)
end

function HUDA_NewsController:GetNewsMeta(news)
    local city, date

    if (news.sector) then
        city = HUDA_GetClosestCity(news.sector)
    end

    if (news.date) then
        date = HUDA_GetDateFromTime(news.date)
    end

    return city, date
end
