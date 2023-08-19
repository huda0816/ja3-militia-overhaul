function HUDA_GetRandomMilitiaName()
    return HUDA_male_militia_names[InteractionRand(223)]
end

function HUDA_GetRandomMilitiaSquadName()
    return HUDA_militia_squad_names[InteractionRand(60)]
end

function HUDA_GetRandomBio(name)
    local bio = HUDA_militia_bios[InteractionRand(50)]

    return string.gsub(bio, "<name>", name)
end

function UpdateNickNames(unit_ids)
    local units = {}

    local unit_data = gv_UnitData

    if not unit_ids then
        units = unit_data and table.filter(unit_data, function(k, v) return v.militia end) or {}

    else
        units = table.filter(unit_data, function(k, v) return v.militia and ArrayContains(unit_ids, k) end)
    end

    if units then
        for k, unit in pairs(units) do
            if not unit.Nick then
                local nick = HUDA_GetRandomMilitiaName()

                unit.Nick = nick
                unit.AllCapsNick = string.upper(nick)
                unit.snype_nick = "Militia " .. nick
            end

            if not unit.JoinDate then
                unit.JoinDate = Game.CampaignTime
            end

            if not unit.JoinLocation then
                unit.JoinLocation = unit:GetSector().Id
            end

            if not unit.Bio and unit.Nick then
                unit.Bio = HUDA_GetRandomBio(unit.Nick)
            end

            if not unit.StatsRandomized then
                HUDA_RandomizeStats(unit)
            end

            unit:AddStatusEffect("GCMilitia")

            print("Morale", unit.class, unit:GetPersonalMorale())

        end
    end
end

function HUDAGetRandomSquadName(sector_id)
    local sector = gv_Sectors[sector_id]

    local sector_name = GetSectorName(sector)

    return sector_name .. " - " .. HUDA_GetRandomMilitiaSquadName()
end

function HUDA_RandomizeStats(unit)
    local defaults = {
        Health = 65,
        Agility = 70,
        Strength = 70,
        Wisdom = 50,
        Leadership = 25,
        Marksmanship = 70,
        Mechanical = 20,
        Explosives = 20,
        Medical = 30,
        Dexterity = 60,
    }

    for k, v in pairs(defaults) do
            unit[k] = InteractionRandRange(v - 10, v + 10)
    end

    unit.StatsRandomized = true

end

HUDA_male_militia_names = {
    "Amadou", "Jean-Baptiste", "Issa", "Kofi", "Léon", "Malik", "Sékou", "Alassane", "Aboubakar", "Yves",
    "Mamadou", "Ousmane", "Claude", "Idriss", "Modibo", "Samba", "Félix", "Aliou", "Youssef", "Souleymane",
    "Adama", "Victor", "Moussa", "Jacques", "Doudou", "Ahmed", "Pierre", "Emmanuel", "Olivier", "Charles",
    "Amadou", "Yannick", "Prosper", "Marcel", "Antoine", "François", "Bertrand", "Didier", "Gilbert", "Hervé",
    "Blaise", "Thierry", "Serge", "Sébastien", "Lionel", "Raoul", "Raymond", "Aimé", "Aymar", "Boris",
    "Constantin", "David", "Elie", "Fabrice", "Gérard", "Hector", "Isaac", "Jérôme", "Kévin", "Laurent",
    "Mathieu", "Noël", "Octave", "Pascal", "Quentin", "Romain", "Samuel", "Théodore", "Ulysse", "Vincent",
    "William", "Xavier", "Yann", "Zéphyr", "Ange", "Basile", "Cyprien", "Désiré", "Édouard", "Firmin",
    "Gaston", "Hector", "Irénée", "Jules", "Kilian", "Lambert", "Médard", "Napoléon", "Onésime", "Parfait",
    "Quirin", "Raphaël", "Siméon", "Théophile", "Ulrich", "Victorien", "Wilfried", "Xénophon", "Yvon",
    "Zéphirin", "Abdoulaye", "Bakary", "Cheikh", "Djibril", "Issouf", "Karim", "Lamine", "Mouhamed", "Ndiaye",
    "Oumar", "Sadio", "Tidiane", "Adnan", "Bilal", "Cem", "Emin", "Farouk", "Ghazi", "Hamza", "Ibrahim",
    "Jalal", "Khalid", "Lutfi", "Mounir", "Nabil", "Omar", "Qasim", "Rashid", "Sami", "Tariq", "Usama",
    "Wael", "Yasin", "Zain", "Akin", "Babatunde", "Chidi", "Dike", "Emeka", "Folami", "Gbenga", "Hakim",
    "Idris", "Jabari", "Kwame", "Lekan", "Malik", "Nkemdilim", "Obasi", "Osaze", "Pius", "Quincy", "Rasheed",
    "Sadiq", "Tunde", "Uzoma", "Vincent", "Wale", "Xola", "Yakubu", "Zuberi", "Adel", "Bachir", "Chakib",
    "Djamel", "Elhadj", "Fouad", "Ghassan", "Habib", "Ilyas", "Jamal", "Kamal", "Larbi", "Majid", "Nadir",
    "Omar", "Qasim", "Rachid", "Salim", "Tarek", "Walid", "Youssef", "Zakariya", "Abdul", "Bilal", "Chacha",
    "Dhaki", "Eshe", "Fahari", "Gamba", "Hasani", "Imani", "Jelani", "Kamau", "Lengo", "Mosi", "Nuru",
    "Oba", "Panya", "Quara", "Rashidi", "Simba", "Tafari", "Ujima", "Vijay", "Wamalwa", "Xolani", "Yusuf",
    "Zahur", "Abebe", "Birhanu", "Desta", "Endale", "Fikru", "Girma", "Habte", "Iyasu", "Jember", "Kebrom",
    "Lulseged", "Mekonnen", "Nigussie", "Obang", "Petros", "Qidus", "Rufael", "Selassie", "Tewodros", "Woldemariam",
    "Xola", "Yared", "Zewdu"
}


HUDA_militia_squad_names = {

    "Gardes du Royaume",
    "Sentinelles de Valeur",
    "Protecteurs de l'Honneur",
    "Vigilants de la Justice",
    "Veilleurs de la Nuit",
    "Porte-Écus du Clair de Lune",
    "Corps des Gardiens",
    "Boucliers de l'Unité",
    "Garde-Paix de l'Alliance",
    "Unité de Sauvegarde Alpha",
    "Force de Garnison Écho",
    "Gardiens des Remparts",
    "Ligue de la Milice du Village",
    "Assemblée des Gardiens de la Citadelle",
    "Ordre des Défenseurs",
    "Légion Cuirassée",
    "Confrérie des Gardiens",
    "Militants de l'Aube",
    "Vanguard des Cœurs de Pierre",
    "Brigade de l'Aube Écarlate",
    "Sentinelles de la Veille Tempétueuse",
    "Gardiens Radieux",
    "Veilleurs Lunaires",
    "Milice du Coup d'Embrasement",
    "Protecteurs de la Lame Tonnerre",
    "Gardiens du Manteau Étoilé",
    "Vigilants du Crête d'Argent",
    "Fraternité de l'Égide",
    "Éclipse des Boucliers",
    "Division Marteau Céleste",
    "Milice Feu Phénix",
    "Corps de l'Aurore Éclatante",
    "Vanguard Flamme Ébène",
    "Gardiens Célestes",
    "Veilleurs d'Obsidienne",
    "Sentinelles Azurées",
    "Chevaliers de Sable",
    "Protecteurs du Bois d'Épine",
    "Militants du Crépuscule Sombre",
    "Gardiens Mystiques",
    "Milice Griffe Écarlate",
    "Bataillon de l'Aube Dorée",
    "Défenseurs de l'Ombre Frappante",
    "Garde Forgée par le Feu",
    "Milice Enlacement Hivernal",
    "Sentinelles Lame du Vent",
    "Gardiens d'Écorce de Fer",
    "Protecteurs du Vortex",
    "Légion Chute de Givre",
    "Milice Cœur de Flamme",
    "Guilde des Murailles",
    "Confrérie de l'Ombre Funeste",
    "Gardiens Astraux",
    "Militants de la Garde Tempétueuse",
    "Sentinelles de Lame Runique",
    "Défenseurs de Gelure",
    "Vanguard d'Écailles Noires",
    "Gardiens de l'Aube Éternelle",
    "Veille du Clair de Lune Ombré",
    "Milice Feu Sanglant",
    "Bataillon Forgeétoile",
    "Gardiens Sylvains",
    "Protecteurs du Tonnerre Frappant"
}

HUDA_militia_bios = {
    [1] = "<name>, born in a remote village in Grand Chien, emerged as a charismatic leader within the local militia. With a reputation for strategic brilliance, <name> rallied disenfranchised youth to defend their land against foreign interests. <name>'s fearless determination and tactical acumen transformed him into a symbol of resistance, inspiring hope in the hearts of many.",
    [2] = "<name>, a Grand Chien native, swiftly rose through the militia's ranks due to his exceptional marksmanship and unyielding resolve. With a tragic personal history tied to foreign exploitation, <name> became the voice of marginalized women within the movement. <name>'s strategic thinking and unbreakable spirit made him a revered figure, challenging gender norms and fighting for a brighter future.",
    [3] = "<name>, hailing from a long line of farmers, transformed into a skilled guerilla fighter, driven by his love for his homeland. <name>'s knowledge of the terrain and resourcefulness proved indispensable, earning <him> the nickname 'The Shadow of Grand Chien.' <name>'s unwavering loyalty to his fellow fighters and his ability to outwit superior forces made him a legendary figure in the militia's history.",
    [4] = "<name>, a former miner in Grand Chien's diamond mines, joined the militia after witnessing the devastating impact of resource exploitation on his community. <name>'s experiences underground have lent <him> a unique advantage in navigating the complex network of tunnels that crisscross the region, making <him> an invaluable asset in the fight for justice.",
    [5] = "<name>, once a feared enforcer for The Legion, turned his allegiance to the militia after seeing the brutality of the regime <he> had served. Now, his insider knowledge of The Legion's tactics and hideouts proves essential in the ongoing struggle to liberate Grand Chien from their grip.",
    [6] = "<name>, a skilled negotiator and former farmer, plays a key role in establishing alliances between different militia factions. <name>'s ability to bridge divides and unite disparate groups has been instrumental in building a formidable resistance against The Legion's tyranny.",
    [7] = "<name>, an expert tracker and former hunter, provides vital reconnaissance for the militia. <name>'s intimate knowledge of Grand Chien's forests and wildlife enables <him> to guide the resistance through treacherous terrains while remaining one step ahead of the enemy.",
    [8] = "<name>, a charismatic storyteller and former artist, uses his talents to rally morale among the militia members. <name>'s compelling narratives of Grand Chien's rich history and the struggle for freedom inspire hope and unity in the face of adversity.",
    [9] = "<name>, a former doctor who treated the wounded during The Legion's reign, now applies his medical skills to mend the injuries sustained in battle. <name>'s compassion and dedication to healing have earned <him> the respect and gratitude of the entire militia.",
    [10] = "<name>, a Grand Chien engineer with a knack for improvisation, constructs ingenious traps and devices to thwart The Legion's advances. <name>'s ability to turn everyday objects into formidable weapons has saved countless lives on the battlefield.",
    [11] = "<name>, a former schoolteacher, educates the next generation of militia members, passing down knowledge and instilling values of justice and equality. <name>'s commitment to nurturing both minds and spirits shapes the future of Grand Chien's resistance.",
    [12] = "<name>, a master of disguise and former actor, infiltrates enemy strongholds to gather critical intelligence. <name>'s ability to blend in seamlessly and gather information unnoticed is a crucial asset in the fight against The Legion.",
    [13] = "<name>, a Grand Chien chef known for his culinary creativity, boosts morale by preparing hearty meals for the militia. <name>'s delicious dishes provide not only sustenance but also a taste of normalcy amidst the chaos of conflict.",
    [14] = "<name>, a former journalist, wields the power of words to expose The Legion's atrocities to the world. <name>'s poignant articles and broadcasts shed light on the horrors faced by Grand Chien's people, rallying international support for the resistance.",
    [15] = "<name>, born in a remote village in Grand Chien, emerged as a charismatic leader within the local militia. With a reputation for strategic brilliance, <name> rallied disenfranchised youth to defend their land against foreign interests. <name>'s fearless determination and tactical acumen transformed him into a symbol of resistance, inspiring hope in the hearts of many.",
    [16] = "<name>, a Grand Chien native, swiftly rose through the militia's ranks due to his exceptional marksmanship and unyielding resolve. With a tragic personal history tied to foreign exploitation, <name> became the voice of marginalized women within the movement. <name>'s strategic thinking and unbreakable spirit made him a revered figure, challenging gender norms and fighting for a brighter future.",
    [17] = "<name>, hailing from a long line of farmers, transformed into a skilled guerilla fighter, driven by his love for his homeland. <name>'s knowledge of the terrain and resourcefulness proved indispensable, earning <him> the nickname 'The Shadow of Grand Chien.' <name>'s unwavering loyalty to his fellow fighters and his ability to outwit superior forces made him a legendary figure in the militia's history.",
    [18] = "<name>, a former miner in Grand Chien's diamond mines, joined the militia after witnessing the devastating impact of resource exploitation on his community. <name>'s experiences underground have lent <him> a unique advantage in navigating the complex network of tunnels that crisscross the region, making <him> an invaluable asset in the fight for justice.",
    [19] = "<name>, once a feared enforcer for The Legion, turned his allegiance to the militia after seeing the brutality of the regime <he> had served. Now, his insider knowledge of The Legion's tactics and hideouts proves essential in the ongoing struggle to liberate Grand Chien from their grip.",
    [20] = "<name>, a skilled negotiator and former farmer, plays a key role in establishing alliances between different militia factions. <name>'s ability to bridge divides and unite disparate groups has been instrumental in building a formidable resistance against The Legion's tyranny.",
    [21] = "<name>, a young mother of two, joined the militia after her husband was killed by The Legion. She is a skilled sniper and has taken down many of The Legion's soldiers. She is also a fierce advocate for women's rights and is fighting for a better future for her children.",
    [22] = "<name>, a former teacher, is now a medic in the militia. He is known for his calm and compassionate demeanor, even in the most chaotic situations. He has saved the lives of many militia members, and his courage and dedication are an inspiration to all.",
    [23] = "<name>, a young man from a poor village, is a natural leader. He is brave and resourceful, and he is always willing to put himself in danger to help others. He is a rising star in the militia, and he is destined to play a major role in the fight for freedom.",
    [24] = "<name>, a former engineer, is now a weapons expert for the militia. He is brilliant and innovative, and he has designed many of the militia's most effective weapons. He is a valuable asset to the resistance, and his work is helping to turn the tide of the war.",
    [25] = "<name>, a former athlete, is now a member of the militia's special forces unit. He is fast and agile, and he is an expert in hand-to-hand combat. He is also a skilled tactician, and he has led many successful missions against The Legion.",
    [26] = "<name>, a former lawyer, is now the militia's legal advisor. She is brilliant and persuasive, and she is using her skills to fight for the rights of the people of Grand Chien. She is a tireless advocate for justice, and she is helping to build a better future for her country.",
    [27] = "<name>, hailing from the outskirts of Grand Chien, joined the militia as a demolitions expert. With an innate ability to turn ordinary items into potent tools of destruction, <name> quickly became an indispensable asset. his dedication to liberating the nation from The Legion's grip, coupled with his ingenious tactics, strikes fear into the hearts of his adversaries.",
    [28] = "<name>, a former farmer turned militia fighter, brings unwavering loyalty and raw strength to the cause. Overcoming personal tragedy at the hands of The Legion, <name> emerged from the ashes with a burning desire for justice. his steadfast resolve and ability to inspire others have united the militia under a common goal, rekindling a sense of unity in the fractured nation.",
    [29] = "<name>, an enigmatic figure shrouded in mystery, is the militia's master of espionage and subterfuge. Trained in the shadowy arts of infiltration, <name> can seamlessly blend into any environment and gather crucial intelligence. his motives remain a well-guarded secret, but his results on the battlefield speak volumes about his unwavering dedication to the cause.",
    [30] = "<name>, a former blacksmith with arms as strong as his will, forges the backbone of the militia. With every strike of his hammer, <name> shapes the destiny of Grand Chien, crafting weapons of resistance and determination. his unwavering dedication to the cause ensures that every fighter is equipped to face the darkness that looms over the nation.",
    [31] = "<name>, a nomadic healer with a deep connection to the land, channels his mystical powers into the militia's ranks. his ability to mend wounds and cure ailments turns the tide of battle, and his presence offers a glimmer of hope amidst the chaos. <name>'s soothing words and ethereal touch rekindle the spirits of those who fight for a better future.",
    [32] = "<name>, a former journalist, uses his words as weapons against The Legion's propaganda. Armed with a pen and a burning desire for truth, <name> exposes the atrocities committed by the oppressors and ignites a spark of rebellion in the hearts of the people. Through his writings, <name> reveals the untold stories of the oppressed, inspiring others to rise and join the fight.",
    [33] = "<name>, a Grand Chien native who once navigated treacherous waters as a fisherman, now steers the militia with the same unwavering determination. his leadership on the battlefield is as steady as the ocean's tide, and his ability to adapt to the ever-changing currents of war ensures that the militia is always one step ahead of their enemies.",
    [34] = "<name>, a former circus performer, brings a flair for the dramatic to the militia. Through acrobatics and daring feats, <he/she> evokes a sense of awe and inspiration among comrades and enemies alike. his boundless energy and infectious laughter uplift spirits and remind all who fight that even in the darkest times, there is room for joy and camaraderie.",
    [35] = "<name>, a Grand Chien scholar well-versed in ancient mysticism, employs his knowledge to harness the power of the elements. With a wave of his hand, <name> conjures storms and blazes that strike fear into the hearts of The Legion. his command over nature itself lends an otherworldly edge to the militia's arsenal, turning the very forces of the universe against their oppressors.",
    [36] = "<name>, once a celebrated musician, now uses his melodies to inspire courage and unity among the militia. Armed with a guitar and a voice that carries the hopes of a nation, <name>'s music serves as a rallying cry for those who yearn for freedom. his songs echo through the battlefield, fueling the fighters' spirits as they face impossible odds.",
    [37] = "<name>, a former scholar of ancient martial arts, channels his mastery into the militia's ranks. With every strike and every move, <name> embodies the teachings of generations past, turning his body into a weapon of precise destruction. his disciplined approach to combat and his quest for inner harmony inspire others to find strength in body and spirit.",
    [38] = "<name>, a charismatic storyteller and puppeteer, uses his talents to educate and inspire the masses. Through vivid tales of heroism and sacrifice, <name> captures the hearts of listeners, reminding them of the noble history they fight to preserve. his performances ignite a fire in the souls of those who hear them, uniting the militia with a shared sense of purpose.",
    [39] = "<name>, a former teacher with a passion for knowledge, guides the militia with wisdom and insight. his strategic thinking and analytical mind offer a calculated approach to each battle, ensuring that every move is a step closer to victory. <name>'s unwavering belief in the potential of Grand Chien fuels his determination to lead his comrades to a brighter future.",
    [40] = "<name>, a former chef, now uses his culinary skills to nourish the militia. his ability to turn simple ingredients into delicious meals boosts the morale of the fighters, and his knack for improvisation ensures that no one goes hungry. <name>'s cooking is a reminder that even in the darkest times, there is always room for joy and celebration.",
    [41] = "<name>, a former athlete, is now a member of the militia's special forces unit. He is fast and agile, and he is an expert in hand-to-hand combat. He is also a skilled tactician, and he has led many successful missions against The Legion.",
    [42] = "<name>, a former lawyer, is now the militia's legal advisor. She is brilliant and persuasive, and she is using her skills to fight for the rights of the people of Grand Chien. She is a tireless advocate for justice, and she is helping to build a better future for her country.",
    [43] = "<name>, hailing from the outskirts of Grand Chien, joined the militia as a demolitions expert. With an innate ability to turn ordinary items into potent tools of destruction, <name> quickly became an indispensable asset. his dedication to liberating the nation from The Legion's grip, coupled with his ingenious tactics, strikes fear into the hearts of his adversaries.",
    [44] = "<name>, a former farmer turned militia fighter, brings unwavering loyalty and raw strength to the cause. Overcoming personal tragedy at the hands of The Legion, <name> emerged from the ashes with a burning desire for justice. his steadfast resolve and ability to inspire others have united the militia under a common goal, rekindling a sense of unity in the fractured nation.",
    [45] = "<name>, an enigmatic figure shrouded in mystery, is the militia's master of espionage and subterfuge. Trained in the shadowy arts of infiltration, <name> can seamlessly blend into any environment and gather crucial intelligence. his motives remain a well-guarded secret, but his results on the battlefield speak volumes about his unwavering dedication to the cause.",
    [46] = "<name>, a former veteran, is the militia's commander. With his military experience and strategic mind, <name> leads the fight against The Legion. his unwavering dedication to the cause inspires others to follow <him/her>, and his presence on the battlefield instills hope in the hearts of the people.",
    [47] = "<name>, a former nurse, is the militia's medic. his knowledge of medicine and herbs is crucial to the militia's success, and his ability to heal wounds and cure ailments keeps the fighters in top condition. <name> is a beacon of hope for those who fight, and his compassion and empathy remind all that the cause is worth fighting for.",
    [48] = "<name>, a former engineer, is the militia's mechanic. his technical expertise and mechanical know-how are essential to the militia's survival, and his ability to repair and maintain equipment ensures that the fighters are always ready for battle. <name>'s unwavering dedication to the cause inspires others to follow <him/her>, and his presence on the battlefield instills hope in the hearts of the people.",
    [49] = "<name>, a former miner, is the militia's miner. his knowledge of the land and its resources is crucial to the militia's survival, and his ability to extract minerals and ores keeps the fighters well-equipped. <name> is a beacon of hope for those who fight, and his strength and determination remind all that the cause is worth fighting for.",
    [50] = "<name>, a former farmer, is the militia's farmer. his knowledge of the land and its resources is crucial to the militia's survival, and his ability to grow crops keeps the fighters well-fed. <name> is a beacon of hope for those who fight, and his strength and determination remind all that the cause is worth fighting for.",
}
