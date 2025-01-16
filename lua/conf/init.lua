local commands = require("conf.commands")
local nvim_config = require("conf.nvim_config")

nvim_config.setup()
commands.setup()

return nvim_config.get_config()
