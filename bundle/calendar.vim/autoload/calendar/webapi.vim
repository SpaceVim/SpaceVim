" =============================================================================
" Filename: autoload/calendar/webapi.vim
" Author: itchyny
" License: MIT License
" Last Change: 2019/12/03 12:48:49.
" =============================================================================

" Web interface.
" Most part of this file was copied from webapi-vim and vital.vim.
" Thank you Yasuhiro Matsumoto, for distributing useful scripts under public
" domain.

" Maintainer and License of the original script {{{
" Last Change: 2010-09-10
" Maintainer:   Yasuhiro Matsumoto <mattn.jp@gmail.com>
" License:      This file is placed in the public domain.
" }}}

let s:save_cpo = &cpo
set cpo&vim

let s:cache = calendar#cache#new('download')
call s:cache.check_dir(1)
if !calendar#setting#get('debug')
  call s:cache.rmdir_on_exit()
endif

function! s:nr2byte(nr) abort
  if a:nr < 0x80
    return nr2char(a:nr)
  elseif a:nr < 0x800
    return nr2char(a:nr/64+192).nr2char(a:nr%64+128)
  elseif a:nr < 0x10000
    return nr2char(a:nr/4096%16+224).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  elseif a:nr < 0x200000
    return nr2char(a:nr/262144%16+240).nr2char(a:nr/4096/16+128).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  elseif a:nr < 0x4000000
    return nr2char(a:nr/16777216%16+248).nr2char(a:nr/262144%16+128).nr2char(a:nr/4096/16+128).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  else
    return nr2char(a:nr/1073741824%16+252).nr2char(a:nr/16777216%16+128).nr2char(a:nr/262144%16+128).nr2char(a:nr/4096/16+128).nr2char(a:nr/64%64+128).nr2char(a:nr%64+128)
  endif
endfunction

function! s:nr2enc_char(charcode) abort
  if &encoding == 'utf-8'
    return nr2char(a:charcode)
  endif
  let char = s:nr2byte(a:charcode)
  if strlen(char) > 1
    let char = strtrans(iconv(char, 'utf-8', &encoding))
  endif
  return char
endfunction

function! calendar#webapi#get(url, ...) abort
  return s:request(1, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'GET'))
endfunction

function! calendar#webapi#post(url, ...) abort
  return s:request(1, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'POST'))
endfunction

function! calendar#webapi#delete(url, ...) abort
  return s:request(1, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'DELETE'))
endfunction

function! calendar#webapi#patch(url, ...) abort
  return s:request(1, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'PATCH'))
endfunction

function! calendar#webapi#put(url, ...) abort
  return s:request(1, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'PUT'))
endfunction

function! calendar#webapi#post_nojson(url, ...) abort
  return s:request(0, {}, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'POST'))
endfunction

function! calendar#webapi#get_async(id, cb, url, ...) abort
  return s:request(1, { 'id': a:id, 'cb': a:cb } , a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'GET'))
endfunction

function! calendar#webapi#post_async(id, cb, url, ...) abort
  return s:request(1, { 'id': a:id, 'cb': a:cb }, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'POST'))
endfunction

function! calendar#webapi#delete_async(id, cb, url, ...) abort
  return s:request(1, { 'id': a:id, 'cb': a:cb }, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'DELETE'))
endfunction

function! calendar#webapi#patch_async(id, cb, url, ...) abort
  return s:request(1, { 'id': a:id, 'cb': a:cb }, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'PATCH'))
endfunction

function! calendar#webapi#put_async(id, cb, url, ...) abort
  return s:request(1, { 'id': a:id, 'cb': a:cb }, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'PUT'))
endfunction

function! calendar#webapi#post_nojson_async(id, cb, url, ...) abort
  return s:request(0, { 'id': a:id, 'cb': a:cb }, a:url, get(a:000, 0, {}), get(a:000, 1, {}), get(a:000, 2, 'POST'))
endfunction

function! s:request(json, async, url, param, postdata, method) abort
  let url = a:url
  let paramstr = calendar#webapi#encodeURI(a:param)
  let withbody = a:method !=# 'GET' && a:method !=# 'DELETE'
  let header = {}
  if paramstr !=# ''
    let url .= '?' . paramstr
  endif
  let postfile = ''
  if withbody
    let postdatastr = a:json ? calendar#webapi#encode(a:postdata) : join(s:postdata(a:postdata), "\n")
    let postfile = tempname()
    call writefile(split(postdatastr, "\n"), postfile, 'b')
    let header['Content-Length'] = len(postdatastr)
    if a:json
      let header['Content-Type'] = 'application/json'
    endif
  endif
  let command = s:command(url, a:method, header, postfile, a:async == {} ? '' : s:cache.path(a:async.id))
  if type(command) != type('')
    return { 'status': '0', 'message': '', 'header': '', 'content': '' }
  endif
  call s:cache.check_dir(1)
  if a:async == {}
    let data = calendar#util#system(command)
    let response = calendar#webapi#parse(split(data, "\n"))
    if withbody
      call delete(postfile)
    endif
    return response
  else
    if !calendar#setting#get('debug')
      call s:cache.delete(a:async.id)
    endif
    call calendar#async#new('calendar#webapi#callback(' . string(a:async.id) . ',' . string(a:async.cb) . ')')
    if has('win32')
      call calendar#util#system('cmd /c start /min ' . command)
    else
      let command .= ' &'
      call calendar#util#system(command)
    endif
  endif
endfunction

function! s:command(url, method, header, postfile, output) abort
  let quote = s:_quote()
  if executable('curl')
    let command = 'curl --http1.1 --suppress-connect-headers -s -k -i -N -X ' . a:method
    let command .= s:make_header_args(a:header, '-H ', quote)
    if a:postfile !=# ''
      let command .= ' --data-binary @' . quote . a:postfile . quote
    endif
    if a:output !=# ''
      let command .= ' -o ' . quote . a:output . quote
    endif
    let command .= ' ' . quote . a:url . quote
    return command
  elseif executable('wget')
    let command = 'wget -O- --server-response -q'
    let a:header['X-HTTP-Method-Override'] = a:method
    let command .= s:make_header_args(a:header, '--header=', quote)
    if a:postfile !=# ''
      let command .= ' --post-file=' . quote . a:postfile . quote
    else
      let command .= ' --method=' . a:method
    endif
    let command .= ' ' . quote . a:url . quote
    if a:output !=# ''
      let command .= ' > ' . quote . a:output . quote . ' 2>&1'
    endif
    return command
  else
    call calendar#echo#error_message('curl_wget_not_found')
    return 1
  endif
endfunction

let s:callback_datalen = {}
function! calendar#webapi#callback(id, cb) abort
  let data = s:cache.get_raw(a:id)
  if type(data) != type([])
    return 1
  endif
  let prevdatalen = get(s:callback_datalen, a:id)
  let s:callback_datalen[a:id] = len(data)
  if len(data) == 0 || len(data) != prevdatalen
    return 1
  endif
  let response = calendar#webapi#parse(data)
  if empty(response)
    return 1
  elseif a:cb !=# ''
    call call(a:cb, [a:id, response])
  endif
  if !calendar#setting#get('debug')
    call s:cache.delete(a:id)
  endif
  unlet s:callback_datalen[a:id]
  return 0
endfunction

function! calendar#webapi#parse(data) abort
  if len(a:data) == 0
    return { 'status': '0', 'message': '', 'header': '', 'content': '' }
  endif
  let i = 0
  while i < len(a:data) && a:data[i] =~# '^  ' " for wget
    let a:data[i] = a:data[i][2:]
    let i += 1
  endwhile
  if i > 0
    call insert(a:data, '', i)
    let i = 0
  endif
  while i < len(a:data) && (a:data[i] =~# '\v^HTTP/[12]%(\.\d)? 3' ||
        \ (i + 2 < len(a:data) && a:data[i] =~# '\v^HTTP/1\.\d \d{3}' &&
        \ a:data[i + 1] =~# '\v^\r?$' && a:data[i + 2] =~# '\v^HTTP/1\.\d \d{3}'))
    while i < len(a:data) && a:data[i] !~# '\v^\r?$'
      let i += 1
    endwhile
    let i += 1
  endwhile
  while i < len(a:data) && a:data[i] !~# '\v^\r?$'
    let i += 1
  endwhile
  let header = a:data[:i]
  let content = join(a:data[(i):], "\n")
  let matched = matchlist(get(header, 0, ''), '\v^HTTP/[12]%(\.\d)?\s+(\d+)\s*(.*)')
  if !empty(matched)
    let [status, message] = matched[1 : 2]
    call remove(header, 0)
  else
    let [status, message] = ['200', 'OK']
  endif
  return { 'status': status, 'message': message, 'header': header, 'content': content }
endfunction

function! calendar#webapi#null() abort
  return 0
endfunction

function! calendar#webapi#true() abort
  return 1
endfunction

function! calendar#webapi#false() abort
  return 0
endfunction

function! calendar#webapi#encode(val) abort
  if type(a:val) == 0
    return a:val
  elseif type(a:val) == 1
    let json = '"' . escape(a:val, '\"') . '"'
    let json = substitute(json, "\r", '\\r', 'g')
    let json = substitute(json, "\n", '\\n', 'g')
    let json = substitute(json, "\t", '\\t', 'g')
    let json = substitute(json, '\([[:cntrl:]]\)', '\=printf("\x%02d", char2nr(submatch(1)))', 'g')
    return iconv(json, &encoding, 'utf-8')
  elseif type(a:val) == 2
    let s = string(a:val)
    if s == "function('calendar#webapi#null')"
      return 'null'
    elseif s == "function('calendar#webapi#true')"
      return 'true'
    elseif s == "function('calendar#webapi#false')"
      return 'false'
    endif
  elseif type(a:val) == 3
    return '[' . join(map(copy(a:val), 'calendar#webapi#encode(v:val)'), ',') . ']'
  elseif type(a:val) == 4
    return '{' . join(map(keys(a:val), 'calendar#webapi#encode(v:val).":".calendar#webapi#encode(a:val[v:val])'), ',') . '}'
  else
    return string(a:val)
  endif
endfunction

function! calendar#webapi#decode(json) abort
  let json = iconv(a:json, 'utf-8', &encoding)
  let json = substitute(json, '[\r\n]', '', 'g')
  let json = substitute(json, '\\x22\|\\u0022', '\\"', 'g')
  if v:version > 703 || v:version == 703 && has('patch780')
    let json = substitute(json, '\\u\(\x\x\x\x\)', '\=iconv(nr2char(str2nr(submatch(1), 16), 1), "utf-8", &encoding)', 'g')
  else
    let json = substitute(json, '\\u\(\x\x\x\x\)', '\=s:nr2enc_char("0x".submatch(1))', 'g')
  endif
  let [null,true,false] = [0,1,0]
  try
    sandbox let ret = eval(json)
  catch
    let ret = {}
  endtry
  return ret
endfunction

function! calendar#webapi#open_url(url) abort
  if has('win32')
    silent! call calendar#util#system('cmd /c start "" "' . a:url . '"')
  elseif executable('xdg-open')
    silent! call calendar#util#system('xdg-open "' . a:url . '" &')
  elseif executable('open')
    silent! call calendar#util#system('open "' . a:url . '" &')
  endif
endfunction

function! calendar#webapi#echo_error(response) abort
  let message = get(a:response, 'message', '')
  if has_key(a:response, 'content')
    let cnt = calendar#webapi#decode(a:response.content)
    if type(cnt) == type({}) && len(get(get(cnt, 'error', {}), 'message', ''))
      let message = get(get(cnt, 'error', {}), 'message', '')
    endif
  endif
  if message !=# ''
    call calendar#echo#error(message)
  endif
endfunction

function! s:make_header_args(headdata, option, quote) abort
  let args = ''
  for key in keys(a:headdata)
    unlet! value
    let value = type(a:headdata[key]) == type('') || type(a:headdata[key]) == type(0) ? a:headdata[key] :
          \     type(a:headdata[key]) == type({}) ? '' :
          \     type(a:headdata[key]) == type([]) ? '[' . join(map(a:headdata[key], 's:make_header_args(v:val, a:option, a:quote)'), ',') . ']' : ''
    if has('win32')
      let value = substitute(value, '"', '"""', 'g')
    endif
    let args .= ' ' . a:option . a:quote . key . ': ' . value . a:quote
  endfor
  return args
endfunction

function! s:decodeURI(str) abort
  let ret = a:str
  let ret = substitute(ret, '+', ' ', 'g')
  let ret = substitute(ret, '%\(\x\x\)', '\=printf("%c", str2nr(submatch(1), 16))', 'g')
  return ret
endfunction

function! s:escape(str) abort
  return substitute(a:str, '[^a-zA-Z0-9_.-]', '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
endfunction

function! calendar#webapi#encodeURI(items) abort
  let ret = ''
  if type(a:items) == type({})
    for key in sort(keys(a:items))
      if ret !=# ''
        let ret .= '&'
      endif
      let ret .= key . '=' . calendar#webapi#encodeURI(a:items[key])
    endfor
  elseif type(a:items) == type([])
    for item in sort(a:items)
      if ret !=# ''
        let ret .= '&'
      endif
      let ret .= item
    endfor
  else
    let ret = s:escape(a:items)
  endif
  return ret
endfunction

function! s:postdata(data) abort
  if type(a:data) == type({})
    return [calendar#webapi#encodeURI(a:data)]
  elseif type(a:data) == type([])
    return a:data
  else
    return split(a:data, "\n")
  endif
endfunction

function! s:_quote() abort
  return &shellxquote == '"' ?  "'" : '"'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
