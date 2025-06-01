-- Main entry point for nixCats Neovim configuration
-- This is a minimal configuration to get started

-- Set leader key early
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load our configuration modules
require('config') 
