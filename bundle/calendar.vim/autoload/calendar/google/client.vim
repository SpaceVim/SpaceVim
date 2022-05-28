" =============================================================================
" Filename: autoload/calendar/google/client.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/11/30 20:02:44.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:cache = calendar#cache#new('google')

let s:auth_url = 'https://accounts.google.com/o/oauth2/auth'

let s:token_url = 'https://accounts.google.com/o/oauth2/token'

function! s:client() abort
  return extend(deepcopy(calendar#setting#get('google_client')), { 'response_type': 'code' })
endfunction

function! s:get_url() abort
  let client = s:client()
  let param = {}
  for x in ['client_id', 'redirect_uri', 'scope', 'response_type']
    if has_key(client, x)
      let param[x] = client[x]
    endif
  endfor
  return s:auth_url . '?' . calendar#webapi#encodeURI(param)
endfunction

function! calendar#google#client#access_token() abort
  let cache = s:cache.get('access_token')
  if type(cache) != type({}) || type(cache) == type({}) && !has_key(cache, 'access_token')
    call calendar#google#client#initialize_access_token()
    let cache = s:cache.get('access_token')
    if type(cache) != type({}) || type(cache) == type({}) && !has_key(cache, 'access_token')
      return 1
    endif
    let content = cache
  else
    let content = cache
  endif
  return content.access_token
endfunction

function! calendar#google#client#initialize_access_token() abort
  let client = s:client()
  let url = s:get_url()
  call calendar#webapi#open_url(url)
  try
    let code = input(printf(calendar#message#get('access_url_input_code'), url) . "\n" . calendar#message#get('input_code'))
  catch
    return
  endtry
  if code !=# ''
    let response = calendar#webapi#post_nojson(s:token_url, {}, {
          \ 'client_id': client.client_id,
          \ 'client_secret': client.client_secret,
          \ 'code': code,
          \ 'redirect_uri': client.redirect_uri,
          \ 'grant_type': 'authorization_code'})
    let content = calendar#webapi#decode(response.content)
    if calendar#google#client#access_token_response(response, content)
      return
    endif
  else
    return
  endif
  let g:calendar_google_event_downloading_list = 0
  let g:calendar_google_event_download = 3
  silent! let b:calendar.event._updated = 3
endfunction

function! calendar#google#client#refresh_token() abort
  let client = s:client()
  let cache = s:cache.get('refresh_token')
  if type(cache) == type({}) && has_key(cache, 'refresh_token') && type(cache.refresh_token) == type('')
    let response = calendar#webapi#post_nojson(s:token_url, {}, {
          \ 'client_id': client.client_id,
          \ 'client_secret': client.client_secret,
          \ 'refresh_token': cache.refresh_token,
          \ 'grant_type': 'refresh_token'})
    let content = calendar#webapi#decode(response.content)
    if calendar#google#client#access_token_response(response, content)
      return 1
    endif
    return content.access_token
  else
    return 1
  endif
endfunction

function! calendar#google#client#access_token_response(response, content) abort
  if a:response.status == 200
    if !has_key(a:content, 'access_token')
      call calendar#echo#error_message('google_access_token_fail')
      return 1
    else
      call s:cache.save('access_token', a:content)
      if has_key(a:content, 'refresh_token') && type(a:content.refresh_token) == type('')
        call s:cache.save('refresh_token', { 'refresh_token': a:content.refresh_token })
      endif
    endif
  else
    call calendar#echo#error_message('google_access_token_fail')
    return 1
  endif
endfunction

function! calendar#google#client#get(url, ...) abort
  return s:request('get', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#put(url, ...) abort
  return s:request('put', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#post(url, ...) abort
  return s:request('post', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#delete(url, ...) abort
  return s:request('delete', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! s:request(method, url, param, body) abort
  let client = s:client()
  let access_token = calendar#google#client#access_token()
  if type(access_token) != type('')
    return 1
  endif
  let param = extend(a:param, { 'oauth_token': access_token })
  let response = calendar#webapi#{a:method}(a:url, param, a:body)
  if response.status == 200
    return calendar#webapi#decode(response.content)
  elseif response.status == 401
    unlet! access_token
    let access_token = calendar#google#client#refresh_token()
    if type(access_token) != type('')
      return 1
    endif
    let param = extend(a:param, { 'oauth_token': access_token })
    let response = calendar#webapi#{a:method}(a:url, param, a:body)
    if response.status == 200
      return calendar#webapi#decode(response.content)
    endif
  endif
  return 1
endfunction

function! calendar#google#client#get_async(id, cb, url, ...) abort
  call s:request_async(a:id, a:cb, 'get', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#delete_async(id, cb, url, ...) abort
  call s:request_async(a:id, a:cb, 'delete', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#put_async(id, cb, url, ...) abort
  call s:request_async(a:id, a:cb, 'put', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#patch_async(id, cb, url, ...) abort
  call s:request_async(a:id, a:cb, 'patch', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#post_async(id, cb, url, ...) abort
  call s:request_async(a:id, a:cb, 'post', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! s:request_async(id, cb, method, url, param, body) abort
  let access_token = calendar#google#client#access_token()
  if type(access_token) != type('')
    return 1
  endif
  let param = extend(a:param, { 'oauth_token': access_token })
  call calendar#webapi#{a:method}_async(a:id, a:cb, a:url, param, a:body)
endfunction

function! calendar#google#client#get_async_use_api_key(id, cb, url, ...) abort
  call s:request_async_use_api_key(a:id, a:cb, 'get', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! calendar#google#client#post_async_use_api_key(id, cb, url, ...) abort
  call s:request_async_use_api_key(a:id, a:cb, 'post', a:url, a:0 ? a:1 : {}, a:0 > 1 ? a:2 : {})
endfunction

function! s:request_async_use_api_key(id, cb, method, url, param, body) abort
  let client = s:client()
  let param = extend(a:param, { 'key': client.api_key })
  call calendar#webapi#{a:method}_async(a:id, a:cb, a:url, param, a:body)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
