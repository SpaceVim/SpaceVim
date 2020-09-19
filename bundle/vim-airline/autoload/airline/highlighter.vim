" MIT License. Copyright (c) 2013-2020 Bailey Ling Christian Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

let s:is_win32term = (has('win32') || has('win64')) &&
                   \ !has('gui_running') &&
                   \ (empty($CONEMUBUILD) || &term !=? 'xterm') &&
                   \ !(exists("+termguicolors") && &termguicolors)

let s:separators = {}
let s:accents = {}
let s:hl_groups = {}

function! s:gui2cui(rgb, fallback)
  if a:rgb == ''
    return a:fallback
  elseif match(a:rgb, '^\%(NONE\|[fb]g\)$') > -1
    return a:rgb
  endif
  let rgb = map(split(a:rgb[1:], '..\zs'), '0 + ("0x".v:val)')
  return airline#msdos#round_msdos_colors(rgb)
endfunction

function! s:group_not_done(list, name)
  if index(a:list, a:name) == -1
    call add(a:list, a:name)
    return 1
  else
    if &vbs
      echomsg printf("airline: group: %s already done, skipping", a:name)
    endif
    return 0
  endif
endfu

function! s:get_syn(group, what)
  if !exists("g:airline_gui_mode")
    let g:airline_gui_mode = airline#init#gui_mode()
  endif
  let color = ''
  if hlexists(a:group)
    let color = synIDattr(synIDtrans(hlID(a:group)), a:what, g:airline_gui_mode)
  endif
  if empty(color) || color == -1
    " should always exists
    let color = synIDattr(synIDtrans(hlID('Normal')), a:what, g:airline_gui_mode)
    " however, just in case
    if empty(color) || color == -1
      let color = 'NONE'
    endif
  endif
  return color
endfunction

function! s:get_array(fg, bg, opts)
  let opts=empty(a:opts) ? '' : join(a:opts, ',')
  return g:airline_gui_mode ==# 'gui'
        \ ? [ a:fg, a:bg, '', '', opts ]
        \ : [ '', '', a:fg, a:bg, opts ]
endfunction

function! airline#highlighter#reset_hlcache()
  let s:hl_groups = {}
endfunction

function! airline#highlighter#get_highlight(group, ...)
  let reverse = get(g:, 'airline_gui_mode', '') ==# 'gui'
      \ ? synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'gui')
      \ : synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'cterm')
      \|| synIDattr(synIDtrans(hlID(a:group)), 'reverse', 'term')
  if get(g:, 'airline_highlighting_cache', 0) && has_key(s:hl_groups, a:group)
    let res = s:hl_groups[a:group]
    return reverse ? [ res[1], res[0], res[3], res[2], res[4] ] : res
  else
    let fg = s:get_syn(a:group, 'fg')
    let bg = s:get_syn(a:group, 'bg')
    let bold = synIDattr(synIDtrans(hlID(a:group)), 'bold')
    if reverse
      let res = s:get_array(bg, fg, bold ? ['bold'] : a:000)
    else
      let res = s:get_array(fg, bg, bold ? ['bold'] : a:000)
    endif
  endif
  let s:hl_groups[a:group] = res
  return res
endfunction

function! airline#highlighter#get_highlight2(fg, bg, ...)
  let fg = s:get_syn(a:fg[0], a:fg[1])
  let bg = s:get_syn(a:bg[0], a:bg[1])
  return s:get_array(fg, bg, a:000)
endfunction

function! s:hl_group_exists(group)
  if !hlexists(a:group)
    return 0
  elseif empty(synIDattr(hlID(a:group), 'fg'))
    return 0
  endif
  return 1
endfunction

function! airline#highlighter#exec(group, colors)
  if pumvisible()
    return
  endif
  let colors = a:colors
  if s:is_win32term
    let colors[2] = s:gui2cui(get(colors, 0, ''), get(colors, 2, ''))
    let colors[3] = s:gui2cui(get(colors, 1, ''), get(colors, 3, ''))
  endif
  let old_hi = airline#highlighter#get_highlight(a:group)
  if len(colors) == 4
    call add(colors, '')
  endif
  if g:airline_gui_mode ==# 'gui'
    let new_hi = [colors[0], colors[1], '', '', colors[4]]
  else
    let new_hi = ['', '', printf("%s", colors[2]), printf("%s", colors[3]), colors[4]]
  endif
  let colors = s:CheckDefined(colors)
  if old_hi != new_hi || !s:hl_group_exists(a:group)
    let cmd = printf('hi %s%s', a:group, s:GetHiCmd(colors))
    exe cmd
    if has_key(s:hl_groups, a:group)
      let s:hl_groups[a:group] = colors
    endif
  endif
endfunction

function! s:CheckDefined(colors)
  " Checks, whether the definition of the colors is valid and is not empty or NONE
  " e.g. if the colors would expand to this:
  " hi airline_c ctermfg=NONE ctermbg=NONE
  " that means to clear that highlighting group, therefore, fallback to Normal
  " highlighting group for the cterm values

  " This only works, if the Normal highlighting group is actually defined, so
  " return early, if it has been cleared
  if !exists("g:airline#highlighter#normal_fg_hi")
    let g:airline#highlighter#normal_fg_hi = synIDattr(synIDtrans(hlID('Normal')), 'fg', 'cterm')
  endif
  if empty(g:airline#highlighter#normal_fg_hi) || g:airline#highlighter#normal_fg_hi < 0
    return a:colors
  endif

  for val in a:colors
    if !empty(val) && val !=# 'NONE'
      return a:colors
    endif
  endfor
  " this adds the bold attribute to the term argument of the :hi command,
  " but at least this makes sure, the group will be defined
  let fg = g:airline#highlighter#normal_fg_hi
  let bg = synIDattr(synIDtrans(hlID('Normal')), 'bg', 'cterm')
  if bg < 0
    " in case there is no background color defined for Normal
    let bg = a:colors[3]
  endif
  return a:colors[0:1] + [fg, bg] + [a:colors[4]]
endfunction

function! s:GetHiCmd(list)
  " a:list needs to have 5 items!
  let res = ''
  let i = -1
  while i < 4
    let i += 1
    let item = get(a:list, i, '')
    if item is ''
      continue
    endif
    if i == 0
      let res .= ' guifg='.item
    elseif i == 1
      let res .= ' guibg='.item
    elseif i == 2
      let res .= ' ctermfg='.item
    elseif i == 3
      let res .= ' ctermbg='.item
    elseif i == 4
      let res .= printf(' gui=%s cterm=%s term=%s', item, item, item)
    endif
  endwhile
  return res
endfunction

function! s:exec_separator(dict, from, to, inverse, suffix)
  if pumvisible()
    return
  endif
  let group = a:from.'_to_'.a:to.a:suffix
  let l:from = airline#themes#get_highlight(a:from.a:suffix)
  let l:to = airline#themes#get_highlight(a:to.a:suffix)
  if a:inverse
    let colors = [ l:from[1], l:to[1], l:from[3], l:to[3] ]
  else
    let colors = [ l:to[1], l:from[1], l:to[3], l:from[3] ]
  endif
  let a:dict[group] = colors
  call airline#highlighter#exec(group, colors)
endfunction

function! airline#highlighter#load_theme()
  if pumvisible()
    return
  endif
  for winnr in filter(range(1, winnr('$')), 'v:val != winnr()')
    call airline#highlighter#highlight_modified_inactive(winbufnr(winnr))
  endfor
  call airline#highlighter#highlight(['inactive'])
  if getbufvar( bufnr('%'), '&modified'  )
    call airline#highlighter#highlight(['normal', 'modified'])
  else
    call airline#highlighter#highlight(['normal'])
  endif
endfunction

function! airline#highlighter#add_separator(from, to, inverse)
  let s:separators[a:from.a:to] = [a:from, a:to, a:inverse]
  call <sid>exec_separator({}, a:from, a:to, a:inverse, '')
endfunction

function! airline#highlighter#add_accent(accent)
  let s:accents[a:accent] = 1
endfunction

function! airline#highlighter#highlight_modified_inactive(bufnr)
  if getbufvar(a:bufnr, '&modified')
    let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c')
          \ ? g:airline#themes#{g:airline_theme}#palette.inactive_modified.airline_c : []
  else
    let colors = exists('g:airline#themes#{g:airline_theme}#palette.inactive.airline_c')
          \ ? g:airline#themes#{g:airline_theme}#palette.inactive.airline_c : []
  endif

  if !empty(colors)
    call airline#highlighter#exec('airline_c'.(a:bufnr).'_inactive', colors)
  endif
endfunction

function! airline#highlighter#highlight(modes, ...)
  let bufnr = a:0 ? a:1 : ''
  let p = g:airline#themes#{g:airline_theme}#palette

  " draw the base mode, followed by any overrides
  let mapped = map(a:modes, 'v:val == a:modes[0] ? v:val : a:modes[0]."_".v:val')
  let suffix = a:modes[0] == 'inactive' ? '_inactive' : ''
  let airline_grouplist = []
  let buffers_in_tabpage = sort(tabpagebuflist())
  if exists("*uniq")
    let buffers_in_tabpage = uniq(buffers_in_tabpage)
  endif
  " mapped might be something like ['normal', 'normal_modified']
  " if a group is in both modes available, only define the second
  " that is how this was done previously overwrite the previous definition
  for mode in reverse(mapped)
    if exists('g:airline#themes#{g:airline_theme}#palette[mode]')
      let dict = g:airline#themes#{g:airline_theme}#palette[mode]
      for kvp in items(dict)
        let mode_colors = kvp[1]
        let name = kvp[0]
        if name is# 'airline_c' && !empty(bufnr) && suffix is# '_inactive'
          let name = 'airline_c'.bufnr
        endif
        " do not re-create highlighting for buffers that are no longer visible
        " in the current tabpage
        if name =~# 'airline_c\d\+'
          let bnr = matchstr(name, 'airline_c\zs\d\+') + 0
          if bnr > 0 && index(buffers_in_tabpage, bnr) == -1
            continue
          endif
        elseif (name =~# '_to_') || (name[0:10] is# 'airline_tab' && !empty(suffix))
          " group will be redefined below at exec_separator
          " or is not needed for tabline with '_inactive' suffix
          " since active flag is 1 for builder)
          continue
        endif
        if s:group_not_done(airline_grouplist, name.suffix)
          call airline#highlighter#exec(name.suffix, mode_colors)
        endif

        if !has_key(p, 'accents') 
          " work around a broken installation
          " shouldn't actually happen, p should always contain accents
          continue
        endif

        for accent in keys(s:accents)
          if !has_key(p.accents, accent)
            continue
          endif
          let colors = copy(mode_colors)
          if p.accents[accent][0] != ''
            let colors[0] = p.accents[accent][0]
          endif
          if p.accents[accent][2] != ''
            let colors[2] = p.accents[accent][2]
          endif
          if len(colors) >= 5
            let colors[4] = get(p.accents[accent], 4, '')
          else
            call add(colors, get(p.accents[accent], 4, ''))
          endif
          if s:group_not_done(airline_grouplist, name.suffix.'_'.accent)
            call airline#highlighter#exec(name.suffix.'_'.accent, colors)
          endif
        endfor
      endfor

      if empty(s:separators)
        " nothing to be done
        continue
      endif
      " TODO: optimize this
      for sep in items(s:separators)
        " we cannot check, that the group already exists, else the separators
        " might not be correctly defined. But perhaps we can skip above groups
        " that match the '_to_' name, because they would be redefined here...
        call <sid>exec_separator(dict, sep[1][0], sep[1][1], sep[1][2], suffix)
      endfor
    endif
  endfor
endfunction
