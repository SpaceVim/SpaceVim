if vim.api.nvim_create_user_command then
  vim.api.nvim_create_user_command('Nvim', function(opt)
    local cmd = { 'nvim-qt', '--' }
    for _, v in pairs(opt.fargs) do
      table.insert(cmd, v)
    end

    vim.fn.jobstart(cmd)
  end, { nargs = '*', complete = 'file' })

  vim.api.nvim_create_user_command('Vim', function(opt)
    local cmd = { 'gvim' }
    for _, v in pairs(opt.fargs) do
      table.insert(cmd, v)
    end

    vim.fn.jobstart(cmd, {
      env = {
        VIM = '',
        VIMRUNTIME = '',
      },
    })
  end, { nargs = '*', complete = 'file' })
end
