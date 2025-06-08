return {
	"diagram.nvim",

	enabled = false,
	-- enabled = function()
	--   return nixCats.cats.ui
	-- end,

	ft = { "markdown", "norg" },

	dep_of = { "image.nvim" },

	after = function()
		---@diagnostic disable-next-line: undefined-field
		require("diagram").setup({
			integrations = {
				require("diagram.integrations.markdown"),
				require("diagram.integrations.neorg"),
			},
			events = {
				render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
				clear_buffer = { "BufLeave" },
			},
			renderer_options = {
				mermaid = {
					background = "transparent", -- Transparent background for dark themes
					theme = "dark", -- Use dark theme for mermaid diagrams
					scale = 2, -- Higher scale for better quality
				},
				plantuml = {
					charset = "utf-8",
				},
				d2 = {
					theme_id = 200, -- Dark theme ID for d2
					dark_theme_id = 200,
					layout = "dagre",
					sketch = false,
				},
				gnuplot = {
					size = "800,600",
					font = "Arial,12",
					theme = "dark",
				},
			},
		})
	end,
}
