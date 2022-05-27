function! s:systemlist(cmd) abort
    let cmd = ''
    let quote = &shellxquote == '"' ?  "'" : '"'
    if type(a:cmd) == type([]) && !has('nvim')
        for argv in a:cmd
            if type(argv) == 4
                let cmd .= quote .  substitute(json_encode(argv), '"', '"""', 'g') . quote . ' '
            else
                let cmd .= quote . substitute(argv, '"', '"""', 'g') . quote . ' '
            endif
        endfor
    else
        let cmd = a:cmd
    endif
    call github#api#util#log('systemlist cmd : ' . string(cmd))
    let result = systemlist(cmd)
    if !empty(v:shell_error) && g:githubapi_verbose == 1
        echom cmd
        echom v:shell_error
        echom string(result)
    endif
    return result
endfunction

function! github#api#util#Get(url,args) abort
    let cmd = [g:githubapi_curl_exe, '-s', s:geturl(a:url)]
    if len(a:args) > 0
        call extend(cmd, a:args)
    endif
    call github#api#util#log('util#Get cmd : ' . string(cmd))
    let result = join(s:systemlist(cmd),"\n")
    return empty(result) ? result : json_decode(result)
endfunction

let s:wrapper = {
            \ 'result' : '',
            \ 'callback' : '',
            \ }

function! s:wrapper.on_stdout(id, data, event) abort
    let self.result .= join(a:data, "\n")
endfunction

function! s:wrapper.on_exit(id, data, event) abort
    if a:data == 0 && a:event ==# 'exit'
        if !empty(self.result)
            call call(self.callback, [json_decode(self.result)])
        endif
    endif
endfunction


" async get issue list, the func accept one argv issue_list
function! github#api#util#async_get(url, args, func) abort
    let cmd = ['curl', '-s', s:geturl(a:url)]
    if len(a:args) > 0
        call extend(cmd, a:args)
    endif
    let opt = deepcopy(s:wrapper)
    let opt.callback = a:func
    call jobstart(cmd, opt)
endfunction

function! github#api#util#GetLastPage(url) abort
    let cmd = ['curl', '-si', s:geturl(a:url)]
    call github#api#util#log('util#GetLastPage cmd : ' . string(cmd))
    let result = filter(copy(s:systemlist(cmd)), "v:val =~# '^Link'")
    let page = 1
    if len(result) > 0
        let line = result[0]
        if !empty(line) && !empty(matchstr(line, 'rel="last"'))
            call github#api#util#log(line)
            let page = split(matchstr(line,'page=\d\+',0,2),'=')[1]
            call github#api#util#log(page)
            return page
        endif
    else
        return page
    endif
endfunction

function! github#api#util#GetStatus(url,opt) abort
    let cmd = ['curl', '-is', s:geturl(a:url)]
    if len(a:opt) > 0
        call extend(cmd, a:opt)
    endif
    call github#api#util#log('util#GetStatus cmd : ' . string(cmd))
    let result = filter(copy(s:systemlist(cmd)), "v:val =~# '^Status:'")
    return matchstr(result[0],'\d\+')
endfunction

""
" @public
" Get current time in a timestamp in ISO 8601 format: YYYY-MM-DDTHH:MM:SSZ
function! github#api#util#Get_current_time() abort
    return strftime('%Y-%m-%dT%TZ')
endfunction

let s:log = []
function! github#api#util#log(log) abort
    call add(s:log, a:log)
endfunction

""
" @public
" view the log of API
function! github#api#util#GetLog() abort
    return join(s:log, "\n")
endfunction

""
" @public
"
" Clean up the log of the API
function! github#api#util#CleanLog() abort
    let s:log = []
    echon "Github-api.vim's log has beed cleaned up!"
endfunction

function! github#api#util#parserArgs(base,name,var,values,default) abort
    if empty(a:default) && index(a:values, a:var) == -1
        return a:base
    endif
    let url = a:base . (stridx(a:base, '?') ==# -1 ? '?' : '&')
    if index(a:values, a:var) == -1
        let url .= a:name . '=' . a:default
    else
        let url .= a:name . '=' . a:var
    endif
    return url
endfunction

function! s:geturl(url) abort
    let s:clientid = $CLIENTID
    let s:clientsecret = $CLIENTSECRET
    if !empty(s:clientid) && !empty(s:clientsecret)
        let url = a:url
        if stridx(a:url, '?') != -1
            let url .= '&client_id=' . s:clientid . '&client_secret=' . s:clientsecret
        else
            let url .= '?client_id=' . s:clientid . '&client_secret=' . s:clientsecret
        endif
        return g:githubapi_root_url . url
    else
        return g:githubapi_root_url . a:url
    endif
endfunction
