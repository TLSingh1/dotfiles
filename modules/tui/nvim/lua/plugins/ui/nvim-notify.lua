return {
	"nvim-notify",
	enabled = function()
		return nixCats.cats.ui
	end,
	lazy = false,
	priority = 1000,
	after = function()
		local notify = require("notify")

		notify.setup({
			-- Animation style
			stages = "fade_in_slide_out",
			-- Default timeout for notifications
			timeout = 3000,
			-- Icons (matching LSP diagnostic signs)
			icons = {
				ERROR = "󰅚",
				WARN = "󰀦",
				INFO = "󰋼",
				DEBUG = "󰃤",
				TRACE = "✎",
			},
			-- Render style
			render = "default",
			-- Minimum width
			minimum_width = 50,
			-- Background colour
			background_colour = "#000000",
			-- Additional configuration
			level = vim.log.levels.INFO,
			fps = 30,
			top_down = true,
			max_width = 80,
			max_height = 10,
		})

		-- Set as default notify function
		vim.notify = notify

		-- Set highlight groups for borders
		vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#f38ba8", bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#f9e2af", bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#89b4fa", bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#94e2d5", bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#cba6f7", bg = "#000000" })

		-- Also set body backgrounds to match
		vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "#000000" })
		vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "#000000" })
	end,
}
