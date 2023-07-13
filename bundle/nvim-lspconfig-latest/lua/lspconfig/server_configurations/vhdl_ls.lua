local util = require 'lspconfig.util'

local root_files = {
  'vhdl_ls.toml',
  '.vhdl_ls.toml',
}

return {
  default_config = {
    cmd = { 'vhdl_ls' },
    filetypes = { 'vhd', 'vhdl' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
Install vhdl_ls from https://github.com/VHDL-LS/rust_hdl and add it to path

Configuration

The language server needs to know your library mapping to perform full analysis of the code. For this it uses a configuration file in the TOML format named vhdl_ls.toml.

vhdl_ls will load configuration files in the following order of priority (first to last):

    A file named .vhdl_ls.toml in the user home folder.
    A file name from the VHDL_LS_CONFIG environment variable.
    A file named vhdl_ls.toml in the workspace root.

Settings in a later files overwrites those from previously loaded files.

Example vhdl_ls.toml
```
# File names are either absolute or relative to the parent folder of the vhdl_ls.toml file
[libraries]
lib2.files = [
  'pkg2.vhd',
]
lib1.files = [
  'pkg1.vhd',
  'tb_ent.vhd'
]
```
]],
  },
}
