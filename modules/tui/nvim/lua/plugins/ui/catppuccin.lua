-- Material You 3 inspired color palette
local colors = {
	-- Base colors (Material You 3 dark surfaces)
	base = "#0e1415",      -- Material dark background
	mantle = "#111819",    -- Slightly elevated surface
	crust = "#0b1011",     -- Darkest surface
	surface0 = "#1e2829",  -- Surface container lowest
	surface1 = "#263233",  -- Surface container low
	surface2 = "#2e3c3d",  -- Surface container
	overlay0 = "#364647",  -- Surface container high
	overlay1 = "#3e5051",  -- Surface container highest
	overlay2 = "#465a5b",  -- Surface bright
	
	-- Text colors (Material You 3 on-surface)
	text = "#c4e7e8",      -- On-surface primary
	subtext1 = "#a8cccd",  -- On-surface variant
	subtext0 = "#8cb1b2",  -- On-surface secondary
	
	-- Accent colors (Material You 3 tonal palette)
	rosewater = "#f4b8cc", -- Tertiary 80
	flamingo = "#e694b3",  -- Tertiary 70
	pink = "#d8709a",      -- Tertiary 60
	mauve = "#a385cf",     -- Secondary 70
	red = "#f2718b",       -- Error 70
	maroon = "#e25370",    -- Error 60
	peach = "#7dd3c0",     -- Primary 70
	yellow = "#5eead4",    -- Primary 80
	green = "#34d399",     -- Primary variant 70
	teal = "#2dd4bf",      -- Primary 60
	sky = "#67e8f9",       -- Secondary 80
	sapphire = "#38bdf8",  -- Secondary 70
	blue = "#0891b2",      -- Secondary 50
	lavender = "#c084fc",  -- Secondary variant 70
	
	-- UI specific colors
	black = "#000000",
	window_bg = "#161f20",    -- Surface container
	cursor_line = "#1e2829",  -- Surface container low
	selection = "#263738",    -- Surface variant
	line_number = "#5f7c7d",  -- On-surface variant dim
}

-- Holographic cyan theme (commented for reference):
-- base = "#050510",      -- was "#0a0505" - deep blue-black
-- mantle = "#080813",    -- was "#100808" - slightly lighter blue-black
-- crust = "#0a0a18",     -- was "#150a0a" - darkest blue-purple
-- surface0 = "#151828",  -- was "#2a1815" - dark blue-purple surface
-- surface1 = "#202438",  -- was "#3a2420" - blue-purple surface
-- surface2 = "#2a3048",  -- was "#4a3028" - lighter blue-purple surface
-- overlay0 = "#353c58",  -- was "#5a3c30" - muted purple-blue
-- overlay1 = "#404868",  -- was "#6a4838" - lighter purple-blue
-- overlay2 = "#4a5478",  -- was "#7a5440" - lightest purple-blue
-- text = "#b0f0ff",      -- was "#ffd4b0" - bright cyan-white
-- subtext1 = "#a0e0ff",  -- was "#ffcaa0" - slightly dimmer cyan
-- subtext0 = "#90d0ff",  -- was "#ffc090" - even dimmer cyan
-- rosewater = "#ff95dc", -- was "#ffdc95" - holographic pink
-- flamingo = "#ff85f0",  -- was "#ff9c85" - bright magenta-pink
-- pink = "#ff95ff",      -- was "#ff8c95" - pure holographic pink
-- mauve = "#d085ff",     -- was "#ff7c85" - holographic purple
-- red = "#ff64a0",       -- was "#ff6464" - holographic hot pink
-- maroon = "#ff50c0",    -- was "#ff7050" - deeper holographic pink
-- peach = "#64ffec",     -- was "#ff9c64" - holographic cyan
-- yellow = "#00ffdc",    -- was "#ffdc00" - bright holographic turquoise
-- green = "#00ffa0",     -- was "#ffa500" - holographic mint green
-- teal = "#64ffd0",      -- was "#ff8c64" - holographic teal
-- sky = "#50e0ff",       -- was "#ffa050" - holographic sky blue
-- sapphire = "#5080ff",  -- was "#ff8050" - holographic blue
-- blue = "#7020ff",      -- was "#ff7020" - holographic purple-blue
-- lavender = "#b08cff",  -- was "#ffb08c" - holographic lavender
-- window_bg = "#0a0f1a", -- was "#1a0f0a" - dark blue window background
-- cursor_line = "#101525", -- was "#2a1510" - blue-purple cursor line
-- selection = "#152035",  -- was "#3a2015" - blue selection
-- line_number = "#305080", -- was "#805030" - muted blue line numbers

-- Original orange holographic colors for reference:
-- base = "#0a0505",
-- mantle = "#100808",
-- crust = "#150a0a",
-- surface0 = "#2a1815",
-- surface1 = "#3a2420",
-- surface2 = "#4a3028",
-- overlay0 = "#5a3c30",
-- overlay1 = "#6a4838",
-- overlay2 = "#7a5440",
-- text = "#ffd4b0",
-- subtext1 = "#ffcaa0",
-- subtext0 = "#ffc090",
-- rosewater = "#ffdc95",
-- flamingo = "#ff9c85",
-- pink = "#ff8c95",
-- mauve = "#ff7c85",
-- red = "#ff6464",
-- maroon = "#ff7050",
-- peach = "#ff9c64",
-- yellow = "#ffdc00",
-- green = "#ffa500",
-- teal = "#ff8c64",
-- sky = "#ffa050",
-- sapphire = "#ff8050",
-- blue = "#ff7020",
-- lavender = "#ffb08c",
-- window_bg = "#1a0f0a",
-- cursor_line = "#2a1510",
-- selection = "#3a2015",
-- line_number = "#805030",

return {
	"catppuccin-nvim",

	enabled = function()
		return nixCats.cats.ui
	end,

	priority = 1000,

	after = function()
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
					base = colors.base,
					mantle = colors.mantle,
					crust = colors.crust,
					surface0 = colors.surface0,
					surface1 = colors.surface1,
					surface2 = colors.surface2,
					overlay0 = colors.overlay0,
					overlay1 = colors.overlay1,
					overlay2 = colors.overlay2,
					text = colors.text,
					subtext1 = colors.subtext1,
					subtext0 = colors.subtext0,
					rosewater = colors.rosewater,
					flamingo = colors.flamingo,
					pink = colors.pink,
					mauve = colors.mauve,
					red = colors.red,
					maroon = colors.maroon,
					peach = colors.peach,
					yellow = colors.yellow,
					green = colors.green,
					teal = colors.teal,
					sky = colors.sky,
					sapphire = colors.sapphire,
					blue = colors.blue,
					lavender = colors.lavender,
				},
			},
			custom_highlights = function()
				return {
					-- Window backgrounds
					ActiveWindow = { bg = colors.window_bg },
					InactiveWindow = { bg = colors.black },
					WinBar = { bg = colors.window_bg },
					WinBarNC = { bg = colors.black },
					StatusLine = { bg = colors.black },
					
					-- Borders
					FloatBorder = { fg = colors.peach, bg = colors.black },
					WinSeparator = { fg = colors.peach, bg = colors.black },
					
					-- File tree
					NeoTreeFloatBorder = { fg = colors.peach, bg = colors.window_bg },
					NeoTreeFloatTitle = { fg = colors.yellow, bg = colors.window_bg },
					NeoTreeNormal = { bg = colors.window_bg },
					NeoTreeTabActive = { bg = colors.cursor_line },
					NeoTreeTabSeparatorActive = { fg = colors.cursor_line, bg = colors.cursor_line },
					
					-- Command line
					NoiceCmdLine = { bg = colors.black },
					
					-- Telescope
					TelescopePromptNormal = { fg = colors.yellow, bg = colors.cursor_line },
					TelescopePromptBorder = { fg = colors.peach, bg = colors.cursor_line },
					TelescopePrompt = { fg = colors.cursor_line, bg = colors.cursor_line },
					TelescopeBorder = { fg = colors.peach, bg = colors.window_bg },
					TelescopeSelection = { bg = colors.selection },
					TelescopeSelectionCaret = { bg = colors.selection },
					TelescopeTitle = { fg = colors.yellow, bg = colors.cursor_line },
					TelescopeResultsNormal = { bg = colors.window_bg },
					TelescopePreviewNormal = { bg = colors.window_bg },
					
					-- Editor
					Folded = { bg = colors.selection, style = { "italic", "bold" } },
					CursorLine = { bg = colors.cursor_line },
					CursorLineNr = { fg = colors.peach, bg = colors.cursor_line, style = { "bold" } },
					
					-- Nvim tree
					NvimTreeNormalFloat = { bg = colors.window_bg },
					NvimTreeSignColumn = { bg = colors.window_bg },
					
					-- Markdown
					HelpviewCode = { bg = colors.cursor_line },
					RenderMarkdownCode = { bg = colors.cursor_line },
					RenderMarkdown_Inverse_RenderMarkdownCode = { fg = colors.cursor_line, bg = colors.cursor_line },
					
					-- Base editor colors
					Normal = { bg = colors.base },
					NormalFloat = { bg = colors.window_bg },
					LineNr = { fg = colors.line_number },
					SignColumn = { bg = colors.base },
					VertSplit = { fg = colors.peach, bg = colors.base },
					
					-- Git signs
					GitSignsAdd = { fg = colors.yellow },
					GitSignsChange = { fg = colors.peach },
					GitSignsDelete = { fg = colors.red },
				}
			end,
		})

		-- Set the colorscheme immediately after setup
		vim.cmd.colorscheme("catppuccin")
	end,
}