let s:jobinfo_base = {
            \ 'cd_back_cmd': '',
            \ 'pending_output': [],
            \ 'file_mode': 1,
            \ }
function! s:jobinfo_base.get_pid() abort
    if has_key(self, 'vim_job')
        let info = job_info(self.vim_job)
        if info.status ==# 'run'
            return info.process
        endif
        return -1
    endif
    try
        return jobpid(self.nvim_job)
    catch /^Vim(return):E900:/
        return -1
    endtry
endfunction

function! s:jobinfo_base.as_string() abort
    let extra = []
    for k in ['canceled', 'finished']
        if get(self, k, 0)
            let extra += [k]
        endif
    endfor
    return printf('Job %d: %s%s', self.id, self.name,
                \ empty(extra) ? '' : ' ['.join(extra, ', ').']')
endfunction

function! s:jobinfo_base.cd_back() abort
    if !empty(self.cd_back_cmd)
        exe self.cd_back_cmd
        let self.cd_back_cmd = ''
    endif
endfunction

function! s:jobinfo_base.cd(...) abort
    if a:0
        if has_key(self, 'cd_from_setting')
            call neomake#log#debug(printf(
                        \ 'jobinfo.cd(): keeping cwd from setting: %s.',
                        \ string(self.cd_from_setting)), self)
            return ''
        endif
        let dir = a:1
    else
        let maker = self.maker
        let dir = neomake#utils#GetSetting('cwd', maker, '', self.ft, self.bufnr, 1)
        if !empty(dir)
            let self.cd_from_setting = dir
        endif
    endif

    if dir !=# ''
        if dir[0:1] ==# '%:'
            let dir = neomake#utils#fnamemodify(self.bufnr, dir[1:])
        else
            let dir = expand(dir, 1)
        endif
        let dir = fnamemodify(dir, ':p')
        " NOTE: need to keep trailing backslash with "/" and "X:\" on Windows.
        if dir !=# '/' && dir[-1:] ==# neomake#utils#Slash() && dir[-2] !=# ':'
            let dir = dir[:-2]
        endif
    else
        let dir = get(self, 'cwd', $HOME)
    endif

    let cur_wd = getcwd()
    if dir !=# cur_wd
        let [cd_error, cd_back_cmd] = neomake#utils#temp_cd(dir, cur_wd)
        if !empty(cd_error)
            call neomake#log#debug(printf('jobinfo.cd(): error when trying to change cwd to %s: %s.',
                        \ dir, cd_error))
            return cd_error
        endif
        let self.cwd = dir
        let self.cd_back_cmd = cd_back_cmd
    else
        let self.cwd = cur_wd
    endif
    return ''
endfunction

function! neomake#jobinfo#new() abort
    let jobinfo = deepcopy(s:jobinfo_base)
    let jobinfo.bufnr = bufnr('%')
    return jobinfo
endfunction

" vim: ts=4 sw=4 et
