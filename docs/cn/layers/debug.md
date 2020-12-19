---
title: "SpaceVim debug 模块"
description: "这一模块为 SpaceVim 提供了 Debug 的常用功能，采用 vebugger 作为后台框架，支持多种 Debug 工具。"
lang: zh
---

# [可用模块](../) >> debug

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [启用模块](#启用模块)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了基本的 Debug 框架，高度定制
[vim-vebugger](https://github.com/idanarye/vim-vebugger) 插件，支持多种 Debug
工具。

## 启用模块

SpaceVim 默认未载入该模块，如需载入模块，可以在配置文件中加入：

```toml
[[layers]]
  name = "debug"
```

## 快捷键

| 快捷键      | 功能描述               |
| ----------- | ---------------------- |
| `SPC d l`   | 启动 debugger          |
| `SPC d c`   | 继续下一步             |
| `SPC d b`   | 添加/去除当前行断点    |
| `SPC d B`   | 清除所有断点           |
| `SPC d o`   | 单步执行               |
| `SPC d i`   | 跳至方法体             |
| `SPC d O`   | 运行至当前方法结束     |
| `SPC d e s` | 打印并求值选中的文本   |
| `SPC d e e` | 打印并求值光标所在变量 |
| `SPC d e S` | 执行选中的文本         |
| `SPC d k`   | 关闭 debugger          |

**Debug 临时快捷键菜单**

Debug 的快捷键太长了？可以使用 `SPC d .` 调出 Debug 临时快捷键菜单。

![Debug Transient State](https://user-images.githubusercontent.com/13142418/33996076-b03c05bc-e0a5-11e7-90fd-5f31e2703d7e.png)
