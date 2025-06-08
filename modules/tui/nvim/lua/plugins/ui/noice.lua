return {
	"noice.nvim",
	enabled = function()
		return nixCats.cats.ui
	end,
	event = "DeferredUIEnter",
	on_plugin = "nvim-notify",
	after = function()
		require("noice").setup({
			lsp = {
				-- override markdown rendering so that **blink.cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					-- Don't override cmp documentation since we're using blink.cmp
				},
				-- Use a border for hover docs and signature help
				hover = {
					enabled = true,
					silent = false,
					view = nil,
					opts = {
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						position = { row = 2, col = 2 },
					},
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = true,
						trigger = true,
						luasnip = true,
						throttle = 50,
					},
					view = nil,
					opts = {
						border = {
							style = "rounded",
							padding = { 0, 1 },
						},
						position = { row = 2, col = 2 },
					},
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			-- custom views
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = {
							Normal = "Normal",
							FloatBorder = "DiagnosticInfo",
						},
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = {
							Normal = "Normal",
							FloatBorder = "DiagnosticInfo",
						},
					},
				},
			},
			-- custom routes
			routes = {
				-- Hide search virtual text
				{
					filter = {
						event = "msg_show",
						kind = "search_count",
					},
					opts = { skip = true },
				},
				-- Hide written messages
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
			-- cmdline configuration
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
					input = {}, -- Used by input()
				},
			},
			-- messages configuration
			messages = {
				enabled = true,
				view = "notify",
				view_error = "notify",
				view_warn = "notify",
				view_history = "messages",
				view_search = "virtualtext",
			},
			-- popupmenu configuration
			popupmenu = {
				enabled = true,
				backend = "nui",
			},
			-- notify configuration
			notify = {
				enabled = true,
				view = "notify",
			},
		})
		
		-- Keymaps for Noice
		vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss all visible messages" })
		vim.keymap.set("n", "<leader>nh", "<cmd>NoiceHistory<cr>", { desc = "Show message history" })
		vim.keymap.set("n", "<leader>nl", "<cmd>NoiceLast<cr>", { desc = "Show last message" })
		vim.keymap.set("n", "<leader>ne", "<cmd>NoiceErrors<cr>", { desc = "Show error messages" })
		
		-- Scrolling in hover docs
		vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
			if not require("noice.lsp").scroll(4) then
				return "<c-f>"
			end
		end, { silent = true, expr = true })
		
		vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
			if not require("noice.lsp").scroll(-4) then
				return "<c-b>"
			end
		end, { silent = true, expr = true })
	end,
}