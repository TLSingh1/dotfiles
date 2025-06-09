return {
	"toggleterm.nvim",

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
					guibg = "#0e1415", -- Material You 3 base background
				},
				NormalFloat = {
					guibg = "#161f20", -- Material You 3 window_bg
				},
				FloatBorder = {
					guifg = "#7dd3c0", -- Material You 3 peach (primary 70)
					guibg = "#161f20", -- Match float background
				},
			},
		})
	end,
}