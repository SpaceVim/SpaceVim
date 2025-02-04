# nvim-plug

> _nvim-plug_ is a simple plugin manager for neovim

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

**Alpha version. Any changes, including backward incompatible changes, are applied without announcements.**

## Usage

```lua
require('plug').setup({
  bundle_dir = 'D:/bundle_dir',
  max_processes = 5, -- max number of processes used for nvim-plug job
  base_url = 'https://github.com',
})

require('plug').add({
  {
    'wsdjeg/scrollbar.vim',
    events = { 'VimEnter' },
    config = function() end,
  },
  {
    'wsdjeg/flygrep.nvim',
    cmds = { 'FlyGrep' },
    config = function()
      require('flygrep').setup()
    end,
  },
  {
    'D:/wsdjeg/winbar.nvim',
    events = { 'VimEnter' },
  },
})
```

## Plugin Spec

| name     | description                                                                       |
| -------- | --------------------------------------------------------------------------------- |
| `[1]`    | `string`, plugin repo short name, `wsdjeg/flygrep.nvim`                           |
| `cmds`   | `table<string>`, commands lazy loading                                            |
| `events` | `table<string>`, events lazy loading                                              |
| `on_ft`  | `table<string>`, filetypes lazy loading                                           |
| `type`   | `string`, plugin type including `color`, `plugin`                                 |
| `build`  | `string` or `table<string>`, executed by [job](https://spacevim.org/api/job/) api |

## Commands

- `:PlugInstall`: install specific plugin

## Feedback

The development of this plugin is in [`SpaceVim/bundle/nvim-plug`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/nvim-plug) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues) or [Telegram group](https://t.me/+w27TxYbUz1wxZmJl)
