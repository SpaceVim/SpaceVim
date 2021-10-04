local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js'))
    or ''
end

local server_name = 'volar'
local bin_name = 'volar-server'

-- https://github.com/johnsoncodehk/volar/blob/master/packages/shared/src/types.ts
local volar_init_options = {
  typescript = {
    serverPath = '',
  },
  languageFeatures = {
    -- not supported - https://github.com/neovim/neovim/pull/14122
    semanticTokens = false,
    references = true,
    definition = true,
    typeDefinition = true,
    callHierarchy = true,
    hover = true,
    rename = true,
    renameFileRefactoring = true,
    signatureHelp = true,
    codeAction = true,
    completion = {
      defaultTagNameCase = 'both',
      defaultAttrNameCase = 'kebabCase',
    },
    schemaRequestService = true,
    documentHighlight = true,
    documentLink = true,
    codeLens = true,
    diagnostics = true,
  },
  documentFeatures = {
    -- not supported - https://github.com/neovim/neovim/pull/13654
    documentColor = false,
    selectionRange = true,
    foldingRange = true,
    linkedEditingRange = true,
    documentSymbol = true,
    documentFormatting = {
      defaultPrintWidth = 100,
    },
  },
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'vue' },
    root_dir = util.root_pattern 'package.json',
    init_options = volar_init_options,
    on_new_config = function(new_config, new_root_dir)
      if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.serverPath == ''
      then
        new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/johnsoncodehk/volar/tree/master/packages/server

Volar language server for Vue
Volar can be installed via npm
```sh
npm install -g @volar/server
```

With Vue 3 projects - it works out of the box.

With Vue 2 projects - requires [additional configuration](https://github.com/johnsoncodehk/volar#using)

Do not run `vuels` and `volar` at the same time.

To check which language servers are running, open a `.vue` file and run the `:LspInfo` command.
]],
  },
}
