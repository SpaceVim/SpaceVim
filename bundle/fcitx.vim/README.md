Keep and restore fcitx state for each buffer separately when leaving/re-entering insert mode. Like always typing English in normal mode, but Chinese in insert mode.

Requires: fcitx 3.6 or later, 4.0 or later will be better.

Settings: environment variable `$FCITX_SOCKET` specifies a socket to connect instead of figuring out itself. This can be an abstract socket address starting with `@` from version 1.2.4 on.

* [git repo](https://github.com/lilydjwg/fcitx.vim)
* [www.vim.org](https://www.vim.org/scripts/script.php?script_id=3764)

Warning:

1. It will be faster and better with Python (3 or 2) enabled Vim. But some old version Vim enabled both Python 2 & 3 may have some issues.
2. If you use Vim in terminal, to avoid the Esc delay, please set `'ttimeoutlen'` to 100 or some other value. And check screen's `maptimeout` or tmux's `escape-time` option if you use it too.

For Mac OS X users, you can use a "fcitx-remote" [here](https://github.com/CodeFalling/fcitx-remote-for-osx), together with the VimL version (the `so/fcitx.vim` file).

在离开或重新进入插入模式时自动记录和恢复每个缓冲区各自的输入法状态，以便在普通模式下始终是英文输入模式，切换回插入模式时恢复离开前的输入法输入模式。

要求: fcitx 版本 3.6 以上，建议 fcitx 4.0 以上。

配置：环境变量 `$FCITX_SOCKET` 指定要连接的套接字路径，而非默认的。自版本 1.2.4 起，此变量若以 `@` 字符开头，则被认为是抽象套接字地址。

* [git 仓库](https://github.com/lilydjwg/fcitx.vim)
* [www.vim.org](https://www.vim.org/scripts/script.php?script_id=3764)

注意事项:

1. Vim 如有 Python 3或2 支持可以获得更快更好的效果。但对于较旧的 Vim 版本，如果同时编译了 Python 2 & 3 支持，因为此 Vim 不能同时运行两个版本的 Python，而本脚本首先检查 Python 3，所以会导致出错或者 Python 2 不可用。
2. 终端下请设置 Vim `'ttimeoutlen'` 选项为较小值（如100），否则退出插入模式时会有较严重的延迟。同样会造成延迟的还有 screen 的 `maptimeout` 选项以及 tmux 的 `escape-time` 选项。

如果你想跨主机使用 fcitx.vim，请参考此文：[fcitx-remote 接口通过 socat 跨主机使用](https://blog.lilydjwg.me/2012/7/27/using-fcitx-remote-interface-remotely-via-socat.34729.html)。

Mac OS X 用户可以使用[此项目](https://github.com/CodeFalling/fcitx-remote-for-osx)提供的 fcitx-remote 命令，配合本软件的 VimL 版（`so/fcitx.vim` 文件）来使用。
