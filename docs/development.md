---
title:  "Development"
description: "General contributing guidelines and changelog of SpaceVim, including development information about SpaceVim"
---

# [Home](../) >> Development

<!-- vim-markdown-toc GFM -->

- [Asking for help](#asking-for-help)
- [Reporting issues](#reporting-issues)
- [Contributing code](#contributing-code)
  - [License](#license)
  - [Bootstrap](#bootstrap)
  - [Conventions](#conventions)
  - [Pull Request](#pull-request)
    - [Title prefix of pull request](#title-prefix-of-pull-request)
    - [Rebase on top of upstream master](#rebase-on-top-of-upstream-master)
    - [Ideally for simple PRs](#ideally-for-simple-prs)
    - [For complex PRs](#for-complex-prs)
  - [Contributing a layer](#contributing-a-layer)
    - [File header](#file-header)
    - [Author of a new layer](#author-of-a-new-layer)
    - [Contributor to an existing layer](#contributor-to-an-existing-layer)
    - [Contributing a keybinding](#contributing-a-keybinding)
      - [Language specified key bindings](#language-specified-key-bindings)
    - [Contributing a banner](#contributing-a-banner)
- [Build with SpaceVim](#build-with-spacevim)
- [Changelog](#changelog)

<!-- vim-markdown-toc -->

SpaceVim is an effort of all the volunteers. We encourage you to pitch in. The community makes SpaceVim what it is.
We have a few guidelines which we need all contributors to follow.

You can only consider reading the sections relevant to what you are going to do:

- [Asking for help](#asking-for-help) if you are about to open an issue to ask a question.
- [Reporting issues](#reporting-issues) if you are about to open a new issue.
- [Contributing code](#contributing-code) if you are about to send a pull-request.

## Asking for help

If you want to ask an usage question, be sure to look first into some places as it may hold the answers:

- <kbd>:h SpaceVim-faq</kbd>: Some of the most frequently asked questions are answered there.
- [SpaceVim documentation](https://spacevim.org/documentation/): It is the general documentation of SpaceVim.

## Reporting issues

Issues have to be reported on [issues tracker](https://github.com/SpaceVim/SpaceVim/issues), please:

- Check that no duplicate issue is in the issues tracker, you can search for keywords in the issues tracker.
- Check that the issue has not been fixed in latest version of SpaceVim, please update your SpaceVim, and try to reproduce the bug here.
- Use a clear title and follow the issue template.
- Include details on how to reproduce it, just like a step by step guide.

## Contributing code

Code contributions are welcome. Please read the following sections carefully. In any case, feel free to join us on the [gitter chat](https://gitter.im/SpaceVim/SpaceVim) to ask questions about contributing!

### License

The license is GPLv3 for all the parts of SpaceVim. This includes:

- The initialization and core files.
- All the layer files.
- The documentation

For files not belonging to SpaceVim like local packages and libraries, refer to the header file. Those files should not have an empty header, we may not accept code without a proper header file.

### Bootstrap

Before contributing to SpaceVim, you should know how does SpaceVim bootstrap, here is the logic of the bootstrap when SpaceVim startup.

<!-- TODO -->

### Conventions

SpaceVim is based on conventions, mainly for naming functions, keybindings definition and writing documentation. Please read the [conventions](https://spacevim.org/conventions/) before your first contribution to get to know them.

### Pull Request

#### Title prefix of pull request

Pull request titles should contain one of these prefix:

- `Add:` Adding new features.
- `Change:` Change default behaviors or the existing features.
- `Fix:` Fix some bugs.
- `Remove:` Remove some existing features.
- `Doc:` Update the help files.
- `Website:` Update the content of website.

Here is an example:

`Website: Update the lang#c layer page.`

#### Rebase on top of upstream master

- Fork SpaceVim repository
- Clone your repository
```sh
git clone ${YOUR_OWN_REPOSITORY_URL}
```

- Add upstream remote
```sh
git remote add upstream https://github.com/SpaceVim/SpaceVim.git
```

- Fetch upstream and rebase on top of upstream master
```sh
git fetch upstream
git rebase upstream/master
```

#### Ideally for simple PRs

- Branch from `master`
- One topic per PR
- One commit per PR
- If you have several commits on different topics, close the PR and create one PR per topic
- If you still have several commits, squash them into only one commit

#### For complex PRs

Squash only the commits with uninteresting changes like typos, syntax fixes, etc. And keep the important and isolated steps in different commits.

Those PRs are merged and explicitly not fast-forwarded.

Commit messages

Write commit messages according to adapted [Tim Pope’s guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):

- Use present tense and write in the imperative: “Fix bug”, not “fixed bug” or “fixes bug”.
- Start with a capitalized, short (72 characters or less) summary, followed by a blank line.
- If necessary, add one or more paragraphs with details, wrapped at 72 characters.
- Separate paragraphs by blank lines.

This is a model commit message:

```gitcommit
Capitalized, short (72 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
or "Fixes bug."  This convention matches up with commit messages generated
by commands like git merge and git revert.

Further paragraphs come after blank lines.

- Bullet points are okay, too

    - Typically a hyphen or asterisk is used for the bullet, followed by a
      single space, with blank lines in between, but conventions vary here

    - Use a hanging indent
```

[Gita] provide Vim mode for Git commit messages, which helps you to comply to these guidelines.

### Contributing a layer

Please read the layers documentation first.

Layer with no associated configuration will be rejected. For instance a layer with just a package and a hook can be easily replaced by the usage of the variable `custom_plugins`.

#### File header

The file header for Vim script should look like the following template:

```vim
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
```

You should replace FILENAME by the name of the file (e.g. foo.vim) and NAME by the name of the layer you are creating, don’t forget to replace **YOUR NAME** and **YOUR EMAIL** neighter. 

#### Author of a new layer

In the files header, replace the default author name (Shidong Wang) with your name.

The following example shows how to create a new layer names `foo`:

1. Fork SpaceVim repo.
2. Add a layer file `autoload/SpaceVim/layers/foo.vim` for `foo` layer.
3. Edit layer file, check out the example below:

```vim
"=============================================================================
" foo.vim --- foo Layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section foo, layer-foo
" @parentsection layers
" This the doc for this layer:
"
" @subsection Key Bindings
" >
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <leader>jA    generate accessors
"   normal    <leader>js    generate setter accessor
" <
" @subsection Layer options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   option1       Set option1 for foo layer               ''
"   option2       Set option2 for foo layer               []
"   option3       Set option3 for foo layer               {}
" <
" @subsection Global options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   g:pluginA_opt1    Set opt1 for plugin A               ''
"   g:pluginB_opt2    Set opt2 for plugin B               []
" <

function! SpaceVim#layers#foo#plugins() abort
  let plugins = []
  call add(plugins, ['Shougo/foo.vim', {'option' : 'value'}])
  call add(plugins, ['Shougo/foo_test.vim', {'option' : 'value'}])
  return plugins
endfunction


function! SpaceVim#layers#foo#config() abort
  let g:foo_option1 = get(g:, 'foo_option1', 1)
  let g:foo_option2 = get(g:, 'foo_option2', 2)
  let g:foo_option3 = get(g:, 'foo_option3', 3)
  " ...
endfunction

" add layer options:
let s:layer_option = 'default var'
function! SpaceVim#layers#foo#set_variable(var) abort
  let s:layer_option = get(a:var, 'layer_option', s:layer_option)
endfunction

" completion function for layer options:
function! SpaceVim#layers#foo#get_options() abort
    return ['layer_option']
endfunction
```

4. Add layer document `docs/layers/foo.md` for `foo` layer.
5. Open `docs/layers/index.md`, run `:call SpaceVim#dev#layers#update()` to update layer list.
6. Send PR to SpaceVim.

#### Contributor to an existing layer

If you want to contribute to an already existing layer, you should not modify any header file.

#### Contributing a keybinding

Mappings are an important part of SpaceVim.

First if you want to have some personal mappings. This can be done in your bootstrap function.

If you think it worth contributing new mappings, be sure to read the documentation to find the best mappings, then create a Pull-Request with your mappings.

ALWAYS document your new mappings or mappings changes inside the relevant documentation file.
It should be the layername.md and the [documentation](../documentation/).

##### Language specified key bindings

All language specified key bindings prefix `SPC l`.

We recommend to keep same language specified key bindings for different languages:

| Key Binding | Description                                      |
| ----------- | ------------------------------------------------ |
| `SPC l r`   | start a runner for current file                  |
| `SPC l e`   | rename symbol                                    |
| `SPC l d`   | show doc                                         |
| `SPC l i r` | remove unused imports                            |
| `SPC l i s` | sort imports with isort                          |
| `SPC l s i` | Start a language specified inferior REPL process |
| `SPC l s b` | send buffer and keep code buffer focused         |
| `SPC l s l` | send line and keep code buffer focused           |
| `SPC l s s` | send selection text and keep code buffer focused |

All above key bindings are just recommended as default, but they also base on the language layer itself.

#### Contributing a banner

The startup banner is by default the SpaceVim logo but there are also ASCII banners available in the core/banner layer.

If you have some ASCII skills you can submit your artwork!

You are free to choose a reasonable height size but the width size should be around 75 characters.

## Build with SpaceVim

SpaceVim provide a lot of public [APIs](../api/), you can create plugins base on this APIs. Also you can add a badge to the README.md of your plugin.

![](https://img.shields.io/badge/build%20with-SpaceVim-ff69b4.svg)

markdown

```md
[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
```

## Changelog

<ul>
    {% for post in site.categories.changelog %}
            <li>
               <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>
