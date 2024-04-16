vim.api.nvim_create_user_command('Format', function(opts)
  require('format').format(opts.bang, opts.args, opts.line1, opts.line2)
end, {
  nargs = '*',
  range = '%',
  bang = true,
  bar = true
})
