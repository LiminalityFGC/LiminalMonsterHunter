local quest = {}

quest.Rank = {
  LOW = 'LOW',
  HIGH = 'HIGH',
  MASTER = 'MASTER',
}

quest.RankArray = {
  [0] = quest.Rank.LOW,
  [1] = quest.Rank.HIGH,
  [2] = quest.Rank.MASTER,
}

---@enum QuestStateParams
quest.QuestStateParams = {
  quest_rank_level = 'getQuestRank_Lv',
  quest_ex_level = 'getQuestLvEx',
  quest_level = 'getQuestLv',
  is_mystery = 'isMysteryQuest',
  is_random_mystery = 'isRandomMysteryQuest',
  is_tour_quest = 'isTourQuest',
  is_zako_target_quest = 'isZakoTargetQuest',
}

local cached_instance = nil

---@param quest_manager
---@return table
function quest.new(quest_manager)
  local quest_values = {}

  for key, value in pairs(quest.QuestStateParams) do
    quest_values[key] = quest_manager:call(value)
  end

  local instance = {}

  ---@return quest.Rank
  function instance.get_rank()
    return quest.RankArray[quest_values.quest_rank_level]
  end

  ---@return boolean
  function instance.is_qualifying()
    return (not quest_values.is_tour_quest and not quest_values.is_zako_target_quest)
  end

  ---@return table
  function instance.get_values()
    return quest_value
  end

  return instance
end

function quest.get_instance(quest_manager)
  if cached_instance == nil then
    cached_instance = quest.new(quest_manager)
  end

  return cached_instance
end

function quest.invalidate_cache()
  cached_instance = nil
end

---@param quest_id integer
---@return boolean
function is_quest_clear(progress_quest_manager)
  return progress_quest_manager:call('isClear', quest_id)
end

return quest
