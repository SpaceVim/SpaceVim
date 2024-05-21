local util = require 'lspconfig.util'

local function get_default_mavenrepo()
  local repo = util.path.join(vim.env.HOME, '.m2', 'repository', 'dk', 'au', 'ece', 'vdmj')
  if util.path.exists(repo) then
    return repo
  else
    return util.path.join(vim.env.HOME, '.m2', 'repository', 'com', 'fujitsu')
  end
end

local function get_jar_path(config, package, version)
  return util.path.join(config.options.mavenrepo, package, version, package .. '-' .. version .. '.jar')
end

local function with_precision(version, is_high_precision)
  return is_high_precision and version:gsub('([%d.]+)', '%1-P') or version
end

local function get_latest_installed_version(repo)
  local path = util.path.join(repo, 'lsp')
  local sort = vim.fn.sort

  local subdirs = function(file)
    local stat = vim.loop.fs_stat(util.path.join(path, file))
    return stat.type == 'directory' and 1 or 0
  end

  local candidates = vim.fn.readdir(path, subdirs)
  local sorted = sort(sort(candidates, 'l'), 'N')
  return sorted[#sorted]
end

-- Special case, as vdmj store particular settings under root_dir/.vscode
local function find_vscode_ancestor(startpath)
  return util.search_ancestors(startpath, function(path)
    if util.path.is_dir(util.path.join(path, '.vscode')) then
      return path
    end
  end)
end

return {
  default_config = {
    cmd = { 'java' },
    filetypes = { 'vdmsl', 'vdmpp', 'vdmrt' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or find_vscode_ancestor(fname)
    end,
    options = {
      java = vim.env.JAVA_HOME and util.path.join(vim.env.JAVA_HOME, 'bin', 'java') or 'java',
      java_opts = { '-Xmx3000m', '-Xss1m' },
      annotation_paths = {},
      mavenrepo = get_default_mavenrepo(),
      logfile = util.path.join(vim.fn.stdpath 'cache', 'vdm-lsp.log'),
      debugger_port = -1,
      high_precision = false,
    },
  },
  docs = {
    description = [[
https://github.com/nickbattle/vdmj

The VDMJ language server can be installed by cloning the VDMJ repository and
running `mvn clean install`.

Various options are provided to configure the language server (see below). In
particular:
- `annotation_paths` is a list of folders and/or jar file paths for annotations
that should be used with the language server;
- any value of `debugger_port` less than zero will disable the debugger; note
that if a non-zero value is used, only one instance of the server can be active
at a time.

More settings for VDMJ can be changed in a file called `vdmj.properties` under
`root_dir/.vscode`. For a description of the available settings, see
[Section 7 of the VDMJ User Guide](https://raw.githubusercontent.com/nickbattle/vdmj/master/vdmj/documentation/UserGuide.pdf).

Note: proof obligations and combinatorial testing are not currently supported
by neovim.
]],
    default_config = {
      cmd = 'Generated from the options given',
      root_dir = 'util.find_git_ancestor(fname) or find_vscode_ancestor(fname)',
      options = {
        java = '$JAVA_HOME/bin/java',
        java_opts = { '-Xmx3000m', '-Xss1m' },
        annotation_paths = {},
        mavenrepo = '$HOME/.m2/repository/dk/au/ece/vdmj',
        version = 'The latest version installed in `mavenrepo`',
        logfile = "path.join(vim.fn.stdpath 'cache', 'vdm-lsp.log')",
        debugger_port = -1,
        high_precision = false,
      },
    },
  },
  on_new_config = function(config, root_dir)
    local version = with_precision(
      config.options.version or get_latest_installed_version(config.options.mavenrepo),
      config.options.high_precision
    )

    local classpath = table.concat({
      get_jar_path(config, 'vdmj', version),
      get_jar_path(config, 'annotations', version),
      get_jar_path(config, 'lsp', version),
      util.path.join(root_dir, '.vscode'),
      unpack(config.options.annotation_paths),
    }, ':')

    local java_cmd = {
      config.options.java,
      config.options.java_opts,
      '-Dlsp.log.filename=' .. config.options.logfile,
      '-cp',
      classpath,
    }

    local dap = {}

    if config.options.debugger_port >= 0 then
      -- TODO: LS will fail to start if port is already in use
      dap = { '-dap', tostring(config.options.debugger_port) }
    end

    local vdmj_cmd = {
      'lsp.LSPServerStdio',
      '-' .. vim.bo.filetype,
      dap,
    }

    config.cmd = util.tbl_flatten { java_cmd, vdmj_cmd }
  end,
}
