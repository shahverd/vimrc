vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.g.netrw_liststyle = 3
vim.cmd.colorscheme 'unokai'

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'filetype') == 'netrw' then
      vim.cmd("Rex")
      return 
    end
  end
  vim.cmd("Explore")
end)

--------------------------PLUGINS-------------------------------
-- Enable LSP for C
vim.lsp.enable('clangd', { filetypes = { 'c', 'objc'}, })

-- Enable better code completion
require('cmp').setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }, 
  },
})
