" =============================================================================
" Filename: autoload/calendar/message.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:30:41.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Getting the message based on the locale setting.
" The message files are found in message/.
function! calendar#message#get(type) abort
  let locale = calendar#setting#get('locale')
  try
    let message = calendar#message#{locale}#get()
  catch
    if len(locale) > 1
      try
        let message = calendar#message#{locale[:1]}#get()
      catch
        let message = calendar#message#default#get()
      endtry
    else
      let message = calendar#message#default#get()
    endif
  finally
    if has_key(message, a:type)
      return message[a:type]
    else
      let message = calendar#message#default#get()
      if has_key(message, a:type)
        return message[a:type]
      else
        let message = calendar#message#en#get()
        return message[a:type]
      endif
    endif
  endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
