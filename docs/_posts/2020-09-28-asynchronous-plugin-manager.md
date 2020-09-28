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

# [Blogs](../blog/) >> Asynchronous plugin manager

{{ page.date | date_to_string }}


SpaceVim use dein as default plugin manager, and implement a UI for dein. 

![dein ui](https://user-images.githubusercontent.com/13142418/80597767-e1e82a80-8a5a-11ea-85ad-031a6f3240f0.gif)

when plugin is failed to update, the error message will be shown after the plugin name,
you can move cursor to the line of that plugin,
then press `g r` to fix the installation, or press `gf` to open a terminal with path of that plugin.

