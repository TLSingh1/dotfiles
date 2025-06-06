-- nvim-ts-autotag - Auto close and rename HTML/XML tags using treesitter

return {
	"nvim-ts-autotag",

	-- Only load if coding category is enabled
	enabled = function()
		return nixCats.cats.coding
	end,

	-- Load on these events for better performance
	event = { "BufReadPre", "BufNewFile" },
	after = function()
		require("nvim-ts-autotag").setup({
			opts = {
				-- Enable all features by default
				enable_close = true, -- Auto close tags
				enable_rename = true, -- Auto rename pairs of tags
				enable_close_on_slash = true, -- Auto close on trailing </
			},
			-- Per-filetype configurations (override global settings)
			per_filetype = {
				-- Example: disable auto-close for HTML if needed
				-- ["html"] = {
				--   enable_close = false
				-- }
			},
			-- Aliases for languages with similar tag structures
			aliases = {
				-- Add any custom language aliases here
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

