function! neomake#makers#ft#rust#EnabledMakers() abort
    return ['cargo']
endfunction

function! neomake#makers#ft#rust#rustc() abort
    return {
        \ 'errorformat':
            \ '%-Gerror: aborting due to previous error,'.
            \ '%-Gerror: aborting due to %\\d%\\+ previous errors,'.
            \ '%-Gerror: Could not compile `%s`.,'.
            \ '%Eerror[E%n]: %m,'.
            \ '%Eerror: %m,'.
            \ '%Wwarning: %m,'.
            \ '%Inote: %m,'.
            \ '%-Z\ %#-->\ %f:%l:%c,'.
            \ '%G\ %#\= %*[^:]: %m,'.
            \ '%G\ %#|\ %#%\\^%\\+ %m,'.
            \ '%I%>help:\ %#%m,'.
            \ '%Z\ %#%m,'.
            \ '%-G%.%#',
        \ }
endfunction

function! s:get_cargo_workspace_root() abort
    if !exists('b:_neomake_cargo_workspace')
        let cmd = 'cargo metadata --no-deps --format-version 1'
        let [cd_error, cd_back_cmd] = neomake#utils#temp_cd(expand('%:h'))
        if !empty(cd_error)
            call neomake#log#debug(printf(
                        \ 's:get_cargo_workspace_root: failed to cd to buffer directory: %s.',
                        \ cd_error))
        endif
        let output = system(cmd)
        if !empty(cd_back_cmd)
            exe cd_back_cmd
        endif
        if v:shell_error
            call neomake#log#debug(printf(
                        \ 'Failed to get cargo metadata for workspace using %s.',
                        \ string(cmd)))
            let b:_neomake_cargo_workspace = ''
        else
            let json = neomake#compat#json_decode(output)
            let b:_neomake_cargo_workspace = json['workspace_root']
        endif
    endif
    return b:_neomake_cargo_workspace
endfunction

function! s:get_cargo_maker_cwd(default) abort
    let cargo_workspace_root = s:get_cargo_workspace_root()
    if !empty(cargo_workspace_root)
        return cargo_workspace_root
    endif

    let cargo_toml = neomake#utils#FindGlobFile('Cargo.toml')
    if !empty(cargo_toml)
        return fnamemodify(cargo_toml, ':h')
    endif

    return a:default
endfunction

function! neomake#makers#ft#rust#cargotest() abort
    " NOTE: duplicates are removed due to https://github.com/rust-lang/cargo/issues/5128.
    let maker = {
        \ 'exe': 'cargo',
        \ 'args': ['test', '%:t:r', '--quiet'],
        \ 'append_file': 0,
        \ 'uses_filename': 0,
        \ 'postprocess': copy(g:neomake#postprocess#remove_duplicates),
        \ 'errorformat':
            \ '%-G,' .
            \ '%-Gtest %s,' .
            \ '%-Grunning %\\d%# test%s,' .
            \ '%-Gfailures:%s,' .
            \ '%-G----%s,' .
            \ '%-G%.%#--verbose%s,' .
            \ '%-G%.%#--explain%s,' .
            \ '%-Gerror: aborting due to previous error,' .
            \ '%-G%\ %#error: aborting due to %\\d%#%\ %#previous errors,' .
            \ '%E%\ %#error[E%n]:\ %m,' .
            \ '%E%\ %#error:\ %m,' .
            \ '%I%\ %#note:\ %m,'.
            \ '%W%\ %#warning:\ %m,' .
            \ '%-Z%\ %#-->\ %f:%l:%c,' .
            \ '%-G%\\d%# %#|\ %s,' .
            \ '%-G%\\d%# %#|,' .
            \ '%-G\ %#\= %*[^:]:\ %m,'.
            \ '%E%\ %#%m,' .
            \ '%G%\ %#%s%\\,,' .
            \ '%Z%\ %#%s%\\,%\\s%f:%l:%c'
    \ }

    function! maker.InitForJob(_jobinfo) abort
        if !has_key(self, 'cwd')
            let self.cwd = s:get_cargo_maker_cwd('%:p:h')
            return self
        endif
    endfunction
    return maker
endfunction

function! neomake#makers#ft#rust#cargo() abort
    let maker_command = get(b:, 'neomake_rust_cargo_command',
                \ get(g:, 'neomake_rust_cargo_command', ['check']))
    let maker = {
        \ 'args': maker_command + ['--message-format=json', '--quiet'],
        \ 'append_file': 0,
        \ 'tempfile_enabled': 0,
        \ 'process_output': function('neomake#makers#ft#rust#CargoProcessOutput'),
        \ }

    function! maker.InitForJob(_jobinfo) abort
        if !has_key(self, 'cwd')
            let self.cwd = s:get_cargo_maker_cwd('%:p:h')
            return self
        endif
    endfunction
    return maker
endfunction

" NOTE: does not use process_json, since cargo outputs multiple JSON root
" elements per line.
function! neomake#makers#ft#rust#CargoProcessOutput(context) abort
    let errors = []
    for line in a:context['output']
        if line[0] !=# '{'
            continue
        endif

        let decoded = neomake#compat#json_decode(line)
        let data = get(decoded, 'message', -1)
        if type(data) != type({}) || empty(get(data, 'spans', []))
            " call neomake#log#debug(printf('cargo: ignoring input: %s.', line))
            continue
        endif

        let error = {'maker_name': 'cargo'}

        let code_dict = get(data, 'code', -1)
        if code_dict is g:neomake#compat#json_null
                    \ || index(['E', 'W'], code_dict['code'][0]) == -1
            let level = get(data, 'level', -1)
            if level != -1
                let error.type = toupper(level[0])
            else
                let error.type = 'W'
            endif
        else
            let error.type = code_dict['code'][0]
            let error.nr = str2nr(code_dict['code'][1:])
        endif

        let span = data.spans[0]
        for candidate_span in data.spans
            if candidate_span.is_primary
                let span = candidate_span
                break
            endif
        endfor

        let expanded = 0
        let has_expansion = type(span.expansion) == type({})
                    \ && type(span.expansion.span) == type({})
                    \ && type(span.expansion.def_site_span) == type({})

        if span.file_name =~# '^<.*>$' && has_expansion
            let expanded = 1
            call neomake#makers#ft#rust#FillErrorFromSpan(error,
                        \ span.expansion.span)
        else
            call neomake#makers#ft#rust#FillErrorFromSpan(error, span)
        endif

        let error.text = data.message
        let detail = span.label
        let children = data.children
        if type(detail) == type('') && !empty(detail)
            let error.text = error.text . ': ' . detail
        elseif !empty(children) && has_key(children[0], 'message')
            let error.text = error.text . '. ' . children[0].message
        endif

        call add(errors, error)

        if has_expansion && !expanded
            let error = copy(error)
            call neomake#makers#ft#rust#FillErrorFromSpan(error,
                        \ span.expansion.span)
            call add(errors, error)
        endif

        for child in children[1:]
            if !has_key(child, 'message')
                continue
            endif

            let info = deepcopy(error)
            let info.type = 'I'
            let info.text = child.message
            call neomake#postprocess#compress_whitespace(info)
            if has_key(child, 'rendered')
                        \ && !(child.rendered is g:neomake#compat#json_null)
                let info.text = info.text . ': ' . child.rendered
            endif

            if len(child.spans)
                let span = child.spans[0]
                if span.file_name =~# '^<.*>$'
                            \ && type(span.expansion) == type({})
                            \ && type(span.expansion.span) == type({})
                            \ && type(span.expansion.def_site_span) == type({})
                    call neomake#makers#ft#rust#FillErrorFromSpan(info,
                                \ span.expansion.span)
                else
                    call neomake#makers#ft#rust#FillErrorFromSpan(info, span)
                endif
                let detail = span.label
                if type(detail) == type('') && len(detail)
                    let info.text = info.text . ': ' . detail
                endif
            endif

            call add(errors, info)
        endfor
    endfor
    return errors
endfunction

function! neomake#makers#ft#rust#FillErrorFromSpan(error, span) abort
    let a:error.filename = a:span.file_name
    let a:error.col = a:span.column_start
    let a:error.lnum = a:span.line_start
    let a:error.length = a:span.byte_end - a:span.byte_start
endfunction

" vim: ts=4 sw=4 et
