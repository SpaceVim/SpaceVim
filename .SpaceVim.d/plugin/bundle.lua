local b = require('spacevim.dev.bundle')
vim.api.nvim_create_user_command('SPBundleUpdate', function(opt)
  local bundles = b.get_bundles()
  if opt.fargs[1] == 'all' then for _, v in pairs(bundles) do b.download(v) end end
  for _, v in pairs(bundles) do
    if v.username .. '/' .. v.repo == opt.fargs[1] then
      b.download(v)
      return
    end
  end
  print('can not find bundle:' .. opt.fargs[1])
end, { nargs = 1, complete = b.complete })
