local util = require 'lspconfig.util'

local root_files = {
  'compile_commands.json',
  '.ccls',
}

return {
  default_config = {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    single_file_support = false,
  },
  docs = {
    description = [[
https://github.com/MaskRay/ccls/wiki

ccls relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html) specified
as compile_commands.json or, for simpler projects, a .ccls.
For details on how to automatically generate one using CMake look [here](https://cmake.org/cmake/help/latest/variable/CMAKE_EXPORT_COMPILE_COMMANDS.html). Alternatively, you can use [Bear](https://github.com/rizsotto/Bear).

Customization options are passed to ccls at initialization time via init_options, a list of available options can be found [here](https://github.com/MaskRay/ccls/wiki/Customization#initialization-options). For example:

```lua
local lspconfig = require'lspconfig'
lspconfig.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = { "-frounding-math"} ;
    };
  }
}

```

]],
    default_config = {
      root_dir = [[root_pattern('compile_commands.json', '.ccls', '.git')]],
    },
  },
}
