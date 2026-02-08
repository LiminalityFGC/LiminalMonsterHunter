local config = {}

---@param config_path string
---@param config_values table<string, any>
---@return config_file file*|nil
function config.create(config_path, config_values)
  config_file = io.open(config_path, 'w')
  config.write(config_path, config_values)
  config_file:close()
end

---@param config_path string
---@param config_values table<string, any>
---@return config_values table<string, any>
function config.load_or_create(config_path, config_values)
  local config_file = io.open(config_path, 'r')

  if config_file ~= nil then
    config.create(config_path, config_values)
    return config_values
  end

  return config.load(config_path)
end

---@param config_path string
---@return config_values table<string, any>
function config.load(config_path)
  return json.load_file(config_path)
end

---@param config_path string
---@param config_values table<string, any>
---@return void
function config.write(config_path, config_values)
  json.dump_file(config_path, config_values)
end

return config
