GameVar("HUDA_MilitiaSquadNames", {})
GameVar("HUDA_MilitiaBios", {})

function HUDA_GetAvailableBios(speciality)
    
    if not HUDA_MilitiaBios then
        return {}
    end

    if not HUDA_ArrayContains({ "Doctor", "ExplosiveExpert", "Mechanic", "Marksmen", "Leader" }, speciality) then
        speciality = "AllRounder"
    end

    if not HUDA_MilitiaBios[speciality] or #HUDA_MilitiaBios[speciality] < 1 then
        HUDA_MilitiaBios[speciality] = HUDA_militia_bios_pool[speciality]
    end

    return HUDA_MilitiaBios[speciality]
end

function HUDA_SetAvailableBios(speciality, bios)
    if not HUDA_MilitiaBios then
        return
    end

    if not HUDA_ArrayContains({ "Doctor", "ExplosiveExpert", "Mechanic", "Marksmen", "Leader" }, speciality) then
        speciality = "AllRounder"
    end

    HUDA_MilitiaBios[speciality] = HUDA_ReindexTable(bios)
end

function HUDA_GetAvailableSquadNames()
    if not HUDA_MilitiaSquadNames then
        return {}
    end

    if not HUDA_MilitiaSquadNames or #HUDA_MilitiaSquadNames < 1 then
        HUDA_MilitiaSquadNames = HUDA_militia_squad_names_pool
    end

    return HUDA_MilitiaSquadNames
end

function HUDA_SetAvailableSquadNames(squad_names)
    if not HUDA_MilitiaSquadNames then
        return
    end

    HUDA_MilitiaSquadNames = HUDA_ReindexTable(squad_names)
end

HUDA_militia_bios_pool = {
    Leader = {
        "<name>, born in a remote village in Grand Chien, emerged as a charismatic leader within the local militia. With a reputation for strategic brilliance, <name> rallied disenfranchised youth to defend their land against foreign interests. <name>'s fearless determination and tactical acumen transformed him into a symbol of resistance, inspiring hope in the hearts of many.",
        "<name>, a skilled negotiator and former farmer, plays a key role in establishing alliances between different militia factions. <name>'s ability to bridge divides and unite disparate groups has been instrumental in building a formidable resistance against The Legion's tyranny.",
        "<name>, a charismatic storyteller and former artist, uses his talents to rally morale among the militia members. <name>'s compelling narratives of Grand Chien's rich history and the struggle for freedom inspire hope and unity in the face of adversity.",
        "<name>, a former schoolteacher, educates the next generation of militia members, passing down knowledge and instilling values of justice and equality. <name>'s commitment to nurturing both minds and spirits shapes the future of Grand Chien's resistance.",
        "<name>, a young man from a poor village, is a natural leader. He is brave and resourceful, and he is always willing to put himself in danger to help others. He is a rising star in the militia, and he is destined to play a major role in the fight for freedom.",
        "<name>, a former lawyer, is now the militia's legal advisor. She is brilliant and persuasive, and she is using her skills to fight for the rights of the people of Grand Chien. She is a tireless advocate for justice, and she is helping to build a better future for her country.",
        "<name>, a Grand Chien native who once navigated treacherous waters as a fisherman, now steers the militia with the same unwavering determination. his leadership on the battlefield is as steady as the ocean's tide, and his ability to adapt to the ever-changing currents of war ensures that the militia is always one step ahead of their enemies.",
        "<name>, once a celebrated musician, now uses his melodies to inspire courage and unity among the militia. Armed with a guitar and a voice that carries the hopes of a nation, <name>'s music serves as a rallying cry for those who yearn for freedom. his songs echo through the battlefield, fueling the fighters' spirits as they face impossible odds.",
        "<name>, a former teacher with a passion for knowledge, guides the militia with wisdom and insight. his strategic thinking and analytical mind offer a calculated approach to each battle, ensuring that every move is a step closer to victory. <name>'s unwavering belief in the potential of Grand Chien fuels his determination to lead his comrades to a brighter future.",
        "<name>, a former veteran, is the militia's commander. With his military experience and strategic mind, <name> leads the fight against The Legion. his unwavering dedication to the cause inspires others to follow <him/her>, and his presence on the battlefield instills hope in the hearts of the people.",
        "<name>, a former schoolteacher driven by a hunger for justice, became a strategist for the militia. Miguel's keen intellect and ability to anticipate enemy movements earned him the name 'The Oracle.' Miguel's guidance turns the tide of battle, proving that knowledge can be as powerful as any weapon."
    },
    Marksmen = {
        "<name>, a Grand Chien native, swiftly rose through the militia's ranks due to his exceptional marksmanship and unyielding resolve. With a tragic personal history tied to foreign exploitation, <name> became the voice of marginalized women within the movement. <name>'s strategic thinking and unbreakable spirit made him a revered figure, challenging gender norms and fighting for a brighter future.",
        "<name>, a seasoned hunter and survivalist, found his purpose within the militia after witnessing the devastating impact of The Legion's tyranny. His remarkable skill with a sniper rifle and deep knowledge of wilderness tactics make him an indispensable asset. <name>'s determination to protect his homeland and his uncanny ability to blend into the environment strike fear into the hearts of The Legion's adversaries.",
        "<name>, an expert tracker and former hunter, provides vital reconnaissance for the militia. <name>'s intimate knowledge of Grand Chien's forests and wildlife enables <him> to guide the resistance through treacherous terrains while remaining one step ahead of the enemy.",
        "<name>, a former competitive sharpshooter, brings unwavering precision to the militia's ranks. <name>'s unmatched accuracy turns every shot into a display of deadly artistry. In the face of adversity, <he> remains a stoic and silent force, instilling both fear and respect in the hearts of The Legion's forces.",
        "<name>, a disillusioned former police officer, now utilizes <his> sharpshooting skills to fight for justice in Grand Chien. Fed up with The Legion's reign of terror, <name> is determined to make every bullet count, taking down high-value targets and chipping away at the enemy's power.",
        "<name>, a nomadic hunter with a profound connection to the land, has honed <his> sniper skills over years of tracking elusive prey. <name>'s patience and deep understanding of the environment make <him> an invaluable asset, capable of turning even the most remote vantage point into a deadly nest for precision strikes.",
    },
    ExplosiveExpert = {
        "<name>, hailing from the outskirts of Grand Chien, joined the militia as a demolitions expert. With an innate ability to turn ordinary items into potent tools of destruction, <name> quickly became an indispensable asset. his dedication to liberating the nation from The Legion's grip, coupled with his ingenious tactics, strikes fear into the hearts of his adversaries.",
        "<name>, a Grand Chien chef known for his culinary creativity, boosts morale by preparing hearty meals for the militia. <name>'s delicious dishes provide not only sustenance but also a taste of normalcy amidst the chaos of conflict.",
        "<name>, a former miner from the rugged mountains, found his true calling as a demolitions expert in the militia. His intimate knowledge of explosives and underground terrain makes him an invaluable asset. <name>'s determination to reclaim his homeland from The Legion's grasp drives him to craft intricate strategies that exploit the enemy's weaknesses.",
        "<name>, once a renowned architect in the bustling cities, now channels his expertise into undermining The Legion's strongholds. As a demolitions specialist, <name> uses his understanding of structural integrity to collapse enemy defenses with surgical precision. His transformation from building creator to demolisher of tyranny is a testament to his unwavering commitment to the cause.",
        "<name>, hailing from a long line of engineers, grew up surrounded by blueprints and tools. With a natural talent for understanding the inner workings of machinery, <name> has become the go-to person for disarming and repurposing enemy traps. The militia's reliance on <name>'s technical prowess has turned the tide of numerous battles against The Legion.",
        "<name>, a former miner and geologist, brings a scientific approach to the art of destruction. Utilizing his knowledge of rock formations and seismic activity, <name> creates controlled earthquakes that disrupt The Legion's operations. His unconventional methods and unyielding loyalty make him a force to be reckoned with on the battlefield.",
    },
    Mechanic = {
        "<name>, a Grand Chien engineer with a knack for improvisation, constructs ingenious traps and devices to thwart The Legion's advances. <name>'s ability to turn everyday objects into formidable weapons has saved countless lives on the battlefield.",
        "<name>, a former engineer, is now a weapons expert for the militia. He is brilliant and innovative, and he has designed many of the militia's most effective weapons. He is a valuable asset to the resistance, and his work is helping to turn the tide of the war.",
        "<name>, a former engineer, is the militia's mechanic. His technical expertise and mechanical know-how are essential to the militia's survival, and his ability to repair and maintain equipment ensures that the fighters are always ready for battle. <name>'s unwavering dedication to the cause inspires others to follow him, and his presence on the battlefield instills hope in the hearts of the people.",
        "<name>, a former blacksmith with arms as strong as his will, forges the backbone of the militia. With every strike of his hammer, <name> shapes the destiny of Grand Chien, crafting weapons of resistance and determination. His unwavering dedication to the cause ensures that every fighter is equipped to face the darkness that looms over the nation.",
        "<name>, an inventive tinkerer, uses <his/her> engineering skills to create innovative gadgets that give the militia an edge in battle. Whether it's a makeshift explosive or a clever diversion device, <name>'s contributions often mean the difference between victory and defeat. <His/Her> resourcefulness and dedication to the cause have earned <him/her> the respect of the entire resistance.",
        "<name>, a former aerospace engineer, brings a high level of technical expertise to the militia. <His/Her> understanding of complex systems and mechanics has been instrumental in repurposing salvaged technology against The Legion. <name>'s meticulous attention to detail and strategic thinking make <him/her> an indispensable asset in the fight for freedom.",
        "<name>, a skilled mechanic before the upheaval, became the go-to person for keeping the militia's vehicles and weapons operational. Eduardo's resourcefulness and knack for improvisation earned him the nickname 'Wrench,' as he tirelessly keeps the engines of resistance running amidst the chaos.",
        "<name>, an engineer with a knack for explosives, became the militia's demolitions expert. Ricardo's technical prowess and ability to turn scraps into deadly tools earned him the name 'Pyro.' His calculated blasts disrupt enemy plans and clear the path for the militia's advance.",
    },
    Doctor = {
        "<name>, a former doctor who treated the wounded during The Legion's reign, now applies his medical skills to mend the injuries sustained in battle. <name>'s compassion and dedication to healing have earned <him> the respect and gratitude of the entire militia.",
        "<name>, a former teacher, is now a medic in the militia. He is known for his calm and compassionate demeanor, even in the most chaotic situations. He has saved the lives of many militia members, and his courage and dedication are an inspiration to all.",
        "<name>, a nomadic healer with a deep connection to the land, channels his mystical powers into the militia's ranks. His ability to mend wounds and cure ailments turns the tide of battle, and his presence offers a glimmer of hope amidst the chaos. <name>'s soothing words and ethereal touch rekindle the spirits of those who fight for a better future.",
        "<name>, a former nurse, is the militia's medic. His knowledge of medicine and herbs is crucial to the militia's success, and his ability to heal wounds and cure ailments keeps the fighters in top condition. <name> is a beacon of hope for those who fight, and his compassion and empathy remind all that the cause is worth fighting for.",
        "<name>, a field medic with a background in emergency medicine, plays a critical role in stabilizing injured militia members on the battlefield. <name>'s quick thinking and resourcefulness ensure that wounded fighters have a chance to return to the frontlines. His unwavering commitment to the cause and his fellow comrades make him a pillar of strength within the militia.",
        "<name>, a former veterinarian, has seamlessly transitioned his skills to aid the militia. His deep understanding of anatomy and healing extends beyond species, and he treats wounded fighters with the same care and precision he once used for animals. <name>'s unique perspective brings an innovative approach to medical care on the battlefield.",
        "<name>, a former nurse with a heart of gold, turned his healing skills into a vital asset for the militia. His medical expertise saved countless lives on and off the battlefield, earning him the moniker 'Guardian of Grand Chien.' Despite the chaos, Carlos's compassion remains unshaken, inspiring those around him to keep fighting for a better future."
    },
    AllRounder = {
        "<name>, hailing from a long line of farmers, transformed into a skilled guerilla fighter, driven by his love for his homeland. <name>'s knowledge of the terrain and resourcefulness proved indispensable, earning <him> the nickname 'The Shadow of Grand Chien.' <name>'s unwavering loyalty to his fellow fighters and his ability to outwit superior forces made him a legendary figure in the militia's history.",
        "<name>, a former miner in Grand Chien's diamond mines, joined the militia after witnessing the devastating impact of resource exploitation on his community. <name>'s experiences underground have lent <him> a unique advantage in navigating the complex network of tunnels that crisscross the region, making <him> an invaluable asset in the fight for justice.",
        "<name>, once a feared enforcer for The Legion, turned his allegiance to the militia after seeing the brutality of the regime he had served. Now, his insider knowledge of The Legion's tactics and hideouts proves essential in the ongoing struggle to liberate Grand Chien from their grip.",
        "<name>, a charismatic storyteller and former artist, uses his talents to rally morale among the militia members. <name>'s compelling narratives of Grand Chien's rich history and the struggle for freedom inspire hope and unity in the face of adversity.",
        "<name>, a master of disguise and former actor, infiltrates enemy strongholds to gather critical intelligence. <name>'s ability to blend in seamlessly and gather information unnoticed is a crucial asset in the fight against The Legion.",
        "<name>, a former journalist, wields the power of words to expose The Legion's atrocities to the world. <name>'s poignant articles and broadcasts shed light on the horrors faced by Grand Chien's people, rallying international support for the resistance.",
        "<name>, hailing from a long line of farmers, transformed into a skilled guerilla fighter, driven by his love for his homeland. <name>'s knowledge of the terrain and resourcefulness proved indispensable, earning <him> the nickname 'The Shadow of Grand Chien.' <name>'s unwavering loyalty to his fellow fighters and his ability to outwit superior forces made him a legendary figure in the militia's history.",
        "<name>, a former athlete, is now a member of the militia's special forces unit. He is fast and agile, and he is an expert in hand-to-hand combat. He is also a skilled tactician, and he has led many successful missions against The Legion.",
        "<name>, hailing from the outskirts of Grand Chien, joined the militia as a demolitions expert. With an innate ability to turn ordinary items into potent tools of destruction, <name> quickly became an indispensable asset. his dedication to liberating the nation from The Legion's grip, coupled with his ingenious tactics, strikes fear into the hearts of his adversaries.",
        "<name>, a former farmer turned militia fighter, brings unwavering loyalty and raw strength to the cause. Overcoming personal tragedy at the hands of The Legion, <name> emerged from the ashes with a burning desire for justice. his steadfast resolve and ability to inspire others have united the militia under a common goal, rekindling a sense of unity in the fractured nation.",
        "<name>, an enigmatic figure shrouded in mystery, is the militia's master of espionage and subterfuge. Trained in the shadowy arts of infiltration, <name> can seamlessly blend into any environment and gather crucial intelligence. his motives remain a well-guarded secret, but his results on the battlefield speak volumes about his unwavering dedication to the cause.",
        "<name>, a former journalist, uses his words as weapons against The Legion's propaganda. Armed with a pen and a burning desire for truth, <name> exposes the atrocities committed by the oppressors and ignites a spark of rebellion in the hearts of the people. Through his writings, <name> reveals the untold stories of the oppressed, inspiring others to rise and join the fight.",
        "<name>, a former circus performer, brings a flair for the dramatic to the militia. Through acrobatics and daring feats, he evokes a sense of awe and inspiration among comrades and enemies alike. his boundless energy and infectious laughter uplift spirits and remind all who fight that even in the darkest times, there is room for joy and camaraderie.",
        "<name>, a Grand Chien scholar well-versed in ancient mysticism, employs his knowledge to harness the power of the elements. With a wave of his hand, <name> conjures storms and blazes that strike fear into the hearts of The Legion. his command over nature itself lends an otherworldly edge to the militia's arsenal, turning the very forces of the universe against their oppressors.",
        "<name>, a former scholar of ancient martial arts, channels his mastery into the militia's ranks. With every strike and every move, <name> embodies the teachings of generations past, turning his body into a weapon of precise destruction. his disciplined approach to combat and his quest for inner harmony inspire others to find strength in body and spirit.",
        "<name>, a charismatic storyteller and puppeteer, uses his talents to educate and inspire the masses. Through vivid tales of heroism and sacrifice, <name> captures the hearts of listeners, reminding them of the noble history they fight to preserve. his performances ignite a fire in the souls of those who hear them, uniting the militia with a shared sense of purpose.",
        "<name>, a former chef, now uses his culinary skills to nourish the militia. his ability to turn simple ingredients into delicious meals boosts the morale of the fighters, and his knack for improvisation ensures that no one goes hungry. <name>'s cooking is a reminder that even in the darkest times, there is always room for joy and celebration.",
        "<name>, a former athlete, is now a member of the militia's special forces unit. He is fast and agile, and he is an expert in hand-to-hand combat. He is also a skilled tactician, and he has led many successful missions against The Legion.",
        "<name>, a defector from a rival paramilitary group, joined the militia seeking redemption. His combat experience and survival skills gained him the title 'Steel Viper.' Alejandro's past fuels his determination to right his wrongs and bring stability back to his homeland.",
        "<name>, a charismatic performer in pre-chaos times, uses his gift of persuasion to rally the militia. Known as 'Maestro,' Javier boosts morale and fosters unity among the fighters with his impassioned speeches and unwavering optimism.",
        "<name>, a former journalist, wields the power of information as the militia's intel officer. Known as 'Whisper,' Dmitri's ability to uncover secrets and expose enemy weaknesses provides the militia with a critical advantage in their fight against The Legion.",
        "<name>, a wildlife tracker and environmentalist, uses his knowledge of nature to outmaneuver enemies. His reputation as 'The Phantom Lynx' stems from his ability to move silently and strike with precision, embodying the spirit of Grand Chien's untamed wilderness.",
        "<name>, a skilled diplomat before the crisis, now negotiates for alliances and resources on behalf of the militia. His talent for finding common ground among diverse groups earned him the nickname 'The Bridge,' uniting factions under the banner of a free Grand Chien.",
        "<name>, a former police officer disillusioned by corruption, enforces justice as the militia's enigmatic enforcer. Known as 'Judge,' Ivan's imposing presence and unyielding principles make him a symbol of retribution against those who exploit the chaos for personal gain."
    }
}

HUDA_militia_squad_names_pool = {
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
    "Garde d'élite du Modding Discord",
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

HUDA_male_militia_names = {
    "Amadou", "Jean-Baptiste", "Feanor", "Issa", "Kofi", "Léon", "Malik", "Sékou", "Alassane", "Aboubakar", "Yves",
    "Mamadou", "Ousmane", "Claude", "Idriss", "Modibo", "Samba", "Félix", "Aliou", "Youssef", "Souleymane",
    "Adama", "Victor", "Moussa", "Jacques", "Doudou", "Ahmed", "Pierre", "Emmanuel", "Olivier", "Charles",
    "Amadou", "Yannick", "Prosper", "Marcel", "Antoine", "François", "Bertrand", "Didier", "Gilbert", "Hervé",
    "Blaise", "Thierry", "Serge", "Sébastien", "Lionel", "Raoul", "Raymond", "Aimé", "Aymar", "Boris",
    "Constantin", "Anarkythera", "David", "Elie", "Fabrice", "Gérard", "Hector", "Isaac", "Jérôme", "Kévin",
    "Laurent", "Mathieu", "Noël", "Octave", "Pascal", "Quentin", "Romain", "Samuel", "Théodore", "Ulysse", "Vincent",
    "William", "Xavier", "Yann", "Archimedes", "Zéphyr", "Ange", "Huda", "Tobias", "Basile", "Cyprien", "Désiré",
    "Édouard", "Firmin", "Gaston", "Hector", "Irénée", "Jules", "Kilian", "Lambert", "Médard", "Napoléon",
    "Onésime", "Parfait", "Quirin", "Raphaël", "Siméon", "Théophile", "Ulrich", "Victorien", "Wilfried", "Xénophon",
    "Yvon", "Zéphirin", "Abdoulaye", "Bakary", "Cheikh", "Djibril", "Issouf", "Karim", "Kira", "Lamine", "Mouhamed",
    "Ndiaye", "Oumar", "Sadio", "Tidiane", "Adnan", "Bilal", "Cem", "Emin", "Farouk", "Ghazi", "Hamza", "Ibrahim",
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
    "Xola", "Yared", "Zewdu", "Chapi"
}
