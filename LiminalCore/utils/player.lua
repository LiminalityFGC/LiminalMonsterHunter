local player = {}

---@return hunter_rank integer
---@return master_rank integer
function player.get_player_rank()
  local hunter_rank = math.max(progress_manager:call('get_HunterRank'), 1)
  local master_rank = math.max(progress_manager:call('get_MasterRank'), 1)

  return hunter_rank, master_rank
end

return player
