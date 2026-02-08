---@param data_manager
local function add_points(data_manager)
  local village_point_data = data_manager:call('get_VillagePointData')
  village_point_data:call('addPoint', talisman_reward.required_points)
end

---@param data_manager
local function add_tickets(data_manager)
  local item_box = data_manager:call('get_PlItemBox')
  local amount = talisman_reward.tickets_per_talisman * talisman_reward.quantity
  local id = talisman_reward.ticket_type_id

  item_box:call('tryAddGameItem(snow.data.ContentsIdSystem.ItemId, System.Int32)', id, amount)
end

local function refill_resources()
  local data_manager = sdk.get_managed_singleton('snow.data.DataManager')
  add_points(data_manager)
  add_tickets(data_manager)
end
