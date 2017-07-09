function! SpaceVim#api#job#get() abort
    return deepcopy(s:self)
endfunction

" make vim and neovim use same job func.
let s:self = {}
let s:self.jobs = {}
let s:self.nvim_job = has('nvim')
let s:self.vim_job = !has('nvim') && has('job') && has('patch-8.0.0027')
let s:self.vim_co = SpaceVim#api#import('vim#compatible')

function! s:self.warn(...) abort
    if len(a:000) == 0
        echohl WarningMsg | echom 'Current version do not support job feature, fallback to sync system()' | echohl None
    elseif len(a:000) == 1 && type(a:1) == type('')
        echohl WarningMsg | echom a:1| echohl None
    else
    endif
endfunction
function! s:self.warp(argv, opts) abort
    let obj = {}
    let obj._argv = a:argv
    let obj._opts = a:opts
    let obj.in_io = get(a:opts, 'in_io', 'pipe')
    " @vimlint(EVL103, 1, a:job_id)
    function! obj._out_cb(job_id, data) abort
        if has_key(self._opts, 'on_stdout')
            call self._opts.on_stdout(self._opts.jobpid, [a:data], 'stdout')
        endif
    endfunction

    function! obj._err_cb(job_id, data) abort
        if has_key(self._opts, 'on_stderr')
            call self._opts.on_stderr(self._opts.jobpid, [a:data], 'stderr')
        endif
    endfunction

    function! obj._exit_cb(job_id, data) abort
        if has_key(self._opts, 'on_exit')
            call self._opts.on_exit(self._opts.jobpid, a:data, 'exit')
        endif
    endfunction
    " @vimlint(EVL103, 0, a:job_id)

    let obj = {
                \ 'argv': a:argv,
                \ 'opts': {
                \ 'mode': 'nl',
                \ 'in_io' : obj.in_io,
                \ 'out_cb': obj._out_cb,
                \ 'err_cb': obj._err_cb,
                \ 'exit_cb': obj._exit_cb,
                \ }
                \ }
    if has_key(a:opts, 'cwd')
        call extend(obj.opts, {'cwd' : a:opts.cwd})
    endif
    return obj
endfunction

" start a job, and return the job_id.
function! s:self.start(argv, ...) abort
    if self.nvim_job
        if len(a:000) > 0
            let job = jobstart(a:argv, a:1)
        else
            let job = jobstart(a:argv)
        endi
        let msg = ['process '. jobpid(job), ' run']
        call extend(self.jobs, {job : msg})
        return job
    elseif self.vim_job
        if len(a:000) > 0
            let opts = a:1
        else
            let opts = {}
        endif
        let id = len(self.jobs) + 1
        let opts.jobpid = id
        let wrapped = self.warp(a:argv, opts)
        if has_key(wrapped.opts, 'cwd')
            let old_wd = getcwd()
            let cwd = expand(wrapped.opts.cwd, 1)
            " Avoid error E475: Invalid argument: cwd
            call remove(wrapped.opts, 'cwd')
            exe 'cd' fnameescape(cwd)
        endif
        let job = job_start(wrapped.argv, wrapped.opts)
        if exists('old_wd')
            exe 'cd' fnameescape(old_wd)
        endif
        call extend(self.jobs, {id : job})
        return id
    else
        if len(a:000) > 0
            let opts = a:1
        else
            let opts = {}
        endif
        if has_key(opts, 'cwd')
            let old_wd = getcwd()
            let cwd = expand(opts.cwd, 1)
            exe 'cd' fnameescape(cwd)
        endif
        let output = self.vim_co.systemlist(a:argv)
        if exists('old_wd')
            exe 'cd' fnameescape(old_wd)
        endif
        let id = -1
        if v:shell_error
            if has_key(opts,'on_stderr')
                call call(opts.on_stderr, [id, output, 'stderr'])
            endif
        else
            if has_key(opts,'on_stdout')
                call call(opts.on_stdout, [id, output, 'stdout'])
            endif
        endif
        if has_key(opts,'on_exit')
            call call(opts.on_exit, [id, v:shell_error, 'exit'])
        endif
        return id
    endif
endfunction

function! s:self.stop(id) abort
    if self.nvim_job
        if has_key(self.jobs, a:id)
            call jobstop(a:id)
            call remove(self.jobs, a:id)
        else
            call self.warn('No job with such id')
        endif
    elseif self.vim_job
        if has_key(self.jobs, a:id)
            call job_stop(get(self.jobs, a:id))
            call remove(self.jobs, a:id)
        endif
    else
        call self.warn()
    endif
endfunction

function! s:self.send(id, data) abort
    if self.nvim_job
        if has_key(self.jobs, a:id)
            if type(a:data) == type('')
                call jobsend(a:id, [a:data, ''])
            else
                call jobsend(a:id, a:data)
            endif
        else
            call self.warn('No job with such id')
        endif
    elseif self.vim_job
        if has_key(self.jobs, a:id)
            let job = get(self.jobs, a:id)
            let chanel = job_getchannel(job)
            call ch_sendraw(chanel, a:data . "\n")
        else
            call self.warn('No job with such id')
        endif
    else
        call self.warn()
    endif
endfunction

function! s:self.status(id) abort
    if self.nvim_job
        if has_key(self.jobs, a:id)
            return get(self.jobs, a:id)[1]
        endif
    elseif self.vim_job
        if has_key(self.jobs, a:id)
            return job_status(get(self.jobs, a:id))
        endif
    else
        call self.warn('No job with such id!')
    endif
endfunction

function! s:self.list() abort
    return copy(self.jobs)
endfunction

function! s:self.info(id) abort
    let info = {}
    if self.nvim_job
        let info.status = self.status(a:id)
        let info.job_id = a:id
        return info
    elseif self.vim_job
        if has_key(self.jobs, a:id)
            return job_info(get(self.jobs, a:id))
        else
            call self.warn('No job with such id!')
        endif
    else
        call self.warn()
    endif
endfunction
