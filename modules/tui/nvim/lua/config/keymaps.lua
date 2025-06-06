-- Basic keymaps

local keymap = vim.keymap.set
local nvim_keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

nvim_keymap("i", "jk", "<ESC><right>", opts)
nvim_keymap("n", "<leader>w", ":w <CR>", opts)
nvim_keymap("n", "<leader>q", ":q <CR>", opts)
nvim_keymap("n", "<leader>Q", ":bdelete <cr>", opts)
nvim_keymap("n", "<leader><leader>q", ":qa <CR>", opts)
nvim_keymap("n", "<leader>Y", ":%y <CR>", opts)
nvim_keymap("x", "p", "p:let @+=@0<CR>", opts)
nvim_keymap("n", "<c-n>", ":bdelete <cr>", opts)
nvim_keymap("n", "<leader>;", ":", opts)
nvim_keymap("n", "<S-l>", ":bnext<CR>", opts)
nvim_keymap("n", "<S-h>", ":bprevious<CR>", opts)

------------------- Navigation ----------------
nvim_keymap("n", "<leader>h", "<C-w>h", opts)
nvim_keymap("n", "<leader>j", "<C-w>j", opts)
nvim_keymap("n", "<leader>k", "<C-w>k", opts)
nvim_keymap("n", "<leader>l", "<C-w>l", opts)
---
------------------- Window --------------------
nvim_keymap("n", "<leader>d", ":vs <CR>", opts)
nvim_keymap("n", "<leader>s", ":split <CR>", opts)
-- vim.keymap.set("n", "<C-h>", require("smart-splits").resize_left)
-- vim.keymap.set("n", "<C-j>", require("smart-splits").resize_down)
-- vim.keymap.set("n", "<C-k>", require("smart-splits").resize_up)
-- vim.keymap.set("n", "<C-l>", require("smart-splits").resize_right)
-- keymap("n", "<leader><leader>h", "<cmd>lua require('smart-splits').swap_buf_left() vim.cmd('wincmd h')<CR>", opts)
-- keymap("n", "<leader><leader>j", "<cmd>lua require('smart-splits').swap_buf_down() vim.cmd('wincmd j')<CR>", opts)
-- keymap("n", "<leader><leader>k", "<cmd>lua require('smart-splits').swap_buf_up() vim.cmd('wincmd k')<CR>", opts)
-- keymap("n", "<leader><leader>l", "<cmd>lua require('smart-splits').swap_buf_right() vim.cmd('wincmd l')<CR>", opts)
--------------------------------------------------------------------------------



-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")


-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move text up and down
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Fix cursor position to be ON first non-blank character, not before it
vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.') - 1
    local first_non_blank = line:find('%S')
    
    if first_non_blank and col < first_non_blank - 1 then
      vim.api.nvim_win_set_cursor(0, {vim.fn.line('.'), first_non_blank - 1})
    end
  end
})

