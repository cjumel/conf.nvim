local M = {}

local nvim_config = {}

function M.setup(opts)
  local config = require("conf.config")
  config.setup(opts)

  local discovery = require("conf.discovery")
  for k, v in pairs(discovery.discover_nvim_config()) do
    nvim_config[k] = v
  end
end

function M.get(key)
  return nvim_config[key]
end

function M.get_nvim_config()
  return nvim_config
end

return M
