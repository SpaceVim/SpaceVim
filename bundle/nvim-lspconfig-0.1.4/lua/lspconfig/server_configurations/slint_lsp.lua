return {
  default_config = {
    cmd = { 'slint-lsp' },
    filetypes = { 'slint' },
    single_file_support = true,
  },
  docs = {
    description = [=[
https://github.com/slint-ui/slint
`Slint`'s language server

You can build and install `slint-lsp` binary with `cargo`:
```sh
cargo install slint-lsp
```

Vim does not have built-in syntax for the `slint` filetype at this time.

This can be added via an autocmd:

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.slint set filetype=slint ]]
```
]=],
  },
}
