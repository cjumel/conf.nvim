local commands = require("conf.commands")
local nvim_config = require("conf.nvim_config")

local M = {}

-- NOTE: we might want to call `get` before package managers, like lazy.nvim, call `setup`, for
-- instance when using `get` inside the `cond` field of a lazy.nvim plugin specification so we have
-- to make sure the `setup` is called anyway (and preferably only once). Also for this reason,
-- to avoid the need to pass plugin options everytime we call `get`, let's not implement any options
-- for now.

local is_setup = false

function M.setup()
  if is_setup then
    return
  end

  nvim_config.setup()
  commands.setup()
  is_setup = true
end

function M.get(key)
  M.setup()
  return nvim_config.get_config(key)
end

return M
