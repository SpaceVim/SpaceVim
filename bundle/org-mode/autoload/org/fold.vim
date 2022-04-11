function! org#fold#level(line)
    if g:org_folds == 0
        return 0
    endif

    if exists('w:sparse_on')
                \ && w:sparse_on
                \ && (get(s:sparse_lines, a:line) == 1)
        if index(b:v.sparse_list, a:line + 1) >= 0
            return '<0'
        endif
        let sparse = index(b:v.sparse_list, a:line)
        if sparse >= 0
            return '>99'
        endif
        let sparse = index(b:v.fold_list, a:line)
        if sparse >= 0
            return '<0' 
        endif
    endif

    
    let [l:text, l:nexttext] = getline(a:line, a:line+1)
    
    if l:text =~ '^\*\+\s'
        let b:v.myAbsLevel = s:Ind(a:line)
    elseif (b:v.lasttext_lev ># '') && (l:text !~ s:remstring) && (l:nexttext !~ '^\*\+\s') && (b:v.lastline == a:line - 1)
    "elseif (b:v.lasttext_lev ># '') && (l:text !~ s:remstring) && (l:nexttext !~ '^\*\+\s\|^\s*:SYNOPSIS:') && (b:v.lastline == a:line - 1)
    "if (b:v.lasttext_lev ># '') && (l:text !~ s:remstring) && (l:nexttext !~ '^\*\+\s') && (b:v.lastline == a:line - 1)
        let b:v.lastline = a:line
        return b:v.lasttext_lev
    endif
    let l:nextAbsLevel = s:Ind(a:line + 1)

    if l:text =~ '^\*\+\s'
        " we're on a heading line
        let b:v.lasttext_lev = ''
        "let b:v.myAbsLevel = s:Ind(a:line)
        
        if l:nexttext =~ b:v.drawerMatch
            let b:v.lev = '>' . string(b:v.myAbsLevel + 4)
        elseif l:nexttext =~ s:remstring
            let b:v.lev = '>' . string(b:v.myAbsLevel + 6)
        elseif (l:nexttext !~ b:v.headMatch) && (a:line != line('$'))
            let b:v.lev = '>' . string(b:v.myAbsLevel + 3)
        elseif l:nextAbsLevel > b:v.myAbsLevel
            let b:v.lev = '>' . string(b:v.myAbsLevel)
        elseif l:nextAbsLevel < b:v.myAbsLevel
            let b:v.lev = '<' . string(l:nextAbsLevel)
        else
            let b:v.lev = '<' . b:v.myAbsLevel
        endif
        let b:v.prevlev = b:v.myAbsLevel

    else    
        "we have a text line 
        if b:v.lastline != a:line - 1    " backup to headline to get bearings
            if l:text =~ b:v.drawerMatch
                let b:v.prevlev = s:Ind(s:OrgPrevHead_l(a:line))
            else
                "don't just back up, recalc previous lines
                " to set variables correctly
                let prevhead = s:OrgPrevHead_l(a:line)
                if prevhead == 0
                    " shortcircuit here, it's blank line prior to any head
                    return -1
                endif
                let b:v.prevlev = s:Ind(prevhead)
                let i = prevhead
                "for item in range(prevhead,a:line-1)
                "    call OrgFoldLevel(item)
                "endfor
            endif
            "let b:v.prevlev = s:Ind(s:OrgPrevHead_l(a:line))
        endif

        if l:text =~ b:v.drawerMatch
            let b:v.lev = '>' . string(b:v.prevlev + 4)
        elseif (l:text =~ s:remstring) 
            if (getline(a:line - 1) =~ b:v.headMatch) && (l:nexttext =~ s:remstring)
                let b:v.lev =  string(b:v.prevlev + 5)
            elseif (l:nexttext !~ s:remstring) || 
                        \ (l:nexttext =~ b:v.drawerMatch) 
                let b:v.lev = '<' . string(b:v.prevlev + 4)
            else
                let b:v.lev = b:v.prevlev + 4
            endif
        elseif l:text[0] != '#'
                let b:v.lev = (b:v.prevlev + 2)
                let b:v.lasttext_lev = b:v.lev
        elseif b:v.src_fold  
            if l:text =~ '^#+begin_src'
                let b:v.lev = '>' . (b:v.prevlev + 2)
            elseif l:text =~ '^#+end_src'
                let b:v.lev = '<' . (b:v.prevlev + 2)
            endif
        else 
            let b:v.lev = (b:v.prevlev + 2)
        endif   

        if l:nexttext =~ '^\* '
            " this is for perf reasons, closing fold
            " back to zero avoids foldlevel calls sometimes
            let b:v.lev = '<0'
        elseif l:nexttext =~ '^\*\+\s'
            let b:v.lev = '<' . string(l:nextAbsLevel)
        endif

    endif   
    let b:v.lastline = a:line
    return b:v.lev    

endfunction

function! s:Ind(line) 
    " used to get level of a heading (todo : rename this function)
    return 2 + (len(matchstr(getline(a:line), '^\**\s')) - 2) / b:v.levelstars  

endfunction
