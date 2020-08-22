---
title: "data#list 函数库"
description: "data#list 函数库主要提供一些操作列表的常用函数。"
lang: zh
---

# [可用函数库](../../) >> data#list

<!-- vim-markdown-toc GFM -->

- [简介](#简介)
- [函数列表](#函数列表)

<!-- vim-markdown-toc -->

## 简介

`data#list` 函数提供了一些操作列表的工具方法，以下为使用这一函数的示例：

```vim
let s:LIST = SpaceVim#api#import('data#list')
let l = [1, 2, 3, 4]
echo s:LIST.pop(l)
" 4
echo l
" [1, 2, 3]
```

## 函数列表

- `pop(list)`: 移除并返回列表的最后一个元素。
- `push(list, var)`: 向列表最后添加一个元素并返回列表。
- `shift(list)`: 移除并返回列表的第一个元素。
- `unshift(list, var)`: 向列表最前端添加一个元素，并返回列表。
- `uniq(list)`: 去除列表中重复的元素，并返回去重后的列表。
- `char_range(char1, char2)`: 返回一个字符列表，从字符`char1`到`char2`。
- `has(list, var)`: 检测列表`list`内是否包含元素`var`，若包含则返回`v:true`，否则返回`v:false`。
- `replace(list, begin, end, new_list)`: 替换列表`list`中从位置`begin`至`end`为新的列表`new_list`。

  示例代码如下：
  ```vim
  let l = ['a', 'b', 'c', 'd', 'e']
  echo s:LIST.replace(l, 1, 3, [1, 2, 3])
  " ['a', 1, 2, 3, 'e']
  ```
