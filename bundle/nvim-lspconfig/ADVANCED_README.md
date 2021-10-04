## Advanced usage

**All provided examples are in Lua,** see `:help :lua-heredoc` to use Lua from your init.vim,
or the quickstart above for an example of a lua heredoc.

Each config provides a `setup()` function to initialize the server with reasonable default
initialization options and settings, as well as some server-specific commands. This is 
invoked in the following form, where `<server>` corresponds to the language server name
in [CONFIG.md](CONFIG.md).

`setup()` takes optional arguments <config>, each of which overrides the respective 
part of the default configuration. The allowed arguments are detailed [below](#setup-function).
```lua
require'lspconfig'.<server>.setup{<config>}
```

### Example: using the defaults

To use the defaults, just call `setup()` with an empty `config` parameter.
For the `gopls` config, that would be:

```lua
require'lspconfig'.gopls.setup{}
```

### Example: override some defaults

To set some config properties at `setup()`, specify their keys. For example to
change how the "project root" is found, set the `root_dir` key:

```lua
local lspconfig = require'lspconfig'
lspconfig.gopls.setup{
  root_dir = lspconfig.util.root_pattern('.git');
}
```

The [documentation](CONFIG.md) for each config lists default values and
additional optional properties. For a more complicated example overriding 
the `name`, `log_level`, `message_level`, and `settings` of texlab:

```lua
local lspconfig = require'lspconfig'
lspconfig.texlab.setup{
  name = 'texlab_fancy';
  settings = {
    latex = {
      build = {
        onSave = true;
      }
    }
  }
}
```

### Example: custom config

To configure a custom/private server, just 

1. load the lspconfig module: `local lspconfig = require('lspconfig')`,
2. Define the config: `lspconfig.configs.foo_lsp = { … }`
3. Call `setup()`: `lspconfig.foo_lsp.setup{}`

```lua
local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
-- Check if it's already defined for when reloading this file.
if not lspconfig.foo_lsp then
  configs.foo_lsp = {
    default_config = {
      cmd = {'/home/ashkan/works/3rd/lua-language-server/run.sh'};
      filetypes = {'lua'};
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
      end;
      settings = {};
    };
  }
end
lspconfig.foo_lsp.setup{}
```

### Example: override default config for all servers

If you want to change default configs for all servers, you can override default_config like this. In this example, we additionally add a check for log_level and message_level which can be passed to the server to control the verbosity of "window/logMessage".

```lua
local lspconfig = require'lspconfig'
lspconfig.util.default_config = vim.tbl_extend(
  "force",
  lspconfig.util.default_config,
  {
    autostart = false,
    handlers = {
      ["window/logMessage"] = function(err, method, params, client_id)
          if params and params.type <= vim.lsp.protocol.MessageType.Log then
            vim.lsp.handlers["window/logMessage"](err, method, params, client_id)
          end
        end;
      ["window/showMessage"] = function(err, method, params, client_id)
          if params and params.type <= vim.lsp.protocol.MessageType.Warning.Error then
            vim.lsp.handlers["window/showMessage"](err, method, params, client_id)
          end
        end;
    }
  }
)
```

## setup() function

setup() extends the arguments listed in `:help vim.lsp.start_client()`. **In addition to all of the arguments defined for start_client**, the following key/value pairs can be passed to the setup function:

```
lspconfig.SERVER.setup{config}

  The `config` parameter has the same shape as that of
  |vim.lsp.start_client()|, with these additions:

  {root_dir}
    Required for some servers, optional for others.
    Function of the form `function(filename, bufnr)`.
    Called on new candidate buffers being attached-to.
    Returns either a root_dir or nil.

    If a root_dir is returned, then this file will also be attached. You
    can optionally use {filetype} to help pre-filter by filetype.

    If a root_dir is returned which is unique from any previously returned
    root_dir, a new server will be spawned with that root_dir.

    If nil is returned, the buffer is skipped.

    See |lspconfig.util.search_ancestors()| and the functions which use it:
    - |lspconfig.util.root_pattern(pattern1, pattern2...)| is a variadic function which
      takes string patterns as arguments, and finds an ancestor 
      which contains one of the files matching the pattern. 
      Each pattern can be a specific filename, such as ".git", or a glob.  
      See `:help glob` for allowed patterns.  This is equivalent to
      coc.nvim's "rootPatterns"
    - Related utilities for common tools:
      - |lspconfig.util.find_git_root()|
      - |lspconfig.util.find_node_modules_root()|
      - |lspconfig.util.find_package_json_root()|

  {name}
    Defaults to the server's name.

  {filetypes}
    Set of filetypes to filter for consideration by {root_dir}.
    May be empty.
    Server may specify a default value.

  {autostart}
    Whether to automatically start a language server when a matching filetype is detected.
    Defaults to true.

  {on_new_config}
    `function(new_config, new_root_dir)` will be executed after a new configuration has been
    created as a result of {root_dir} returning a unique value. You can use this
    as an opportunity to further modify the new_config or use it before it is
    sent to |vim.lsp.start_client()|. If you set a custom `on_new_config`, ensure that 
    `new_config.cmd = cmd` is present within the function body.
```
