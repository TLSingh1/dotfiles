-- Catppuccin: Soothing pastel theme for Neovim

return {
	"catppuccin-nvim",

	-- Only load if ui category is enabled
	enabled = function()
		return nixCats.cats.ui
	end,

	priority = 1000, -- Load before other plugins to ensure colorscheme is available early

	after = function()
		-- Simple setup with minimal configuration
		require("catppuccin").setup({
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
					-- Base colors - dark warm tones
					base = "#0a0505", -- Very dark with slight red tint (was #1e1e2e)
					mantle = "#100808", -- Darker warm (was #181825)
					crust = "#150a0a", -- Darkest warm (was #11111b)

					-- Surface colors - orange-tinted grays
					surface0 = "#2a1815", -- Dark orange-gray (was #313244)
					surface1 = "#3a2420", -- Medium orange-gray (was #45475a)
					surface2 = "#4a3028", -- Light orange-gray (was #585b70)

					-- Overlay colors
					overlay0 = "#5a3c30", -- (was #6c7086)
					overlay1 = "#6a4838", -- (was #7f849c)
					overlay2 = "#7a5440", -- (was #9399b2)

					-- Text colors
					text = "#ffd4b0", -- Warm white (was #cdd6f4)
					subtext1 = "#ffcaa0", -- (was #bac2de)
					subtext0 = "#ffc090", -- (was #a6adc8)

					-- Main theme colors - orange spectrum
					rosewater = "#ffdc95", -- Light yellow-orange (was #f5e0dc)
					flamingo = "#ff9c85", -- Light orange (was #f2cdcd)
					pink = "#ff8c95", -- Orange-pink (was #f5c2e7)
					mauve = "#ff7c85", -- Deep orange (was #cba6f7)
					red = "#ff6464", -- Coral red (was #f38ba8)
					maroon = "#ff7050", -- Orange-red (was #eba0ac)
					peach = "#ff9c64", -- Primary orange (was #fab387)
					yellow = "#ffdc00", -- Bright yellow (was #f9e2af)
					green = "#ffa500", -- Orange (was #a6e3a1)
					teal = "#ff8c64", -- Amber (was #94e2d5)
					sky = "#ffa050", -- Light orange (was #89dceb)
					sapphire = "#ff8050", -- Deep orange (was #74c7ec)
					blue = "#ff7020", -- Dark orange (was #89b4fa)
					lavender = "#ffb08c", -- Light orange (was #b4befe)
				},
			},
			custom_highlights = function()
				return {
					-- Window backgrounds - warm dark tones
					ActiveWindow = { bg = "#1a0f0a" },
					InactiveWindow = { bg = "#000000" },
					WinBar = { bg = "#1a0f0a" },
					WinBarNC = { bg = "#000000" },
					StatusLine = { bg = "#0a0505" },
					FloatBorder = { fg = "#ff9c64", bg = "#000000" },
					WinSeparator = { fg = "#ff9c64", bg = "#000000" },

					-- NeoTree - orange theme
					NeoTreeFloatBorder = { fg = "#ff9c64", bg = "#1a0f0a" },
					NeoTreeFloatTitle = { fg = "#ffdc00", bg = "#1a0f0a" },
					NeoTreeNormal = { bg = "#1a0f0a" },
					NeoTreeTabActive = { bg = "#2a1510" },
					NeoTreeTabSeparatorActive = { fg = "#2a1510", bg = "#2a1510" },

					-- Command line
					NoiceCmdLine = { bg = "#000000" },

					-- Telescope - orange holographic
					TelescopePromptNormal = { fg = "#ffdc00", bg = "#2a1510" },
					TelescopePromptBorder = { fg = "#ff9c64", bg = "#2a1510" },
					TelescopePrompt = { fg = "#2a1510", bg = "#2a1510" },
					TelescopeBorder = { fg = "#ff9c64", bg = "#1a0f0a" },
					TelescopeSelection = { bg = "#3a2015" },
					TelescopeSelectionCaret = { bg = "#3a2015" },
					TelescopeTitle = { fg = "#ffdc00", bg = "#2a1510" },
					TelescopeResultsNormal = { bg = "#1a0f0a" },
					TelescopePreviewNormal = { bg = "#1a0f0a" },

					-- Editor highlights
					Folded = { bg = "#3a2015", style = { "italic", "bold" } },
					CursorLine = { bg = "#2a1510" },
					CursorLineNr = { fg = "#ff9c64", bg = "#2a1510", style = { "bold" } },

					-- Tree and markdown
					NvimTreeNormalFloat = { bg = "#1a0f0a" },
					NvimTreeSignColumn = { bg = "#1a0f0a" },
					HelpviewCode = { bg = "#2a1510" },
					RenderMarkdownCode = { bg = "#2a1510" },
					RenderMarkdown_Inverse_RenderMarkdownCode = { fg = "#2a1510", bg = "#2a1510" },

					-- Additional highlights for holographic effect
					Normal = { bg = "#0a0505" },
					NormalFloat = { bg = "#1a0f0a" },
					LineNr = { fg = "#805030" }, -- Muted orange
					SignColumn = { bg = "#0a0505" },
					VertSplit = { fg = "#ff9c64", bg = "#0a0505" },

					-- Git signs with orange theme
					GitSignsAdd = { fg = "#ffdc00" },
					GitSignsChange = { fg = "#ff9c64" },
					GitSignsDelete = { fg = "#ff6464" },
				}
			end,
		})

		-- Set the colorscheme immediately after setup
		vim.cmd.colorscheme("catppuccin")
	end,
}
