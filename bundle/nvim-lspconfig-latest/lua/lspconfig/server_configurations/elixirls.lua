return {
  default_config = {
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    root_dir = function(fname)
      local matches = vim.fs.find({ 'mix.exs' }, { upward = true, limit = 2, path = fname })
      local child_or_root_path, maybe_umbrella_path = unpack(matches)
      local root_dir = vim.fs.dirname(maybe_umbrella_path or child_or_root_path)

      return root_dir
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elixir-lsp/elixir-ls

`elixir-ls` can be installed by following the instructions [here](https://github.com/elixir-lsp/elixir-ls#building-and-running).

```bash
curl -fLO https://github.com/elixir-lsp/elixir-ls/releases/latest/download/elixir-ls.zip
unzip elixir-ls.zip -d /path/to/elixir-ls
# Unix
chmod +x /path/to/elixir-ls/language_server.sh
```

**By default, elixir-ls doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your unzipped elixir-ls.

```lua
require'lspconfig'.elixirls.setup{
    -- Unix
    cmd = { "/path/to/elixir-ls/language_server.sh" };
    -- Windows
    cmd = { "/path/to/elixir-ls/language_server.bat" };
    ...
}
```

'root_dir' is chosen like this: if two or more directories containing `mix.exs` were found when searching directories upward, the second one (higher up) is chosen, with the assumption that it is the root of an umbrella app. Otherwise the directory containing the single mix.exs that was found is chosen.
]],
    default_config = {
      root_dir = '{{see description above}}',
    },
  },
}
