vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.cmd.colorscheme 'unokai'

--================PLUGINS=================--

require("explore")
require("lsp")
require("autocomplete")
local gdb = require("gdb")

--================KEYMAPS=================--

-- Window movement in normal mode
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Make terminal esc act like normal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true }) 
vim.keymap.set('n', '<leader>t',  ":vsplit | terminal<CR>")

vim.keymap.set('n', 'gd',         vim.lsp.buf.definition)
vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d',         vim.diagnostic.goto_next)

vim.keymap.set('n', '<leader>k',  vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>v',  vim.diagnostic.open_float)

vim.keymap.set( 'n', '<leader>dc', ":lua require('gdb').start('./build/MyProject')<CR>", {noremap=true, silent=true})
vim.keymap.set( 'n', '<leader>dq', ":lua require('gdb').stop()<CR>", {noremap=true, silent=true})
vim.keymap.set( 'n', '<leader>db', ":lua require('gdb').toggle_breakpoint()<CR>", {noremap=true, silent=true})

