local item = {}

---@class ItemUtils
---@field add_to_itembox fun(item_id:integer, quantity: integer): nil
---@field get_item_box fun(): nil
---@field add_village_points fun(quantity: integer): nil

---@param data_manager table<sdk.get_managed_singleton("snow.data.DataManager")>
---@return ItemUtils
function item.new(data_manager)
  ---@type ItemUtils
  local instance = {}

  ---@param item_id integer No safeguard, verify id actually exists
  ---@param quantity integer
  ---@return nil
  --- Adds items to the itembox
  function instance.add_to_itembox(item_id, quantity)
    local item_box = item.get_item_box(data_manager)
    item_box:call('tryAddGameItem(snow.data.ContentsIdSystem.ItemId, System.Int32)', item_id, quantity)
  end

  ---@return any Item Box Instance
  function instance.get_item_box()
    return data_manager:call('get_PlItemBox')
  end

  ---@params quantity integer
  ---@reutrn nil
  function instance.add_village_points(quantity)
    local village_point_data = data_manager:call('get_VillagePointData')
    village_point_data:call('addPoint', quantity)
  end
end

return item
