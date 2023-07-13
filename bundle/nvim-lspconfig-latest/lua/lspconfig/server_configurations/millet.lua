local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'millet' },
    filetypes = { 'sml' },
    root_dir = util.root_pattern 'millet.toml',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/azdavis/millet

Millet, a language server for Standard ML

To use with nvim:

1. Install a Rust toolchain: https://rustup.rs
2. Clone the repo
3. Run `cargo build --release --bin lang-srv`
4. Move `target/release/lang-srv` to somewhere on your $PATH as `millet`
    ]],
  },
}
