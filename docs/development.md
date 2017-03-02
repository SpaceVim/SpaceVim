---
title:  "Development"
permalink: "/development"
redirect_from: "/development/index.html"
---

# Development

Development happens in the GitHub repository. here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

## Content

- [Contribution guidelines](#contribution-guidelines)
    - [Asking for help](#asking-for-help)
    - [Reporting issues](#reporting-issues)
    - [Contributing code](#contributing-code)
- [Build with SpaceVim](#build-with-spacevim)
- [Changelog](#changelog)

## Contribution guidelines

SpaceVim is a effort of all the volunteers, we encourage you to pitch in. The community makes SpaceVim what it is.
We have a few guidelines, which we ask all contributors to follow.

You can only consider reading the sections relevant to what you are going to do:

- [Asking for help](#asking-for-help) if you are about to open an issue to ask a question.
- [Reporting issues](#reporting-issues) if you are about to open a new issue.
- [Contributing code](#contributing-code) if you are about to send a Pull-Request.

### Asking for help

If you want to ask an usage question, be sure to look first into some places as it may hold the answers:
- <kbd>:h SpaceVim-faq</kbd>: Some of the most frequently asked questions are answered there.
- [SpaceVim documentation](https://spacevim.org/documentation): It is the general documentation of SpaceVim.

### Reporting issues

issues have to be reported on [issues tracker](https://github.com/SpaceVim/SpaceVim/issues), Please:
- Check that there is no duplicate issue in the issues tracker, you can search keywords in the issues tracker.
- Check that the issue has not been fixed in latest version of SpaceVim, please update your SpaceVim, and try to reproduce the bug here.
- Use a clear title and follow the issue template.
- Include details on how to reproduce it, just like a step by step guide.

### Contributing code

Code contributions are welcome. Please read the following sections carefully. In any case, feel free to join us on the [gitter chat](https://gitter.im/SpaceVim/SpaceVim) to ask questions about contributing!

#### License

The license is MIT for all the parts of SpaceVim. this includes:
- The initialization and core files
- All the layer files.

For files not belonging to Spacemacs like local packages and libraries, refer to the header file. Those files should not have an empty header, we may not accept code without a proper header file.

#### Conventions

SpaceVim is based on conventions, mainly for naming functions, keybindings definition and writing documentation. Please read the [conventions](https://spacevim.org/development/conventions) before your first contribution to get to know them.

#### Pull Request

Submit your contribution against the `dev` branch. You should not use your master branch to modify SpaceVim, this branch is considered to be read-only.

You may want to read our beginner’s guide for Pull Requests.

PR = Pull-Request

##### Ideally for simple PRs (most of them):

- Branch from `dev`
- One topic per PR
- One commit per PR
- If you have several commits on different topics, close the PR and create one PR per topic
- If you still have several commits, squash them into only one commit
- Rebase your PR branch on top of upstream develop before submitting the PR

Those PRs are usually cherry-picked.

##### For complex PRs (big refactoring, etc):

Squash only the commits with uninteresting changes like typos, syntax fixes, etc… and keep the important and isolated steps in different commits.

Those PRs are merged and explicitly not fast-forwarded.
Commit messages

Write commit messages according to adapted [Tim Pope’s guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html):

- Use present tense and write in the imperative: “Fix bug”, not “fixed bug” or “fixes bug”.
- Start with a capitalized, short (72 characters or less) summary, followed by a blank line.
- If necessary, add one or more paragraphs with details, wrapped at 72 characters.
- Separate paragraphs by blank lines.

This is a model commit message:

```
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

[Gita] provide vim mode for Git commit messages, which helps you to comply to these guidelines.

#### Contributing a layer

Please read the layers documentation first.

Layer with no associated configuration will be rejected. For instance a layer with just a package and a hook can be easily replaced by the usage of the variable `g:spacevim_custom_plugins`.

##### File header

The file header for vim script should look like the following template:

```viml
"=============================================================================
" FILENAME --- NAME layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: YOUR_NAME <YOUR_EMAIL>
" URL: https://spacevim.org
" License: MIT license
"=============================================================================
```

You should replace FILENAME by the name of the file (e.g. foo.vim) and NAME by the name of the layer you are creating, don’t forget to replace YOUR_NAME and YOUR_EMAIL also. 

##### Author of a new layer

In the files header, change the default author name (Shidong Wang) to your name.

here is an example for creating a new layer names `foo`:

1. fork SpaceVim repo
2. add a layer file `autoload/SpaceVim/layers/foo.vim` for `foo` layer.
3. edit layer file, check out the example below:

```vim
"=============================================================================
" foo.vim --- foo Layer file for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

""
" @section foo, layer-foo
" @parentsection layers
" This the doc for this layer:
"
" @subsection Mappings
" >
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    <leader>jA    generate accessors
"   normal    <leader>js    generate setter accessor
" <
" @subsection options
" >
"   Name              Description                      Default
"   -------------------------------------------------------------
"   g:foo_option1     Set option1 for foo layer        1
"   g:foo_option2     Set option2 for foo layer        2
"   g:foo_option3     Set option3 for foo layer        3
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
```

4. send PR to SpaceVim.

##### Contributor to an existing layer

If you are contributing to an already existing layer, you should not modify any header file.

#### Contributing a keybinding

Mappings are an important part of SpaceVim.

First if you want to have some personal mappings, This can be done in your `~/.SpaceVim.d/init.vim` file.

If you think it worth contributing a new mappings then be sure to read the documentation to find the best mappings, then create a Pull-Request with your changes.

ALWAYS document your new mappings or mappings changes inside the relevant documentation file. It should be the the layer file and the [documentation.md](https://spacevim.org/documentation).

#### Contributing a banner

The startup banner is by default the SpaceVim logo but there are also ASCII banners available in the core/banner layer.

If you have some ASCII skills you can submit your artwork!

You are free to choose a reasonable height size but the width size should be around 75 characters.


## Build with SpaceVim

SpaceVim provide a lot of public [APIs](https://spacevim.org/apis), you can create plugins base on this APIs. also you can add a badge to the README.md of your plugin.

![](https://img.shields.io/badge/build%20with-SpaceVim-ff69b4.svg)

markdown

```md
[![](https://spacevim.org/img/build-with-SpaceVim.svg)](https://spacevim.org)
```

## Changelog

<ul>
    {% for post in site.categories.changelog %}
            <li>
                <a href="{{ post.url }}">{{ post.title }}</a>
            </li>
    {% endfor %}
</ul>
