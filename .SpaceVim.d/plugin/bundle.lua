local b = require('spacevim.dev.bundle')
vim.api.nvim_create_user_command('SPBundleUpdate', function(opt)
  local bundles = b.get_bundles()
  for _, v in pairs(bundles) do
    if v.repo == opt.fargs[1] then
      b.download(v)
    end
  end
end, { nargs = 1, complete = b.complete })
