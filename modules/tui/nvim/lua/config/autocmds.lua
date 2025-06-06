-- Autocommands for Neovim configuration

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Create augroup for our custom autocommands
local config_group = augroup("UserConfig", { clear = true })

-- Set InactiveWindow background color on startup
autocmd("VimEnter", {
  group = config_group,
  pattern = "*",
  callback = function()
    vim.cmd("hi InactiveWindow guibg=#000000")
  end,
  desc = "Set InactiveWindow background to pure black"
})

-- Also set it after colorscheme changes
autocmd("ColorScheme", {
  group = config_group,
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.cmd("hi InactiveWindow guibg=#000000")
    end, 1)
  end,
  desc = "Ensure InactiveWindow stays black after colorscheme changes"
})