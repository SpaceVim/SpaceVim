scriptencoding utf-8
call unite#custom#source('codesearch', 'max_candidates', 30)
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {
      \   'safe': 0,
      \   'start_insert': 1,
      \   'ignorecase' : 1,
      \   'short_source_names': 1,
      \   'update_time': 200,
      \   'direction': 'rightbelow',
      \   'winwidth': 40,
      \   'winheight': 15,
      \   'max_candidates': 100,
      \   'no_auto_resize': 1,
      \   'vertical_preview': 1,
      \   'cursor_line_time': '0.10',
      \   'hide_icon': 0,
      \   'candidate-icon': ' ',
      \   'marked_icon': '✓',
      \   'prompt' : '➭ '
      \ })
call unite#custom#profile('source/neobundle/update', 'context', {
      \   'start_insert' : 0,
      \ })
let g:unite_source_codesearch_ignore_case = get(g:,
      \ 'unite_source_codesearch_ignore_case', 1)
let g:unite_source_buffer_time_format = get(g:,
      \ 'unite_source_buffer_time_format', '(%m-%d-%Y %H:%M:%S) ')
let g:unite_source_file_mru_time_format = get(g:,
      \ 'unite_source_file_mru_time_format', '(%m-%d-%Y %H:%M:%S) ')
let g:unite_source_directory_mru_time_format = get(g:,
      \ 'unite_source_directory_mru_time_format', '(%m-%d-%Y %H:%M:%S) ')
let g:unite_source_directory_mru_limit = get(g:,
      \ 'unite_source_directory_mru_limit', 80)
let g:unite_source_file_rec_max_depth = get(g:,
      \ 'unite_source_file_rec_max_depth', 6)
let g:unite_enable_ignore_case = get(g:, 'unite_enable_ignore_case', 1)
let g:unite_enable_smart_case = get(g:, 'unite_enable_smart_case', 1)
let g:unite_data_directory = get(g:, 'unite_data_directory',g:spacevim_data_dir.'/unite')
"let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable = get(g:,
      \ 'unite_source_history_yank_enable', 1)
let g:unite_split_rule = get(g:, 'unite_split_rule', 'botright')
let g:unite_winheight = get(g:, 'unite_winheight', 25)
let g:unite_source_grep_default_opts = get(g:,
      \ 'unite_source_grep_default_opts',
      \ '-iRHn'
      \ . " --exclude='tags'"
      \ . " --exclude='cscope*'"
      \ . " --exclude='*.svn*'"
      \ . " --exclude='*.log*'"
      \ . " --exclude='*tmp*'"
      \ . " --exclude-dir='**/tmp'"
      \ . " --exclude-dir='CVS'"
      \ . " --exclude-dir='.svn'"
      \ . " --exclude-dir='.git'"
      \ . " --exclude-dir='node_modules'")
let g:unite_launch_apps = get(g:, 'unite_launch_apps', [
      \ 'rake',
      \ 'make',
      \ 'git pull',
      \ 'git push'])
let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
let g:unite_source_menu_menus.git = {
      \ 'description' : '            gestionar repositorios git
      \                            ⌘ [espacio]g',
      \}
let g:unite_source_menu_menus.git.command_candidates = [
      \['▷ tig                                                        ⌘ ,gt',
      \'normal ,gt'],
      \['▷ git status       (Fugitive)                                ⌘ ,gs',
      \'Gstatus'],
      \['▷ git diff         (Fugitive)                                ⌘ ,gd',
      \'Gdiff'],
      \['▷ git commit       (Fugitive)                                ⌘ ,gc',
      \'Gcommit'],
      \['▷ git log          (Fugitive)                                ⌘ ,gl',
      \'exe "silent Glog | Unite quickfix"'],
      \['▷ git blame        (Fugitive)                                ⌘ ,gb',
      \'Gblame'],
      \['▷ git stage        (Fugitive)                                ⌘ ,gw',
      \'Gwrite'],
      \['▷ git checkout     (Fugitive)                                ⌘ ,go',
      \'Gread'],
      \['▷ git rm           (Fugitive)                                ⌘ ,gr',
      \'Gremove'],
      \['▷ git mv           (Fugitive)                                ⌘ ,gm',
      \'exe "Gmove " input("destino: ")'],
      \['▷ git push         (Fugitive, salida por buffer)             ⌘ ,gp',
      \'Git! push'],
      \['▷ git pull         (Fugitive, salida por buffer)             ⌘ ,gP',
      \'Git! pull'],
      \['▷ git prompt       (Fugitive, salida por buffer)             ⌘ ,gi',
      \'exe "Git! " input("comando git: ")'],
      \['▷ git cd           (Fugitive)',
      \'Gcd'],
      \]
"===============================================================================
" HTTP Status Code Definitions
"===============================================================================
let g:unite_source_menu_menus.StatusCodeDefinitions = {'description':
      \ 'HTTP status code definitions             <leader>sc'}
let g:unite_source_menu_menus.StatusCodeDefinitions.command_candidates = [
      \['➤ 100 Continue                                                   ',
      \ 'echo "Continue"'],
      \['➤ 101 Switching Protocols                                        ',
      \ 'echo "Switching Protocols"'],
      \['➤ 200 OK                                                         ',
      \ 'echo "OK"'],
      \['➤ 201 Created                                                    ',
      \ 'echo "Created"'],
      \['➤ 202 Accepted                                                   ',
      \ 'echo "Accepted"'],
      \['➤ 203 Non-Authoritative Information                              ',
      \ 'echo "Non-Authoritative Information"'],
      \['➤ 204 No Content                                                 ',
      \ 'echo "No Content"'],
      \['➤ 205 Reset Content                                              ',
      \ 'echo "Reset Content"'],
      \['➤ 206 Partial Content                                            ',
      \ 'echo "Partial Content"'],
      \['➤ 300 Multiple Choices                                           ',
      \ 'echo "Multiple Choices"'],
      \['➤ 301 Moved Permanently                                          ',
      \ 'echo "Moved Permanently"'],
      \['➤ 302 Found                                                      ',
      \ 'echo "Found"'],
      \['➤ 303 See Other                                                  ',
      \ 'echo "See Other"'],
      \['➤ 304 Not Modified                                               ',
      \ 'echo "Not Modified"'],
      \['➤ 305 Use Proxy                                                  ',
      \ 'echo "Use Proxy"'],
      \['➤ 307 Temporary Redirect                                         ',
      \ 'echo "Temporary Redirect"'],
      \['➤ 400 Bad Request                                                ',
      \ 'echo "Bad Request"'],
      \['➤ 401 Unauthorized                                               ',
      \ 'echo "Unauthorized"'],
      \['➤ 402 Payment Required                                           ',
      \ 'echo "Payment Required"'],
      \['➤ 403 Forbidden                                                  ',
      \ 'echo "Forbidden"'],
      \['➤ 404 Not Found                                                  ',
      \ 'echo "Not Found"'],
      \['➤ 405 Method Not Allowed                                         ',
      \ 'echo "Method Not Allowed"'],
      \['➤ 406 Not Acceptable                                             ',
      \ 'echo "Not Acceptable"'],
      \['➤ 407 Proxy Authentication Required                              ',
      \ 'echo "Proxy Authoritative Required"'],
      \['➤ 408 Request Timeout                                            ',
      \ 'echo "Request Timeout"'],
      \['➤ 409 Conflict                                                   ',
      \ 'echo "Conflict"'],
      \['➤ 410 Gone                                                       ',
      \ 'echo "Gone"'],
      \['➤ 411 Length Required                                            ',
      \ 'echo "Length Required"'],
      \['➤ 412 Precondition Failed                                        ',
      \ 'echo "Precondition Failed"'],
      \['➤ 413 Request Entity Too Large                                   ',
      \ 'echo "Request Entity Too Large"'],
      \['➤ 414 Request-URI Too Long                                       ',
      \ 'echo "Request-URI Too Long"'],
      \['➤ 415 Unsupported Media Type                                     ',
      \ 'echo "Unsupported Media Type"'],
      \['➤ 416 Requested Range Not Satisfiable                            ',
      \ 'echo "Requested Range Not Satisfiable"'],
      \['➤ 417 Expectation Failed                                         ',
      \ 'echo "Expectation Failed"'],
      \['➤ 422 Unprocessable Entity                                       ',
      \ 'echo "Unprocessable Entity"'],
      \['➤ 500 Internal Server Error                                      ',
      \ 'echo "Internal Server Error"'],
      \['➤ 501 Not Implemented                                            ',
      \ 'echo "Not Implemented"'],
      \['➤ 502 Bad Gateway                                                ',
      \ 'echo "Bad Gateway"'],
      \['➤ 503 Service Unavailable                                        ',
      \ 'echo "Service Unavailable"'],
      \['➤ 504 Gateway Timeout                                            ',
      \ 'echo "Gateway Timeout"'],
      \['➤ 505 HTTP Version Not Supported                                 ',
      \ 'echo "HTTP Version Not Supported"'],
      \]
let g:unite_source_grep_max_candidates = get(g:,
      \ 'unite_source_grep_max_candidates', 200)
if executable('hw')
  " Use hw (highway)
  " https://github.com/tkengo/highway
  let g:unite_source_grep_command = 'hw'
  let g:unite_source_grep_default_opts = '--no-group --no-color'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ag')
  " Use ag (the silver searcher)
  " https://github.com/ggreer/the_silver_searcher
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('rg') && 0
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = ''
  let g:unite_source_grep_recursive_opt = ''
elseif executable('pt')
  " Use pt (the platinum searcher)
  " https://github.com/monochromegane/the_platinum_searcher
  let g:unite_source_grep_command = 'pt'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack-grep')
  " Use ack
  " http://beyondgrep.com/
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('jvgrep')
  " Use jvgrep
  " https://github.com/mattn/jvgrep
  let g:unite_source_grep_command = 'jvgrep'
  let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
elseif executable('beagrep')
  " Use beagrep
  " https://github.com/baohaojun/beagrep
  let g:unite_source_grep_command = 'beagrep'
endif
let g:unite_source_rec_async_command = get(g:,
      \ 'unite_source_rec_async_command',
      \ ['ag', '--follow', '--nocolor', '--nogroup',
      \  '--hidden', '-g', ''])
call unite#custom#profile('file_rec/async,file_rec/git', 'context', {
      \   'start_insert' : 1,
      \   'quit'         : 1,
      \   'split'        : 1,
      \   'keep_focus'   : 1,
      \   'winheight'    : 20,
      \ })
call unite#custom#source('file_rec/async,file_rec/neovim', 'ignore_globs',
      \ ['*.png','.git/','*.ttf', '*.eot', '*.woff', '*.svg'])
call unite#custom#profile('buffer,buffer_tab', 'context', {
      \   'start_insert' : 0,
      \   'quit'         : 1,
      \   'keep_focus'   : 1,
      \ })
function! s:view_github_starred_repos() abort
  if empty(g:unite_source_menu_menus.MyStarredrepos.command_candidates)
    if UpdateStarredRepos()
      Unite -silent -ignorecase -winheight=17 -start-insert menu:MyStarredrepos
    endif
  else
    Unite -silent -ignorecase -winheight=17 -start-insert menu:MyStarredrepos
  endif
endfunction
if SpaceVim#layers#isLoaded('tools#mpv')
  call SpaceVim#layers#tools#mpv#loadMusics()
endif
augroup unite_buffer_feature
  autocmd FileType unite call s:unite_my_settings()
augroup END
function! s:unite_my_settings()
  " Overwrite settings.
  setlocal nowrap

  " Play nice with supertab
  let b:SuperTabDisabled=1

  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>     <Plug>(unite_select_next_line)
  nmap <buffer> <C-j>     <Plug>(unite_select_next_line)
  imap <buffer> <TAB>     <Plug>(unite_select_next_line)
  nmap <buffer> <TAB>     <Plug>(unite_select_next_line)
  imap <buffer> <C-k>     <Plug>(unite_select_previous_line)
  nmap <buffer> <C-k>     <Plug>(unite_select_previous_line)
  imap <buffer> <S-Tab>   <Plug>(unite_select_previous_line)
  nmap <buffer> <S-Tab>   <Plug>(unite_select_previous_line)
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer><expr> j unite#smart_map('j', '')

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
  nmap <silent><buffer><expr> <C-s>     unite#do_action('split')

  " Runs "vsplit" action by <C-v>.
  imap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-v>     unite#do_action('vsplit')

  " Runs "tabopen" action by <C-t>.
  imap <silent><buffer><expr> <C-t>     unite#do_action('tabopen')
  nmap <silent><buffer><expr> <C-t>     unite#do_action('tabopen')

  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>     <Plug>(unite_narrowing_path)
  nmap <buffer> <C-e>     <Plug>(unite_toggle_auto_preview)
  imap <buffer> <C-e>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif
  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
endfunction

" vim:set et sw=2 cc=80:
