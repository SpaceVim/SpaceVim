" File:        coveragepy.vim
" Description: Displays coverage reports from Ned Batchelder's excellent
"              coverage.py tool
"              (see: http://nedbatchelder.com/code/coverage )
" Maintainer:  Alfredo Deza <alfredodeza AT gmail.com>
" License:     MIT
"============================================================================


if exists("g:loaded_coveragepy") || &cp
  finish
endif

function! s:HasCoverage() abort
    if (g:coveragepy_executable != "")
        return
    endif
    let executable_list = ["coverage", "python-coverage", "python3-coverage", "python2-coverage", "python2.7-coverage"]
    for executable_name in executable_list
        if (executable(executable_name) == 1)
		let g:coveragepy_executable = executable_name
		break
        endif
    endfor
    if (g:coveragepy_executable == "")
        echoerr("This plugin needs coverage.py installed and accessible")
    endif
endfunction

" Global variables for registering next/previous error
let g:coveragepy_last_session  = ""
let g:coveragepy_marks         = []
let g:coveragepy_session_map   = {}
let g:coveragepy_executable    = ""


function! s:ToggleSigns()

    if exists("b:coveragepy_is_displaying") && b:coveragepy_is_displaying
        call s:ClearSigns()
        let b:coveragepy_is_displaying = 0
    else
        call s:HighlightMissing()
    endif
endfunction


function! s:CoveragepySyntax() abort
  let b:current_syntax = 'Coveragepy'
  syn match CoveragepyTitleDecoration      "\v\-{2,}"
  syn match CoveragepyHeaders              '\v(^Name\s+|\s*Stmts\s*|\s*Miss\s+|Cover|Missing$)'
  syn match CoveragepyDelimiter            "\v^(\-\-)\s+"
  syn match CoveragepyPercent              "\v(\d+\%\s+)"
  syn match CoveragepyLineNumbers          "\v(\s*\d+,|\d+-\d+,|\d+-\d+$|\d+$)"

  hi def link CoveragepyFiles              Number
  hi def link CoveragepyHeaders            Comment
  hi def link CoveragepyTitleDecoration    Keyword
  hi def link CoveragepyDelimiter          Comment
  hi def link CoveragepyPercent            Boolean
  hi def link CoveragepyLineNumbers        Error
endfunction


function! s:Echo(msg, ...) abort
    redraw!
    let x=&ruler | let y=&showcmd
    set noruler noshowcmd
    if (a:0 == 1)
        echo a:msg
    else
        echohl WarningMsg | echo a:msg | echohl None
    endif

    let &ruler=x | let &showcmd=y
endfun

function! s:FindCoverage() abort
    let found = findfile(".coverage", ".;")
    if (found !~ '.coverage')
        return ""
    endif
    " Return the actual directory where .coverage is found
    return fnamemodify(found, ":h")
endfunction


function! s:ClearSigns() abort
    execute("sign unplace * group=uncovered buffer=".bufnr('%'))
    execute("sign unplace * group=branchuncovered buffer=".bufnr('%'))
endfunction


function! s:SetHighlight()
    if exists('g:coveragepy_uncovered_sign')
      let text = g:coveragepy_uncovered_sign
    else
      let text = '^'
    endif
    highlight default NoCoverage ctermfg=red guifg=#ef0000
    highlight default NoBranchCoverage ctermfg=yellow guifg=#ebef00

    execute 'sign define uncovered text=' . text . ' texthl=NoCoverage'
    execute 'sign define branchuncovered text=' . text . ' texthl=NoBranchCoverage'

endfunction


function! s:HighlightMissing() abort
    call s:SetHighlight()
    let b:coveragepy_is_displaying = 1
    if (g:coveragepy_session_map == {})
        call s:CoveragepyReport()
    endif
    call s:ClearSigns()

    let current_buffer_py = matchlist(expand("%:p"), '\v(.*)(.py)')[0]
    let current_buffer = matchlist(expand("%:p"), '\v(.*)(.py)')[1]

    for path in keys(g:coveragepy_session_map)
        if (current_buffer =~ path) || (current_buffer_py =~ path)
            for position in g:coveragepy_session_map[path]
                execute(":sign place ". position ." line=". position ." group=uncovered name=uncovered buffer=".bufnr("%"))
            endfor
            for position in g:coveragepy_session_map['BRANCH' . path]
                execute(":sign place ". position ." line=". position ." group=branchuncovered name=branchuncovered buffer=".bufnr("%"))
            endfor
            " FIXME: I had to comment this out because it was no longer correct
            " after adding branch support
            "execute g:coveragepy_session_map[path][0]
            redraw!
            return
        endif
    endfor
    call s:Echo("Coveragepy ==> 100% covered", 1)
endfunction


function! s:Strip(input_string) abort
    return split(a:input_string, " ")[0]
endfunction


function! s:Roulette(direction) abort
    let orig_line = line('.')
    let last_line = line('$') - 3

    " if for some reason there is not enough
    " coverage output return
    if last_line < 3
        return
    endif

    " Move to the line we need
    let move_to = orig_line + a:direction

    if move_to > last_line
        let move_to = 3
        exe move_to
    elseif (move_to < 3) && (a:direction == -1)
        let move_to = last_line
        exe move_to
    elseif (move_to < 3) && (a:direction == 1)
        let move_to = 3
        exe move_to
    else
        exe move_to
    endif

    if move_to == 1
        let _num = move_to
    else
        let _num = move_to - 1
    endif
endfunction


function! s:CoveragepyReport() abort
    " Run a report, ignore errors and show missing lines,
    " which is what we are interested after all :)
    let original_dir = getcwd()
    " First try to see if we actually have a .coverage file
    " to work with
    let has_coverage = s:FindCoverage()
    if (has_coverage == "")
        return 0
    else
        " set the original directory path
        " as a global
        let g:coveragepy_path = has_coverage
        " change dir to where coverage is
        " and do all the magic we need
        exe "cd " . has_coverage
        call s:ClearSigns()
        let g:coveragepy_last_session = ""

        " Allow for rcfile
        if exists("g:coveragepy_rcfile")
            let s:coveragepy_rcfile=" --rcfile=".resolve(expand(g:coveragepy_rcfile))
        else
            let s:coveragepy_rcfile=""
        endif

        let cmd = g:coveragepy_executable." report -m -i".s:coveragepy_rcfile
        let out = system(cmd)
        let g:coveragepy_last_session = out
        call s:ReportParse()

        " Finally get back to where we initially where
        exe "cd " . original_dir
        return 1
    endif
endfunction


function! s:ReportParse() abort
    " After coverage runs, parse the content so we can get
    " line numbers mapped to files
    let path_to_lines = {}
    for line in split(g:coveragepy_last_session, '\n')
        if (line =~ '\v(\s*\d+,|\d+-\d+,|\d+-\d+$|\d+$)') && line !~ '\v(100\%)'
            let path         = split(line, ' ')[0]
            let match_split  = split(line, '%')
            let line_nos     = match_split[-1]
            let all_line_nos = s:LineNumberParse(line_nos)
            let all_branch_line_nos = s:BranchLineNumberParse(line_nos)
            let path_to_lines[path] = all_line_nos
            let path_to_lines['BRANCH' . path] = all_branch_line_nos
        endif
    endfor
    let g:coveragepy_session_map = path_to_lines
endfunction


function! s:BranchLineNumberParse(numbers) abort
    " Line numbers will come with a possible comma in them
    " and lots of extra space. Let's remove them and strip them
    let parsed_list = []
    let splitted = split(a:numbers, ',')
    for line_no in splitted
        " only add numbers that are branch-coverage numbers
        if len(split(line_no, '->')) > 1
            if line_no =~ '->-'
              let split_char = '->-'
            else
              let split_char = '->'
            endif
            if line_no =~ '-'
                let split_nos = split(line_no, split_char)
                let first = s:Strip(split_nos[0])
                call add(parsed_list, first)
            else
                call add(parsed_list, s:Strip(line_no))
            endif
        endif
    endfor
    return parsed_list
endfunction

function! s:LineNumberParse(numbers) abort
    " Line numbers will come with a possible comma in them
    " and lots of extra space. Let's remove them and strip them
    let parsed_list = []
    let splitted = split(a:numbers, ',')
    for line_no in splitted
        " only add numbers that are not branch-coverage numbers
        if len(split(line_no, '->')) == 1
            if line_no =~ '-'
                let split_nos = split(line_no, '-')
                let first = s:Strip(split_nos[0])
                let second = s:Strip(split_nos[1])
                for range_no in range(first, second)
                    call add(parsed_list, range_no)
                endfor
            else
                call add(parsed_list, s:Strip(line_no))
            endif
        endif
    endfor
    return parsed_list
endfunction


function! s:ClearAll() abort
    let bufferL = ['LastSession.coveragepy']
    for b in bufferL
        let _window = bufwinnr(b)
        if (_window != -1)
            silent! execute _window . 'wincmd w'
            silent! execute 'q'
        endif
    endfor
endfunction


function! s:LastSession() abort
    call s:ClearAll()
    let winnrback = bufwinnr(expand("%"))
    if (len(g:coveragepy_last_session) == 0)
        call s:CoveragepyReport()
    endif
    let winnr = bufwinnr('LastSession.coveragepy')
    silent! execute  winnr < 0 ? 'botright new ' . 'LastSession.coveragepy' : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number filetype=coveragepy
    let session = split(g:coveragepy_last_session, '\n')
    call append(0, session)
    silent! execute 'resize ' . line('$')
    silent! execute 'normal gg'
    silent! execute 'nnoremap <silent> <buffer> q :q! <CR>'
    nnoremap <silent><script> <buffer> <C-n>   :call <sid>Roulette(1)<CR>
    nnoremap <silent><script> <buffer> <down>  :call <sid>Roulette(1)<CR>
    nnoremap <silent><script> <buffer> j       :call <sid>Roulette(1)<CR>
    nnoremap <silent><script> <buffer> <C-p>   :call <sid>Roulette(-1)<CR>
    nnoremap <silent><script> <buffer> <up>    :call <sid>Roulette(-1)<CR>
    nnoremap <silent><script> <buffer> k       :call <sid>Roulette(-1)<CR>
    nnoremap <silent> <buffer> <Enter>         :call <sid>OpenBuffer()<CR>
    call s:CoveragepySyntax()
    exe winnrback  . 'wincmd w'
endfunction


function! s:OpenBuffer() abort
    let raw_path = split(getline('.'), ' ')[0] . '.py'
    " newer coverage versions use the .py extension, previously it
    " didn't.
    let path = split(raw_path, '.py')[0] . '.py'
    let absolute_path = g:coveragepy_path . '/' . path
    if filereadable(absolute_path)
        execute 'wincmd p'
        silent! execute ":e " . absolute_path
        call s:HighlightMissing()
        execute 'wincmd p'
        call s:CoveragepySyntax()
    else
        call s:Echo("Could not load file: " . path)
    endif
endfunction


function! s:Version() abort
    call s:Echo("coveragepy version 1.1dev", 1)
endfunction


function! s:Completion(ArgLead, CmdLine, CursorPos) abort
    let actions = "report\nshow\nnoshow\nrefresh\nsession\n"
    let extras  = "version\n"
    return actions . extras
endfunction


function! s:Proxy(action, ...) abort
    " Make sure that if we are called, we have coverage installed
    call s:HasCoverage()
    if (a:action == "show")
        call s:ToggleSigns()
    elseif (a:action == "noshow")
        call s:ClearSigns()
    elseif (a:action == "refresh")
        call s:ClearAll()
        let g:coveragepy_session_map = {}
        call s:HighlightMissing()
    elseif (a:action == "session")
        let winnr = bufwinnr('LastSession.coveragepy')
        if (winnr != -1)
                silent! execute 'wincmd b'
                silent! execute 'q'
            return
        else
            call s:LastSession()
        endif
    elseif (a:action == "report")
        let report =  s:CoveragepyReport()
        if report == 1
            call s:LastSession()
            call s:HighlightMissing()
        else
            call s:Echo("No .coverage was found in current or parent dirs")
        endif
    elseif (a:action == "version")
        call s:Version()
    endif
endfunction


command! -nargs=+ -complete=custom,s:Completion Coveragepy call s:Proxy(<f-args>)

