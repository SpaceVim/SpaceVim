local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    settings = {
      -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
      redhat = { telemetry = { enabled = false } },
    },
  },
  docs = {
    description = [[
https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `yarn`:
```sh
yarn global add yaml-language-server
```

To use a schema for validation, there are two options:

1. Add a modeline to the file. A modeline is a comment of the form:

```
# yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
```

where the relative filepath is the path relative to the open yaml file, and the absolute filepath
is the filepath relative to the filesystem root ('/' on unix systems)

2. Associated a schema url, relative , or absolute (to root of project, not to filesystem root) path to
the a glob pattern relative to the detected project root. Check `:LspInfo` to determine the resolved project
root.

```lua
require('lspconfig').yamlls.setup {
  ... -- other configuration for setup {}
  settings = {
    yaml = {
      ... -- other settings. note this overrides the lspconfig defaults.
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["../path/relative/to/file.yml"] = "/.github/workflows/*",
        ["/path/from/root/of/project"] = "/.github/workflows/*",
      },
    },
  }
}
```

Currently, kubernetes is special-cased in yammls, see the following upstream issues:
* [#211](https://github.com/redhat-developer/yaml-language-server/issues/211).
* [#307](https://github.com/redhat-developer/yaml-language-server/issues/307).

To override a schema to use a specific k8s schema version (for example, to use 1.18):

```lua
require('lspconfig').yamlls.setup {
  ... -- other configuration for setup {}
  settings = {
    yaml = {
      ... -- other settings. note this overrides the lspconfig defaults.
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
        ... -- other schemas
      },
    },
  }
}
```

]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
