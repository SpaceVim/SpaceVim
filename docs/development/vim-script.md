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
