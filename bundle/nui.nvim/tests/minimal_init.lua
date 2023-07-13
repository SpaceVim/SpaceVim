-- mimic startup option `--clean`
local function clean_startup()
  for _, path in ipairs(vim.split(vim.o.runtimepath, ",")) do
    if
      string.find(path, vim.fn.expand("~/.config/nvim"))
      or string.find(path, vim.fn.expand("~/.local/share/nvim/site"))
    then
      vim.opt.packpath:remove(path)
      vim.opt.runtimepath:remove(path)
    end
  end
end

clean_startup()

local root_dir = vim.fn.fnamemodify(vim.trim(vim.fn.system("git rev-parse --show-toplevel")), ":p")

package.path = string.format("%s;%s?.lua;%s?/init.lua", package.path, root_dir, root_dir)

vim.opt.packpath:prepend(root_dir .. ".testcache/site")

vim.opt.runtimepath:prepend(root_dir)

vim.cmd([[
  packadd plenary.nvim
]])
