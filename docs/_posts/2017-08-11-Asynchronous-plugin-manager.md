---
title: "Asynchronous plugin manager"
categories: [feature, blog]
description: "Use dein as default plugin manager, Provides a UI for dein, Install and update plugin asynchronously, Show process status on the fly"
image: https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif
commentsID: "Asynchronous plugin manager"
comments: true
---


# Asynchronous plugin manager

SpaceVim use dein as default plugin manager, and implement a UI for dein. 

![dein ui](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

when plugin is failed to update, the error message will be shown after the plugin name, you can move cursor to the line of that plugin, then press `gf` to open a terminal with path of that plugin.
