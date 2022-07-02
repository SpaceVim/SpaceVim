---
title: "主页"
description: "SpaceVim 是一个社区驱动的模块化的 Vim IDE，以模块的方式组织和管理插件，提高 Vim 环境配置效率。"
lang: zh
---

[![Gitter](https://img.shields.io/gitter/room/SpaceVim/SpaceVim?color=%2364CEAA)](https://gitter.im/SpaceVim/cn)
[![build](https://img.shields.io/github/workflow/status/SpaceVim/SpaceVim/test)](https://github.com/SpaceVim/SpaceVim/actions/workflows/check.yml?query=branch%3Amaster)
[![Codecov coverage](https://img.shields.io/codecov/c/github/SpaceVim/SpaceVim.svg)](https://codecov.io/gh/SpaceVim/SpaceVim)
[![Version](https://img.shields.io/badge/version-2.1.0--dev-8700FF.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/master/LICENSE)

![welcome page](https://user-images.githubusercontent.com/13142418/176910121-8e7ca78f-8434-4ac7-9b02-08c4d15f8ad9.png)

# SpaceVim - 模块化的 Vim IDE

SpaceVim 是一个社区驱动的模块化的 Vim IDE，以模块的方式组织管理插件以及相关配置，
为不同的语言开发量身定制了相关的开发模块，该模块提供代码自动补全，
语法检查、格式化、调试、REPL 等特性。用户仅需载入相关语言的模块即可得到一个开箱即用的 Vim IDE。

如果你喜欢 SpaceVim，可以在[码云](https://gitee.com/spacevim/SpaceVim)或者
[GitHub](https://github.com/SpaceVim/SpaceVim/) 上留下一颗星，非常感谢！

- [入门指南](quick-start-guide/): 包括最基本的安装以及配置教程，同时包括了针对不同语言的配置技巧
- [使用文档](documentation/): 完整的用户使用文档，详细介绍了每一个快捷键以及配置的功能
- [可用模块](layers/): 罗列了目前已经支持的所有模块，包括功能模块和不同的语言模块

当前最新的稳定版为[v2.0.0](https://spacevim.org/SpaceVim-release-v2.0.0/)，发布于2022年7月2日，[following-HEAD](https://github.com/SpaceVim/SpaceVim/wiki/Following-HEAD) 页面罗列了
master 分支最新的更新以及变动。

## 最新特性

<ul>
    {% for post in site.categories.feature_cn offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
               <br>
               <img alt="{{ post.title }}" src="{{ post.image }}">
    {% endfor %}
</ul>

更多精彩内容会定期在 SpaceVim [博客](blog/)上发布。

或者可以关注我们的推特：[@SpaceVim](https://twitter.com/SpaceVim)。

## 参与

常规的项目讨论和问答主要是使用 [Gitter 聊天室](https://gitter.im/SpaceVim/cn) 和 [知乎](https://www.zhihu.com/topic/20168681/hot)，
而提交问题和贡献代码主要是在 [Github](https://github.com/SpaceVim/SpaceVim) 上，
同时，SpaceVim 开通了[码云仓库](https://gitee.com/spacevim/SpaceVim)，主要用于中文交流。

## 常见问题

- 目前 SpaceVim 的开发状态如何？

  当前最新发布的稳定版本是 v1.9.0。可以查看 [时间表](https://github.com/SpaceVim/SpaceVim/milestones) 获取开发进度，
  或者阅读 [Roadmap](roadmap/) 获取开发计划。

- SpaceVim 是尝试搭建一个 IDE 吗？

  是的，通过模块的方式，将各种功能封装成相应的模块，对多种语言提供了语言开发模块，目标是尝试模拟简易的集成开发环境。

- SpaceVim 支持多少种编程语言？

  ```sh
  ~/.SpaceVim> ls autoload/SpaceVim/layers/lang | wc -l
  87
  ```

- SpaceVim 支持什么版本的 Vim/Neovim？

  SpaceVim 目前已通过 gh 测试了如下版本的 vim 和 neovim：

  - vim: `master`, `8.1.2269`, `8.0.1453`, `8.0.0027`,`7.4.1689`,`7.4.629`, `7.4.052`
  - neovim: `nightly`, `v0.5.0`, `v0.4.4`, `v0.4.3`, `v0.4.2`, `v0.4.0`, `v0.3.8`

更多常见问题请阅读[常见问题解答](faq/)

<!-- vim:set nowrap: -->
