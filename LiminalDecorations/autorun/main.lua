math.randomseed(os.time())

local quest = require('LiminalCore.utils.quest')
local core = require('LiminalCore.models.CoreModels')
local log = require('LiminalCore.utils.log')
local player = require('LiminalCore.utils.player')
local chat_session = require('LiminalCore.utils.chat')

-- Decorations Models
local model = require('models.decoration_models')
local decoration_category = model.DecorationCategory

-- Config
local config_default_values = {
    hunter_rank: 1,
    master_rank: 1,
}

local config_path = 'liminal_decorations.json'
local configuration = require('LiminalCore.utils.config')
local config = configuration.load_or_create(config_path, config_default_values)

-- Globals
local current_quest = nil
local current_chat = nil

-- Singletons 
local quest_manager, facility_manager, enemy_manager, message_manager, chat_manager
local player_manager, progress_manager, progress_quest_manager, data_manager

---@return nil 
local function init_singletons()
  if not quest_manager then
    quest_manager = sdk.get_managed_singleton('snow.QuestManager')
  end

  if not chat_manager then
    chat_manager = sdk.get_managed_singleton('snow.gui.ChatManager')
  end

  if not facility_manager then
    facility_manager = sdk.get_managed_singleton('snow.data.FacilityDataManager')
  end

  if not enemy_manager then
    enemy_manager = sdk.get_managed_singleton('snow.enemy.EnemyManager')
  end

  if not message_manager then
    message_manager = sdk.get_managed_singleton('snow.gui.MessageManager')
  end

  if not player_manager then
    player_manager = sdk.get_managed_singleton('snow.player.PlayerManager')
  end

  if not data_manager then
    data_manager = sdk.get_managed_singleton('snow.data.DataManager')
  end

  if not progress_manager then
    progress_manager = sdk.get_managed_singleton('snow.progress.ProgressManager')
  end

  if not progress_quest_manager then
    progress_quest_manager = sdk.get_managed_singleton('snow.progress.quest.ProgressQuestManager')
  end
end


---@param category DecorationCategory
---@param chance integer
---@return boolean 
local function roll_for(category, chance)

  local progress_multiplier = 1 + (config.hunter_rank / 200) + (config.master_rank / 200)
  local out_of = math.random(100)

  local category_functions = {
    [decoration_category.NORMAL] = function()
      chance = chance * progress_multiplier
      return chance > out_of
    end,
    [decoration_category.RAMPAGE] = function()
      chance = chance * progress_multiplier
      return chance > out_of
    end,
  }

  return category_functions[category]()
end


---@param gambling_category DecorationCategory
---@param odds table 
---@return quantity integer
local function roll_for_many(gambling_category, odds)

  local quantity = odds.min
  local rolls = odds.max - odds.min

  for i = 1, rolls do
    if roll_for(gambling_category, odds.chance) then
      quantity = quantity + 1
    end
  end

  return quantity 
end

---@return nil 
local function get_gambling_quantity()

  local generation_table = {}
  local quest_rank = current_quest.get_rank()

  ---@param category DecorationCategory
  ---@return quantity integer
  local function gamble(category)
    local odds = model.RankTypeToDecorationCategoryOdds[quest_rank][category]
    return roll_for_many(category, odds)
  end

  for _, category in pairs(model.DecorationCategory) do
    generation_table[category].quantity = gamble(category)
  end

  return generation_table
end

---@return nil 
local function update_player_progress()
  config.hunter_rank, config.master_rank = player.get_player_rank()
  config.write(config_path, configuration)
end


---@param category DecorationCategory
---@param quantity integer
---@param quest_rank RankType
---@return nil 
local function roll_for_decorations(category, quantity, quest_rank)

  if not quantity then
    return
  end

  local decoration_values = {}
  local decoration_table_by_rank =  model.DecorationTableByRank[category]
  local decoration_table = decoration_table_by_rank[quest_rank]

  for i = 1, quantity do
    local decoration_id = math.random(1, #decoration_table)
    table.insert(decoration_values.ids, decoration_id)
    table.insert(decoration_values.mh_index, decoration_table[decoration_id].mh_index)
    table.insert(decoration_values.name, decoration_table[decoration_id].name)
  end

  return decoration_values 
end


---@param decoration_indexes table<integer>
---@return nil
function add_decorations_to_inventory(decoration_indexes)
  local item_box = data_manager:call('getDecorationsBox()')

  for i = 1, #decoration_indexes do
    data_manager:call('getDecorationsList()')
    item_box:call('tryAddGameItem(snow.equip.DecorationsId, System.Int32)', decoration_indexes[i], 1)
  end
end


---@param decoration_values table 
---@return nil
function generate_chat_messages(decoration_values) 
  for _, category in pairs(model.DecorationCategory) do
    generate_chat_message(category, decoration_values)
  end
end


---@param category DecorationCategory 
---@param decoration_values table 
---@return nil
function generate_chat_message(category, decoration_values)

  local quantity_headers = {
    [decoration_category.NORMAL] = { [0] = 'Normal Decorations found: ' },
    [decoration_category.RAMPAGE] = { [0] = 'Rampage Decorations found: ' },
  }

  local category_message = {}
  local pair_buffer = {}

  table.insert(category_message[category], quantity_headers[category])
  table.insert(category_message[category], tostring(quantity) .. '\n')

  for i = 1, #decoration_values[category].ids do
    table.insert(pair_buffer, decoration_values[category].name[i])

    if #pair_buffer == 2 then
      table.insert(category_message[category], '-' .. pair_buffer[1] .. ', ' .. pair_buffer[2] .. '\n')

      pair_buffer = {}
    end
  end

  if pair_buffer == 1 then
    table.insert(category_message[category], '-' .. pair_buffer[1] .. '\n')
  end

  chat_messages[category] = category_message[category]
end


---@return nil 
local function create_chat()
  for _, category in pairs(model.DecorationCategory) do
    if chat_messages[category] ~= nil then
      local message = table.concat(chat_messages[category])
      current_chat.print(chat.DisplayWindow.RIGHT_NOTIFICATION, message)
    end
  end
end


---@param quantity_table table
---@return decorations table 
local function get_decoration_generation_params(quantity_table)

  local decorations = {}
  local quest_rank = current_quest.get_rank()

  for _, category in pairs(model.DecorationCategory) do

    local quantity = quantity_table[category].quantity
    decorations[category] = roll_for_decorations(category, quantity, quest_rank)

    if quest_rank == RankType.MASTER then
      roll_for_decorations(model.DecorationCategory.NORMAL, 2, RankType.HIGH_RANK)
      roll_for_decorations(model.DecorationCategory.NORMAL, 2, RankType.LOW_RANK)
    end

    if quest_rank == RankType.HIGH_RANK then
      roll_for_decorations(model.DecorationCategory.NORMAL, 3, RankType.LOW_RANK)
    end
  end

  return decorations
end


---@return nil
local function generate_and_insert_decorations()
  local quantity_table = get_gambling_quantity()
  local decorations_table = get_decoration_generation_params(quantity_table)
  add_decorations_to_inventory(decorations_table)
end


---@param retval any
---@return nil 
local function check_rewards_on_quest_complete(retval)

  init_singletons()

  current_quest = quest.get_instance(quest_manager) 
  current_chat = chat_session.get_instance(chat_manager)

  if not current_quest.is_qualifying() then
    return
  end

  update_player_progress()
  generate_and_insert_decorations()
  generate_chat_messages()
  create_chat()

  current_quest.invalidate_cache()
  current_chat.invalidate_cache()

  current_quest = nil
  current_chat = nil
end

-- Hooks
sdk.hook(sdk.find_type_definition('snow.QuestManager'):get_method('setQuestClear'), function(args) end, check_rewards_on_quest_complete)

