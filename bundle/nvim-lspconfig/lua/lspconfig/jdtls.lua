local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local handlers = require 'vim.lsp.handlers'

local server_name = 'jdtls'

local sysname = vim.loop.os_uname().sysname
local env = {
  HOME = vim.loop.os_homedir(),
  JAVA_HOME = os.getenv 'JAVA_HOME',
  JDTLS_HOME = os.getenv 'JDTLS_HOME',
  WORKSPACE = os.getenv 'WORKSPACE',
}

local function get_java_executable()
  local executable = env.JAVA_HOME and util.path.join(env.JAVA_HOME, 'bin', 'java') or 'java'

  return sysname:match 'Windows' and executable .. '.exe' or executable
end

local function get_workspace_dir()
  return env.WORKSPACE and env.WORKSPACE or util.path.join(env.HOME, 'workspace')
end

local function get_jdtls_jar()
  return vim.fn.expand '$JDTLS_HOME/plugins/org.eclipse.equinox.launcher_*.jar'
end

local function get_jdtls_config()
  if sysname:match 'Linux' then
    return util.path.join(env.JDTLS_HOME, 'config_linux')
  elseif sysname:match 'Darwin' then
    return util.path.join(env.JDTLS_HOME, 'config_mac')
  elseif sysname:match 'Windows' then
    return util.path.join(env.JDTLS_HOME, 'config_win')
  else
    return util.path.join(env.JDTLS_HOME, 'config_linux')
  end
end

-- Non-standard notification that can be used to display progress
local function on_language_status(_, _, result)
  local command = vim.api.nvim_command
  command 'echohl ModeMsg'
  command(string.format('echo "%s"', result.message))
  command 'echohl None'
end

-- TextDocument version is reported as 0, override with nil so that
-- the client doesn't think the document is newer and refuses to update
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

local root_files = {
  -- Single-module projects
  {
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  -- Multi-module projects
  { 'build.gradle', 'build.gradle.kts' },
}

configs[server_name] = {
  default_config = {
    cmd = {
      get_java_executable(),
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '-Xmx2G',
      '-jar',
      get_jdtls_jar(),
      '-configuration',
      get_jdtls_config(),
      '-data',
      get_workspace_dir(),
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
    },
    filetypes = { 'java' },
    root_dir = function(fname)
      for _, patterns in ipairs(root_files) do
        local root = util.root_pattern(unpack(patterns))(fname)
        if root then
          return root
        end
      end
      return vim.fn.getcwd()
    end,
    init_options = {
      workspace = get_workspace_dir(),
      jvm_args = {},
      os_config = nil,
    },
    handlers = {
      -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
      -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
      ['textDocument/codeAction'] = function(a, b, actions)
        for _, action in ipairs(actions) do
          -- TODO: (steelsojka) Handle more than one edit?
          if action.command == 'java.apply.workspaceEdit' then -- 'action' is Command in java format
            action.edit = fix_zero_version(action.edit or action.arguments[1])
          elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
            action.edit = fix_zero_version(action.edit or action.command.arguments[1])
          end
        end
        handlers['textDocument/codeAction'](a, b, actions)
      end,

      ['textDocument/rename'] = function(a, b, workspace_edit)
        handlers['textDocument/rename'](a, b, fix_zero_version(workspace_edit))
      end,

      ['workspace/applyEdit'] = function(a, b, workspace_edit)
        handlers['workspace/applyEdit'](a, b, fix_zero_version(workspace_edit))
      end,

      ['language/status'] = vim.schedule_wrap(on_language_status),
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/redhat-developer/vscode-java/master/package.json',
    description = [[
https://projects.eclipse.org/projects/eclipse.jdt.ls

Language server for Java.

IMPORTANT: If you want all the features jdtls has to offer, [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
you can keep reading here.

For manual installation you can download precompiled binaries from the
[official downloads site](http://download.eclipse.org/jdtls/snapshots/?d)

Due to the nature of java, settings cannot be inferred. Please set the following
environmental variables to match your installation. If you need per-project configuration
[direnv](https://github.com/direnv/direnv) is highly recommended.

```bash
# Mandatory:
# .bashrc
export JDTLS_HOME=/path/to/jdtls_root # Directory with the plugin and configs directories

# Optional:
export JAVA_HOME=/path/to/java_home # In case you don't have java in path or want to use a version in particular
export WORKSPACE=/path/to/workspace # Defaults to $HOME/workspace
```
```lua
  -- init.lua
  require'lspconfig'.jdtls.setup{}
```

For automatic installation you can use the following unofficial installers/launchers under your own risk:
  - [jdtls-launcher](https://github.com/eruizc-dev/jdtls-launcher) (Includes lombok support by default)
    ```lua
      -- init.lua
      require'lspconfig'.jdtls.setup{ cmd = { 'jdtls' } }
    ```
    ]],
    default_config = {
      root_dir = [[{
        -- Single-module projects
        {
          'build.xml', -- Ant
          'pom.xml', -- Maven
          'settings.gradle', -- Gradle
          'settings.gradle.kts', -- Gradle
        },
        -- Multi-module projects
        { 'build.gradle', 'build.gradle.kts' },
      } or vim.fn.getcwd()]],
    },
  },
}
