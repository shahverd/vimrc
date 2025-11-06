vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.cmd.colorscheme 'unokai'

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', function() 
  vim.cmd(vim.fn.exists(':Rexplore') == 1 and 'Rexplore' or 'Explore') end)


vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 0
  end,
})

--------------PLUGINS-------------
-- Enable LSP for C
vim.lsp.enable('clangd', { filetypes = { 'c', 'objc'}, })

-- Enable better code completion
require('cmp').setup({ sources = {
  { name = 'nvim_lsp' },
  { name = 'buffer' }, 
}})
