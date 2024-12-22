local M = {}

function M.get_default_config_path()
  return vim.fn.stdpath("config") .. "/lua/conf/default.lua"
end

local function get_default_config()
  local ok, default_config = pcall(require, "conf.default")
  if ok then
    return default_config or {}
  end
  return {}
end

function M.get_global_config_path()
  return vim.fn.stdpath("config") .. "/lua/conf/global.lua"
end

local function get_global_config()
  local ok, global_config = pcall(require, "conf.global")
  if ok then
    return global_config or {}
  end
  return {}
end

function M.get_project_config_path()
  local project_config_path = vim.fn.findfile(
    ".nvim.lua",
    vim.fn.getcwd() .. ";" .. vim.env.HOME -- Loof from the cwd upward until the home directory
  )
  -- Default to a configuration file in the cwd
  return project_config_path or vim.fn.getcwd() .. "/.nvim.lua"
end

local function get_project_config()
  local nvim_config_path = M.get_project_config_path()
  local nvim_config_code = vim.secure.read(nvim_config_path)
  if nvim_config_code ~= nil then -- Configuration file is found and trusted
    return load(nvim_config_code)() or {}
  end
  return {}
end

local function get_env_config()
  local env_nvim_conf = {}
  for _, k in ipairs(vim.tbl_keys(get_default_config())) do
    local v = vim.env["NVIM_" .. string.upper(k)]

    if v ~= nil then
      if vim.tbl_contains({ "1", "true" }, string.lower(v)) then
        env_nvim_conf[k] = true
      elseif vim.tbl_contains({ "0", "false" }, string.lower(v)) then
        env_nvim_conf[k] = false
      elseif string.find(v, ",") then
        env_nvim_conf[k] = vim.split(v, ",")
      else
        env_nvim_conf[k] = v
      end
    end
  end
  return env_nvim_conf
end

M.nvim_config = {}

function M.setup()
  local final_nvim_config = get_default_config()
  final_nvim_config = vim.tbl_extend("force", final_nvim_config, get_global_config())
  final_nvim_config = vim.tbl_extend("force", final_nvim_config, get_project_config())
  final_nvim_config = vim.tbl_extend("force", final_nvim_config, get_env_config())

  for k, v in pairs(final_nvim_config) do
    M.nvim_config[k] = v
  end
end

function M.get_config(key)
  if key == nil then
    return M.nvim_config
  else
    return M.nvim_config[key]
  end
end

return M
