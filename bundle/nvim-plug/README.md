# nvim-plug

[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
[![GPLv3 License](https://img.spacevim.org/license-GPLv3-blue.svg)](LICENSE)

![nvim-plug](https://wsdjeg.net/images/nvim-plug.gif)

<!-- vim-markdown-toc GFM -->

- [Intro](#intro)
- [Features](#features)
- [Usage](#usage)
- [Plugin Spec](#plugin-spec)
- [Commands](#commands)
- [Default UI](#default-ui)
- [Custom Plugin UI](#custom-plugin-ui)
- [Feedback](#feedback)

<!-- vim-markdown-toc -->

## Intro

nvim-plug is an asynchronous Neovim plugin manager written in Lua. There is also a [Chinese introduction](https://wsdjeg.net/neovim-plugin-manager-nvim-plug/) about nvim-plug.

## Features

- **faster:** written in lua.
- **async:** downloading and building via job.
- **lazy loading:** lazy load plugin based on events, comamnd, mapping, etc..
- **custom UI:** provide custom UI API.

## Usage

setup nvim-plug:

```lua
require('plug').setup({
  -- set the bundle dir
  bundle_dir = 'D:/bundle_dir',
  -- set the path where raw plugin is download to
  raw_plugin_dir = 'D:/bundle_dir/raw_plugin',
  -- max number of processes used for nvim-plug job
  max_processes = 5,
  base_url = 'https://github.com',
  -- default ui is `notify`, use `default` for split window UI
  ui = 'notify',
  -- default is nil
  http_proxy = 'http://127.0.0.1:7890',
  -- default is nil
  https_proxy = 'http://127.0.0.1:7890',
  -- default history depth for `git clone`
  clone_depth = 1,
})
```

add plugins:

```lua
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
    type = 'raw',
    url = 'https://gist.githubusercontent.com/wsdjeg/4ac99019c5ca156d35704550648ba321/raw/4e8c202c74e98b5d56616c784bfbf9b873dc8868/markdown.vim',
    script_type = 'after/syntax'
  },
  {
    'D:/wsdjeg/winbar.nvim',
    events = { 'VimEnter' },
  },
  {
    'wsdjeg/vim-mail',
    on_func = 'mail#',
  },
})
```

## Plugin Spec

The plugin spec is inspired by [dein.nvim](https://github.com/Shougo/dein.vim).

| name            | description                                                                                                   |
| --------------- | ------------------------------------------------------------------------------------------------------------- |
| `[1]`           | `string`, plugin repo short name, `wsdjeg/flygrep.nvim`                                                       |
| `cmds`          | `table<string>`, commands lazy loading                                                                        |
| `events`        | `table<string>`, events lazy loading                                                                          |
| `config`        | `function`, function called after adding plugin path to nvim rtp, before loading files in `plugin/` directory |
| `config_after`  | `function`, function called after loading files in `plugin/` directory                                        |
| `config_before` | `function`, function called when `plug.add()` function is called                                              |
| `on_ft`         | `table<string>`, filetypes lazy loading                                                                       |
| `on_map`        | `table<string>`, key bindings lazy loading                                                                    |
| `on_func`       | `string` or `table<string>`, vim function lazy loading                                                        |
| `script_type`   | `string`, plugin type including `color`, `plugin`, etc..                                                      |
| `build`         | `string` or `table<string>`, executed by [job](https://spacevim.org/api/job/) api                             |
| `enabled`       | `boolean` or `function` evaluated when startup, when it is false, plugin will be skiped                       |
| `frozen`        | update only when specific with `PlugUpdate name`                                                              |
| `depends`       | `table<PluginSpec>` a list of plugins                                                                         |
| `branch`        | `string` specific git branch                                                                                  |
| `tag`           | `string` specific git tag                                                                                     |
| `type`          | `string` specific plugin type, this can be git, raw or none, if it is raw, `script_type` must be set          |
| `autoload`      | `boolean`, load plugin after git clone                                                                        |

`config` and `config_after` function will be not be called if the plugin has not been installed.

## Commands

- `:PlugInstall`: install specific plugin or all plugins
- `:PlugUpdate`: update specific plugin or all plugins

## Default UI

The default is ui is inspired by [vundle](https://github.com/VundleVim/Vundle.vim)

The default highlight group.

| highlight group name | description                     |
| -------------------- | ------------------------------- |
| `PlugTitle`          | the first line of plugin window |
| `PlugProcess`        | the process of downloading      |
| `PlugDone`           | clone/build/install done        |
| `PlugFailed`         | clone/build/install failed      |
| `PlugDoing`          | job is running                  |

Default highlight link:

```lua
vim.cmd('hi def link PlugTitle TODO')
vim.cmd('hi def link PlugProcess Repeat')
vim.cmd('hi def link PlugDone Type')
vim.cmd('hi def link PlugFailed WarningMsg')
vim.cmd('hi def link PlugDoing Number')
```

## Custom Plugin UI

To setup custom UI, you need to creat a on_update function, this function is called with two arges, `name` and `plugUiData`.

The plugUiData is table with following keys:

| key             | description                                          |
| --------------- | ---------------------------------------------------- |
| `clone_done`    | boolead, is true when clone successfully             |
| `command`       | string, clone, pull or build                         |
| `clone_process` | string, git clone progress, such as `16% (160/1000)` |
| `clone_done`    | boolean, git clone exit status                       |
| `building`      | boolean                                              |
| `build_done`    | boolean                                              |
| `pull_done`     | boolean                                              |
| `pull_process`  | string                                               |

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
