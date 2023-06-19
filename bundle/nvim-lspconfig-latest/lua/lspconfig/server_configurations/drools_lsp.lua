local util = require 'lspconfig.util'

local function get_java_bin(config)
  local java_bin = vim.tbl_get(config, 'drools', 'java', 'bin')
  if not java_bin then
    java_bin = vim.env.JAVA_HOME and util.path.join(vim.env.JAVA_HOME, 'bin', 'java') or 'java'
    if vim.fn.has 'win32' == 1 then
      java_bin = java_bin .. '.exe'
    end
  end
  return java_bin
end

local function get_java_opts(config)
  local java_opts = vim.tbl_get(config, 'drools', 'java', 'opts')
  return java_opts and java_opts or {}
end

local function get_jar(config)
  local jar = vim.tbl_get(config, 'drools', 'jar')
  return jar and jar or 'drools-lsp-server-jar-with-dependencies.jar'
end

local function get_cmd(config)
  local cmd = vim.tbl_get(config, 'cmd')
  if not cmd then
    cmd = { get_java_bin(config) }
    for _, o in ipairs(get_java_opts(config)) do
      table.insert(cmd, o)
    end
    ---@diagnostic disable-next-line:missing-parameter
    vim.list_extend(cmd, { '-jar', get_jar(config) })
  end
  return cmd
end

return {
  default_config = {
    filetypes = { 'drools' },
    root_dir = util.find_git_ancestor(),
    single_file_support = true,
    on_new_config = function(new_config)
      new_config.cmd = get_cmd(new_config)
    end,
  },
  docs = {
    description = [=[
https://github.com/kiegroup/drools-lsp

Language server for the [Drools Rule Language (DRL)](https://docs.drools.org/latest/drools-docs/docs-website/drools/language-reference/#con-drl_drl-rules).

The `drools-lsp` server is a self-contained java jar file (`drools-lsp-server-jar-with-dependencies.jar`), and can be downloaded from [https://github.com/kiegroup/drools-lsp/releases/](https://github.com/kiegroup/drools-lsp/releases/).

Configuration information:
```lua
-- Option 1) Specify the entire command:
require('lspconfig').drools_lsp.setup {
  cmd = { '/path/to/java', '-jar', '/path/to/drools-lsp-server-jar-with-dependencies.jar' },
}

-- Option 2) Specify just the jar path (the JAVA_HOME environment variable will be respected if present):
require('lspconfig').drools_lsp.setup {
  drools = { jar = '/path/to/drools-lsp-server-jar-with-dependencies.jar' },
}

-- Option 3) Specify the java bin and/or java opts in addition to the jar path:
require('lspconfig').drools_lsp.setup {
  drools = {
    java = { bin = '/path/to/java', opts = { '-Xmx100m' } },
    jar = '/path/to/drools-lsp-server-jar-with-dependencies.jar',
  },
}
```

Neovim does not yet have automatic detection for the `drools` filetype, but it can be added with:
```lua
vim.cmd [[ autocmd BufNewFile,BufRead *.drl set filetype=drools ]]
```
]=],
  },
}
