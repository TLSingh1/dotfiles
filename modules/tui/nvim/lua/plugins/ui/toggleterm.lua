-- ToggleTerm - Terminal management

return {
	"toggleterm.nvim",

	-- Only load if ui category is enabled
	enabled = function()
		return nixCats.cats.ui
	end,

	cmd = { "ToggleTerm" },
	keys = {
		{ "<A-;>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
	},
	after = function()
		require("toggleterm").setup({
			open_mapping = "<A-;>",
			direction = "float",
			--   shell = "fish",
			float_opts = {
				border = "curved",
			},
			highlights = {
				Normal = {
					guibg = "#0a0505", -- Dark background matching theme
				},
				NormalFloat = {
					guibg = "#1a0f0a", -- Slightly lighter for float
				},
				FloatBorder = {
					guifg = "#ff9c64", -- Orange border
					guibg = "#1a0f0a", -- Match float background
				},
			},
		})
	end,
}

