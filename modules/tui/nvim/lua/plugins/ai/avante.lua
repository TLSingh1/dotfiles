-- Avante.nvim - AI-powered code assistant

return {
  "avante.nvim",
  
  -- Only load if ai category is enabled
  enabled = function()
    return nixCats.cats.ai
  end,
  
  event = "VeryLazy",
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteChat",
    "AvanteChatNew",
    "AvanteHistory",
    "AvanteClear",
    "AvanteEdit",
    "AvanteFocus",
    "AvanteRefresh",
    "AvanteStop",
    "AvanteSwitchProvider",
    "AvanteShowRepoMap",
    "AvanteToggle",
    "AvanteModels",
    "AvanteSwitchSelectorProvider",
  },
  
  keys = {
    { "<leader>aa", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante sidebar" },
    { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante sidebar" },
    { "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
    { "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
    { "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Edit selected blocks", mode = { "n", "v" } },
    { "<leader>aS", "<cmd>AvanteStop<CR>", desc = "Stop Avante request" },
    { "<leader>ah", "<cmd>AvanteHistory<CR>", desc = "Show Avante history" },
    { "<leader>aB", desc = "Add all buffers to Selected Files" },
    { "<leader>a?", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante provider" },
  },
  
  before = function()
    -- Load avante_lib first as required by the documentation
    if vim.fn.exists("*avante_lib#load") == 1 then
      vim.fn["avante_lib#load"]()
    elseif pcall(require, "avante_lib") then
      require("avante_lib").load()
    end
  end,
  
  after = function()
    require("avante").setup({
      -- Provider configuration
      provider = "claude",
      auto_suggestions_provider = "claude",
      mode = "agentic", -- "agentic" or "legacy"
      
      -- Use snacks.nvim for input UI
      input = {
        provider = "snacks",
        provider_opts = {
          title = "Avante Input",
          icon = " ",
          placeholder = "Enter your API key...",
        },
      },
      
      -- Provider settings
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 4096,
          },
        },
      },
      
      -- Behavior settings
      behaviour = {
        auto_suggestions = false, -- Experimental
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
        enable_token_counting = true,
        auto_approve_tool_permissions = false,
      },
      
      -- Window configuration
      windows = {
        position = "right",
        wrap = true,
        width = 30,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
        input = {
          prefix = "> ",
          height = 8,
        },
        edit = {
          border = "rounded",
          start_insert = true,
        },
        ask = {
          floating = false,
          start_insert = true,
          border = "rounded",
          focus_on_apply = "ours",
        },
      },
      
      -- Diff configuration
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
      
      -- Suggestion settings
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
      
      -- Selector provider (using telescope since it's already installed)
      selector = {
        provider = "telescope",
        provider_opts = {},
      },
      
      -- Hints
      hints = { enabled = true },
    })
    
    -- Setup key for adding all buffers (requires manual setup)
    vim.keymap.set("n", "<leader>aB", function()
      local sidebar = require("avante").get()
      if sidebar and sidebar.file_selector then
        -- Add all open buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
            local name = vim.api.nvim_buf_get_name(buf)
            if name and name ~= "" then
              local relative_path = require("avante.utils").relative_path(name)
              sidebar.file_selector:add_selected_file(relative_path)
            end
          end
        end
      end
    end, { desc = "Add all buffers to Avante Selected Files" })
  end,
}