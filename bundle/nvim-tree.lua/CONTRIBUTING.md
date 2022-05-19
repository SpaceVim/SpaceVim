# Contributing to `nvim-tree.lua`

Thank you for contributing.

## Styling and formatting

Code is formatted using luacheck, and linted using stylua.
You can install these with:

```bash
luarocks install luacheck
cargo install stylua
```

## Adding new actions

To add a new action, add a file in `actions/name-of-the-action.lua`. You should export a `setup` function if some configuration is needed.

## Documentation

When adding new options, you should declare the defaults in the main `nvim-tree.lua` file.
Once you did, you should run the `update-default-opts.sh` script which will update the default documentation in the README and the help file.

Documentation for options should also be added, see how this is done after `nvim-tree.disable_netrw` in the `nvim-tree-lua.txt` file.
