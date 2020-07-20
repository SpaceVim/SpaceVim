---
title: "Asynchronous plugin manager"
categories: [feature, blog]
description: "Use dein as default plugin manager, Provides a UI for dein, Install and update plugin asynchronously, Show process status on the fly"
image: https://user-images.githubusercontent.com/13142418/80597767-e1e82a80-8a5a-11ea-85ad-031a6f3240f0.gif
commentsID: "Asynchronous plugin manager"
comments: true
---


# [Blogs](../blog/) >> Asynchronous plugin manager

{{ page.date | date_to_string }}


SpaceVim use dein as default plugin manager, and implement a UI for dein. 

![dein ui](https://user-images.githubusercontent.com/13142418/80597767-e1e82a80-8a5a-11ea-85ad-031a6f3240f0.gif)

when plugin is failed to update, the error message will be shown after the plugin name,
you can move cursor to the line of that plugin,
then press `g r` to fix the installation, or press `gf` to open a terminal with path of that plugin.
