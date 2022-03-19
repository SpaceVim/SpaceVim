---
title: "SpaceVim lang#markdown 模块"
description: "这一模块为 Markdown 编辑提供支持，包括格式化、自动生成文章目录、代码块等特性。"
lang: zh
---

# [可用模块](../../) >> lang#markdown

<!-- vim-markdown-toc GFM -->

- [模块简介](#模块简介)
- [启用模块](#启用模块)
- [代码格式化](#代码格式化)
- [模块设置](#模块设置)
- [标签栏](#标签栏)
- [快捷键](#快捷键)

<!-- vim-markdown-toc -->

## 模块简介

这一模块为 SpaceVim 提供 Markdown 编辑支持，包括格式化、实时预览、自动生成 TOC 等特性。

## 启用模块

可通过在配置文件内加入如下配置来启用该模块：

```toml
[[layers]]
  name = "lang#markdown"
```

语法树的支持由插件`lvht/tagbar-markdown`提供，但是该插件依赖 php，如果不希望安装 php，可以直接下载 [mdctags](https://github.com/wsdjeg/mdctags.rs) 命令。

## 代码格式化

SpaceVim 默认使用 remark 来格式化 Markdown 文件，Windows 下建议使用 [Prettier](https://github.com/prettier/prettier) 来格式化 Markdown 文件。

remark 可通过 [npm](https://www.npmjs.com/get-npm) 命令来安装：

```sh
npm -g install remark
npm -g install remark-cli
npm -g install remark-stringify
npm -g install remark-frontmatter
npm -g install wcwidth
```

默认值是 remark 而不是 prettier，如果您想使用 prettier，你需要修改此模块的选项：`enable_formater`。

[Prettier](https://github.com/prettier/prettier) 可通过 [yarn](https://yarnpkg.com/lang/zh-hans/docs/install/#windows-stable) 或 [npm](https://www.npmjs.com/get-npm) 命令来安装：

1. 通过 `yarn` 命令来安装

```sh
yarn global add prettier
```

2. 通过 `npm` 命令来安装

```sh
npm install --global prettier
```

## 模块设置

**listItemIndent**

设置有序列表对齐方式 (`tab`, `mixed` 或者 `1` , 默认： `1`)。

- `'tab'`: 使用 tab stops 对齐
- `'1'`: 使用空格对齐
- `'mixed'`: use `1` for tight and `tab` for loose list items

**enableWcwidth**

启用/禁用表格字符宽度检测，默认未启用该功能。若需要启用该功能，需要额外安装 [wcwidth](https://www.npmjs.com/package/wcwidth)。

**listItemChar**

设置无序列表前缀 (`'-'`, `'*'`, or `'+'`, 默认: `'-'`)。

**enabled_formater**

为 markdown 文件指定启用的格式化工具，默认值是`["remark"]`，您也可以添加其它格式化工具到此列表，例如：`["remark", "prettier"]`。

## 标签栏

为了在标签栏中显示标题（使用<kbd>F2</kbd>切换），请确保 php 在你的环境变量`$PATH`中，在 SpaceVim 中，您可以这样测试：`:!php --version`，如果 php 安装成功，此命令应该会显示一些 php 的信息。

如果不希望安装 php，也可以直接下载 [mdctags](https://github.com/wsdjeg/mdctags.rs) 命令。

## 快捷键

| 快捷键    | 模式          | 按键描述                                |
| --------- | ------------- | --------------------------------------- |
| `SPC b f` | Normal        | 格式化当前文件                          |
| `SPC l c` | Normal/Visual | 在光标处创建目录                        |
| `SPC l C` | Normal/Visual | 删除目录                                |
| `SPC l k` | Normal/Visual | 为光标下的单词或者选中文本增加 URL 链接 |
| `SPC l K` | Normal/Visual | 为光标下的单词或者选中文本增加图片链接  |
| `SPC l r` | Normal/Visual | 运行区块中的代码                        |
| `SPC l u` | Normal/Visual | 更新目录                                |
| `SPC l p` | Normal        | 通过浏览器实时预览当前文件              |
