vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set packpath=/tmp/nvt-min/site]]
local package_root = "/tmp/nvt-min/site/pack"
local install_path = package_root .. "/packer/start/packer.nvim"
local function load_plugins()
  require("packer").startup {
    {
      "wbthomason/packer.nvim",
      "kyazdani42/nvim-tree.lua",
      "kyazdani42/nvim-web-devicons",
      -- ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
    },
    config = {
      package_root = package_root,
      compile_path = install_path .. "/plugin/packer_compiled.lua",
      display = { non_interactive = true },
    },
  }
end
if vim.fn.isdirectory(install_path) == 0 then
  print "Installing nvim-tree and dependencies."
  vim.fn.system { "git", "clone", "--depth=1", "https://github.com/wbthomason/packer.nvim", install_path }
end
load_plugins()
require("packer").sync()
vim.cmd [[autocmd User PackerComplete ++once echo "Ready!" | lua setup()]]
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- MODIFY NVIM-TREE SETTINGS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
_G.setup = function()
  require("nvim-tree").setup {}
end

