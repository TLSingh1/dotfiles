-- TypeScript Tools - Enhanced TypeScript support

return {
  "typescript-tools.nvim",
  
  -- Only load if coding category is enabled
  -- enabled = function()
  --   return nixCats.cats.coding
  -- end,
  enabled = false,  
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  event = { "BufReadPre", "BufNewFile" }, -- Load on file open for better reliability
  after = function()
    -- Ensure lspconfig is available (since we removed deps)
    local has_lspconfig = pcall(require, 'lspconfig')
    if not has_lspconfig then
      vim.notify("nvim-lspconfig not available for typescript-tools", vim.log.levels.WARN)
      return
    end

    -- Setup completion capabilities (blink.cmp handles this automatically)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Setup typescript-tools
    require("typescript-tools").setup({
      capabilities = capabilities,
      settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
        -- "remove_unused_imports"|"organize_imports") -- or string "all"
        -- to include all supported code actions
        -- specify commands exposed as code_actions
        expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused", "organize_imports" },
        -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
        -- (see 💅 `styled-components` support section)
        tsserver_plugins = {},
        -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
        -- memory limit in megabytes or "auto"(basically no limit)
        tsserver_max_memory = "auto",
        -- described below
        tsserver_format_options = {},
        tsserver_file_preferences = {
          -- Enable auto-imports
          includeCompletionsForModuleExports = true,
          includeCompletionsForImportStatements = true,
        },
        -- locale of all tsserver messages, supported locales you can find here:
        -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
        tsserver_locale = "en",
        -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
        complete_function_calls = true, -- Enable this for better completion
        include_completions_with_insert_text = true,
        -- CodeLens
        -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
        -- possible values: ("off"|"all"|"implementations_only"|"references_only")
        code_lens = "off",
        -- by default code lenses are displayed on all referencable values and for some of you it can
        -- be too much this option reduce count of them by removing member references from lenses
        disable_member_code_lens = true,
        -- JSXCloseTag
        -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
        -- that maybe have a conflict if enable this feature. )
        jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
        }
      },
      on_attach = function(client, bufnr)
        -- Set up keymaps for TypeScript specific features
        local opts = { buffer = bufnr, silent = true }
        
        -- Standard LSP keymaps
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        
        -- TypeScript specific commands
        vim.keymap.set('n', '<leader>to', '<cmd>TSToolsOrganizeImports<CR>', { buffer = bufnr, desc = "Organize Imports" })
        vim.keymap.set('n', '<leader>ts', '<cmd>TSToolsSortImports<CR>', { buffer = bufnr, desc = "Sort Imports" })
        vim.keymap.set('n', '<leader>tr', '<cmd>TSToolsRemoveUnused<CR>', { buffer = bufnr, desc = "Remove Unused" })
        vim.keymap.set('n', '<leader>tf', '<cmd>TSToolsFixAll<CR>', { buffer = bufnr, desc = "Fix All" })
        vim.keymap.set('n', '<leader>ta', '<cmd>TSToolsAddMissingImports<CR>', { buffer = bufnr, desc = "Add Missing Imports" })

        -- Additional useful TypeScript commands
        vim.keymap.set('n', '<leader>tR', '<cmd>TSToolsFileReferences<CR>', { buffer = bufnr, desc = "File References" })
        vim.keymap.set('n', '<leader>td', '<cmd>TSToolsGoToSourceDefinition<CR>', { buffer = bufnr, desc = "Go to Source Definition" })
        
        -- Debug: Notify when TypeScript LSP attaches
        vim.notify(string.format("TypeScript LSP attached to buffer %d (%s)", bufnr, vim.fn.expand("%:t")), vim.log.levels.INFO)
      end,
    })

    -- Create a command to check TypeScript LSP status
    vim.api.nvim_create_user_command("TSDebug", function()
      local clients = vim.lsp.get_active_clients({ name = "typescript-tools" })
      if #clients > 0 then
        vim.notify("TypeScript LSP is active with " .. #clients .. " client(s)", vim.log.levels.INFO)
        for _, client in ipairs(clients) do
          print("Client ID:", client.id, "Name:", client.name)
        end
      else
        vim.notify("No TypeScript LSP clients active", vim.log.levels.WARN)
      end
    end, { desc = "Debug TypeScript LSP status" })
  end,
} 
