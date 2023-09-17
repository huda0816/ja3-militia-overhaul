GameVar("gv_HUDA_News", {})

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