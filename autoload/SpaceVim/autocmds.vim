"=============================================================================
" autocmd.vim --- main autocmd group for spacevim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

"autocmds
function! SpaceVim#autocmds#init() abort
  augroup SpaceVim_core
    au!
    autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
          \   q :cclose<cr>:lclose<cr>
    autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix' ) |
          \   bd|
          \   q | endif
    autocmd FileType jsp call JspFileTypeInit()
    autocmd QuitPre * call SpaceVim#plugins#windowsmanager#UpdateRestoreWinInfo()
    autocmd WinEnter * call SpaceVim#plugins#windowsmanager#MarkBaseWin()
    autocmd FileType html,css,jsp EmmetInstall
    autocmd BufRead,BufNewFile *.pp setfiletype puppet
    if g:spacevim_enable_cursorline == 1
      autocmd BufEnter,WinEnter,InsertLeave * setl cursorline
      autocmd BufLeave,WinLeave,InsertEnter * setl nocursorline
    endif
    if g:spacevim_enable_cursorcolumn == 1
      autocmd BufEnter,WinEnter,InsertLeave * setl cursorcolumn
      autocmd BufLeave,WinLeave,InsertEnter * setl nocursorcolumn
    endif
    autocmd BufReadPost *
          \ if line("'\"") > 0 && line("'\"") <= line("$") |
          \   exe "normal! g`\"" |
          \ endif
    autocmd BufNewFile,BufEnter * set cpoptions+=d " NOTE: ctags find the tags file from the current path instead of the path of currect file
    autocmd BufEnter * :syntax sync fromstart " ensure every file does syntax highlighting (full)
    autocmd BufNewFile,BufRead *.avs set syntax=avs " for avs syntax file.
    autocmd FileType text setlocal textwidth=78 " for all text files set 'textwidth' to 78 characters.
    autocmd FileType c,cpp,cs,swig set nomodeline " this will avoid bug in my project with namespace ex, the vim will tree ex:: as modeline.
    autocmd FileType c,cpp,java,javascript set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f://
    autocmd FileType cs set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,f:///,f://
    autocmd FileType vim set comments=sO:\"\ -,mO:\"\ \ ,eO:\"\",f:\"
    autocmd FileType lua set comments=f:--
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd Filetype html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType xml call XmlFileTypeInit()
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd BufEnter *
          \   if empty(&buftype) && has('nvim') && &filetype != 'help'
          \|      nnoremap <silent><buffer> <C-]> :call MyTagfunc()<CR>
          \|      nnoremap <silent><buffer> <C-[> :call MyTagfuncBack()<CR>
          \|  else
            \|    if empty(maparg('<leader>[', 'n', 0, 1)) && empty(maparg('<leader>]', 'n', 0, 1))
            \|       nnoremap <silent><buffer> <leader>] :call MyTagfunc()<CR>
            \|       nnoremap <silent><buffer> <leader>[ :call MyTagfuncBack()<CR>
            \|    endif
            \|  endif
    "}}}
    autocmd FileType python,coffee call zvim#util#check_if_expand_tab()
    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    au StdinReadPost * call s:disable_welcome()
    autocmd InsertEnter * call s:fixindentline()
    if executable('synclient') && g:spacevim_auto_disable_touchpad
      let s:touchpadoff = 0
      autocmd InsertEnter * call s:disable_touchpad()
      autocmd InsertLeave * call s:enable_touchpad()
      autocmd FocusLost * call system('synclient touchpadoff=0')
      autocmd FocusGained * call s:reload_touchpad_status()
    endif
    autocmd BufWritePost *.vim call s:generate_doc()
    autocmd ColorScheme gruvbox call s:fix_gruvbox()
    autocmd VimEnter * call SpaceVim#autocmds#VimEnter()
  augroup END
endfunction

function! s:reload_touchpad_status() abort
  if s:touchpadoff
    call s:disable_touchpad()
  endif
endf
function! s:disable_touchpad() abort
  let s:touchpadoff = 1
  call system('synclient touchpadoff=1')
endfunction
function! s:enable_touchpad() abort
  let s:touchpadoff = 0
  call system('synclient touchpadoff=0')
endfunction
function! s:fixindentline() abort
  if !exists('s:done')
    if exists(':IndentLinesToggle') == 2
      IndentLinesToggle
      IndentLinesToggle
    else
      echohl WarningMsg
      echom 'plugin : indentLines has not been installed,
            \ please use `:call dein#install(["indentLine"])` to install this plugin,'
      echohl None
    endif
    let s:done = 1
  endif
endfunction
function! s:generate_doc() abort
  if filereadable('./addon-info.json') && executable('vimdoc')
    call SpaceVim#api#import('job').start(['vimdoc', '.'])
  endif
endfunction

function! s:fix_gruvbox() abort
  if &background ==# 'dark'
    hi VertSplit guibg=#282828 guifg=#181A1F
    "hi EndOfBuffer guibg=#282828 guifg=#282828
  else
    hi VertSplit guibg=#fbf1c7 guifg=#e7e9e1
    "hi EndOfBuffer guibg=#fbf1c7 guifg=#fbf1c7
  endif
  hi SpaceVimLeaderGuiderGroupName cterm=bold ctermfg=175 gui=bold guifg=#d3869b
endfunction
function! SpaceVim#autocmds#VimEnter() abort
  call SpaceVim#api#import('vim#highlight').hide_in_normal('EndOfBuffer')
  for argv in g:_spacevim_mappings_space_custom
    call call('SpaceVim#mapping#space#def', argv)
  endfor
  if get(g:, '_spacevim_statusline_loaded', 0) == 1
    set laststatus=2
    call SpaceVim#layers#core#statusline#def_colors()
    setlocal statusline=%!SpaceVim#layers#core#statusline#get(1)
  endif
  if get(g:, '_spacevim_tabline_loaded', 0) == 1
    call SpaceVim#layers#core#tabline#def_colors()
    set showtabline=2
  endif
endfunction

function! s:disable_welcome() abort
    augroup SPwelcome
        au!
    augroup END
endfunction


" vim:set et sw=2:
