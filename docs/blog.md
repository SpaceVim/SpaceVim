---
title: "Blog"
---

# Blog

Here you can learn more about SpaceVim with our tutorials and find out what's
going on. 

<ul>
    {% for post in site.posts %}
            <li>
               <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
               <span class="post-date">{{ post.date | date_to_string }}</span>
               <h4>{{ post.excerpt | truncatewords: 100 }}</h4>
            </li>
    {% endfor %}
</ul>
