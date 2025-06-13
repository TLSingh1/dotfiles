return {
	"render-markdown.nvim",

	enabled = function()
		return nixCats.cats.ui
	end,

	ft = { "markdown" },
	cmd = { "RenderMarkdown" },

	after = function()
		require("render-markdown").setup({
			latex = {
				enabled = true,
				render_modes = false,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				position = "above",
				top_pad = 0,
				bottom_pad = 0,
			},
			indent = {
				enabled = true,
			},
			heading = {
				border = true,
				position = "inline",
				width = "block",
			},
			paragraph = {
				enabled = true,
			},
			code = {
				enabled = true,
				style = "full",
				position = "right",
				language_pad = 0,
				width = "block",
				left_pad = 0,
				right_pad = 4,
				min_width = 0,
				border = "thick",
			},
			bullet = {
				enabled = true,
				icons = { "•", "○", "◆", "◇" },
				left_pad = 0,
				right_pad = 0,
				highlight = "RenderMarkdownBullet",
			},
		})
	end,
}
