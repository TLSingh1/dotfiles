return {
	"image.nvim",

	-- Only load if ui category is enabled
	enabled = false,
	-- enabled = function()
	--   return nixCats.cats.ui
	-- end,

	ft = { "markdown", "norg", "typst", "html", "css" },

	after = function()
		require("image").setup({
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					filetypes = { "markdown", "vimwiki" },
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					filetypes = { "norg" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_width = nil,
			max_height = nil,
			max_width_window_percentage = nil,
			max_height_window_percentage = 50,
			window_overlap_clear_enabled = false,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			editor_only_render_when_focused = false,
			tmux_show_only_in_active_window = false,
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end,
}
