---
title: "SpaceVim tools#mpv 模块"
description: "这一模块为 SpaceVim 提供了mpv支持，可快速查找光标位置的单词。"
lang: zh
---

# [可用模块](../) >> tools#mpv

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

该模块为 SpaceVim 提供了 mpv 集成。

## 启用模块

tools#mpv 模块默认并未启用，如果需要启用该模块，需要在配置文件里面加入：

```toml
[[layers]]
  name = "tools#mpv"
```

## 模块选项

- `musics_directory`: 设置音乐存放文件夹
- `mpv_interpreter`: mpv 可执行命令路径
- `loop_mode`: 循环模式，默认是 `random`

example:

```toml
[[layers]]
    name = 'tools#mpv'
    mpv_interpreter = 'D:\Program Files\mpv\mpv.exe'
    musics_directory = 'F:\other\musics'
```


## 快捷键

| 快捷键      | 功能描述         |
| ----------- | ---------------- |
| `SPC m m l` | 模糊搜索音乐列表 |
| `SPC m m n` | 下一首           |
| `SPC m m s` | 停止播放         |
