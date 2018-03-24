let g:ref_source_webdict_sites = {
      \   'je': {
      \     'url': 'http://dictionary.infoseek.ne.jp/jeword/%s',
      \   },
      \   'ej': {
      \     'url': 'http://dictionary.infoseek.ne.jp/ejword/%s',
      \   },
      \   'wiki': {
      \     'url': 'http://ja.wikipedia.org/wiki/%s',
      \   },
      \   'cn': {
      \     'url': 'http://www.iciba.com/%s',
      \   },
      \   'wikipedia:en':{'url': 'http://en.wikipedia.org/wiki/%s',  },
      \   'bing':{'url': 'http://cn.bing.com/search?q=%s', },
      \ }
let g:ref_source_webdict_sites.default = 'cn'
"let g:ref_source_webdict_cmd='lynx -dump -nonumbers %s'
"let g:ref_source_webdict_cmd='w3m -dump %s'
"The filter on the output. Remove the first few lines
function! g:ref_source_webdict_sites.je.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.ej.filter(output)
  return join(split(a:output, "\n")[15 :], "\n")
endfunction
function! g:ref_source_webdict_sites.wiki.filter(output)
  return join(split(a:output, "\n")[17 :], "\n")
endfunction

" vim:set et sw=2:
