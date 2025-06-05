-- nvim-colorizer - Highlight color codes and names

return {
  "nvim-colorizer.lua",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  event = { "BufReadPre", "BufNewFile" },
  
  after = function()
    require("colorizer").setup({})
  end,
}
