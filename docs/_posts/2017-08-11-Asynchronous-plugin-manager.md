---
title: "Asynchronous plugin manager"
categories: feature
excerpt: ""
image: https://user-images.githubusercontent.com/13142418/31309093-36c01150-abb3-11e7-836c-3ad406bdd71a.gif
---


# Asynchronous plugin manager

SpaceVim use dein as default plugin manager, and implement a UI for dein. 

![dein ui](https://user-images.githubusercontent.com/13142418/31309093-36c01150-abb3-11e7-836c-3ad406bdd71a.gif)

when plugin is failed to update, the error message will be shown after the plugin name, you can move cursor to the line of that plugin, then press `gf` to open a terminal with path of that plugin.
