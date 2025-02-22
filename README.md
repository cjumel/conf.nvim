# conf.nvim

Simple machine-, project- and command-level configuration for Neovim in Lua.

## Concepts

### The problem

`conf.nvim` tries to address **as simply as possible** an issue I had with configuring Neovim, which
is that I wanted to be able to define simple configuration options at various levels:

- the machine level, e.g. if I use my Neovim configuration on a machine without logging in with
  GitHub, I want to disable the GitHub-Copilot-related plugins on that machine
- the project level, e.g. if I work on a project that uses a different code formatter, I want to
  change the code formatters I use
- the command level, e.g. to start Neovim in "light mode" (basically without any external tool
  dependenncy) on-the-fly, without having to create a new configuration file

Besides, I wanted to do this with Lua, as I like this language and it is powerful-enough and yet
very efficient, and I wanted each level to update the previous ones, not overwrite them.

### The solution

When `conf.nvim` is used, the following happens:

- First, `conf.nvim` looks for a default Neovim configuration table returned by a file
  `.nvim-default.lua` in the Neovim configuration directory (`~/.config/nvim` by default).

- Then, `conf.nvim` looks for a global, machine-level Neovim configuration table returned by a file
  `.nvim-global.lua` in the Neovim configuration directory (`~/.config/nvim` by default).

- Then, `conf.nvim` looks for a project-specific Neovim configuration table return by a file named
  `.nvim.lua` in the current working directory and all its parent directories until the home
  directory. If found, the file is sourced **securely** using `vim.secure.read`, to avoid executing
  blindly potentially malicious code.

- Finally, `conf.nvim` looks for environment variables starting with the `NVIM_` prefix to define a
  command-level Neovim configuration table.

At each of these steps, the newly found configuration options are used to update the existing
configuration table, overriding any shared configuration values, to define the final configuration
table which is then returned when calling `require("conf")`.

This system is quite simple but flexible-enough for me to configure Neovim in a way that suits my
needs. Besides, since it relies on sourcing Lua files, it supports executing arbitrary Lua code,
like creating commands or setting environment variables at machine- or project-level.

> [!TIP]
>
> Usually, I Git-ignore the global configuration file in my Neovim configuration repository, and I
> Git-ignore the project-specific configuration files at the global Git level by adding it in
> `~/.config/git/ignore`, so only my default Neovim configuration file is versioned. That way the
> Neovim configuration files don't pollute any project repository I'm working on.

## Installation

To install `conf.nvim`, you can use your favorite plugin manager, for example I use
[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "cjumel/conf.nvim",
  lazy = true, -- Can be directly required by other plugins
}
```

Since `conf.nvim` is designed to be usable in other plugins' specifications (typically the `cond`
field in a `lazy.vim` plugin specifications), it doesn't rely on the call of a `setup` function
(which would not have been called anyway at this stage).

> [!WARNING]
>
> If you're using `conf.nvim` in other plugins specifications and you're grouping plugins by
> directories when declaring them to `lazy.nvim`, make sure `conf.nvim` is in the first plugin
> group, otherwise, `lazy.nvim` might not be able to find it when calling `require("conf")`. For
> instance, this could be something like:
>
> ```lua
> require("lazy").setup({
>   spec = {
>    { import = "plugins.core" }, -- Put conf.nvim in there
>    { import = "plugins.ui" },
>    ...
>   }
> })
> ```

## Usage

To use `conf.nvim`, first install it as described above, then create a `.nvim-default.lua` file in
your Neovim configuration directory where you return your default Neovim configuration table. It can
contain any arbitrary option, for instance `disable_copilot=false` to enable or disable the
Copilot-related plugins.

Then, you can use `conf.nvim` in your Neovim configuration files to access your custom configuration
table with `require("conf")`. For instance, to easily disable
[copilot.lua](https://github.com/zbirenbaum/copilot.lua), you could use:

```lua
{
  "zbirenbaum/copilot.lua",
  cond=require("conf").disable_copilot,
  ...
}
```

Finally, you can enable or disable `copilot.lua` at the machine-level, by editing the
`.nvim-global.lua` file in the Neovim configuration directory, at the project-level, by creating a
`.nvim.lua` file in the project directory, or at the command-level, by setting the
`NVIM_DISABLE_COPILOT` environment variable.

## Similar plugins

- [neoconf.nvim](https://github.com/folke/neoconf.nvim), a more ambitious alternatives which didn't
  suit my needs, as it is configured via JSON files and tries to be a lot more, with LSP
  integrations, etc.
- [nvim-config-local](https://github.com/klen/nvim-config-local/tree/main), a very cool alternative
  with quite similar features, except that is supports only project-level style configuration, not
  configurations cascading on several levels.
- [direnv.nvim](https://github.com/direnv/direnv.vim), an older vimscript alternative
