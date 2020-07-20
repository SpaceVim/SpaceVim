---
title: SpaceVim release v0.3.0
categories: [changelog, blog]
description: "The major change happend in v0.3.0 is new mapping guide and custom mapping prefix SPC."
type: article
commentsID: "SpaceVim release v0.3.0"
comments: true
---

# [Changelogs](../development#changelog) > SpaceVim release v0.3.0

## FEATURES

- **Mappings guide:** A guide buffer is displayed each time the prefix key is pressed in normal mode. It lists the available key bindings and their short description.

for example, after pressing `<Space>` in normal mode, you will see :

![mapping guide](https://cloud.githubusercontent.com/assets/13142418/25778673/ae8c3168-3337-11e7-8536-ee78d59e5a9c.png)

for more information about mapping guide, please read the [documentation](http://spacevim.org/documentation/#mappings-guide).

- **Statusline:** A modulue statusline will displayed all the status of SpaceVim. all the sections in the statusline can be toggled.

here is an picture for this feature:

![search status](https://cloud.githubusercontent.com/assets/13142418/26313080/578cc68c-3f3c-11e7-9259-a27419d49572.png)

please checkout statusline [documentation](http://spacevim.org/documentation/#statusline) for all the shortcuts.

## CHANGES

SpaceVim now use Space as [SPC] only in normal mode. and do not change the default value of mapleader.

## FIXES

please checkout our issue list.
