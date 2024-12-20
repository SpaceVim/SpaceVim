vim.api.nvim_create_user_command('Format', function(opts)
  require('format').format(opts.bang, opts.args, opts.line1, opts.line2)
end, {
  nargs = '*',
  range = '%',
  bang = true,
  bar = true,
  complete = function(_, line)
    local ft = vim.o.filetype
    local l = vim.split(line, '%s+')
    local ok, default = pcall(require, 'format.ft.' .. ft)
    if ok then
      return vim.tbl_filter(function(val)
        return vim.startswith(val, l[#l])
      end, default.enabled())
    else
    end
  end,
})

