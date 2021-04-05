[![SpaceVim](docs/logo.png)](https://spacevim.org/cn/)

[Wiki](https://gitee.com/spacevim/SpaceVim/wikis) \|
[入门指南](https://spacevim.org/cn/quick-start-guide/) \|
[用户手册](https://spacevim.org/cn/documentation/) \|
[中文社区](https://spacevim.org/cn/community/) \|
[捐助](https://spacevim.org/cn/sponsors/) \|
[微博](https://weibo.com/SpaceVim) \|
[中文交流群](https://gitter.im/SpaceVim/SpaceVim)

[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/cn)
[![build](https://github.com/SpaceVim/SpaceVim/workflows/build/badge.svg)](https://github.com/SpaceVim/SpaceVim/actions?query=workflow%3Abuild)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master/graph/badge.svg?token=jVQLVETbAI)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Version](https://img.shields.io/badge/version-1.7.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome page](https://user-images.githubusercontent.com/13142418/103414298-5e1da980-4bb8-11eb-96bc-b2e118f672b5.png)

[SpaceVim](https://spacevim.org/cn/) 是一个社区驱动的模块化 Vim/Neovim 配置集合，以模块的方式组织管理插件以
及相关配置，为不同的语言开发量身定制了相关的开发模块，该模块提供代码自动补全，
语法检查、格式化、调试、REPL 等特性。用户仅需载入相关语言的模块即可得到一个开箱
即用的 Vim-IDE。

当前最新的稳定版为[v1.5.0](https://spacevim.org/SpaceVim-release-v1.5.0/)，[following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) 页面罗列了
master 分支最新的更新以及变动。

**推荐阅读:**

- [入门指南](https://spacevim.org/cn/quick-start-guide/)
- [用户文档](https://spacevim.org/cn/documentation/)
- [可用模块](https://spacevim.org/cn/layers/)

## 最新特性

以下为 SpaceVim 中最新实现的一些特性：

**多光标 Iedit 模式:**

SpaceVim 内置了一种特殊的模式，Iedit 模式，这种模式提供了多光标支持，不同于已有插件的实现，
该模式支持两种状态：`iedit-Normal` 和 `iedit-Insert`。默认情况下，多光标输入时，`iedit-normal`
模式状态栏时是红色，而 `iedit-insert` 模式时是绿色，当然这由所选择的主题决定。

![iedit mode](https://user-images.githubusercontent.com/13142418/44941560-be2a9800-add2-11e8-8fa5-e6118ff9ddcb.gif)

**高亮光标下的函数:**

SpaceVim 支持高亮当前光标函数，并且启动一个特殊模式，在该模式下可以快捷地切换高亮区域
（方法内、屏幕内、整个文件内），并且可以快速在高亮函数间跳转、切换高亮状态（高亮、取消高亮），
并且可以根据已选择的位置进入 Iedit 模式。

![highlight cursor symbol](https://user-images.githubusercontent.com/13142418/36210381-e6dffde6-1163-11e8-9b35-0bf262e6f22b.gif)

**实时代码检索:**

SpaceVim 自带的 FlyGrep 这个插件可以根据输入实时搜索项目代码，当然需要借助后台搜索工具，
目前支持的工具有：`ag`, `rg`, `ack`, `pt` 和 `grep`，用户可任意选择一个喜欢的工具。

![searching project](https://user-images.githubusercontent.com/13142418/35278709-7856ed62-0010-11e8-8b1e-e6cc6374b0dc.gif)

**快捷键辅助导航:**

在 SpaceVim 中，所有快捷键都有导航系统，你不需要记忆任何快捷键。初次使用时可根据快捷键提示进行操作。当按下空格键或者
`g`、`z` 以及 `s` 按键时，导航就会自动出现。当你记住了快捷键，输入比较快时，导航则不会出现。

![mapping guide](https://user-images.githubusercontent.com/13142418/35568184-9a318082-058d-11e8-9d88-e0eafd1d498d.gif)

**快捷键描述系统**

通过快捷键描述系统，你可以清楚的了解到一个快捷键的功能，并且可以快速跳转到快捷键定义的位置；
比如，通过 `SPC h d k` 启动快捷键描述系统，然后按下所需描述快捷键 `SPC b n`，就会弹出一个描述
窗口，在改窗口可以通过快捷键 `gd` 快速跳转到快捷键定义处。

![describe key bindings](https://user-images.githubusercontent.com/13142418/35568829-e3c8e74c-058f-11e8-8fa8-c0e046d8add3.gif)

[**异步插件管理器:**](https://spacevim.org/cn/asynchronous-plugin-manager/)

SpaceVim 利用了 Vim 8 和 Neovim 最新的异步机制，实现了异步插件下载及更新，而插件运行管理采用的是 [dein.vim](https://github.com/Shougo/dein.vim/)。

![UI for dein](https://user-images.githubusercontent.com/13142418/34907332-903ae968-f842-11e7-8ac9-07fcc9940a53.gif)

想要获取更多关于 SpaceVim 的最新特性，请关注 [SpaceVim 官方博客](https://spacevim.org/blog/)

## 支持 SpaceVim

| 微信                                                     | 支付宝                                                     |
| -------------------------------------------------------- | ---------------------------------------------------------- |
| <img src="docs/img/weixin.png" height="150" width="150"> | <img src="docs/img/zhifubao.png" height="150" width="150"> |

## 鸣谢

- [@Gabirel](https://github.com/Gabirel) 的 [《Hack-SpaceVim》](https://github.com/Gabirel/Hack-SpaceVim)
- [@everettjf](https://github.com/everettjf) 的 [《SpaceVimTutorial》](https://everettjf.gitbooks.io/spacevimtutorial/content/)
- [vimdoc](https://github.com/google/vimdoc)：自动生成帮助文件
- SpaceVim 中所使用所有插件的作者

<!-- vim:set nowrap: -->
