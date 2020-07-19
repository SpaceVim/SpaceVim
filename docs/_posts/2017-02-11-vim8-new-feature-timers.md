---
title: "VIM 8 新特性之旅: 定时器 (timers)"
categories: [blog_cn, feature_cn]
description: "VIM 8 新特性之旅系列教程 - 定时器, 介绍定时器具体使用方法以及场景"
permalink: /cn/:title/
redirect_from: "/vim8-new-feature-timers-zh_cn/"
lang: zh
comments: true
image: https://user-images.githubusercontent.com/13142418/80497170-abe47100-899c-11ea-9975-ef250cfbde6d.png
commentsID: "Vim8 最新特性: timers"
---

# 定时器（ timer ）


<!-- vim-markdown-toc GFM -->

- [什么是定时器？](#什么是定时器)
- [启动定时器](#启动定时器)
  - [获取定时器信息](#获取定时器信息)
  - [暂停定时器](#暂停定时器)
  - [停止定时器](#停止定时器)

<!-- vim-markdown-toc -->

vim 需要支持 +timers 特性

## 什么是定时器？

Vim 的定时器是指在指定时间后重复指定次数执行某个回调函数。 这一功能需要 Vim 支持 `+timers` 特性。

## 启动定时器

`timer_start({毫秒}, {回调函数｝[,{选项}])`

Vim 中这个方法将创建一个计时器，并且返回这个定时器的 ID。 回调函数接受一个参数，可以是字符串，表示方法具体名称，也可以是 `Funcref` 变量。 下面是一个示例：

```vim
func MyHandler(id)
  echo 'This is handler called for timer-' . a:id
endfunc
let timer = timer_start(500, 'MyHandler',
  \ {'repeat': 3})
```

### 获取定时器信息

`timer_info([{ID}])`

这个方法会返回一个存储定时器信息的列表， 当编号为 ID 的定时器不存在，将返回一个空的列表，当直接调用这个方法， 而不传递任何参数时，将返回所有定时器的信息。返回列表中每一个元素实际上是一个字典数据类型，具体的结构如下:

```json
{
  "id" : "该定时器的 ID",
  "time" : "定时器启动是所设置的毫秒数",
  "remaining" : "距定时器启动还剩余的毫秒数",
  "repeat" : "定时器还需要重复执行的次数，无限执行则返回 -1",
  "callback" : "回调函数",
  "paused" : "是否被暂停，是则返回 1，否则返回 0"
}
```
     
### 暂停定时器

`timer_pause({ID} , {是否})`

这个方法接受 2 个参数，第一个参数是 定时器的 ID, 第二个参数是决定是 暂停 还是 取消暂停 的关键，当第二个参数是一个非 0 数值，或非空字符串，则该定时器被暂停，否则即为取消暂停。

### 停止定时器

`timer_stop([{ID}])`

停止一个编号为 ID 的定时器，ID 即为 timer_start() 方法的返回值，因此必须为数值，即便编号为 ID 的定时器不存在，这个方法也不会报错。

另外一个方法 timer_stopall(), 将停止所有定时器。就个人来看 vim 这个方法设计并不完美， 一个软件的方法命名应该存在一定的规则，比如前面的 timer_info() 就是一个可变参数的方法，当无参执行是返回所有定时器的信息，那么这个 timer_staop() 应该也是可以参数方法，无参执行时取消所有定时器。当然了这个仅仅是个人意见。

查阅跟多 Vim 中文教程，请阅读： 
