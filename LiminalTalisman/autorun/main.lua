local config_path = "talisman_config.json"

math.randomseed(os.time())

local core = require("LiminalCore.models.CoreModels")
local language = core.Language
local quest_state_params = core.QuestStateParams

local model = require("models.talisman_models")
local qualifying_quest_list = model.QualifyingQuestList
local melding_name = model.MeldingName
local melding_type = model.MeldingType
local quest_id_to_melding_unlock = model.QuestIdToMeldingUnlock
local melding_name_params = model.MeldingNameParams
local melding_name_to_mh_id = model.MeldingNameToMhId
local gambling_category = model.GamblingCategory
local melding_name_to_skill_ids = model.MeldingNameToSkillIds

local ticket = model.Ticket

-- move these into a table idiot
local GIVE_TALISMAN = false
local quest_params = {}

---@return void
local function load_config()
	local config_file = json.load_file(config_path)
	if config_file then
		config = config_file
	else
		config = {
			max_deterministic_melding_method = melding_name.NONE,
			max_random_melding_method = melding_name.NONE,
			hunter_rank = 1,
			master_rank = 1,
		}
	end
end

---@return TalismanReward
local function default_talisman_reward()
	return {
		total_talisman_rolls = 0,
		rolls = 0,
		deterministic_skill_id = 1,
		melding_name = melding_name.NONE,
		melding_type = melding_type.DETERMINISTIC,
		ticket_type_id = 0,
		tickets_per_talisman = 0,
		points_per_talisman = 0,
		required_points = 0,
	}
end

-- gross
local talisman_reward = default_talisman_reward()

---@return void
local function write_config()
	json.dump_file(config_path, config)
end

---@return void
local function update_config(updates)
	for k, v in pairs(updates) do
		config[k] = v
	end
	write_config()
end

-- init managers
local quest_manager, facility_manager, enemy_manager, message_manager
local player_manager, progress_manager, progress_quest_manager

---@return void
local function init_singletons()
	if not quest_manager then
		quest_manager = sdk.get_managed_singleton("snow.QuestManager")
	end

	if not facility_manager then
		facility_manager = sdk.get_managed_singleton("snow.data.FacilityDataManager")
	end

	if not enemy_manager then
		enemy_manager = sdk.get_managed_singleton("snow.enemy.EnemyManager")
	end

	if not message_manager then
		message_manager = sdk.get_managed_singleton("snow.gui.MessageManager")
	end

	if not player_manager then
		player_manager = sdk.get_managed_singleton("snow.player.PlayerManager")
	end

	if not progress_manager then
		progress_manager = sdk.get_managed_singleton("snow.progress.ProgressManager")
	end

	if not progress_quest_manager then
		progress_quest_manager = sdk.get_managed_singleton("snow.progress.quest.ProgressQuestManager")
	end
end

---@return void
local function create_chat()
	local chat_manager = sdk.get_managed_singleton("snow.gui.ChatManager")

	local quantity = math.min(talisman_reward.quantity * talisman_reward.total_talisman_rolls, 10)
	local name = talisman_reward.melding_name
	local message = "<COL YELLOW> " .. quantity .. " talisman" .. "\nmade with: " .. name .. "</COL YELLOW>"
	chat_manager:call("reqAddChatInfomation", message, 2289944406)
end

---@return hunter_rank integer
---@return master_rank integer
local function get_player_rank()
	local hunter_rank = math.max(progress_manager:call("get_HunterRank"), 1)
	local master_rank = math.max(progress_manager:call("get_MasterRank"), 1)

	return hunter_rank, master_rank
end

---@param quest_id integer
---@return boolean
local function is_quest_clear(quest_id)
	return progress_quest_manager:call("isClear", quest_id)
end

---@return MeldingName max_deterministic
---@return MeldingName max_random
local function get_player_melding_methods()
	local max_deterministic, max_random = melding_name.NONE, melding_name.NONE

	for _, quest_id in pairs(qualifying_quest_list) do
		if is_quest_clear(quest_id) then
			local melding_methods = quest_id_to_melding_unlock[quest_id]

			for _, melding_method in pairs(melding_methods) do
				if melding_name_params[melding_method].melding_type == melding_type.DETERMINISTIC then
					max_deterministic = melding_method
				else
					max_random = melding_method
				end
			end
		end
	end

	return max_deterministic, max_random
end

---@void
local function toggle_rewards()
	GIVE_TALISMAN = not GIVE_TALISMAN
end

---@return void
local function update_player_progress()
	config.max_deterministic_melding_method, config.max_random_melding_method = get_player_melding_methods()
	config.hunter_rank, config.master_rank = get_player_rank()

	write_config()
end

---@return QuestParams
local function init_quest_params()
	quest_params = {}
	for key, value in pairs(quest_state_params) do
		quest_params[key] = quest_manager:call(value)
	end
end

---@return boolean
local function is_qualifying_quest()
	return (not quest_params.is_tour_quest and not quest_params.is_zako_target_quest)
end

---@param category GamblingCategory
---@return boolean
local function roll_for(category)
	local quest_level = quest_params.quest_level + 1
	local quest_rank = quest_params.quest_rank_level + 1
	local progress_multiplier = 1 + (config.hunter_rank / 200) + (config.master_rank / 200)

	local chance
	local out_of

	local category_functions = {
		[gambling_category.JACKPOT] = function()
			chance = quest_level * quest_rank * 0.5 * progress_multiplier
			out_of = math.random(100)
			return chance > out_of
		end,
		[gambling_category.TOTAL_TALISMAN_ROLLS] = function()
			chance = quest_level * quest_rank * math.random(4) * progress_multiplier
			out_of = math.random(25, 100 - quest_level - quest_rank)
			return chance > out_of
		end,
		[gambling_category.MELDING_TYPE] = function()
			chance = 80
			out_of = math.random(100)
			return chance > out_of
		end,
		[gambling_category.SKILL_ID] = function()
			local skill_ids = melding_name_to_skill_ids[talisman_reward.melding_name]

			return skill_ids[math.random(#skill_ids)]
		end,
	}

	return category_functions[category]()
end

---@param gambling_category GamblingCategory
---@param min integer
---@param max integer
---@return integer
local function roll_for_many(gambling_category, min, max)
	if max - min < 0 then
		return min
	end

	local collector = min

	for i = 1, max - 1 do
		if roll_for(gambling_category) then
			collector = collector + 1
		end
	end

	return collector
end

---@param deterministic_melding_name MeldingName
---@param random_melding_name MeldingName
---
local function update_talisman_reward(deterministic_melding_name, random_melding_name)
	local is_random = false

	if deterministic_melding_name ~= melding_name.NONE and random_melding_name ~= melding_name.NONE then
		is_random = roll_for(gambling_category.MELDING_TYPE)
	end

	local reward_type = is_random and melding_type.RANDOM or melding_type.DETERMINISTIC

	talisman_reward.melding_name = is_random and random_melding_name or deterministic_melding_name
	talisman_reward.melding_type = reward_type
	talisman_reward.total_talisman_rolls = melding_name_params[talisman_reward.melding_name].max_rolls
	talisman_reward.quantity = melding_name_params[talisman_reward.melding_name].max_talisman_in_roll
end

local function filter_valid_melding_names()
	local deterministic_melding_method = config.max_deterministic_melding_method
	local random_melding_method = config.max_random_melding_method

	-- if the player is doing low rank, but has unlocked reflecting pool, give it to them
	if quest_params.quest_rank_level == 0 and config.max_deterministic_melding_method ~= melding_name.NONE then
		deterministic_melding_method = melding_name.REFLECTINGPOOL
	end

	-- if the player is doing highrank, give them the deterministic melding method for their quest level
	if quest_params.quest_rank_level == 1 then
		if quest_params.quest_level < 5 then
			deterministic_melding_method = melding_name.REFLECTINGPOOL
		end

		deterministic_melding_method = melding_name.HAZE
	end

	-- if the player is doing 4 star and below quests in master rank, give them the appropriate early master rank melding methods
	if quest_params.quest_rank_level == 2 and quest_params.quest_level <= 3 then
		deterministic_melding_method = melding_name.MOONBOW
		random_melding_method = melding_name.WISPOFMYSTERY
	end

	if deterministic_melding_method == melding_name.NONE and random_melding_method == melding_name.NONE then
		return
	end

	update_talisman_reward(deterministic_melding_method, random_melding_method)
end

local function compute_tickets_per_roll()
	local ticket_type = melding_name_params[talisman_reward.melding_name].ticket_type
	local points_per_talisman = melding_name_params[talisman_reward.melding_name].points_per_talisman
	local points_per_ticket = ticket[ticket_type].points
	local required_points = melding_name_params[talisman_reward.melding_name].required_points

	talisman_reward.required_points = required_points
	talisman_reward.points_per_talisman = points_per_talisman
	talisman_reward.ticket_type_id = ticket[ticket_type].id
	talisman_reward.tickets_per_talisman = math.ceil(points_per_talisman / points_per_ticket)
end

---@param data_manager
local function add_points(data_manager)
	local village_point_data = data_manager:call("get_VillagePointData")
	village_point_data:call("addPoint", talisman_reward.required_points)
end

---@param data_manager
local function add_tickets(data_manager)
	local item_box = data_manager:call("get_PlItemBox")
	local amount = talisman_reward.tickets_per_talisman * talisman_reward.quantity
	local id = talisman_reward.ticket_type_id

	item_box:call("tryAddGameItem(snow.data.ContentsIdSystem.ItemId, System.Int32)", id, amount)
end

local function refill_resources()
	local data_manager = sdk.get_managed_singleton("snow.data.DataManager")
	add_points(data_manager)
	add_tickets(data_manager)
end

---@param alchemy
---@param index integer
local function swap_talismans(alchemy, index)
	local alchemy_function = alchemy:call("get_Function")
	local reserve_info_list = alchemy_function:get_field("_ReserveInfoList")
	local array = reserve_info_list:call("ToArray")

	if index >= #array then
		index = #array - 1
	end

	local temp = array:get_element(0)

	array:call("SetValue", array:get_element(index), 0)
	for i = 1, index do
		local curr = array:get_element(i)
		array:call("SetValue", temp, i)
		temp = curr
	end

	reserve_info_list:call("Clear")
	reserve_info_list:call("AddRange", array)
end

---@param retval
local function add_talismans_to_pot(retval)
	if not GIVE_TALISMAN then
		return
	end

	local alchemy = facility_manager:call("getAlchemy")
	local slots = alchemy:call("getRemainingSlotNum")
	local ticket_quantity = talisman_reward.tickets_per_talisman
	local ticket_type_id = talisman_reward.ticket_type_id
	local melding_method = talisman_reward.melding_name

	for i = 1, talisman_reward.total_talisman_rolls * talisman_reward.quantity do
		if slots > 0 then
			slots = slots - 1
			refill_resources()

			local list = alchemy:call("getPatturnDataList")
			local list_array = list:call("ToArray")
			local pattern = list_array[melding_name_to_mh_id[melding_method]]
			alchemy:call("selectPatturn", pattern)
			alchemy:call("addUsingItem", ticket_type_id, ticket_quantity)
			alchemy:call("reserveAlchemy")
			if slots < 9 then
				swap_talismans(alchemy, 10 - slots - 1)
			end
			alchemy:call("invokeCycleMethod")
			alchemy:call("resetUsingItem")
		end
	end
	toggle_rewards()
	return retval
end

local function dealer()
	local min = 1
	local max = talisman_reward.total_talisman_rolls + 1
	talisman_reward.total_talisman_rolls = roll_for_many(gambling_category.TOTAL_TALISMAN_ROLLS, min, max)
end

local function check_rewards_on_quest_complete(retval)
	if GIVE_TALISMAN then
		return
	end

	init_singletons()
	init_quest_params()
	update_player_progress()

	if config.hunter_rank < 3 then
		return
	end

	if not quest_params then
		return
	end

	if not is_qualifying_quest() then
		return
	end

	filter_valid_melding_names()

	dealer()

	-- Compute tickets
	compute_tickets_per_roll()

	-- And yell about it
	create_chat()

	toggle_rewards()
end

sdk.hook(
	sdk.find_type_definition("snow.QuestManager"):get_method("setQuestClear"),
	function(args) end,
	check_rewards_on_quest_complete
)

sdk.hook(
	sdk.find_type_definition("snow.QuestManager"):get_method("setQuestClearSub"),
	function(args) end,
	check_rewards_on_quest_complete
)

sdk.hook(
	sdk.find_type_definition("snow.SnowSessionManager"):get_method("_onSucceedQuickQuest"),
	function(arg) end,
	check_rewards_on_quest_complete
)

sdk.hook(
	sdk.find_type_definition("snow.data.FacilityDataManager"):get_method("executeCycle"),
	function(args) end,
	add_talismans_to_pot
)

load_config()
