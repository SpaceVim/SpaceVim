" org.vim - VimOrganizer plugin for Vim
" -------------------------------------------------------------
" Version: 0.30
" Maintainer: Herbert Sitz <hesitz@gmail.com>
" Last Change: 2011 Nov 02
"
" Script: http://www.vim.org/scripts/script.php?script_id=3342
" Github page: http://github.com/hsitz/VimOrganizer 
" Copyright: (c) 2010, 2011 by Herbert Sitz
" The VIM LICENSE applies to all files in the
" VimOrganizer plugin.  
" (See the Vim copyright except read "VimOrganizer"
" in places where that copyright refers to "Vim".)
" http://vimdoc.sourceforge.net/htmldoc/uganda.html#license
" No warranty, express or implied.
" *** *** Use At-Your-Own-Risk *** ***

if exists("g:org_autoload_funcs")
	finish
endif

let g:org_autoload_funcs=1

function! org#SetOrgFileType()
        "if expand("%:e") == 'org'
       "if exists("g:syntax_on") | syntax off | else | syntax enable | endif
	"syntax enable
                if &filetype != 'org'
                        execute "set filetype=org"
			
"			if !exists('g:org_todo_setup')
"				let g:org_todo_setup = 'TODO | DONE'
"			endif
"			if !exists('g:org_tag_setup')
"				let g:org_tag_setup = '{home(h) work(w)}'
"			endif
"			
"			call OrgProcessConfigLines()
"			exec "syntax match DONETODO '" . b:v.todoDoneMatch . "' containedin=OL1,OL2,OL3,OL4,OL5,OL6" 
"			exec "syntax match NOTDONETODO '" . b:v.todoNotDoneMatch . "' containedin=OL1,OL2,OL3,OL4,OL5,OL6" 
		
                endif
	
        "endif
	runtime syntax/org.vim
	"syntax enable
        "call OrgSetColors()
endfunction     

function! org#Pad(s,amt)
    return a:s . repeat(' ',a:amt - len(a:s))
endfunction

function! org#Timestamp()
    return strftime("%Y-%m-%d %a %H:%M")
endfunction

function! org#redir(command)
  let save_a = @a
  try 
    silent! redir @a
    silent! exe a:command
    redir END
  finally
    "let res = split(@a,"\n")
    let res = @a

    " restore register
    let @a = save_a
    return res
  endtry
endfunction

function! org#GetGroupHighlight(group)
    " this code was copied and modified from code posted on StackOverflow
    " http://stackoverflow.com/questions/1331213/how-to-modify-existing-highlight-group-in-vim
    " Redirect the output of the "hi" command into a variable
    " and find the highlighting
    redir => GroupDetails
    try
	exe "silent hi " . a:group
    catch
	" skip error message if no such group exists
    endtry
    redir END

    " Resolve linked groups to find the root highlighting scheme
    while GroupDetails =~ "links to"
        let index = stridx(GroupDetails, "links to") + len("links to")
        let LinkedGroup =  strpart(GroupDetails, index + 1)
        redir => GroupDetails
        exe "silent hi " . LinkedGroup
        redir END
    endwhile

    if GroupDetails ># ''
	" Extract the highlighting details (the bit after "xxx")
	let MatchGroups = matchlist(GroupDetails, '\<xxx\>\s\+\(.*\)')
	let ExistingHighlight = MatchGroups[1] !~? 'cleared' ? MatchGroups[1] : ''	
    else
	" Group does not exist
	let ExistingHighlight = ''
    endif

    return ExistingHighlight

endfunction

function! org#ISODateToYWD(date)
    "returns y,w,d which are iso week spec for date
    let date = a:date
    "let d = 1 + ((calutil#dow(date) + 4) % 7)
    let d = 1 + calutil#dow(date)
    let jul_nThur = calutil#jul(date) + 4 - d
    let y = calutil#cal(jul_nThur)[0:3]
    let julJan1 = calutil#jul(date[0:3] . '-01-01')
    let w = 1 + ((jul_nThur - julJan1) / 7)
    return [y,w,d]
endfunction

function! org#LocateFile(filename)
    let filename = a:filename

    if bufwinnr(filename) >= 0
        silent execute bufwinnr(filename)."wincmd w"
    else
        if org#redir('tabs') =~ fnamemodify(filename, ':t')
            " proceed on assumption that file is open
            " if match found in tablist
            let this_tab = tabpagenr()
            let last_tab = tabpagenr('$')
            for i in range(1 , last_tab)
                exec i . 'tabn'
                if bufwinnr(filename) >= 0
                    silent execute bufwinnr(filename)."wincmd w"
                    break
                " if file not found then use tab drop to open new file
                elseif i == last_tab
                    execute 'tab drop ' . filename
                    if (&ft != 'org') && (filename != '__Agenda__')
                        call org#SetOrgFileType()
                    endif
                endif
                tabn
            endfor
        else
            exe 'tabn ' . tabpagenr('$')
            execute 'tab drop ' . filename
            if (&ft != 'org') && (filename != '__Agenda__')
                call org#SetOrgFileType()
            endif
        endif
    endif
    if (&fdm != 'expr') && !exists('g:in_agenda_search')
        set fdm=expr
	set foldlevel=1
    endif

endfunction

function! org#SaveLocation()
    let file_loc = bufname('%') ==? '__Agenda__' ? '__Agenda__' : expand('%:p')
    let g:location = [ file_loc , getpos('.') ]
endfunction
function! org#RestoreLocation()
    if expand('%:p') != g:location[0]
        call org#LocateFile( g:location[0] )
    endif
    call setpos( '.', g:location[1] )
endfunction
    
    
function! org#OpenCaptureFile()
    call org#LocateFile(g:org_capture_file)
endfunction

function! org#CaptureBuffer()
    if !exists('g:org_capture_file') || empty(g:org_capture_file)
        echo 'Capture is not set up.  Please read docs at :h vimorg-capture.'
        return
    endif
    if bufnr('_Org_Capture_') > 0
	exec 'bwipeout! ' . bufnr('_Org_Capture_')
    endif
    sp _Org_Capture_
    autocmd BufWriteCmd <buffer> :call <SID>ProcessCapture() 
    "autocmd BufLeave <buffer> :bwipeout
    autocmd BufUnload <buffer> :set nomodified
    set nobuflisted
    set ft=org
    setlocal buftype=acwrite
    setlocal noswapfile
    command! -buffer W :call <SID>ProcessCapture()
    " below is the basic template
    " a first level head with date timestamp
    normal ggVGd
    normal i* 
    silent exec "normal o:<".org#Timestamp().">"
    normal gg
    set nomodified
    startinsert!
    
endfunction
function! s:ProcessCapture()
    "normal ggVG"xy
    let curbufnr = bufnr(g:org_capture_file)
    " check if capture file is already open or not
    if curbufnr == -1
        exe '1,$write >> ' . g:org_capture_file
        bw! _Org_Capture_
    else
        normal ggVG"xy
        bw! _Org_Capture_
        call org#SaveLocation()
        call org#LocateFile(g:org_capture_file)
        normal G"xp
        silent write
        call org#RestoreLocation()
    endif
    exe 'bwipeout! ' . g:org_capture_file
   
endfunction

function! s:Pre0(s)
    return repeat('0',2 - len(a:s)) . a:s
endfunction
function! org#randomData()

    let date = string((2009 + org#util#random(3) - 1)).'-'.s:Pre0(org#util#random(12)).'-'.s:Pre0(org#util#random(28))
    let dstring = ''
    if org#util#random(3) == 3
        let dstring = date. ' ' . calutil#dayname(date)
    else
        let dstring = date. ' ' . calutil#dayname(date).' '.s:Pre0(org#util#random(23)).':'.s:Pre0((org#util#random(12)-1)*5)
    endif
    if org#util#random(6) == 6
        let dstring .= ' +'.org#util#random(4).['d','w','m'][org#util#random(3)-1]
    endif
    return '<'.dstring.'>'
    "if a:date_type != ''
    "    call s:SetProp(a:date_type,date)
    "else
    "    silent execute "normal A".date
    "endif
endfunction
