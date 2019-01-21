---
title: "使用 Vim 搭建 Java 开发环境"
categories: [tutorials_cn, blog_cn]
excerpt: "如何使用 Vim 搭建 Java 的开发环境，自动补全、语法检查、代码格式化、交互式编程以及断点调试相关使用技巧"
permalink: /cn/:title/
lang: cn
type: BlogPosting
comments: true
commentsID: "使用 Vim 搭建 Java 开发环境"
---

# [Blogs](../blog/) > 使用 Vim 搭建 Java 开发环境

这篇文章主要介绍如何使用 SpaceVim 搭建 Java 开发 Vim 环境，主要涉及到 `lang#java` 模块。

<!-- vim-markdown-toc GFM -->

- [启用模块](#启用模块)
- [代码补全](#代码补全)
- [语法检查](#语法检查)
- [导包](#导包)
- [跳转测试文件](#跳转测试文件)
- [编译运行](#编译运行)
- [代码格式化](#代码格式化)
- [交互式编程](#交互式编程)

<!-- vim-markdown-toc -->

### 启用模块

SpaceVim 初次安装时默认并未启用相关语言模块。首先需要启用
`lang#java` 模块, 通过快捷键 `SPC f v d` 打开配置文件，添加：

```toml
[[layers]]
  name = "lang#java"
```

启用 `lang#java` 模块后，在打开 java 文件时，就可以使用语言专属快捷键，这些快捷键都是以 `SPC l` 为前缀的。

`lang#java` 模块主要采用插件 vim-javacomplete2，该插件可以自动读取工程配置文件，获取当前项目的 classpath，
目前支持的项目包括 maven、gradle 以及 eclipse 下的配置文件。

### 代码补全

vim-javacomplete2 为 java 项目提供了很好的代码补全功能，配合 autocomplete 模块，可以在编辑代码时实时补全代码，并且可以模糊匹配。

![code complete](https://user-images.githubusercontent.com/13142418/46297202-ba0ab980-c5ce-11e8-81a0-4a4a85bc98a5.png)

### 语法检查

`checkers` 模块为 SpaceVim 提供了异步语法检查功能，该模块主要包括插件 [neomake](https://github.com/neomake/neomake)。
目前支持的项目包括 maven、gradle 以及 eclipse 下的配置文件。

![lint-java](https://user-images.githubusercontent.com/13142418/46323584-99b81a80-c621-11e8-8ca5-d8eb7fbd93cf.png)

从上图，我们可以看到，目前语法检查支持如下功能：

- 在底部分割窗口列出所有语法问题
- 在侧边使用标记符号标记错误信息
- 在状态了显示错误及警告数量
- 当光标所在位置存在错误，在光标的下一行展示错误细节，移动光标后，这个错误描述就会被清除，并不会影响代码内容

### 导包

在编辑 java 文件时，导包的操作主要有两种，一种是自动导包，一种是手动导包。自动导包主要是在选中某个补全的类后，自动导入该类。
手动导包的快捷键是 `<F4>`，可将光标移动到类名上，按下 F4 手动导入该包。会出现这样一种情况，classpath 内有多个可选择的类，
此时会在屏幕下方弹出提示，选择相对应的类名即可。

![import class](https://user-images.githubusercontent.com/13142418/46298485-c04e6500-c5d1-11e8-96f3-01d84f9fe237.png)

### 跳转测试文件

在编辑 java 源文件时，可以通过命令 `:A` 跳转到与之对应的测试文件，这一功能主要依赖 tpope 的 vim-project，以 maven 项目为例，
需要在项目根目录添加配置文件 `.projections.json`，内容如下：

```json
{
  "src/main/java/*.java": {"alternate": "src/test/java/{dirname}/Test{basename}.java"},
  "src/test/java/**/Test*.java": {"alternate": "src/main/java/{}.java"}
}
```

基于这样的配置，就可以实现源文件和测试文件相互跳转了。

![jump-test](https://user-images.githubusercontent.com/13142418/46322905-12b57300-c61e-11e8-81a2-53c69d10140f.gif)

### 编译运行

主要基于 JavaUnite，可以编译并运行当前类，也可以执行某个指定的函数。`SPC l r c` 执行光标函数， `SPC l r m` 执行 main 函数。

![run-main](https://user-images.githubusercontent.com/13142418/46323137-61174180-c61f-11e8-94df-61b6998b8907.gif)


### 代码格式化

基于 `format` 模块，可以使用 `SPC b f` 对当前代码进行格式化，`format` 模块主要包括插件 [neoformat](https://github.com/sbdchd/neoformat)。
该插件提供了格式化框架，对于 java 的支持，还需要安装 [uncrustify](http://astyle.sourceforge.net/) 或者 [astyle](http://astyle.sourceforge.net/)。
同时，你也可以使用谷歌的 [java formatter](https://github.com/google/google-java-format)。

![format-java](https://user-images.githubusercontent.com/13142418/46323426-ccadde80-c620-11e8-9726-d99025f3bf76.gif)

### 交互式编程

jdk9 引入了 `jshell`，让 java 的交互式编程成为了可能，在 SpaceVim 里，可以通过快捷键 `SPC l s i` 其同该功能。REPL 窗口打开后，
可以通过 `SPC l s l` 和 `SPC l s s` 等快捷键发送代码给 jshell，目前支持发送当前行、选中内容及整个文件内容。

![repl-java](https://user-images.githubusercontent.com/13142418/46323880-0b449880-c623-11e8-811a-919738c9ec5f.gif)


