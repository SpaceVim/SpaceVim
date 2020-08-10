---
title: "Use Vim as a Swift IDE"
categories: [tutorials, blog]
image: https://user-images.githubusercontent.com/13142418/57321608-4a484880-7134-11e9-8e43-5fa05085d7e5.png
description: "A general guide for using SpaceVim as Swift IDE, including layer configuration, requiems installation and usage."
type: article
comments: true
commentsID: "Use Vim as a Swift IDE"
---

# [Blogs](../blog/) >> Use Vim as a Swift IDE

This is a general guide for using SpaceVim as a Swift IDE, including layer configuration and usage. 
Each of the following sections will be covered:

<!-- vim-markdown-toc GFM -->

- [Enable language layer](#enable-language-layer)

<!-- vim-markdown-toc -->

### Enable language layer

To add swift language support in SpaceVim, you need to enable the `lang#swift` layer. Press `SPC f v d` to open
SpaceVim configuration file, and add following configuration:

```toml
[[layers]]
  name = "lang#swift"
```

for more info, you can read the [lang#swift](../layers/lang/swift/) layer documentation.

