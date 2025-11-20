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

              vim.cmd('stopinsert')
              vim.cmd('normal! vf,') -- select first parameter

            end
          end)
        end
      end,
    })

    -- Auto-show signature help with proper configuration
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      buffer = bufnr,
      callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local before_cursor = line:sub(1, col)

        -- Show signature help when inside function parentheses
        if before_cursor:match('%(') or before_cursor:match(',') then
          -- Use pcall to prevent errors and configure to not focus
          pcall(vim.lsp.buf.signature_help, { focusable = false })
        end
      end,
    })
  end,
})


-------keymap for autocomplete accept suggestion---------
vim.keymap.set('i', '<CR>',  function()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  else
    return "<CR>"
  end
end,{expr = true, noremap = true})

vim.keymap.set('i', '<Tab>',  function()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
  else
    return "<Tab>"
  end
end,{expr = true, noremap = true})
------------keymap for arguments hopping----------------
local function select_current_arg()
  local start = vim.fn.search(",\\|(", "cbW", vim.fn.line('.'))
  if start == 0 then return end
  vim.cmd("normal! l")
  vim.cmd("normal! v")

  local finish = vim.fn.search(",\\|)", "cW")
  if finish == 0 then return end
  vim.cmd("normal! h")
end

vim.keymap.set("n", "<Tab>", select_current_arg)
vim.keymap.set("n", "<S-Tab>", function()
  local start_prev = vim.fn.search(",\\|(", "cbW", vim.fn.line('.'))
  if start_prev == 0 then return end

  vim.cmd("normal! h")

  select_current_arg()
end)

vim.keymap.set("v", "<Tab>", function()
  vim.cmd("normal! l")
  vim.cmd("normal! v") -- exit visual

  select_current_arg()
end, { noremap = true })

vim.keymap.set("v", "<S-Tab>", function()
  local start = vim.fn.search(",\\|(", "cbW", vim.fn.line('.'))
  if start == 0 then return end

  vim.cmd("normal! h")
  vim.cmd("normal! v") -- exit visual

  select_current_arg()
end, { noremap = true })
----------------------------------------------
