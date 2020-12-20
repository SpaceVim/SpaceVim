scriptencoding utf-8
" load api
let s:sys = SpaceVim#api#import('system')


" denite option
let s:denite_options = {
      \ 'default' : {
      \ 'winheight' : 15,
      \ 'mode' : 'insert',
      \ 'start_filter' : 1,
      \ 'quit' : 1,
      \ 'highlight_matched_char' : 'MoreMsg',
      \ 'highlight_matched_range' : 'MoreMsg',
      \ 'direction': 'rightbelow',
      \ 'statusline' : has('patch-7.4.1154') ? v:false : 0,
      \ 'prompt' : g:spacevim_commandline_prompt,
      \ }}

function! s:profile(opts) abort
  for fname in keys(a:opts)
    for dopt in keys(a:opts[fname])
      call denite#custom#option(fname, dopt, a:opts[fname][dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

" buffer source
call denite#custom#var(
      \ 'buffer',
      \ 'date_format', '%m-%d-%Y %H:%M:%S')

" denite command
if !s:sys.isWindows
  if executable('rg')
    " For ripgrep
    " Note: It is slower than ag
    call denite#custom#var('file/rec', 'command',
          \ ['rg', '--hidden', '--files', '--glob', '!.git', '--glob', '']
          \ + SpaceVim#util#Generate_ignore(g:spacevim_wildignore, 'rg')
          \ )
  elseif executable('ag')
    " Change file/rec command.
    call denite#custom#var('file/rec', 'command',
          \ ['ag' , '--nocolor', '--nogroup', '-g', '']
          \ + SpaceVim#util#Generate_ignore(g:spacevim_wildignore, 'ag')
          \ )
  endif
else
  if executable('pt')
    " For Pt(the platinum searcher)
    " NOTE: It also supports windows.
    call denite#custom#var('file/rec', 'command',
          \ ['pt', '--nocolor', '--ignore', '.git', '--hidden', '-g=', ''])
  endif
endif

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

" FIND and GREP COMMANDS
if executable('rg')
  " Ripgrep command on grep source
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])

elseif  executable('pt')
  " Pt command on grep source
  call denite#custom#var('grep', 'command', ['pt'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--nogroup', '--nocolor', '--smart-case'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
elseif executable('ag')
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ [ '--vimgrep', '--smart-case' ])
elseif executable('ack')
  " Ack command
  call denite#custom#var('grep', 'command', ['ack'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--match'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ ['--ackrc', $HOME.'/.config/ackrc', '-H',
        \ '--nopager', '--nocolor', '--nogroup', '--column'])
endif

" enable unite menu compatibility
call denite#custom#var('menu', 'unite_source_menu_compatibility', 1)

" KEY MAPPINGS
let s:insert_mode_mappings = [
      \ ['jk', '<denite:enter_mode:normal>', 'noremap'],
      \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['<C-t>', '<denite:do_action:tabopen>', 'noremap'],
      \ ['<C-v>', '<denite:do_action:vsplit>', 'noremap'],
      \ ['<C-s>', '<denite:do_action:split>', 'noremap'],
      \ ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
      \ ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
      \ ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
      \ ['<Up>', '<denite:assign_previous_text>', 'noremap'],
      \ ['<Down>', '<denite:assign_next_text>', 'noremap'],
      \ ['<C-Y>', '<denite:redraw>', 'noremap'],
      \ ]

let s:normal_mode_mappings = [
      \ ["'", '<denite:toggle_select_down>', 'noremap'],
      \ ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
      \ ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
      \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['gg', '<denite:move_to_first_line>', 'noremap'],
      \ ['<C-t>', '<denite:do_action:tabopen>', 'noremap'],
      \ ['<C-v>', '<denite:do_action:vsplit>', 'noremap'],
      \ ['<C-s>', '<denite:do_action:split>', 'noremap'],
      \ ['q', '<denite:quit>', 'noremap'],
      \ ['r', '<denite:redraw>', 'noremap'],
      \ ]

" this is for old version of denite
for s:m in s:insert_mode_mappings
  call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
  call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

unlet s:m s:insert_mode_mappings s:normal_mode_mappings


" Define mappings
augroup spacevim_layer_denite
  autocmd!
  autocmd FileType denite call s:denite_my_settings()
  autocmd FileType denite-filter call s:denite_filter_my_settings()
augroup END

function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> '
        \ denite#do_map('toggle_select').'j'
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-t>
        \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-s>
        \ denite#do_map('do_action', 'split')
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><Tab> j
  nnoremap <silent><buffer><S-Tab> k
endfunction

function! s:denite_filter_my_settings() abort
  call s:clear_imap('<C-g>g')
  call s:clear_imap('<C-g>S')
  call s:clear_imap('<C-g>s')
  call s:clear_imap('<C-g>%')
  imap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
  imap <silent><buffer> <C-g> <Plug>(denite_filter_quit):q<Cr>
  inoremap <silent><buffer> <Tab>
        \ <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
  inoremap <silent><buffer> <S-Tab>
        \ <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  " @fixme use this key binding only for sources which has delete action
  inoremap <silent><buffer><expr> <C-d>
        \ <SID>delete_action()
  if exists('*deoplete#custom#buffer_option')
    call deoplete#custom#buffer_option('auto_complete', v:false)
  endif
endfunction


function! s:delete_action() abort
  if SpaceVim#layers#core#statusline#denite_status("sources") =~# '^buffer'
    return denite#do_map('do_action', 'delete')
  else
    return ''
  endif
endfunction


function! s:clear_imap(map) abort
  if maparg(a:map, 'i')
    exe 'iunmap <buffer> ' . a:map
  endif
endfunction

" vim:set et sw=2 cc=80:
