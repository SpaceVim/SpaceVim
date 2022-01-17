function! s:AmtDone(lineno) dict
   "use list_dict structure to calculate 
   "amount done for node at lineno
   let mysum = 0
   let mycount = 0
   if (len(self[a:lineno].c) == 0) && ( get(self[a:lineno],'ckbox') )
       " just check val for current line
       let mysum = get(self[a:lineno],'ckval',0)
       let mycount = 1
   else
       " sum vals for this item's immediate children
       for item in self[a:lineno].c
 	  if get(self[item],'ckbox') == 1
 	      let mysum += (get(self[item],'ckval',' ') == 'X')
 	      let mycount += 1
 	  endif
       endfor
   endif
   return [ mysum , mycount ]
endfunction

function! orgcheck#ToggleCheck()
    call s:MakeListDict()
    let linetext = getline(line('.'))
    let curval = matchstr(linetext,' \[\zs.\ze\]')
    let has_checkbox = match(linetext, '^\s* [-\+\*] \[.\]') > -1 
    if curval == 'X'
        call s:ClearCheck()
    elseif !has_checkbox
	" give this list item a checkbox if it has none
        let part1 = matchstr(linetext,'^\s* [-\+\*] ')
        let part2 = matchstr(linetext,'^\s* [-\+\*] \zs.*')
	call setline(line('.'),part1 . '[ ] ' . part2)
	" need to redo dict after checkbox added
	call s:MakeListDict()
    else
        call s:SetCheck()
    endif
    call s:UpdateCheckSummaries()
endfunction

function! orgcheck#UpdateSummaries()
    call s:MakeListDict()
    call s:UpdateCheckSummaries()
endfunction

function! s:SetCheck()
    let save_pos = getpos('.')
    exec 's/\[\zs.\ze\]/X/e'
    let g:list_dict[line('.')].ckval = 'X'
    " also set children, if any
    for line in g:list_dict[line('.')].c
        exec line
        call s:SetCheck()
    endfor
    call setpos('.', save_pos)
endfunction

function! s:ClearCheck()
    let save_pos = getpos('.')
    exec 's/\[\zs.\ze\]/ /e'
    let g:list_dict[line('.')].ckval = ' '
    " also clear children, if any
    for line in g:list_dict[line('.')].c
        exec line
        call s:ClearCheck()
    endfor
    call setpos('.', save_pos)
endfunction

function! s:UpdateCheckSummaries(...)
" updates summaries (i.e., (x/x)) for list checkbox
" lines from beginning of list to current line
   if a:0 > 0 | let lineno = a:1 | endif
   let save_pos = getpos('.')
   let this_line = line('.')
   func! s:CheckCompare(i1, i2) 
       return a:i2 - a:i1
   endfunc
   " get reversed list of lines
   let list_lines = copy(sort(keys(g:list_dict),"s:CheckCompare"))
   if a:0 > 0 
       call s:UpdateListLine(key)
   else
      for key in list_lines
          call s:UpdateListLine(key)
      endfor
   endif
   call setpos('.',save_pos)
endfunction

function! s:DoHeadingUpdate()
     exec 'let lineno =<SNR>' . g:org_sid . '_OrgGetHead()'  
     if lineno == 0 | return | endif
     exec lineno
     " delete existing stats, if any
     exec 's/ \[\d\+\/\d\+\]\s*$//e'
     " now put new stats in
     let stats = g:list_dict.AmtDone(0)
     let new_summary = ' [' . stats[0] . '\/' . stats[1] . ']'
     exec 's/$/' . new_summary . '/'
endfunction

function! s:UpdateListLine(key)
      let key = a:key
      if str2nr(key) > 0
         let  parent = get(g:list_dict[key], 'p', 0)  
	 if parent > 0
	     call s:UpdateListLine(parent)
	 endif
      endif
      if key == 'AmtDone' | return | endif
      if key == '0'
	 " put amtdone on heading and return 
         call s:DoHeadingUpdate()
	 return
      else
         exec key
      endif
      "delete current summary, if any
      :s/\s*\[\d\+\/\d\+\]\s*$//e
      " and put new summary on
      let stats = g:list_dict.AmtDone(key)
      let new_summary = ' [' . stats[0] . '\/' . stats[1] . ']'
      if match(new_summary,'\/[01]\]') > -1 | return | endif
      exec 's/$/' . new_summary . '/'
      if stats[0] == 0
	  exec 's/\[\zs.\ze\]/ /e'
	  let g:list_dict[key].ckval = ' '
      elseif stats[0] == stats[1]
	  exec 's/\[\zs.\ze\]/X/e'
	  let g:list_dict[key].ckval = 'X'
      else
	  exec 's/\[\zs.\ze\]/-/e'
	  let g:list_dict[key].ckval = '-'
      endif
endfunction

function! s:MakeListDict()
       let save_pos = getpos('.')
       let list_dict = {'AmtDone':function('s:AmtDone'), 0:{'c':[], 'indent':0}}
       let list_pat = '^\s* [-\+\*] *' 
       let item_stack = [ 0 ]
       let last_indent = 0

       ?\(^\s*$\|^\*\)?+1
       while 1
	   let lineno = line('.')
	   let linetext = getline(lineno)
           let start_indent = len(matchstr(linetext, list_pat))
           let is_list_item = match(linetext, list_pat) > -1 
           let has_checkbox = match(linetext, '^\s* [-\+\*] \[.\]') > -1 
	    
	   if (linetext =~ '^\s*$') 
	       break
	   elseif is_list_item  
	       let list_dict[lineno] = { 'ckbox':has_checkbox, 'c':[] }
	       let this_indent = len(matchstr(linetext, list_pat))
	       let list_dict[lineno].indent = this_indent
	       if this_indent < start_indent
                   break
               endif
	       if has_checkbox && (matchstr(linetext,'^\s* [-\+\*] [\zsX\ze') == 'X')
                    let list_dict[lineno].ckval = 'X'
               endif
	       if this_indent > last_indent
		   let list_dict[lineno].p = item_stack[-1]
		    call add(list_dict[item_stack[-1]].c, lineno)
		    call add(item_stack, lineno)
	       elseif this_indent <= last_indent
		    while list_dict[item_stack[-1]].indent > this_indent
			unlet item_stack[-1]
		    endwhile
		    let item_stack[-1] = lineno
		    let list_dict[lineno].p = item_stack[-2]
		    call add(list_dict[item_stack[-2]].c, lineno)
	       endif
	   endif
	   let last_indent = this_indent
	   exec lineno + 1
        endwhile
	let g:list_dict = list_dict
	call setpos('.', save_pos)
endfunction

