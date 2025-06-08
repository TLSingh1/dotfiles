return {
	"nvim-treesitter",

	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufReadPost", "BufNewFile" },
	cmd = { "TSUpdate", "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },

	after = function()
		require("nvim-treesitter.configs").setup({
			-- Highlighting
			highlight = {
				enable = true,
				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			-- Incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<C-s>",
					node_decremental = "<M-space>",
				},
			},

			-- Indentation
			indent = {
				enable = true,
				-- Disable for certain languages that have issues
				disable = { "python", "yaml" },
			},

			-- Text objects
			textobjects = {
				select = {
					enable = true,
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["al"] = "@loop.outer",
						["il"] = "@loop.inner",
						["ai"] = "@conditional.outer",
						["ii"] = "@conditional.inner",
						["ak"] = "@comment.outer",
						["ik"] = "@comment.inner",
					},
					-- You can choose the select mode (default is charwise 'v')
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						["@class.outer"] = "<c-v>", -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap` and `ip` mappings.
					include_surrounding_whitespace = true,
				},

				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]]"] = { query = "@class.outer", desc = "Next class start" },
						["]o"] = "@loop.*",
						["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]["] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[["] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[]"] = "@class.outer",
					},
					-- Below will go to either the start or the end, whichever is closer.
					-- Use if you want more granular movements
					-- Make it even more gradual by adding multiple queries and regex.
					goto_next = {
						["]d"] = "@conditional.outer",
					},
					goto_previous = {
						["[d"] = "@conditional.outer",
					},
				},

				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},

				lsp_interop = {
					enable = true,
					border = "none",
					floating_preview_opts = {},
					-- peek_definition_code = {
					--   ["<leader>df"] = "@function.outer",
					--   ["<leader>dF"] = "@class.outer",
					-- },
				},
			},

			-- Additional modules
			ensure_installed = {}, -- Managed by Nix, so leave empty
			auto_install = false, -- Don't auto-install, Nix handles this
			sync_install = false, -- Don't sync install

			-- Additional parser configurations
			parser_install_dir = nil, -- Use default

			-- Folding
			fold = {
				enable = false, -- Enable if you want treesitter-based folding
				disable = {},
			},
		})

		-- Set foldmethod to treesitter if folding is enabled
		-- vim.opt.foldmethod = "expr"
		-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		-- vim.opt.foldenable = false -- Start with folds open

		-- Additional treesitter-based features can be configured here
		-- For example, if you have other treesitter plugins
	end,
}
