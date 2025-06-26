-- Markdown Preview - Live preview of markdown files in browser
-- Note: Requires Node.js to be installed for diagram rendering (Mermaid, PlantUML, etc.)

return {
	"markdown-preview.nvim",

	-- Only load if ui category is enabled
	enabled = function()
		return nixCats.cats.ui
	end,

	ft = { "markdown" },
	cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },

	keys = {
		{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle markdown preview" },
	},

	before = function()
		-- Set configuration variables before plugin loads
		vim.g.mkdp_auto_start = 0 -- Don't auto-open preview
		vim.g.mkdp_auto_close = 1 -- Auto-close preview when leaving buffer
		vim.g.mkdp_refresh_slow = 0 -- Real-time refresh
		vim.g.mkdp_command_for_global = 0 -- Only available in markdown buffers
		vim.g.mkdp_open_to_the_world = 0 -- Only accessible from localhost
		vim.g.mkdp_open_ip = "" -- Default IP
		vim.g.mkdp_browser = "" -- Use system default browser
		vim.g.mkdp_echo_preview_url = 0 -- Don't echo preview URL
		vim.g.mkdp_browserfunc = "" -- Default browser function
		vim.g.mkdp_theme = "dark" -- Dark theme
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_page_title = "「${name}」"
		vim.g.mkdp_preview_options = {
			mkit = {}, -- markdown-it options (parser engine)
			katex = {}, -- KaTeX options for math rendering
			uml = {}, -- PlantUML options for UML diagrams
			maid = {}, -- Mermaid options for diagrams
			disable_sync_scroll = 0, -- 0 = enable sync scroll, 1 = disable
			sync_scroll_type = "middle", -- cursor position: 'top', 'middle', 'relative'
			hide_yaml_meta = 1, -- 1 = hide YAML frontmatter, 0 = show it
			sequence_diagrams = {}, -- js-sequence-diagrams options
			flowchart_diagrams = {}, -- flowchart.js options
			content_editable = false, -- make preview editable in browser
			disable_filename = 0, -- 0 = show filename in title, 1 = hide
			toc = {}, -- table of contents options
		}
	end,
}

