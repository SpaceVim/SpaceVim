---
title: "主页"
description: "SpaceVim 是一个社区驱动的模块化的 Vim IDE，以模块的方式组织和管理插件，提高 Vim 环境配置效率。"
lang: zh
---

[![Gitter](https://badges.gitter.im/SpaceVim/SpaceVim.svg)](https://gitter.im/SpaceVim/cn)
[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/dev?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/master)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/master)
[![Version](https://img.shields.io/badge/version-1.3.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome-page](https://user-images.githubusercontent.com/13142418/68079142-904e4280-fe1f-11e9-993e-b834ea3d39ea.png)

# SpaceVim - 模块化的 Vim IDE

SpaceVim 是一个社区驱动的模块化的 Vim IDE，以模块的方式组织管理插件以及相关配置，
为不同的语言开发量身定制了相关的开发模块，该模块提供代码自动补全，
语法检查、格式化、调试、REPL 等特性。用户仅需载入相关语言的模块即可得到一个开箱即用的 Vim IDE。

如果你喜欢SpaceVim，可以在 [gitee](https://gitee.com/spacevim/SpaceVim) 上给 SpaceVim 加星，这是一个很好的方式来表达你的感激之情，同时也给了我们继续做这个项目的动力。

- [入门指南](quick-start-guide/): 包括最基本的安装以及配置教程，同时包括了针对不同语言的配置技巧
- [使用文档](documentation/): 完整的用户使用文档，详细介绍了每一个快捷键以及配置的功能
- [可用模块](layers/): 罗列了目前已经支持的所有模块，包括功能模块和不同的语言模块

## 最新特性

<ul>
    {% for post in site.categories.feature_cn offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.excerpt | truncatewords: 100 }}</p>
               <br>
               <img alt="{{ post.title }}" src="{{ post.image }}">
    {% endfor %}
</ul>

更多精彩博客请订阅 SpaceVim [博客](blog/) 或关注微博 [@SpaceVim](https://weibo.com/SpaceVim)。

## 参与

常规的项目讨论和问答主要是使用 [Gitter 聊天室](https://gitter.im/SpaceVim/cn) 和 [知乎](https://www.zhihu.com/topic/20168681/hot)，
而提交问题和贡献代码主要是在 [Github](https://github.com/SpaceVim/SpaceVim) 上，
同时，SpaceVim 开通了[码云仓库](https://gitee.com/spacevim/SpaceVim)，主要用于中文交流。

## 常见问题

- 目前 SpaceVim 的开发状态如何？

当前最新发布的稳定版本是 v1.2.0。可以查看 [时间表](https://github.com/SpaceVim/SpaceVim/milestones) 获取开发进度，
或者阅读 [Roadmap](roadmap/) 获取开发计划。

- SpaceVim 是尝试搭建一个 IDE 吗？

是的，通过模块的方式，将各种功能封装成相应的模块，对多种语言提供了语言开发模块，目标是尝试模拟简易的集成开发环境。

- SpaceVim 支持多少种编程语言？ 

```sh
~/.SpaceVim> ls autoload/SpaceVim/layers/lang | wc -l
78
```

- SpaceVim 支持什么版本的 Vim/Neovim？

建议使用 Vim 7.4 或者 Neovim v0.1.7及其以上版本。

更多常见问题请阅读[常见问题解答](faq/)

<!-- vim:set nowrap: -->
