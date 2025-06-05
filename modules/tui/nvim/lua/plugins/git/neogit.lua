-- Neogit - Magit-like interface for Git

return {
  "neogit",
  
  -- Only load if git category is enabled
  enabled = function()
    return nixCats.cats.git
  end,
  
  cmd = { "Neogit" },
  keys = {
    { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
    { "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
    { "<leader>gp", "<cmd>Neogit push<CR>", desc = "Neogit push" },
    { "<leader>gl", "<cmd>Neogit pull<CR>", desc = "Neogit pull" },
  },
  after = function()
    require("neogit").setup({
      kind = "split", -- Opens neogit in a split
      signs = {
        -- { CLOSED, OPENED }
        section = { "", "" },
        item = { "", "" },
        hunk = { "", "" },
      },
      integrations = {
        telescope = true,
      },
      sections = {
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
      },
    })
  end,
}