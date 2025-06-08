local function set_fallback_colorscheme()
	if not (nixCats and nixCats.cats and nixCats.cats.ui) then
		vim.cmd.colorscheme("default")
	end
end

set_fallback_colorscheme()

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		-- You can add any colorscheme-specific customizations here
		-- For example, custom highlight groups or adjustments
	end,
})
