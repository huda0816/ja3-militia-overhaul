-- Zulib or slider mod from audaki_ra has to be active for that
if Zulib.setupModSlider then
    local slider_options = {
        "huda_militiaDailyCampaignCosts",
        "huda_militiaDailyUpkeepRookie",
        "huda_militiaDailyUpkeepVeteran",
        "huda_militiaDailyUpkeepElite"
    }

    for index, option in ipairs(slider_options) do
        Zulib.setupModSlider({
            modId = CurrentModId,
            optionId = option,
            displayType = 'value',
            displayPostfix = '$',
        })
    end
end
