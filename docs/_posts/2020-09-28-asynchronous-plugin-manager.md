---
title: "Vim 异步插件管理器"
categories: [blog_cn, feature_cn]
description: "使用 dein 作为默认插件管理器，提供一个可视化的插件管理界面。"
permalink: /cn/:title/
lang: zh
type: article
comments: true
image: https://user-images.githubusercontent.com/13142418/80597767-e1e82a80-8a5a-11ea-85ad-031a6f3240f0.gif
commentsID: "VIM 异步插件管理器"
---

# [Blogs](../blog/) >> VIM 异步插件管理器

{{ page.date | date_to_string }}

SpaceVim 使用 `dein` 作为默认的插件管理器，并且提供一个可视化的插件管理界面。

![dein ui](https://user-images.githubusercontent.com/13142418/80597767-e1e82a80-8a5a-11ea-85ad-031a6f3240f0.gif)

在更新插件的过程中，如果提示插件跟新失败，错误消息会在插件名称后方展示。
同时，可以在插件上按下快捷键 `g r`，进行更新，或者使用快捷键 `g f`
打开一个终端，并且定位到插件所在的目录。
