-- nvim-web-devicons: File type icons for Neovim plugins

return {
	"nvim-web-devicons",
	-- Only load if ui category is enabled
	enabled = function()
		return nixCats.cats.ui
	end,
	lazy = false, -- Load immediately since many plugins depend on it
	priority = 900, -- Load early since other plugins depend on it
	after = function()
		require("nvim-web-devicons").setup({
			-- Enable default icon
			default = true,
			-- Enable strict matching
			strict = true,
			-- Override specific icons if needed
			override = {},
			-- Use default colors
			color_icons = true,
		})
	end,
}