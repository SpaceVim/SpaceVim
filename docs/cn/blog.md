---
title: "博客"
description: "SpaceVim 最新资讯、新特新预览，Vim 实用教程及使用技巧整理。"
lang: cn
---

# SpaceVim 中文博客

在这里，你可以看到最新的 SpaceVim 特性简介，以及使用技巧：

<ul>
    {% for post in site.categories.blog_cn %}
            <li>
               <h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.excerpt | truncatewords: 100 }}</p>
            </li>
    {% endfor %}
</ul>
