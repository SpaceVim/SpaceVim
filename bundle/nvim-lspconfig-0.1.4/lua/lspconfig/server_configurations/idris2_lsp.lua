local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'idris2-lsp' },
    filetypes = { 'idris2' },
    root_dir = util.root_pattern '*.ipkg',
  },
  docs = {
    description = [[
https://github.com/idris-community/idris2-lsp

The Idris 2 language server.

Plugins for the Idris 2 filetype include
[Idris2-Vim](https://github.com/edwinb/idris2-vim) (fewer features, stable) and
[Nvim-Idris2](https://github.com/ShinKage/nvim-idris2) (cutting-edge,
experimental).

Idris2-Lsp requires a build of Idris 2 that includes the "Idris 2 API" package.
Package managers with known support for this build include the
[AUR](https://aur.archlinux.org/packages/idris2/) and
[Homebrew](https://formulae.brew.sh/formula/idris2#default).

If your package manager does not support the Idris 2 API, you will need to build
Idris 2 from source. Refer to the
[the Idris 2 installation instructions](https://github.com/idris-lang/Idris2/blob/main/INSTALL.md)
for details.  Steps 5 and 8 are listed as "optional" in that guide, but they are
necessary in order to make the Idris 2 API available.

You need to install a version of Idris2-Lsp that is compatible with your
version of Idris 2. There should be a branch corresponding to every released
Idris 2 version after v0.4.0. Use the latest commit on that branch. For example,
if you have Idris v0.5.1, you should use the v0.5.1 branch of Idris2-Lsp.

If your Idris 2 version is newer than the newest Idris2-Lsp branch, use the
latest commit on the `master` branch, and set a reminder to check the Idris2-Lsp
repo for the release of a compatible versioned branch.
]],
  },
}
