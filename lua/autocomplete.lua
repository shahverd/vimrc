-- Configure Autocomplete behavior
vim.o.completeopt = "menu,menuone,noinsert,popup,preview"
vim.o.pumheight = 10    -- limit menu height
vim.o.pumblend  = 10    -- slight transparency

local function show_suggestion_menu()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)

  -- Trigger completion after typing letters, dots, or arrows
  if before_cursor:match('[%w_]$') or before_cursor:match('%.$') or before_cursor:match('->$') then
    if vim.fn.pumvisible() == 0 then
      -- Trigger the menu
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n')
    end
  end
end

local function complete_signature()
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
    vim.lsp.buf_request(0, 'textDocument/signatureHelp', vim.lsp.util.make_position_params(), function(err, result)
      if err or not result or not result.signatures or #result.signatures == 0 then return end

      local sig = result.signatures[1].label
      local args = sig:match("%((.*)%)")
      if not args then return end

      local line = vim.api.nvim_get_current_line()
      local col = vim.fn.col(".")
      local start = line:find("%(") or col

      local new = line:sub(1, start) .. args .. line:sub(col + 1) .. ")"
      vim.api.nvim_set_current_line(new)

      vim.cmd("stopinsert")
      vim.cmd("normal! vf,")
    end)

  end

end

local function show_signature_help()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)

  -- Show signature help when inside function parentheses
  if before_cursor:match('%(') or before_cursor:match(',') then
    -- Use pcall to prevent errors and configure to not focus
    pcall(vim.lsp.buf.signature_help, { focusable = false })
  end

end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Auto-trigger completion as you type
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      callback = show_suggestion_menu
    })

    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      callback = complete_signature
    })
    -- Auto-show signature help with proper configuration
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      callback = show_signature_help
    })
  end,
})

-------keymap for autocomplete and accept suggestion---------
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })
vim.keymap.set('i', '<CR>', function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end, 
  { expr = true, noremap = true })
vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, 
  { expr = true, noremap = true })
