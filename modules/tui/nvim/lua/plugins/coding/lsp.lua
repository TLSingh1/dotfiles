-- LSP Configuration

return {
	"nvim-lspconfig",

	-- Only load if coding category is enabled
	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufReadPre", "BufNewFile" },
	after = function()
		-- blink.cmp handles LSP capabilities automatically, no need for manual setup
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Basic LSP keymaps
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

		-- Setup nixd if we have nix category enabled
		require("lspconfig").nixd.setup({
			capabilities = capabilities,
			settings = {
				nixd = {
					nixpkgs = {
						-- This will use the nixpkgs from your flake
						expr = "import <nixpkgs> { }",
					},
					formatting = {
						command = { "alejandra" }, -- or nixfmt, nixpkgs-fmt
					},
				},
			},
		})

		-- Setup lua_ls for Lua development
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = {
							"vim",
							"require",
							"nixCats", -- Add nixCats global for our setup
						},
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
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

		-- Setup ts_ls for TypeScript/JavaScript development (includes JSX/TSX support)
		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
		})
	end,
}
