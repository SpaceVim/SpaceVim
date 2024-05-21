local util = require 'lspconfig.util'

return {
  default_config = {
    settings = {
      FormattingOptions = {
        -- Enables support for reading code style, naming convention and analyzer
        -- settings from .editorconfig.
        EnableEditorConfigSupport = true,
        -- Specifies whether 'using' directives should be grouped and sorted during
        -- document formatting.
        OrganizeImports = nil,
      },
      MsBuild = {
        -- If true, MSBuild project system will only load projects for files that
        -- were opened in the editor. This setting is useful for big C# codebases
        -- and allows for faster initialization of code navigation features only
        -- for projects that are relevant to code that is being edited. With this
        -- setting enabled OmniSharp may load fewer projects and may thus display
        -- incomplete reference lists for symbols.
        LoadProjectsOnDemand = nil,
      },
      RoslynExtensionsOptions = {
        -- Enables support for roslyn analyzers, code fixes and rulesets.
        EnableAnalyzersSupport = nil,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = nil,
        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        AnalyzeOpenDocumentsOnly = nil,
      },
      Sdk = {
        -- Specifies whether to include preview versions of the .NET SDK when
        -- determining which version to use for project loading.
        IncludePrereleases = true,
      },
    },

    filetypes = { 'cs', 'vb' },
    root_dir = util.root_pattern('*.sln', '*.csproj', 'omnisharp.json', 'function.json'),
    on_new_config = function(new_config, _)
      -- Get the initially configured value of `cmd`
      new_config.cmd = { unpack(new_config.cmd or {}) }

      -- Append hard-coded command arguments
      table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
      vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
      table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
      vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
      table.insert(new_config.cmd, '--languageserver')

      -- Append configuration-dependent command arguments
      local function flatten(tbl)
        local ret = {}
        for k, v in pairs(tbl) do
          if type(v) == 'table' then
            for _, pair in ipairs(flatten(v)) do
              ret[#ret + 1] = k .. ':' .. pair
            end
          else
            ret[#ret + 1] = k .. '=' .. vim.inspect(v)
          end
        end
        return ret
      end
      if new_config.settings then
        vim.list_extend(new_config.cmd, flatten(new_config.settings))
      end

      -- Disable the handling of multiple workspaces in a single instance
      new_config.capabilities = vim.deepcopy(new_config.capabilities)
      new_config.capabilities.workspace.workspaceFolders = false -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
    end,
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/omnisharp/omnisharp-roslyn
OmniSharp server based on Roslyn workspaces

`omnisharp-roslyn` can be installed by downloading and extracting a release from [here](https://github.com/OmniSharp/omnisharp-roslyn/releases).
OmniSharp can also be built from source by following the instructions [here](https://github.com/omnisharp/omnisharp-roslyn#downloading-omnisharp).

OmniSharp requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

**By default, omnisharp-roslyn doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of the unzipped run script or binary.

For `go_to_definition` to work fully, extended `textDocument/definition` handler is needed, for example see [omnisharp-extended-lsp.nvim](https://github.com/Hoffs/omnisharp-extended-lsp.nvim)

```lua
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },

    settings = {
      FormattingOptions = {
        -- Enables support for reading code style, naming convention and analyzer
        -- settings from .editorconfig.
        EnableEditorConfigSupport = true,
        -- Specifies whether 'using' directives should be grouped and sorted during
        -- document formatting.
        OrganizeImports = nil,
      },
      MsBuild = {
        -- If true, MSBuild project system will only load projects for files that
        -- were opened in the editor. This setting is useful for big C# codebases
        -- and allows for faster initialization of code navigation features only
        -- for projects that are relevant to code that is being edited. With this
        -- setting enabled OmniSharp may load fewer projects and may thus display
        -- incomplete reference lists for symbols.
        LoadProjectsOnDemand = nil,
      },
      RoslynExtensionsOptions = {
        -- Enables support for roslyn analyzers, code fixes and rulesets.
        EnableAnalyzersSupport = nil,
        -- Enables support for showing unimported types and unimported extension
        -- methods in completion lists. When committed, the appropriate using
        -- directive will be added at the top of the current file. This option can
        -- have a negative impact on initial completion responsiveness,
        -- particularly for the first few completion sessions after opening a
        -- solution.
        EnableImportCompletion = nil,
        -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
        -- true
        AnalyzeOpenDocumentsOnly = nil,
      },
      Sdk = {
        -- Specifies whether to include preview versions of the .NET SDK when
        -- determining which version to use for project loading.
        IncludePrereleases = true,
      },
    },
}
```
]],
    default_config = {
      root_dir = [[root_pattern("*.sln", "*.csproj", "omnisharp.json", "function.json")]],
    },
  },
}
