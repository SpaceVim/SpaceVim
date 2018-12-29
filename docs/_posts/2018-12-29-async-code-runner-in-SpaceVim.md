---
title: "SpaceVim 中一键异步运行"
categories: [blog_cn, feature_cn]
excerpt: "异步执行当前文件，并将结果展示在下方窗口"
comments: true
commentsID: "VIM 异步代码执行"
lang: cn
---

# [博客](../cn/blogs/) > An async code runner in SpaceVim

when edit code, sometimes I want run current file. as we know vim's build-in feature `:!`, but it is not running asynchronously.

here is an gif shown how we can run code within SpaceVim. the first line is showing the command, the last line is showing the exit code and the time that has been consumed. the default key binding is `SPC l r`, `SPC` means `<Space>` on your keyboard.

![async code runner](https://user-images.githubusercontent.com/13142418/33722240-141ed716-db2f-11e7-9a4d-c99f05cc1d05.gif)

as wrote in old blog, we can also use this feature for java, c, php, JavaScript, etc.

