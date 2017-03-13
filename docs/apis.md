---
title: "APIs"
---

# SpaceVim public APIs:

SpaceVim provide many public apis, you can use this apis in your plugins. SpaceVim api got inspired by [vital.vim](https://github.com/vim-jp/vital.vim)

## Usage

```viml

let s:file = SpaceVim#api#import('file')
let s:system = SpaceVim#api#import('system')

if s:system.isWindows
    echom "Os is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

here is the list of all the apis, and welcome to contribute to SpaceVim.

name | description | documentation
----- |:----:| -------
file  | basic api about file and directory | [readme](https://spacevim.org/api/file)
system | basic api about system | [readme](https://spacevim.org/api/system)
