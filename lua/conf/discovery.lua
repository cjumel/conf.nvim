local M = {}

local function discover_default_nvim_config()
  local config = require("conf.config")
  local nvim_config_path = vim.fn.stdpath("config") .. "/" .. config.default_config_path
  local nvim_config_code = vim.secure.read(nvim_config_path)
  if nvim_config_code ~= nil then -- Configuration file is found and trusted
    return load(nvim_config_code)()
  end
end

local function discover_global_nvim_config()
  local config = require("conf.config")
  local nvim_config_path = vim.fn.stdpath("config") .. "/" .. config.global_config_path
  local nvim_config_code = vim.secure.read(nvim_config_path)
  if nvim_config_code ~= nil then -- Configuration file is found and trusted
    return load(nvim_config_code)()
  end
end

local function discover_project_nvim_config()
  local config = require("conf.config")
  -- Look for the project configuration file from the current working directory upward until the
  -- home directory
  local nvim_config_path =
    vim.fn.findfile(config.project_config_name, vim.fn.getcwd() .. ";" .. vim.env.HOME)
  if nvim_config_path ~= "" then -- Configuration file is found
    local nvim_config_code = vim.secure.read(nvim_config_path)
    if nvim_config_code ~= nil then -- Configuration file is trusted
      return load(nvim_config_code)()
    end
  end
end

local function discover_env_nvim_config()
  local config = require("conf.config")
  local nvim_conf = {}
  for _, key in ipairs(vim.tbl_keys(config.default_nvim_config)) do
    local value = vim.env[config.env_var_prefix .. string.upper(key)]
    if value ~= nil then
      if vim.tbl_contains({ "1", "true" }, string.lower(value)) then
        nvim_conf[key] = true
      elseif vim.tbl_contains({ "0", "false" }, string.lower(value)) then
        nvim_conf[key] = false
      elseif string.find(value, ",") then
        nvim_conf[key] = vim.split(value, ",")
      else
        nvim_conf[key] = value
      end
    end
  end
  return nvim_conf
end

function M.discover_nvim_config()
  local nvim_config = discover_default_nvim_config() or {}
  nvim_config = vim.tbl_extend("force", nvim_config, discover_global_nvim_config() or {})
  nvim_config = vim.tbl_extend("force", nvim_config, discover_project_nvim_config() or {})
  nvim_config = vim.tbl_extend("force", nvim_config, discover_env_nvim_config() or {})
  return nvim_config
end

return M
