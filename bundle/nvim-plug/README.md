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
  ui = 'notify', -- default ui is notify, use `default` for split window UI
})

require('plug').add({
  {
    'wsdjeg/scrollbar.vim',
    events = { 'VimEnter' },
    config = function() end,
  },
  {
    'wsdjeg/vim-chat',
    enabled = function()
      return vim.fn.has('nvim-0.10.0') == 1
    end,
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

| name      | description                                                                             |
| --------- | --------------------------------------------------------------------------------------- |
| `[1]`     | `string`, plugin repo short name, `wsdjeg/flygrep.nvim`                                 |
| `cmds`    | `table<string>`, commands lazy loading                                                  |
| `events`  | `table<string>`, events lazy loading                                                    |
| `on_ft`   | `table<string>`, filetypes lazy loading                                                 |
| `on_map`  | `table<string>`, key bindings lazy loading                                              |
| `type`    | `string`, plugin type including `color`, `plugin`                                       |
| `build`   | `string` or `table<string>`, executed by [job](https://spacevim.org/api/job/) api       |
| `enabled` | `boolean` or `function` evaluated when startup, when it is false, plugin will be skiped |

## Commands

- `:PlugInstall`: install specific plugin

## Default UI

The default is ui is inspired by [vundle](https://github.com/VundleVim/Vundle.vim)

The default highlight group.

| highlight group name | description                     |
| -------------------- | ------------------------------- |
| `PlugTitle`          | the first line of plugin window |
| `PlugProcess`        | the process of downloading      |

## Custom Plugin UI

To setup custom UI, you need to creat a on_update function, this function is called with two arges:

- name: `string`
- date: `PlugUiData`

| key          | description                              |
| ------------ | ---------------------------------------- |
| `clone_done` | boolead, is true when clone successfully |

```lua
--- your custom UI

local function on_ui_update(name, data)
  -- logic
end


require('plug').setup({
  bundle_dir = 'D:/bundle_dir',
  max_processes = 5, -- max number of processes used for nvim-plug job
  base_url = 'https://github.com',
  ui = on_ui_update, -- default ui is notify, use `default` for split window UI
})
```

## Feedback

The development of this plugin is in [`SpaceVim/bundle/nvim-plug`](https://github.com/SpaceVim/SpaceVim/tree/master/bundle/nvim-plug) directory.

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/SpaceVim/SpaceVim/issues) or [Telegram group](https://t.me/+w27TxYbUz1wxZmJl)
