return {
	"nvim-lspconfig",

	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufReadPre", "BufNewFile" },
	after = function()
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
			},
			-- virtual_text = false, -- Disable virtual_text since lsp_lines will show diagnostics
			virtual_lines = {
				only_current_line = true,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚",
					[vim.diagnostic.severity.WARN] = "󰀦",
					[vim.diagnostic.severity.HINT] = "󰌵",
					[vim.diagnostic.severity.INFO] = "󰋼",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
			end,
		})

		require("lspconfig").nixd.setup({
			capabilities = capabilities,
			settings = {
				nixd = {
					nixpkgs = {
						-- use the nixpkgs from flake
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "alejandra" },
					},
				},
			},
		})

		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {
							"vim",
							"require",
							"nixCats",
						},
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
		})

		require("lspconfig").qmlls.setup({
			capabilities = capabilities,
		})
	end,
}
