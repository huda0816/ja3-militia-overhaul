GameVar("gv_HUDA_People", {})

-- function OnMsg.ZuluGameLoaded(game)
--     if (#gv_HUDA_People > 0) then
--         return
--     end

--     HUDA_PeopleController:InitPeople()
-- end

--personmodel
-- local person = {
--     id = city .. "_" .. i,
--     unitId = nil,
--     city = city,
--     firstName = "Person " .. i,
--     lastName = "PersonLast " .. i,
--     gender = "male",
--     spouse = nil,
--     children = {},
--     mother = nil,
--     father = nil,
--     age = 0,
--     profession = "unemployed",
--     loyalty = 0,
--     nationality = "Grand Chien",
--     affiliation = "none"
-- }

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
    },
    totalPopulation = 0,
    persons = {}
}

function HUDA_PeopleController:GeneratePerson(father, mother, siblings)
    local person = {}

    person = self:FindSpouse(person, father, mother, siblings)

    person = self:GenerateChildren(person)

    self.totalPopulation = self.totalPopulation - 1

    return person
end

function HUDA_PeopleController:FindSpouse(person, father, mother, siblings)
    if person.age < 17 then
        return person
    end

    local roll = Random(1, 100)

    if roll > 70 then
        return person
    end

    for i, candidate in ipairs(self.persons) do
        if candidate.age >= 17 and
            candidate.spouse == nil and
            candidate.children == {} and
            candidate.city == person.city and
            person.gender ~= candidate.gender and
            father.id ~= candidate.id and
            mother.id ~= candidate.id then
            
                local is_sibling = false

            for i, sibling in ipairs(siblings) do
                if sibling.id == candidate.id then
                    is_sibling = true
                end
            end

            if not is_sibling then
                local age_difference = person.gender == "male" and person.age - candidate.age or
                candidate.age - person.age

                if person.gender == "male" and age_difference > -2 and age_difference < 10 then
                    candidate.spouse = person.id
                    person.spouse = candidate.id
                    return person
                end
            end
        end
    end
end

function HUDA_PeopleController:GenerateChildren(person)
    person.children = {}

    local roll = Random(1, 100)

    local threshold = person.spouse == nil and 90 or person.gender == "female" and 40 or 10

    if roll > threshold then
        return person
    end

    local children_num = Random(1, 4)

    person.children = {}

    local forbidden 

    for i = 1, children_num do
        local child = self:GeneratePerson(forbidden)

        table.insert(person.children, child.id)
    end
    end
end

function HUDA_PeopleController:InitPeople()
    for city, number in pairs(self.cityPopulation) do
        self.totalPopulation = self.totalPopulation + number
    end

    while self.totalPopulation > 0 do
        local person = self:GeneratePerson()

        table.insert(self.persons, person)
    end







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
