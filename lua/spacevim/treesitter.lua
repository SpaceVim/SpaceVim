local M = {}

function M.setup()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {},

    sync_install = false,

    auto_install = false,

    ignore_install = {},

    highlight = {
      enable = false,
      disable = {"lua"},
      additional_vim_regex_highlighting = false,
    },
  })
end
return M
