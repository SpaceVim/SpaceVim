---
title: "自定义工程文件跳转"
categories: [feature_cn, blog_cn]
description: "通过配置文件，自定义工程文件跳转路径，包括跳转至测试源文件、文档源文件等。"
image: https://user-images.githubusercontent.com/13142418/80495522-9d955580-899a-11ea-9e2e-b621b1d821d8.png
permalink: /cn/:title/
lang: zh
type: article
comments: true
commentsID: "自定义工程文件跳转"
---

# [Blogs](../blog/) >> 自定义工程文件跳转

{{ page.date | date_to_string }}


## 起因和目的

起初，在管理 SpaceVim 这一项目时，每编辑一个模块源文件，总是需要关注以下几件事：

1. 相关的文档是否存在，是否需要修改，在工程内存在中英文版本的文档，是否内容保持一致。
2. 测试文件是否存在，是否需要修改。

出于以上两点的考虑，衍生出如下需求：

1. 在编辑源文件时，迅速跳转至文档所在的源文件；
2. 在编辑中文文档时，迅速跳转至英文文档，反之亦然；
3. 在编辑源文件时，迅速跳转至测试文件，反之亦然；

目前，SpaceVim 内置的这一插件基本实现了以上功能，以便于快速在相关文件之间进行跳转。

## 基本的使用

SpaceVim 提供了一个内置的工程文件跳转插件，默认的命令为 `:A`，
该命令可接收参数，指定跳转类别：

![a](https://user-images.githubusercontent.com/13142418/80495522-9d955580-899a-11ea-9e2e-b621b1d821d8.png)

在使用这一特性之前，需要在工程根目录添加配置文件 `.project_alt.json`。例如：

```json
{
  "autoload/SpaceVim/layers/lang/*.vim": {"doc": "docs/layers/lang/{}.md"},
}
```

加入以上配置文件后，当编辑 `autoload/SpaceVim/layers/lang/java.vim` 文件时，
可以通过 `:A doc` 跳转至 `docs/layers/lang/java.md` 文件。











