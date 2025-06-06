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
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = { "bold" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      -- color_overrides = {
      --   all = {
      --     base = "#000000",
      --   },
      -- },
      custom_highlights = function()
        return {
          ActiveWindow = { bg = "#011826" },
          InactiveWindow = { bg = "#000000" },
          WinBar = { bg = "#011826" },
          WinBarNC = { bg = "#000000" },
          StatusLine = { bg = "#000000" },
          FloatBorder = { fg = "#011826", bg = "#011826" },
          WinSeparator = { fg = "#011826", bg = "#000000" },
          NeoTreeFloatBorder = { fg = "#011826", bg = "#011826" },
          NeoTreeFloatTitle = { fg = "#011826", bg = "#011826" },
          NeoTreeNormal = { bg = "#011826" },
          NeoTreeTabActive = { bg = "#0B2534" },
          NeoTreeTabSeparatorActive = { fg = "#0B2534", bg = "#0B2534" },
          NoiceCmdLine = { bg = "#000000" },
          TelescopePromptNormal = { fg = "#1affff", bg = "#0B2534" },
          TelescopePromptBorder = { fg = "#0B2534", bg = "#0B2534" },
          TelescopePrompt = { fg = "#0B2534", bg = "#0B2534" },
          TelescopeBorder = { fg = "#011826", bg = "#011826" },
          TelescopeSelection = { bg = "#233B48" },
          TelescopeSelectionCaret = { bg = "#233B48" },
          TelescopeTitle = { fg = "#1affff", bg = "#0B2534" },
          TelescopeResultsNormal = { bg = "#011826" },
          TelescopePreviewNormal = { bg = "#011826" },
          Folded = { bg = "#233B48", style = { "italic", "bold" } },
          CursorLine = { bg = "#0B2534" },
          CursorLineNr = { fg = "#f2c9ff", bg = "#0B2534", style = { "bold" } },
          -- TreesitterContext = { bg = "#0B2534" },
          -- TreesitterContextBottom = { bg = "#0B2534" },
          -- TreesitterContextLineNumber = { bg = "#0B2534" },
          NvimTreeNormalFloat = { bg = "#011826" },
          NvimTreeSignColumn = { bg = "#011826" },
          HelpviewCode = { bg = "#0B2534" },
          RenderMarkdownCode = { bg = "#0B2534" },
          RenderMarkdown_Inverse_RenderMarkdownCode = { fg = "#0B2534", bg = "#0B2534" },
        }
      end,
    })
    
    -- Set the colorscheme immediately after setup
    vim.cmd.colorscheme("catppuccin")
  end,
} 
