local default_config = {
  -- The name of the project-level configuration file
  project_config_name = ".nvim.lua",
  -- The name of the global configuration file
  global_config_name = ".nvim-global.lua",
  -- The prefix for environment variables to discover as Neovim configuration
  env_var_prefix = "NVIM_",
  -- The default Neovim configuration
  default_nvim_config = {},
}

local M = vim.deepcopy(default_config)

function M.setup(opts)
  opts = opts or {}

  local new_config = vim.tbl_extend("force", default_config, opts)
  for k, v in pairs(new_config) do
    M[k] = v
  end
end

return M
