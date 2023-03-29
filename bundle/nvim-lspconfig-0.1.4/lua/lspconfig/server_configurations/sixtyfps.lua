return {
  default_config = {
    cmd = { 'sixtyfps-lsp' },
    filetypes = { 'sixtyfps' },
    single_file_support = true,
  },
  docs = {
    description = [=[
https://github.com/sixtyfpsui/sixtyfps
`SixtyFPS`'s language server

You can build and install `sixtyfps-lsp` binary with `cargo`:
```sh
cargo install sixtyfps-lsp
```

Vim does not have built-in syntax for the `sixtyfps` filetype currently.

This can be added via an autocmd:

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.60 set filetype=sixtyfps ]]
```

or by installing a filetype plugin such as https://github.com/RustemB/sixtyfps-vim
]=],
  },
}
