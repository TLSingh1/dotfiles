return {
	"conform.nvim",

	-- enabled = false,
	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	after = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				nix = { "alejandra" },
				markdown = { "prettierd", "prettier" },
			},
			formatters = {
				prettier = {
					prepend_args = { "--prose-wrap", "always" },
				},
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
