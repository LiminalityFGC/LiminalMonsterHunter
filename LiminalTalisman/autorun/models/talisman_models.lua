local model = {}

-- Fix this shit
---@type string
model.DefaultMessage = "<COL RED>Talisman Rewards:</COL>\nRewards available for pickup at melding pot."

---@type table<integer, integer>
model.QualifyingQuestList = {
	10302,
	10503,
	10701,
	405600,
	405601,
}

---@enum MeldingName
model.MeldingName = {
	NONE = "NONE",
	REFLECTINGPOOL = "REFLECTINGPOOL",
	HAZE = "HAZE",
	MOONBOW = "MOONBOW",
	WISPOFMYSTERY = "WISPOFMYSTERY",
	ANIMA = "ANIMA",
	AURORA = "AURORA",
	VIGOR = "VIGOR",
}

---@enum MeldingType
model.MeldingType = {
	RANDOM = "RANDOM",
	DETERMINISTIC = "DETERMINISTIC",
}

model.PlayerMessage = {
	[model.MeldingType.RANDOM] = "<COL RED>Random rewards await:</COL>\nRewards available for pickup at melding pot.",
	[model.MeldingType.DETERMINISTIC] = "<COL RED>Deterministic rewards await:</COL>\nRewards available for pickup at melding pot.",
}

---@type MeldingNameToSkillIds
model.MeldingNameToSkillIds = {
	[model.MeldingName.REFLECTINGPOOL] = {
		33,
		42,
		43,
		44,
		58,
		59,
		67,
		68,
		69,
		70,
		71,
		73,
		74,
		75,
		77,
		78,
		79,
		80,
		86,
		88,
		90,
		92,
		95,
		96,
		97,
		98,
		99,
		104,
		105,
	},
	[model.MeldingName.HAZE] = {
		13,
		14,
		15,
		16,
		17,
		18,
		33,
		40,
		41,
		42,
		43,
		44,
		52,
		53,
		54,
		56,
		57,
		58,
		59,
		60,
		62,
		64,
		72,
		81,
		85,
		86,
		88,
		89,
		90,
		92,
		93,
		96,
		99,
		104,
		105,
		106,
		107,
	},
	[model.MeldingName.MOONBOW] = {
		6,
		8,
		13,
		14,
		15,
		16,
		17,
		18,
		23,
		24,
		28,
		39,
		40,
		41,
		52,
		56,
		57,
		60,
		61,
		63,
		65,
		66,
		76,
		85,
		107,
	},
	[model.MeldingName.AURORA] = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		22,
		23,
		24,
		25,
		26,
		30,
		31,
		32,
		33,
		34,
		35,
		36,
		37,
		38,
		39,
		40,
		41,
		45,
		46,
		48,
		49,
		50,
		51,
		55,
		61,
		65,
		66,
		81,
		87,
		91,
		104,
		106,
		107,
		108,
		116,
		124,
		125,
		126,
		127,
		128,
		131,
	},
}

---@type SkillIdToName
model.SkillIdToName = {
	[1] = "Attack Boost",
	[2] = "Agitator",
	[3] = "Peak Performance",
	[4] = "Resentment",
	[5] = "Resuscitate",
	[6] = "Critical Eye",
	[7] = "Critical Boost",
	[8] = "Weakness Exploit",
	[9] = "Latent Power",
	[10] = "Maximum Might",
	[11] = "Critical Element",
	[12] = "Master's Touch",
	[13] = "Fire Attack",
	[14] = "Water Attack",
	[15] = "Ice Attack",
	[16] = "Thunder Attack",
	[17] = "Dragon Attack",
	[18] = "Poison Attack",
	[19] = "Paralysis Attack",
	[20] = "Sleep Attack",
	[21] = "Blast Attack",
	[22] = "Handicraft",
	[23] = "Razor Sharp",
	[24] = "Spare Shot",
	[25] = "Protective Polish",
	[26] = "Mind's Eye",
	[27] = "Ballistics",
	[28] = "Bludgeoner",
	[29] = "Bow Charge Plus",
	[30] = "Focus",
	[31] = "Power Prolonger",
	[32] = "Marathon Runner",
	[33] = "Constitution",
	[34] = "Stamina Surge",
	[35] = "Guard",
	[36] = "Guard Up",
	[37] = "Offensive Guard",
	[38] = "Critical Draw",
	[39] = "Punishing Draw",
	[40] = "Quick Sheathe",
	[41] = "Slugger",
	[42] = "Stamina Thief",
	[43] = "Affinity Sliding",
	[44] = "Horn Maestro",
	[45] = "Artillery",
	[46] = "Load Shells",
	[47] = "Special Ammo Boost",
	[48] = "Normal/Rapid Up",
	[49] = "Pierce Up",
	[50] = "Spread Up",
	[51] = "Ammo Up",
	[52] = "Reload Speed",
	[53] = "Recoil Down",
	[54] = "Steadiness",
	[55] = "Rapid Fire Up",
	[56] = "Defense Boost",
	[57] = "Divine Blessing",
	[58] = "Recovery Up",
	[59] = "Recovery Speed",
	[60] = "Speed Eating",
	[61] = "Earplugs",
	[62] = "Windproof",
	[63] = "Tremor Resistance",
	[64] = "Bubbly Dance",
	[65] = "Evade Window",
	[66] = "Evade Extender",
	[67] = "Fire Resistance",
	[68] = "Water Resistance",
	[69] = "Ice Resistance",
	[70] = "Thunder Resistance",
	[71] = "Dragon Resistance",
	[72] = "Blight Resistance",
	[73] = "Poison Resistance",
	[74] = "Paralysis Resistance",
	[75] = "Sleep Resistance",
	[76] = "Stun Resistance",
	[77] = "Muck Resistance",
	[78] = "Blast Resistance",
	[79] = "Botanist",
	[80] = "Geologist",
	[81] = "Partbreaker",
	[82] = "Capture Master",
	[83] = "Carving Master",
	[84] = "Good Luck",
	[85] = "Speed Sharpening",
	[86] = "Bombardier",
	[87] = "Mushroomancer",
	[88] = "Item Prolonger",
	[89] = "Wide-Range",
	[90] = "Free Meal",
	[91] = "Heroics",
	[92] = "Fortify",
	[93] = "Flinch Free",
	[94] = "Jump Master",
	[95] = "Carving Pro",
	[96] = "Hunger Resistance",
	[97] = "Leap of Faith",
	[98] = "Diversion",
	[99] = "Master Mounter",
	[100] = "Chameleos Blessing",
	[101] = "Kushala Blessing",
	[102] = "Teostra Blessing",
	[103] = "Dragonheart",
	[104] = "Wirebug Whisperer",
	[105] = "Wall Runner",
	[106] = "Counterstrike",
	[107] = "Rapid Morph",
	[108] = "Hellfire Cloak",
	[109] = "Wind Alignment",
	[110] = "Thunder Alignment",
	[111] = "Stormsoul",
	[112] = "Blood Rite",
	[113] = "Dereliction",
	[114] = "Furious",
	[115] = "Mail of Hellfire",
	[116] = "Coalescence",
	[117] = "Bloodlust",
	[118] = "Defiance",
	[119] = "Sneak Attack",
	[120] = "Adrenaline Rush",
	[122] = "Redirection",
	[123] = "Spiribird's Call",
	[124] = "Charge Master",
	[125] = "Foray",
	[126] = "Tune-Up",
	[127] = "Grinder (S)",
	[128] = "Bladescale Hone",
	[129] = "Wall Runner (Boost)",
	[133] = "Quick Breath",
	[130] = "Element Exploit",
	[131] = "Burst",
	[132] = "Guts",
	[134] = "Status Trigger",
	[135] = "Intrepid Heart",
	[136] = "Buildup Boost",
	[121] = "Embolden",
	[138] = "Wind Mantle",
	[139] = "Powder Mantle",
	[137] = "Berserk",
	[145] = "Strife",
	[140] = "Frostcraft",
	[141] = "Dragon Conversion",
	[142] = "Heaven-Sent",
	[143] = "Frenzied Bloodlust",
	[144] = "Blood Awakening",
	[146] = "Shock Absorber",
	[147] = "Inspiration",
}

-- Gross
---@enum QuestStateParams
model.GamblingCategory = {
	TALISMAN_IN_ROLL = 0,
	TOTAL_TALISMAN_ROLLS = 1,
	MELDING_TYPE = 2,
	SKILL_ID = 3,
	JACKPOT = 4,
}

---@enum TicketType
model.TicketType = {
	QURIOUS = "QURIOUS",
	FRIEND = "FRIEND",
}

---@type Ticket
model.Ticket = {
	[model.TicketType.FRIEND] = {
		id = 68158506,
		points = 40,
	},

	[model.TicketType.QURIOUS] = {
		id = 68160308,
		points = 20,
	},
}

---@type QuestIdToMeldingUnlock
model.QuestIdToMeldingUnlock = {
	[0] = { model.MeldingName.NONE },
	[10302] = { model.MeldingName.REFLECTINGPOOL },
	[10503] = { model.MeldingName.HAZE },
	[10701] = { model.MeldingName.MOONBOW, model.MeldingName.WISPOFMYSTERY },
	[405600] = { model.MeldingName.AURORA, model.MeldingName.ANIMA },
	[405601] = { model.MeldingName.VIGOR },
}

---@enum MeldingNameToQuestId
model.MeldingNameToQuestId = {
	[model.MeldingName.NONE] = 0,
	[model.MeldingName.REFLECTINGPOOL] = 10302,
	[model.MeldingName.HAZE] = 10503,
	[model.MeldingName.MOONBOW] = 10701,
	[model.MeldingName.WISPOFMYSTERY] = 10701,
	[model.MeldingName.AURORA] = 405600,
	[model.MeldingName.ANIMA] = 405600,
	[model.MeldingName.VIGOR] = 405601,
}

---@type RandomMeldingMethodsByIndex
model.RandomMeldingMethodsByIndex = {
	[0] = model.MeldingName.WISPOFMYSTERY,
	[1] = model.MeldingName.ANIMA,
	[2] = model.MeldingName.VIGOR,
}

---@type DeterministicMeldingMethodsByIndex
model.DeterministicMeldingMethodsByIndex = {
	[0] = model.MeldingName.REFLECTINGPOOL,
	[1] = model.MeldingName.HAZE,
	[2] = model.MeldingName.MOONBOW,
	[3] = model.MeldingName.AURORA,
}

---@enum RandomMeldingMethodsToIndex
model.RandomMeldingMethodsToIndex = {
	[model.MeldingName.WISPOFMYSTERY] = 0,
	[model.MeldingName.ANIMA] = 1,
	[model.MeldingName.VIGOR] = 2,
}

---@enum DeterministicMeldingMethodsToIndex
model.DeterministicMeldingMethodsToIndex = {
	[model.MeldingName.REFLECTINGPOOL] = 0,
	[model.MeldingName.HAZE] = 1,
	[model.MeldingName.MOONBOW] = 2,
	[model.MeldingName.AURORA] = 3,
}

---@type MeldingNameParams
model.MeldingNameParams = {
	[model.MeldingName.REFLECTINGPOOL] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 10,
		required_points = 100,
		melding_type = model.MeldingType.DETERMINISTIC,
		max_talisman_in_roll = 1,
		max_rolls = 3,
		mh_melding_id = 0,
		unlock_quest = 10302,
	},

	[model.MeldingName.HAZE] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 40,
		required_points = 100,
		melding_type = model.MeldingType.DETERMINISTIC,
		max_talisman_in_roll = 3,
		max_rolls = 3,
		mh_melding_id = 1,
		unlock_quest = 10503,
	},

	[model.MeldingName.MOONBOW] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 150,
		required_points = 100,
		melding_type = model.MeldingType.DETERMINISTIC,
		max_talisman_in_roll = 3,
		max_rolls = 3,
		mh_melding_id = 2,
		unlock_quest = 10701,
	},

	[model.MeldingName.WISPOFMYSTERY] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 150,
		required_points = 100,
		melding_type = model.MeldingType.RANDOM,
		max_talisman_in_roll = 3,
		max_rolls = 5,
		mh_melding_id = 3,
		unlock_quest = 10701,
	},

	[model.MeldingName.AURORA] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 300,
		required_points = 200,
		melding_type = model.MeldingType.DETERMINISTIC,
		max_talisman_in_roll = 3,
		max_rolls = 5,
		mh_melding_id = 7,
		unlock_quest = 405600,
	},

	[model.MeldingName.ANIMA] = {
		ticket_type = model.TicketType.FRIEND,
		points_per_talisman = 200,
		required_points = 200,
		melding_type = model.MeldingType.RANDOM,
		max_talisman_in_roll = 5,
		max_rolls = 5,
		mh_melding_id = 5,
		unlock_quest = 405600,
	},

	[model.MeldingName.VIGOR] = {
		ticket_type = model.TicketType.QURIOUS,
		points_per_talisman = 40,
		required_points = 600,
		melding_type = model.MeldingType.RANDOM,
		max_talisman_in_roll = 5,
		max_rolls = 5,
		mh_melding_id = 8,
		unlock_quest = 405601,
	},
}

---@enum MeldingNameToMeldingType
model.MeldingNameToMeldingType = {
	[model.MeldingName.REFLECTINGPOOL] = model.MeldingType.DETERMINISTIC,
	[model.MeldingName.HAZE] = model.MeldingType.DETERMINISTIC,
	[model.MeldingName.MOONBOW] = model.MeldingType.DETERMINISTIC,
	[model.MeldingName.AURORA] = model.MeldingType.DETERMINISTIC,
	[model.MeldingName.WISPOFMYSTERY] = model.MeldingType.RANDOM,
	[model.MeldingName.ANIMA] = model.MeldingType.RANDOM,
	[model.MeldingName.VIGOR] = model.MeldingType.RANDOM,
}

---@type MeldingTypeToMeldingName
model.MeldingTypeToMeldingName = {
	[model.MeldingType.DETERMINISTIC] = {
		model.MeldingName.REFLECTINGPOOL,
		model.MeldingName.HAZE,
		model.MeldingName.MOONBOW,
		model.MeldingName.AURORA,
	},
	[model.MeldingType.RANDOM] = {
		model.MeldingName.WISPOFMYSTERY,
		model.MeldingName.ANIMA,
		model.MeldingName.VIGOR,
	},
}

---@enum MeldingNameToMhId
model.MeldingNameToMhId = {
	[model.MeldingName.REFLECTINGPOOL] = 0,
	[model.MeldingName.HAZE] = 1,
	[model.MeldingName.MOONBOW] = 2,
	[model.MeldingName.WISPOFMYSTERY] = 3,
	[model.MeldingName.ANIMA] = 5,
	[model.MeldingName.AURORA] = 7,
	[model.MeldingName.VIGOR] = 8,
}

---@enum MeldingNameToBtIndex
model.MeldingNameToBtIndex = {
	[model.MeldingName.REFLECTINGPOOL] = 1,
	[model.MeldingName.HAZE] = 2,
	[model.MeldingName.MOONBOW] = 3,
	[model.MeldingName.WISPOFMYSTERY] = 4,
	[model.MeldingName.ANIMA] = 5,
	[model.MeldingName.AURORA] = 6,
	[model.MeldingName.VIGOR] = 7,
}

---@type MhIdToMeldingName
model.MhIdToMeldingName = {
	[0] = model.MeldingName.REFLECTINGPOOL,
	[1] = model.MeldingName.HAZE,
	[2] = model.MeldingName.MOONBOW,
	[3] = model.MeldingName.WISPOFMYSTERY,
	[5] = model.MeldingName.ANIMA,
	[7] = model.MeldingName.AURORA,
	[8] = model.MeldingName.VIGOR,
}

---@type MeldingNameArray
model.MeldingNameArray = {
	[1] = model.MeldingName.REFLECTINGPOOL,
	[2] = model.MeldingName.HAZE,
	[3] = model.MeldingName.MOONBOW,
	[4] = model.MeldingName.WISPOFMYSTERY,
	[5] = model.MeldingName.ANIMA,
	[6] = model.MeldingName.AURORA,
	[7] = model.MeldingName.VIGOR,
}

return model
