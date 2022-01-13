local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.zk = {
  default_config = {
    cmd = { 'zk', 'lsp' },
    filetypes = { 'markdown' },
    root_dir = util.root_pattern '.zk',
  },

  docs = {
    description = [[
github.com/mickael-menu/zk

A plain text note-taking assistant
]],
    default_config = {
      root_dir = [[root_pattern(".zk")]],
    },
  },
}

configs.zk.index = function()
  vim.lsp.buf.execute_command {
    command = 'zk.index',
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
end

configs.zk.new = function(...)
  vim.lsp.buf_request(
    0,
    'workspace/executeCommand',
    {
      command = 'zk.new',
      arguments = {
        vim.api.nvim_buf_get_name(0),
        ...,
      },
    },
    util.compat_handler(function(_, result, _, _)
      if not (result and result.path) then
        return
      end
      vim.cmd('edit ' .. result.path)
    end)
  )
end
