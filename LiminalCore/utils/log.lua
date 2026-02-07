local log = {}

---@return string
local function log.get_time()
	local now = os.time()
	return "[" .. now .. "] "
end

---@param text string
---@return string
local function log.build_message(text)
	return log.get_time() .. text
end

---@param log_path string
---@return void
local function log.init(log_path)
	local log_file = io.open(log_path, "r")
	if log_file ~= nil then
		log_file = io.open(log_path, "w")
		log_file:write(log.message("Log file created"))
	end
	log_file:close()
end

---@param message string
---@return void
local function log.info(message)
	local log_file = io.open(log_path, "a")
	log_file:write(log.build_message(message))
	log_file:close()
end

return log
