---
title: "SpaceVim autocomplete 模块"
description: "这一模块为 SpaceVim 提供了自动补全的框架，包括语法补全等多种补全来源，同时提供了代码块自动完成等特性。"
lang: zh
---

# [可用模块](../) >> autocomplete

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)
  - [快捷键设置](#快捷键设置)
  - [代码块的设置](#代码块的设置)
  - [自动补全括号](#自动补全括号)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了代码自动补全的框架，同时提供了代码块自动完成的特性。默认情况
下根据当前 Vim 所具备的特性，自动选择补全引擎：

- [deoplete](https://github.com/Shougo/deoplete.nvim) - neovim/Vim 具备 `+python3` 特性，并且安装了 neovim 的 python-client
- [neocomplete](https://github.com/Shougo/neocomplete.vim) - 需要 Vim 具备 `+lua` 特性
- [neocomplcache](https://github.com/Shougo/neocomplcache.vim) - 当都不具备以上特性时
- [YouCompleteMe](https://github.com/Valloric/YouCompleteMe) - 默认 Ycm 是不会自动启用的，可通过 SpaceVim 选项 `enable_ycm` 来启用

代码块自动完成框架默认为[neosnippet](https://github.com/Shougo/neosnippet.vim)，可通过
SpaceVim 选项 `snippet_engien` 设置为 ultisnips

## 启用模块

这一模块是默认启用的，当然为了稳妥，可以再配置文件里加入以下代码块：

```toml
[[layers]]
  name = "autocomplete"
```

## 模块配置

自动补全模块的配置，主要包括两个部分，自动补全快捷键的设置、代码块模板以及
使用体验的优化

### 快捷键设置

为了提升用户体验，可以通过使用如下的模块选项来定制自动补全：

1. `auto_completion_return_key_behavior` 选项控制当按下 `Return`/`Enter` 键时的行为，
   默认为 `complete`，可用的值包括如下 3 种：
   - `complete` 补全模式，插入当前选中的列表选项
   - `smart` 智能模式，插入当前选中的列表选项，若当前选择的时 snippet，则自动展开代码块。
   - `nil` 当设为 nil 时，则采用 Vim 默认的按键行为，插入新行
2. `auto_completion_tab_key_behavior` 选项控制当按下 `Tab` 键时的行为，默认为
   `complete`，可用的值包括如下 4 种：
   - `smart` 智能模式，自动循环补全列表、展开代码块以及跳至下一个代码块的锚点
   - `complete` 补全模式，插入当前选中的列表选项
   - `cycle` 循环模式，自动再补全列表之间循环
   - `nil` 当设为 nil 时，该行为和 `Tab` 的默认行为一致
3. `auto_completion_delay` 设置自动补全延迟时间，默认 50 毫秒
4. `auto_completion_complete_with_key_sequence` 设置一个手动补全的由两个字符构成的按键序列，如果你按下这个序列足够快，将会启动补全；如果这一选项的值是 `nil` ，这一特性将被禁用。
5. `auto_completion_complete_with_key_sequence_delay` 设置手动补全按键序列延迟时间，默认是 0.1

自动补全模块默认载入状态如下：

```toml
[[layers]]
  name = "autocomplete"
  auto_completion_return_key_behavior = "nil"
  auto_completion_tab_key_behavior = "smart"
  auto_completion_delay = 200
  auto_completion_complete_with_key_sequence = "nil"
  auto_completion_complete_with_key_sequence_delay = 0.1
```

通常会建议将 `auto_completion_complete_with_key_sequence` 的值设为 `jk`，如果你不用
这一组按键的话。

### 代码块的设置

默认情况下，会自动载入以下代码块仓库和文件夹的代码块模板：

- [Shougo/neosnippet-snippets](https://github.com/Shougo/neosnippet-snippets)：neosnippet 的默认代码块模板
- [honza/vim-snippets](https://github.com/honza/vim-snippets)：额外的代码块模板
- `~/.SpaceVim/snippets/`：SpaceVim 内置代码块模板
- `~/.SpaceVim.d/snippets/`：用户全局代码块模板
- `./.SpaceVim.d/snippets/`：当前项目本地代码块模板

同时，可以通过修改 bootstrap 方法来设置 `g` 的值，进而设置自定义的代码块模板路径，该值
可以是一个 string，表示单个目录，也可以是一个 list，每一个元素表示一个路径。

默认情况下，代码块模板缩写词会在补全列表里面显示，以提示当前输入的内容为一个代码块模板的缩写，
如果需要禁用这一特性，可以设置 `auto_completion_enable_snippets_in_popup` 为 false。

```toml
[[layers]]
  name = "autocomplete"
  auto_completion_enable_snippets_in_popup = false
```

### 自动补全括号

默认情况下，会自动补全成对的括号，如果需要禁用该功能，可以添加如下配置：

```toml
[options]
    autocomplete_parens = false
```

## 快捷键

**自动补全相关快捷键**

| 快捷键        | 功能描述                                   |
| ------------- | ------------------------------------------ |
| `Ctrl-n`      | 选择下一个列表选项                         |
| `Ctrl-p`      | 选择上一个列表选项                         |
| `<Tab>`       | 依据 `auto_completion_tab_key_behavior`    |
| `Shift-<Tab>` | 选择上一个列表选项                         |
| `<Return>`    | 依据 `auto_completion_return_key_behavior` |

**代码块模板相关快捷键**

| 快捷键    | 功能描述                                           |
| --------- | -------------------------------------------------- |
| `M-/`     | 如果光标前的词语为一代码块模板缩写，则展开该代码块 |
| `SPC i s` | 列出所有可用的代码块模板，选择后并插入             |
