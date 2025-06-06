-- ultimate-autopair.nvim - Advanced auto-pairing plugin with treesitter support

return {
	"ultimate-autopair.nvim",

	-- Only load if coding category is enabled
	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "InsertEnter", "CmdlineEnter" },
	after = function()
		require("ultimate-autopair").setup({
			-- Enable all default pairs
			{ "(", ")" },
			{ "[", "]" },
			{ "{", "}" },
			{ '"', '"' },
			{ "'", "'" },
			{ "`", "`" },
			{ "<", ">" },

			-- Advanced features
			tabout = { -- Tab to jump out of pairs
				enable = true,
				map = "<Tab>",
				cmap = "<Tab>",
			},

			-- Treesitter integration for smart pairing
			config_internal_pairs = {
				-- Multiline support
				multiline = true,

				-- Only pair if next character is space, closing pair, or end of line
				space = {
					on = true,
					check_box_ft = { "markdown", "org" },
				},

				-- Skip pairing in strings and comments
				treesitter = {
					enable = true,
					filter = {
						node_type = {
							-- Skip in these treesitter nodes
							{ "string", "comment" },
						},
					},
				},
			},

			-- Close pair settings
			close = {
				enable = true,
				map = {
					-- Enable automatic closing for all pairs
					["("] = ")",
					["["] = "]",
					["{"] = "}",
					['"'] = '"',
					["'"] = "'",
					["`"] = "`",
					["<"] = ">",
				},
			},

			-- Fast wrap feature (wrap selection with pairs)
			fastwrap = {
				enable = true,
				map = "<M-e>", -- Alt+e to trigger
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},

			-- Language-specific configurations
			extensions = {
				-- Better support for specific filetypes
				filetype = {
					-- Disable in certain filetypes if needed
					disable = { "TelescopePrompt", "spectre_panel" },
				},
				-- Command line specific settings
				cmdline = {
					-- Disable autopairs in vim command line for / and ?
					disable = { "/", "?" },
				},
			},
		})
	end,
}

