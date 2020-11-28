# Vim Script Guide


<!-- vim-markdown-toc GFM -->

- [Introduction](#introduction)
- [Syntax](#syntax)
  - [Basic syntax](#basic-syntax)
  - [Comments](#comments)
- [Variables](#variables)
  - [Variable Scope](#variable-scope)
- [Data Types](#data-types)
- [Operators](#operators)
- [Loop](#loop)
  - [for loop](#for-loop)
  - [while loop](#while-loop)
- [Functions](#functions)

<!-- vim-markdown-toc -->

## Introduction

Vim script is the built-in language used in Vim/Neovim editors.

## Syntax

### Basic syntax

### Comments

## Variables

Variables are "containers" for storing information. In vim script, a variable starts with the scoop,
followed by the name of this variable.

```
let g:foo = 'hello world'
```

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
