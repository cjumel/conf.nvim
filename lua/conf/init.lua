local M = {}

-- We might want to call functions like `get` before lazy.nvim calls `setup`, for instance when
-- using `get` inside the `cond` field of a lazy.nvim plugin specification. To make sure the
-- configurations are discovered when calling `get`, let's call `setup` inside the `get` function
-- (and the other similar ones). To avoid additional computation, let's make sure the `setup` is
-- always actually performed only once anyway.

local is_setup = false
local nvim_config = {}

function M.setup(opts)
  if is_setup then
    return
  end

  local config = require("conf.config")
  config.setup(opts)

  local discovery = require("conf.discovery")
  for k, v in pairs(discovery.discover_nvim_config()) do
    nvim_config[k] = v
  end

  is_setup = true
end

function M.get(key, opts)
  M.setup(opts)
  return nvim_config[key]
end

function M.get_nvim_config(opts)
  M.setup(opts)
  return nvim_config
end

return M
