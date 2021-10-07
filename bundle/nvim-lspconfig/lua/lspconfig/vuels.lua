local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vuels'
local bin_name = 'vls'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'vue' },
    root_dir = util.root_pattern('package.json', 'vue.config.js'),
    init_options = {
      config = {
        vetur = {
          useWorkspaceDependencies = false,
          validation = {
            template = true,
            style = true,
            script = true,
          },
          completion = {
            autoImport = false,
            useScaffoldSnippets = false,
            tagCasing = 'kebab',
          },
          format = {
            defaultFormatter = {
              js = 'none',
              ts = 'none',
            },
            defaultFormatterOptions = {},
            scriptInitialIndent = false,
            styleInitialIndent = false,
          },
        },
        css = {},
        html = {
          suggest = {},
        },
        javascript = {
          format = {},
        },
        typescript = {
          format = {},
        },
        emmet = {},
        stylusSupremacy = {},
      },
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/vuejs/vetur/master/package.json',
    description = [[
https://github.com/vuejs/vetur/tree/master/server

Vue language server(vls)
`vue-language-server` can be installed via `npm`:
```sh
npm install -g vls
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "vue.config.js")]],
      init_options = {
        config = {
          vetur = {
            useWorkspaceDependencies = false,
            validation = {
              template = true,
              style = true,
              script = true,
            },
            completion = {
              autoImport = false,
              useScaffoldSnippets = false,
              tagCasing = 'kebab',
            },
            format = {
              defaultFormatter = {
                js = 'none',
                ts = 'none',
              },
              defaultFormatterOptions = {},
              scriptInitialIndent = false,
              styleInitialIndent = false,
            },
          },
          css = {},
          html = {
            suggest = {},
          },
          javascript = {
            format = {},
          },
          typescript = {
            format = {},
          },
          emmet = {},
          stylusSupremacy = {},
        },
      },
    },
  },
}
