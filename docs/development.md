---
title:  "Development"
---

# Development

Development happens in the GitHub repository. here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

## Content

- [Contribution guidelines](#contribution-guidelines)
    - [Asking for help](#asking-for-help)
    - [Reporting issues](#reporting-issues)
    - [Contributing code](#contributing-code)

## Contribution guidelines

SpaceVim is a effort of all the volunteers, we encourage you to pitch in. The community makes SpaceVim what it is.
We have a few guidelines, which we ask all contributors to follow.

You can only consider reading the sections relevant to what you are going to do:

- [Asking for help](#asking-for-help) if you are about to open an issue to ask a question.
- [Reporting issues](#reporting-issues) if you are about to open a new issue.
- [Contributing code](#contributing-code) if you are about to send a Pull-Request.

### Asking for help

If you want to ask an usage question, be sure to look first into some places as it may hold the answers:
- <kbd>:h SpaceVim-faq</kbd> Some of the most frequently asked questions are answered there.
- [SpaceVim documentation](https://spacevim.org/documentation), It is the general documentation of SpaceVim.

### Reporting issues

issues have to be reported on issues tracker, Please:
- Check that there is no duplicate issue in the issues tracker, you can search keywords in the issues tracker.
- Check that the issue has not been fixed in latest version of SpaceVim, please update your SpaceVim, and try to reproduce the bug here.
- Use a clear title and follow the issue template.
- Include details on how to reproduce it, just like a step by step guide.

### Contributing code

## Conventions

## Report bugs

If you get any issues, please open an issue with the ISSUE_TEMPLATE. It is useful for me to debug for this issue.

## Contribute Layers

1. fork SpaceVim repo
2. add a layer file `autoload/SpaceVim/layers/foo.vim` for `foo` layer.
3. edit layer file, check out the example below:

```vim
function! SpaceVim#layers#foo#plugins() abort
let plugins = []
call add(plugins, ['Shougo/foo.vim', {'option' : 'value'}])
return plugins
endfunction


function! SpaceVim#layers#foo#config() abort
" here you can set some value or mappings
endfunction
```

4. send PR to SpaceVim.

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
