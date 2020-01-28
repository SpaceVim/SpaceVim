---
title: "自定义工程文件跳转"
categories: [feature_cn, blog_cn]
excerpt: "通过配置文件，自定义工程文件跳转路径，包括跳转至测试源文件、文档源文件等。"
image: https://user-images.githubusercontent.com/13142418/73239989-98c4d800-41d8-11ea-8c5b-383076cfcd6c.png
permalink: /cn/:title/
lang: zh
type: BlogPosting
comments: true
commentsID: "自定义工程文件跳转"
---

# [Blogs](../blog/) >> 自定义工程文件跳转

{{ page.date | date_to_string }}


SpaceVim 提供了一个内置的工程文件跳转插件，默认的命令为 `:A`，
该命令可接收参数，指定跳转类别：

![a](https://user-images.githubusercontent.com/13142418/73239989-98c4d800-41d8-11ea-8c5b-383076cfcd6c.png)

在使用这一特性之前，需要在工程根目录添加配置文件 `.project_alt.json`。例如：

```json
{
  "autoload/SpaceVim/layers/lang/*.vim": {"doc": "docs/layers/lang/{}.md"},
}
```

加入以上配置文件后，当编辑 `autoload/SpaceVim/layers/lang/java.vim` 文件时，
可以通过 `:A doc` 跳转至 `docs/layers/lang/java.md` 文件。











