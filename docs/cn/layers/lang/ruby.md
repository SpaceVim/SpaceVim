---
title: "SpaceVim lang#ruby 模块"
description: "这一模块为 Ruby 开发提供支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#ruby

<!-- vim-markdown-toc GFM -->

- [模块描述](#模块描述)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [设置 RubyGems 镜像](#设置-rubygems-镜像)
  - [依赖安装](#依赖安装)
  - [启用模块](#启用模块)
- [模块选项](#模块选项)
- [快捷键](#快捷键)
  - [交互式编程](#交互式编程)
  - [运行当前脚本](#运行当前脚本)

<!-- vim-markdown-toc -->

## 模块描述

这一模块为 SpaceVim 提供了 Ruby 开发支持，包括代码补全、语法检查以及代码格式化等特性。

## 依赖安装及启用模块

### 设置 RubyGems 镜像

因为在国内访问[RubyGems](http://rubygems.org/) 非常慢，推荐使用 [ruby-china 的镜像](https://gems.ruby-china.com)：

```
$ gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
$ gem sources -l
https://gems.ruby-china.com
# 确保只有 gems.ruby-china.com
```

### 依赖安装

为了启用 Ruby 语法检查和代码格式化，需要安装 [cobocop](https://github.com/bbatsov/rubocop)。

```sh
gem install rubocop
```

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#ruby"
```

## 模块选项

- `ruby_file_head`: 设置新建 Ruby 文件时的默认文件头。
  默认情况下，当新建一个 Ruby 文件时，SpaceVim 会自动在文件顶部添加文件头信息。
  如果需要修改默认的文件头模板，可以使用 `ruby_file_head` 选项：

  ```toml
  [[layers]]
    name = "lang#python"
    ruby_file_head = [
        '#!/usr/bin/ruby -w',
        '# -*- coding: utf-8 -*-',
        '',
        ''
    ]
  ```

- `format_on_save`: 启用/禁用保存 Ruby 文件时的自动格式化，默认为 `false`，
  若需要启用该功能，可将值设为 `true`。
  ```toml
  [[layers]]
      name = 'lang#ruby'
      format_on_save = true
  ```

- `enabled_linters`: 设置 Ruby 语言默认的语法检查工具，默认为 `['rubylint']`，
  若需要添加其他的语法检查工具，可以修改值为：
  ```toml
  [[layers]]
    name = 'lang#ruby'
    enabled_linters = ['rubylint', 'rubocop']
  ```
## 快捷键

### 交互式编程

启动 `irb` 交互进程，快捷键为： `SPC l s i`。

将代码传输给 REPL 进程执行：

| 快捷键      | 功能描述                |
| ----------- | ----------------------- |
| `SPC l s b` | 发送整个文件内容至 REPL |
| `SPC l s l` | 发送当前行内容至 REPL   |
| `SPC l s s` | 发送已选中的内容至 REPL |

### 运行当前脚本

在编辑 Ruby 文件时，可通过快捷键 `SPC l r` 快速异步运行当前文件，运行结果会展示在一个独立的执行窗口内。
