-- Configure Autocomplete behavior
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })
vim.o.completeopt = "menu,menuone,noinsert"
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
          if vim.fn.pumvisible() == 0 then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n')
          end
        end
      end,
    })







vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
  buffer = bufnr,
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = line:sub(1, col)

    if before_cursor:match('%(') or before_cursor:match(',') then
      -- Avoid repeated insertion: check if there is already text inside parentheses
      local paren_start = line:find('%(')
      local paren_end = line:find(')', paren_start)
      if paren_start and paren_end and paren_end > paren_start + 1 then
        return
      end

      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(bufnr, 'textDocument/signatureHelp', params, function(err, result)
        if err or not result or not result.signatures or #result.signatures == 0 then return end

        local sig = result.signatures[1]
        local sig_label = sig.label
        local parens = sig_label:match('%((.*)%)')
        if parens then
          local start_col = line:find('%(') or col
          local new_line = line:sub(1, start_col) .. parens .. line:sub(col + 1) .. ')'
          vim.api.nvim_set_current_line(new_line)

          -- Move cursor to the end of inserted params and leave insert mode
          -- vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], start_col + #parens })
          vim.cmd('stopinsert')

          vim.cmd('normal! vf,')


        end
      end)
    end
  end,
})





    -- Auto-show signature help with proper configuration
    --  vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      --    buffer = bufnr,
      --    callback = function()
        --      local line = vim.api.nvim_get_current_line()
        --      local col = vim.api.nvim_win_get_cursor(0)[2]
        --      local before_cursor = line:sub(1, col)
        --      
        --      -- Show signature help when inside function parentheses
        --      if before_cursor:match('%(') or before_cursor:match(',') then
        --        -- Use pcall to prevent errors and configure to not focus
        --        pcall(vim.lsp.buf.signature_help, { focusable = false })
        --      end
        --    end,
        --  })
        --


  end,
})
