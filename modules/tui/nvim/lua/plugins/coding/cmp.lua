return {
	"blink.cmp",

	enabled = function()
		return nixCats.cats.coding
	end,

	event = "InsertEnter",
	after = function()
		require("blink.cmp").setup({
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
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					snippets = {
						opts = {
							friendly_snippets = true,
							search_paths = { vim.fn.stdpath("config") .. "/snippets" },
							global_snippets = { "all" },
							extended_filetypes = {},
							ignored_filetypes = {},
						},
					},
				},
			},

			signature = { enabled = true },

			completion = {
				accept = {
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

			snippets = {
				preset = "default",
			},
		})
	end,
}
