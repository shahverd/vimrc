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
require("debug")
