return {
	"nvim-ts-autotag",

	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufReadPre", "BufNewFile" },
	after = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
			per_filetype = {
				-- Example: disable auto-close for HTML if needed
				-- ["html"] = {
				--   enable_close = false
				-- }
			},
			-- Aliases for languages with similar tag structures
			aliases = {
				-- ["custom_language"] = "html",
			},
		})

		-- Optional: Fix for diagnostics update in insert mode
		-- Uncomment if you experience issues with tag updates
		-- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
		--   vim.lsp.diagnostic.on_publish_diagnostics,
		--   {
		--     underline = true,
		--     virtual_text = {
		--       spacing = 5,
		--       severity_limit = 'Warning',
		--     },
		--     update_in_insert = true,
		--   }
		-- )
	end,
}
