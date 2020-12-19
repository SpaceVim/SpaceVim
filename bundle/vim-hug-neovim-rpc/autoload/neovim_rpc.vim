
if has('pythonx')
    let g:neovim_rpc#py = 'pythonx'
    let s:pyeval = function('pyxeval')
elseif has('python3')
    let g:neovim_rpc#py = 'python3'
    let s:pyeval = function('py3eval')
else
    let g:neovim_rpc#py = 'python'
    let s:pyeval = function('pyeval')
endif

func! s:py(cmd)
    execute g:neovim_rpc#py a:cmd
endfunc

func! neovim_rpc#serveraddr()
    if exists('g:_neovim_rpc_nvim_server')
        return g:_neovim_rpc_nvim_server
    endif

    if &encoding !=? "utf-8"
        throw '[vim-hug-neovim-rpc] requires `:set encoding=utf-8`'
    endif

    try
        call s:py('import pynvim')
    catch
        try
            call s:py('import neovim')
        catch
            call neovim_rpc#_error("failed executing: " .
                        \ g:neovim_rpc#py . " import [pynvim|neovim]")
            call neovim_rpc#_error(v:exception)
            throw '[vim-hug-neovim-rpc] requires one of `:' . g:neovim_rpc#py .
                        \ ' import [pynvim|neovim]` command to work'
        endtry
    endtry

    call s:py('import neovim_rpc_server')
    let l:servers = s:pyeval('neovim_rpc_server.start()')

    let g:_neovim_rpc_nvim_server     = l:servers[0]
    let g:_neovim_rpc_vim_server = l:servers[1]

    let g:_neovim_rpc_main_channel = ch_open(g:_neovim_rpc_vim_server)

    " identify myself
    call ch_sendexpr(g:_neovim_rpc_main_channel,'neovim_rpc_setup')

    return g:_neovim_rpc_nvim_server
endfunc

" elegant python function call wrapper
func! neovim_rpc#pyxcall(func,...)
    call s:py('import vim, json')
    let g:neovim_rpc#_tmp_args = copy(a:000)
    let l:ret = s:pyeval(a:func . '(*vim.vars["neovim_rpc#_tmp_args"])')
    unlet g:neovim_rpc#_tmp_args
    return l:ret
endfunc

" supported opt keys:
" - on_stdout
" - on_stderr
" - on_exit
" - detach
func! neovim_rpc#jobstart(cmd,...)

    let l:opts = {}
    if len(a:000)
        let l:opts = a:1
    endif

    let l:opts['_close'] = 0
    let l:opts['_exit'] = 0

    let l:real_opts = {'mode': 'raw'}
    if has_key(l:opts,'detach') && l:opts['detach']
        let l:real_opts['stoponexit'] = ''
    endif

    if has_key(l:opts,'on_stdout')
        let l:real_opts['out_cb'] = function('neovim_rpc#_on_stdout')
    endif
    if has_key(l:opts,'on_stderr')
        let l:real_opts['err_cb'] = function('neovim_rpc#_on_stderr')
    endif
    let l:real_opts['exit_cb'] = function('neovim_rpc#_on_exit')
    let l:real_opts['close_cb'] = function('neovim_rpc#_on_close')

    let l:job   = job_start(a:cmd, l:real_opts)
    let l:jobid = ch_info(l:job)['id']

    let g:_neovim_rpc_jobs[l:jobid] = {'cmd':a:cmd, 'opts': l:opts, 'job': l:job}

    return l:jobid
endfunc

func! neovim_rpc#jobstop(jobid)
    let l:job = g:_neovim_rpc_jobs[a:jobid]['job']
    return job_stop(l:job)
endfunc

func! neovim_rpc#rpcnotify(channel,event,...)
    call neovim_rpc#pyxcall('neovim_rpc_server.rpcnotify',a:channel,a:event,a:000)
endfunc

let s:rspid = 1
func! neovim_rpc#rpcrequest(channel, event, ...)
    let s:rspid = s:rspid + 1

    " a unique key for storing response
    let rspid = '' . s:rspid

    " neovim's rpcrequest doesn't have timeout
    let opt = {'timeout': 24 * 60 * 60 * 1000}
    let args = ['rpcrequest', a:channel, a:event, a:000, rspid]
    call ch_evalexpr(g:_neovim_rpc_main_channel, args, opt)

    let expr = 'neovim_rpc_server.responses.pop("' . rspid . '")'

    call s:py('import neovim_rpc_server, json')
    let [err, result] = s:pyeval(expr)
    if err
        if type(err) == type('')
            throw err
        endif
        throw err[1]
    endif
    return result
endfunc

func! neovim_rpc#_on_stdout(job,data)
    let l:jobid = ch_info(a:job)['id']
    let l:opts = g:_neovim_rpc_jobs[l:jobid]['opts']
    " convert to neovim style function call
    call call(l:opts['on_stdout'],[l:jobid,split(a:data,"\n",1),'stdout'],l:opts)
endfunc

func! neovim_rpc#_on_stderr(job,data)
    let l:jobid = ch_info(a:job)['id']
    let l:opts = g:_neovim_rpc_jobs[l:jobid]['opts']
    " convert to neovim style function call
    call call(l:opts['on_stderr'],[l:jobid,split(a:data,"\n",1),'stderr'],l:opts)
endfunc

func! neovim_rpc#_on_exit(job,status)
    let l:jobid = ch_info(a:job)['id']
    let l:opts = g:_neovim_rpc_jobs[l:jobid]['opts']
    let l:opts['_exit'] = 1
    " cleanup when both close_cb and exit_cb is called
    if l:opts['_close'] && l:opts['_exit']
        unlet g:_neovim_rpc_jobs[l:jobid]
    endif
    if has_key(l:opts, 'on_exit')
        " convert to neovim style function call
        call call(l:opts['on_exit'],[l:jobid,a:status,'exit'],l:opts)
    endif
endfunc

func! neovim_rpc#_on_close(job)
    let l:jobid = ch_info(a:job)['id']
    let l:opts = g:_neovim_rpc_jobs[l:jobid]['opts']
    let l:opts['_close'] = 1
    " cleanup when both close_cb and exit_cb is called
    if l:opts['_close'] && l:opts['_exit']
        unlet g:_neovim_rpc_jobs[l:jobid]
    endif
endfunc

func! neovim_rpc#_callback()
    execute g:neovim_rpc#py . ' neovim_rpc_server.process_pending_requests()'
endfunc

let g:_neovim_rpc_main_channel = -1
let g:_neovim_rpc_jobs = {}

let s:leaving = 0

func! neovim_rpc#_error(msg)
    if mode() == 'i'
        " NOTE: side effect, sorry, but this is necessary
        set nosmd
    endif
    echohl ErrorMsg
    echom '[vim-hug-neovim-rpc] ' . a:msg
    echohl None
endfunc

func! neovim_rpc#_nvim_err_write(msg)
    if mode() == 'i'
        " NOTE: side effect, sorry, but this is necessary
        set nosmd
    endif
    echohl ErrorMsg
    let g:error = a:msg
    echom a:msg
    echohl None
endfunc

func! neovim_rpc#_nvim_out_write(msg)
    echom a:msg
endfunc
