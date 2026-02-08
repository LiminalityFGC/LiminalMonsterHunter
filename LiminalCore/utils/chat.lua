local chat = {}

chat.DisplayWindow = {
  RIGHT_NOTIFICATION = 2289944406,
}

local cached_instance = nil

---@param chat_manager
---@return table
function chat.new(chat_manager)
  local instance = {}

  ---@param location DisplayWindow
  ---@param message string
  function instance.print(location, message)
    chat_manager:call('reqAddChatInfomation', location, message)
  end

  return instance
end

function chat.get_instance(chat_manager)
  if cached_instance == nil then
    cached_instance = chat.new(chat_manager)
  end

  return cached_instance
end

function chat.invalidate_cache()
  cached_instance = nil
end
