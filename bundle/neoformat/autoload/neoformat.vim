"=============================================================================
" neoformat.vim --- A Neovim plugin for formatting
" Copyright (c) 2016-2021 Steve Dignam
" Copyright (c) 2022 Eric Wong
" Author: Eric Wong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Set global flag to allow checking in custom user config
let g:neoformat = 1

" @todo update `:h neoformat`
" https://github.com/sbdchd/neoformat/blob/f1b6cd506b72be0a2aaf529105320ec929683920/doc/neoformat.txt

""
" @section Introduction, intro
" @library
" @order intro commands config adding-new-formatter managing-undo-history supported-filetypes
" A [Neovim](https://neovim.io) and Vim8 plugin for formatting code.
"
" *Neoformat* uses a variety of formatters for many filetypes. Currently, Neoformat
" will run a formatter using the current buffer data, and on success it will
" update the current buffer with the formatted text. On a formatter failure,
" Neoformat will try the next formatter defined for the filetype.
"
" By using `getbufline()` to read from the current buffer instead of file,
" Neoformat is able to format your buffer without you having to `:w` your file first.
" Also, by using `setline()`, marks, jumps, etc. are all maintained after formatting.
"
" Neoformat supports both sending buffer data to formatters via stdin, and also
" writing buffer data to `/tmp/` for formatters to read that do not support input
" via stdin.


""
" @section MANAGING UNDO HISTORY, managing-undo-history
" If you use an |autocmd| to run Neoformat on save, and you have your editor
" configured to save automatically on |CursorHold| then you might run into
" problems reverting changes. Pressing |u| will undo the last change made by
" Neoformat instead of the change that you made yourself - and then Neoformat
" will run again redoing the change that you just reverted. To avoid this
" problem you can run Neoformat with the Vim |undojoin| command to put changes
" made by Neoformat into the same |undo-block| with the preceding change. For
" example:
"
" >
"     augroup fmt
"       autocmd!
"       autocmd BufWritePre * undojoin | Neoformat
"     augroup END
" <
"
" When |undojoin| is used this way pressing |u| will "skip over" the Neoformat
" changes - it will revert both the changes made by Neoformat and the change
" that caused Neoformat to be invoked.

""
" @section ADDING A NEW FORMATTER, adding-new-formatter
" Note: you should replace everything `{{ }}` accordingly
"
" 1. Create a file in `autoload/neoformat/formatters/{{ filetype }}.vim` if it does not
"    already exist for your filetype.
"
" 2. Follow the following format
"
" See Config above for options
" >
"     function! neoformat#formatters#{{ filetype }}#enabled() abort
" 	return ['{{ formatter name }}', '{{ other formatter name for filetype }}']
"     endfunction
"
"     function! neoformat#formatters#{{ filetype }}#{{ formatter name }}() abort
" 	return {
" 	    \ 'exe': '{{ formatter name }}',
" 	    \ 'args': ['-s 4', '-q'],
" 	    \ 'stdin': 1
" 	    \ }
"     endfunction
"
"     function! neoformat#formatters#{{ filetype }}#{{ other formatter name }}() abort
"       return {'exe': {{ other formatter name }}
"     endfunction
" <
" 3. Update `README.md` and `doc/neoformat.txt`

""
" @section Configuration, config
" Define custom formatters.
"
" Options:
" 1. `exe`: the name the formatter executable in the path, required
" 2. `args`: list of arguments, default: [], optional
" 3. `replace`: overwrite the file, instead of updating the buffer, default: 0, optional
" 4. `stdin`: send data to the stdin of the formatter, default 0, optional
" 5. `stderr`: used to specify whether stderr output should be read along with
" 	 the stdin, otherwise redirects stderr to `stderr.log` file in neoformat's
" 	 temporary directory, default 0, optional
" 6. `no_append`: do not append the `path` of the file to the formatter command,
" 	 used when the `path` is in the middle of a command, default: 0, optional
" 7. `env`: list of environment variables to prepend to the command, default: [], optional
" 8. `valid_exit_codes`: list of valid exit codes for formatters who do not
"    respect common unix practices, default is [0], optional
" 9. `try_node_exe`: attempt to find `exe` in a `node_modules/.bin` directory
"    in the current working directory or one of its parents (requires setting
"    `g:neoformat_try_node_exe`), default: 0, optional
" 10. `output_encode`: set the output encoding of formatter, default is `utf-8`
"
" Example:
"
" Define custom formatters.
" >
"     let g:neoformat_python_autopep8 = {
"             \ 'exe': 'autopep8',
"             \ 'args': ['-s 4', '-E'],
"             \ 'replace': 1 " replace the file, instead of updating buffer (default: 0),
"             \ 'stdin': 1, " send data to stdin of formatter (default: 0)
"             \ 'valid_exit_codes': [0, 23],
"             \ 'no_append': 1,
"             \ }
"
"     let g:neoformat_enabled_python = ['autopep8']
" <
" Have Neoformat use &formatprg as a formatter
" >
"     let g:neoformat_try_formatprg = 1
" <
" Enable basic formatting when a filetype is not found. Disabled by default.
" >
"     " Enable alignment globally
"     let g:neoformat_basic_format_align = 1
"
"     " Enable tab to spaces conversion globally
"     let g:neoformat_basic_format_retab = 1
"
"     " Enable trimmming of trailing whitespace globally
"     let g:neoformat_basic_format_trim = 1
"
" Run all enabled formatters (by default Neoformat stops after the first
" formatter succeeds)
"
"     let g:neoformat_run_all_formatters = 1
"
" Above options can be activated or deactivated per buffer. For example:
"
"     " runs all formatters for current buffer without tab to spaces conversion
"     let b:neoformat_run_all_formatters = 1
"     let b:neoformat_basic_format_retab = 0
"
" Have Neoformat only msg when there is an error
" >
"     let g:neoformat_only_msg_on_error = 1
" <
" When debugging, you can enable either of following variables for extra logging.
" >
"     let g:neoformat_verbose = 1 " only affects the verbosity of Neoformat
"     " Or
"     let &verbose            = 1 " also increases verbosity of the editor as a whole
" <
" Have Neoformat look for a formatter executable in the `node_modules/.bin`
" directory in the current working directory or one of its parents (only applies
" to formatters with `try_node_exe` set to `1`):
" >
"     let g:neoformat_try_node_exe = 1
" <



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
            if empty(cmd.tmp_file_path)
                call neoformat#utils#log('tmp file name is empty, skipped!')
                return
            else
                call writefile(stdin, cmd.tmp_file_path)
                let stdout = split(system(cmd.exe), '\n')
            endif
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

                if cmd.output_encode != 'utf-8'
                    let new_buffer = map(new_buffer, 'iconv(v:val, "cp936", "utf-8")')
                endif

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

function! s:get_node_exe(exe) abort
    let node_exe = findfile('node_modules/.bin/' . a:exe, getcwd() . ';')
    if !empty(node_exe) && executable(node_exe)
        return node_exe
    endif

    return a:exe
endfunction

function! s:generate_cmd(definition, filetype) abort
    let executable = get(a:definition, 'exe', '')
    let output_encode = get(a:definition, 'output_encode', 'utf-8')
    if executable == ''
        call neoformat#utils#log('no exe field in definition')
        return {}
    endif

    if exists('g:neoformat_try_node_exe')
                \ && g:neoformat_try_node_exe
                \ && get(a:definition, 'try_node_exe', 0)
        let executable = s:get_node_exe(executable)
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
        \ 'output_encode' : output_encode,
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

""
" @section Supported filetypes, supported-filetypes
" This is a list of default formatters.

