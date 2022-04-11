---
title: "Vim 脚本指南"
description: "Vim 脚本入门指南，语法及基本使用。"
lang: zh
---

# [开发者文档](../) >> Vim 脚本指南


## 简介

Vim 脚本是 Vim/Neovim 编辑器内置的脚本语言。可以用于配置 Vim/Neovim 及开发插件。

## 语法

### 基本语法

### 注释

Vim 脚本注释都是以 双引号开头，比如：

```vim
" 这是一个单行注释

let g:foo = 1 " 这是一个行尾注释。
```

## 变量

变量是一个存储数据的容器，在 vim 脚本内，一个变量由作用域前缀和变量名称组成，比如：

```vim
let g:foo = 'hello world'
```

其中，`g:foo` 就是一个变量，`g:` 就是一个作用域标识。`foo` 是这个变量的名称。

### Variable Scope

In vim script, there are 6 kinds of variable scopes:

1. `g:` global variable scope
2. `s:` local to script
3. `l:` local to function, it can be prepended.
4. `w:` local to window
5. `t:` local to tab
6. `b:` local to buffer

## Data Types

## Operators

## Loop

Often when you write vim script, you want the same code block to run over and over again.
Instead of adding several almost equal lines in the script, we can use loops.

In vim script there are two kinds of lools, `for loop` and `while loop`.

### for loop


To execute a block of code a specified number of times, you need to use for loop.
here is an example of for loop in vim script:

```vim
for n in range(10)
    echo n
endfor
```

### while loop

While loops execute a block of code while the specified condition is true.


## Functions

Vim provides many built-in functions, besides the built-in functions,
we can also create our own functions.

```vim
function! TestHello() abort
    echo "hello world"
endfunction
```

use `:call TestHello()` to run a function.

### return statement

Within a function, we can use return statement to return a variable.
if the return statement is prepended. `0` is returned.

```vim
function! Test() abort
    return 'hello'
endfunction

echo Test()

" hello

function! Test() abort
    
endfunction

echo Test()

" 0
```
