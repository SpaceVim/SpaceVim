" =============================================================================
" File: wildfire.vim
" Description: Smart selection of the closest text object
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/wildfire.vim
" License: MIT
" =============================================================================


let s:save_cpo = &cpo
set cpo&vim


" Internal variables
" =============================================================================

let s:cannot_be_nested = {"iw" : 1, "aw" : 1, "iW" : 1, "aW": 1}

let s:vim_text_objects = {}
for s:char in split("(){}[]<>'`\"bBwWpst", "\\zs")
    let s:vim_text_objects = extend(s:vim_text_objects, {"a".s:char : 1, "i".s:char : 1})
endfor

let s:counts = {}
let s:history = []
let s:origin = []


" Functions
" =============================================================================

fu! wildfire#Start(repeat, objects)
    cal s:init(a:objects)
    cal wildfire#Fuel(a:repeat)
endfu

fu! wildfire#Fuel(repeat)
    for i in range(a:repeat)
        cal s:select_text_object()
    endfor
endfu

fu! wildfire#Water(repeat)
    for i in range(a:repeat)
        cal setpos(".", s:origin)
        if len(s:history) > 1
            let s:counts[remove(s:history, -1).selection.object] -= 1
            cal winrestview(get(s:history, -1).view)
            cal s:select(get(s:history, -1).selection)
        endif
    endfor
endfu

fu! s:init(objects)
    let s:origin = getpos(".")
    let s:history = []
    let s:counts = {}
    let _objects = s:load_objects(a:objects)
    for object in get(_objects, &ft, get(_objects, "*", []))
        let s:counts[object] = 1
    endfor
endfu

fu! s:load_objects(objects)
    " force `a:objects` to be a dictionary
    let _objects = type(a:objects) == type([]) ? {"*": a:objects} : a:objects
    " split filetypes that share the same text objects
    for [ftypes, objs] in items(_objects)
        for ft in split(ftypes, ",")
            let _objects[ft] = objs
        endfor
    endfor
    return _objects
endfu

fu! s:select_text_object()

    cal setpos(".", s:origin)

    let view = winsaveview()

    let candidates = {}
    for object in keys(s:counts)

        let selection = {"object": object, "count": s:counts[object]}

        let [startline, startcol, endline, endcol] = s:edges(selection)
        let selection = extend(selection,
            \ {"startline": startline, "startcol": startcol, "endline": endline, "endcol": endcol })

        cal winrestview(view)

        " Some text object cannot be nested. This avoids unwanted behavior.
        if get(s:cannot_be_nested, selection.object) && selection.count > 1
            continue
        endif

        " The selection failed with the candidate text object
        if selection.startline == selection.endline && selection.startcol == selection.endcol
            continue
        endif

        " Sometimes Vim selects text objects even if the cursor is outside the
        " them (e.g. `it`, `i"`, etc). We don't want this.
        if selection.startline == selection.endline
            if s:origin[2] < selection.startcol || s:origin[2] > selection.endcol
                let s:counts[object] += 1
                continue
            endif
        endif

        let size = s:size(selection)

        " This happens when the _count is incremented but the selection remains still
        let _selection = extend(copy(selection), {"count": selection.count-1})
        if s:already_selected(_selection)
            continue
        endif

        " Special case
        if object =~ "a\"\\|i\"\\|a'\\|i'" && startline == endline
            let _selection = extend(copy(selection),
                \ {"count": selection.count-1, "startcol": selection.startcol+1, "endcol": selection.endcol-1})
            if s:already_selected(_selection)
                " When there is no more string to select on the same line, vim
                " selects the outer string text object. This is far from the
                " desired behavior
                continue
            endif
            let _selection = extend(copy(selection),
                \ {"count": selection.count-1, "startcol": selection.startcol+1})
            if s:already_selected(_selection)
                " This follows the previous check. When the string ends the
                " line, the size of the text object is just one character less
                continue
            endif
            let line = getline("'<")
            let quote = strpart(object, 1)
            let [before, after] = [line[:selection.startcol-3], line[selection.endcol+1:]]
            if s:odd_quotes(quote, before) || s:odd_quotes(quote, after)
                continue
            endif
        endif

        let candidates[size] = selection

    endfor

    cal s:select_best_candidate(candidates)

endfu

" To select the closest text object among the candidates
fu! s:select_best_candidate(candidates)
    if len(a:candidates)
        " select the closest text object (the one with the smaller size)
        let selection = a:candidates[min(keys(a:candidates))]
        let s:history = add(s:history, {"selection": selection, "view": winsaveview()})
        let s:counts[selection.object] += 1
        cal s:select(selection)
    elseif len(s:history)
        " get stuck on the last selection
        cal s:select(get(s:history, -1).selection)
    else
        " do nothing
        exec "sil! norm! \<ESC>"
    endif
endfu

" To retrun the edges of a text object
fu! s:edges(selection)
    cal s:select(a:selection)
    exe "sil! norm! \<ESC>"
    return [line("'<"), col("'<"), line("'>"), col("'>")]
endfu

" To select a text object
fu! s:select(selection)
    exe "sil! norm! \<ESC>v\<ESC>v"
    if get(s:vim_text_objects, a:selection.object)
        " use counts when selecting vim text objects
        exe "sil! norm! " . a:selection.count . a:selection.object
    else
        " counts might not be suported by non-default text objects
        for n in range(a:selection.count)
            exe "sil! norm " . a:selection.object
        endfor
    endif
endfu

" To check if a text object has been already selected
fu! s:already_selected(selection)
    for s in s:history
        if s.selection == a:selection
            return 1
        end
    endfor
    return 0
endfu

" To return the size of a text object
fu! s:size(selection)
    if a:selection.startline == a:selection.endline
        return a:selection.endcol - a:selection.startcol + 1
    endif
    let size = len(getline(a:selection.startline)) - a:selection.startcol + a:selection.endcol + 1
    let size += winwidth(0) * (a:selection.endline - a:selection.startline - 1)
    return size
endfu

" To check if in a strings there is an odd number of quotes
fu! s:odd_quotes(quote, s)
    let n = 0
    for i in range(0, strlen(a:s))
        if a:s[i] == a:quote && !(i > 0 && a:s[i-1] == "\\")
            let n += 1
        endif
    endfor
    return n % 2 != 0
endfu

" Quick Select
" =============================================================================

fu! wildfire#QuickSelect(objects)
    cal s:init(a:objects)
    while 1
        let last_hist_size = len(s:history)
        cal s:select_text_object()
        if empty(s:history)
            return
        end
        let selection = get(s:history, -1).selection
        if selection.startline < line("w0") || selection.endline > line("w$")
            cal wildfire#Water(1)
            break
        end
        if last_hist_size == len(s:history)
            break
        end
    endw
    exe "norm! \<ESC>"
    cal setpos(".", s:origin)
    let save_hl = s:turn_off_syntax_errs()
    let marks = s:show_marks(map(copy(s:history), "v:val.selection"))
    cal s:jump(marks)
    cal s:turn_on_syntax_errs(save_hl)
endfu

" To display marks
fu s:show_marks(selections)
    try | undojoin | catch | endtry
    cal matchadd("WildfireShade", '\%>'.(line('w0')-1).'l\%<'.line('w$').'l')
    let marks = split(g:wildfire_marks, '\zs')
    let placed_marks = {}
    let candidates = {}
    for selection in a:selections
        if empty(marks) | break | end
        if !has_key(placed_marks, selection.startline . "," . selection.startcol)
            let [mline, mcol] = [selection.startline, selection.startcol]
        elseif !has_key(placed_marks, selection.endline . "," . selection.endcol)
            let [mline, mcol] = [selection.endline, selection.endcol]
        else
            continue
        end
        let placed_marks[mline.",".mcol] = 1
        let mark = remove(marks, 0)
        let candidates[mark] = [
            \ selection,
            \ {"line": mline, "col": mcol, "char": mark, "oldchar": getline(mline)[mcol-1]}
        \ ]
        cal setline(mline, s:str_subst(getline(mline), mcol-1, mark))
        cal matchadd("WildfireMark", '\%'.mline.'l\%'.mcol.'c')
    endfor
    setl nomodified
    return candidates
endfu

" To ask the user where to jump and move there
fu s:jump(marks)
    if empty(a:marks) | return | end
    normal! m'
    while 1
        redraw
        cal s:show_prompt()
        let choice = s:get_char()
        if choice =~ '<C-C>\|<ESC>'
            cal s:clear_marks(a:marks)
            break
        end
        if has_key(a:marks, choice)
            cal s:clear_marks(a:marks)
            cal s:select(a:marks[choice][0])
            let s:history = s:history[:stridx(g:wildfire_marks, choice)]
            break
        end
    endw
endfu

" To display the prompt
fu s:show_prompt()
    echohl WildfirePrompt | echon g:wildfire_prompt | echohl None
endfu


" To clear all marks
fu s:clear_marks(marks)
    cal s:clear_matches("WildfireMark", "WildfireShade")
    try | undojoin | catch | endtry
    for [s, mark] in values(a:marks)
        cal setline(mark.line, s:str_subst(getline(mark.line), mark.col-1, mark.oldchar))
    endfor
    setl nomodified
endfu

" To turn off syntax errors. The returned value can be used to restore syntax
" errors with s:turn_on_syntax_err()
fu s:turn_off_syntax_errs()
    let colors = s:colors_of("Error")
    hi Error None
    return colors
endfu

" To turn on syntax errors
fu s:turn_on_syntax_errs(colors)
    cal s:set_colors("Error", a:colors)
endfu

" Utilities
" =============================================================================

" To get the colors of given highlight group.
fu s:colors_of(group)
    redir => raw_hl
        exe "hi" a:group
    redir END
    let raw_hl = substitute(raw_hl, "\n", " ", "")
    if match(raw_hl, 'cleared') >= 0
        return {"colors": "None", "link": ""}
    end
    if match(raw_hl, "links to") >= 0
        return {"colors": "", "link": matchstr(raw_hl, '\v(links to )@<=.*')}
    end
    return {"colors": matchstr(raw_hl, '\v( xxx )@<=.*'), "link": ""}
endfu

" To set the colors for a given highlight group. Note that this function should
" be used exclusively with colors retrieved with the function s:color_of(..)
fu s:set_colors(group, colors)
    if !empty(a:colors.link)
        exe "hi link" a:group a:colors.link
    else
        exe "hi" a:group a:colors.colors
    end
endfu

" To clear matches of given groups
fu s:clear_matches(...)
    for m in getmatches()
        if index(a:000, m.group) != -1
            cal matchdelete(m.id)
        end
    endfor
endfu

" To substitute a character in a string
fu s:str_subst(str, col, char)
    return strpart(a:str, 0, a:col) . a:char . strpart(a:str, a:col+1)
endfu

" To get a key pressed by the user
fu s:get_char()
    let char = strtrans(getchar())
        if char == 13 | return "<CR>"
    elseif char == 27 | return "<ESC>"
    elseif char == 9 | return "<TAB>"
    elseif char >= 1 && char <= 26 | return "<C-" . nr2char(char+64) . ">"
    elseif char != 0 | return nr2char(char)
    elseif match(char, '<fc>^D') > 0 | return "<C-SPACE>"
    elseif match(char, 'kb') > 0 | return "<BS>"
    elseif match(char, 'ku') > 0 | return "<UP>"
    elseif match(char, 'kd') > 0 | return "<DOWN>"
    elseif match(char, 'kl') > 0 | return "<LEFT>"
    elseif match(char, 'kr') > 0 | return "<RIGHT>"
    elseif match(char, 'k\\d\\+') > 0 | return "<F" . match(char, '\\d\\+', 4) . ">"
    end
endfu

" =============================================================================

let &cpo = s:save_cpo
unlet s:save_cpo
