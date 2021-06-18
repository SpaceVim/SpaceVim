function! neoformat#Neoformat(bang, user_input, start_line, end_line) abort
    let view = winsaveview()
    let search = @/
    let original_filetype = &filetype

    call s:neoformat(a:bang, a:user_input, a:start_line, a:end_line)

    " Setting &filetype might destroy existing folds, so only do that
    " if the filetype got changed (which can only be possible when
    " invoking with a bang)
    if a:bang && &filetype != original_filetype
        let &filetype = original_filetype
    endif
    let @/ = search
    call winrestview(view)
endfunction

function! s:neoformat(bang, user_input, start_line, end_line) abort

    if !&modifiable
        return neoformat#utils#warn('buffer not modifiable')
    endif

    let using_visual_selection = a:start_line != 1 || a:end_line != line('$')

    let inputs = split(a:user_input)
    if a:bang
        let &filetype = len(inputs) > 1 ? inputs[0] : a:user_input
    endif

    let filetype = s:split_filetypes(&filetype)

    let using_user_passed_formatter = (!empty(a:user_input) && !a:bang)
                \ || (len(inputs) > 1 && a:bang)

    if using_user_passed_formatter
        let formatters = len(inputs) > 1 ? [inputs[1]] : [a:user_input]
    else
        let formatters = s:get_enabled_formatters(filetype)
        if formatters == []
            call neoformat#utils#msg('formatter not defined for ' . filetype . ' filetype')
            return s:basic_format()
        endif
    endif

    let formatters_failed = []
    let formatters_changed = []
    for formatter in formatters

        if &formatprg != '' && split(&formatprg)[0] ==# formatter
                    \ && neoformat#utils#var('neoformat_try_formatprg')
            call neoformat#utils#log('using formatprg')
            let fmt_prg_def = split(&formatprg)
            let definition = {
                    \ 'exe': fmt_prg_def[0],
                    \ 'args': fmt_prg_def[1:],
                    \ 'stdin': 1,
                    \ }
        elseif exists('b:neoformat_' . filetype . '_' . formatter)
            let definition = b:neoformat_{filetype}_{formatter}
        elseif exists('g:neoformat_' . filetype . '_' . formatter)
            let definition = g:neoformat_{filetype}_{formatter}
        elseif s:autoload_func_exists('neoformat#formatters#' . filetype . '#' . formatter)
            let definition =  neoformat#formatters#{filetype}#{formatter}()
        else
            call neoformat#utils#log('definition not found for formatter: ' . formatter)
            if using_user_passed_formatter
                call neoformat#utils#msg('formatter definition for ' . a:user_input . ' not found')

                return s:basic_format()
            endif
            continue
        endif

        let cmd = s:generate_cmd(definition, filetype)
        if cmd == {}
            if using_user_passed_formatter
                return neoformat#utils#warn('formatter ' . a:user_input . ' failed')
            endif
            continue
        endif

        let stdin = getbufline(bufnr('%'), a:start_line, a:end_line)
        let original_buffer = getbufline(bufnr('%'), 1, '$')

        call neoformat#utils#log(stdin)

        call neoformat#utils#log(cmd.exe)
        if cmd.stdin
            call neoformat#utils#log('using stdin')
            let stdin_str = join(stdin, "\n")
            let stdout = split(system(cmd.exe, stdin_str), '\n')
        else
            call neoformat#utils#log('using tmp file')
            call writefile(stdin, cmd.tmp_file_path)
            let stdout = split(system(cmd.exe), '\n')
        endif

        " read from /tmp file if formatter replaces file on format
        if cmd.replace
            let stdout = readfile(cmd.tmp_file_path)
        endif

        call neoformat#utils#log(stdout)

        call neoformat#utils#log(cmd.valid_exit_codes)
        call neoformat#utils#log(v:shell_error)

        let process_ran_succesfully = index(cmd.valid_exit_codes, v:shell_error) != -1

        if cmd.stderr_log != ''
            call neoformat#utils#log('stderr output redirected to file' . cmd.stderr_log)
            call neoformat#utils#log_file_content(cmd.stderr_log)
        endif
        if process_ran_succesfully
            " 1. append the lines that are before and after the formatterd content
            let lines_after = getbufline(bufnr('%'), a:end_line + 1, '$')
            let lines_before = getbufline(bufnr('%'), 1, a:start_line - 1)

            let new_buffer = lines_before + stdout + lines_after
            if new_buffer !=# original_buffer

                call s:deletelines(len(new_buffer), line('$'))

                call setline(1, new_buffer)

                call add(formatters_changed, cmd.name)
                let endmsg = cmd.name . ' formatted buffer'
            else

                let endmsg = 'no change necessary with ' . cmd.name
            endif
            if !neoformat#utils#var('neoformat_run_all_formatters')
                return neoformat#utils#msg(endmsg)
            endif
            call neoformat#utils#log('running next formatter')
        else
            call add(formatters_failed, cmd.name)
            call neoformat#utils#log(v:shell_error)
            call neoformat#utils#log('trying next formatter')
        endif
    endfor
    if len(formatters_failed) > 0
        call neoformat#utils#msg('formatters ' . join(formatters_failed, ", ") . ' failed to run')
    endif
    if len(formatters_changed) > 0
        call neoformat#utils#msg(join(formatters_changed, ", ") . ' formatted buffer')
    elseif len(formatters_failed) == 0
        call neoformat#utils#msg('no change necessary')
    endif
endfunction

function! s:get_enabled_formatters(filetype) abort
    if &formatprg != '' && neoformat#utils#var('neoformat_try_formatprg')
        call neoformat#utils#log('adding formatprg to enabled formatters')
        let format_prg_exe = [split(&formatprg)[0]]
    else
        let format_prg_exe = []
    endif

    " Note: we append format_prg_exe to ever return as it will either be
    " [], or it will be a formatter that we want to try first

    if exists('b:neoformat_enabled_' . a:filetype)
        return format_prg_exe + b:neoformat_enabled_{a:filetype}
    elseif exists('g:neoformat_enabled_' . a:filetype)
        return format_prg_exe + g:neoformat_enabled_{a:filetype}
    elseif s:autoload_func_exists('neoformat#formatters#' . a:filetype . '#enabled')
        return format_prg_exe + neoformat#formatters#{a:filetype}#enabled()
    endif
    return format_prg_exe
endfunction

function! s:deletelines(start, end) abort
    silent! execute a:start . ',' . a:end . 'delete _'
endfunction

function! neoformat#CompleteFormatters(ArgLead, CmdLine, CursorPos) abort
    if a:CmdLine =~ '!'
        " 1. user inputting formatter :Neoformat! css <here>
        if a:CmdLine =~# 'Neoformat! \S*\s'
            let filetype = split(a:CmdLine)[1]
            return filter(s:get_enabled_formatters(filetype),
                    \ "v:val =~? '^" . a:ArgLead ."'")
        endif

        " 2. user inputting filetype :Neoformat! <here>
        " https://github.com/junegunn/fzf.vim/pull/110
        " 1. globpath (find) all filetype files in neoformat
        " 2. split at new lines
        " 3. map ~/.config/nvim/plugged/neoformat/autoload/neoformat/formatters/xml.vim --> xml
        " 4. sort & uniq to eliminate dupes
        " 5. filter for input
        return filter(uniq(sort(map(split(globpath(&runtimepath,
                    \ 'plugged/neoformat/autoload/neoformat/formatters/*.vim'), '\n'),
                    \ "fnamemodify(v:val, ':t:r')"))),
                    \ "v:val =~? '^" . a:ArgLead . "'")
    endif
    if a:ArgLead =~ '[^A-Za-z0-9]'
        return []
    endif
    let filetype = s:split_filetypes(&filetype)
    return filter(s:get_enabled_formatters(filetype),
                \ "v:val =~? '^" . a:ArgLead ."'")
endfunction

function! s:autoload_func_exists(func_name) abort
    try
        call eval(a:func_name . '()')
    catch /^Vim\%((\a\+)\)\=:E/
        return 0
    endtry
    return 1
endfunction

function! s:split_filetypes(filetype) abort
    if a:filetype == ''
        return ''
    endif
    return split(a:filetype, '\.')[0]
endfunction

function! s:generate_cmd(definition, filetype) abort
    let executable = get(a:definition, 'exe', '')
    if executable == ''
        call neoformat#utils#log('no exe field in definition')
        return {}
    endif

    if &shell =~ '\v%(powershell|pwsh)'
        if system('[bool](Get-Command ' . executable . ' -ErrorAction SilentlyContinue)') !~ 'True'
            call neoformat#utils#log('executable: ' . executable . ' is not a cmdlet, function, script file, or an executable program')
            return {}
        endif
    elseif !executable(executable)
        call neoformat#utils#log('executable: ' . executable . ' is not an executable')
        return {}
    endif

    let args = get(a:definition, 'args', [])
    let args_expanded = []
    for a in args
        let args_expanded = add(args_expanded, s:expand_fully(a))
    endfor

    let no_append = get(a:definition, 'no_append', 0)
    let using_stdin = get(a:definition, 'stdin', 0)
    let using_stderr = get(a:definition, 'stderr', 0)
    let stderr_log = ''

    let filename = expand('%:t')

    let tmp_dir = has('win32') ? expand('$TEMP/neoformat') :
                \ exists('$TMPDIR') ? expand('$TMPDIR/neoformat') :
                \ '/tmp/neoformat'

    if !isdirectory(tmp_dir)
        call mkdir(tmp_dir, 'p')
    endif

    if get(a:definition, 'replace', 0)
        let path = !using_stdin ? expand(tmp_dir . '/' . fnameescape(filename)) : ''
    else
        let path = !using_stdin ? tempname() : ''
    endif

    let inline_environment = get(a:definition, 'env', [])
    let _fullcmd = join(inline_environment, ' ') . ' ' . executable . ' ' . join(args_expanded) . ' ' . (no_append ? '' : path)
    " make sure there aren't any double spaces in the cmd
    let fullcmd = join(split(_fullcmd))
    if !using_stderr
        if neoformat#utils#should_be_verbose()
            let stderr_log = expand(tmp_dir . '/stderr.log')
            let fullcmd = fullcmd . ' 2> ' . stderr_log
        else
            if (has('win32') || has('win64'))
                let stderr_log = ''
                let fullcmd = fullcmd . ' 2> ' . 'NUL'
            else
                let stderr_log = ''
                let fullcmd = fullcmd . ' 2> ' . '/dev/null'
            endif
        endif
    endif

    return {
        \ 'exe':       fullcmd,
        \ 'stdin':     using_stdin,
        \ 'stderr_log': stderr_log,
        \ 'name':      a:definition.exe,
        \ 'replace':   get(a:definition, 'replace', 0),
        \ 'tmp_file_path': path,
        \ 'valid_exit_codes': get(a:definition, 'valid_exit_codes', [0]),
        \ }
endfunction

function! s:expand_fully(string) abort
    return substitute(a:string, '%\(:[a-z]\)*', '\=expand(submatch(0))', 'g')
endfunction

function! s:basic_format() abort
    call neoformat#utils#log('running basic format')
    if !exists('g:neoformat_basic_format_align')
        let g:neoformat_basic_format_align = 0
    endif

    if !exists('g:neoformat_basic_format_retab')
        let g:neoformat_basic_format_retab = 0
    endif

    if !exists('g:neoformat_basic_format_trim')
        let g:neoformat_basic_format_trim = 0
    endif

    if neoformat#utils#var('neoformat_basic_format_align')
        call neoformat#utils#log('aligning with basic formatter')
        let v = winsaveview()
        silent! execute 'normal gg=G'
        call winrestview(v)
    endif
    if neoformat#utils#var('neoformat_basic_format_retab')
        call neoformat#utils#log('converting tabs with basic formatter')
        retab
    endif
    if neoformat#utils#var('neoformat_basic_format_trim')
        call neoformat#utils#log('trimming whitespace with basic formatter')
        " http://stackoverflow.com/q/356126
        let search = @/
        let view = winsaveview()
        " vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect
        silent! %s/\s\+$//e
        " vint: +ProhibitCommandRelyOnUser +ProhibitCommandWithUnintendedSideEffect
        let @/=search
        call winrestview(view)
    endif
endfunction
