-- Claude Code - AI assistant integration for Neovim

return {
  "claude-code-nvim",
  
  -- Only load if ai category is enabled
  enabled = function()
    return nixCats.cats.ai
  end,
  
  event = "DeferredUIEnter",
  deps = { "plenary-nvim" }, -- Required dependency
  
  after = function()
    require("claude-code").setup({
      -- Terminal window settings
      window = {
        split_ratio = 0.3,     -- Percentage of screen for the terminal window
        position = "botright", -- Position: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        enter_insert = true,   -- Whether to enter insert mode when opening Claude Code
        hide_numbers = true,   -- Hide line numbers in the terminal window
        hide_signcolumn = true,-- Hide the sign column in the terminal window
      },
      
      -- File refresh settings
      refresh = {
        enable = true,              -- Enable file change detection
        updatetime = 100,          -- updatetime when Claude Code is active (milliseconds)
        timer_interval = 1000,     -- How often to check for file changes (milliseconds)
        show_notifications = true, -- Show notification when files are reloaded
      },
      
      -- Git project settings
      git = {
        use_git_root = true, -- Set CWD to git root when opening Claude Code (if in git project)
      },
      
      -- Command settings
      command = "claude", -- Command to run (change if claude is installed elsewhere)
      command_variants = {
        continue = "--continue",
        resume = "--resume",
        verbose = "--verbose",
      },
      
      -- Keymaps
      keymaps = {
        toggle = {
          normal = "<C-,>",
          terminal = "<C-,>",
          variants = {
            continue = "<leader>cC",
            verbose = "<leader>cV",
          },
        },
        window_navigation = true,
        scrolling = true,
      }
    })
  end,
}