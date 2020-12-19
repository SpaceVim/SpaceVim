" MIT License. Copyright (c) 2013-2019 Bailey Ling, Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! airline#extensions#po#shorten()
  " Format and shorte the output of msgfmt
  let b:airline_po_stats = substitute(get(b:, 'airline_po_stats', ''), ' \(message\|translation\)s*\.*', '', 'g')
  let b:airline_po_stats = substitute(b:airline_po_stats, ', ', '/', 'g')
  if exists("g:airline#extensions#po#displayed_limit")
    let w:displayed_po_limit = g:airline#extensions#po#displayed_limit
    if len(b:airline_po_stats) > w:displayed_po_limit - 1
      let b:airline_po_stats = b:airline_po_stats[0:(w:displayed_po_limit - 2)].(&encoding==?'utf-8' ? '…' : '.'). ']'
    endif
  endif
  if strlen(get(b:, 'airline_po_stats', '')) >= 30 && airline#util#winwidth() < 150
    let fuzzy = ''
    let untranslated = ''
    let messages = ''
    " Shorten [120 translated, 50 fuzzy, 4 untranslated] to [120T/50F/4U]
    if b:airline_po_stats =~ 'fuzzy'
      let fuzzy = substitute(b:airline_po_stats, '.*\(\d\+\) fuzzy.*', '\1F', '')
      if fuzzy == '0F'
        let fuzzy = ''
      endif
    endif
    if b:airline_po_stats =~ 'untranslated'
      let untranslated = substitute(b:airline_po_stats, '.*\(\d\+\) untranslated.*', '\1U', '')
      if untranslated == '0U'
        let untranslated = ''
      endif
    endif
    let messages = substitute(b:airline_po_stats, '\(\d\+\) translated.*', '\1T', '')
    let b:airline_po_stats = printf('%s%s%s', fuzzy, (empty(fuzzy) || empty(untranslated) ? '' : '/'), untranslated)
    if strlen(b:airline_po_stats) < 8
      let b:airline_po_stats = messages. (!empty(b:airline_po_stats) ? '/':''). b:airline_po_stats
    endif
  endif
  let b:airline_po_stats = '['.b:airline_po_stats. ']'
endfunction

function! airline#extensions#po#on_winenter()
  " only reset cache, if the window size changed
  if get(b:, 'airline_winwidth', 0) != airline#util#winwidth()
    let b:airline_winwidth = airline#util#winwidth()
    " needs re-formatting
    unlet! b:airline_po_stats
  endif
endfunction

function! airline#extensions#po#apply(...)
  if &ft ==# 'po'
    call airline#extensions#prepend_to_section('z', '%{airline#extensions#po#stats()}')
    " Also reset the cache variable, if a window has been split, e.g. the winwidth changed
    autocmd airline BufWritePost * unlet! b:airline_po_stats
    autocmd airline WinEnter * call airline#extensions#po#on_winenter()
  endif
endfunction

function! airline#extensions#po#stats()
  if exists('b:airline_po_stats') && !empty(b:airline_po_stats)
    return b:airline_po_stats
  endif

  let cmd = 'msgfmt --statistics -o /dev/null -- '
  if g:airline#init#vim_async
    call airline#async#get_msgfmt_stat(cmd, expand('%:p'))
  elseif has("nvim")
    call airline#async#nvim_get_msgfmt_stat(cmd, expand('%:p'))
  else
    let airline_po_stats = system(cmd. shellescape(expand('%:p')))
    if v:shell_error
      return ''
    endif
    try
      let b:airline_po_stats = split(airline_po_stats, '\n')[0]
    catch
      let b:airline_po_stats = ''
    endtry
    call airline#extensions#po#shorten()
  endif
  return get(b:, 'airline_po_stats', '')
endfunction

function! airline#extensions#po#init(ext)
    call a:ext.add_statusline_func('airline#extensions#po#apply')
endfunction
