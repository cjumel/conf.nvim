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
  dependenncies) on-the-flye, without having to create a new configuration file

Besides, I wanted to do this with Lua, as I like this language and it is powerful-enough and yet
very efficient!

## The solution

When the plugin is initialized, the user defines a default Neovim configuration, then three steps
happen, corresponding to the 3 levels described above:

- First, the plugin looks for a global Neovim configuration file (named `.nvim-global.lua` by
  default) in the Neovim configuration directory (by default `~/.config/nvim`). If found, this file
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
  -- The name of the project-level configuration file
  project_config_name = ".nvim.lua",
  -- The name of the global configuration file
  global_config_name = ".nvim-global.lua",
  -- The prefix for environment variables to discover as Neovim configuration
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
