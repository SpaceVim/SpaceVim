---
title: "公共 API"
lang: cn
---

# SpaceVim 公共 APIs

SpaceVim 提供了许多公共的 apis，你可以在你的插件中使用这些公共 apis，SpaceVim 的公共 apis 借鉴与 [vital.vim](https://github.com/vim-jp/vital.vim)

## 使用方法

```viml

let s:file = SpaceVim#api#import('file')
let s:system = SpaceVim#api#import('system')

if s:system.isWindows
    echom "Os is Windows"
endif
echom s:file.separator
echom s:file.pathSeparator
```

以下为可用的公共 apis，欢迎贡献新的 apis

名称 | 描述 | 文档
----- |:----:| -------
file  | 文件 API | [readme](https://spacevim.org/api/file)
system | 系统 API | [readme](https://spacevim.org/api/system)
