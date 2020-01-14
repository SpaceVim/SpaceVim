let s:VCOP = SpaceVim#api#import('vim#compatible')
if get(g:, 'spacevim_filetree_direction', 'right') ==# 'right'
  let g:NERDTreeWinPos = 'rightbelow'
else
  let g:NERDTreeWinPos = 'left'
endif
let g:NERDTreeWinSize=get(g:,'NERDTreeWinSize',31)
let g:NERDTreeChDirMode=get(g:,'NERDTreeChDirMode',1)
let g:NERDTreeShowHidden = get(g:, '_spacevim_filetree_show_hidden_files', 0)
augroup nerdtree_zvim
  autocmd!
  autocmd bufenter *
        \ if (winnr('$') == 1 && exists('b:NERDTree')
        \ && b:NERDTree.isTabTree())
        \|   q
        \| endif
  autocmd FileType nerdtree call s:nerdtreeinit()
augroup END


function! s:nerdtreeinit() abort
  nnoremap <silent><buffer> yY  :<C-u>call <SID>copy_to_system_clipboard()<CR>
  nnoremap <silent><buffer> P  :<C-u>call <SID>paste_to_file_manager()<CR>
endfunction

function! s:paste_to_file_manager() abort
  let path = g:NERDTreeFileNode.GetSelected().path.str()
  if !isdirectory(path)
    let path = fnamemodify(path, ':p:h')
  endif
  let old_wd = getcwd()
  if old_wd == path
    call s:VCOP.systemlist(['xclip-pastefile'])
  else
    noautocmd exe 'cd' fnameescape(path)
    call s:VCOP.systemlist(['xclip-pastefile'])
    noautocmd exe 'cd' fnameescape(old_wd)
  endif
endfunction

function! s:copy_to_system_clipboard() abort
  let filename = g:NERDTreeFileNode.GetSelected().path.str()
  call s:VCOP.systemlist(['xclip-copyfile', filename])
  echo 'Yanked:' . (type(filename) == 3 ? len(filename) : 1 ) . ( isdirectory(filename) ? 'directory' : 'file'  )
endfunction
