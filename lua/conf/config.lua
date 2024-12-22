local default_config = {
  -- The path were to look for the default Neovim configuration inside the Neovim configuration
  -- directory
  default_config_path = "lua/conf-default.lua",
  -- The path were to look for the global Neovim configuration inside the Neovim configuration
  -- directory
  global_config_path = "lua/conf-global.lua",
  -- The name to look for the project-level configuration file, from the current working directory
  -- upward until the home directory
  project_config_name = ".nvim.lua",
  -- The prefix for environment variables to consider as Neovim configuration
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
