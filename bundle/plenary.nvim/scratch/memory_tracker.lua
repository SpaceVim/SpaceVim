local nvim_pid = 2201099 

vim.api.nvim_buf_set_lines(981, 0, -1, false, vim.fn.systemlist({'pmap', tostring(nvim_pid), '-X'}))
