local log = {}

---@return string
function log.get_time()
  local now = os.time()
  return '[' .. now .. '] '
end

---@param text string
---@return string
function log.build_message(text)
  return log.get_time() .. text
end

---@param log_path string
---@return void
function log.create(log_path)
  log_file = io.open(log_path, 'w')
  log.write(log_path)
  log_file:close()
end

---@param log_path string
---@return log_values table<string, any>
function log.init(log_path)
  local log_file = io.open(log_path, 'r')

  if log_file ~= nil then
    log.create(log_path)
  end
end

---@param message string
---@return void
function log.info(message)
  local log_file = io.open(log_path, 'a')
  log_file:write(log.build_message(message))
  log_file:close()
end

return log
