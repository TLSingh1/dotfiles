-- Nui.nvim - UI component library

return {
  "nui.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  -- Load immediately as it's a dependency for other plugins
  lazy = false,
}