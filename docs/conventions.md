---
title: "Conventions"
description: "conventions of contributing to SpaceVim, including the coding style guides about vim script and markdown"
---

# Conventions

<!-- vim-markdown-toc GFM -->

- [Commit emoji convention](#commit-emoji-convention)
- [Viml coding style guide](#viml-coding-style-guide)
  - [Portability](#portability)
    - [Strings](#strings)
    - [Matching Strings](#matching-strings)
    - [Regular Expressions](#regular-expressions)
    - [Dangerous commands](#dangerous-commands)
    - [Fragile commands](#fragile-commands)
    - [Catching Exceptions](#catching-exceptions)
  - [General Guidelines](#general-guidelines)
    - [Messaging](#messaging)
    - [Type checking](#type-checking)
    - [Python](#python)
    - [Other Languages](#other-languages)
    - [Plugin layout](#plugin-layout)
    - [Functions](#functions)
    - [Commands](#commands)
    - [Autocommands](#autocommands)
    - [Mappings](#mappings)
    - [Errors](#errors)
    - [Settings](#settings)
  - [Style](#style)
    - [Whitespace](#whitespace)
    - [Line Continuations](#line-continuations)
    - [Naming](#naming)
- [Key notations](#key-notations)
- [Vimscript Style](#vimscript-style)
- [Markdown Style](#markdown-style)

<!-- vim-markdown-toc -->

## Commit emoji convention

- `:memo:` Add comment or doc.
- `:gift:` New feature.
- `:bug:` Bug fix.
- `:bomb:` Breaking compatibility.
- `:white_check_mark:` Write test.
- `:fire:` Remove something.
- `:beer:` I'm happy like reduced code complexity.

## Viml coding style guide

### Portability

Vim is highly configurable. Users can change many of the default settings, including the case sensitivity, the regular expression rules, the substitution rules, and more. In order for your vimscript to work for all users, follow these guidelines:

#### Strings

**Prefer single quoted strings**

Double quoted strings are semantically different in vimscript, and you probably don't want them (they break regexes).

Use double quoted strings when you need an escape sequence (such as "\\n") or if you know it doesn't matter and you need to embed single quotes.

#### Matching Strings

**Use the =~# or =~? operator families over the =~ family.**

The matching behavior depends upon the user's ignorecase and smartcase settings and on whether you compare them with the =~, =~#, or =~? family of operators. Use the =~# and =~? operator families explicitly when comparing strings unless you explicitly need to honor the user's case sensitivity settings.

#### Regular Expressions

**Prefix all regexes with one of \\m, \\v, \\M, or \\V.**

In addition to the case sensitivity settings, regex behavior depends upon the user's nomagic setting. To make regexes act like nomagic and noignorecase are set, prepend all regexes with one of \\m, \\v, \\M, or \\V.

You are welcome to use other magic levels (\\v) and case sensitivities (\\c) so long as they are intentional and explicit.

#### Dangerous commands

**Avoid commands with unintended side effects.**

Avoid using :s[ubstitute] as it moves the cursor and prints error messages. Prefer functions (such as search()) better suited to scripts.

The meaning of the g flag depends upon the gdefault setting. If you do use :substitute you must save gdefault, set it to 0 or 1, perform the substitution, and then restore it.

For many Vim commands, functions exist that do the same thing with fewer side effects. See `:help functions` for a list of built-in functions.

#### Fragile commands

**Avoid commands that rely on user settings.**

Always use normal! instead of normal. The latter depends upon the user's key mappings and could do anything.

Avoid :s[ubstitute], as its behavior depends upon a number of local settings.

The same applies to other commands not listed here.

#### Catching Exceptions

**Match error codes, not error text.**

Error text may be locale dependent.

### General Guidelines

#### Messaging

**Message the user infrequently.**

Loud scripts are annoying. Message the user only when:

- A long-running process has kicked off.
- An error has occurred.

#### Type checking

**Use strict and explicit checks where possible.**

Vimscript has unsafe, unintuitive behavior when dealing with some types. For instance, 0 == 'foo' evaluates to true.

Use strict comparison operators where possible. When comparing against a string literal, use the is# operator. Otherwise, prefer maktaba#value#IsEqual or check type() explicitly.

Check variable types explicitly before using them. Use functions from maktaba#ensure, or check maktaba#value or type() and throw your own errors.

Use :unlet for variables that may change types, particularly those assigned inside loops.

#### Python

**Use sparingly.**

Use python only when it provides critical functionality, for example when writing threaded code.

#### Other Languages

**Use Vimscript instead.**

Avoid using other scripting languages such as ruby and lua. We cannot guarantee that the end user's Vim has been compiled with support for non-vimscript languages.

#### Plugin layout

**Organize functionality into modular plugins**

Group your functionality as a plugin, unified in one directory (or code repository) which shares your plugin's name (with a "vim-" prefix or ".vim" suffix if desired). It should be split into plugin/, autoload/, etc. subdirectories as necessary, and it should declare metadata in the addon-info.json format (see the Vim documentation for details).

#### Functions

**In the autoload/ directory, defined with [!] and [abort].**

Autoloading allows functions to be loaded on demand, which makes startup time faster and enforces function namespacing.

Script-local functions are welcome, but should also live in autoload/ and be called by autoloaded functions.

Non-library plugins should expose commands instead of functions. Command logic should be extracted into functions and autoloaded.

[!] allows developers to reload their functions without complaint.

[abort] forces the function to halt when it encounters an error.

#### Commands

**In the plugin/commands.vim or under the ftplugin/ directory, defined without [!].**

General commands go in plugin/commands.vim. Filetype-specific commands go in ftplugin/.

Excluding [!] prevents your plugin from silently clobbering existing commands. Command conflicts should be resolved by the user.

#### Autocommands

**Place them in plugin/autocmds.vim, within augroups.**

Place all autocommands in augroups.

The augroup name should be unique. It should either be, or be prefixed with, the plugin name.

Clear the augroup with autocmd! before defining new autocommands in the augroup. This makes your plugin re-entrable.

#### Mappings

**Place them in plugin/mappings.vim, using maktaba#plugin#MapPrefix to get a prefix.**

All key mappings should be defined in plugin/mappings.vim.

Partial mappings (see :help using-<Plug>.) should be defined in plugin/plugs.vim.

**Always use the noremap family of commands.**

Your plugins generally shouldn't introduce mappings, but if they do, the map command respects the users existing mappings and could do anything.

#### Errors

When using catch, match the error codes rather than the error text.

#### Settings

**Change settings locally**

Use :setlocal and &l: instead of :set and & unless you have explicit reason to do otherwise.

### Style

Follow google style conventions. When in doubt, treat vimscript style like python style.

#### Whitespace

**Similar to python.**

- Use two spaces for indents
- Do not use tabs
- Use spaces around operators

This does not apply to arguments to commands.

let s:variable = "concatenated " . "strings"
command -range=% MyCommand

- Do not introduce trailing whitespace

You need not go out of your way to remove it.

Trailing whitespace is allowed in mappings which prep commands for user input,
such as "noremap <leader>gf :grep -f ".

- Restrict lines to 80 columns wide
- Indent continued lines by two spaces
- Do not align arguments of commands

```diff
+command -bang MyCommand call myplugin#foo()
+command MyCommand2 call myplugin#bar()
-command -bang MyCommand  call myplugin#foo()
-command       MyCommand2 call myplugin#bar()
```

#### Line Continuations

- Prefer line continuations on semantic boundaries.

```diff
+command SomeLongCommand
+    \ call some#function()
-command SomeLongCommand call
-    \ some#function()
```

- Place one space after the backslash denoting a line continuation.

When continuing a multi-line command a pipe can be substituted for this space as necessary, as follows:

```vim
autocommand BufEnter <buffer>
    \ if !empty(s:var)
    \|  call some#function()
    \|else
    \|  call some#function(s:var)
    \|endif
```

- Do not continue multi-line commands when you can avoid it. Prefer function calls.

#### Naming

- Keep them short and sweet.
- In general, use
    - `plugin-names-like-this`
    - `FunctionNamesLikeThis`
    - `CommandNamesLikeThis`
    - `augroup_names_like_this`
    - `variable_names_like_this`

- Do not create global functions. Use autoloaded functions instead.
- Prefer succinct command names over common command prefixes.
- Augroup names count as variables for naming purposes.
- Prefix all variables with their scope.
    - Global variables with g:
    - Script-local variables with s:
    - Function arguments with a:
    - Function-local variables with l:
    - Vim-predefined variables with v:
    - Buffer-local variables with b:
    - g:, s:, and a: must always be used.
    - b: changes the variable semantics; use it when you want buffer-local semantics.
    - l: and v: should be used for consistency, future proofing, and to avoid subtle bugs. They are not strictly required. Add them in new code but don’t go out of your way to add them elsewhere.
    - Autoloaded functions may not have a scope prefix.

## Key notations

- Use capital case and angle brackets for keyboard buttons: `<Down>`, `<Up>`.
- Use uppercase for custom leader: `SPC`, `WIN`, `UNITE`, `DENITE`.
- Use space as delimiter for key sequences: `SPC t w`, `<Leader> f o`.
- Use `/` for alternative sequences: `<Tab>` / `Ctrl-n`.
- Use `Ctrl-e` rather than `<C-e>` in documentation.

## Vimscript Style

- [Google Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
- [Google Vimscript Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Vim Scripting Style Guide](https://github.com/noahfrederick/vim-scripting-style-guide/blob/master/doc/scripting-style.txt)

## Markdown Style

- [Google's Markdown style guide](https://github.com/google/styleguide/blob/3591b2e540cbcb07423e02d20eee482165776603/docguide/style.md)

