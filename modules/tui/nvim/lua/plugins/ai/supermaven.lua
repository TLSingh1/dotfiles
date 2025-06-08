return {
	"supermaven-nvim",

	enabled = function()
		return nixCats.cats.ai
	end,

	event = "DeferredUIEnter",
	after = function()
		require("supermaven-nvim").setup({
			keymaps = {
				accept_suggestion = "<Tab>",
				clear_suggestion = "<C-]>",
				accept_word = "<C-j>",
			},
			ignore_filetypes = {
				gitcommit = true,
				gitrebase = true,
				help = true,
				markdown = true,
			},
			color = {
				suggestion_color = "#808080",
				cterm = 244,
			},
			log_level = "off",
			disable_inline_completion = false,
			disable_keymaps = false,
			condition = function()
				-- Disable in very large files (>10k lines) for performance
				local line_count = vim.api.nvim_buf_line_count(0)
				if line_count > 10000 then
					return true
				end

				-- Disable in certain file patterns
				local filename = vim.fn.expand("%:t")
				if string.match(filename, "%.min%.") then -- minified files
					return true
				end

				return false
			end,
		})
	end,
}

