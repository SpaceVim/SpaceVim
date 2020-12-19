let g:neomake#core#valid_maker_name_pattern = '\v^\w+$'

let g:neomake#core#_ignore_autocommands = 0

function! neomake#core#create_jobs(options, makers) abort
    let args = [a:options, a:makers]
    let jobs = call('s:bind_makers_for_job', args)
    return jobs
endfunction

" Map/bind a:makers to a list of job options, using a:options.
function! s:bind_makers_for_job(options, makers) abort
    let r = []
    for maker in a:makers
        let options = copy(a:options)
        try
            let maker = neomake#core#instantiate_maker(maker, options, 1)
        catch /^Neomake: skip_job: /
            let msg = substitute(v:exception, '^Neomake: skip_job: ', '', '')
            call neomake#log#debug(printf('%s: skipping job: %s.',
                        \ maker.name, msg), options)
            continue
        catch /^Neomake: /
            let error = substitute(v:exception, '^Neomake: ', '', '').'.'
            call neomake#log#error(error, options)
            continue
        endtry
        if !empty(maker)
            let options.maker = maker
            let r += [options]
        endif
    endfor
    return r
endfunction

function! neomake#core#instantiate_maker(maker, options, check_exe) abort
    let maker = a:maker
    let options = a:options
    let ft = get(options, 'ft', '')
    let bufnr = get(options, 'bufnr', '')

    " Call InitForJob function in maker object, if any.
    let l:Init = neomake#utils#GetSetting('InitForJob', maker, g:neomake#config#undefined, ft, bufnr)
    if empty(Init)
        " Deprecated: should use InitForJob instead.
        if has_key(maker, 'fn')
            unlet Init  " vim73
            let l:Init = maker.fn
            call neomake#log#warn_once(printf("Please use 'InitForJob' instead of 'fn' for maker %s.", maker.name),
                        \ printf('deprecated-fn-%s', maker.name))
        endif
    endif
    if !empty(Init)
        let returned_maker = call(Init, [options], maker)
        if returned_maker isnot# 0
            " This conditional assignment allows to both return a copy
            " (factory), while also can be used as a init method.
            let maker = returned_maker
        endif
    endif

    if has_key(maker, '_bind_args')
        call maker._bind_args()
        if type(maker.exe) != type('')
            let error = printf('Non-string given for executable of maker %s: type %s',
                        \ maker.name, type(maker.exe))
            if !get(maker, 'auto_enabled', 0)
                throw 'Neomake: '.error
            endif
            call neomake#log#debug(error.'.', options)
            return {}
        endif
        if a:check_exe && !executable(maker.exe)
            if get(maker, 'auto_enabled', 0)
                call neomake#log#debug(printf(
                            \ 'Exe (%s) of auto-configured maker %s is not executable, skipping.', maker.exe, maker.name), options)
            else
                let error = printf('Exe (%s) of maker %s is not executable', maker.exe, maker.name)
                throw 'Neomake: '.error
            endif
            return {}
        endif
    endif
    return maker
endfunction

" Base class for command makers.
let g:neomake#core#command_maker_base = {}

function! g:neomake#core#command_maker_base._get_fname_for_args(jobinfo) abort dict
    " Append file?  (defaults to jobinfo.file_mode, project/global makers should set it to 0)
    let append_file = neomake#utils#GetSetting('append_file', self, a:jobinfo.file_mode, a:jobinfo.ft, a:jobinfo.bufnr)
    " Use stdin?  (checked here always to work without setting "uses_filename").
    let uses_stdin = neomake#utils#GetSetting('uses_stdin', self, g:neomake#config#undefined, a:jobinfo.ft, a:jobinfo.bufnr)
    if uses_stdin isnot g:neomake#config#undefined
        let a:jobinfo.uses_stdin = uses_stdin
        call neomake#log#debug(printf('Using uses_stdin (%s) from setting.',
                    \ a:jobinfo.uses_stdin), a:jobinfo)
    endif
    " Use/generate a filename?  (defaults to 1 if tempfile_name is set)
    let uses_filename = append_file || neomake#utils#GetSetting('uses_filename', self, has_key(self, 'tempfile_name'), a:jobinfo.ft, a:jobinfo.bufnr)
    if append_file || uses_filename || !empty(uses_stdin)
        let filename = self._get_fname_for_buffer(a:jobinfo)
        if append_file
            return filename
        endif
    endif
    return ''
endfunction

function! g:neomake#core#command_maker_base._get_argv(_jobinfo) abort dict
    return neomake#compat#get_argv(self.exe, self.args, type(self.args) == type([]))
endfunction

" Get tabnr and winnr for a given make ID.
function! neomake#core#get_tabwin_for_makeid(make_id) abort
    let curtab = tabpagenr()
    for t in [curtab] + range(1, curtab-1) + range(curtab+1, tabpagenr('$'))
        for w in range(1, tabpagewinnr(t, '$'))
            if index(neomake#compat#gettabwinvar(t, w, 'neomake_make_ids', []), a:make_id) != -1
                return [t, w]
            endif
        endfor
    endfor
    return [-1, -1]
endfunction
" vim: ts=4 sw=4 et
