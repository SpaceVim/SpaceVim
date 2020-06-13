"=============================================================================
" edit.vim --- SpaceVim edit layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


scriptencoding utf-8
let s:PASSWORD = SpaceVim#api#import('password')
let s:NUMBER = SpaceVim#api#import('data#number')
let s:LIST = SpaceVim#api#import('data#list')
let s:VIM = SpaceVim#api#import('vim')

function! SpaceVim#layers#edit#plugins() abort
  let plugins = [
        \ [g:_spacevim_root_dir . 'bundle/vim-surround'],
        \ [g:_spacevim_root_dir . 'bundle/vim-repeat'],
        \ [g:_spacevim_root_dir . 'bundle/vim-emoji'],
        \ [g:_spacevim_root_dir . 'bundle/vim-expand-region', { 'loadconf' : 1}],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-user'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-indent'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-line'],
        \ [g:_spacevim_root_dir . 'bundle/vim-table-mode'],
        \ [g:_spacevim_root_dir . 'bundle/vim-textobj-entire'],
        \ [g:_spacevim_root_dir . 'bundle/wildfire.vim',{'on_map' : '<Plug>(wildfire-'}],
        \ [g:_spacevim_root_dir . 'bundle/vim-easymotion'],
        \ [g:_spacevim_root_dir . 'bundle/vim-easyoperator-line'],
        \ [g:_spacevim_root_dir . 'bundle/editorconfig-vim', { 'merged' : 0, 'if' : has('python') || has('python3')}],
        \ [g:_spacevim_root_dir . 'bundle/vim-jplus', { 'on_map' : '<Plug>(jplus' }],
        \ [g:_spacevim_root_dir . 'bundle/tabular',           { 'merged' : 0}],
        \ [g:_spacevim_root_dir . 'bundle/vim-better-whitespace',  { 'on_cmd' : ['StripWhitespace', 'ToggleWhitespace', 'DisableWhitespace', 'EnableWhitespace']}],
        \ ]
  if executable('fcitx')
    call add(plugins,[g:_spacevim_root_dir . 'bundle/fcitx.vim',        { 'on_event' : 'InsertEnter'}])
  endif
  if g:spacevim_enable_bepo_layout
    call add(plugins,[g:_spacevim_root_dir . 'bundle/vim-bepo',        { 'merged' : 0}])
  endif
  return plugins
endfunction

function! SpaceVim#layers#edit#config() abort
  let g:multi_cursor_next_key=get(g:, 'multi_cursor_next_key', '<C-n>')
  let g:multi_cursor_prev_key=get(g:, 'multi_cursor_prev_key', '<C-m>')
  let g:multi_cursor_skip_key=get(g:, 'multi_cursor_skip_key', '<C-x>')
  let g:multi_cursor_quit_key=get(g:, 'multi_cursor_quit_key', '<Esc>')
  let g:user_emmet_install_global = 0
  let g:user_emmet_mode='a'
  let g:user_emmet_settings = {
        \ 'javascript': {
        \ 'extends': 'jsx',
        \ },
        \ 'jsp' : {
        \ 'extends': 'html',
        \ },
        \ }

  "noremap <SPACE> <Plug>(wildfire-fuel)
  vnoremap <C-SPACE> <Plug>(wildfire-water)
  let g:wildfire_objects = ["i'", 'i"', 'i)', 'i]', 'i}', 'ip', 'it']

  " osyo-manga/vim-jplus {{{
  nmap <silent> J <Plug>(jplus)
  vmap <silent> J <Plug>(jplus)
  " }}}

  let g:_spacevim_mappings_space.x = {'name' : '+Text'}
  let g:_spacevim_mappings_space.x.a = {'name' : '+align'}
  let g:_spacevim_mappings_space.x.d = {'name' : '+delete'}
  let g:_spacevim_mappings_space.x.i = {'name' : '+change symbol style'}
  nnoremap <silent> <Plug>CountSelectionRegion :call <SID>count_selection_region()<Cr>
  xnoremap <silent> <Plug>CountSelectionRegion :<C-u>call <SID>count_selection_region()<Cr>
  call SpaceVim#mapping#space#def('nmap', ['x', 'c'], '<Plug>CountSelectionRegion', 'count in the selection region', 0, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '#'], 'Tabularize /#', 'align-region-at-#', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '%'], 'Tabularize /%', 'align-region-at-%', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '&'], 'Tabularize /&', 'align-region-at-&', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '('], 'Tabularize /(', 'align-region-at-(', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ')'], 'Tabularize /)', 'align-region-at-)', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '['], 'Tabularize /[', 'align-region-at-[', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ']'], 'Tabularize /]', 'align-region-at-]', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '{'], 'Tabularize /{', 'align-region-at-{', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '}'], 'Tabularize /}', 'align-region-at-}', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ','], 'Tabularize /,', 'align-region-at-,', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '.'], 'Tabularize /\.', 'align-region-at-dot', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ':'], 'Tabularize /:', 'align-region-at-:', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', ';'], 'Tabularize /;', 'align-region-at-;', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '='], 'Tabularize /===\|<=>\|\(&&\|||\|<<\|>>\|\/\/\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.?-]\?=[#?]\?/l1r1', 'align-region-at-=', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', 'o'], 'Tabularize /&&\|||\|\.\.\|\*\*\|<<\|>>\|\/\/\|[-+*/.%^><&|?]/l1r1', 'align-region-at-operator, such as +,-,*,/,%,^,etc', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '¦'], 'Tabularize /¦', 'align-region-at-¦', 1, 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', '<Bar>'], 'Tabularize /|', 'align-region-at-|', 1, 1)
  call SpaceVim#mapping#space#def('nmap', ['x', 'a', '[SPC]'], 'Tabularize /\s\ze\S/l0', 'align-region-at-space', 1, 1)
  " @fixme SPC x a SPC make vim flick
  nmap <Space>xa<Space> [SPC]xa[SPC]
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'a', 'r'], 'call call('
        \ . string(s:_function('s:align_at_regular_expression')) . ', [])',
        \ 'align-region-at-user-specified-regexp', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', 'w'], 'StripWhitespace', 'delete trailing whitespaces', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'd', '<Space>'], 'silent call call('
        \ . string(s:_function('s:delete_extra_space')) . ', [])',
        \ 'delete extra space arround cursor', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'c'], 'silent call call('
        \ . string(s:_function('s:lowerCamelCase')) . ', [])',
        \ 'change symbol style to lowerCamelCase', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'C'], 'silent call call('
        \ . string(s:_function('s:UpperCamelCase')) . ', [])',
        \ 'change symbol style to UpperCamelCase', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '_'], 'silent call call('
        \ . string(s:_function('s:under_score')) . ', [])',
        \ 'change symbol style to under_score', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'u'], 'silent call call('
        \ . string(s:_function('s:under_score')) . ', [])',
        \ 'change symbol style to under_score', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'U'], 'silent call call('
        \ . string(s:_function('s:up_case')) . ', [])',
        \ 'change symbol style to UP_CASE', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', 'k'], 'silent call call('
        \ . string(s:_function('s:kebab_case')) . ', [])',
        \ 'change symbol style to kebab-case', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'i', '-'], 'silent call call('
        \ . string(s:_function('s:kebab_case')) . ', [])',
        \ 'change symbol style to kebab-case', 1)

  " justification
  let g:_spacevim_mappings_space.x.j = {'name' : '+Justification'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'l'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["left"])',
        \ 'set-the-justification-to-left', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'c'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["center"])',
        \ 'set-the-justification-to-center', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'j', 'r'], 'silent call call('
        \ . string(s:_function('s:set_justification_to')) . ', ["right"])',
        \ 'set-the-justification-to-right', 1)

  call SpaceVim#mapping#space#def('vnoremap', ['x', 'u'], 'gu', 'set the selected text to lower case', 0)
  call SpaceVim#mapping#space#def('vnoremap', ['x', 'U'], 'gU', 'set the selected text to up case', 0)

  " word
  let g:_spacevim_mappings_space.x.w = {'name' : '+Word'}
  call SpaceVim#mapping#space#def('vnoremap', ['x', 'w', 'c'], 'normal! ' . ":'<,'>s/\\\w\\+//gn" . "\<cr>", 'count the words in the select region', 1)
  let g:_spacevim_mappings_space.x.s = {'name' : '+String'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 's', 'j'], 'call call('
        \ . string(s:_function('s:join_string_with')) . ', [])',
        \ 'join-string-with', 1)

  let g:_spacevim_mappings_space.i = {'name' : '+Insertion'}
  let g:_spacevim_mappings_space.i.l = {'name' : '+Lorem-ipsum'}
  let g:_spacevim_mappings_space.i.p = {'name' : '+Passwords'}
  let g:_spacevim_mappings_space.i.U = {'name' : '+UUID'}
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 1], 'call call('
        \ . string(s:_function('s:insert_simple_password')) . ', [])',
        \ 'insert-simple-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 2], 'call call('
        \ . string(s:_function('s:insert_stronger_password')) . ', [])',
        \ 'insert-stronger-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 3], 'call call('
        \ . string(s:_function('s:insert_paranoid_password')) . ', [])',
        \ 'insert-password-for-paranoids', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'p'], 'call call('
        \ . string(s:_function('s:insert_phonetically_password')) . ', [])',
        \ 'insert-a-phonetically-easy-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'n'], 'call call('
        \ . string(s:_function('s:insert_numerical_password')) . ', [])',
        \ 'insert-a-numerical-password', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'U', 'U'], 'call call('
        \ . string(s:_function('s:uuidgen_U')) . ', [])',
        \ 'uuidgen-4', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'l'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_list')) . ', [])',
        \ 'insert-lorem-ipsum-list', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 'p'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_paragraph')) . ', [])',
        \ 'insert-lorem-ipsum-paragraph', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['i', 'l', 's'], 'call call('
        \ . string(s:_function('s:insert_lorem_ipsum_sentence')) . ', [])',
        \ 'insert-lorem-ipsum-sentence', 1)
  " move line
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'J'], 'call call('
        \ . string(s:_function('s:move_text_down_transient_state')) . ', [])',
        \ 'move-text-down(enter-transient-state)', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 'K'], 'call call('
        \ . string(s:_function('s:move_text_up_transient_state')) . ', [])',
        \ 'move-text-up(enter-transient-state)', 1)

  " transpose
  let g:_spacevim_mappings_space.x.t = {'name' : '+transpose'}
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'c'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["character"])',
        \ 'swap-current-character-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'w'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["word"])',
        \ 'swap-current-word-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'l'], 'call call('
        \ . string(s:_function('s:transpose_with_previous')) . ', ["line"])',
        \ 'swap-current-line-with-previous-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'C'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["character"])',
        \ 'swap-current-character-with-next-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'W'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["word"])',
        \ 'swap-current-word-with-next-one', 1)
  call SpaceVim#mapping#space#def('nnoremap', ['x', 't', 'L'], 'call call('
        \ . string(s:_function('s:transpose_with_next')) . ', ["line"])',
        \ 'swap-current-line-with-next-one', 1)

endfunction

function! s:transpose_with_previous(type) abort
  let l:save_register = @"
  if a:type ==# 'line'
    if line('.') > 1
      normal! kddp
    endif
  elseif a:type ==# 'word'
    normal! yiw
    let l:cw = @"
    normal! geyiw
    let l:tw = @"
    if l:cw !=# l:tw
      let @" = l:cw
      normal! viwp
      let @" = l:tw
      normal! eviwp
    endif
  elseif a:type ==# 'character'
    if col('.') > 1
      normal! hxp
    endif
  endif
  let @" = l:save_register
endfunction

function! s:transpose_with_next(type) abort
  let l:save_register = @"
  if a:type ==# 'line'
    if line('.') < line('$')
      normal! ddp
    endif
  elseif a:type ==# 'word'
    normal! yiw
    let l:cw = @"
    normal! wyiw
    let l:nw = @"
    if l:cw !=# l:nw
      let @" = l:cw
      normal! viwp
      let @" = l:nw
      normal! geviwp
    endif
  elseif a:type ==# 'character'
    if col('.') < col('$')-1
      normal! xp
    endif
  endif
  let @" = l:save_register
endfunction

function! s:move_text_down_transient_state() abort   
  if line('.') == line('$')
  else
    let l:save_register = @"
    normal! ddp
    let @" = l:save_register
  endif
  call s:text_transient_state()
endfunction

function! s:move_text_up_transient_state() abort
  if line('.') > 1
    let l:save_register = @"
    normal! ddkP
    let @" = l:save_register
  endif
  call s:text_transient_state()
endfunction

function! s:text_transient_state() abort
  let state = SpaceVim#api#import('transient_state') 
  call state.set_title('Move Text Transient State')
  call state.defind_keys(
        \ {
        \ 'layout' : 'vertical split',
        \ 'left' : [
        \ {
        \ 'key' : 'J',
        \ 'desc' : 'move text down',
        \ 'func' : '',
        \ 'cmd' : 'noautocmd silent! m .+1',
        \ 'exit' : 0,
        \ },
        \ ],
        \ 'right' : [
        \ {
        \ 'key' : 'K',
        \ 'func' : '',
        \ 'desc' : 'move text up',
        \ 'cmd' : 'noautocmd silent! m .-2',
        \ 'exit' : 0,
        \ },
        \ ],
        \ }
        \ )
  call state.open()
endfunction

function! s:lowerCamelCase() abort
  " fooFzz
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let rst = [cword[0]]
    if len(cword) > 1
      let rst += map(cword[1:], "substitute(v:val, '^.', '\\u&', 'g')")
    endif
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:UpperCamelCase() abort
  " FooFzz
  if strcharpart(getline('.')[col('.') - 1:], 0, 1) =~ '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let rst = map(cword, "substitute(v:val, '^.', '\\u&', 'g')")
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(rst, '')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:kebab_case() abort
  " foo-fzz
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
    return
  endif
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '-')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:under_score() abort
  " foo_fzz
  let cword = s:parse_symbol(expand('<cword>'))
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

function! s:up_case() abort
  " FOO_FZZ
  if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
    return
  endif
  let cword =map(s:parse_symbol(expand('<cword>')), 'toupper(v:val)')
  if !empty(cword)
    let save_register = @k
    let save_cursor = getcurpos()
    let @k = join(cword, '_')
    normal! viw"kp
    call setpos('.', save_cursor)
    let @k = save_register
  endif
endfunction

let s:STRING = SpaceVim#api#import('data#string')
function! s:parse_symbol(symbol) abort
  if a:symbol =~# '^[a-z]\+\(-[a-zA-Z]\+\)*$'
    return split(a:symbol, '-')
  elseif a:symbol =~# '^[a-z]\+\(_[a-zA-Z]\+\)*$'
    return split(a:symbol, '_')
  elseif a:symbol =~# '^[a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = s:STRING.string2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        call add(rst, tolower(word))
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  elseif a:symbol =~# '^[A-Z][a-z]\+\([A-Z][a-z]\+\)*$'
    let chars = s:STRING.string2chars(a:symbol)
    let rst = []
    let word = ''
    for char in chars
      if char =~# '[a-z]'
        let word .= char
      else
        if !empty(word)
          call add(rst, tolower(word))
        endif
        let word = char
      endif
    endfor
    call add(rst, tolower(word))
    return rst
  else
    return [a:symbol]
  endif
endfunction

function! s:count_selection_region() abort
  call feedkeys("gvg\<c-g>\<Esc>", 'ti')
endfunction


function! s:delete_extra_space() abort
  if !empty(getline('.'))
    if getline('.')[col('.')-1] ==# ' '
      execute "normal! \"_ciw\<Space>\<Esc>"
    endif
  endif
endfunction

function! s:set_justification_to(align) abort
  let l:startlinenr = line("'{")
  let l:endlinenr = line("'}")
  if getline(l:startlinenr) ==# ''
    let l:startlinenr += 1
  endif
  if getline(l:endlinenr) ==# ''
    let l:endlinenr -= 1
  endif
  let l:lineList = map(getline(l:startlinenr, l:endlinenr), 'trim(v:val)')
  let l:maxlength = 0
  for l:line in l:lineList
    let l:length = strdisplaywidth(l:line)
    if l:length > l:maxlength
      let l:maxlength = l:length
    endif
  endfor

  if a:align ==# 'left'
    execute l:startlinenr . ',' . l:endlinenr . ":left\<cr>"
  elseif a:align ==# 'center'
    execute l:startlinenr . ',' . l:endlinenr . ':center ' . l:maxlength . "\<cr>"
  elseif a:align ==# 'right'
    execute l:startlinenr . ',' . l:endlinenr . ':right  ' . l:maxlength . "\<cr>"
  endif

  unlet l:startlinenr
  unlet l:endlinenr
  unlet l:lineList
  unlet l:maxlength
endfunction

let s:local_lorem_ipsum = [
      \ 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
      \ 'Donec hendrerit tempor tellus.',
      \ 'Donec pretium posuere tellus.',
      \ 'Proin quam nisl, tincidunt et, mattis eget, convallis nec, purus.',
      \ 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
      \ 'Nulla posuere.',
      \ 'Donec vitae dolor.',
      \ 'Nullam tristique diam non turpis.',
      \ 'Cras placerat accumsan nulla.',
      \ 'Nullam rutrum.',
      \ 'Nam vestibulum accumsan nisl.',
      \ 'Pellentesque dapibus suscipit ligula.',
      \ 'Donec posuere augue in quam.',
      \ 'Etiam vel tortor sodales tellus ultricies commodo.',
      \ 'Suspendisse potenti.',
      \ 'Aenean in sem ac leo mollis blandit.',
      \ 'Donec neque quam, dignissim in, mollis nec, sagittis eu, wisi.',
      \ 'Phasellus lacus.',
      \ 'Etiam laoreet quam sed arcu.',
      \ 'Phasellus at dui in ligula mollis ultricies.',
      \ 'Integer placerat tristique nisl.',
      \ 'Praesent augue.',
      \ 'Fusce commodo.',
      \ 'Vestibulum convallis, lorem a tempus semper, dui dui euismod elit, vitae placerat urna tortor vitae lacus.',
      \ 'Nullam libero mauris, consequat quis, varius et, dictum id, arcu.',
      \ 'Mauris mollis tincidunt felis.',
      \ 'Aliquam feugiat tellus ut neque.',
      \ 'Nulla facilisis, risus a rhoncus fermentum, tellus tellus lacinia purus, et dictum nunc justo sit amet elit.',
      \ 'Aliquam erat volutpat.',
      \ 'Nunc eleifend leo vitae magna.',
      \ 'In id erat non orci commodo lobortis.',
      \ 'Proin neque massa, cursus ut, gravida ut, lobortis eget, lacus.',
      \ 'Sed diam.',
      \ 'Praesent fermentum tempor tellus.',
      \ 'Nullam tempus.',
      \ 'Mauris ac felis vel velit tristique imperdiet.',
      \ 'Donec at pede.',
      \ 'Etiam vel neque nec dui dignissim bibendum.',
      \ 'Vivamus id enim.',
      \ 'Phasellus neque orci, porta a, aliquet quis, semper a, massa.',
      \ 'Phasellus purus.',
      \ 'Pellentesque tristique imperdiet tortor.',
      \ 'Nam euismod tellus id erat.',
      \ 'Nullam eu ante vel est convallis dignissim.',
      \ 'Fusce suscipit, wisi nec facilisis facilisis, est dui fermentum leo, quis tempor ligula erat quis odio.',
      \ 'Nunc porta vulputate tellus.',
      \ 'Nunc rutrum turpis sed pede.',
      \ 'Sed bibendum.',
      \ 'Aliquam posuere.',
      \ 'Nunc aliquet, augue nec adipiscing interdum, lacus tellus malesuada massa, quis varius mi purus non odio.',
      \ 'Pellentesque condimentum, magna ut suscipit hendrerit, ipsum augue ornare nulla, non luctus diam neque sit amet urna.',
      \ 'Curabitur vulputate vestibulum lorem.',
      \ 'Fusce sagittis, libero non molestie mollis, magna orci ultrices dolor, at vulputate neque nulla lacinia eros.',
      \ 'Sed id ligula quis est convallis tempor.',
      \ 'Curabitur lacinia pulvinar nibh.',
      \ 'Nam a sapien.',
      \ ]

let s:lorem_ipsum_paragraph_separator = "\n\n"
let s:lorem_ipsum_sentence_separator = '  '
let s:lorem_ipsum_list_beginning = ''
let s:lorem_ipsum_list_bullet = '* '
let s:lorem_ipsum_list_item_end = "\n"
let s:lorem_ipsum_list_end = ''

function! s:insert_lorem_ipsum_list() abort
  let save_register = @k
  let @k =  '* ' . s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . "\n"
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_lorem_ipsum_paragraph() abort
  let save_register = @k
  let pids = len(s:local_lorem_ipsum) / 11
  let pid = s:NUMBER.random(0, pids) * 11
  let @k = join(s:LIST.listpart(s:local_lorem_ipsum, pid, 11), s:lorem_ipsum_sentence_separator) . s:lorem_ipsum_paragraph_separator
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_lorem_ipsum_sentence() abort
  let save_register = @k
  let @k =  s:local_lorem_ipsum[s:NUMBER.random(0, len(s:local_lorem_ipsum))] . s:lorem_ipsum_sentence_separator
  normal! "kgP
  let @k = save_register
endfunction

function! s:insert_simple_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_simple(v:count ? v:count : 8)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_stronger_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_strong(v:count ? v:count : 12)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_paranoid_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_paranoid(v:count ? v:count : 20)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_numerical_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_numeric(v:count ? v:count : 4)
  normal! "kPl
  let @k = save_register
endfunction
function! s:insert_phonetically_password() abort
  let save_register = @k
  let @k = s:PASSWORD.generate_phonetic(v:count ? v:count : 8)
  normal! "kPl
  let @k = save_register
endfunction

function! s:uuidgen_U() abort
  let uuid = system('uuidgen')
  let save_register = @k
  let @k = uuid
  normal! "kPl
  let @k = save_register
endfunction

function! s:align_at_regular_expression() abort
  let re = input(':Tabularize /')
  if !empty(re)
    exe 'Tabularize /' . re
  else
    normal! :
    echo 'empty input, canceled!'
  endif
endfunction


function! s:join_string_with() abort
  if s:is_string(line('.'), col('.'))
    let c = col('.')
    let a = 0
    let b = 0
    let _c = c
    while c > 0
      if s:is_string(line('.'), c)
        let c -= 1
      else
        let a = c
        break
      endif
    endwhile
    let c = _c
    while c > 0
      if s:is_string(line('.'), c)
        let c += 1
      else
        let b = c
        break
      endif
    endwhile
    let l:save_register_m = @m
    let line = getline('.')[:a] . join(split(getline('.')[a+1 : b]), '-') .  getline('.')[b :]
    call setline('.', line)
    let @m = l:save_register_m
  endif
endfunction

let s:string_hi = {
      \ 'c' : 'cCppString',
      \ 'cpp' : 'cCppString',
      \ }

function! s:is_string(l, c) abort
  return synIDattr(synID(a:l, a:c, 1), 'name') == get(s:string_hi, &filetype, &filetype . 'String')
endfunction


" function() wrapper
if v:version > 703 || v:version == 703 && has('patch1170')
  function! s:_function(fstr) abort
    return function(a:fstr)
  endfunction
else
  function! s:_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze__SID$')
  endfunction
  let s:_s = '<SNR>' . s:_SID() . '_'
  function! s:_function(fstr) abort
    return function(substitute(a:fstr, 's:', s:_s, 'g'))
  endfunction
endif

augroup spacevim_layer_edit
  au!
  autocmd FileType * call <SID>add_buffer_head()
augroup END
let s:ft_head_tp = {}
function! s:add_buffer_head() abort
  if has_key(s:ft_head_tp, &ft) && getline(1) ==# '' && line('$')  == 1
    let head = s:ft_head_tp[&ft]
    call setline(1, map(head, 's:parse(v:val)'))
    call cursor(len(head), 0)
  endif
endfunction

function! s:parse(line) abort
  return s:VIM.parse_string(a:line)
endfunction

function! SpaceVim#layers#edit#add_ft_head_tamplate(ft, tamp) abort
  call extend(s:ft_head_tp, {a:ft : a:tamp})
endfunction
