---
title: "博客"
description: "SpaceVim 中文博客"
lang: cn
---

# SpaceVim 中文博客

在这里，你可以看到最新的 SpaceVim 特性简介，以及使用技巧：

<ul>
    {% for post in site.categories.feature_cn offset: 0 limit: 5  %}
               <strong><a href="{{ post.url }}">{{ post.title }}</a></strong>
               <br>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <p>{{ post.excerpt | truncatewords: 100 }}</p>
    {% endfor %}
</ul>
