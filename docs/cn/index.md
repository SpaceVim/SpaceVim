---
title:  "主页"
description: "SpaceVim is a community-driven vim distribution that seeks to provide layer feature."
lang: cn
---

[![Build Status](https://travis-ci.org/SpaceVim/SpaceVim.svg?branch=dev)](https://travis-ci.org/SpaceVim/SpaceVim)
[![Build status](https://ci.appveyor.com/api/projects/status/eh3t5oph70abp665/branch/dev?svg=true)](https://ci.appveyor.com/project/wsdjeg/spacevim/branch/dev)
[![codecov](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev/graph/badge.svg)](https://codecov.io/gh/SpaceVim/SpaceVim/branch/dev)
[![Version](https://img.shields.io/badge/version-0.8.0--dev-FF69B4.svg)](https://github.com/SpaceVim/SpaceVim/releases)
[![GPLv3 License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://github.com/SpaceVim/SpaceVim/blob/dev/LICENSE)
[![QQ](https://img.shields.io/badge/QQ群-121056965-blue.svg)](https://jq.qq.com/?_wv=1027&k=43DB6SG)
[![Weibo](https://img.shields.io/badge/Weibo-%40SpaceVim-orange.svg)](https://weibo.com/SpaceVim)
[![GitHub stars](https://img.shields.io/github/stars/SpaceVim/SpaceVim.svg?style=social&label=Star)](https://github.com/SpaceVim/SpaceVim)

![welcome-page](https://user-images.githubusercontent.com/13142418/33793078-3446cb6e-dc76-11e7-9998-376a355557a4.png)

官 网： <https://spacevim.org>

Github : <https://github.com/SpaceVim/SpaceVim>

码 云 : <https://gitee.com/SpaceVim/SpaceVim>

SpaceVim 是一个社区驱动的模块化 vim/neovim 配置集合，以模块的方式组织管理插件以
及相关配置，为不同的语言开发量身定制了相关的开发模块，该模块提供代码自动补全，
语法检查、格式化、调试、REPL 等特性。用户仅需载入相关语言的模块即可得到一个开箱
即用的Vim-IDE。

推荐阅读：

- [入门指南](quick-start-guide)
- [用户文档](documentation)
- [可用模块](layers)

## 最新特新

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

更多精彩博客请订阅 [SpaceVim 中文博客](https://spacevim.org/cn/blog/)

[关注微博 @SpaceVim](https://weibo.com/SpaceVim) 

## 参与

使用过程中遇到问题或者有什么功能需求可以在码云提交，这将更容易被关注
和修复。我们也欢迎喜欢 vim/neovim 的用户加入我们的
[QQ群(点击加入)](https://jq.qq.com/?_wv=1027&k=43zWPlT)，该群定期也会分享一些
实用的 Vim 技巧以及插件。
