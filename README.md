# conf.nvim

Simple machine-, project- and command-level configuration for Neovim in Lua.

## Concepts

### The problem

This plugin tries to fix **as simply as possible** an issue I had with configuring Neovim, which is
that I wanted to be able to define simple configuration options at various levels:

- the machine level, e.g. if I use my Neovim configuration on a machine without logging in with
  GitHub, I want to disable the Copilot-related plugins on that machine
- the project level, e.g. if I work on a project that uses a different code formatter, I want to
  disable my formatter or change it
- the command level, e.g. to start Neovim in "light mode" (basically without any external
  dependenncies) on-the-fly, without having to create a new configuration file

Besides, I wanted to do this with Lua, as I like this language and it is powerful-enough and yet
very efficient, and I wanted each level to update the previous ones, not overwrite them.

### The solution

When the plugin is setup, the following steps happen:

- First, the plugin looks for a default Neovim configuration file in `lua/conf/default.lua` in the
  Neovim configuration directory (`~/.config/nvim` by default). If found, its output is used to
  define the Neovim configuration.

- Then, the plugin looks for a global Neovim configuration file in `lua/conf/global.lua` in the
  Neovim configuration directory (`~/.config/nvim` by default). If found, its output is used to
  update the Neovim configuration.

- Then, the plugin looks for a project-specific Neovim configuration file named `.nvim.lua` in the
  current working directory and all its parent directories until the home directory. If found, the
  file is sourced **securely** using `vim.secure.read`, to avoid executing blindly potentially
  malicious code. Again, its output is used to update the Neovim configuration.

- Finally, the plugin looks for environment variables starting with the `NVIM_` prefix. If found, it
  adds them with their values to the Neovim configuration.

This system is quite simple but flexible-enough for me to configure Neovim in a way that suits my
needs. Besides, since it relies on sourcing Lua files, it supports executing arbitrary Lua code,
like creating commands or setting environment variables at machine- or project-level.

> [!TIP]
>
> Usually, I Git-ignore the global configuration file in my Neovim configuration repository, and I
> Git-ignore the project-specific configuration files at the global Git level, by adding it in
> `~/.config/git/ignore`, so only my default Neovim configuration file is versioned. That way the
> Neovim configuration files don't pollute any project I'm working on.

## Installation

To install the plugin, you can use your favorite plugin manager, for example
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cjumel/conf.nvim",
  lazy = true, -- Can be directly required by other plugins
}
```

> [!NOTE]
>
> This plugin is designed to be usable even before plugin managers like `lazy.nvim` has set it up,
> to be usable for instance in plugin specificiations, like `cond` in `lazy.nvim`. For this reason,
> using the plugin functions will automatically set it up, and the plugin doesn't support options,
> has it would be cumbersome to deal with them in this context.

## Usage

To use this plugin, first install it as described above, then create a `lua/conf/default.lua` file
where you can define your default configuration options. This can be any arbitrary option, for
instance `disable_copilot=false` to enable or disable the Copilot-related plugins.

Then, you can use in your Neovim configuration files `require("conf").get` to get the value of a
configuration option. This value will have been updated by any global-, project- or command-level
option as described above. For instance, in our previous example, you could add use in the plugin
specification of Copilot-related plugins, like
[copilot.lua](https://github.com/zbirenbaum/copilot.lua) or
[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim):

```lua
{
  "zbirenbaum/copilot.lua",
  cond=require("conf").get("disable_copilot"),
  ...
}
```

Then, you can enable or disable the Copilot-related plugins at the machine-level, by editing the
`lua/conf/default.lua` file in the Neovim configuration directory, at the project-level, by creating
a `.nvim.lua` file in the project directory, or at the command-level, by setting the
`NVIM_DISABLE_COPILOT` environment variable.

## Similar plugins

- [neoconf.nvim](https://github.com/folke/neoconf.nvim), a more ambitious alternatives but which
  didn't suit my needs, as it is configured via JSON files and tries to be a lot more, with LSP
  integrations, etc.
- [nvim-config-local](https://github.com/klen/nvim-config-local/tree/main), a very cool alternative
  with quite similar features, except that is supports only project-level style configuration, not
  configurations cascading on several levels.
- [direnv.nvim](https://github.com/direnv/direnv.vim), a vimscript alternative
