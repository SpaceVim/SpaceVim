---
title: "公共 API"
description: "SpaceVim 公共 API 提供了一套开发插件的公共函数，以及 neovim 和 vim 的兼容组件"
lang: cn
---

# SpaceVim 公共 APIs

SpaceVim 提供了许多公共的 apis，你可以在你的插件中使用这些公共 apis，SpaceVim 的公共 apis 借鉴与 [vital.vim](https://github.com/vim-jp/vital.vim)

## 使用方法

可以使用 `SpaceVim#api#import()` 方法导入 API。参考以下示例：

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
file  | 文件 API | [readme](https://spacevim.org/cn/api/file)
system | 系统 API | [readme](https://spacevim.org/cn/api/system)
job | 异步协同 API | [readme](https://spacevim.org/cn/api/job)
