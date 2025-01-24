local config = {}

for _, config_name in ipairs({ "default", "global" }) do
  local new_config_path = vim.fn.stdpath("config") .. "/.nvim-" .. config_name .. ".lua"
  if vim.fn.filereadable(new_config_path) == 1 then
    local new_config_code = table.concat(vim.fn.readfile(new_config_path), "\n")
    local new_config = load(new_config_code)()
    config = vim.tbl_deep_extend("force", config, new_config or {})
  end
end

local project_config_path = vim.fn.findfile(
  ".nvim.lua",
  vim.fn.getcwd() .. ";" .. vim.env.HOME -- Look from the cwd upward until the home directory
)
if project_config_path then
  local project_config_code = vim.secure.read(project_config_path)
  if project_config_code ~= nil then -- Configuration file is found and trusted
    local project_config = load(project_config_code)()
    config = vim.tbl_deep_extend("force", config, project_config or {})
  end
end

local env_config = {}
for _, k in ipairs(vim.tbl_keys(config)) do
  local v = vim.env["NVIM_" .. string.upper(k)]
  if v ~= nil then
    if vim.tbl_contains({ "1", "true" }, string.lower(v)) then
      env_config[k] = true
    elseif vim.tbl_contains({ "0", "false" }, string.lower(v)) then
      env_config[k] = false
    elseif string.find(v, ",") then
      env_config[k] = vim.split(v, ",")
    else
      env_config[k] = v
    end
  end
end
config = vim.tbl_deep_extend("force", config, env_config)

vim.api.nvim_create_user_command("ConfOpenDefault", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/conf/default.lua")
end, { desc = "Open the default configuration file" })
vim.api.nvim_create_user_command("ConfOpenGlobal", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/conf/global.lua")
end, { desc = "Open the global configuration file" })
vim.api.nvim_create_user_command("ConfOpenProject", function()
  vim.cmd("edit " .. project_config_path or vim.fn.getcwd() .. "/.nvim.lua")
end, { desc = "Open the project configuration file" })
vim.api.nvim_create_user_command("ConfViewConfig", function()
  vim.notify(vim.inspect(config), vim.log.levels.INFO, { title = "Neovim Configuration" })
end, { desc = "View the configuration" })

return config
