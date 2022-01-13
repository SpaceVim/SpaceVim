local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.pasls = {
  default_config = {
    cmd = { 'pasls' },
    filetypes = { 'pascal' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/genericptr/pascal-language-server

An LSP server implementation for Pascal variants that are supported by Free Pascal, including Object Pascal. It uses CodeTools from Lazarus as backend.

First set `cmd` to the Pascal lsp binary.

Customization options are passed to pasls as environment variables for example in your `.bashrc`:
	    ```bash
export FPCDIR='/usr/lib/fpc/src',
export PP='/usr/lib/fpc/3.2.2/ppcx64',
export LAZARUSDIR='/usr/lib/lazarus',
export FPCTARGET='',
export FPCTARGETCPU='x86_64',

		```

`FPCDIR` : FPC source directory (This is the only required option for the server to work).

`PP` : Path to the Free Pascal compiler executable.

`LAZARUSDIR` : Path to the Lazarus sources.

`FPCTARGET` : Target operating system for cross compiling.

`FPCTARGETCPU` : Target CPU for cross compiling.
]],
  },
}
