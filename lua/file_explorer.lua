
-- Setting for better use of netrw
vim.keymap.set('n', '<leader>e', function() vim.cmd(vim.fn.exists(':Rexplore') == 1 and 'Rexplore' or 'Explore') end)

-- After a short delay fix list style in netrw
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
--     vim.defer_fn(function()
      vim.g.netrw_liststyle = 3
      vim.g.netrw_browse_split = 0
--     end, 350) -- tweak ms if necessary
  end,
})
