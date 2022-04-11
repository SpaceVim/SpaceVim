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
    let mysid='<SNR>' . g:org_sid . '_'
    nnoremap <silent> <buffer> <localleader>ag :call OrgAgendaDashboard()<cr>
    nnoremap <silent> <buffer> <localleader>et :call OrgTagsEdit()<cr>
    nnoremap <silent> <buffer> <localleader>ci :call OrgClockIn()<cr>
    nnoremap <silent> <buffer> <localleader>co :call OrgClockOut()<cr>
    nnoremap <silent> <buffer> <localleader>d  :call OrgDateDashboard()<cr>
    nnoremap <silent> <buffer> <localleader>t  :call OrgTodoDashboard()<cr>
    nnoremap <silent> <buffer> <localleader>a  :call DoRefile(['_archive'],[line('.')])<cr>
    "nnoremap <silent> <buffer> <localleader><tab>  :call {mysid}ToFromAgenda()<cr>
    nnoremap <silent> <buffer> <localleader><tab>  :call {mysid}ToFromAgenda()<cr>
    "nnoremap <silent> <buffer> q  :sign unplace * | quit<cr>
    nnoremap <silent> <buffer> q  :call OrgQuitAgenda()<cr>

    nmap <buffer> <silent> <s-CR>       :call {mysid}AgendaReplaceTodo()<CR>
    nmap <silent> <buffer> <c-CR>       :MyAgendaToBuf<CR>
    nmap <silent> <buffer> <CR>         :AgendaMoveToBuf<CR>
    nmap <silent> <buffer> ,r           :call OrgRunCustom({'redo_num': line('.'), 'type':'tags-todo', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> >>           :call OrgAgendaDateInc('++1d')<CR>
    nmap <silent> <buffer> <<           :call OrgAgendaDateInc('--1d')<CR>
    nmap <silent> <buffer> <localleader>t    :call OrgTodoDashboard()<CR>
    nmap <silent> <buffer> <s-right>    :silent call {mysid}AgendaReplaceTodo()<CR>
    
    nmap <silent> <buffer> <s-left>     :silent call {mysid}AgendaReplaceTodo('todo-bkwd')<CR>
    nmap <silent> <buffer> <space>      :call {mysid}ToggleHeadingMark(line('.'))<CR>
    nmap <silent> <buffer> <c-space>    :call {mysid}DeleteHeadingMarks()<CR>
    nmap <silent> <buffer> ,R           :call OrgRefileDashboard()<CR>
    nmap <silent> <buffer> <tab>        :call {mysid}OrgAgendaTab()<CR>

    "if a:search_type ==? 'agenda_todo'
    "    nmap <buffer> r :call OrgRunSearch(g:org_search_spec,'agenda_todo')<cr>
    "endif

    " lines below are from date searches
    nmap <silent> <buffer> v. :call OrgRunCustom({'redo_num': line('.'), 'type':'agenda', 'agenda_date': strftime("%Y-%m-%d"), 'agenda_duration':'d', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> vd :call OrgRunCustom({'redo_num': line('.'), 'type':'agenda', 'agenda_date': g:agenda_startdate, 'agenda_duration':'d', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> vw :call OrgRunCustom({'redo_num': line('.'), 'type':'agenda', 'agenda_date': g:agenda_startdate, 'agenda_duration':'w', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> vm :call OrgRunCustom({'redo_num': line('.'), 'type':'agenda', 'agenda_date': g:agenda_startdate, 'agenda_duration':'m', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> vy :call OrgRunCustom({'redo_num': line('.'), 'type':'agenda', 'agenda_date': g:agenda_startdate, 'agenda_duration':'y', 'spec': g:org_search_spec})<CR>
    nmap <silent> <buffer> f :<C-U>call OrgAgendaMove('forward',v:count1)<cr>
    nmap <silent> <buffer> b :<C-U>call OrgAgendaMove('backward',v:count1)<cr>
    
    nmap <buffer> <silent> <tab> :call {mysid}OrgAgendaTab()<CR>
    "nmap <silent> <buffer> <s-CR> :call OrgAgendaGetText(1)<CR>
    nmap <silent> <buffer> r :call OrgRefreshCalendarAgenda()<CR>


function! OrgQuitAgenda()
    sign unplace *
    bw
    call clearmatches()
    let b:v.chosen_agenda_heading = 0
    if bufnr('ColHeadBuffer') > -1
	"main window has column headings window that
	"is now showing a blank buffer line, push back up . . .
	resize 100
    endif
    "quit
endfunction
   
