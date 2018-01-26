---
title: "博客"
description: "SpaceVim 中文博客"
---

# SpaceVim 中文博客

在这里，你可以看到最新的 SpaceVim 特性简介，以及使用技巧：

<ul>
    {% for post in site.posts_by_language.cn %}
            <li>
               <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <h3>{{ post.excerpt | truncatewords: 100 }}</h3>
            </li>
    {% endfor %}
<
