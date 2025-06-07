-- Diagram.nvim - Render diagrams in Neovim using image.nvim

return {
  "diagram.nvim",
  
  -- Only load if ui category is enabled
  enabled = false,
  -- enabled = function()
  --   return nixCats.cats.ui
  -- end,
  
  -- Load when opening markdown or neorg files
  ft = { "markdown", "norg" },
  
  -- Depends on image.nvim being loaded first
  dep_of = { "image.nvim" },
  
  after = function()
    ---@diagnostic disable-next-line: undefined-field
    require("diagram").setup({
      -- Set up integrations for markdown and neorg
      integrations = {
        require("diagram.integrations.markdown"),
        require("diagram.integrations.neorg"),
      },
      -- Events for rendering and clearing diagrams
      events = {
        render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
        clear_buffer = { "BufLeave" },
      },
      -- Renderer-specific options
      renderer_options = {
        mermaid = {
          background = "transparent", -- Transparent background for dark themes
          theme = "dark", -- Use dark theme for mermaid diagrams
          scale = 2, -- Higher scale for better quality
        },
        plantuml = {
          charset = "utf-8",
        },
        d2 = {
          theme_id = 200, -- Dark theme ID for d2
          dark_theme_id = 200,
          layout = "dagre",
          sketch = false,
        },
        gnuplot = {
          size = "800,600",
          font = "Arial,12",
          theme = "dark",
        },
      },
    })
  end,
}
