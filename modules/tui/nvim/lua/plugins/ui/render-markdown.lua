-- Render Markdown - Improve viewing Markdown files in Neovim

return {
  "render-markdown.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  ft = { "markdown" },
  cmd = { "RenderMarkdown" },
  
  after = function()
    require("render-markdown").setup({
      -- Main options
      enabled = true,
      render_modes = { "n", "c", "t" }, -- Only render in normal, command, and terminal modes
      
      -- Performance
      debounce = 100,
      max_file_size = 10.0, -- MB
      
      -- Headings
      heading = {
        enabled = true,
        sign = true,
        icons = { "◉ ", "○ ", "✸ ", "✿ ", "▶ ", "⤷ " },
      },
      
      -- Code blocks
      code = {
        enabled = true,
        sign = true,
        style = "full",
        border = "thin",
        width = "full",
        left_pad = 1,
        right_pad = 1,
      },
      
      -- Bullets
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      
      -- Checkboxes
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
      },
      
      -- Tables
      pipe_table = {
        enabled = true,
        preset = "round",
        style = "full",
      },
      
      -- Quote blocks
      quote = {
        enabled = true,
        icon = "▌",
      },
    })
  end,
}