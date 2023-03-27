# xmake.vim

> Vim/Neovim plugin for [xmake](https://github.com/tboox/xmake)

This plugin is inspired by [`luzhlon/xmake.vim`](https://github.com/luzhlon/xmake.vim/tree/5b20e97f5d0b063a97be23451c730d0278eef927)

## 功能

* 使用Vim打开xmake.lua文件时，加载对应的配置
* 保存xmake.lua时重新加载配置
* XMakek命令Tab键自动完成
* 异步构建，构建前会保存所有文件
* 构建失败自动打开quickfix窗口显示错误列表
* 构建并运行(Windows GVim下打开新的cmd窗口运行，不阻塞GVim窗口)

## 命令

| 命令                 | 功能                                               |
| -------------------- | -------------------------------------------------- |
| XMake build [target] | 构建目标，不指定target则构建所有目标               |
| XMake run [target]   | 运行目标，不指定target会自动寻找可运行的目标运行   |
| XMake [...]          | 使用...参数运行xmake命令，输出会投递到quickfix窗口 |
| XMakeLoad            | 手动加载xmake.lua里的配置                          |
| XMakeGen             | 根据当前的配置生成xmake.lua文件(实验性质)          |
