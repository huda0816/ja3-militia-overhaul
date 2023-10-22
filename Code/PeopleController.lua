GameVar("gv_HUDA_People", {})

-- function OnMsg.ZuluGameLoaded(game)
--     if (#gv_HUDA_People > 0) then
--         return
--     end

--     HUDA_PeopleController:InitPeople()
-- end

DefineClass.HUDA_PeopleController = {
    cityPopulation = {
        ErnieVillage = 394,
        Pantagruel = 1620,
        Sabra = 0,
        Landsbach = 720,
        Bloemstad = 0,
        IlleMorat = 537,
        Chalet = 849,
        Fleatown = 894,
        Payak = 654,
        PortDiancie = 2940,
        RefugeeCamp = 496
    }
}


function HUDA_PeopleController:InitPeople()
    local persons = gv_HUDA_People or {}

    for city, number in pairs(self.cityPopulation) do
        for i = 1, number do
            local person = {
                id = city .. "_" .. i,
                unitId = nil,
                city = city,
                firstName = "Person " .. i,
                lastName = "PersonLast " .. i,
                gender = "male",
                spouse = nil,
                children = {},
                mother = nil,
                father = nil,
                age = 0,
                profession = "unemployed",
                loyalty = 0,
                nationality = "Grand Chien",
                affiliation = "none"
            }
            table.insert(persons, person)
        end
    end

    gv_HUDA_People = persons
end
