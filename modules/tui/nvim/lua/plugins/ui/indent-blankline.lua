-- Indent Blankline - Show indent guides with rainbow colors

return {
  "indent-blankline.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  event = { "BufReadPost", "BufNewFile" },
  
  after = function()
    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#453134" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#454231" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#313645" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#453931" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#31453b" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#413145" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#314545" })
    end)

    require("ibl").setup({
      indent = {
        highlight = highlight,
        char = "▏",
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = { "dashboard", "norg", "markdown" },
      },
    })
  end,
}