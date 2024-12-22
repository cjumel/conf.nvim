local nvim_config = require("conf.nvim_config")

local M = {}

function M.setup()
  vim.api.nvim_create_user_command("ConfViewConfig", function()
    local config = nvim_config.get_config()
    vim.notify(vim.inspect(config), vim.log.levels.INFO, { title = "conf.nvim" })
  end, { desc = "View the configuration" })
  vim.api.nvim_create_user_command("ConfOpenDefault", function()
    local path = nvim_config.get_default_config_path()
    vim.cmd("edit " .. path)
  end, { desc = "Open the default configuration file" })
  vim.api.nvim_create_user_command("ConfOpenGlobal", function()
    local path = nvim_config.get_global_config_path()
    vim.cmd("edit " .. path)
  end, { desc = "Open the global configuration file" })
  vim.api.nvim_create_user_command("ConfOpenProject", function()
    local path = nvim_config.get_project_config_path()
    vim.cmd("edit " .. path)
  end, { desc = "Open the project configuration file" })
end

return M
