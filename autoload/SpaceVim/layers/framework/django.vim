"=============================================================================
" django.vim --- django project support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section framework#django, layers-framework-django
" @parentsection layers
" The `framework#django` layer provides code completion and syntax highlight for django.
" This layer is not enabled by default, to enable it:
" >
"   [[layers]]
"     name = 'framework#django'
" <
"

function! SpaceVim#layers#framework#django#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/django-plus.vim', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#framework#django#health() abort
  call SpaceVim#layers#framework#django#plugins()
  return 1
endfunction

" @todo add code formatter and linter for htmldjango
" https://code.djangoproject.com/wiki/UsingVimWithDjango
" https://github.com/yaegassy/coc-htmldjango
" https://github.com/rtts/djhtml
" https://github.com/Riverside-Healthcare/djlint
" https://stackoverflow.com/questions/42170561/vscode-html-autoformat-on-django-template
" https://www.reddit.com/r/django/comments/fnzrxv/is_there_an_autoformatter_plugin_for_vs_code_that/
