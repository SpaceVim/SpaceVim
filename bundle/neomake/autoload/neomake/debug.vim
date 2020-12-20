" Debug/feedback helpers.

function! neomake#debug#pprint(d, ...) abort
    return call('s:pprint', [a:d] + a:000)
endfunction

function! s:pprint(v, ...) abort
    let indent = a:0 ? a:1 : ''
    if type(a:v) ==# type({})
        if empty(a:v)
            return '{}'
        endif
        let r = "{\n"
        for [k, l:V] in items(a:v)
            let r .= printf("%s  %s: %s,\n",
                        \ indent,
                        \ string(k),
                        \ s:pprint(neomake#utils#fix_self_ref(V), indent . '  '))
            unlet V  " old-vim
        endfor
        let r .= indent.'}'
        return r
    elseif type(a:v) ==# type([])
        if empty(a:v)
            return '[]'
        endif
        let r = '['."\n".join(map(copy(a:v), 'indent."  ".s:pprint(v:val, indent."  ")'), ",\n").",\n".indent.']'
        return r
    endif
    return string(a:v)
endfunction

function! neomake#debug#validate_maker(maker) abort
    let issues = {'errors': [], 'warnings': []}

    if has_key(a:maker, 'process_json') && has_key(a:maker, 'process_output')
        let issues.warnings += ['maker has process_json and process_output, but only process_json will be used.']
        let check_process = ['process_json']
    else
        let check_process = ['process_json', 'process_output']
    endif

    for f in check_process
        if has_key(a:maker, f)
            if has_key(a:maker, 'mapexpr')
                let issues.warnings += [printf(
                            \ 'maker has mapexpr, but only %s will be used.',
                            \ f)]
            endif
            if has_key(a:maker, 'postprocess')
                let issues.warnings += [printf(
                            \ 'maker has postprocess, but only %s will be used.',
                            \ f)]
            endif
            if has_key(a:maker, 'errorformat')
                let issues.warnings += [printf(
                            \ 'maker has errorformat, but only %s will be used.',
                            \ f)]
            endif
        endif
    endfor

    let jobinfo = neomake#jobinfo#new()
    try
        let maker = neomake#core#instantiate_maker(a:maker, jobinfo, 0)
        if !executable(maker.exe)
            let t = get(maker, 'auto_enabled', 0) ? 'warnings' : 'errors'
            let issues[t] += [printf("maker's exe (%s) is not executable.", maker.exe)]
        endif
    catch /^Neomake: /
        let issues.errors += [substitute(v:exception, '^Neomake: ', '', '').'.']
    endtry

    if has_key(a:maker, 'name')
        if a:maker.name !~# g:neomake#core#valid_maker_name_pattern
            call add(issues['errors'], printf(
                  \ 'Invalid maker name: %s (should match %s)',
                  \ string(a:maker.name),
                  \ string(g:neomake#core#valid_maker_name_pattern)))
        endif
    endif

    return issues
endfunction

" Optional arg: ft
function! s:get_makers_info(...) abort
    let maker_names = call('neomake#GetEnabledMakers', a:000)
    if empty(maker_names)
        return ['None.']
    endif
    let maker_defaults = g:neomake#config#_defaults['maker_defaults']
    let r = []
    for maker_name in maker_names
        let maker = call('neomake#GetMaker', [maker_name] + a:000)
        let r += [' - '.maker.name]
        let r += map(s:get_maker_info(maker, maker_defaults), "'  '.v:val")
    endfor
    return r
endfunction

function! s:get_maker_info(maker, ...) abort
    let maker_defaults = a:0 ? a:1 : {}
    let maker = a:maker
    let r = []
    for [k, l:V] in sort(copy(items(maker)))
        if k !=# 'name' && k !=# 'ft' && k !~# '^_'
            if !has_key(maker_defaults, k)
                        \ || type(V) != type(maker_defaults[k])
                        \ || V !=# maker_defaults[k]
                let r += [' - '.k.': '.string(V)]
            endif
        endif
        unlet V  " vim73
    endfor

    let issues = neomake#debug#validate_maker(maker)
    if !empty(issues)
        for type in sort(copy(keys(issues)))
            let items = issues[type]
            if !empty(items)
                let r += [' - '.toupper(type) . ':']
                for issue in items
                    let r += ['   - ' . issue]
                endfor
            endif
        endfor
    endif

    if type(maker.exe) == type('') && executable(maker.exe)
        let version_arg = get(maker, 'version_arg', '--version')
        let exe = exists('*exepath') ? exepath(maker.exe) : maker.exe
        let version_output = neomake#compat#systemlist([exe, version_arg])
        if empty(version_output)
            let version_output = [printf(
                        \ 'failed to get version information (%s)',
                        \ v:shell_error)]
        endif
        let r += [printf(' - version information (%s %s): %s',
                    \ exe,
                    \ version_arg,
                    \ join(version_output, "\n     "))]
    endif
    return r
endfunction

function! s:get_fts_with_makers() abort
    return neomake#compat#uniq(sort(map(split(globpath(escape(&runtimepath, ' '),
          \ 'autoload/neomake/makers/ft/*.vim'), "\n"),
          \ 'fnamemodify(v:val, ":t:r")')))
endfunction

function! neomake#debug#get_maker_info(maker_name) abort
    let source = ''
    let maker = neomake#get_maker_by_name(a:maker_name, &filetype)
    if empty(maker)
        let maker = neomake#get_maker_by_name(a:maker_name)
        if empty(maker)
            let fts = filter(s:get_fts_with_makers(), 'v:val != &filetype')
            for ft in fts
                let maker = neomake#get_maker_by_name(a:maker_name, ft)
                if !empty(maker)
                    let source = 'filetype '.ft
                    break
                endif
            endfor
        else
            let source = 'project maker'
        endif
    endif
    if empty(maker)
        call neomake#log#error(printf('Maker not found: %s.', a:maker_name))
        return []
    endif
    let maker = neomake#create_maker_object(maker, &filetype)
    return [maker.name . (empty(source) ? '' : ' ('.source.')')]
                \ + s:get_maker_info(maker)
endfunction

function! neomake#debug#display_info(...) abort
    let bang = a:0 ? a:1 : 0
    if a:0 > 1
        let maker_name = a:2
        let lines = neomake#debug#get_maker_info(maker_name)
    else
        let lines = neomake#debug#_get_info_lines()
    endif
    if bang
        try
            call setreg('+', join(lines, "\n"), 'l')
        catch
            call neomake#log#error(printf(
                        \ 'Could not set clipboard: %s.', v:exception))
            return
        endtry
        echom 'Copied Neomake info to clipboard ("+).'
    else
        echon join(lines, "\n")
    endif
endfunction

function! s:trim(s) abort
    return substitute(a:s, '\v^[ \t\r\n]+|[ \t\r\n]+$', '', 'g')
endfunction

function! neomake#debug#_get_info_lines() abort
    let r = []
    let ft = &filetype

    let r += ['#### Neomake debug information']
    let r += ['']
    let r += ['Async support: '.neomake#has_async_support()]
    let r += ['Current filetype: '.ft]
    let r += ['Windows: '.neomake#utils#IsRunningWindows()]
    let r += ['[shell, shellcmdflag, shellslash]: '.string([&shell, &shellcmdflag, &shellslash])]
    let r += [join(map(split(neomake#utils#redir('verb set makeprg?'), '\n'), 's:trim(v:val)'), ', ')]

    let r += ['']
    let r += ['##### Enabled makers']
    let r += ['']
    let r += ['For the current filetype ("'.ft.'", used with :Neomake):']
    let r += s:get_makers_info(ft)
    if empty(ft)
        let r += ['NOTE: the current buffer does not have a filetype.']
    else
        let conf_ft = neomake#utils#get_ft_confname(ft)
        let r += ['NOTE: you can define g:neomake_'.conf_ft.'_enabled_makers'
                    \ .' to configure it (or b:neomake_'.conf_ft.'_enabled_makers).']
    endif
    let r += ['']
    let r += ['For the project (used with :Neomake!):']
    let r += s:get_makers_info()
    let r += ['NOTE: you can define g:neomake_enabled_makers to configure it.']
    let r += ['']
    let r += ['Default maker settings:']
    for [k, v] in items(neomake#config#get('maker_defaults'))
        let r += [' - '.k.': '.string(v)]
        unlet! v  " Fix variable type mismatch with Vim 7.3.
    endfor
    let r += ['']
    let r += ['##### Settings']
    let r += ['']
    let r += ['###### New-style (dict, overrides old-style)']
    let r += ['']
    let r += ['```']

    let r += ['g:neomake: '.(exists('g:neomake') ? s:pprint(g:neomake) : 'unset')]
    let r += ['b:neomake: '.(exists('b:neomake') ? s:pprint(b:neomake) : 'unset')]
    let r += ['```']
    let r += ['']
    let r += ['###### Old-style']
    let r += ['']
    let r += ['```']
    for [k, V] in sort(items(filter(copy(g:), "v:key =~# '^neomake_'")))
        let r += ['g:'.k.' = '.string(V)]
        unlet! V  " Fix variable type mismatch with Vim 7.3.
    endfor
    let r += ['']
    let r += ['```']
    let r += ["\n"]
    let r += ['#### :version']
    let r += ['']
    let r += ['```']
    let r += split(neomake#utils#redir('version'), '\n')
    let r += ['```']
    let r += ['']
    let r += ['#### :messages']
    let r += ['']
    let r += ['```']
    let r += split(neomake#utils#redir('messages'), '\n')
    let r += ['```']
    return r
endfunction
" vim: ts=4 sw=4 et
