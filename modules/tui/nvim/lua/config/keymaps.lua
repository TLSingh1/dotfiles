-- Basic keymaps

local keymap = vim.keymap.set
local nvim_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
nvim_keymap("n", "<leader>d", ":vs <CR>", opts)
nvim_keymap("n", "<leader>s", ":split <CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", "<cmd>bnext<CR>")
keymap("n", "<S-h>", "<cmd>bprevious<CR>")
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

nvim_keymap("n", "<leader>w", "<cmd>w<CR>", opts)
nvim_keymap("i", "jk", "<ESC><right>", opts)
