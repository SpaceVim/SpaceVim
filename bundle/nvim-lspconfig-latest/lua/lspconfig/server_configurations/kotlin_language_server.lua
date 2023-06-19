local util = require 'lspconfig.util'

local bin_name = 'kotlin-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin. I am not sure whether the language server supports Ant projects,
--  but I'm keeping it here as well since Ant does support Kotlin.
local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
  'build.xml', -- Ant
  'pom.xml', -- Maven
}

local fallback_root_files = {
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

return {
  default_config = {
    filetypes = { 'kotlin' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
    end,
    cmd = { bin_name },
  },
  docs = {
    description = [[
    A kotlin language server which was developed for internal usage and
    released afterwards. Maintaining is not done by the original author,
    but by fwcd.

    It is built via gradle and developed on github.
    Source and additional description:
    https://github.com/fwcd/kotlin-language-server

    This server requires vim to be aware of the kotlin-filetype.
    You could refer for this capability to:
    https://github.com/udalov/kotlin-vim (recommended)
    Note that there is no LICENSE specified yet.
    ]],
    default_config = {
      root_dir = [[root_pattern("settings.gradle")]],
      cmd = { 'kotlin-language-server' },
      capabilities = [[
      smart code completion,
      diagnostics,
      hover,
      document symbols,
      definition lookup,
      method signature help,
      dependency resolution,
      additional plugins from: https://github.com/fwcd

      Snipped of License (refer to source for full License):

      The MIT License (MIT)

      Copyright (c) 2016 George Fraser
      Copyright (c) 2018 fwcd

      ]],
    },
  },
}
