vim.g.mapleader = " "

vim.opt.number = true
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99
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

------------------------
require("which-key").setup({
icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
})
require'nvim-web-devicons'.setup {
 -- your personal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- set the light or dark variant manually, instead of relying on `background`
 -- (default to nil)
 variant = "light|dark";
 -- override blend value for all highlight groups :h highlight-blend.
 -- setting this value to `0` will make all icons opaque. in practice this means
 -- that icons width will not be affected by pumblend option (see issue #608)
 -- (default to nil)
 blend = 0;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}
