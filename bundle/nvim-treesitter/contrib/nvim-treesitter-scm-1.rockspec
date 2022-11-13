local MODREV, SPECREV = "scm", "-1"
rockspec_format = "3.0"
package = "nvim-treesitter"
version = MODREV .. SPECREV

description = {
	summary = "Nvim Treesitter configurations and abstraction layer",
	labels = { "neovim"},
	homepage = "https://github.com/nvim-treesitter/nvim-treesitter",
	license = "Apache-2.0",
}

dependencies = {
	"lua >= 5.1, < 5.4",
}

source = {
	url = "http://github.com/nvim-treesitter/nvim-treesitter/archive/v" .. MODREV .. ".zip",
}

if MODREV == 'scm' then
  source = {
    url = 'git://github.com/nvim-treesitter/nvim-treesitter',
  }
end

build = {
   type = "builtin",
   copy_directories = {
	 'plugin'
   }
}
