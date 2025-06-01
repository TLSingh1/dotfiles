-- ToggleTerm - Terminal management

return {
  "toggleterm.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  cmd = { "ToggleTerm" },
  keys = {
    { "<A-;>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
  },
  after = function()
    require("toggleterm").setup({
      open_mapping = "<A-;>",
      direction = "float",
    --   shell = "fish",
      float_opts = {
        border = "curved",
      },
      highlights = {
        Normal = {
          guibg = "#011826",
        },
        NormalFloat = {
          guibg = "#011826",
        },
        FloatBorder = {
          guifg = "#011826",
          guibg = "#011826",
        },
      },
    })
  end,
} 