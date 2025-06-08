vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "

local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 1,
	completeopt = { "menuone", "noselect" },
	conceallevel = 2,
	-- conceallevel = 3, TODO: uncomment after
	fileencoding = "utf-8",
	hlsearch = false,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	showtabline = 0,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	splitkeep = "screen",
	swapfile = false,
	termguicolors = true,
	timeoutlen = 1000,
	undofile = true,
	updatetime = 300,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "yes",
	wrap = true,
	-- wrap = false,
	scrolloff = 8,
	laststatus = 3,
	breakindent = true,
	linebreak = true,
	winhighlight = "Normal:ActiveWindow,NormalNC:InactiveWindow",
	foldlevel = 99, -- Using ufo provider need a large value
	foldenable = true,
	foldlevelstart = 99,
	fillchars = { eob = " " },
	startofline = true, -- Move cursor to first non-blank character
	virtualedit = "", -- Ensure cursor can't move past actual characters
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
