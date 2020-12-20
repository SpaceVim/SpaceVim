---
title: "An async code runner in SpaceVim"
categories: blog
description: "A better way for running code with in vim, more info about the command status, will not move cursor from code buffer."
commentsID: "Async code runner"
comments: true
---

# [Blogs](https://spacevim.org/community#blogs) > An async code runner in SpaceVim

when edit code, sometimes I want run current file. as we know vim's build-in feature `:!`, but it is not running asynchronously.

here is an gif shown how we can run code within SpaceVim. the first line is showing the command, the last line is showing the exit code and the time that has been consumed. the default key binding is `SPC l r`, `SPC` means `<Space>` on your keyboard.

![async code runner](https://user-images.githubusercontent.com/13142418/80607131-b9b2f880-8a67-11ea-84ad-047ed8dd18b1.gif)

as wrote in old blog, we can also use this feature for java, c, php, JavaScript, etc.
