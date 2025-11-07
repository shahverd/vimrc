vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.cmd.colorscheme 'unokai'

vim.keymap.set('n', '<leader>v', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', function() vim.cmd(vim.fn.exists(':Rexplore') == 1 and 'Rexplore' or 'Explore') end)

-- After a short delay fix list style in netrw
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 0
  end,
})

--================PLUGINS=================--

require("lsp")
require("autocomplete")
require("debug")
