---
title: "SpaceVim colorscheme 模块"
description: "这一模块为 SpaceVim 提供了一系列的常用颜色主题，默认情况下使用深色 gruvbox 作为默认主题。该模块提供了快速切换主题、随机主题等特性。"
lang: zh
---

# [可用模块](../) >> colorscheme

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块配置](#模块配置)

<!-- vim-markdown-toc -->

## 模块描述

colorscheme 模块为 SpaceVim 提供了一系列常用的颜色主题，默认情况为深色的 gruvbox 主题。

## 启用模块

默认情况下，这一模块并未启用，如果需要使用更多的颜色主题，可以启用该模块，在配置
文件内加入如下内容：

```toml
[[layers]]
  name = "colorscheme"
```

## 模块配置

如果需要修改默认主题，可在配置文件中修改 colorscheme 选项，改为主题名称即可。

```toml
[options]
  colorscheme = "onedark"
```

**主题列表**

| 名称         | 深色主题 | 浅色主题 | 终端支持 | Gui 支持 | 状态栏支持 |
| ------------ | -------- | -------- | -------- | -------- | ---------- |
| molokai      | yes      | no       | yes      | yes      | yes        |
| srcery       | yes      | no       | yes      | yes      | yes        |
| onedark      | yes      | no       | yes      | yes      | yes        |
| jellybeans   | yes      | no       | yes      | yes      | yes        |
| palenight    | yes      | no       | yes      | yes      | yes        |
| one          | yes      | yes      | yes      | yes      | yes        |
| nord         | yes      | no       | yes      | yes      | yes        |
| gruvbox      | yes      | yes      | yes      | yes      | yes        |
| NeoSolarized | yes      | yes      | yes      | yes      | yes        |
| hybrid       | yes      | yes      | yes      | yes      | yes        |
| material     | yes      | yes      | yes      | yes      | yes        |
| SpaceVim     | yes      | yes      | yes      | yes      | yes        |

默认情况下，SpaceVim 的 colorscheme 模块仅包含以上主题，如果需要使用 Github 上其它主题，
可以在配置文件中使用 `custom_plugins` 来添加主题，例如：

```toml
[options]
  colorscheme = "OceanicNext"
  colorscheme_bg = "dark"

# 添加自定义主题：https://github.com/mhartington/oceanic-next
[[custom_plugins]]
  name = "mhartington/oceanic-next"
  merged = 0
```

部分主题提供了深色和浅色两系列的主题，可以通过设置主题背景色来切换这两种主题。
SpaceVim 支持在配置文件中通过 `colorscheme_bg` 这一选项来设置。

比如，设置默认主题为 onedark，并且使用其深色系列主题：

```toml
[options]
  colorscheme = "onedark"
  colorscheme_bg = "dark"
```

这一模块提供了，在启动时随机选择主题，而不是使用默认的主题。这一特性可以很
大限度地消除视觉疲劳：

```toml
[[layers]]
  name = "colorscheme"
  random_theme = true
```

除了在每次启用时自动应用随机主题以外，也可以设置它的更新频率，默认是为空，
表示每次启用 Vim 是随机选择一种主题。可供选择的频率有：`daily`、`hourly`、`weekly`,
以及 `数字 + 单位` 这种格式，如 `1h`。

```toml
[[layers]]
  name = "colorscheme"
  random_theme = true
  frequency = "daily"
```
