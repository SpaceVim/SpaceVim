---
title: "基本约定"
description: "描述贡献代码所需遵循的约定俗成的规范，包括 Vim 脚本的代码规范以及 MarkDown 文件的代码规范。"
lang: zh
---

# 基本约定

<!-- vim-markdown-toc GFM -->

- [Commit emoji 规范](#commit-emoji-规范)
- [Vim 脚本代码规范](#vim-脚本代码规范)
  - [可移植性](#可移植性)
    - [字符串](#字符串)
    - [匹配字符串](#匹配字符串)
    - [正则表达式](#正则表达式)
    - [危险命令](#危险命令)
    - [脆弱命令](#脆弱命令)
    - [捕获异常](#捕获异常)
  - [引导总览](#引导总览)
    - [信息](#信息)
    - [类型检查](#类型检查)
    - [Python](#python)
    - [其它语言](#其它语言)
    - [插件布局](#插件布局)
    - [功能](#功能)
    - [命令](#命令)
    - [自动命令](#自动命令)
    - [映射](#映射)
    - [错误](#错误)
    - [设置](#设置)
  - [风格](#风格)
    - [空白行](#空白行)
    - [连续行](#连续行)
    - [命名](#命名)
- [按键表示](#按键表示)
- [Vimscript 代码规范](#vimscript-代码规范)
- [Markdown 代码规范](#markdown-代码规范)

<!-- vim-markdown-toc -->

## Commit emoji 规范

- `:memo:` 添加一个备注或者文档
- `:gift:` 新的特性
- `:bug:` bug 修复
- `:bomb:` 破坏向后兼容
- `:white_check_mark:` 添加测试
- `:fire:` 移除某些配置
- `:beer:` 代码优化

## Vim 脚本代码规范

### 可移植性

Vim 具有高度可定制性。用户可以更改很多的默认设置，包括区分大小写，正则表达式规则，替换规则，还有很多别的。
为了让你的脚本可以适用于所有用户，请遵循下面的规则：

#### 字符串

**推荐单引号字符串**

双引号字符串在 Vim 和脚本中的语义跟其它语言中不一样，你可能并不需要它们（它们打破了正则表达式）。

当你需要转义时使用双引号（例如 `\\n` ）或者你需要嵌入单引号（例如 `"Abce'a'"` ）。

#### 匹配字符串

**用 `=~#` 或者 `=~?` 操作符家族替换 `=~` 家族**

匹配行为取决于用户的忽略大小写设置（ignorecase）和智能大小写（smartcase）设置以及你是否将它们与 `=~,` `=~#` 或 `=~?` 操作符家族进行比较。
使用 `=~#` 和 `=~?` 操作符家族显式的比较字符串，除非明确的要遵守用户的大小写语义设置。

#### 正则表达式

**所有的正则表达前缀都是 \\m, \\v, \\M, 或 \\V 其中之一**

在传统的大小写语义设置下，正则表达式的行为取决于用户的无魔法(nomagic)设置。
为了让正则表达式的行为像无魔法(nomagic)和不忽略大小写(noignorecase)设置下一样，在所有正则表达式前都必须有前缀，前缀是`\\m`,`\\v`,`\\M`, 或`\\V`其中之一。

欢迎你使用其它等级的魔法(magic levels)`\\v` 和大小写敏感性`\\c`，只要确定了它们是你有意为之并且是明确的。

#### 危险命令

**避免命令意想不到的副作用**

避免使用 `:s[ubstitute]` 因为它会移动光标并打印错误消息。函数（例如 `search()` ）更适用于脚本。

这意味着 `g` 标志取决于上层中 gdefault 的设置。如果你用了 `:substitute` 你必须要保存 gdefault,
把它设置为 0 或 1，预先生成替换并且在操作完成后还原它。

有很多内置的函数可以代替 Vim 命令在影响更小的情况下完成同样的事情。
查看 `:help functions` 查看内置的函数表。

#### 脆弱命令

**避免依赖于用户设置的命令**

总是使用`normal!`在替代`normal`。后者取决于用户的按键映射，可以做任何事情。

避免`:s[ubstitute]`，因为它的行为取决于上层的一些运行设置。

其它同样的命令的应用，在此不再列出。

#### 捕获异常

**匹配错误代码，而非错误文本**

错误文本可能与语言环境(local dependant)有关。

### 引导总览

#### 信息

**罕见的用户信息**

提示信息多的脚本很容易让人厌烦。信息只在以下情况中出现：

- 一个需要较长时间运行的进程开始时。
- 发生了某个错误。

#### 类型检查

**尽可能严格和明确的进行检查**

Vim 脚本在处理一些类型(style)时有不安全，不直观的行为。举个例子：`0 == 'foo'` 认证为真(evalutaes to true)。

尽可能的用严格的比较操作。当二次比较字母的时候用`is#`操作符。除此之外，更适合用 maktaba#value#IsEqual 或明确使用 check htype()。

在使用变量前，明确检查变量的类型。使用 maktaba#ensure 中的函数(functions from maktaba#ensure) 或 check maktaba#value 或 type() 找出你自己的错误。

对变量使用`:unlet`可能更改变量的类型，尤其是在循环中赋值的时候。

#### Python

**保守使用**

只在它提供关键功能时使用，例如在编写线程代码(threaded code)时。

#### 其它语言

**用 Vim 脚本替代**

避免使用其它的脚本语言，例如 Ruby 和 Lua。 我们不能保证，用户的 Vim 已经完成了对 non-vimscript languages 的支持。

#### 插件布局

**将功能组织到模块化插件中**

把你的功能组织成为一个插件，统一放在一个文件夹中(或者是代码仓库)分享你的插件名(用一个 "vim-" 前缀或者需要的话使用 ".vim" 后缀)。
它应该可以被拆分到 plugin/, autoload/, 等等。子目录应该以 addon-info.json 格式声明元数据(详情参见 Vim 文档)。

#### 功能

**在 autoload/ 目录中，用 [!] 和 [abort]定义**

自动加载允许按需加载函数，这使得启动时间更快，并且强制执行函数命名空间(namespacing)。

脚本本地函数(Script-local functions)是被欢迎的，但是只应存活在`atuoload/`中并且能够被自动运行函数调用。

非库函数(Non-library)插件应该提供命令来代替函数。命令逻辑应该被提取到功能和 `autoload/`。

[!] 允许开发者无需申诉(complaint)便可重新加载它们的功能。

[abort] 强制函数在遇到错误时停止。

#### 命令

**在 plugin/commands.vim 中或 ftplugin/ 目录中，不用[!]定义**

一般命令(general commands)进入 plugin/commands.vim. 文件类型特殊命令(Filetype-specific) 进入 ftplugin/ 。

Excluding [!] prevents your plugin from silently clobbering existing commands. Command conflicts should be resolved by the user.

#### 自动命令

**在 plugin/autocmds.vim 中用参数组(augroups) 替换它们**

把所有的自动命令(autocommands)放进参数组(augroups)。

每个参数组都应当有一个独特的名字。或许你应该给它加上插件名前缀。

在定义一个新的自动命令(autocommands)前，用`autocmd!`清除参数组(augroup)。这可以让你的插件复用(re-entrable)。

#### 映射

**在 plugin/mappings.vim 中用 maktaba#plugin#MapPrefix 获取前缀**

所有的按键映射都应当在`plugin/mappings.vim`中被定义。

练习映射(参看`:help using-<Plugin>`)应当在 plugin/plugs.vim 中被定义。

**一直使用 noremap family 命令**

一般你的插件不应引入映射，但是你如果引入了映射的话，这个映射会取代用户现存的映射并且可以做任何事情。

#### 错误

当你需要捕获异常的时候，你应当匹配错误代码而不是匹配错误文本。

#### 设置

**在本地更改设置**

用`:setlocal`和`&l:`替代`:set`和`&`，除非你有明确的原因不去使用它们。

### 风格

按照谷歌风格的约定。有疑惑时请参照 Python 的风格来修改 VimScript 的风格。

#### 空白行

**类似 Python**

- 缩进使用两个空格
- 不要使用 Tabs
- 在操作符(operators)前后使用空格

不要以参数列表(arguments)的形式来使用命令。

```vim
let s:variable = "concatenated " . "strings"
command -range=% MyCommand
```

- 不要在行尾留下空白字符

你无需用自己的方法去清除它。

准备获取用户输入的命令映射中允许留空白字符，例如 `noremap <leader>gf :grep -f`

- 每行限制 80 个字符的宽度
- 缩进保持 4 个空格
- 不要对齐命令的参数列表

```diff
+command -bang MyCommand call myplugin#foo()
+command MyCommand2 call myplugin#bar()
-command -bang MyCommand  call myplugin#foo()
-command       MyCommand2 call myplugin#bar()
```

#### 连续行

- 尽量在单词语义的边界分割连续行

```diff
+command SomeLongCommand
+    \ call some#function()
-command SomeLongCommand call
-    \ some#function()
```

- 反斜杠后添加一个空格代表续行

如果需要连续使用多行命令，可以使用管道符来代替空格，就像下面这样：

```vim
autocommand BufEnter <buffer>
    \ if !empty(s:var)
    \|  call some#function()
    \|else
    \|  call some#function(s:var)
    \|endif
```

- 应当尽量避免使用多行命令，可以用函数调用来替代它

#### 命名

在 SpaceVim 中，函数、变量以及各自提示的命名应当保持简单易于理解，应遵循以下基本命名规范：

- 像这样的函数名 `FunctionNamesLikeThis`
- 像这样的命令名 `CommandNamesLikeThis`
- 像这样的参数组 `augroup_names_like_this`
- 像这样的变量名 `variable_names_like_this`
- 像这样的提示 `hints-like-this`
- 全局及模块选项 `option_name`
- 不要定义全局函数，而使用自动运行函数来替代全局函数。
- 通用命令优先于一般的前缀
- 自动命令组名像变量一样命名。
- 全局变量的前缀为`g:`
- 本地脚本变量的前缀为`s:`
- 函数的参数前缀为`a:`
- 本地函数的变量前缀为`l:`
- Vim 预定义变量前缀为`v:`
- 本地缓冲区变量的前缀为`b:`
- `g:`,`s:`,和`a:`前缀必须使用
- `b:`当你想要改变本地缓冲区的变量的语义时前缀为`b:`

## 按键表示

- 使用首字母大写的单词和尖括号来表示按键：`<Down>`, `<Up>`。
- 使用大写字母来表示 custom leader：`SPC`, `WIN`, `UNITE`, `DENITE`。
- 使用空格来分隔按键序列：`SPC t w`, `<Leader> f o`.
- 使用`/` 来分隔多个可选的按键序列：`<Tab>` / `<C-n>`.
- 在文档中使用`Ctrl-e`而不是`<C-e>`。

## Vimscript 代码规范

- [Google Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
- [Google Vimscript Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Vim Scripting Style Guide](https://github.com/noahfrederick/vim-scripting-style-guide/blob/master/doc/scripting-style.txt)

## Markdown 代码规范

- [Google's Markdown style guide](https://github.com/google/styleguide/blob/3591b2e540cbcb07423e02d20eee482165776603/docguide/style.md)
