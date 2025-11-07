-- Configure Autocomplete behavior
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })

vim.o.completeopt = "menu,menuone,noselect"
vim.o.pumheight = 10    -- limit menu height
vim.o.pumblend = 10     -- slight transparency

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    -- Key mappings
    local opts = { buffer = bufnr }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    
    -- Auto-trigger completion as you type
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      buffer = bufnr,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = line:sub(1, col)
        
        -- Trigger completion after typing letters, dots, or arrows
        if before_cursor:match('[%w_]$') or before_cursor:match('%.$') or before_cursor:match('->$') then
          -- Check if completion menu is not already visible
          if vim.fn.pumvisible() == 0 then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n')
          end
        end
      end,
    })
    
    -- Auto-show signature help when typing parameters
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      buffer = bufnr,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = line:sub(1, col)
        
        -- Show signature help when inside function parentheses
        if before_cursor:match('%(') or before_cursor:match(',') then
          vim.lsp.buf.signature_help()
        end
      end,
    })
  end,
})

