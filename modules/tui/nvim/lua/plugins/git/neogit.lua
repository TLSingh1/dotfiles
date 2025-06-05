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
          hidden = false,
        },
        unstaged = {
          hidden = false,
        },
        staged = {
          hidden = false,
        },
        stashes = {
          hidden = true,
        },
        unpulled = {
          hidden = true,
        },
        unmerged = {
          hidden = false,
        },
        recent = {
          hidden = true,
        },
      },
    })
  end,
}