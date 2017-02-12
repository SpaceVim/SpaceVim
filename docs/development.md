---
title:  "Development"
---

# Support SpaceVim

## Development happens in the GitHub repository.

[![Throughput Graph](https://graphs.waffle.io/SpaceVim/SpaceVim/throughput.svg)](https://github.com/SpaceVim/SpaceVim)

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
