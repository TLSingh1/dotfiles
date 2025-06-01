-- Catppuccin: Soothing pastel theme for Neovim

return {
  "catppuccin-nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  priority = 1000, -- Load before other plugins to ensure colorscheme is available early
  
  after = function()
    -- Simple setup with minimal configuration
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        nvimtree = true,
        treesitter = true,
        telescope = {
          enabled = true,
        },
        native_lsp = {
          enabled = true,
        },
      },
    })
    
    -- Set the colorscheme immediately after setup
    vim.cmd.colorscheme("catppuccin")
  end,
} 