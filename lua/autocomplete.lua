-- Configure Autocomplete behavior
vim.o.completeopt = "menu,menuone,noinsert,popup,preview"
vim.o.pumheight = 10    -- limit menu height
vim.o.pumblend  = 10    -- slight transparency

-------keymap for autocomplete and accept suggestion---------
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })
vim.keymap.set('i', '<CR>', function() 
  if vim.fn.pumvisible() == 1 then 
    return "<C-y>" 
  else 
    return "<CR>" 
  end
end, { expr = true, noremap = true })

vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, 
{ expr = true, noremap = true })
-------------------------------------------------------------------------

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

local function insert_signature()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local before_cursor = line:sub(1, col)

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(err, result)
    if err or not result or not result.signatures or #result.signatures == 0 then return end

    local sig = result.signatures[1]
    if not sig then return end

    local args = sig.label:match('%((.*)%)')
    if not args or args == "" then return end

    local new_line = line:sub(1, col) .. args .. ')' .. line:sub(col + 1)
    vim.api.nvim_set_current_line(new_line)

    vim.cmd("stopinsert")
    vim.cmd("normal! vf,")
  end)
end



-- Detect if a completion entry is a function/method
local function is_fn_completion()
  local item = vim.v.completed_item
  local kind = item.kind  -- string such as "Function", "Method"
  return kind == "Function" or kind == "Method"
end

-- After confirmation of completion, insert '(' and trigger signatureHelp
vim.api.nvim_create_autocmd("CompleteDone", {
  callback = function()
    if vim.fn.pumvisible() == 1 then
      return
    end

    if is_fn_completion() then
      -- Insert '(' only if it's not already there
      -- the ')' will be inserted inside insert_signature
      local col = vim.fn.col('.')
      local next_char = vim.fn.getline('.'):sub(col, col)
      if next_char ~= '(' then
        vim.api.nvim_put({ "(" }, "", true, true)
      end

      insert_signature()
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Auto-trigger completion as you type
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      callback = function()
        show_suggestion_menu()
        show_signature_help()
      end
    })

  end,
})

