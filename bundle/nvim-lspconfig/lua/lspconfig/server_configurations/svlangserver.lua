local util = require 'lspconfig.util'

local bin_name = 'svlangserver'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

local function build_index()
  local params = {
    command = 'systemverilog.build_index',
  }
  vim.lsp.buf.execute_command(params)
end

local function report_hierarchy()
  local params = {
    command = 'systemverilog.report_hierarchy',
    arguments = { vim.fn.expand '<cword>' },
  }
  vim.lsp.buf.execute_command(params)
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'verilog', 'systemverilog' },
    root_dir = function(fname)
      return util.root_pattern '.svlangserver'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      systemverilog = {
        includeIndexing = { '*.{v,vh,sv,svh}', '**/*.{v,vh,sv,svh}' },
      },
    },
  },
  commands = {
    SvlangserverBuildIndex = {
      build_index,
      description = 'Instructs language server to rerun indexing',
    },
    SvlangserverReportHierarchy = {
      report_hierarchy,
      description = 'Generates hierarchy for the given module',
    },
  },
  docs = {
    description = [[
https://github.com/imc-trading/svlangserver

Language server for SystemVerilog.

`svlangserver` can be installed via `npm`:

```sh
$ npm install -g @imc-trading/svlangserver
```
]],
    default_config = {
      root_dir = [[root_pattern(".svlangserver", ".git")]],
    },
  },
}
