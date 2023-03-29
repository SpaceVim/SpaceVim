local util = require 'lspconfig.util'

return {
  default_config = {
    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = false,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,

    filetypes = { 'cs', 'vb' },
    root_dir = function(fname)
      return util.root_pattern '*.sln'(fname) or util.root_pattern '*.csproj'(fname)
    end,
    on_new_config = function(new_config, new_root_dir)
      table.insert(new_config.cmd, '-z') -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
      vim.list_extend(new_config.cmd, { '-s', new_root_dir })
      vim.list_extend(new_config.cmd, { '--hostPID', tostring(vim.fn.getpid()) })
      table.insert(new_config.cmd, 'DotNet:enablePackageRestore=false')
      vim.list_extend(new_config.cmd, { '--encoding', 'utf-8' })
      table.insert(new_config.cmd, '--languageserver')

      if new_config.enable_editorconfig_support then
        table.insert(new_config.cmd, 'FormattingOptions:EnableEditorConfigSupport=true')
      end

      if new_config.organize_imports_on_format then
        table.insert(new_config.cmd, 'FormattingOptions:OrganizeImports=true')
      end

      if new_config.enable_ms_build_load_projects_on_demand then
        table.insert(new_config.cmd, 'MsBuild:LoadProjectsOnDemand=true')
      end

      if new_config.enable_roslyn_analyzers then
        table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableAnalyzersSupport=true')
      end

      if new_config.enable_import_completion then
        table.insert(new_config.cmd, 'RoslynExtensionsOptions:EnableImportCompletion=true')
      end

      if new_config.sdk_include_prereleases then
        table.insert(new_config.cmd, 'Sdk:IncludePrereleases=true')
      end

      if new_config.analyze_open_documents_only then
        table.insert(new_config.cmd, 'RoslynExtensionsOptions:AnalyzeOpenDocumentsOnly=true')
      end
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

```lua
require'lspconfig'.omnisharp.setup {
    cmd = { "dotnet", "/path/to/omnisharp/OmniSharp.dll" },

    -- Enables support for reading code style, naming convention and analyzer
    -- settings from .editorconfig.
    enable_editorconfig_support = true,

    -- If true, MSBuild project system will only load projects for files that
    -- were opened in the editor. This setting is useful for big C# codebases
    -- and allows for faster initialization of code navigation features only
    -- for projects that are relevant to code that is being edited. With this
    -- setting enabled OmniSharp may load fewer projects and may thus display
    -- incomplete reference lists for symbols.
    enable_ms_build_load_projects_on_demand = false,

    -- Enables support for roslyn analyzers, code fixes and rulesets.
    enable_roslyn_analyzers = false,

    -- Specifies whether 'using' directives should be grouped and sorted during
    -- document formatting.
    organize_imports_on_format = false,

    -- Enables support for showing unimported types and unimported extension
    -- methods in completion lists. When committed, the appropriate using
    -- directive will be added at the top of the current file. This option can
    -- have a negative impact on initial completion responsiveness,
    -- particularly for the first few completion sessions after opening a
    -- solution.
    enable_import_completion = false,

    -- Specifies whether to include preview versions of the .NET SDK when
    -- determining which version to use for project loading.
    sdk_include_prereleases = true,

    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
    -- true
    analyze_open_documents_only = false,
}
```
]],
    default_config = {
      root_dir = [[root_pattern(".sln") or root_pattern(".csproj")]],
    },
  },
}
