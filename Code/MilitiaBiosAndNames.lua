GameVar("HUDA_MilitiaSquadNames", {})
GameVar("HUDA_MilitiaBios", {})



function HUDA_GetAvailableBios(archetype)
    if not HUDA_MilitiaBios then
        return {}
    end

    if not HUDA_ArrayContains(HUDA_TableKeys(HUDA_militia_bios_pool), archetype) then
        archetype = "Worker"
    end

    if not HUDA_MilitiaBios[archetype] or #HUDA_MilitiaBios[archetype] < 1 then
        HUDA_MilitiaBios[archetype] = HUDA_militia_bios_pool[archetype]
    end

    return HUDA_MilitiaBios[archetype]
end

function HUDA_SetAvailableBios(archetype, bios)
    if not HUDA_MilitiaBios then
        return
    end

    if not HUDA_ArrayContains(HUDA_TableKeys(HUDA_militia_bios_pool), archetype) then
        archetype = "Worker"
    end

    HUDA_MilitiaBios[archetype] = HUDA_ReindexTable(bios)
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
    Doctor = {
        "<name>, a skilled trauma surgeon accustomed to the urgency of the operating room in <city>, recognized the need to extend medical expertise beyond hospital walls. Fueled by a commitment to saving lives in unconventional settings, <name> has chosen to join the militia.",
        "<name>, a compassionate pediatrician who once cared for the youngest residents of <city>, believes in nurturing the well-being of communities. Driven by a commitment to protect the most vulnerable, <name> has decided to join the militia.",
        "<name>, an infectious disease specialist with expertise in combating epidemics in <city>, recognized the importance of proactive measures in times of crisis. Fueled by a commitment to prevent and manage diseases at their source, <name> has chosen to join the militia.",
        "<name>, a respected general practitioner known for being the first line of defense in <city>'s health care system, understands the holistic needs of a community. Driven by a commitment to provide comprehensive care, <name> has decided to join the militia.",
        "<name>, an emergency medicine physician accustomed to handling critical cases in <city>'s hospitals, recognized the importance of swift responses in times of crisis. Fueled by a commitment to immediate action and triage, <name> has chosen to join the militia.",
        "<name>, a doctor who dedicated their career to providing healthcare in rural areas surrounding <city>, understands the unique challenges faced by underserved communities. Fueled by a commitment to address healthcare disparities, <name> has chosen to join the militia.",
        "<name>, a dedicated medical researcher whose studies contributed to advancements in <city>'s healthcare, recognizes the importance of research in finding solutions. Driven by a commitment to apply scientific knowledge for societal benefit, <name> has decided to join the militia.",
        "<name>, a dedicated general practitioner serving the diverse healthcare needs of <city>, understands the importance of primary care in community well-being. Fueled by a commitment to provide comprehensive medical support, <name> has chosen to join the militia.",
        "<name>, an empathetic family doctor who has been a pillar of health in the urban setting of <city>, believes in the continuity of care for families. Driven by a commitment to offer holistic healthcare services, <name> has decided to join the militia.",
        "<name>, a committed primary care physician addressing the diverse health concerns of the metropolitan population in <city>, recognizes the pivotal role of general medicine. Fueled by a commitment to be the first line of defense in times of crisis, <name> has chosen to join the militia.",
        "<name>, a trusted physician managing the daily health challenges at a bustling clinic in <city>, believes in the accessibility of healthcare for all. Driven by a commitment to offer immediate medical assistance, <name> has decided to join the militia.",
        "<name>, a compassionate healthcare provider catering to the medical needs of the urban community in <city>, understands the importance of prompt medical attention. Fueled by a commitment to be a healthcare anchor in times of uncertainty, <name> has chosen to join the militia.",
        "<name>, a dedicated medical practitioner with a practice deeply rooted in the heart of <city>, believes in the continuity of care for the local residents. Driven by a commitment to provide ongoing health support, <name> has decided to join the militia.",
        "<name>, a committed physician running a health clinic in the metropolitan area of <city>, recognizes the significance of accessible healthcare services. Fueled by a commitment to be a healthcare anchor in times of need, <name> has chosen to join the militia.",
        "<name>, a compassionate general medical practitioner providing essential healthcare services in the urban landscape of <city>, understands the integral role of primary care. Driven by a commitment to address the health concerns of the local population, <name> has decided to join the militia."
    },
    Teacher = {
        "<name>, a former teacher from <city>, traded the classroom for the front lines, driven by a duty to protect. Bringing wisdom and discipline to the militia, <name> uses his strategic mind to navigate battles, instilling camaraderie and resilience among fellow soldiers.",
        "<name>, a compassionate educator from <city>, left the serene halls of academia to confront the harsh realities of Grand Chien's upheaval. Driven by a profound commitment to safeguarding the community, <name> now imparts not only knowledge but also resilience to the militia.",
        "<name>, a caring teacher from <city>, traded the classroom for the front lines, driven by a commitment to safeguard the community. Now part of the militia, <name> inspires resilience, adapting his teaching skills to foster unity and purpose among fellow soldiers in the struggle for a brighter future.",
        "<name>, a nurturing teacher from <city>, exchanged textbooks for battle gear in a quest to protect the people of Grand Chien. Embracing the call to defend, <name> now shares his insightful lessons with fellow militia members, blending intellect with valor on the front lines.",
        "<name>, a caring educator from <city>, shifted from molding minds to defending lives when tragedy struck close to home. Witnessing the suffering of his community during turbulent times, <name> couldn't stand idly by. Fueled by a profound sense of duty, he joined the militia, channeling his teaching skills to nurture resilience and unity.",
        "<name>, a compassionate teacher from <city>, found an unyielding purpose in the face of personal loss. When his own family felt the sting of Grand Chien's turmoil, <name> turned heartbreak into resolve. Driven by a burning desire to prevent others from suffering the same fate, he enlisted in the militia.",
        "<name>, a dedicated teacher from <city>, felt the crushing blow of The Legion when they destroyed his beloved school. Fueled by a burning desire to rebuild and seek justice, <name> joined the militia. Now, amidst the chaos, he turns the remnants of his shattered school into a symbol of resilience, carrying the weight of fallen walls in his heart.",
        "<name>, a nurturing teacher from <city>, couldn't stand idly by when his students' lives were at stake. Witnessing The Legion's encroachment on the safety of the school, <name> joined the militia to become a shield for the youth. Now, he fights not just for a brighter future but to safeguard the innocence that lies within the hearts of the children he once taught.",
        "<name>, a passionate teacher from <city>, was driven into the militia by a personal vendetta. The Legion's ruthless actions claimed the life of a dear colleague. Fueled by grief and a thirst for justice, <name> now channels his sorrow into a relentless pursuit, seeking retribution for the fallen and vowing to make The Legion pay for their crimes.",
        "<name>, a compassionate teacher from <city>, joined the militia to find redemption for a past perceived failure. Haunted by the memory of a student lost to the chaos, <name> seeks to make amends by using his teaching skills to guide the militia. Every battle is a chance to rectify the past and ensure that others don't suffer the same fate.",
        "<name>, a resilient teacher from <city>, became a refugee when The Legion overran his hometown. Determined to reclaim a sense of normalcy, <name> enlisted in the militia. Now, he imparts knowledge and hope to his fellow displaced citizens, carrying the weight of his past while nurturing dreams of a better future within the militia ranks.",
        "<name>, an inspirational teacher from <city>, joined the militia with a vision of being a beacon of hope. Witnessing the despair that The Legion cast upon Grand Chien, <name> resolved to uplift spirits. Now, he uses his teaching skills to inspire resilience and optimism, believing that education is not just a tool for the mind but a weapon against darkness.",
        "<name>, a former schoolteacher, educates the next generation of militia members, passing down knowledge and instilling values of justice and equality. <name>'s commitment to nurturing both minds and spirits shapes the future of Grand Chien's resistance.",
        "<name>, a former teacher with a passion for knowledge, guides the militia with wisdom and insight. his strategic thinking and analytical mind offer a calculated approach to each battle, ensuring that every move is a step closer to victory. <name>'s unwavering belief in the potential of Grand Chien fuels his determination to lead his comrades to a brighter future.",
        "<name>, a former schoolteacher driven by a hunger for justice, became a strategist for the militia. Miguel's keen intellect and ability to anticipate enemy movements earned him the name 'The Oracle.' Miguel's guidance turns the tide of battle, proving that knowledge can be as powerful as any weapon."
    },
    Worker = {
        "<name>, a skilled craftsman hailing from <city>, once honed his talents in the quiet workshops of Grand Chien. Fueled by a sense of justice and the need to defend his home, <name> now channels his craftsmanship into the creation and maintenance of essential tools for the militia.",
        "<name>, a skilled artisan from the bustling factories of <city>, exchanged the rhythmic clatter of machinery for the chaotic beat of war drums. As The Legion encroached on the industrial heart of Grand Chien, <name> saw a need to defend not just a workplace, but a way of life.",
        "<name>, a hardworking construction worker from <city>, witnessed the destruction of familiar landmarks as The Legion advanced. Driven by a deep connection to the cityscape he helped build, <name> enlisted in the militia. Armed with a determination forged in the crucible of construction sites, he now reinforces the militia's ranks, rebuilding not just structures but also the hope for a better tomorrow.",
        "<name>, a seasoned dockworker from the bustling port of <city>, felt the tremors of change when The Legion threatened to seize control. Witnessing the potential devastation to the vital lifeline of trade, <name> traded cargo for combat. Now, armed with the grit of a dockyard worker, he stands as a bulwark, safeguarding not just shipments but the economic heartbeat of Grand Chien.",
        "<name>, a skilled electrician from <city>, saw the lights dim as The Legion cast shadows over the once vibrant streets. Fueled by a commitment to restore the city's spark, <name> joined the militia. With a toolkit of skills honed in fixing circuits, he now illuminates the path for his fellow soldiers, electrifying the fight against the encroaching darkness.",
        "<name>, a diligent miner from the depths of <city>'s mines, delved into the militia with a determination forged in the bowels of the earth. As The Legion threatened to engulf the region, <name> recognized the need to protect not only underground treasures but the very land that sustained his livelihood.",
        "<name>, a skilled mechanic from the bustling streets of <city>, heard the rumble of engines fade as The Legion's grip tightened. Fueled by a passion for all things automotive and a desire to reclaim the city's streets, <name> enlisted in the militia. Armed with wrenches and determination, he now ensures that the militia's vehicles roar to life, symbolizing the relentless spirit of Grand Chien's blue-collar workers.",
        "<name>, a skilled welder from the industrial sectors of <city>, witnessed the destructive forces of The Legion tearing through steel and concrete. Fuelled by the fury of molten metal, <name> joined the militia. Now, he welds not just structures but also a bond of strength among his fellow soldiers, determined to forge a path to victory.",
        "<name>, a dedicated garbage collector from the streets of <city>, found himself amidst rising piles of refuse as The Legion's influence spread. Seeing the decay of his community, <name> joined the militia. Armed with the determination to clean up more than just the streets, he fights for a fresh start, ensuring that Grand Chien emerges from the rubble stronger than ever.",
        "<name>, a diligent transit worker from the heart of <city>, saw the public transport system crumble under The Legion's weight. Fueled by a commitment to keep the city moving, <name> enlisted in the militia. Now, he guides not just buses but the momentum of the resistance, ensuring that the pulse of Grand Chien remains steady in the face of adversity.",
        "<name>, a skilled textile worker from the looms of <city>, felt the fabric of society unraveling as The Legion advanced. Driven by a commitment to weave a different tale, <name> enlisted in the militia. Now, armed with threads of resilience, he stitches together not just fabrics but a tapestry of strength among his fellow soldiers.",
        "<name>, a brave firefighter from <city>, witnessed the flames of chaos consuming the city he swore to protect. Fueled by a determination to extinguish more than just physical fires, <name> joined the militia. Now, he fights not only with water and hose but with a firefighter's courage, ready to quench the blaze of oppression threatening Grand Chien.",
        "<name>, a skilled brewmaster from the local breweries in <city>, tasted the bitterness of oppression in the air as The Legion tightened its grip. Fueled by a desire to reclaim the city's flavor, <name> enlisted in the militia. Now, he doesn't just brew beverages but stirs the spirit of resistance, fermenting a rebellion against The Legion's oppressive rule.",
        "<name>, a meticulous maintenance worker from the heart of <city>, saw the wear and tear of neglect as The Legion wreaked havoc. Driven by a commitment to keep the city infrastructure intact, <name> joined the militia. Armed with tools of repair, he not only fixes structures but also mends the resolve of his fellow soldiers, ensuring that Grand Chien remains standing.",
        "<name>, a diligent sanitation worker from the streets of <city>, observed the decay of cleanliness as The Legion spread its influence. Driven by a commitment to hygiene and order, <name> enlisted in the militia. Now, armed with a broom and a sense of duty, he sweeps away not just trash but the looming threat of chaos in Grand Chien.",
        "<name>, a skilled mechanic from the workshops of <city>, felt the gears of society grind to a halt under The Legion's rule. Fueled by a desire to reignite the engine of progress, <name> joined the militia. Now, armed with wrenches and determination, he not only fixes machines but also oils the cogs of resistance, ensuring that Grand Chien's mechanisms of defiance run smoothly.",
        "<name>, hailing from a long line of engineers, grew up surrounded by blueprints and tools. With a natural talent for understanding the inner workings of machinery, <name> has become the go-to person for disarming and repurposing enemy traps. The militia's reliance on <name>'s technical prowess has turned the tide of numerous battles against The Legion.",
        "<name>, a Grand Chien engineer with a knack for improvisation, constructs ingenious traps and devices to thwart The Legion's advances. <name>'s ability to turn everyday objects into formidable weapons has saved countless lives on the battlefield.",
        "<name>, a former engineer, is the militia's mechanic. His technical expertise and mechanical know-how are essential to the militia's survival, and his ability to repair and maintain equipment ensures that the fighters are always ready for battle. <name>'s unwavering dedication to the cause inspires others to follow him, and his presence on the battlefield instills hope in the hearts of the people.",
        "<name>, a former blacksmith with arms as strong as his will, forges the backbone of the militia. With every strike of his hammer, <name> shapes the destiny of Grand Chien, crafting weapons of resistance and determination. His unwavering dedication to the cause ensures that every fighter is equipped to face the darkness that looms over the nation.",
    },
    WhiteCollar = {
        "<name>, a meticulous city engineer involved in shaping the urban landscape of <city>, understands the importance of structural integrity. Fueled by a commitment to contribute engineering expertise beyond blueprints, <name> has chosen to join the militia.",
        "<name>, a skilled financial analyst accustomed to navigating the intricacies of corporate finance in <city>, recognizes the broader economic impact of crises. Driven by a commitment to financial stability beyond office walls, <name> has decided to join the militia.",
        "<name>, an adept IT specialist responsible for maintaining technological infrastructure in <city>, understands the critical role of technology in modern society. Fueled by a commitment to cyber resilience, <name> has chosen to join the militia.",
        "<name>, a meticulous city accountant who has kept financial records in check for <city>, believes in fiscal responsibility during times of crisis. Driven by a commitment to transparent financial management, <name> has decided to join the militia.",
        "<name>, a creative marketing executive responsible for promoting businesses in <city>, recognizes the power of communication in crisis situations. Fueled by a commitment to positive messaging, <name> has chosen to join the militia.",
        "<name>, a compassionate HR specialist involved in employee well-being in <city>, believes in supporting the workforce during challenging times. Driven by a commitment to human resources beyond office protocols, <name> has decided to join the militia.",
        "<name>, a visionary city planner contributing to the aesthetic and functional aspects of <city>, understands the importance of organized urban development. Fueled by a commitment to sustainable planning beyond city blueprints, <name> has chosen to join the militia.",
        "<name>, a legal consultant well-versed in navigating the complexities of law in <city>, believes in upholding justice during times of uncertainty. Driven by a commitment to legal advocacy, <name> has decided to join the militia.",
        "<name>, a meticulous city auditor ensuring financial accountability in <city>, recognizes the importance of transparent governance. Fueled by a commitment to auditing practices beyond official protocols, <name> has chosen to join the militia.",
        "<name>, a visionary city architect contributing to the aesthetic and functional aspects of <city>, understands the importance of architectural coherence. Driven by a commitment to innovative design beyond blueprints, <name> has decided to join the militia.",
        "<name>, an environmental consultant focused on sustainability practices in <city>, recognizes the significance of eco-friendly initiatives. Fueled by a commitment to environmental responsibility beyond consulting contracts, <name> has chosen to join the militia.",
        "<name>, a skilled logistics manager coordinating the movement of goods in <city>, understands the importance of supply chains during crises. Driven by a commitment to efficient logistics, <name> has decided to join the militia.",
        "<name>, an urban economist studying economic trends in the dynamic setting of <city>, recognizes the impact of economic shifts on communities. Fueled by a commitment to economic resilience beyond research papers, <name> has chosen to join the militia.",
        "<name>, a vigilant city compliance officer ensuring adherence to regulations in <city>, believes in maintaining order during challenging times. Driven by a commitment to regulatory compliance, <name> has decided to join the militia.",
        "<name>, a strategic corporate communications specialist responsible for managing public perception in <city>, recognizes the importance of transparent communication during crises. Fueled by a commitment to positive messaging, <name> has chosen to join the militia.",
        "<name>, a skilled IT manager responsible for maintaining technology infrastructure in <city>, understands the critical role of technology in modern society. Driven by a commitment to cyber resilience, <name> has decided to join the militia."
    },
    Farmer = {
        "<name>, a hardworking farmer from the outskirts of <city>, felt the threat of The Legion encroaching on the fields that sustained his community. Driven by a deep connection to the land, <name> left behind the plow for a weapon.",
        "<name>, a seasoned fiherman from the coastal areas near <city>, felt the currents of change as The Legion threatened the livelihood of his community. Driven by a deep connection to the sea, <name> traded his fishing rod for a weapon.",
        "<name>, a dedicated landscaper from the gardens of <city>, watched as The Legion's shadow loomed over the once vibrant greenery. Fueled by a commitment to preserve the beauty of his surroundings, <name> joined the militia.",
        "<name>, a diligent farmer from the fertile fields surrounding <city>, witnessed the threat of instability looming over his crops. Driven by a profound connection to the land that sustained his community, <name> joined the militia.",
        "<name>, a dedicated farmhand from the outskirts of <city>, saw the sanctuaries of agriculture endangered by external forces. Fueled by a commitment to nurture life and sustenance, <name> enlisted in the militia.",
        "<name>, a skilled herder from the serene pastures near <city>, felt the threat of chaos creeping towards the very heart of his livelihood. Driven by a deep bond with the animals he tended, <name> enlisted in the militia.",
        "<name>, a meticulous orchard keeper from the sun-kissed groves surrounding <city>, saw the shadows of uncertainty cast over the fruitful trees. Fueled by a commitment to preserve the sweetness of life, <name> joined the militia.",
        "<name>, a skilled irrigation specialist from the agrarian landscapes near <city>, recognized the vital role water played in sustaining the fields. Driven by a commitment to ensure the lifeblood of agriculture flows unimpeded, <name> enlisted in the militia.",
        "<name>, a dedicated nursery worker from the verdant nurseries near <city>, witnessed the fragility of newly sprouted life under the looming threat. Fueled by a commitment to nurture growth, <name> joined the militia.",
        "<name>, a meticulous agricultural scientist from the research labs near <city>, observed the potential devastation that threatened the carefully cultivated crops. Fueled by a commitment to apply scientific knowledge for the greater good, <name> enlisted in the militia.",
        "<name>, a skilled tractor operator from the vast farmlands surrounding <city>, witnessed the encroachment of uncertainty over the expansive fields. Driven by a commitment to keep the wheels of progress turning, <name> joined the militia.",
        "<name>, a dedicated beekeeper from the buzzing apiaries near <city>, sensed the disruption in the delicate balance of nature. Fueled by a commitment to protect the pollinators that sustain crops, <name> enlisted in the militia.",
        "<name>, a skilled greenhouse caretaker from the controlled environments near <city>, saw the vulnerability of delicate crops to external threats. Driven by a commitment to nurture life even in the face of adversity, <name> joined the militia.",
        "<name>, a diligent crop scout from the sprawling farmlands near <city>, recognized the vulnerability of crops to unseen threats. Fueled by a commitment to ensure the health of the fields, <name> enlisted in the militia.",
        "<name>, a skilled agricultural engineer from the technology-driven farms near <city>, saw the potential disruption to the finely tuned machinery that powered the fields. Driven by a commitment to innovation and progress, <name> joined the militia.",
        "<name>, a dedicated dairy farmer from the serene pastures surrounding <city>, felt the threat to the source of life-sustaining milk. Fueled by a commitment to preserve the nutritional backbone of the community, <name> enlisted in the militia.",
        "<name>, a knowledgeable agronomist from the agricultural research centers near <city>, recognized the potential impact of external forces on crop yields. Driven by a commitment to apply scientific principles to farming, <name> joined the militia.",
        "<name>, a dedicated farmer from a generations-old family farm near <city>, witnessed the legacy of hard work threatened by external forces. Fueled by a commitment to uphold family traditions, <name> joined the militia.",
        "<name>, a weathered farmer from the sunlit fields surrounding <city>, endured the trials of seasons and storms. Driven by a commitment to withstand whatever challenges nature and man presented, <name> enlisted in the militia.",
        "<name>, a diligent orchard keeper from the fruit-laden orchards near <city>, sensed the fragility of the delicate fruits under the looming threat. Fueled by a commitment to preserve the bounty that graced the land, <name> joined the militia.",
        "<name>, a resilient smallholder farmer from the outskirts of <city>, felt the squeeze of external pressures on his modest farm. Driven by a commitment to prove that even the smallest plots have a role in the grand tapestry of agriculture, <name> enlisted in the militia.",
        "<name>, a Grand Chien native who once navigated treacherous waters as a fiherman, now steers the militia with the same unwavering determination. his leadership on the battlefield is as steady as the ocean's tide, and his ability to adapt to the ever-changing currents of war ensures that the militia is always one step ahead of their enemies.",
        "<name>, a seasoned hunter and survivalist, found his purpose within the militia after witnessing the devastating impact of The Legion's tyranny. His remarkable skill with a sniper rifle and deep knowledge of wilderness tactics make him an indispensable asset.",
        "<name>, an expert tracker and former hunter, provides vital reconnaissance for the militia. <name>'s intimate knowledge of Grand Chien's forests and wildlife enables him to guide the resistance through treacherous terrains while remaining one step ahead of the enemy.",
    },
    Miner = {
        "<name>, a seasoned diamond miner from the depths of Grand Chien's mines, braved the dark tunnels in pursuit of the glittering gems. Fueled by a commitment to unearth the treasures that adorned the city, <name> enlisted in the militia.",
        "<name>, a skilled miner who spent years extracting gems from the rich veins beneath <city>, witnessed the potential exploitation of the invaluable resources. Driven by a commitment to ensure that the city's wealth benefits its people, <name> joined the militia.",
        "<name>, a diligent pit prospector from the expansive diamond mines near <city>, explored the labyrinth of tunnels in search of precious stones. Fueled by a commitment to uncover the hidden treasures that lay beneath, <name> enlisted in the militia.",
        "<name>, a skilled mine engineer responsible for the intricate workings beneath <city>, understood the delicate balance required for successful mining. Driven by a commitment to maintain the integrity of the mines and protect the workforce, <name> joined the militia.",
        "<name>, a meticulous gem cutter who transformed raw diamonds into exquisite jewels for <city>, saw the potential exploitation of the precious stones. Fueled by a commitment to preserve the true value of the gems, <name> enlisted in the militia.",
        "<name>, a stalwart miner who spent a lifetime in the winding tunnels beneath <city>, recognized the importance of preserving the mining legacy. Driven by a commitment to safeguard the ancestral knowledge passed down through generations, <name> joined the militia.",
        "<name>, a skilled operator of ore carts in the depths of <city>'s mines, understood the importance of transporting precious cargo efficiently. Fueled by a commitment to keep the wheels of mining turning, <name> enlisted in the militia.",
        "<name>, a meticulous surveyor who mapped the expansive diamond quarries surrounding <city>, recognized the potential threats to the mining landscapes. Driven by a commitment to preserve the natural beauty and resources of the quarries, <name> joined the militia.",
        "<name>, a skilled dynamite handler responsible for controlled explosions in <city>'s mines, witnessed the power and potential danger of the explosive work. Fueled by a commitment to balance progress with safety, <name> enlisted in the militia.",
        "<name>, a savvy gem market trader who facilitated the sale of diamonds from <city>'s mines, foresaw the economic impact of external threats. Driven by a commitment to uphold the fair trade of gemstones, <name> joined the militia.",
        "<name>, a former miner from the rugged mountains, found his true calling as a demolitions expert in the militia. His intimate knowledge of explosives and underground terrain makes him an invaluable asset.",
        "<name>, a former miner and geologist, brings a scientific approach to the art of destruction. Utilizing his knowledge of rock formations and seismic activity, <name> creates controlled earthquakes that disrupt The Legion's operations.",
        "<name>, a former miner in Grand Chien's diamond mines, joined the militia after witnessing the devastating impact of resource exploitation on his community. <name>'s experiences underground have lent him a unique advantage in navigating the complex network of tunnels that crisscross the region.",
    },
    Soldier = {
        "<name>, a seasoned soldier with a history of military service in the defense forces of <city>, felt the call to duty once again as Grand Chien faced new threats. Fueled by a commitment to protect the city he once served, <name> joined the militia.",
        "<name>, a former soldier haunted by the memories of past conflicts, sought redemption in a new cause. Driven by a commitment to make amends for the turmoil wrought by previous wars, <name> joined the militia.",
        "<name>, a dedicated ex-soldier who once patrolled the streets of <city> in uniform, heard the echoes of a new battle cry. Fueled by a commitment to safeguard the familiar streets he once defended, <name> joined the militia.",
        "<name>, a skilled soldier with expertise in urban warfare, felt the pulse of <city>'s streets and recognized the potential threats. Driven by a commitment to ensure the safety of the urban landscape, <name> joined the militia.",
        "<name>, a dedicated former soldier who once patrolled the quaint streets of <city>, felt a renewed sense of duty. Fueled by a commitment to safeguard the close-knit community he once protected, <name> joined the militia.",
        "<name>, a skilled soldier experienced in rural defense, sensed the peaceful rhythms of life in <city> under threat. Driven by a commitment to preserve the tranquility of the village, <name> joined the militia.",
        "<name>, a loyal ex-soldier who once watched over the hamlet borders of <city>, recognized the importance of preserving the small community. Fueled by a commitment to protect the tight-knit hamlet, <name> joined the militia.",
        "<name>, a vigilant ex-soldier who once patrolled the riverside areas of <city>, felt the call to defend the waterfront from emerging threats. Driven by a commitment to preserve the town's lifeline, <name> joined the militia.",
        "<name>, a steadfast ex-soldier familiar with the strategic importance of crossroads, recognized the vulnerability of <city>'s central meeting point. Fueled by a commitment to protect the heart of the town, <name> joined the militia.",
        "<name>, a dedicated ex-soldier who once stood sentinel on the hillside overlooking <city>, felt the winds of change stirring in the air. Driven by a commitment to safeguard the elevated vantage point, <name> joined the militia.",
        "<name>, a skilled ex-soldier with experience in rural landscapes, sensed the potential threats to the fruitful orchards surrounding <city>. Fueled by a commitment to protect the agricultural heart of the town, <name> joined the militia.",
        "<name>, a vigilant ex-soldier who once patrolled the outskirts of <city>, felt the responsibility to secure the town's boundaries. Driven by a commitment to preserve the sense of safety in the outskirts, <name> joined the militia.",
        "<name> is a former soldier. With his military experience and strategic mind, <name> leads the fight against The Legion. his unwavering dedication to the cause inspires others to follow him, and his presence on the battlefield instills hope in the hearts of the people.",

    },
    Legion = {
        "<name>, a former member of The Legion who once marched in their ranks, felt the weight of past misdeeds. Driven by a deep desire for redemption and a commitment to right the wrongs, <name> joined the militia.",
        "<name>, an ex-Legion soldier who once wore the insignia of The Legion, broke free from the shackles of the oppressive gang. Fueled by a commitment to dismantle the very force he once served, <name> joined the militia.",
        "<name>, a former Legion deserter who once slipped away from the ranks, felt the call to make amends. Driven by a commitment to atone for abandoning The Legion, <name> joined the militia.",
        "<name>, an ex-Legion outcast who dared to question the gang's oppressive ways, found refuge in the militia's cause. Fueled by a commitment to defy the very ideals he once followed, <name> joined the militia.",
        "<name>, a dissenter from The Legion who resisted the gang's authority, sought a new purpose. Driven by a commitment to oppose the oppressive regime, <name> joined the militia.",
        "<name>, a survivor of The Legion's harsh indoctrination, broke free from the gang's control. Fueled by a commitment to prevent others from suffering the same fate, <name> joined the militia.",
        "<name>, a former member of The Legion who defected from the gang's ranks, sought a path of redemption. Driven by a commitment to undo the harm caused by his association, <name> joined the militia.",
        "<name>, a dissident who once challenged The Legion's authority from within, found a new purpose in the militia. Fueled by a commitment to break the chains of tyranny, <name> joined the militia.",
        "<name>, a survivor of The Legion's brutal training and indoctrination, emerged with a desire for change. Driven by a commitment to dismantle the oppressive gang, <name> joined the militia.",
        "<name>, a former Legion member who rejected the gang's ideology, sought a new cause. Fueled by a commitment to resist The Legion's influence, <name> joined the militia.",
        "<name>, once a feared enforcer for The Legion, turned his allegiance to the militia after seeing the brutality of the regime he had served.",
        "<name>, a defector from The Legion, joined the militia seeking redemption. <name>'s past fuels his determination to right his wrongs and bring stability back to his homeland.",

    },
    Criminal = {
        "<name>, once a notorious figure in the criminal underworld of <city>, decided to turn away from a life of crime. Fueled by a commitment to seek redemption and make amends, <name> joined the militia.",
        "<name>, a reformed enforcer for a once-powerful gang in <city>, chose to break free from the cycle of crime. Driven by a commitment to protect the community he once exploited, <name> joined the militia.",
        "<name>, a former street hustler and small-time criminal in <city>, felt the weight of his past choices. Fueled by a commitment to break free from the criminal life, <name> joined the militia.",
        "<name>, once a notorious smuggler with a checkered past, chose to abandon illicit activities. Driven by a commitment to distance himself from the criminal underworld, <name> joined the militia.",
        "<name>, a former member of a street gang that once ruled sections of <city>, decided to break away from the life of crime. Fueled by a commitment to rectify past wrongs, <name> joined the militia.",
        "<name>, a reformed petty thief who once roamed the streets of <city>, found a new purpose in the militia. Driven by a commitment to leave behind a life of larceny, <name> joined the militia.",
        "<name>, a former safe cracker known for his precision in heists, chose to leave the criminal world behind. Fueled by a commitment to use his skills for a noble cause, <name> joined the militia.",
        "<name>, once an informant for a criminal syndicate in <city>, decided to break free from the chains of betrayal. Driven by a commitment to loyalty and justice, <name> joined the militia.",
        "<name>, a skilled forgery artist with a knack for creating counterfeit documents, turned away from the deceitful world of crime. Fueled by a commitment to use his talents for the greater good, <name> joined the militia.",
        "<name>, a former street con artist skilled in swindling unsuspecting victims, chose to put an end to the deceit. Driven by a commitment to live an honest life, <name> joined the militia.",
        "<name>, a former negotiator for criminal enterprises in <city>, sought a path of redemption. Fueled by a commitment to use his skills for lawful purposes, <name> joined the militia.",
        "<name>, once a renowned cat burglar with a history of daring heists, decided to leave the life of crime behind. Driven by a commitment to ascend to new heights, <name> joined the militia.",
        "<name>, a former pickpocket adept at navigating crowded streets, chose to abandon the subtle art of theft. Fueled by a commitment to contribute positively to society, <name> joined the militia.",
        "<name>, a former blackmailer who once held secrets for profit, turned away from the shadows of extortion. Driven by a commitment to seek justice, <name> joined the militia.",

    },
    Student = {
        "<name>, a recent graduate from <city>'s high school, felt a profound sense of duty to protect his community. Fueled by a commitment to make a difference, <name> joined the militia.",
        "<name>, a recent college graduate with dreams of a promising future, heard the call to defend <city>. Driven by a commitment to contribute to society, <name> joined the militia.",
        "<name>, a recent graduate with a knack for technology and innovation, saw an opportunity to apply his skills for the greater good. Fueled by a commitment to use his technical prowess for defense, <name> joined the militia.",
        "<name>, a passionate college activist with a history of advocating for change, transitioned his ideals to the militia. Driven by a commitment to turn ideals into actions, <name> joined the militia.",
        "<name>, a recent high school graduate with aspirations for a bright future, felt a profound sense of responsibility towards <city>. Fueled by a commitment to contribute to the well-being of his community, <name> joined the militia.",
        "<name>, a conscientious high school senior eager to make a meaningful impact, answered the call to serve <city>. Driven by a commitment to foster a sense of community and safety, <name> joined the militia.",
        "<name>, a high school graduate with dreams of leadership, saw an opportunity to lead by example in the militia. Fueled by a commitment to guide <city> towards a better future, <name> joined the militia.",
        "<name>, a recent high school graduate with a passion for civic duty, felt compelled to defend <city> from emerging threats. Driven by a commitment to uphold the values of community and service, <name> joined the militia.",
        "<name>, a recent high school graduate eager to make a meaningful impact, joined the militia driven by a profound sense of duty. Fueled by a commitment to contribute to the well-being of <city>.",
        "<name>, a compassionate high school senior inspired by a sense of community, decided to answer the call to serve <city>. Driven by a commitment to fostering a sense of compassion and safety, <name> joined the militia.",
        "<name>, a high school graduate with aspirations for a better future, recognized the opportunity to contribute to the vision of <city>. Fueled by a commitment to guide <city> toward prosperity, <name> joined the militia.",
        "<name>, a recent high school graduate with a natural inclination for defending others, felt the urge to protect <city>. Driven by a commitment to safeguard his community, <name> joined the militia.",
        "<name>, a journalism graduate with a desire to unearth the truth, recognized the need to defend the integrity of information in <city>. Fueled by a commitment to report on the front lines, <name> joined the militia.",
    },
    Athlete = {
        "<name>, a recent sports science graduate and former star athlete, found a new arena to apply his discipline and commitment. Driven by a sense of duty to his community, <name> joined the militia.",
        "<name>, a renowned champion in the sports arena of <city>, recognized the need to translate physical prowess into a force for good. Fueled by a commitment to use athleticism for a greater purpose, <name> has chosen to join the militia.",
        "<name>, a respected team captain celebrated for leadership on and off the sports field in <city>, understands the impact of teamwork. Driven by a commitment to extend the spirit of collaboration beyond the sports arena, <name> has decided to join the militia.",
        "<name>, a star soccer striker whose goals echoed through <city>'s stadiums, saw an opportunity to score victories beyond the field. Fueled by a commitment to utilize agility and precision for a greater cause, <name> has chosen to join the militia.",
        "<name>, a dominant basketball center whose presence on the court towered over competitors in <city>, believes in channeling height and strength for a purpose beyond hoops. Driven by a commitment to teamwork and discipline, <name> has decided to join the militia.",
        "<name>, an ace tennis player whose powerful serves echoed through <city>'s tennis courts, recognized the potential to serve justice beyond the net. Fueled by a commitment to precision and focus, <name> has chosen to join the militia.",
        "<name>, an accomplihed Olympic swimmer who once conquered the waters representing <city>, believes in diving into new challenges for a greater cause. Driven by a commitment to endurance and speed, <name> has decided to join the militia.",
        "<name>, a martial arts champion whose disciplined techniques inspired respect in <city>, recognized the potential to defend beyond the dojo. Fueled by a commitment to discipline and honor, <name> has chosen to join the militia.",
        "<name>, a skilled golf professional whose precision on the greens captivated audiences in <city>, understands the power of patience and strategy. Driven by a commitment to navigate challenges with finesse, <name> has decided to join the militia.",
        "<name>, a cycling champion who conquered the roads of <city> with speed and endurance, recognized the potential to ride towards a greater purpose. Fueled by a commitment to pedal for change, <name> has chosen to join the militia.",
        "<name>, a track and field star whose records reverberated through <city>'s stadiums, believes in sprinting towards a cause greater than personal achievements. Driven by a commitment to speed and agility, <name> has decided to join the militia.",
        "<name>, a former competitive sharpshooter, brings unwavering precision to the militia's ranks. <name>'s unmatched accuracy turns every shot into a display of deadly artistry. In the face of adversity, <he> remains a stoic and silent force.",
    },
    Journalist = {
        "<name>, a seasoned journalist known for uncovering the truth amidst chaos in <city>, recognized the power of journalism in times of crisis. Fueled by a commitment to expose corruption and injustice, <name> has chosen to join the militia.",
        "<name>, a citizen journalist who captured the raw realities of <city>'s streets, felt compelled to contribute more than just documentation. Driven by a commitment to be an active participant in change, <name> has decided to join the militia.",
        "<name>, an investigative blogger renowned for exposing hidden truths in <city>, believes in the potential of digital journalism. Fueled by a commitment to keep the public informed, <name> has chosen to join the militia.",
        "<name>, a courageous whistleblower who risked everything to unveil corruption in <city>, understands the power of truth. Driven by a commitment to justice, <name> has decided to join the militia.",
        "<name>, an underground journalist who operated in the shadows of <city>, believes in the impact of grassroots reporting. Fueled by a commitment to amplify the voices of the marginalized, <name> has chosen to join the militia.",
        "<name>, a community reporter deeply connected to the pulse of <city>, recognizes the importance of local narratives. Driven by a commitment to share stories from the heart, <name> has decided to join the militia.",
        "<name>, a war correspondent who witnessed conflict unfold in the outskirts of <city>, understands the impact of chaos. Fueled by a commitment to bring attention to the consequences of strife, <name> has chosen to join the militia.",
        "<name>, a digital activist who harnessed the power of social media for advocacy in <city>, believes in the strength of online mobilization. Driven by a commitment to inspire change through connectivity, <name> has decided to join the militia.",
        "<name>, a truth-defending podcaster known for dissecting complex issues in <city>, sees the potential of audio storytelling. Fueled by a commitment to engage a broader audience, <name> has chosen to join the militia.",
        "<name>, a street photographer capturing moments of life in <city>, recognizes the power of visual storytelling. Driven by a commitment to document the human experience, <name> has decided to join the militia.",
        "<name>, a dedicated newspaper reporter with a history of uncovering local stories in <city>, understands the importance of community awareness. Fueled by a commitment to serve the public interest, <name> has chosen to join the militia.",
        "<name>, an investigative journalist renowned for delving into corruption and malpractices in <city>, believes in the power of exposing the truth. Driven by a commitment to hold those in power accountable, <name> has decided to join the militia.",
        "<name>, a respected local news anchor who has been the face of information in <city>, recognizes the need for active participation in shaping the narrative. Fueled by a commitment to engage with the community, <name> has chosen to join the militia.",
        "<name>, a versatile freelance journalist known for covering a diverse range of stories in <city>, understands the importance of independent reporting. Driven by a commitment to highlight stories that may go unnoticed, <name> has decided to join the militia.",
        "<name>, a journalist, wields the power of words to expose The Legion's atrocities to the world. <name>'s poignant articles and broadcasts hed light on the horrors faced by Grand Chien's people, rallying international support for the resistance.",
        "<name>, a former journalist, uses his words as weapons against The Legion's propaganda. Armed with a pen and a burning desire for truth, <name> exposes the atrocities committed by the oppressors and ignites a spark of resistance in the hearts of the people.",
    },
    SlumKid = {
        "<name>, a resilient youth who grew up navigating the harsh realities of the slums in <city>, decided to turn his struggles into strength. Fueled by a commitment to break free from the cycle of poverty and violence, <name> joined the militia.",
        "<name>, a determined resident of the slums in <city>, saw the opportunity to bring change to his community through the militia. Driven by a commitment to rise above the challenges of the slums, <name> joined the militia.",
        "<name>, a determined youth who found strength in the alleyways of the slums in <city>, decided to channel his resilience into a greater cause. Fueled by a commitment to uplift the spirits of his fellow slum dwellers, <name> joined the militia.",
        "<name>, a resourceful young resident of <city>'s slums, recognized the need to defend the vulnerable communities from external threats. Driven by a commitment to create a safer environment, <name> joined the militia.",
        "<name>, a resilient youth who grew up navigating the back alleys of the slums in <city>, saw an opportunity to bring change to his community through the militia. Fueled by a commitment to break free from the constraints of poverty, <name> joined the militia.",
        "<name>, a determined individual who overcame adversity in the slums of <city>, decided to use his experiences to make a positive impact. Driven by a commitment to defy the odds stacked against him and his community, <name> joined the militia.",
        "<name>, a resilient youth who navigated the hidden tunnels and sewers of the slums in <city>, saw an opportunity to bring change to the darkest corners. Fueled by a commitment to rise above the subterranean struggles, <name> joined the militia.",
        "<name>, a determined resident who grew up in the bustling market alleys of the slums in <city>, decided to transform his familiarity with the chaos into a force for good. Driven by a commitment to protect the vulnerable marketplaces, <name> joined the militia.",
        "<name>, a resourceful youth who found solace on the rooftops overlooking the slums in <city>, decided to use his elevated perspective for a greater purpose. Fueled by a commitment to keep watch over the vulnerable communities, <name> joined the militia.",
        "<name>, a talented youth who expressed hope through street art in the slums of <city>, saw an opportunity to bring color to the lives of his community. Driven by a commitment to uplift spirits, <name> joined the militia.",
        "<name>, a determined resident who pursued knowledge in the hidden backstreets of the slums in <city>, recognized the power of education in bringing change. Fueled by a commitment to empower his community, <name> joined the militia.",
        "<name>, a skilled artisan who honed sewing skills in the slums of <city>, realized the potential to stitch together a stronger community. Driven by a commitment to mend the fabric of his society, <name> joined the militia.",
        "<name>, a nature enthusiast who cultivated a hidden garden in the heart of the slums in <city>, decided to use the beauty of nature as a force for good. Fueled by a commitment to bring life to the concrete jungle, <name> joined the militia.",
        "<name>, a talented musician who crafted melodies in the alleys of the slums in <city>, recognized the power of music to inspire change. Driven by a commitment to uplift spirits, <name> joined the militia. ",
    },
    Revolutionary = {
        "<name>, a passionate advocate for communist ideals in the politically charged landscape of <city>, believes in the power of collective action. Fueled by a commitment to societal equality and justice, <name> is willing to join the militia with the right support.",
        "<name>, a dedicated labor rights activist who has been tirelessly advocating for workers' rights in the industrial sectors of <city>, sees the potential for change through the militia. Driven by a commitment to address economic disparities, <name> is prepared to join the militia with your support.",
        "<name>, a vocal advocate for social equality and justice in the tumultuous political climate of <city>, believes in the strength of unity. Fueled by a commitment to eradicate class disparities, <name> is prepared to join the militia with your support.",
        "<name>, a tireless organizer promoting collective action and solidarity among the people of <city>, envisions a society free from oppression. Driven by a commitment to unite the masses, <name> is ready to join the militia with your support.",
        "<name>, a committed member of the workers' vanguard who tirelessly advocates for the labor class in <city>, recognizes the potential for change through collective effort. Fueled by a commitment to elevate the working class, <name> is eager to join the militia with your support.",
        "<name>, a staunch advocate for social justice and equality in the face of political turbulence in <city>, believes in the transformative power of the people. Driven by a commitment to build a more just society, <name> is willing to join the militia with your support.",
        "<name>, an intellectual from the proletariat who passionately advocates for the rights of the working class in <city>, recognizes the potential for change through collective strength. Fueled by a commitment to bridge the gap between intellectual discourse and practical change, <name> is eager to join the militia with your support.",
        "<name>, a grassroots organizer deeply rooted in the communities of <city>, believes in the power of organizing from the bottom up. Driven by a commitment to amplify the voices of the marginalized, <name> is ready to join the militia with your support.",
        "<name>, a dedicated member of the equality vanguard, tirelessly advocates for the dismantling of oppressive structures in <city>. Fueled by a commitment to erase social hierarchies, <name> is prepared to join the militia with your support.",
        "<name>, an artist whose creations echo the call for revolution and change in <city>, sees the potential for artistic expression to fuel political transformation. Driven by a commitment to use creativity as a weapon for social justice, <name> is willing to join the militia with your support.",
    },
    RichKid = {
        "<name>, born into wealth and privilege in <city>, experienced an awakening to the disparities that plagued the city. Fueled by a commitment to bridge the gap between social classes, <name> has chosen to join the militia.",
        "<name>, hailing from one of the most affluent families in <city>, felt a calling to use privilege for a greater purpose. Driven by a commitment to address social issues, <name> has decided to join the militia.",
        "<name>, the heir to a considerable fortune in <city>, recognized the responsibility that comes with privilege. Fueled by a commitment to use wealth for the betterment of society, <name> has chosen to join the militia.",
        "<name>, born into a family of influence and affluence, became acutely aware of the societal issues in <city>. Driven by a commitment to be part of the solution, <name> has decided to join the militia.",
        "<name>, an aristocrat with a heart for the less fortunate, understands the power of privilege in shaping the destiny of <city>. Fueled by a commitment to alleviate suffering, <name> has chosen to join the militia.",
        "<name>, an individual from a prosperous family, envisions a future where wealth is a tool for positive change. Driven by a commitment to transform the narrative of affluence, <name> has decided to join the militia.",
        "<name>, born into a family known for its philanthropic endeavors, felt a personal calling to step beyond traditional charitable acts. Fueled by a commitment to actively address societal issues, <name> has chosen to join the militia.",
        "<name>, a progressive benefactor from a wealthy family, believes in using resources to catalyze positive change. Driven by a commitment to challenge the status quo, <name> has decided to join the militia.",
        "<name>, an heiress to a substantial fortune, perceives hiswealth as a catalyst for societal transformation. Fueled by a commitment to redefine the role of the privileged, <name> has chosen to join the militia.",
        "<name>, a compassionate scion from an affluent family, understands the potential impact of wealth on social issues. Driven by a commitment to be a force for good, <name> has decided to join the militia."
    },
    Refugee = {
        "<name>, a resilient individual forced to flee their home due to turmoil in <city>, found strength in the face of adversity. Fueled by a commitment to reclaim a sense of belonging, <name> has chosen to join the militia.",
        "<name>, a displaced parent who sought refuge in the midst of uncertainty in <city>, understands the profound impact of a stable home. Driven by a commitment to provide a better future for their family and others like them, <name> has decided to join the militia.",
        "<name>, an artisan displaced by the ravages of conflict in <city>, carried with them the skills of their trade to the refugee camps. Fueled by a commitment to rebuild and create anew, <name> has chosen to join the militia.",
        "<name>, a displaced teacher who once nurtured young minds in <city>, believes in the power of education to overcome displacement. Driven by a commitment to provide hope through knowledge, <name> has decided to join the militia.",
        "<name>, a counselor displaced by the traumatic events in <city>, recognized the importance of mental health in the journey of recovery. Fueled by a commitment to provide support and healing, <name> has chosen to join the militia.",
        "<name>, a displaced farmer who once tended to the fields of <city>, believes in the regenerative power of agriculture. Driven by a commitment to sow the seeds of hope, <name> has decided to join the militia.",
        "<name>, an engineer displaced from their once-thriving projects in <city>, understands the potential for innovation even in adversity. Fueled by a commitment to rebuild and improve, <name> has chosen to join the militia.",
        "<name>, a displaced medic who once provided care in the hospitals of <city>, believes in the healing power of compassion. Driven by a commitment to offer medical support in challenging times, <name> has decided to join the militia.",
        "<name>, a musician forced to abandon the familiar melodies of <city>, understands the harmonizing effect of music. Fueled by a commitment to uplift spirits through melodies, <name> has chosen to join the militia.",
        "<name>, an environmentalist displaced from their conservation efforts in <city>, believes in the restoration of balance even amidst displacement. Driven by a commitment to protect the environment, <name> has decided to join the militia."
    },
    Cop = {
        "<name>, a retired detective with a history of solving cases in <city>, recognized the need to continue upholding justice even outside the police force. Fueled by a commitment to safeguard the community, <name> has chosen to join the militia.",
        "<name>, a former beat officer who patrolled the neighborhoods of <city>, believes in maintaining order through community involvement. Driven by a commitment to protect and serve beyond traditional law enforcement, <name> has decided to join the militia.",
        "<name>, a seasoned SWAT officer with a history of handling high-pressure situations in <city>, recognized the need for tactical expertise in unconventional circumstances. Fueled by a commitment to apply specialized skills for the greater good, <name> has chosen to join the militia.",
        "<name>, a retired police captain who once commanded precincts in <city>, understands the importance of strategic leadership. Driven by a commitment to guide and organize beyond traditional structures, <name> has decided to join the militia.",
        "<name>, a former narcotics detective skilled in navigating the complex underworld of <city>, believes in using knowledge gained from the streets for a noble cause. Fueled by a commitment to dismantle criminal networks, <name> has chosen to join the militia.",
        "<name>, an ex-homicide investigator renowned for solving intricate cases in <city>, recognizes the enduring impact of unresolved crimes. Driven by a commitment to seek justice even outside the confines of official investigations, <name> has decided to join the militia.",
        "<name>, a former community policing advocate who prioritized building relationships in <city>, believes in the power of strong community ties. Fueled by a commitment to bridge gaps between law enforcement and citizens, <name> has chosen to join the militia.",
        "<name>, a retired traffic cop who once maintained order on <city>'s busy streets, understands the importance of traffic control in maintaining safety. Driven by a commitment to regulate chaos beyond traffic signals, <name> has decided to join the militia.",
        "<name>, a skilled undercover operative who infiltrated criminal networks in <city>, recognizes the value of covert operations in times of crisis. Fueled by a commitment to adaptability and secrecy, <name> has chosen to join the militia.",
        "<name>, a retired crisis negotiator known for defusing tense situations in <city>, believes in the power of dialogue to resolve conflicts. Driven by a commitment to peaceful resolutions beyond formal negotiations, <name> has decided to join the militia.",
        "<name>, a disillusioned former police officer, now utilizes his sharpshooting skills to fight for justice in Grand Chien. Fed up with The Legion's reign of terror, <name> is determined to make every bullet count, taking down high-value targets and chipping away at the enemy's power.",
    },
    Prominent = {
        "<name>, an iconic musician whose melodies resonated throughout the cultural tapestry of <city>, recognized the potential to harmonize a community in times of turmoil. Fueled by a commitment to use the power of music for a greater cause, <name> has chosen to join the militia.",
        "<name>, a respected politician known for diplomatic prowess in <city>, understands the significance of political influence in shaping a city's destiny. Driven by a commitment to serve beyond the traditional halls of power, <name> has decided to join the militia.",
        "<name>, a beloved actress whose performances captured the hearts of audiences in <city>, recognized the transformative power of storytelling. Fueled by a commitment to bring narratives of resilience to life, <name> has chosen to join the militia.",
        "<name>, a visionary business tycoon who once shaped the economic landscape of <city>, believes in utilizing resources for societal transformation. Driven by a commitment to prosperity beyond corporate confines, <name> has decided to join the militia.",
        "<name>, an esteemed academician whose intellectual contributions enriched the educational fabric of <city>, understands the role of knowledge in times of crisis. Fueled by a commitment to share wisdom for the greater good, <name> has chosen to join the militia.",
        "<name>, a charismatic news anchor whose voice brought news into every household in <city>, believes in using the media for positive impact. Driven by a commitment to truth and justice, <name> has decided to join the militia.",
        "<name>, a compassionate social worker who dedicated their life to helping the underprivileged in <city>, recognized the need for direct action in times of crisis. Fueled by a commitment to hands-on assistance, <name> has chosen to join the militia.",
        "<name>, an inspirational motivational speaker whose words stirred hope in the hearts of <city>'s residents, believes in motivating change through personal empowerment. Driven by a commitment to inspire action beyond words, <name> has decided to join the militia.",
        "<name>, an accomplihed scientist whose discoveries contributed to the scientific progress of <city>, understands the potential of innovation in times of need. Fueled by a commitment to apply scientific knowledge for societal benefit, <name> has chosen to join the militia.",
        "<name>, an influential community organizer who once mobilized masses for positive change in <city>, believes in the strength of collective action. Driven by a commitment to grassroots movements, <name> has decided to join the militia.",
        "<name>, a versatile thespian known for seamlessly inhabiting diverse roles on <city>'s stages, recognized the power of performance beyond the theatrical realm. Fueled by a commitment to bring emotions to life for a greater cause, <name> has chosen to join the militia.",
        "<name>, a charismatic film star whose on-screen presence captivated audiences in <city>, believes in using the glamour of the entertainment industry for impactful change. Driven by a commitment to influence beyond the silver screen, <name> has decided to join the militia.",
        "<name>, a soulful balladeer whose melodic voice resonated through <city>'s venues, recognized the potential of music to soothe and inspire. Fueled by a commitment to use the power of song for a greater cause, <name> has chosen to join the militia.",
        "<name>, a chart-topping pop sensation whose music echoed through the airwaves of <city>, believes in using the rhythm of popular culture to make a positive impact. Driven by a commitment to influence beyond the music charts, <name> has decided to join the militia.",
        "<name>, once a celebrated musician, now uses his melodies to inspire courage and unity among the militia. Armed with a guitar and a voice that carries the hopes of a nation, <name>'s music serves as a rallying cry for those who yearn for freedom. his songs echo through the battlefield, fueling the fighters' spirits as they face impossible odds.",
        "<name>, a charismatic storyteller and former artist, uses his talents to rally morale among the militia members. <name>'s compelling narratives of Grand Chien's rich history and the struggle for freedom inspire hope and unity in the face of adversity.",
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
    "Idris", "Jabari", "Kwame", "Lekan", "Malik", "Nkemdilim", "Obasi", "Osaze", "Pius", "Quincy", "Raheed",
    "Sadiq", "Tunde", "Uzoma", "Vincent", "Wale", "Xola", "Yakubu", "Zuberi", "Adel", "Bachir", "Chakib",
    "Djamel", "Elhadj", "Fouad", "Ghassan", "Habib", "Ilyas", "Jamal", "Kamal", "Larbi", "Majid", "Nadir",
    "Omar", "Qasim", "Rachid", "Salim", "Tarek", "Walid", "Youssef", "Zakariya", "Abdul", "Bilal", "Chacha",
    "Dhaki", "Ehe", "Fahari", "Gamba", "Hasani", "Imani", "Jelani", "Kamau", "Lengo", "Mosi", "Nuru",
    "Oba", "Panya", "Quara", "Rashidi", "Simba", "Tafari", "Ujima", "Vijay", "Wamalwa", "Xolani", "Yusuf",
    "Zahur", "Abebe", "Birhanu", "Desta", "Endale", "Fikru", "Girma", "Habte", "Iyasu", "Jember", "Kebrom",
    "Lulseged", "Mekonnen", "Nigussie", "Obang", "Petros", "Qidus", "Rufael", "Selassie", "Tewodros", "Woldemariam",
    "Xola", "Yared", "Zewdu", "Chapi", "Icepick", "Anton", "Toni", "rato", "Witzzard"
}
