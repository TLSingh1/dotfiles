-- nvim-surround - Add/change/delete surrounding delimiter pairs with ease

return {
	"nvim-surround",

	-- Only load if coding category is enabled
	enabled = function()
		return nixCats.cats.coding
	end,

	event = { "BufReadPre", "BufNewFile" },
	after = function()
		require("nvim-surround").setup({
			-- Number of lines within which surrounding is searched
			highlight = {
				duration = 0, -- Highlight duration in milliseconds
			},
			-- Keymaps for the plugin
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
			-- Configuration for specific surrounds
			surrounds = {
				-- Custom surround for function calls
				["f"] = {
					add = function()
						local result = require("nvim-surround.config").get_input("Function name: ")
						if result then
							return { { result .. "(" }, { ")" } }
						end
					end,
					find = function()
						return require("nvim-surround.config").get_selection({ pattern = "[^=%s%(%)]+%b()" })
					end,
					delete = "^(.-%()().-(%))()$",
					change = {
						target = "^.-([%w_]+)()%(.-%)()()$",
						replacement = function()
							local result = require("nvim-surround.config").get_input("Function name: ")
							if result then
								return { { result }, { "" } }
							end
						end,
					},
				},
				-- Custom surround for HTML tags
				["t"] = {
					add = function()
						local result = require("nvim-surround.config").get_input("Tag name: ")
						if result then
							return { { "<" .. result .. ">" }, { "</" .. result .. ">" } }
						end
					end,
					find = function()
						return require("nvim-surround.config").get_selection({ pattern = "<.->.-</.->", selection = "inner" })
					end,
					delete = "^(%<.->)().-(%</[^>]+>)()$",
					change = {
						target = "^<([^%s>]+)(.-)>.-</%1>$",
						replacement = function()
							local result = require("nvim-surround.config").get_input("Tag name: ")
							if result then
								return { { result }, { "" } }
							end
						end,
					},
				},
				-- Add angle brackets
				["<"] = {
					add = { "<", ">" },
					find = function()
						return require("nvim-surround.config").get_selection({ pattern = "<.->", selection = "inner" })
					end,
					delete = "^(.)().-()().$",
					change = {
						target = "^(.)().-()().$",
					},
				},
				[">"] = {
					add = { "<", ">" },
					find = function()
						return require("nvim-surround.config").get_selection({ pattern = "<.->", selection = "inner" })
					end,
					delete = "^(.)().-()().$",
					change = {
						target = "^(.)().-()().$",
					},
				},
			},
			-- Aliases for convenience
			aliases = {
				["a"] = ">", -- Single character aliases
				["b"] = ")",
				["B"] = "}",
				["r"] = "]",
				["q"] = { '"', "'", "`" }, -- Quote alias
			},
			-- Whether to indent inserted lines
			indent_lines = function(start, stop)
				local b = vim.bo
				-- Only re-indent if 'indentexpr' is set
				if b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp then
					vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
				end
			end,
			-- Whether to move cursor to the first character of the surrounding
			move_cursor = "begin",
		})
	end,
}