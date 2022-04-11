---
title: "SpaceVim lang#vue 模块"
description: "这一模块为 SpaceVim 提供了 Vue 的的开发支持，包括代码补全、语法检查、代码格式化等特性。"
lang: zh
---

# [可用模块](../../) >> lang#vue

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [依赖安装及启用模块](#依赖安装及启用模块)
  - [启用模块](#启用模块)
  - [语言工具](#语言工具)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供了 Vue 的的开发支持，包括代码补全、语法检查、代码格式化等特性。该模块包含了插件 [vim-vue](https://github.com/posva/vim-vue)。

## 依赖安装及启用模块

### 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#vue"
```

### 语言工具

- **语法检查：**

  `checkers` 模块提供了代码检查功能, 此外需要安装 `eslint` 和 `eslint-plugin-vue` 包：

  ```sh
  npm install -g eslint eslint-plugin-vue
  ```
