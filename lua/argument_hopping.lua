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

