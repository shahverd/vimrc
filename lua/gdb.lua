-- debug.lua - GDB integration for Neovim

-- Sign definition for breakpoint
vim.fn.sign_define('GdbBreakpoint', {text='B', texthl='Error', linehl='', numhl=''})

local M = {}

-- Sign definition for breakpoint
vim.fn.sign_define('GdbBreakpoint', {text='B', texthl='Error', linehl='', numhl=''})

-- Store breakpoints
local breakpoints = {}

-- Start GDB in a terminal split
function M.start(program)
  if vim.g.gdb_term == nil then
    vim.cmd("vsplit | terminal gdb " .. program)
    vim.g.gdb_term = vim.b.terminal_job_id
    print("GDB started in terminal split.")
  else
    print("GDB already running.")
  end
end

-- Stop GDB properly
function M.stop()
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
    print("GDB terminal not started. Run :lua require('gdb').start('./build/MyProject')")
  end
end

-- Toggle breakpoint
function M.toggle_breakpoint()
  local bufnr = vim.api.nvim_get_current_buf()
  local lnum = vim.fn.line('.')
  local file = vim.fn.fnamemodify(vim.fn.expand('%:p'), ':.') -- relative to cwd
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

return M
