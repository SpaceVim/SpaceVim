---
title:  "Development"
---

# Development

Development happens in the GitHub repository. here is a throughput graph of the repository for the last few weeks:

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://waffle.io/SpaceVim/SpaceVim/metrics/throughput)

## Contribution guidelines

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
