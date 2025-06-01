-- conform.nvim - Lightweight yet powerful formatter plugin
-- https://github.com/stevearc/conform.nvim

return {
  -- Only load if coding category is enabled
  enabled = function()
    return nixCats.cats.coding
  end,

  event = { "BufWritePre", "BufNewFile" },
  cmd = { "ConformInfo", "Format" },

  config = function()
    local conform = require("conform")

    conform.setup({
      -- Map of filetype to formatters
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },
        
        -- JavaScript/TypeScript/JSON/CSS/HTML
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        
        -- Python
        python = { "isort", "black" },
        
        -- Rust
        rust = { "rustfmt", lsp_format = "fallback" },
        
        -- Shell scripts
        sh = { "shfmt" },
        bash = { "shfmt" },
        
        -- TOML
        toml = { "taplo" },
        
        -- Nix (using LSP formatter as fallback)
        nix = { lsp_format = "fallback" },
      },

      -- Set default format options
      default_format_opts = {
        lsp_format = "fallback",
      },

      -- Format on save configuration
      format_on_save = function(bufnr)
        -- Disable with a global variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,

      -- Notify when formatter errors
      notify_on_error = true,
      notify_no_formatters = false, -- Don't spam when no formatters available
    })

    -- Create user commands
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      conform.format({ async = true, range = range })
    end, { range = true })

    -- Commands to toggle format-on-save
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })

    -- Keymaps
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })

    -- Add format info keymap
    vim.keymap.set("n", "<leader>ci", "<cmd>ConformInfo<cr>", { desc = "Conform Info" })
  end,
} 