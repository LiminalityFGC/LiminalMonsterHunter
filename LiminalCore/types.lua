
---@class QuestParams
---@field quest_rank_level integer
---@field quest_ex_level integer
---@field quest_level integer
---@field is_mystery boolean
---@field is_random_mystery boolean
---@field is_tour_quest boolean
---@field is_zako_target_quest boolean

---@class TalismanReward
---@field total_talisman_rolls integer
---@field skill_id integer
---@field melding_name MeldingName
---@field melding_type MeldingType
---@field ticket_type_id integer
---@field tickets_per_talisman integer
---@field points_per_talisman integer
---@field required_points integer
---@field quantity integer

---@class MeldingParams
---@field ticket_type TicketType
---@field points_per_talisman integer
---@field melding_type MeldingType
---@field max_talisman_in_roll integer
---@field max_rolls integer
---@field mh_melding_id integer
---@field unlock_quest integer
---@field required_points integer

---@class TicketInfo
---@field id integer
---@field points integer

---@alias DeterministicMeldingMethodsByIndex table<integer, MeldingName>
---@alias LanguageByIndex table<integer, string>
---@alias MeldingNameArray table<integer, MeldingName>
---@alias MeldingNameParams table<MeldingName, MeldingParams>
---@alias MeldingNameToSkillIds table<MeldingName, table<integer, integer>>
---@alias MeldingTypeToMeldingName table<MeldingType, MeldingName[]>
---@alias MhIdToMeldingName table<integer, MeldingName>
---@alias QuestIdToMeldingUnlock table<integer, MeldingName[]>
---@alias RandomMeldingMethodsByIndex table<integer, MeldingName>
---@alias SkillIdToName table<integer, string>
---@alias Ticket table<TicketType, TicketInfo>

---@class DecorationRewards
---@field low_rank_rolls integer
---@field high_rank_rolls integer
---@field master_rank_rolls integer

---@class MeldingParams
---@field ticket_type TicketType
---@field points_per_talisman integer
---@field melding_type MeldingType
---@field max_talisman_in_roll integer
---@field max_rolls integer
---@field mh_melding_id integer
---@field unlock_quest integer
---@field required_points integer

---@alias RampageDecorationsByRank table<integer, string>
---@alias DecorationsByRank table<integer, string>
---@alias UnluckyDecorations table<integer, string>
---@alias UnluckyRampageDecorations table<integer, string>
---@alias Decorations table<integer, string>
---@alias RampageDecorations table<integer, string>
