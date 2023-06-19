local util = require 'lspconfig.util'

-- Angular requires a node_modules directory to probe for @angular/language-service and typescript
-- in order to use your projects configured versions.
-- This defaults to the vim cwd, but will get overwritten by the resolved root of the file.
local function get_probe_dir(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)

  return project_root and (project_root .. '/node_modules') or ''
end

local default_probe_dir = get_probe_dir(vim.fn.getcwd())

return {
  default_config = {
    cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      default_probe_dir,
      '--ngProbeLocations',
      default_probe_dir,
    },
    filetypes = { 'typescript', 'html', 'typescriptreact', 'typescript.tsx' },
    -- Check for angular.json since that is the root of the project.
    -- Don't check for tsconfig.json or package.json since there are multiple of these
    -- in an angular monorepo setup.
    root_dir = util.root_pattern 'angular.json',
  },
  on_new_config = function(new_config, new_root_dir)
    local new_probe_dir = get_probe_dir(new_root_dir)

    -- We need to check our probe directories because they may have changed.
    new_config.cmd = {
      'ngserver',
      '--stdio',
      '--tsProbeLocations',
      new_probe_dir,
      '--ngProbeLocations',
      new_probe_dir,
    }
  end,
  docs = {
    description = [[
https://github.com/angular/vscode-ng-language-service

`angular-language-server` can be installed via npm `npm install -g @angular/language-server`.

Note, that if you override the default `cmd`, you must also update `on_new_config` to set `new_config.cmd` during startup.

```lua
local project_library_path = "/path/to/project/lib"
local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}

require'lspconfig'.angularls.setup{
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
```
    ]],
    default_config = {
      root_dir = [[root_pattern("angular.json")]],
    },
  },
}
