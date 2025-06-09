return {
	"catppuccin-nvim",

	enabled = function()
		return nixCats.cats.ui
	end,

	priority = 1000,

	after = function()
		-- Try to load dynamic colors from Caelestia
		local ok, dynamic_colors = pcall(require, "plugins.ui.dynamic-colors")
		local dynamic_config = {}
		
		if ok then
			dynamic_config = dynamic_colors.setup()
		end
		
		-- Base configuration
		local config = {
			flavour = "mocha",
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			no_italic = false,
			no_bold = false,
			no_underline = false,
			styles = {
				comments = { "italic" },
				conditionals = { "italic" },
				loops = {},
				functions = {},
				keywords = { "bold" },
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
				operators = {},
			},
			color_overrides = {
				mocha = {
					-- Default fallback colors (orange theme)
					-- These will be overridden by dynamic colors if available
					base = "#0a0505",
					mantle = "#100808",
					crust = "#150a0a",
					surface0 = "#2a1815",
					surface1 = "#3a2420",
					surface2 = "#4a3028",
					overlay0 = "#5a3c30",
					overlay1 = "#6a4838",
					overlay2 = "#7a5440",
					text = "#ffd4b0",
					subtext1 = "#ffcaa0",
					subtext0 = "#ffc090",
					rosewater = "#ffdc95",
					flamingo = "#ff9c85",
					pink = "#ff8c95",
					mauve = "#ff7c85",
					red = "#ff6464",
					maroon = "#ff7050",
					peach = "#ff9c64",
					yellow = "#ffdc00",
					green = "#ffa500",
					teal = "#ff8c64",
					sky = "#ffa050",
					sapphire = "#ff8050",
					blue = "#ff7020",
					lavender = "#ffb08c",
				},
			},
			custom_highlights = function()
				return {
					-- Default highlights (orange theme)
					-- These will be overridden by dynamic colors if available
					ActiveWindow = { bg = "#1a0f0a" },
					InactiveWindow = { bg = "#000000" },
					WinBar = { bg = "#1a0f0a" },
					WinBarNC = { bg = "#000000" },
					StatusLine = { bg = "#000000" },
					FloatBorder = { fg = "#ff9c64", bg = "#000000" },
					WinSeparator = { fg = "#ff9c64", bg = "#000000" },
					NeoTreeFloatBorder = { fg = "#ff9c64", bg = "#1a0f0a" },
					NeoTreeFloatTitle = { fg = "#ffdc00", bg = "#1a0f0a" },
					NeoTreeNormal = { bg = "#1a0f0a" },
					NeoTreeTabActive = { bg = "#2a1510" },
					NeoTreeTabSeparatorActive = { fg = "#2a1510", bg = "#2a1510" },
					NoiceCmdLine = { bg = "#000000" },
					TelescopePromptNormal = { fg = "#ffdc00", bg = "#2a1510" },
					TelescopePromptBorder = { fg = "#ff9c64", bg = "#2a1510" },
					TelescopePrompt = { fg = "#2a1510", bg = "#2a1510" },
					TelescopeBorder = { fg = "#ff9c64", bg = "#1a0f0a" },
					TelescopeSelection = { bg = "#3a2015" },
					TelescopeSelectionCaret = { bg = "#3a2015" },
					TelescopeTitle = { fg = "#ffdc00", bg = "#2a1510" },
					TelescopeResultsNormal = { bg = "#1a0f0a" },
					TelescopePreviewNormal = { bg = "#1a0f0a" },
					Folded = { bg = "#3a2015", style = { "italic", "bold" } },
					CursorLine = { bg = "#2a1510" },
					CursorLineNr = { fg = "#ff9c64", bg = "#2a1510", style = { "bold" } },
					NvimTreeNormalFloat = { bg = "#1a0f0a" },
					NvimTreeSignColumn = { bg = "#1a0f0a" },
					HelpviewCode = { bg = "#2a1510" },
					RenderMarkdownCode = { bg = "#2a1510" },
					RenderMarkdown_Inverse_RenderMarkdownCode = { fg = "#2a1510", bg = "#2a1510" },
					Normal = { bg = "#0a0505" },
					NormalFloat = { bg = "#1a0f0a" },
					LineNr = { fg = "#805030" },
					SignColumn = { bg = "#0a0505" },
					VertSplit = { fg = "#ff9c64", bg = "#0a0505" },
					GitSignsAdd = { fg = "#ffdc00" },
					GitSignsChange = { fg = "#ff9c64" },
					GitSignsDelete = { fg = "#ff6464" },
				}
			end,
		}
		
		-- Merge with dynamic config if available
		if dynamic_config.color_overrides and dynamic_config.color_overrides.mocha then
			config = vim.tbl_deep_extend("force", config, dynamic_config)
		end
		
		require("catppuccin").setup(config)

		-- Set the colorscheme immediately after setup
		vim.cmd.colorscheme("catppuccin")
	end,
}