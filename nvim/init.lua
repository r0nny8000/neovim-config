-- Set leader key before loading plugins (plugins may read mapleader at load time)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw (recommended by nvim-tree; must be set before plugin load)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.lazy")
