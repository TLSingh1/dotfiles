-- Main configuration module

-- Load basic vim options
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load plugins using lze
require("plugins")

-- Load colorscheme (after plugins to ensure themes are available)
require("config.colorscheme")

-- Load autocommands
require("config.autocmds")

