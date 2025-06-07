return {
	"lsp_lines.nvim",
	enabled = function()
		return nixCats.cats.coding
	end,
	event = "LspAttach",
	after = function()
		require("lsp_lines").setup({})

		-- Toggle keybinding
		-- vim.keymap.set("", "<Leader>i", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
	end,
}
