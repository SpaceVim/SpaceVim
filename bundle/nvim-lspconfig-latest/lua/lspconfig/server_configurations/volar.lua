local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib')) or ''
end

-- https://github.com/johnsoncodehk/volar/blob/20d713b/packages/shared/src/types.ts
local volar_init_options = {
  typescript = {
    tsdk = '',
  },
}

return {
  default_config = {
    cmd = { 'vue-language-server', '--stdio' },
    filetypes = { 'vue' },
    root_dir = util.root_pattern 'package.json',
    init_options = volar_init_options,
    on_new_config = function(new_config, new_root_dir)
      if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.tsdk == ''
      then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/johnsoncodehk/volar/tree/20d713b/packages/vue-language-server

Volar language server for Vue

Volar can be installed via npm:

```sh
npm install -g @vue/language-server
```

Volar by default supports Vue 3 projects. Vue 2 projects need
[additional configuration](https://github.com/vuejs/language-tools/tree/master/packages/vscode-vue#usage).

**TypeScript support**
As of release 2.0.0, Volar no longer wraps around tsserver. For typescript
support, `tsserver` needs to be configured with the `@vue/typescript-plugin`
plugin.

**Take Over Mode**

Volar (prior to 2.0.0), can serve as a language server for both Vue and TypeScript via [Take Over Mode](https://github.com/johnsoncodehk/volar/discussions/471).

To enable Take Over Mode, override the default filetypes in `setup{}` as follows:

```lua
require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
```

**Overriding the default TypeScript Server used by Volar**

The default config looks for TS in the local `node_modules`. This can lead to issues
e.g. when working on a [monorepo](https://monorepo.tools/). The alternatives are:

- use a global TypeScript Server installation

```lua
require'lspconfig'.volar.setup{
  init_options = {
    typescript = {
      tsdk = '/path/to/.npm/lib/node_modules/typescript/lib'
      -- Alternative location if installed as root:
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
    }
  }
}
```

- use a local server and fall back to a global TypeScript Server installation

```lua
local util = require 'lspconfig.util'
local function get_typescript_server_path(root_dir)

  local global_ts = '/home/[yourusernamehere]/.npm/lib/node_modules/typescript/lib'
  -- Alternative location if installed as root:
  -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts =  util.path.join(path, 'node_modules', 'typescript', 'lib')
    if util.path.exists(found_ts) then
      return path
    end
  end
  if util.search_ancestors(root_dir, check_dir) then
    return found_ts
  else
    return global_ts
  end
end

require'lspconfig'.volar.setup{
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
}
```
    ]],
  },
}
