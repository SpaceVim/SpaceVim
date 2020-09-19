# deoplete-dictionary
deoplete source for dictionary

## Description
This source collects "keyword_patterns" keywords from 'dictionary'.

Note: It uses buffer-local 'dictionary' set up.

Note: It also supports directory.

rank: 100

## Configuration examples

```vim
" Sample configuration for dictionary source with multiple
" dictionary files.
setlocal dictionary+=/usr/share/dict/words
setlocal dictionary+=/usr/share/dict/american-english
" Remove this if you'd like to use fuzzy search
call deoplete#custom#source(
\ 'dictionary', 'matchers', ['matcher_head'])
" If dictionary is already sorted, no need to sort it again.
call deoplete#custom#source(
\ 'dictionary', 'sorters', [])
" Do not complete too short words
call deoplete#custom#source(
\ 'dictionary', 'min_pattern_length', 4)
```
