if vim.version().major == 0 and vim.version().minor < 7 then
  vim.notify('The AWK language server requires nvim >= 0.7', vim.log.levels.ERROR)
  return
end

return {
  default_config = {
    cmd = { 'awk-language-server' },
    filetypes = { 'awk' },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Beaglefoot/awk-language-server/

`awk-language-server` can be installed via `npm`:
```sh
npm install -g awk-language-server
```
]],
  },
}
