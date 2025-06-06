-- Snacks - Collection of small QoL plugins

return {
	"snacks.nvim",

	-- Only load if ui category is enabled
	enabled = function()
		return nixCats.cats.ui
	end,

	priority = 1000,
	lazy = false,

	after = function()
		local Snacks = require("snacks")

		Snacks.setup({
			-- Status column configuration
			statuscolumn = {
				enabled = true,
				left = { "mark", "sign" }, -- high priority on the left
				right = { "fold", "git" }, -- high priority on the right
				folds = {
					open = false, -- don't show open fold icons
					git_hl = false, -- don't use Git Signs hl for fold icons
				},
				git = {
					-- patterns to match Git signs
					patterns = { "GitSign", "MiniDiffSign" },
				},
				refresh = 50, -- refresh at most every 50ms
			},

			-- Indent configuration (since we disabled indent-blankline.nvim)
			indent = {
				enabled = true,
				-- Indent configuration with rainbow colors
				animate = {
					duration = { step = 15, total = 150 },
					easing = "linear",
				},
				char = "▏",
				scope = {
					enabled = true,
					char = "▏",
					underline = true,
					highlight = {
						"SnacksIndentScope1",
						"SnacksIndentScope2",
						"SnacksIndentScope3",
						"SnacksIndentScope4",
						"SnacksIndentScope5",
						"SnacksIndentScope6",
						"SnacksIndentScope7",
					},
				},
				chunk = {
					enabled = true,
				},
				only_scope = false,
				only_current = false,
				hl = {
					"SnacksIndent1",
					"SnacksIndent2",
					"SnacksIndent3",
					"SnacksIndent4",
					"SnacksIndent5",
					"SnacksIndent6",
					"SnacksIndent7",
				},
			},
		})

		-- Set up rainbow colors for indent (Catppuccin Mocha palette - 30% brightness)
		vim.api.nvim_set_hl(0, "SnacksIndent1", { fg = "#6f3545" }) -- Red (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent2", { fg = "#6e4a37" }) -- Peach (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent3", { fg = "#6c6147" }) -- Yellow (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent4", { fg = "#496144" }) -- Green (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent5", { fg = "#41615b" }) -- Teal (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent6", { fg = "#3d4e6e" }) -- Blue (dimmed)
		vim.api.nvim_set_hl(0, "SnacksIndent7", { fg = "#4e526d" }) -- Lavender (dimmed)

		-- Set up rainbow colors for scope (Catppuccin Mocha palette - full brightness)
		vim.api.nvim_set_hl(0, "SnacksIndentScope1", { fg = "#f38ba8" }) -- Red
		vim.api.nvim_set_hl(0, "SnacksIndentScope2", { fg = "#fab387" }) -- Peach
		vim.api.nvim_set_hl(0, "SnacksIndentScope3", { fg = "#f9e2af" }) -- Yellow
		vim.api.nvim_set_hl(0, "SnacksIndentScope4", { fg = "#a6e3a1" }) -- Green
		vim.api.nvim_set_hl(0, "SnacksIndentScope5", { fg = "#94e2d5" }) -- Teal
		vim.api.nvim_set_hl(0, "SnacksIndentScope6", { fg = "#89b4fa" }) -- Blue
		vim.api.nvim_set_hl(0, "SnacksIndentScope7", { fg = "#b4befe" }) -- Lavender
	end,
}
