if exists('b:did_django_ftplugin') || !exists('b:is_django')
  finish
endif
let b:did_django_ftplugin = 1
let b:orig_omnifunc = &l:omnifunc
if !has('python') && b:orig_omnifunc ==# 'pythoncomplete#Complete'
  let b:orig_omnifunc = ''
endif

setlocal omnifunc=djangoplus#complete


if exists(':UltiSnipsAddFiletypes')
  " Add Django snippets
  UltiSnipsAddFiletypes django
endif


if exists(':ImpSort')
  function! s:django_sort(a, b) abort
    return impsort#sort_top('^django', a:a, a:b)
  endfunction

  if get(g:, 'django_impsort_top', 1)
    let b:impsort_method_prefix = [function('s:django_sort')]
          \ + get(g:, 'impsort_method_imports', ['alpha', 'length'])
    let b:impsort_method_group = [function('s:django_sort')]
          \ + get(g:, 'impsort_method_group', ['length', 'alpha'])
    let b:impsort_method_module = [function('s:django_sort')]
          \ + get(g:, 'impsort_method_module', ['depth', 'length', 'alpha'])
  endif
endif
