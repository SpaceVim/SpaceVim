### Explain the issue

Most issues are related to bugs or problems. In these cases, you should
include a minimal working example and a minimal vimrc file (see below), as
well as:

1. What vim version are you using?
2. Steps to reproduce
3. Expected behavior
4. Observed behavior

If your issue is instead a feature request or anything else, please
consider if minimal examples and vimrc files might still be relevant.

### Minimal working example

Please provide a minimal working example, e.g.,

```vim
if l:x == 1
  call one()
elseif l:x == 2
  call two()
else
  call three()
endif
```

### Minimal vimrc file

Please provide a minimal vimrc file that reproduces the issue. The
following should often suffice:

```vim
set nocompatible

" load match-up
let &rtp  = '~/.vim/bundle/vim-matchup,' . &rtp
let &rtp .= ',~/.vim/bundle/vim-matchup/after'

" load other plugins, if necessary
" let &rtp = '~/path/to/other/plugin,' . &rtp

filetype plugin indent on
syntax enable

" match-up options go here
```

