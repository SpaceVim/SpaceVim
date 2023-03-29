local util = require 'lspconfig.util'

local bin_name = 'gradle-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

local root_files = {
  'settings.gradle', -- Gradle (multi-project)
}

local fallback_root_files = {
  'build.gradle', -- Gradle
}

return {
  default_config = {
    filetypes = { 'groovy' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
    end,
    cmd = { bin_name },
    -- gradle-language-server expects init_options.settings to be defined
    init_options = {
      settings = {
        gradleWrapperEnabled = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/microsoft/vscode-gradle

Microsoft's lsp server for gradle files

If you're setting this up manually, build vscode-gradle using `./gradlew installDist` and point `cmd` to the `gradle-language-server` generated in the build directory
]],
    default_config = {
      root_dir = [[root_pattern("settings.gradle")]],
      cmd = { 'gradle-language-server' },
      init_options = {
        settings = {
          gradleWrapperEnabled = true,
        },
      },
    },
  },
}
