return {
	"dashboard-nvim",
	enabled = function()
		return nixCats.cats.ui
	end,
	event = "VimEnter",
	after = function()
		require("dashboard").setup({
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						desc = "󰊳 Update",
						group = "@property",
						action = "Lazy update",
						key = "u",
					},
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = " Recent",
						group = "DiagnosticHint",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						desc = " Config",
						group = "Number",
						action = "Telescope find_files cwd=~/.dotfiles/modules/tui/nvim",
						key = "c",
					},
					{
						desc = " New",
						group = "String",
						action = "enew",
						key = "n",
					},
					{
						desc = " Quit",
						group = "Error",
						action = "quit",
						key = "q",
					},
				},
				packages = { enable = true },
				project = {
					enable = true,
					limit = 8,
					icon = "",
					label = "",
					action = "Telescope find_files cwd=",
				},
				mru = {
					enable = true,
					limit = 10,
					icon = "",
					label = "",
					cwd_only = false,
				},
				footer = {
					"",
					"⚡ Neovim loaded in " .. vim.fn.printf("%.3f", vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))) .. " seconds",
				},
			},
			hide = {
				statusline = true,
				tabline = true,
				winbar = true,
			},
		})
		
		-- Set up an autocommand to update start time
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.g.start_time = vim.fn.reltime()
			end,
		})
	end,
}