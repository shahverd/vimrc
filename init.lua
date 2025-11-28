vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.cmd.colorscheme 'unokai'
-- vim.cmd.colorscheme 'delek'

--================PLUGINS=================--

require("file_explorer")
require("lsp_settings")
require("autocomplete")
require("argument_hopping")
require("debug_gdb")

--================KEYMAPS=================--
-- Make terminal esc act like normal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true }) 
vim.keymap.set('n', '<leader>t',  ":vsplit | terminal<CR>")

-- Swap / and \ for my personal keyboard
vim.keymap.set({'n','x','o'}, '/', '\\')
vim.keymap.set({'n','x','o'}, '\\', '/')
vim.keymap.set('i', '/', '\\')
vim.keymap.set('i', '\\', '/')
vim.keymap.set('c', '/', '\\')
vim.keymap.set('c', '\\', '/')

-- Window movement in normal mode
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
