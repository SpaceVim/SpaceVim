---
title: "常见问题"
description: "在使用 SpaceVim 过程中比较常见的一些问题，包括并不限于安装、配置及使用。"
lang: zh
---

# [主页](../) >> 常见问题解答

这里根据社区反馈的情况，罗列了一些大家经常会问的问题，如果有需要补充的，欢迎使用
使用 SpaceVim 中文社区频道参与讨论，也可以直接编辑本页并提交 PR 。


<!-- vim-markdown-toc GFM -->

- [为什么选择 Toml 作为默认配置格式？](#为什么选择-toml-作为默认配置格式)
- [为什么 SpaceVim 颜色主题和官网不一致？](#为什么-spacevim-颜色主题和官网不一致)
- [如何增加自定义快捷键？](#如何增加自定义快捷键)
- [按下 Ctrl-s 后，Vim 为什么会卡死？](#按下-ctrl-s-后vim-为什么会卡死)

<!-- vim-markdown-toc -->

### 为什么选择 Toml 作为默认配置格式？

在往期的版本中，一直使用 Vim 脚本作为配置文件，而 SpaceVim 读取配置文件的机制是
直接载入该脚本。Vim 在载入脚本时是边载入边执行的，这就意味着当你的配置文件中间部分
出现语法错误时，并不能阻止前半部分配置被载入，排错时非常有影响。

因此我们选择了另外一种更加健壮的语言来配置 SpaceVim，SpaceVim 会完整读取该配置文件，
如果文件中间出现语法错误，导致解析失败。那么该配置会被完全舍弃，而使用 SpaceVim 的
默认配置，这就大大降低了因配置文件错误导致 SpaceVim 运行出错的可能性。

在配置文件格式选择时，我们在 json、yaml、xml、Toml 这四中文件格式之间也做了比较。

1. yaml 依赖缩进，配置转移时易出错，不予考虑
2. xml 缺少 Vim 解析库，不予考虑
3. json 时一个比较好的配置信息传输格式，并且 Vim 有一个解析的函数，但是 json 格式
不支持注释，手写编辑时，可读性太差，不予考虑。

因此，我们选择了 Toml 作为默认的配置格式，并且解析后缓存为 json 文件。
SpaceVim 在启动时直接读取缓存的 json 文件，效率更高。

### 为什么 SpaceVim 颜色主题和官网不一致？

因为在 SpaceVim 中，默认情况下启用了终端真色，因此你需要确保你的终端支持真色。
但是并不是每种终端都支持真色。因此，当你的终端不支持真色时，你可以在配置文件里面禁用真色支持：

```toml
[options]
    enable_guicolors = false
```

### 如何增加自定义快捷键？

使用 Toml 作为默认配置文件后，无法在配置文件里面直接添加 Vim 快捷键，
这点让很多用户感到困惑。实际上，SpaceVim 支持指定载入配置时需要调用的函数。

比如，我需要加入这样一个快捷键，使用 `<Leader> w` 来保存当前文件。那么，
我需要修改配置文件，并指定一个载入时需要调用的方法：

在`~/.SpaceVim.d/init.toml`的[options]片断中加入 `bootstrap_before` 选项：
```toml
[options]
    bootstrap_before = "myspacevim#init"
```

添加文件 `~/.SpaceVim.d/autoload/myspacevim.vim`, 并加入如下内容：

```vim
function! myspacevim#init() abort
    nnoremap <Leader>w :w<cr>
endfunction
```

### 按下 Ctrl-s 后，Vim 为什么会卡死？

这是终端模拟器的特性，在终端模拟器内，有一套快捷键，可以暂停终端输出和恢复输出，默认情况下，
按下 `Ctrl-s` 终端会停止输出，表现为 Vim 卡住，按任何按键都无响应。此时可以按 `Ctrl-q` 恢复终端。
当然，如果你希望禁用这一特性，可以在的终端配置文件 `~/.bashrc` 或者 `~/.bash_profile` 中加入：

```sh
stty -ixon
```
