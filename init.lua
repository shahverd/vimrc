vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:2'
--vim.opt.winborder = 'single'
-- vim.cmd.colorscheme 'delek'
vim.cmd.colorscheme 'unokai'

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20
vim.g.netrw_browse_split = 4
--vim.g.netrw_altv = 1

-- Toggle Vexplore with <Leader>e
vim.keymap.set('n', '<Leader>e', function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, "filetype") == "netrw" then
      -- If a netrw buffer exists, close it
      vim.api.nvim_buf_delete(buf, { force = true })
      return
    end
  end
  -- Otherwise, open Vexplore
  vim.cmd("Vexplore")
end, { noremap = true, silent = true })

-- Show Vexplore instead of Explore for directory
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) == 1 then
      vim.cmd("Vexplore")
    end
  end
})


--------------------------PLUGINS-------------------------------

-- Enable LSP for C
vim.lsp.enable('clangd', {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  -- Optional: Add settings specific to clangd
  settings = {
    clangd = {
      -- Example: Set the compilation database path if needed
      arguments = {
        '--compile-commands-dir=build'
      },
    }
  }
})

-- Show error/warning message of LSP
vim.keymap.set('n', '<leader>d', 
  vim.diagnostic.open_float, 
  {
    desc = "Show full diagnostic message"
  }
)

-- Enable better code completion
local cmp = require('cmp')
cmp.setup({
  -- The list of completion sources to use
  sources = {
    -- LSP suggestions (from cmp-nvim-lsp)
    { name = 'nvim_lsp' },
    
    -- Current buffer text 
    -- (from cmp-buffer, often another required plugin)
    { name = 'buffer' }, 
  },

  -- Keymappings for the completion menu
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), 
    ['<C-e>'] = cmp.mapping.abort(), 
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
  }),

  -- Appearance and other settings
  completion = {
    keyword_length = 1, -- Start completion after 1 character
  },
})
