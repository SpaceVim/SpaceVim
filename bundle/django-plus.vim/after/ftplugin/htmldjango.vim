if exists('b:did_django_ftplugin') || !exists('b:is_django')
  finish
endif

let b:did_django_ftplugin = 1

let b:orig_omnifunc = &l:omnifunc
setlocal omnifunc=djangoplus#complete

if exists(':UltiSnipsEdit')
  " Add HTML snippets
  UltiSnipsAddFiletypes html
endif


if exists('loaded_matchit')
  let b:match_ignorecase = 1
  let b:match_skip = 's:Comment'
  let b:match_words = '<:>,' .
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
        \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,'  .
        \ '{% *if .*%}:{% *else *%}:{% *endif *%},' .
        \ '\%({% *\)\@<=\%(end\)\@!\(\i\+\) .*%}:\%({% *\)\@<=end\1 .*%}'
endif


autocmd BufWritePost <buffer> call djangoplus#scan_template_tags()
call djangoplus#scan_template_tags()
