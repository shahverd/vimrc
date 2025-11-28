-- Autocomplete settings
vim.o.completeopt = "menu,menuone,noinsert,popup,preview"
vim.o.pumheight = 10
vim.o.pumblend = 10

-- Keymaps
vim.keymap.set("i", "<C-Space>", "<C-x><C-o>", { noremap = true })

vim.keymap.set('i', '<CR>', function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, noremap = true })

vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, noremap = true })

-- Helper functions
local function show_suggestion_menu()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)
  
  local triggers = { '[%w_]$', '%.$', '->$' }
  for _, pattern in ipairs(triggers) do
    if before_cursor:match(pattern) and vim.fn.pumvisible() == 0 then
      vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true), 'n')
      return
    end
  end
end

local function show_signature_help()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before_cursor = line:sub(1, col)
  
  if before_cursor:match('%(') or before_cursor:match(',') then
    pcall(vim.lsp.buf.signature_help, { focusable = false })
  end
end

local function insert_signature()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local params = vim.lsp.util.make_position_params()
  
  vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(err, result)
    if err or not result or not result.signatures or #result.signatures == 0 then
      return
    end
    
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

local function is_fn_completion()
  local kind = vim.v.completed_item.kind
  return kind == "Function" or kind == "Method"
end

-- Autocmds
vim.api.nvim_create_autocmd("CompleteDone", {
  callback = function()
    if vim.fn.pumvisible() == 1 or not is_fn_completion() then
      return
    end
    
    local col = vim.fn.col('.')
    local next_char = vim.fn.getline('.'):sub(col, col)
    
    if next_char ~= '(' then
      -- The ')' will be inserted inside 'insert_signature'
      vim.api.nvim_put({ "(" }, "", true, true)
    end
    
    insert_signature()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    
    vim.api.nvim_create_autocmd({'TextChangedI', 'TextChangedP'}, {
      buffer = args.buf,
      callback = function()
        show_suggestion_menu()
        show_signature_help()
      end
    })
  end,
})
