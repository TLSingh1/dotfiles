-- Avante.nvim - AI-powered code assistant

return {
  "avante.nvim",
  
  -- Only load if ai category is enabled
  enabled = function()
    return nixCats.cats.ai
  end,
  
  event = { "BufReadPost", "BufNewFile" },
  
  -- Load after nui.nvim
  on_plugin = { "nui.nvim" },
  
  before = function()
    -- Configure vim.ui.input to use snacks.nvim
    local Snacks = require("snacks")
    vim.ui.input = function(opts, on_confirm)
      Snacks.input(opts, on_confirm)
    end
    -- Note: vim.ui.select will use the default implementation
    -- as snacks doesn't provide a select replacement
  end,
  
  after = function()
    require("avante_lib").load()
    require("avante").setup({
      provider = "claude",
      mode = "agentic", -- Use the new agentic mode for better code generation
      auto_suggestions_provider = "claude",
      
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-3-5-sonnet-20241022", -- Sonnet 3.5 (newest version)
          -- You can also use "claude-3-5-haiku-20241022" for faster, cheaper responses
          extra_request_body = {
            temperature = 0.7,
            max_tokens = 4096,
          },
        },
      },
      
      behaviour = {
        auto_suggestions = false, -- Disable auto suggestions to save API costs
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = true,
        minimize_diff = true,
        enable_token_counting = true,
        auto_approve_tool_permissions = false, -- Ask before running tools for safety
      },
      
      mappings = {
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        cancel = {
          normal = { "<C-c>", "<Esc>", "q" },
          insert = { "<C-c>" },
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          retry_user_request = "r",
          edit_user_request = "e",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = { "<Esc>", "q" },
        },
      },
      
      hints = { enabled = true },
      
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
      
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      
      diff = {
        autojump = true,
        list_opener = "copen",
        override_timeoutlen = 500,
      },
      
      suggestion = {
        debounce = 600,
        throttle = 600,
      },
      
      -- File selector configuration to use telescope
      selector = {
        provider = "telescope",
        provider_opts = {},
      },
    })
    
    -- Configure render-markdown to support Avante
    require("render-markdown").setup({
      file_types = { "markdown", "Avante" },
    })
    
    -- Configure img-clip for image pasting support
    require("img-clip").setup({
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        use_absolute_path = true,
      },
    })
  end,
}