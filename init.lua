vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.signcolumn = 'yes:1'
vim.cmd.colorscheme 'unokai'

vim.keymap.set('n', '<leader>v', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>e', function() vim.cmd(vim.fn.exists(':Rexplore') == 1 and 'Rexplore' or 'Explore') end)

-- After a short delay fix list style in netrw
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.g.netrw_liststyle = 3
    vim.g.netrw_browse_split = 0
  end,
})

--================PLUGINS=================--

-- Enable LSP for C
-- You need to have clangd binary on your system
vim.lsp.enable('clangd', { filetypes = { 'c', 'objc'}, })

-- Enable better code completion
require('cmp').setup({ sources = {
  { name = 'nvim_lsp' },
  { name = 'buffer' }, 
}})

-- Enable debug C with GDB
-- Keymaps
vim.api.nvim_set_keymap('n', '<leader>dc', ":lua StartGDB('./build/MyProject')<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>dq', ":lua StopGDB()<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap('n', '<leader>db', ":lua ToggleBreakpoint()<CR>", {noremap=true, silent=true})
-- Sign definition for breakpoint
vim.fn.sign_define('GdbBreakpoint', {text='B', texthl='Error', linehl='', numhl=''})

-- Store breakpoints
local breakpoints = {}

-- Start GDB in a terminal split
function StartGDB(program)
  if vim.g.gdb_term == nil then
    vim.cmd("vsplit | terminal gdb " .. program)
    vim.g.gdb_term = vim.b.terminal_job_id
    print("GDB started in terminal split.")
  else
    print("GDB already running.")
  end
end

-- Stop GDB properly
function StopGDB()
  if vim.g.gdb_term then
    -- Send quit command to GDB
    vim.api.nvim_chan_send(vim.g.gdb_term, "quit\n")
    -- Clear the global variable
    vim.g.gdb_term = nil
    print("GDB stopped.")
  else
    print("GDB is not running.")
  end
end

-- Send command to GDB terminal
local function send_to_gdb(cmd)
  if vim.g.gdb_term then
    vim.api.nvim_chan_send(vim.g.gdb_term, cmd .. "\n")
  else
    print("GDB terminal not started. Run StartGDB('./build/MyProject')")
  end
end

-- Toggle breakpoint
function ToggleBreakpoint()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.fn.line('.')
  local file = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.')  -- relative to cwd
  local key = file .. ':' .. lnum

  if breakpoints[key] then
    -- Remove sign
    vim.fn.sign_unplace('gdb', {buffer = bufnr, id = breakpoints[key]})
    breakpoints[key] = nil
    send_to_gdb("clear " .. file .. ":" .. lnum)
    print("Breakpoint removed at " .. file .. ":" .. lnum)
  else
    -- Place sign
    local id = vim.fn.sign_place(0, 'gdb', 'GdbBreakpoint', file, {lnum = lnum})
    breakpoints[key] = id
    send_to_gdb("break " .. file .. ":" .. lnum)
    print("Breakpoint set at " .. file .. ":" .. lnum)
  end
end
----------------END GDB-----------------------
