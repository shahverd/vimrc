-- Enable LSP for C
-- You need to have clangd binary on your system

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


-- Enable inline diagnostics
vim.diagnostic.config({
  virtual_text = {
    spacing = 2,
    prefix = "●",
  },
  update_in_insert = false, 
  underline = true,
  signs = true,
})
