" PlantUML Live Preview for ascii/unicode art
" @Author: Martin Grenfell <martin.grenfell@gmail.com>
" @Date: 2018-12-07 13:00:22
" @Last Modified by: Tsuyoshi CHO <Tsuyoshi.CHO@Gmail.com>
" @Last Modified time: 2018-12-08 00:02:38
" @License: WTFPL
" PlantUML preview plugin core

" Intro  {{{1
if exists("g:autoloaded_slumlord")
  finish
endif
let g:autoloaded_slumlord = 1

let s:save_cpo = &cpo
set cpo&vim

" variable {{{1
let g:slumlord_plantuml_jar_path = get(g:, 'slumlord_plantuml_jar_path', expand("<sfile>:p:h") . "/../plantuml.jar")
let g:slumlord_plantuml_include_path = get(g:, 'slumlord_plantuml_include_path', expand("~/.config/plantuml/include/"))
let g:slumlord_asciiart_utf = get(g:, 'slumlord_asciiart_utf', 1)

" function {{{1
function! slumlord#updatePreview(args) abort
    if !s:shouldInsertPreview()
        return
    end

    let charset = 'UTF-8'

    let type = 'utxt'
    let ext  = 'utxt'
    if !g:slumlord_asciiart_utf
      let type = 'txt'
      let ext  = 'atxt'
    endif

    let tmpfname = tempname()
    call s:mungeDiagramInTmpFile(tmpfname)
    let b:slumlord_preview_fname = fnamemodify(tmpfname,  ':r') . '.' . ext

    let cmd = "java -Dapple.awt.UIElement=true -Dplantuml.include.path=\"". g:slumlord_plantuml_include_path ."\" -splash: -jar ". g:slumlord_plantuml_jar_path ." -charset ". charset ." -t" . type ." ". tmpfname

    let write = has_key(a:args, 'write') && a:args["write"] == 1
    if exists("*jobstart")
        call jobstart(cmd, { "on_exit": function("s:asyncHandlerAdapter"), "write": write, "bufnr": bufnr("") })
    elseif exists("*job_start")
        call job_start(cmd, { "exit_cb": {job,st->call('s:asyncHandlerAdapter',[job,st,0],{"bufnr": bufnr(""),"write": write})}, "out_io": "buffer", "out_buf": bufnr("") })
    else
        call system(cmd)
        if v:shell_error == 0
            call s:updater.update(a:args)
        endif
    endif
endfunction

function! s:shouldInsertPreview() abort
    "check for 'no-preview flag
    if search('^\s*''no-preview', 'wn') > 0
        return
    endif

    "check for state diagram
    if search('^\s*\[\*\]', 'wn') > 0
        return
    endif

    "check for use cases
    if search('^\s*\%((.*)\|:.*:\)', 'wn') > 0
        return
    endif

    "check for class diagrams
    if search('^\s*class\>', 'wn') > 0
        return
    endif

    "check for activity diagrams
    if search('^\s*:.*;', 'wn') > 0
        return
    endif

    return 1
endfunction

function! s:asyncHandlerAdapter(job_id, data, event) abort dict
    if a:data != 0
        return 0
    endif

    if bufnr("") != self.bufnr
        return 0
    endif

    call s:updater.update(self)
endfunction

function! s:readWithoutStoringAsAltFile(fname) abort
    let oldcpoptions = &cpoptions
    set cpoptions-=a
    exec 'read' a:fname
    let &cpoptions = oldcpoptions
endfunction

function! s:mungeDiagramInTmpFile(fname) abort
    call writefile(getline(1, '$'), a:fname)
    call s:convertNonAsciiSupportedSyntax(a:fname)
endfunction

function! s:convertNonAsciiSupportedSyntax(fname) abort
    exec 'sp' a:fname

    /@startuml/,/@enduml/s/^\s*\(boundary\|database\|entity\|control\)/participant/e
    /@startuml/,/@enduml/s/^\s*\(end \)\?\zsref\>/note/e
    /@startuml/,/@enduml/s/^\s*ref\>/note/e
    /@startuml/,/@enduml/s/|||/||4||/e
    /@startuml/,/@enduml/s/\.\.\.\([^.]*\)\.\.\./==\1==/e
    write

    bwipe!
endfunction

function! s:removeLeadingWhitespace(...) abort
    let opts = a:0 ? a:1 : {}

    let diagramEnd = get(opts, 'diagramEnd', line('$'))

    let smallestLead = 100

    for i in range(1, diagramEnd-1)
        let lead = match(getline(i), '\S')
        if lead >= 0 && lead < smallestLead
            let smallestLead = lead
        endif
    endfor

    exec '1,' . diagramEnd . 's/^ \{'.smallestLead.'}//e'
endfunction

function! s:addTitle() abort
    let lnum = search('^title ', 'n')
    if !lnum
        return
    endif

    let title = substitute(getline(lnum), '^title \(.*\)', '\1', '')

    call append(0, "")
    call append(0, repeat("^", strdisplaywidth(title)+6))
    call append(0, "   " . title)
endfunction

" InPlaceUpdater object {{{1
let s:InPlaceUpdater = {}
let s:InPlaceUpdater.divider = "@startuml"

function! s:InPlaceUpdater.update(args) abort
    let startLine = line(".")
    let lastLine = line("$")
    let startCol = col(".")

    call self.__deletePreviousDiagram()
    call self.__insertDiagram(b:slumlord_preview_fname)
    call s:addTitle()

    call cursor(line("$") - (lastLine - startLine), startCol)

    if a:args['write']
        noautocmd write
    endif
endfunction

function! s:InPlaceUpdater.__deletePreviousDiagram() abort
    if self.__dividerLnum() > 1
        exec '0,' . (self.__dividerLnum() - 1) . 'delete _'
    endif
endfunction

function! s:InPlaceUpdater.__insertDiagram(fname) abort
    call append(0, "")
    call append(0, "")
    0

    call s:readWithoutStoringAsAltFile(a:fname)

    "fix trailing whitespace
    exec '1,' . self.__dividerLnum() . 's/\s\+$//e'

    call s:removeLeadingWhitespace()
endfunction

function! s:InPlaceUpdater.__dividerLnum() abort
    return search(self.divider, 'wn')
endfunction

" WinUpdater object {{{1
let s:WinUpdater = {}
function! s:WinUpdater.update(args) abort
    let fname = b:slumlord_preview_fname
    call self.__moveToWin()
    %d

    call append(0, "")
    call append(0, "")
    0

    call s:readWithoutStoringAsAltFile(fname)

    "fix trailing whitespace
    %s/\s\+$//e

    call s:removeLeadingWhitespace()
    call s:addTitle()
    wincmd p
endfunction

function s:WinUpdater.__moveToWin() abort
    if exists("b:slumlord_bnum") && bufexists(b:slumlord_bnum)
        if bufwinnr(b:slumlord_bnum) != -1
            exec bufwinnr(b:slumlord_bnum) . "wincmd w"
        else
            exec b:slumlord_bnum . "sb"
        endif
    else
        let prev_bnum = bufnr("")
        new
        setlocal buftype=nofile
        setlocal bufhidden=wipe
        setlocal noswapfile
        setlocal textwidth=0 " avoid automatic line break
        call setbufvar(prev_bnum, "slumlord_bnum", bufnr(""))
        call self.__setupWinOpts()
    endif
endfunction

function s:WinUpdater.__setupWinOpts() abort
    setl nowrap
    setl buftype=nofile
    syn match plantumlPreviewBoxParts #[┌┐└┘┬─│┴<>╚═╪╝╔═╤╪╗║╧╟╠╣]#
    syn match plantumlPreviewCtrlFlow #\(LOOP\|ALT\|OPT\)[^│]*│\s*[a-zA-Z0-9?! ]*#
    syn match plantumlPreviewCtrlFlow #║ \[[^]]*\]#hs=s+3,he=e-1
    syn match plantumlPreviewEntity #│\w*│#hs=s+1,he=e-1
    syn match plantumlPreviewTitleUnderline #\^\+#
    syn match plantumlPreviewNoteText #║[^┌┐└┘┬─│┴<>╚═╪╝╔═╤╪╗║╧╟╠╣]*[░ ]║#hs=s+1,he=e-2
    syn match plantumlPreviewDividerText #╣[^┌┐└┘┬─│┴<>╚═╪╝╔═╤╪╗║╧╟╣]*╠#hs=s+1,he=e-1
    syn match plantumlPreviewMethodCall #\(\(│\|^\)\s*\)\@<=[a-zA-Z_]*([[:alnum:],_ ]*)# 
    syn match plantumlPreviewMethodCallParen #[()]# containedin=plantumlPreviewMethodCall contained

    hi def link plantumlPreviewBoxParts normal
    hi def link plantumlPreviewCtrlFlow Keyword
    hi def link plantumlPreviewLoopName Statement
    hi def link plantumlPreviewEntity Statement
    hi def link plantumlPreviewTitleUnderline Statement
    hi def link plantumlPreviewNoteText Constant
    hi def link plantumlPreviewDividerText Constant
    hi def link plantumlPreviewMethodCall plantumlText
    hi def link plantumlPreviewMethodCallParen plantumlColonLine
endfunction


" other shit {{{1
if exists("g:slumlord_separate_win") && g:slumlord_separate_win
    let s:updater = s:WinUpdater
else
    let s:updater = s:InPlaceUpdater
endif

" Outro {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set fdm=marker:
