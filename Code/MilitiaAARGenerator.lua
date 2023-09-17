-- Battle Introduction:
-- <sectorName>
-- <enemyAffiliation>

-- Militia Promotions:
-- <promotedMilitiaSodierNames>

-- Statistics at the Conclusion:
-- <enemyWoundedNum>
-- <ownWoundedNum>
-- <enemyKilledNum>
-- <ownKilledNum>

-- Enemy Introduction in Defensive Battle:
-- <enemyLeader>
-- Enemy Introduction in Offensive Battle:
-- <enemyLeader>

-- Militia Forces Introduction:
-- <militiaLeader>
-- <squadName>
-- <militiaNumber>

-- Player Forces in Defensive Battle:
-- <mercNames>
-- <mercNumber>

-- Optional Allied Forces Mention:
-- <squadNum>

-- Optional "Panicked" Status Effect:
-- <name>

-- Optional "Berserk" Status Effect:
-- <name>

-- Optional "Heroic" Status Effect:
-- <name>

-- Optional Lightly Wounded Mention:
-- <name>

-- Optional Heavily Wounded Mention:
-- <name>

-- Optional Killed Mention:
-- <name>

-- Optional Battle Won Sentence:

-- N/A

-- Optional Battle Lost Sentence:

-- N/A

-- Optional Militia Promotions:
-- <promotedMilitiaSodierNames>

-- local conflict = {
--     sectorId = sectorId,
--     squads = self:GetConflictSquads(sectorId),
--     militiaUnits = self:GetUnitIds(sectorId, "militia"),
--     enemyUnits = self:GetUnitIds(sectorId, "enemy"),
--     playerUnits = self:GetUnitIds(sectorId, "player"),
--     allyUnits = self:GetUnitIds(sectorId, "ally"),
--     militiaKilled = {},
--     enemyKilled = {},
--     playerKilled = {},
--     allyKilled = {},
--     civKilled = {},
--     kills = {},
--     wounds = {},
--     specialEvents = {},
--     promotions = {},
--     playerWon = false,
--     autoResolve = false,
--     playerAttacked = false,
--     retreat = false,
--     resolved = false,
--     startTime = Game.CampaignTime,
--     endTime = 0,
-- }


DefineClass.HUDA_AARGenerator = {
    victoryOffensiveTitles = {
        "Victory in <sectorName>",
        "Triumphs in <sectorName>",
        "Breaking: <sectorName> Victory!",
        "<sectorName> Battle Report",
        "<sectorName> Showdown",
        "Triumphant Day at <sectorName>",
        "The <sectorName> Triumph",
        "Victorious Campaign in <sectorName>",
        "Legendary Victory in <sectorName>",
        "Epic Triumphs in <sectorName>",
        "Dominating <sectorName> Victory",
        "Triumphant Return from <sectorName>",
        "The Day <sectorName> Stood Tall",
        "Triumph at <sectorName>",
        "Conquering <sectorName> Victory",
        "<sectorName> Victory Euphoria",
        "Glorious Offensive at <sectorName>",
        "Battles of <sectorName>",
        "<sectorName>: War Recap",
        "Frontline Dispatch: <sectorName>",
        "News Flash: <sectorName> Battle",
        "<sectorName> Conflict Update",
        "In the Trenches: <sectorName>",
        "<sectorName> War Diary",
        "Frontlines of <sectorName>",
        "War Reports from <sectorName>",
        "Inside <sectorName> Conflict",
        "The Fight at <sectorName>",
        "Engagements in <sectorName>",
        "<sectorName> War Journal",
        "Covering <sectorName> Battles",
        "Dispatches from <sectorName>",
        "Field Notes on <sectorName>",
        "<sectorName> Battle Highlights",
        "War Chronicles: <sectorName>",
        "Stories from <sectorName>",
        "War Front in <sectorName>",
        "<sectorName> Offensive Insights",
    },
    victoryDefensiveTitles = {
        "Defensive Victory at <sectorName>",
        "<sectorName> Defense Report",
        "<sectorName> Fortress Stand",
        "Triumphant Defense of <sectorName>",
        "<sectorName> Siege Triumph",
        "Defending <sectorName>: A Victory",
        "Lasting Defense in <sectorName>",
        "The <sectorName> Stronghold",
        "<sectorName> Defense Glory",
        "Stalwart Defense of <sectorName>",
        "Defensive Masterstroke in <sectorName>",
        "<sectorName> Invaders Repelled",
        "Fortified Victory in <sectorName>",
        "Protecting <sectorName> Success",
        "<sectorName> Strong Defense",
        "Withstanding <sectorName> Siege",
        "Valiant Defense of <sectorName>",
        "<sectorName> Victory and Valor",
        "Defensive Excellence at <sectorName>",
        "The Triumph of <sectorName> Defense",
    },
    defeatOffensiveTitles = {
        "<sectorName> Offensive Failures",
        "Retreat from <sectorName>",
        "Defeats in <sectorName>",
        "Breaking News: <sectorName> Losses",
        "<sectorName> Retreat Report",
        "Frontline Challenges: <sectorName>",
        "Bitter Defeat at <sectorName>",
        "<sectorName> Defeat Diary",
        "Suffering Losses in <sectorName>",
        "Dark Days at <sectorName>",
        "The Retreat from <sectorName>",
        "<sectorName> Defeat Analysis",
        "Defeat in <sectorName> Campaign",
        "The Battle of <sectorName>: Lost",
        "Resisting <sectorName> Defeat",
        "Struggles at <sectorName>",
        "Setbacks in <sectorName> Conflict",
        "Reeling from <sectorName> Defeat",
    },
    defeatDefensiveTitles = {
        "Defensive Defeat at <sectorName>",
        "<sectorName> Defense Collapse",
        "<sectorName> Fortress Breached",
        "Failed Defense of <sectorName>",
        "<sectorName> Siege Disaster",
        "Falling <sectorName>: A Defeat",
        "Crumbled Defense in <sectorName>",
        "The <sectorName> Breach",
        "<sectorName> Defense in Shambles",
        "Collapse of <sectorName> Defense",
        "Failed Defense in <sectorName>",
        "<sectorName> Invaders Prevail",
        "Disastrous Stand in <sectorName>",
        "Futile Defense of <sectorName>",
        "<sectorName> Defense Overwhelmed",
        "Battling Losses in <sectorName>",
        "<sectorName> Defensive Setback",
        "The Collapse of <sectorName> Defense",
        "Defensive Deficiency at <sectorName>",
        "The Fall of <sectorName>",
    },
    introVariants = {
        "The battle for <sectorName> ignited as our forces clashed with the formidable <enemyAffiliation>.",
        "Amidst the landscape of <sectorName>, a fierce battle erupted, pitting our forces against the relentless <enemyAffiliation>.",
        "Within the boundaries of <sectorName>, the tumultuous clash between our forces and the determined <enemyAffiliation> began.",
        "Beneath the vast skies of <sectorName>, the battle unfolded, with our forces facing off against the formidable <enemyAffiliation>.",
        "In the heart of <sectorName>, a fierce conflict erupted, as our forces clashed with the relentless <enemyAffiliation>.",
        "Amid the challenging environment of <sectorName>, the battle commenced, with our forces confronting the formidable <enemyAffiliation>.",
        "Within the territory of <sectorName>, the battlefield witnessed the clash between our forces and the determined <enemyAffiliation>.",
        "Beneath the radiant sun of <sectorName>, the battle roared to life, with our forces engaging the formidable <enemyAffiliation>.",
        "In the realm of <sectorName>, a fierce confrontation unfolded, as our forces faced off against the relentless <enemyAffiliation>.",
        "Amidst the dramatic setting of <sectorName>, the battle commenced, with our forces pitted against the formidable <enemyAffiliation>.",
        "The battle in <sectorName> erupted as our forces clashed with the formidable <enemyAffiliation>.",
        "Amidst the challenging terrain of <sectorName>, a fierce battle unfolded, with our forces facing off against the relentless <enemyAffiliation>.",
        "Within the confines of <sectorName>, the tumultuous clash between our forces and the determined <enemyAffiliation> began.",
        "Beneath the expansive skies of <sectorName>, the battle ignited, with our forces engaging the formidable <enemyAffiliation>.",
        "In the heart of <sectorName>, a fierce confrontation erupted, as our forces confronted the relentless <enemyAffiliation>.",
        "Amid the rugged environment of <sectorName>, the battle commenced, with our forces pitted against the formidable <enemyAffiliation>.",
        "Within the boundaries of <sectorName>, the battlefield witnessed the clash between our forces and the determined <enemyAffiliation>.",
        "Beneath the scorching sun of <sectorName>, the battle raged on, with our forces challenging the formidable <enemyAffiliation>.",
        "In the realm of <sectorName>, a fierce conflict unfolded, as our forces faced the relentless <enemyAffiliation>.",
        "Amidst the dramatic backdrop of <sectorName>, the battle erupted, with our forces clashing against the formidable <enemyAffiliation>."
    },
    enemyLeaderVariants = {
        "The leader of the Enemy forces was <enemyLeader>.",
        "<enemyLeader> stood as the commander of the Enemy forces.",
        "At the helm of the Enemy forces was <enemyLeader>.",
        "<enemyLeader> took charge of the Enemy forces.",
        "Leading the Enemy forces was <enemyLeader>.",
        "<enemyLeader> assumed leadership of the Enemy forces.",
        "The commander of the Enemy forces was <enemyLeader>.",
        "<enemyLeader> held the position of leader within the Enemy forces.",
        "Within the Enemy forces, <enemyLeader> served as the leader.",
        "The role of leader was held by <enemyLeader> in the Enemy forces.",
        "<enemyLeader> took on the role of leading the Enemy forces.",
        "In the Enemy forces, <enemyLeader> was recognized as the leader.",
        "The position of leader in the Enemy forces belonged to <enemyLeader>.",
        "<enemyLeader> was the acknowledged leader of the Enemy forces.",
        "At the forefront of the Enemy forces was <enemyLeader> as their leader.",
        "The leader of the Enemy forces, <enemyLeader>, directed their actions.",
        "<enemyLeader> was the designated leader of the Enemy forces.",
        "Within the Enemy forces, <enemyLeader> held the title of leader.",
        "In the ranks of the Enemy forces, <enemyLeader> was the leader.",
        "The leadership of the Enemy forces rested with <enemyLeader>."
    },
    enemyOffensiveVariants = {
        "Our forces launched a daring offensive against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With determination, we initiated an offensive campaign against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "Under the banner of victory, our troops embarked on an offensive mission against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With unwavering resolve, we initiated an offensive assault against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "In a bold offensive move, our forces challenged the <enemyForcesName> forces, numbering <enemyNumber>.",
        "Our offensive campaign, led by fearless commanders, aimed to overcome the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With determination and unity, we advanced aggressively against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In the face of adversity, our troops launched an offensive operation against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With the goal of victory in sight, our forces initiated an offensive strike against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With valor in our hearts, we challenged the <enemyForcesName> forces, numbering <enemyNumber>, in an offensive campaign.",
        "Our offensive forces advanced with resolve to engage the <enemyForcesName> forces, totaling <enemyNumber>.",
        "Our forces launched an offensive operation against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "Our offensive campaign unfolded against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With our brave soldiers leading the way, we initiated an offensive assault against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In a united effort, our forces challenged the <enemyForcesName> forces, numbering <enemyNumber>, in a bold offensive maneuver.",
        "Our offensive mission, aimed to achieve victory against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With our determined fighters, we advanced aggressively against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In the face of adversity, our troops launched an offensive operation against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With our heroes leading the way, our forces initiated an offensive strike against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With courage in our hearts, we challenged the <enemyForcesName> forces, numbering <enemyNumber>, in an offensive campaign."
    },
    enemyDefensiveVariants = {
        "We fortified our defenses against the <enemyForcesName> forces, numbering <enemyNumber>, who launched an aggressive attack.",
        "With determination, we stood our ground as the <enemyForcesName> forces, totaling <enemyNumber>, pressed their assault.",
        "Under a barrage of attacks from the <enemyForcesName> forces, numbering <enemyNumber>, our defenses were put to the test.",
        "With unwavering resolve, we defended against the <enemyForcesName> forces, totaling <enemyNumber>, in a fierce battle.",
        "In the face of relentless enemy advances, we held our defensive positions against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "Our defensive lines, commanded by steadfast leaders, repelled the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With unity and determination, we defended our territory against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "As the enemy launched wave after wave of attacks, we fortified our defenses against the <enemyForcesName> forces, totaling <enemyNumber>.",
        "With the goal of safeguarding our position, we resisted the <enemyForcesName> forces, numbering <enemyNumber>, in a defensive battle.",
        "With courage in our hearts, we withstood the assault of the <enemyForcesName> forces, numbering <enemyNumber>, in a defensive campaign.",
        "Our defenses, manned by our soldiers, held firm against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With our brave warriors at the forefront, we stood resolute against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In the face of enemy aggression, we defended our territory against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With our heroes leading the defense, we repelled the <enemyForcesName> forces, numbering <enemyNumber>.",
        "As our defenders stood their ground, our defensive positions held strong against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In a united effort, we fortified our defenses against the <enemyForcesName> forces, numbering <enemyNumber>, in the midst of battle.",
        "Our defensive mission, with our soldiers, aimed to protect our territory from the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With our determined fighters, we resisted the relentless assault of the <enemyForcesName> forces, numbering <enemyNumber>.",
        "In the face of adversity, our defenders held the line against the <enemyForcesName> forces, numbering <enemyNumber>.",
        "With courage in our hearts, we confronted the <enemyForcesName> forces, numbering <enemyNumber>, in a defensive campaign."
    },
    militiaDefensiveVariants = {
        "Beside them, <militiaLeader> rallied the local militia, known as <squadName>, with their <militiaNumber> dedicated members, determined to defend their homeland.",
        "As the enemy advanced, <militiaLeader> took charge of <squadName>, a militia force consisting of <militiaNumber> loyal individuals who stood firm to protect their community.",
        "In the face of danger, <militiaLeader> led <squadName>, a group of <militiaNumber> dedicated militia members, in a valiant effort to safeguard their homes.",
        "With courage in their hearts, <militiaLeader> and the <squadName> militia, totaling <militiaNumber> strong, stood resolute in the defense of their beloved territory.",
        "As the enemy's forces approached, <militiaLeader> emerged as the leader of <squadName>, a militia composed of <militiaNumber> steadfast defenders of their homeland.",
        "The local militia, under the guidance of <militiaLeader>, known as <squadName>, comprised <militiaNumber> determined members, all committed to protecting their community.",
        "Facing a formidable threat, <militiaLeader> took charge of <squadName>, a militia force of <militiaNumber> individuals, ready to defend their homeland with unwavering resolve.",
        "With their homes at stake, <militiaLeader> led the <squadName> militia, a group of <militiaNumber> valiant defenders, determined to stand their ground.",
        "In the midst of danger, <militiaLeader> and <squadName>'s militia, numbering <militiaNumber>, prepared to repel the enemy and safeguard their beloved community.",
        "As the enemy closed in, <militiaLeader> rallied the <squadName> militia, consisting of <militiaNumber> resolute members, ready to defend their homeland at all costs."
    },
    militiaOffensiveVariants = {
        "Beside them, <militiaLeader> led the local militia, known as <squadName>, with their <militiaNumber> dedicated members, in a daring offensive against the enemy.",
        "With determination in their hearts, <militiaLeader> took charge of <squadName>, a militia force consisting of <militiaNumber> brave individuals who embarked on an offensive mission.",
        "In a bold move, <militiaLeader> led <squadName>, a group of <militiaNumber> courageous militia members, in an audacious offensive to reclaim their territory.",
        "With unwavering resolve, <militiaLeader> and the <squadName> militia, totaling <militiaNumber> strong, launched an offensive to push back the enemy forces.",
        "Taking the initiative, <militiaLeader> emerged as the leader of <squadName>, a militia composed of <militiaNumber> determined warriors on an offensive campaign.",
        "Under the guidance of <militiaLeader>, the local militia known as <squadName>, comprised <militiaNumber> steadfast members, embarked on an offensive to reclaim their community.",
        "In the face of adversity, <militiaLeader> took charge of <squadName>, a militia force of <militiaNumber> individuals, boldly launching an offensive to secure their homeland.",
        "With their sights set on victory, <militiaLeader> led the <squadName> militia, a group of <militiaNumber> valiant fighters, on an audacious offensive mission.",
        "As the offensive began, <militiaLeader> and <squadName>'s militia, numbering <militiaNumber>, launched a daring assault to reclaim their beloved community.",
        "With determination burning bright, <militiaLeader> rallied the <squadName> militia, consisting of <militiaNumber> resolute members, on an offensive crusade against the enemy."
    },
    playerOffensiveVariants = {
        "Amidst the offensive, <mercNumber> renowned AIM mercenaries emerged as the vanguard: <mercNames>. Their skills were unmatched.",
        "In a daring offensive, <mercNames> from AIM led the charge. Their reputation as elite warriors preceded them.",
        "With the offensive underway, the hired guns from AIM, including <mercNames>, took point. Their skills were a force to be reckoned with.",
        "As the offensive campaign began, <mercNames> from AIM stepped forward as the elite strike team, ready to overcome all obstacles.",
        "Taking the offensive, the <mercNumber> AIM mercenaries, <mercNames>, advanced with unwavering determination and unmatched combat expertise.",
        "In the heat of battle, <mercNames> from AIM were the tip of the spear, leading the offensive charge with their renowned skills.",
        "With victory as their aim, the AIM mercenaries <mercNames> spearheaded the offensive, ready to outmatch any opposition.",
        "As the offensive strategy unfolded, <mercNames> from AIM stood tall, their elite status well-deserved, poised for a relentless advance.",
        "With the offensive in full swing, <mercNames> showcased their expertise as AIM mercenaries, taking the lead with unwavering resolve.",
        "Leading the charge in the offensive campaign were the AIM mercenaries <mercNames>, their names synonymous with victory.",
    },
    playerDefensiveVariants = {
        "Amidst the defense, <mercNumber> renowned AIM mercenaries emerged as the stalwarts: <mercNames>. Their skills were unmatched.",
        "In a steadfast defense, <mercNames> from AIM stood their ground. Their reputation as elite warriors preceded them.",
        "With the defense in place, the hired guns from AIM, including <mercNames>, formed an unbreakable line. Their skills were a force to be reckoned with.",
        "As the defensive campaign began, <mercNames> from AIM were the bastion of resilience, ready to repel all threats.",
        "Defending their position, the <mercNumber> AIM mercenaries, <mercNames>, held their ground with unwavering determination and unmatched combat expertise.",
        "In the face of adversity, <mercNames> from AIM were the steadfast defenders, standing firm with their renowned skills.",
        "With victory as their aim, the AIM mercenaries <mercNames> anchored the defense, ready to outmatch any opposition.",
        "As the defense strategy unfolded, <mercNames> from AIM stood tall, their elite status well-deserved, poised for an unyielding stand.",
        "With the defense firmly established, <mercNames> showcased their expertise as AIM mercenaries, holding the line with unwavering resolve.",
        "At the forefront of the defensive battle were the AIM mercenaries <mercNames>, their names synonymous with resilience.",
    },
    alliesOffensiveVariants = {
        "In the midst of the offensive, <squadNum> allied squads fought alongside the player's forces, creating a formidable alliance on the battlefield.",
        "With the offensive underway, the player's forces were reinforced by <squadNum> friendly squads, significantly bolstering their attack.",
        "As the offensive campaign began, <squadNum> allied squads joined the fray, forming a powerful coalition with the player's forces.",
        "Taking the offensive, the player's forces were not alone; <squadNum> allied squads fought shoulder to shoulder, united in their pursuit of victory.",
        "Amidst the offensive, <squadNum> friendly squads lent their support to the player's forces, enhancing their strength and resolve.",
        "With the offensive in full swing, the player's forces were joined by <squadNum> allied squads, collectively determined to achieve their objective.",
        "In a daring offensive, the player's forces found staunch allies in <squadNum> friendly squads, together forming an unstoppable front.",
        "With determination in their hearts, the player's forces and <squadNum> allied squads launched an audacious offensive to overcome all opposition.",
        "As the enemy faced an offensive onslaught, <squadNum> allied squads rallied to the player's cause, amplifying the impact of their assault.",
        "In the heat of battle, <squadNum> friendly squads provided crucial support to the player's forces, making victory all the more attainable."
    },
    alliesDefensiveVariants = {
        "Amidst the defense, <squadNum> allied squads stood steadfastly alongside the player's forces, forming an impenetrable defensive alliance.",
        "In a steadfast defense, the player's forces were reinforced by <squadNum> friendly squads, fortifying their defenses against all threats.",
        "With the defense in place, <squadNum> allied squads joined the ranks, creating an unyielding defensive coalition with the player's forces.",
        "As the defensive campaign began, <squadNum> friendly squads were the bulwark alongside the player's forces, resolute in their defense.",
        "Defending their position, <squadNum> allied squads stood shoulder to shoulder with the player's forces, unwavering in their commitment.",
        "In the face of adversity, <squadNum> friendly squads provided unwavering support to the player's forces, fortifying their defenses.",
        "With the defense firmly established, <squadNum> allied squads contributed to the unbreakable front alongside the player's forces.",
        "As the defense strategy unfolded, <squadNum> friendly squads bolstered the player's forces, creating an impervious defense.",
        "At the forefront of the defensive battle, <squadNum> allied squads reinforced the player's forces, ensuring a resilient stand.",
        "In the midst of the defensive battle, <squadNum> allied squads played a pivotal role in bolstering the player's defenses against all odds."
    },
    panickedStatusVariants = {
        "<name> displayed signs of panic, struggling to maintain composure amidst the chaos.",
        "Amidst the turmoil, <name> fell victim to panic, their actions becoming erratic and uncontrolled.",
        "As the battle raged on, <name> succumbed to panic, their movements marked by fear and uncertainty.",
        "<name> was overcome by panic, their once-confident demeanor replaced by a sense of unease.",
        "In the midst of the conflict, <name> experienced a moment of panic, their resolve briefly wavering.",
        "The intensity of the battle took its toll on <name>, who showed signs of panic in the face of danger.",
        "<name>'s composure waned as panic set in, casting doubt on their ability to withstand the pressure.",
        "Amidst the chaos of the battlefield, <name> couldn't escape the grip of panic, causing momentary disarray.",
        "<name> struggled to maintain control, their actions betraying the fear that had taken hold in the heat of battle.",
        "In a moment of vulnerability, <name> was gripped by panic, their actions reflecting the turmoil within."
    },
    berserkStatusVariants = {
        "Driven by an uncontrollable frenzy, <name> went berserk, attacking anything in their path with unrestrained ferocity.",
        "<name> succumbed to a wild berserker rage, their actions fueled by primal instincts and a relentless desire for combat.",
        "In the heat of battle, <name> was consumed by berserker fury, lashing out at friend and foe alike in a wild rampage.",
        "Amidst the chaos, <name> became a berserker, their actions driven solely by an insatiable appetite for violence.",
        "The battlefield witnessed <name>'s transformation into a berserk force, wreaking havoc without discrimination.",
        "<name> was overtaken by a berserker's madness, their every move marked by unrelenting aggression and chaos.",
        "In a frenzied state, <name> embraced the berserker within, unleashing an onslaught of unrestrained brutality.",
        "<name>'s descent into berserker rage left a trail of destruction in its wake, a force of unbridled chaos.",
        "Fueled by berserker fervor, <name> became a whirlwind of violence, heedless of danger or consequence.",
        "The battlefield quaked with <name>'s berserker onslaught, as they unleashed their primal instincts with savage intensity."
    },
    heroicStatusVariants = {
        "In a moment of sheer heroism, <name> rose above the chaos, displaying unwavering courage and determination.",
        "Amidst the battle, <name> exhibited a heroic spirit, inspiring those around them with acts of bravery and selflessness.",
        "With unwavering resolve, <name> became a beacon of heroism, leading by example on the battlefield.",
        "In the midst of adversity, <name> embraced a heroic role, their actions reflecting valor and self-sacrifice.",
        "The battlefield witnessed <name>'s heroic deeds, as they fearlessly faced danger to protect their comrades.",
        "<name> displayed heroism beyond measure, their actions defining the essence of courage and sacrifice.",
        "Amidst the chaos of battle, <name> emerged as a hero, their selfless acts inspiring others to follow suit.",
        "With valor in their heart, <name> became a symbol of heroism, reminding all of the noblest qualities within.",
        "In the face of danger, <name> embodied heroism, their actions showcasing unwavering bravery and determination.",
        "The battlefield echoed with tales of <name>'s heroic exploits, their selflessness a testament to the human spirit."
    },
    killandwoundedTransitions = {
        "Amidst the clash of arms, the toll of casualties weighed heavily on us.",
        "As the battle raged on, the cost in lives and injuries became increasingly evident.",
        "The battlefield bore witness to the sacrifices made by our brave soldiers.",
        "In the heat of battle, the price of victory was measured in wounded and fallen comrades.",
        "The struggle continued, marked by the sacrifices of our warriors.",
        "Despite our determination, casualties began to mount on both sides.",
        "With each passing moment, the battlefield became a somber reminder of the price of war.",
        "The clash of forces exacted a heavy toll in lives and injuries.",
        "As the battle unfolded, the human cost of conflict was impossible to ignore.",
        "The ebb and flow of battle was marked by the bravery and sacrifice of our troops.",
        "In the midst of battle, the wounded and fallen heroes became a testament to our resolve.",
        "Despite the challenges, our determination burned brightly, even in the face of casualties.",
    },
    lightlyWoundedVariants = {
        "<name> sustained minor injuries during the battle but remained determined to continue the fight.",
        "Amidst the chaos, <name> suffered light wounds, a testament to their resilience in the face of adversity.",
        "Despite facing minor injuries, <name> pressed on with unwavering resolve, undeterred by the pain.",
        "In the heat of battle, <name> received light wounds, though their spirit remained unbroken.",
        "The skirmish left <name> with minor injuries, but their commitment to the cause remained unwavering.",
        "<name> endured minor wounds on the battlefield, a reflection of their determination to persevere.",
        "Amidst the clash of arms, <name> suffered light injuries, but their fighting spirit remained undiminished.",
        "Even with minor wounds, <name> continued to stand firm, resolute in their dedication to the battle.",
        "The battle took its toll on <name>, leaving them lightly wounded, yet their courage remained unshaken.",
        "<name>'s minor injuries were a reminder of the battle's intensity, but they pressed on undaunted."
    },
    heavilyWoundedVariants = {
        "<name> sustained severe injuries during the battle, their resilience tested as they fought through the pain.",
        "Amidst the tumultuous clash, <name> suffered heavy wounds, yet their determination to prevail remained unyielding.",
        "In the midst of the chaos, <name> bore the weight of heavy injuries, their spirit undiminished by the suffering.",
        "Despite enduring severe wounds, <name> pressed on with unwavering resolve, defying the odds.",
        "The fierce battle left <name> heavily wounded, but their unwavering courage continued to shine.",
        "<name> faced the brunt of heavy injuries on the battlefield, a testament to their unbreakable spirit.",
        "Amidst the relentless conflict, <name> bore the burden of heavy wounds, their fortitude unwavering.",
        "Even with grievous injuries, <name> continued to stand resolute, their determination unshaken.",
        "The intensity of the battle exacted a heavy toll on <name>, leaving them gravely wounded but unbowed.",
        "Despite their heavy injuries, <name> displayed remarkable strength, a beacon of determination on the battlefield."
    },
    killedVariants = {
        "<name> valiantly fought until the end, but tragically, he fell in the midst of the battle.",
        "Amidst the chaos of combat, <name>'s life was cut short, a solemn reminder of the cost of war.",
        "In the heat of the struggle, <name> met a heroic end, their sacrifice forever etched in the annals of battle.",
        "<name>'s journey on the battlefield came to a close, a poignant moment in the midst of conflict.",
        "The relentless battle claimed <name>, a stark reminder of the risks faced in the pursuit of victory.",
        "With unwavering resolve, <name> faced their final moments on the battlefield, a symbol of bravery to all.",
        "The clash of arms exacted a heavy toll, and <name> was among those who gave their all for the cause.",
        "Even in their final moments, <name> stood as a testament to the valor displayed in the face of adversity.",
        "The battlefield witnessed <name>'s sacrifice, a solemn reminder of the price paid in the pursuit of freedom.",
        "<name> met their fate on the battlefield, leaving behind a legacy of courage and dedication."
    },
    greatPerformanceVariants = {
        "During the fierce battle, <soldierName> showcased remarkable courage and determination, securing an impressive <killNumber> enemy casualties, earning the respect of their comrades.",
        "Amidst the chaos of battle, <soldierName> stood as an unstoppable force, achieving the remarkable feat of taking down <killNumber> enemy combatants, a feat that would be remembered for generations.",
        "Heroic deeds unfolded on the battlefield as <soldierName> fought valiantly, achieving an outstanding <killNumber> enemy kills, becoming a true hero of the conflict.",
        "<soldierName> delivered exemplary service during the battle, resulting in a staggering <killNumber> enemy casualties, solidifying their reputation as a formidable warrior.",
        "The battlefield witnessed the emergence of <soldierName> as a true hero, achieving an outstanding <killNumber> enemy kills, leaving an indelible mark on the annals of history.",
        "Epic feats were accomplished by <soldierName> during the intense battle, securing an impressive <killNumber> enemy casualties, earning the admiration of all who fought alongside them.",
        "The legendary warrior <soldierName> earned their title on the battlefield, with <killNumber> enemy kills, demonstrating unmatched prowess and valor.",
        "A masterful performance by <soldierName> led to a total of <killNumber> enemy casualties, underscoring their exceptional skills and unwavering commitment.",
        "The unparalleled skill of <soldierName> on the battlefield resulted in a remarkable <killNumber> enemy kills, turning the tide of battle.",
        "Exceptional contribution to the battle was made by <soldierName>, achieving <killNumber> enemy casualties, earning the highest accolades from their fellow soldiers.",
        "Outstanding achievements marked <soldierName>'s actions, with <killNumber> enemy kills, turning the tide of battle.",
        "Incredible bravery was on full display as <soldierName> fought on the front lines, resulting in the elimination of <killNumber> enemy combatants, a testament to their courage.",
        "During the battle, <soldierName> delivered a remarkable performance, securing <killNumber> enemy casualties, contributing significantly to the battle's outcome.",
        "The peerless skill of <soldierName> on the battlefield led to a total of <killNumber> enemy kills, setting an example of unwavering dedication and valor.",
        "Unwavering resolve defined <soldierName>'s actions on the battlefield, achieving <killNumber> enemy casualties, inspiring all who fought alongside them.",
        "Heroic valor was evident in <soldierName>'s actions, securing <killNumber> enemy kills, leaving an indelible mark on the history of the conflict.",
        "An exceptional performance was delivered by <soldierName> on the battlefield, achieving <killNumber> enemy casualties, showcasing unmatched dedication.",
        "Fearless fighting characterized <soldierName>'s role in the battle, eliminating <killNumber> enemy foes and proving to be an invaluable asset to their comrades.",
        "In the heat of battle, <soldierName>'s actions were nothing short of extraordinary, accounting for <killNumber> enemy casualties, demonstrating unwavering commitment.",
        "The tenacity displayed by <soldierName> during the conflict resulted in a significant <killNumber> enemy kills, establishing them as a true warrior of renown.",
    },
    battleWonVariants = {
        "After a hard-fought battle, victory was achieved, bringing a sense of relief and accomplishment to all.",
        "The resilience and determination of the forces prevailed, securing a hard-earned triumph in the face of adversity.",
        "In the end, the battle was won, a testament to the unwavering spirit of those who fought.",
        "Victory was seized from the jaws of defeat, as the forces emerged triumphant in the fierce clash of arms.",
        "The battlefield echoed with the sweet sound of victory, marking a memorable moment of triumph.",
        "With unyielding resolve, the forces emerged victorious, their efforts culminating in a well-deserved win.",
        "Amidst the chaos of battle, a triumphant moment emerged, signifying the ultimate success of the mission.",
        "The hard-won victory on the battlefield served as a testament to the strength and unity of the forces.",
        "After a grueling struggle, the forces emerged as the victors, their determination unwavering until the end.",
        "The battle's end brought victory, a shining moment of accomplishment in the face of daunting odds.",
        "Through unwavering courage and sheer determination, victory was achieved in the heart of battle.",
        "With a final surge of strength, the forces secured a triumphant win, their resilience unwavering.",
        "The battle's conclusion marked a victorious moment, a testament to the tenacity of those who fought.",
        "The triumphant outcome of the battle was a symbol of unity and bravery in the face of adversity.",
        "In the end, victory was claimed on the battlefield, a hard-earned reward for the sacrifices made.",
        "The forces emerged as the victorious party, their unwavering commitment to the cause paying off.",
        "The clash of arms yielded a victorious result, a testament to the indomitable spirit of the fighters.",
        "Amidst the tumultuous battle, the forces achieved a well-deserved victory, their efforts not in vain.",
        "The battle's conclusion brought triumph, a moment of celebration for those who fought relentlessly.",
        "With determination as their guiding light, the forces emerged victorious, their mission accomplished.",
    },
    battleLostVariants = {
        "Despite valiant efforts, the battle was lost, leaving a heavy sense of disappointment and sorrow.",
        "The forces fought bravely but, in the end, victory eluded them, casting a somber shadow over the battlefield.",
        "Despite their unwavering determination, the forces faced defeat, a bitter reminder of the challenges of war.",
        "In the face of adversity, the forces fell short, their efforts met with the harsh reality of defeat.",
        "The battlefield bore witness to a hard-fought struggle, but the outcome was one of loss and despair.",
        "Despite their best efforts, the forces were unable to secure victory, a solemn moment on the battlefield.",
        "With courage and resilience, the forces battled fiercely, but destiny had other plans, and defeat was their fate.",
        "The clash of arms ended in defeat, a humbling experience for the forces who fought with valor.",
        "Amidst the chaos of battle, the forces faced the harsh truth of defeat, a reminder of the unpredictable nature of war.",
        "Despite their determination, the forces could not overcome the odds, and the battle ended in a sorrowful loss.",
        "In the end, the forces found themselves on the losing side, a somber conclusion to a fierce conflict.",
        "The battle's outcome was one of defeat, a moment of reflection on the sacrifices made by those who fought.",
        "Despite their unwavering resolve, the forces could not alter the course of destiny, and defeat was inevitable.",
        "The forces fought with honor, but the battlefield yielded a bitter result—a loss that weighed heavy on their hearts.",
        "In the face of adversity, the forces gave their all, but the battle concluded with the bitter taste of defeat.",
        "The battlefield echoed with the somber realization of defeat, a moment of reflection on the challenges faced.",
        "Despite their bravery, the forces were met with defeat, a stark reminder of the uncertainties of warfare.",
        "With determination in their hearts, the forces fought valiantly, but the battle ended in the shadow of defeat.",
        "The forces' resilience was commendable, but the outcome was one of loss, a reminder of the cost of conflict.",
        "Despite their fierce resolve, the forces were unable to claim victory, and the battle ended in defeat."
    },
    militiaPromotionVariants = {
        "Several militia members, including <promotedMilitiaSodierNames>, demonstrated exceptional leadership and dedication, earning well-deserved promotions within the militia ranks.",
        "The militia ranks saw several promotions, with <promotedMilitiaSodierNames> standing out for their dedication and leadership.",
        "Among those promoted in the militia were <promotedMilitiaSodierNames>, individuals who showcased remarkable commitment to the cause.",
        "The dedication of <promotedMilitiaSodierNames> within the militia ranks did not go unnoticed, resulting in well-earned promotions.",
        "Multiple militia members, including <promotedMilitiaSodierNames>, were recognized for their outstanding contributions with promotions.",
        "Promotions within the militia were aplenty, and <promotedMilitiaSodierNames> were at the forefront of this well-deserved recognition.",
        "The militia celebrated several promotions, with <promotedMilitiaSodierNames> emerging as distinguished leaders among their peers.",
        "Recognition and promotions were bestowed upon several militia members, including <promotedMilitiaSodierNames>, for their unwavering dedication.",
        "The ranks of the militia swelled with promotions, as <promotedMilitiaSodierNames> were honored for their exceptional service.",
        "Distinguished leaders emerged within the militia, and <promotedMilitiaSodierNames> were among those who earned promotions.",
        "Promotions were a testament to the commitment of militia members, and <promotedMilitiaSodierNames> stood out for their dedication.",
        "Several promotions highlighted the militia's unity and determination, with <promotedMilitiaSodierNames> earning their place among the honored.",
        "The militia saw numerous promotions, and <promotedMilitiaSodierNames> were recognized for their invaluable contributions.",
        "Within the militia ranks, <promotedMilitiaSodierNames> were commended and promoted for their unwavering commitment.",
        "The promotion of <promotedMilitiaSodierNames> within the militia reflected the dedication and unity of the forces.",
        "Several militia members, including <promotedMilitiaSodierNames>, received well-deserved promotions for their unwavering service.",
        "Promotions were a symbol of the militia's strength and resilience, with <promotedMilitiaSodierNames> leading the way.",
        "The ranks of the militia were bolstered by promotions, and <promotedMilitiaSodierNames> were at the forefront of this recognition.",
        "Militia promotions were a testament to the determination of <promotedMilitiaSodierNames> and their fellow comrades.",
        "The militia celebrated several promotions, with <promotedMilitiaSodierNames> earning their place among the honored leaders."
    },
    militiaPromotionSingleVariants = {
        "<promotedMilitiaSodierNames> demonstrated exceptional leadership and dedication, earning a well-deserved promotion within the militia ranks.",
        "In recognition of his unwavering commitment, <promotedMilitiaSodierNames> received a distinguished promotion within the militia.",
        "Among the dedicated militia members, <promotedMilitiaSodierNames> stood out and earned a notable promotion.",
        "The remarkable service of <promotedMilitiaSodierNames> was honored with a significant promotion within the militia.",
        "<promotedMilitiaSodierNames> was recognized as an exemplary leader and received a special promotion within the militia.",
        "Promotions within the militia were highlighted by <promotedMilitiaSodierNames>'s outstanding dedication and earned leadership.",
        "The militia ranks celebrated a singular promotion as <promotedMilitiaSodierNames> emerged as an exceptional leader.",
        "<promotedMilitiaSodierNames>'s commitment and leadership were rewarded with a well-earned promotion in the militia.",
        "A singular promotion within the militia ranks marked <promotedMilitiaSodierNames>'s dedication to the cause.",
        "In a standout performance, <promotedMilitiaSodierNames> earned a significant promotion within the militia.",
        "Among the militia's dedicated members, <promotedMilitiaSodierNames> was promoted for their exceptional contributions.",
        "A special promotion within the militia recognized <promotedMilitiaSodierNames>'s unwavering commitment and leadership.",
        "The militia's unity and determination were exemplified by <promotedMilitiaSodierNames>'s singular promotion.",
        "<promotedMilitiaSodierNames>'s invaluable contributions were acknowledged with a well-deserved promotion within the militia.",
        "For their unwavering service, <promotedMilitiaSodierNames> received a prominent promotion in the militia.",
        "The promotion of <promotedMilitiaSodierNames> underscored the dedication and unity of the militia forces.",
        "In a standout moment, <promotedMilitiaSodierNames> was promoted within the militia ranks for their remarkable service.",
        "<promotedMilitiaSodierNames> led the way with their dedication and earned a significant promotion in the militia.",
        "The militia's strength and resilience were embodied by <promotedMilitiaSodierNames>'s singular promotion.",
        "Amidst celebrations, <promotedMilitiaSodierNames> earned their place among the honored leaders with a promotion in the militia."
    },
    battleConclusionVariants = {
        "The aftermath of the battle revealed the toll of conflict, with: <result>.",
        "As the dust settled, the battlefield bore witness to the costs of war, with: <result>.",
        "The battle's conclusion painted a somber picture, with: <result>.",
        "Amidst the remnants of the battlefield, the numbers spoke of the price paid for victory, with: <result>.",
        "The toll of battle became evident, with: <result>.",
        "The aftermath revealed the true cost of conflict, with: <result>.",
        "As the smoke cleared, the battlefield told a sobering story, with: <result>.",
        "The numbers etched on the battlefield were a stark reminder of the sacrifices made, with: <result>.",
        "In the aftermath, the battle's toll was clear, with: <result>.",
        "The price of victory was evident in the numbers, with: <result>.",
        "The battle's aftermath spoke of the challenges faced, with: <result>.",
        "As the dust settled, the battlefield revealed the costs incurred, with: <result>.",
        "The numbers on the battlefield were a testament to the sacrifices made, with: <result>.",
        "In the wake of battle, the toll became clear, with: <result>.",
        "The aftermath painted a vivid picture of the battle's costs, with: <result>.",
        "As the smoke cleared, the battlefield revealed the price paid for victory, with: <result>.",
        "The numbers etched on the battlefield told the story of valor and sacrifice, with: <result>.",
        "In the aftermath, the battle's toll stood as a testament to the courage displayed, with: <result>.",
        "The price of victory was etched in the numbers, with: <result>",
        "The battle's aftermath told a tale of challenges faced and sacrifices made, with: <result>."
    },
    events = {
        "Berserk",
        "Panicked",
        "Heroic"
    },
    numToWord = {
        [1] = "one",
        [2] = "two",
        [3] = "three",
        [4] = "four",
        [5] = "five",
        [6] = "six",
        [7] = "seven",
        [8] = "eight",
        [9] = "nine",
        [10] = "ten",
        [11] = "eleven",
        [12] = "twelve",
        [13] = "thirteen",
        [14] = "fourteen",
        [15] = "fifteen",
        [16] = "sixteen",
        [17] = "seventeen",
        [18] = "eighteen",
        [19] = "nineteen",
        [20] = "twenty"
    }
}

function HUDA_AARGenerator:NtW(num)
    num = num or 0

    if num == 0 then
        return "none"
    end

    if num > 20 then
        return tostring(num)
    else
        return self.numToWord[num]
    end
end

function HUDA_AARGenerator:Em(string)
    return "<color 0 0 0 255>" .. string .. "</color>"
    -- return string
end

function HUDA_AARGenerator:GetConclusionNums(conflict, type, side)
    if type == "wounded" then
        if side == "enemy" then
            return #table.filter(conflict.wounds, function(i, v)
                return v.side == "enemy"
            end)
        else
            return #table.filter(conflict.wounds, function(i, v)
                return v.side ~= "enemy"
            end)
        end
    elseif type == "killed" then
        if side == "enemy" then
            return #conflict.enemy.killed
        else
            return #conflict.militia.killed + #conflict.player.killed + #conflict.ally.killed
        end
    end
end

function HUDA_AARGenerator:JoinNames(array, key)
    key = key or "name"

    local names = ""

    for i, v in ipairs(array) do
        if i == 1 then
            names = v[key]
        elseif i == #array then
            names = names .. " and " .. v[key]
        else
            names = names .. ", " .. v[key]
        end
    end

    return names
end

function HUDA_AARGenerator:GetSpecialEvents(conflict)
    local specialEvents = table.filter(conflict.specialEvents, function(i, v)
        if v.side == "enemy" then
            return false
        end

        for i, event in ipairs(self.events) do
            if v.event == event then
                return true
            end
        end

        return false
    end)

    return specialEvents
end

function HUDA_AARGenerator:HasWoundedOrKilled(conflict)
    local killed = table.filter(conflict.kills, function(i, v)
        return v.side ~= "enemy"
    end)

    if #killed > 0 then
        return true
    end

    local wounded = table.filter(conflict.wounds, function(i, v)
        return v.side ~= "enemy"
    end)

    if #wounded > 0 then
        return true
    end

    return false
end

function HUDA_AARGenerator:GetMercNames(conflict)
    local mercNames = ""
    for i, v in ipairs(conflict.player.units) do
        local unit = getUnits and g_Units[v] or gv_UnitData[v]

        local name = unit.Name or unit.Nick

        local seperator = ""
        if i == 1 then
        elseif i ~= 1 and i ~= #conflict.player.units then
            seperator = ", "
        elseif i ~= 1 and i == #conflict.player.units then
            seperator = " and "
        end

        mercNames = mercNames .. seperator .. TDevModeGetEnglishText(name)
    end

    return mercNames
end

function HUDA_AARGenerator:GetMostWounded(conflict)
    local wounded = table.filter(conflict.wounds, function(i, v)
        return v.side ~= "enemy"
    end)

    if #wounded == 0 then
        return
    end

    local woundedUnits = {}
    for i, v in ipairs(wounded) do
        woundedUnits[v.name] = woundedUnits[v.name] or 0

        woundedUnits[v.name] = woundedUnits[v.name] + v.stack
    end

    local woundedUnitsArray = {}

    for i, v in pairs(woundedUnits) do
        table.insert(woundedUnitsArray, { name = i, stack = v })
    end

    table.sort(woundedUnitsArray, function(a, b)
        return a.stack > b.stack
    end)

    return woundedUnitsArray[1]
end

function HUDA_AARGenerator:GetSpecialKiller(conflict)
    local kills = conflict.kills

    local killers = {}

    for _, kill in ipairs(kills) do
        if kill.attacker and kill.side == "enemy" then
            table.insert(killers, kill.attacker)
        end
    end

    if #killers == 0 then
        return
    end

    local killer, kills = HUDA_ArrayMost(killers)

    if kills > 1 then
        return killer, kills
    end
end

function HUDA_AARGenerator:GetSectorName(sectorId)
    local sector = gv_Sectors[sectorId]

    return TDevModeGetEnglishText(sector.display_name or "") .. " (" .. sectorId .. ")"
end

function HUDA_AARGenerator:GetResultString(conflict)
    local results = {}

    local enemyWoundedNum = self:GetConclusionNums(conflict, "wounded", "enemy")
    local enemyKilledNum = self:GetConclusionNums(conflict, "killed", "enemy")
    local ownWoundedNum = self:GetConclusionNums(conflict, "wounded", "player")
    local ownKilledNum = self:GetConclusionNums(conflict, "killed", "player")

    if ownWoundedNum > 0 then
        table.insert(results, self:NtW(ownWoundedNum) .. " wounded")
    end

    if ownKilledNum > 0 then
        table.insert(results, self:NtW(ownKilledNum) .. " killed")
    end

    if enemyWoundedNum > 0 then
        table.insert(results,
            self:NtW(enemyWoundedNum) .. " " .. (enemyWoundedNum > 1 and "enemies" or "enemy") .. " wounded")
    end

    if enemyKilledNum > 0 then
        table.insert(results,
            self:NtW(enemyKilledNum) .. " " .. (enemyKilledNum > 1 and "enemies" or "enemy") .. " killed")
    end

    local string = ""

    for i, v in ipairs(results) do
        if i == 1 then
            string = v
        elseif i == #results then
            string = string .. " and " .. v
        else
            string = string .. ", " .. v
        end
    end

    return string
end

function HUDA_AARGenerator:RegenerateAAR(conflict)
    local aar = {}

    aar.title = self:PrintAARTitle(conflict)

    aar.text = self:PrintAAR(conflict)

    conflict.aar = aar
end

function HUDA_AARGenerator:PrintAAR(conflict)
    if not conflict then
        return
    end

    local aar = self:GenerateAAR(conflict)

    local aarText = ""
    for i, v in pairs(aar) do
        aarText = aarText .. v .. "\n"
    end

    return Untranslated(aarText)
end

function HUDA_AARGenerator:PrintAARTitle(conflict)
    if not conflict then
        return
    end

    local title = self:GenerateAARTitle(conflict)

    return Untranslated(title)
end

function HUDA_AARGenerator:GenerateAAR(conflict)
    local militia = #conflict.militia.units > 0 and true or false
    local enemy = #conflict.enemy.units > 0 and true or false
    local mercs = #conflict.player.units > 0 and true or false
    local allies = #conflict.ally.units > 0 and true or false
    local specialEvents = #self:GetSpecialEvents(conflict) > 0 and true or false
    local woundedOrKilled = self:HasWoundedOrKilled(conflict)
    local villain = conflict.enemy.leader and conflict.enemy.leader.villain or false
    local killer, kills = self:GetSpecialKiller(conflict)

    local aar = {}

    aar[#aar + 1] = self:GenerateBattleIntro(conflict)

    if villain then
        aar[#aar + 1] = self:GenerateVillainIntro(conflict)
    end

    aar[#aar + 1] = self:GenerateEnemyIntro(conflict)

    if militia then
        aar[#aar + 1] = self:GenerateMilitiaIntro(conflict)
    end

    if mercs then
        aar[#aar + 1] = self:GenerateMercsIntro(conflict)
    end

    if allies then
        aar[#aar + 1] = self:GenerateAlliesIntro(conflict)
    end

    if specialEvents then
        aar[#aar + 1] = self:GenerateSpecialEvents(conflict)
    end

    if woundedOrKilled then
        aar[#aar + 1] = self:GenerateWoundedAndKilled(conflict)
    end

    if killer then
        aar[#aar + 1] = self:GenerateSpecialKiller(conflict, killer, kills)
    end

    aar[#aar + 1] = self:GenerateFinale(conflict)

    if (militia and #conflict.promotions > 0) then
        aar[#aar + 1] = self:GenerateMilitiaPromotions(conflict)
    end

    aar[#aar + 1] = self:GenerateBattleConclusion(conflict)

    return aar
end

function HUDA_AARGenerator:GetRandomVariant(variants)
    if not variants or #variants == 0 then
        return ""
    end

    local rand = InteractionRand(#variants)

    rand = rand > 0 and rand or 1

    return variants[rand]
end

function HUDA_AARGenerator:GenerateAARTitle(conflict)
    local intro = {}
    intro.sectorName = self:GetSectorName(conflict.sectorId)

    local titleVariant

    if conflict.playerWon then
        titleVariant = conflict.playerAttacked and self:GetRandomVariant(self.victoryOffensiveTitles) or
            self:GetRandomVariant(self.victoryDefensiveTitles)
    else
        titleVariant = conflict.playerAttacked and self:GetRandomVariant(self.defeatOffensiveTitles) or
            self:GetRandomVariant(self.defeatDefensiveTitles)
    end

    return titleVariant:gsub("<sectorName>", intro.sectorName)
end

function HUDA_AARGenerator:GenerateBattleIntro(conflict)
    local intro = {}
    intro.sectorName = self:GetSectorName(conflict.sectorId)
    intro.enemyAffiliation = conflict.enemy.leader and conflict.enemy.leader.affiliation or "enemy"

    local introVariant = self:GetRandomVariant(self.introVariants)

    return introVariant:gsub("<sectorName>", self:Em(intro.sectorName)):gsub("<enemyAffiliation>",
        self:Em(intro.enemyAffiliation))
end

function HUDA_AARGenerator:GenerateVillainIntro(conflict)
    local intro = {}
    intro.enemyLeader = conflict.enemy.leader.name or "Francis"

    local introVariant = self:GetRandomVariant(self.enemyLeaderVariants)

    return introVariant:gsub("<enemyLeader>", intro.enemyLeader)
end

function HUDA_AARGenerator:GenerateEnemyIntro(conflict)
    local intro = {}
    intro.enemyForcesName = conflict.enemy.leader and conflict.enemy.leader.affiliation or "enemy"
    intro.enemyNumber = self:NtW(#conflict.enemy.units)

    local introVariant = self:GetRandomVariant(conflict.playerAttacked and self.enemyOffensiveVariants or
        self.enemyDefensiveVariants)

    return introVariant:gsub("<enemyNumber>", intro.enemyNumber):gsub("<enemyForcesName>", intro.enemyForcesName)
end

function HUDA_AARGenerator:GenerateMilitiaIntro(conflict)
    local intro = {}
    intro.militiaLeader = conflict.militia.leader and conflict.militia.leader.name or "The one and only"
    intro.squadName = '"' .. TDevModeGetEnglishText(conflict.militia.leader and conflict.militia.leader.squadName or "The Bastards") .. '"'
    intro.militiaNumber = self:NtW(#conflict.militia.units)

    print("name", intro.squadName)

    local introVariant = self:GetRandomVariant(conflict.playerAttacked and self.militiaOffensiveVariants or
        self.militiaDefensiveVariants)

    return introVariant:gsub("<militiaLeader>", intro.militiaLeader):gsub("<squadName>", self:Em(intro.squadName)):gsub(
        "<militiaNumber>", intro.militiaNumber)
end

function HUDA_AARGenerator:GenerateMercsIntro(conflict)
    local intro = {}
    intro.mercNames = self:GetMercNames(conflict)
    intro.mercNumber = #conflict.player.units

    local introVariant = self:GetRandomVariant(conflict.playerAttacked and self.playerOffensiveVariants or
        self.playerDefensiveVariants)

    return introVariant:gsub("<mercNames>", intro.mercNames):gsub("<mercNumber>", intro.mercNumber)
end

function HUDA_AARGenerator:GenerateAlliesIntro(conflict)
    local intro = {}
    intro.squadNum = self:NtW(#table.ifilter(conflict.squads, function(i, v)
        return v.side == "ally"
    end))

    local introVariant = self:GetRandomVariant(conflict.playerAttacked and self.alliesOffensiveVariants or
        self.alliesDefensiveVariants)

    return introVariant:gsub("<squadNum>", intro.squadNum)
end

function HUDA_AARGenerator:GenerateSpecialEvents(conflict)
    local specialEvents = self:GetSpecialEvents(conflict)

    local event = specialEvents[1]

    local eventVariant

    if event.event == "Heroic" then
        eventVariant = self:GetRandomVariant(self.heroicStatusVariants)
    elseif event.event == "Berserk" then
        eventVariant = self:GetRandomVariant(self.berserkStatusVariants)
    elseif event.event == "Panicked" then
        eventVariant = self:GetRandomVariant(self.panickedStatusVariants)
    end

    if eventVariant then
        return eventVariant:gsub("<name>", event.name)
    end
end

function HUDA_AARGenerator:GenerateWoundedAndKilled(conflict)
    local wkString = ""

    local transition = self:GetRandomVariant(self.killandwoundedTransitions)

    wkString = wkString .. transition

    local mercDeath = table.ifilter(conflict.kills, function(i, v)
        return v.side == "player"
    end)

    if #mercDeath > 0 then
        local eventVariant = self:GetRandomVariant(self.killedVariants)

        wkString = wkString .. " " .. eventVariant:gsub("<name>", mercDeath[1].targetName)
    else
        local militiaDeath = table.ifilter(conflict.kills, function(i, v)
            return v.side == "militia"
        end)

        if #militiaDeath > 0 then
            local eventVariant = self:GetRandomVariant(self.killedVariants)

            wkString = wkString .. " " .. eventVariant:gsub("<name>", militiaDeath[1].targetName)
        end
    end

    local mostWounded = self:GetMostWounded(conflict)

    if mostWounded then
        local eventVariant = self:GetRandomVariant(mostWounded.stack > 1 and self.heavilyWoundedVariants or
            self.lightlyWoundedVariants)

        wkString = wkString .. " " .. eventVariant:gsub("<name>", mostWounded.name)
    end

    return wkString
end

function HUDA_AARGenerator:GenerateSpecialKiller(conflict, killer, kills)
    local eventVariant = self:GetRandomVariant(self.greatPerformanceVariants)

    return eventVariant:gsub("<soldierName>", killer):gsub("<killNumber>", kills)
end

function HUDA_AARGenerator:GenerateMilitiaPromotions(conflict)
    local militiaPromotionsNumber = #conflict.promotions

    local eventVariant = self:GetRandomVariant(militiaPromotionsNumber > 1 and self.militiaPromotionVariants or
        self.militiaPromotionSingleVariants)

    local names = self:JoinNames(conflict.promotions)

    return eventVariant:gsub("<promotedMilitiaSodierNames>", names)
end

function HUDA_AARGenerator:GenerateFinale(conflict)
    local finaleVariant

    if conflict.playerWon then
        finaleVariant = self:GetRandomVariant(self.battleWonVariants)
    else
        finaleVariant = self:GetRandomVariant(self.battleLostVariants)
    end

    return finaleVariant
end

function HUDA_AARGenerator:GenerateBattleConclusion(conflict)
    local conclusionVariant = self:GetRandomVariant(self.battleConclusionVariants)

    return conclusionVariant:gsub("<result>", self:GetResultString(conflict))
end
