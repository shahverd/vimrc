-- Enable LSP for C
-- You need to have clangd binary on your system
vim.keymap.set('n', 'gd',         vim.lsp.buf.definition)
vim.keymap.set('n', 'K',          vim.lsp.buf.hover)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d',         vim.diagnostic.goto_next)

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.lsp.start({
      name = "clangd",
      cmd = { "clangd" },
      root_dir = vim.fn.getcwd(),
    })
  end,
})
