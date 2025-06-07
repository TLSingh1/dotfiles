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
	end,
}

