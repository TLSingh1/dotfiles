-- Supermaven - AI-powered code completion

return {
  "supermaven-nvim",
  
  -- Only load if ai category is enabled
  enabled = function()
    return nixCats.cats.ai
  end,
  
  event = "DeferredUIEnter",
  after = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { 
        gitcommit = true,
        gitrebase = true,
        help = true,
        markdown = true, -- Disable for markdown files
      },
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      log_level = "off", -- Disable logging for clean experience
      disable_inline_completion = false, -- Keep inline completion enabled
      disable_keymaps = false,
      -- Condition to disable in certain scenarios
      condition = function()
        -- Disable in very large files (>10k lines) for performance
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count > 10000 then
          return true
        end
        
        -- Disable in certain file patterns
        local filename = vim.fn.expand("%:t")
        if string.match(filename, "%.min%.") then -- minified files
          return true
        end
        
        return false
      end,
    })
  end,
} 