#! /usr/bin/env python3
# -*- coding: utf-8 -*-
#======================================================================
#
# leaderf_snippet.py - 
#
# Created by skywind on 2021/02/01
# Last Modified: 2021/02/01 17:48:09
#
#======================================================================
from __future__ import unicode_literals, print_function
import sys
import time
import re
import vim


def init():
    # print('init2')
    return 0


def usnip_query():
    source = []
    vim.eval('UltiSnips#SnippetsInCurrentScope()')
    items = vim.eval('items(g:current_ulti_dict_info)')
    from UltiSnips import UltiSnips_Manager
    import UltiSnips
    manager = UltiSnips.UltiSnips_Manager
    snippets = UltiSnips.UltiSnips_Manager._snips('', True)
    snippets_values = {}
    for snippet in snippets:
        key = snippet.trigger
        desc = snippet._description
        snippets_values[key] = snippet._value
    size = 4
    for item in items:
        key = item[0]
        info = item[1]
        desc = info.get('description', '')
        value = snippets_values.get(key, '<unknow>')
        desc = desc.strip()
        size = max(size, len(key))
        if not desc:
            desc = usnip_simplify(value)
            # desc = ''
        source.append([key, desc, '', usnip_clear(value)])
    source.sort()
    for item in source:
        item[2] = item[0] + (' ' * (size - len(item[0])))
    return source

def usnip_clear(text):
    t = re.sub('`[^`]*`', '', text)
    if t.strip() == '':
        t = text
    return t

def usnip_simplify(text):
    t = re.sub('`[^`]*`', '', text)
    if t.strip() == '':
        t = text
    text = '\n'.join(t.split("\n")[:5])
    text = re.sub('\${[^{}]*}', '...', text)
    text = re.sub('\${[^{}]*}', '...', text)
    text = text.replace("\n", ' ; ')
    text = re.sub('\s+', ' ', text)
    return text[:100]

def usnip_digest(text):
    return 0

def test():
    source = usnip_query()
    for item in source:
        key = item[0]
        if key == 'def' or 0:
            value = item[3]
            print(key, value)
            print('---')
            print(usnip_clear(value))
            print('---')
            print(usnip_simplify(value))
    return 0


