if exists('b:current_syntax')
  finish
endif

syntax match GinaEventsPrefix /^[^:]\+/
syntax match GinaEventsTime /\d\{2}:\d\{2}:\d\{2}\.\d\{6}/
syntax match GinaEventsComment /^| .*$/
syntax match GinaEventsComment /<.\{-}>$/

function! s:define_highlights() abort
  highlight default link GinaEventsComment Comment
  highlight default link GinaEventsPrefix  Statement
  highlight default link GinaEventsTime    Title
endfunction

augroup gina_syntax__events_internal
  autocmd! *
  autocmd ColorScheme * call s:define_highlights()
augroup END

call s:define_highlights()

let b:current_syntax = 'gina-_events'
