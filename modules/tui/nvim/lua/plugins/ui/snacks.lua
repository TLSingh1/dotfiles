-- Snacks - Collection of small QoL plugins

return {
  "snacks.nvim",
  
  -- Only load if ui category is enabled
  enabled = function()
    return nixCats.cats.ui
  end,
  
  priority = 1000,
  lazy = false,
  
  after = function()
    local Snacks = require("snacks")
    
    Snacks.setup({
      -- Dashboard configuration
      dashboard = {
        enabled = true,
        width = 60,
        preset = {
          -- Custom header
          header = [[
███╗   ██╗██╗██╗  ██╗ ██████╗ █████╗ ████████╗███████╗
████╗  ██║██║╚██╗██╔╝██╔════╝██╔══██╗╚══██╔══╝██╔════╝
██╔██╗ ██║██║ ╚███╔╝ ██║     ███████║   ██║   ███████╗
██║╚██╗██║██║ ██╔██╗ ██║     ██╔══██║   ██║   ╚════██║
██║ ╚████║██║██╔╝ ██╗╚██████╗██║  ██║   ██║   ███████║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝]],
          
          -- Keymaps configuration
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      
      -- Status column configuration
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- high priority on the left
        right = { "fold", "git" }, -- high priority on the right
        folds = {
          open = false, -- don't show open fold icons
          git_hl = false, -- don't use Git Signs hl for fold icons
        },
        git = {
          -- patterns to match Git signs
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50, -- refresh at most every 50ms
      },
      
      -- Indent configuration (since we disabled indent-blankline.nvim)
      indent = {
        enabled = true,
        -- Indent configuration with rainbow colors
        animate = {
          duration = { step = 15, total = 150 },
          easing = "linear",
        },
        char = "▏",
        scope = {
          enabled = true,
          char = "▏",
          underline = false,
          highlight = {
            "SnacksIndentScope1",
            "SnacksIndentScope2",
            "SnacksIndentScope3",
            "SnacksIndentScope4",
            "SnacksIndentScope5",
            "SnacksIndentScope6",
            "SnacksIndentScope7",
          },
        },
        chunk = {
          enabled = false,
        },
        blank = {
          enabled = false,
        },
        only_scope = false,
        only_current = false,
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
          "SnacksIndent7",
        },
      },
      
      -- Scroll configuration (smooth scrolling)
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 15, total = 250 },
          easing = "linear",
        },
      },
    })
    
    -- Set up rainbow colors for indent
    vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#453134" })
    vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#454231" })
    vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#313645" })
    vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#453931" })
    vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#31453b" })
    vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#413145" })
    vim.api.nvim_set_hl(0, "SnacksIndent7", { fg = "#314545" })
    
    -- Set up rainbow colors for scope
    vim.api.nvim_set_hl(0, "SnacksIndentScope1", { fg = "#653538" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope2", { fg = "#656335" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope3", { fg = "#4a5168" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope4", { fg = "#65564a" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope5", { fg = "#4a6558" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope6", { fg = "#5f4a68" })
    vim.api.nvim_set_hl(0, "SnacksIndentScope7", { fg = "#4a6868" })
    
    -- Create dashboard command
    vim.api.nvim_create_user_command("Dashboard", function()
      Snacks.dashboard()
    end, {})
  end,
}