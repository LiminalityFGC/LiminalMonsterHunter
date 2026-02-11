local chat = {}

chat.DisplayWindow = {
  RIGHT_NOTIFICATION = 2289944406,
}

---@class ChatUtils
---@field print fun(location: chat.DisplayWindow, message: string)

---@type ChatUtils|nil
local cached_instance = nil

---@param chat_manager table<sdk.get_managed_singleton("snow.gui.ChatManager")>
---@return ChatUtils
--- Factory function for chat utility
function chat.new(chat_manager)
  ---@type ChatUtils
  local instance = {}

  ---@param location DisplayWindow
  ---@param message string
  ---@return nil
  function instance.print(location, message)
    chat_manager:call('reqAddChatInfomation', message, location)
  end

  return instance
end

---@param chat_manager table<sdk.get_managed_singleton("snow.gui.ChatManager")>
---@return ChatUtils
function chat.get_instance(chat_manager)
  if cached_instance == nil then
    cached_instance = chat.new(chat_manager)
  end

  return cached_instance
end

---@return nil
function chat.invalidate_cache()
  cached_instance = nil
end

return chat
