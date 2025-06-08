return {
	"lsp_lines.nvim",
	enabled = function()
		return nixCats.cats.coding
	end,
	event = "LspAttach",
	after = function()
		require("lsp_lines").setup({})
	end,
}
