---
title: "博客"
description: "SpaceVim 最新资讯、新特新预览，Vim 实用教程及使用技巧整理。"
lang: zh
---

# [主页](../) >> 博客

SpaceVim 中文博客主要公布最新版本发布、新特性预览以及一些 SpaceVim 及 Vim
相关的使用教程，可通过 RSS [订阅本博客](../../feed.xml)：

<ul>
    {% for post in site.categories.blog_cn %}
            <li>
               <h5><a href="{{ post.url }}">{{ post.title }}</a></h5>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.description | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>
