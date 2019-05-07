---
title: "SpaceVim lang#markdown layer"
description: "Edit markdown within vim, autopreview markdown in the default browser, with this layer you can also format markdown file."
---

# [Available Layers](../../) >> lang#markdown

<!-- vim-markdown-toc GFM -->

- [Description](#description)
- [Install](#install)
- [Formatting](#formatting)
  - [options](#options)
- [Key bindings](#key-bindings)

<!-- vim-markdown-toc -->

## Description

This layer is for editing markdown file.

## Install

To use this configuration layer, update custom configuration file with:

```toml
[[layers]]
  name = "lang#markdown"
```

## Formatting

SpaceVim uses remark to format Markdown file by default, but we suggest using [Prettier](https://github.com/prettier/prettier) on Windows.

You can install remark via [npm](https://www.npmjs.com/get-npm), the commands are shown as below.

```sh
npm -g install remark
npm -g install remark-cli
npm -g install remark-stringify
npm -g install remark-frontmatter
npm -g install wcwidth
```

You can install [Prettier](https://github.com/prettier/prettier) via [yarn](https://yarnpkg.com/lang/zh-hans/docs/install/#windows-stable) or [npm](https://www.npmjs.com/get-npm), the commands are shown as below:

1. Via `yarn`

```sh
yarn global add prettier
```

2. Via `npm`

```sh
npm install --global prettier
```

### options

**listItemIndent**

How to indent the content from list items (`tab`, `mixed` or 1 , default: 1).

- `'tab'`: use tab stops (4 spaces)
- `'1'`: use one space
- `'mixed'`: use `1` for tight and `tab` for loose list items

**enableWcwidth**

Enable/Disable wcwidth for detecting the length of a table cell, default is 0. To enable this option, you need to install [wcwidth](https://www.npmjs.com/package/wcwidth)

**listItemChar**

Bullet marker to use for list items (`'-'`, `'*'`, or `'+'`, default: `'-'`).

## Key bindings

| Key bindings | mode          | Descriptions                                           |
| ------------ | ------------- | ------------------------------------------------------ |
| `SPC b f`    | Normal        | Format current buffer                                  |
| `SPC l k`    | Normal/Visual | Add URL link for word under cursor or slected word     |
| `SPC l k`    | Normal/Visual | Add picture link for word under cursor or slected word |
| `SPC l p`    | Normal        | Real-time markdown preview                             |
