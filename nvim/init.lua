-- Set leader key before loading plugins (plugins may read mapleader at load time)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
