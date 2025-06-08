return {
	"telescope.nvim",

	enabled = function()
		return nixCats.cats.ui
	end,

	cmd = { "Telescope" },
	keys = {
		{ "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
		{ "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
		{ "<leader>td", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
	},
	after = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = "🔭 ",
				selection_caret = "󱞪 ",
				path_display = { "smart" },
				sorting_strategy = "ascending",
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<S-k>"] = actions.preview_scrolling_up,
						["<S-j>"] = actions.preview_scrolling_down,
					},
					n = {
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
					},
				},
			},
			pickers = {
				find_files = {
					theme = "dropdown",
					previewer = true,
				},
			},
		})
	end,
}
