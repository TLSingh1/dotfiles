-- blink.cmp - Modern, fast completion engine

return {
	"blink.cmp",

	-- Only load if coding category is enabled
	enabled = function()
		return nixCats.cats.coding
	end,

	event = "InsertEnter",
	after = function()
		require("blink.cmp").setup({
			-- Keymap configuration
			keymap = {
				preset = "default",
				-- Navigation with Ctrl+j/k
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				-- Tab for snippet navigation or accept
				["<Tab>"] = {
					function(cmp)
						-- If we're in a snippet and can jump forward, do that
						if cmp.snippet_active({ direction = 1 }) then
							return cmp.snippet_forward()
						-- Otherwise, if the menu is open, accept the selected item
						elseif cmp.is_visible() then
							return cmp.accept()
						end
					end,
					"fallback",
				},
				-- Shift-Tab for backward snippet navigation
				["<S-Tab>"] = { "snippet_backward", "fallback" },
				-- Enter to accept completion OR jump forward in snippet
				["<CR>"] = {
					function(cmp)
						-- If the menu is open, accept the item
						if cmp.is_visible() then
							return cmp.accept()
						-- If we're in a snippet and can jump forward, do that
						elseif cmp.snippet_active({ direction = 1 }) then
							return cmp.snippet_forward()
						end
						-- Otherwise fallback to normal Enter
					end,
					"fallback",
				},
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						opts = {
							friendly_snippets = true, -- Load friendly-snippets
							search_paths = { vim.fn.stdpath("config") .. "/snippets" }, -- Additional custom snippets path
							global_snippets = { "all" }, -- Global snippets available in all filetypes
							extended_filetypes = {}, -- e.g. { typescript = { 'javascript' } }
							ignored_filetypes = {}, -- Filetypes to ignore
						},
					},
				},
			},

			-- Experimental signature help support
			signature = { enabled = true },

			completion = {
				accept = {
					-- Experimental auto-brackets support
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = true,
				},
			},

			-- Snippets configuration using vim.snippet API
			snippets = {
				preset = "default", -- Use default preset which includes vim.snippet integration
			},
		})
	end,
}

