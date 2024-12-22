# conf.nvim

Simple machine-, project- and command-level configuration for Neovim in Lua.

## The problem

This plugin tries to fix **as simply as possible** an issue I had with configuring Neovim, which is
that I wanted to be able to define simple configuration options at various levels:

- the machine level, e.g. if I use my Neovim configuration on a machine without logging in with
  GitHub, I want to disable the Copilot-related plugins on that machine
- the project level, e.g. if I work on a project that uses a different code formatter, I want to
  disable my formatter or change it
- the command level, e.g. to start Neovim in "light mode" (basically without any external
  dependenncies) on-the-fly, without having to create a new configuration file

Besides, I wanted to do this with Lua, as I like this language and it is powerful-enough and yet
very efficient!

## The solution

When the plugin is setup,the following steps happen:

- First, the plugin looks for a default Neovim configuration file (in `lua/default-nvim-config.lua`
  by default) in the Neovim configuration directory (`~/.config/nvim` by default). If found, this
  file is **securely** sourced, and its output is used to define the Neovim configuration.

- Then, the plugin looks for a global Neovim configuration file (in `lua/global-nvim-config.lua` by
  default) in the Neovim configuration directory (`~/.config/nvim` by default). If found, this file
  is **securely** sourced, and its output is used to update the Neovim configuration.

- Then, the plugin looks for a project-specific Neovim configuration file (named `.nvim.lua` by
  default) in the current working directory and all its parent directories until the home directory.
  If found, this file, again, is **securely** sourced, and its output is used to update the Neovim
  configuration.

- Finally, the plugin looks for environment variables starting with a prefix (`NVIM_` by default),
  and if found, it adds them with their values to the Neovim configuration.

This system is simple but flexible-enough for me to configure Neovim in a way that suits my needs.
Besides, since it relies on sourcing Lua files, it supports executing arbitrary Lua code, like
creating commands or setting environment variables at machine- or project-level.

Usually, I Git-ignore the global and project-specific configuration files, and only my default
Neovim configuration is versioned, so that the Neovim configuration doesn't pollute any project I'm
working on.

## Installation

To install the plugin, you can use your favorite plugin manager, for example
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cjumel/conf.nvim",
  lazy = true,
  opts = {
  default_nvim_config = {
      ...  -- Your custom configuration goes here, e.g. `light_mode = false`
    },
  }
}
```

<details>
<summary>Default configuration</summary>

```lua
 {
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
```

</details>

Then, in your configuration of Neovim, you can use the `conf.nvim` Neovim configuration options
simply with `require("conf").get(...)` (e.g. `light_mode=require("conf").get("light_mode")`, and the
configuration value will be automatically udpated with any of the `conf.nvim` configuration file or
environment variables you use.

## Known issue

When using `require("conf").get` inside `lazy.nvim` plugin specification field like `cond` (which is
one of its main usecases for me), `lazy.nvim` hasn't setup the plugin yet, so the setup is called
manually by the plugin function. For this reason, if one wants to use other options than the default
config, one needs to pass them to `get` at this moment (which is quite cumbersome). Hence, to
benefit from this usecase, I recommand sticking to the default configuration.
