-- Colorscheme configuration
-- Note: Catppuccin sets its own colorscheme in the plugin config
-- This file provides fallback behavior only

-- Set fallback colorscheme if catppuccin is not available or UI category is disabled
local function set_fallback_colorscheme()
  -- Only set fallback if UI category is disabled or catppuccin failed to load
  if not (nixCats and nixCats.cats and nixCats.cats.ui) then
    vim.cmd.colorscheme("default")
  end
end

-- Set fallback colorscheme
set_fallback_colorscheme()

-- Auto-reload colorscheme if it changes (useful for development)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- You can add any colorscheme-specific customizations here
    -- For example, custom highlight groups or adjustments
  end,
}) 