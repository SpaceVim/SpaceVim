if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let s:id = 1
let s:reg = {}
let s:leaving = 0

augroup yarp
    autocmd!
    " this one is which you're most likely to use?
    autocmd VimLeavePre * let s:leaving = 1 
augroup end

if has('nvim')
    let s:rpcrequest = 'rpcrequest'
    let s:rpcnotify = 'rpcnotify'
    let s:jobstart = 'jobstart'
    fun! s:_serveraddr()
        return v:servername
    endfunc
    let s:serveraddr = function('s:_serveraddr')
else
    let s:rpcrequest = get(g:, 'yarp_rpcrequest', 'neovim_rpc#rpcrequest')
    let s:rpcnotify = get(g:, 'yarp_rpcnotify', 'neovim_rpc#rpcnotify')
    let s:jobstart = get(g:, 'yarp_jobstart', 'neovim_rpc#jobstart')
    let s:serveraddr = get(g:, 'yarp_serveraddr', 'neovim_rpc#serveraddr')
endif

func! yarp#core#new(rp)
    let s:id = s:id + 1

    let rp = a:rp
    let rp.jobstart = function('yarp#core#jobstart')
    func rp.error(msg) dict
        call yarp#core#error(self.module, a:msg)
    endfunc
    let rp.call = function('yarp#core#request')
    let rp.request = function('yarp#core#request')
    let rp.notify = function('yarp#core#notify')
    let rp.try_notify = function('yarp#core#try_notify')
    let rp.wait_channel = function('yarp#core#wait_channel')
    let rp.id = s:id
    let rp.job_is_dead = 0
    let s:reg[rp.id] = rp

    " options
    let rp.on_load = get(rp, 'on_load', function('yarp#core#_nop'))
    let rp.job_detach = get(rp, 'job_detach', 0)

    " reserved for user
    let rp.user_data = get(rp, 'user_data', {})
    return rp
endfunc

func! yarp#core#_nop(...) dict
endfunc

func! yarp#core#on_stderr(chan_id, data, event) dict
    let mod = self.self
    call mod.error(filter(a:data, 'len(v:val)'))
endfunc

func! yarp#core#on_exit(chan_id, data, event) dict
    let mod = self.self
    let mod.job_is_dead = 1
    if has_key(mod, 'channel')
        unlet mod.channel
    endif

    if has("nvim")
        if v:exiting is 0
            return
        endif
    elseif v:dying || s:leaving
        return
    endif
    call mod.error("Job is dead. cmd=" . string(mod.cmd))
endfunc

func! yarp#core#channel_started(id, channel)
    let rp = s:reg[a:id]
    let rp.channel = a:channel
    call call(rp.on_load, [], rp)
endfunc

func! yarp#core#request(method, ...) dict
    call self.wait_channel()
    return call(s:rpcrequest, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#notify(method, ...) dict
    call self.wait_channel()
    call call(s:rpcnotify, [self.channel, a:method] + a:000)
endfunc

func! yarp#core#try_notify(method, ...) dict
    call self.jobstart()
    if get(self, 'job_is_dead', 0)
        call self.error('try_notify ' . a:method . ' failed, job is dead')
        return 0
    endif
    if !has_key(self, 'channel')
        " not yet started
        return 0
    endif
    let args = [self.channel, a:method] + a:000
    try
        call call(s:rpcnotify, args)
        return 1
    catch
        call self.error('try_notify ' . s:rpcnotify . ' ' . a:method . ' failed: ' . v:exception . ', ' . string(args))
        return 0
    endtry
endfunc

func! yarp#core#wait_channel() dict
    if has_key(self, 'channel')
        return
    endif
    if ! has_key(self, 'job')
        call self.jobstart()
    endif
    if get(self, 'job', -1) == -1
        throw '[yarp] [' . self.module . '] job is not running'
    endif
    let cnt = 5000 / 20
    while ! has_key(self, 'channel')
        if self.job_is_dead
            throw '[yarp] [' . self.module .
                    \ '] job is dead. failed establishing channel for ' .
                    \ string(self.cmd)
        endif
        if cnt <= 0
            throw '[yarp] [' . self.module . '] timeout establishing channel for ' . string(self.cmd)
        endif
        let cnt = cnt - 1
        silent sleep 20m
    endwhile
endfunc

func! yarp#core#jobstart() dict
    if ! has_key(self, 'cmd')
        call self.init()
        if ! has_key(self, 'cmd')
            call self.error("cmd of the job is not set")
            return
        endif
    endif
    if has_key(self, 'job')
        return
    endif
    let opts = {'on_stderr': function('yarp#core#on_stderr'),
            \ 'on_exit': function('yarp#core#on_exit'),
            \ 'detach': self.job_detach,
            \ 'self': self}
    try
        let self.job = call(s:jobstart, [self.cmd, opts])
        if self.job == -1
            call self.error('Failed starting job: ' . string(self.cmd))
        endif
    catch
        let self.job = -1
        call self.error(['Failed starting job: ' . string(self.cmd), v:exception])
    endtry
endfunc

func! yarp#core#serveraddr()
    return call (s:serveraddr, [])
endfunc

func! yarp#core#error(mod, msg)
    if mode() == 'i'
        " NOTE: side effect, sorry, but this is necessary
        set nosmd
    endif
    if type(a:msg) == type("")
        let lines = split(a:msg, "\n", 1)
    else
        let lines = a:msg
    endif
    echoh ErrorMsg
    for line in lines
        echom '[' . a:mod . '@yarp] ' . line
    endfor
    echoh None
endfunc
