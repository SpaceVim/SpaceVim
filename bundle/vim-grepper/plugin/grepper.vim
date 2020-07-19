" Initialization {{{1

if exists('g:loaded_grepper')
  finish
endif
let g:loaded_grepper = 1

" Escaping test line:
" ..ad\\f40+$':-# @=,!;%^&&*()_{}/ /4304\'""?`9$343%$ ^adfadf[ad)[(

highlight default link GrepperPrompt Question

"
" Default values that get used for missing values in g:grepper.
"
let s:defaults = {
      \ 'quickfix':      1,
      \ 'open':          1,
      \ 'switch':        1,
      \ 'jump':          0,
      \ 'cword':         0,
      \ 'prompt':        1,
      \ 'prompt_text':   '$c> ',
      \ 'prompt_quote':  0,
      \ 'highlight':     0,
      \ 'buffer':        0,
      \ 'buffers':       0,
      \ 'append':        0,
      \ 'searchreg':     0,
      \ 'side':          0,
      \ 'side_cmd':      'vnew',
      \ 'stop':          5000,
      \ 'dir':           'cwd',
      \ 'prompt_mapping_tool': '<tab>',
      \ 'prompt_mapping_dir':  '<c-d>',
      \ 'prompt_mapping_side': '<c-s>',
      \ 'repo':          ['.git', '.hg', '.svn'],
      \ 'tools':         ['git', 'ag', 'ack', 'ack-grep', 'grep', 'findstr', 'rg', 'pt', 'sift'],
      \ 'git':           { 'grepprg':    'git grep -nGI',
      \                    'grepformat': '%f:%l:%c:%m,%f:%l:%m,%f',
      \                    'escape':     '\^$.*[]' },
      \ 'ag':            { 'grepprg':    'ag --vimgrep',
      \                    'grepformat': '%f:%l:%c:%m,%f:%l:%m,%f',
      \                    'escape':     '\^$.*+?()[]{}|' },
      \ 'rg':            { 'grepprg':    'rg -H --no-heading --vimgrep' . (has('win32') ? ' $* .' : ''),
      \                    'grepformat': '%f:%l:%c:%m,%f',
      \                    'escape':     '\^$.*+?()[]{}|' },
      \ 'pt':            { 'grepprg':    'pt --nogroup',
      \                    'grepformat': '%f:%l:%m,%f' },
      \ 'sift':          { 'grepprg':    'sift -n --column --binary-skip $* .',
      \                    'grepprgbuf': 'sift -n --column --binary-skip --filename -- $* $.',
      \                    'grepformat': '%f:%l:%c:%m,%f',
      \                    'escape':     '\+*?^$%#()[]' },
      \ 'ack':           { 'grepprg':    'ack --noheading --column',
      \                    'grepformat': '%f:%l:%c:%m,%f',
      \                    'escape':     '\^$.*+?()[]{}|' },
      \ 'ack-grep':      { 'grepprg':    'ack-grep --noheading --column',
      \                    'grepformat': '%f:%l:%c:%m,%f',
      \                    'escape':     '\^$.*+?()[]{}|' },
      \ 'grep':          { 'grepprg':    'grep -RIn $* .',
      \                    'grepprgbuf': 'grep -HIn -- $* $.',
      \                    'grepformat': '%f:%l:%m,%f',
      \                    'escape':     '\^$.*[]' },
      \ 'findstr':       { 'grepprg':    'findstr -rspnc:$* *',
      \                    'grepprgbuf': 'findstr -rpnc:$* $.',
      \                    'grepformat': '%f:%l:%m,%f',
      \                    'wordanchors': ['\<', '\>'] }
      \ }

" Make it possible to configure the global and operator behaviours separately.
let s:defaults.operator = deepcopy(s:defaults)
let s:defaults.operator.prompt = 0

let s:has_doau_modeline = v:version > 703 || v:version == 703 && has('patch442')

function! s:merge_configs(config, defaults) abort
  let new = deepcopy(a:config)

  " Add all missing default options.
  call extend(new, a:defaults, 'keep')

  " Global options.
  for k in keys(a:config)
    if k == 'operator'
      continue
    endif

    " If only part of an option dict was set, add the missing default keys.
    if type(new[k]) == type({}) && has_key(a:defaults, k) && new[k] != a:defaults[k]
      call extend(new[k], a:defaults[k], 'keep')
    endif

    " Inherit operator option from global option unless it already exists or
    " has a default value where the global option has not.
    if !has_key(new.operator, k) || (has_key(a:defaults, k)
          \                          && new[k] != a:defaults[k]
          \                          && new.operator[k] == s:defaults.operator[k])
      let new.operator[k] = deepcopy(new[k])
    endif
  endfor

  " Operator options.
  if has_key(a:config, 'operator')
    for opt in keys(a:config.operator)
      " If only part of an operator option dict was set, inherit the missing
      " keys from the global option.
      if type(new.operator[opt]) == type({}) && new.operator[opt] != new[opt]
        call extend(new.operator[opt], new[opt], 'keep')
      endif
    endfor
  endif

  return new
endfunction

let g:grepper = exists('g:grepper')
      \ ? s:merge_configs(g:grepper, s:defaults)
      \ : deepcopy(s:defaults)

for s:tool in g:grepper.tools
  if !has_key(g:grepper, s:tool)
        \ || !has_key(g:grepper[s:tool], 'grepprg')
        \ || !executable(expand(matchstr(g:grepper[s:tool].grepprg, '^[^ ]*')))
    call remove(g:grepper.tools, index(g:grepper.tools, s:tool))
  endif
endfor

"
" Special case: ack (different distros use different names for ack)
" Prefer ack-grep since its presence likely means ack is a different tool.
"
let s:ack     = index(g:grepper.tools, 'ack')
let s:ackgrep = index(g:grepper.tools, 'ack-grep')
if (s:ack >= 0) && (s:ackgrep >= 0)
  call remove(g:grepper.tools, s:ack)
endif

let s:cmdline = ''
let s:slash   = exists('+shellslash') && !&shellslash ? '\' : '/'

let s:git_column_flag_checked = 0

" Job handlers {{{1
" s:on_stdout_nvim() {{{2
function! s:on_stdout_nvim(_job_id, data, _event) dict abort
  if !exists('s:id')
    return
  endif

  let orig_dir = s:chdir_push(self.work_dir)
  let lcandidates = []

  try
    if len(a:data) > 1 || empty(a:data[-1])
      " Second-last item is the last complete line in a:data.
      let acc_line = self.stdoutbuf . a:data[0]
      let lcandidates = (empty(acc_line) ? [] : [acc_line]) + a:data[1:-2]
      let self.stdoutbuf = ''
    endif
    " Last item in a:data is an incomplete line (or empty), append to buffer
    let self.stdoutbuf .= a:data[-1]

    if self.flags.stop > 0 && (self.num_matches + len(lcandidates) >= self.flags.stop)
      " Add the remaining data
      let n_rem_lines = self.flags.stop - self.num_matches
      if n_rem_lines > 0
        noautocmd execute self.addexpr 'lcandidates[:n_rem_lines-1]'
        let self.num_matches = self.flags.stop
      endif

      silent! call jobstop(s:id)
      unlet! s:id
      return
    else
      noautocmd execute self.addexpr 'lcandidates'
      let self.num_matches += len(lcandidates)
    endif
  finally
    call s:chdir_pop(orig_dir)
  endtry
endfunction

" s:on_stdout_vim() {{{2
function! s:on_stdout_vim(_job_id, data) dict abort
  if !exists('s:id')
    return
  endif

  let orig_dir = s:chdir_push(self.work_dir)

  try
    noautocmd execute self.addexpr 'a:data'
    let self.num_matches += 1
    if self.flags.stop > 0 && self.num_matches >= self.flags.stop
      silent! call job_stop(s:id)
      unlet! s:id
    endif
  finally
    call s:chdir_pop(orig_dir)
  endtry
endfunction

" s:on_exit() {{{2
function! s:on_exit(...) dict abort
  execute 'tabnext' self.tabpage
  execute self.window .'wincmd w'
  unlet! s:id
  return s:finish_up(self.flags)
endfunction

" Completion {{{1
" grepper#complete() {{{2
function! grepper#complete(lead, line, _pos) abort
  if a:lead =~ '^-'
    let flags = ['-append', '-buffer', '-buffers', '-cd', '-cword', '-dir',
          \ '-grepprg', '-highlight', '-jump', '-open', '-prompt', '-query',
          \ '-quickfix', '-side', '-stop', '-switch', '-tool', '-noappend',
          \ '-nohighlight', '-nojump', '-noopen', '-noprompt', '-noquickfix',
          \ '-noside', '-noswitch']
    return filter(map(flags, 'v:val." "'), 'v:val[:strlen(a:lead)-1] ==# a:lead')
  elseif a:line =~# '-dir \w*$'
    return filter(map(['cwd', 'file', 'filecwd', 'repo'], 'v:val." "'),
          \ 'empty(a:lead) || v:val[:strlen(a:lead)-1] ==# a:lead')
  elseif a:line =~# '-stop $'
    return ['5000']
  elseif a:line =~# '-tool \w*$'
    return filter(map(sort(copy(g:grepper.tools)), 'v:val." "'),
          \ 'empty(a:lead) || v:val[:strlen(a:lead)-1] ==# a:lead')
  else
    return grepper#complete_files(a:lead, 0, 0)
  endif
endfunction

" grepper#complete_files() {{{2
function! grepper#complete_files(lead, _line, _pos)
  let [head, path] = s:extract_path(a:lead)
  " handle relative paths
  if empty(path) || (path =~ '\s$')
    return map(split(globpath('.'.s:slash, path.'*'), '\n'), 'head . "." . v:val[1:] . (isdirectory(v:val) ? s:slash : "")')
  " handle sub paths
  elseif path =~ '^.\/'
    return map(split(globpath('.'.s:slash, path[2:].'*'), '\n'), 'head . "." . v:val[1:] . (isdirectory(v:val) ? s:slash : "")')
  " handle absolute paths
  elseif path[0] == '/'
    return map(split(globpath(s:slash, path.'*'), '\n'), 'head . v:val[1:] . (isdirectory(v:val) ? s:slash : "")')
  endif
endfunction

" s:extract_path() {{{2
function! s:extract_path(string) abort
  let item = split(a:string, '.*\s\zs', 1)
  let len  = len(item)

  if     len == 0 | let [head, path] = ['', '']
  elseif len == 1 | let [head, path] = ['', item[0]]
  elseif len == 2 | let [head, path] = item
  else            | throw 'The unexpected happened!'
  endif

  return [head, path]
endfunction

" Statusline {{{1
" #statusline() {{{2
function! grepper#statusline() abort
  return s:cmdline
endfunction

" Helpers {{{1
" s:error() {{{2
function! s:error(msg)
  redraw
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" s:lstrip() {{{2
function! s:lstrip(string) abort
  return substitute(a:string, '^\s\+', '', '')
endfunction

" s:split_one() {{{2
function! s:split_one(string) abort
  let stripped = s:lstrip(a:string)
  let first_word = substitute(stripped, '\v^(\S+).*', '\1', '')
  let rest = substitute(stripped, '\v^\S+\s*(.*)', '\1', '')
  return [first_word, rest]
endfunction

" s:next_tool() {{{2
function! s:next_tool(flags)
  let a:flags.tools = a:flags.tools[1:-1] + [a:flags.tools[0]]
endfunction

" s:get_current_tool() {{{2
function! s:get_current_tool(flags) abort
  return a:flags[a:flags.tools[0]]
endfunction

" s:get_current_tool_name() {{{2
function! s:get_current_tool_name(flags) abort
  return a:flags.tools[0]
endfunction

" s:get_grepprg() {{{2
function! s:get_grepprg(flags) abort
  let tool = s:get_current_tool(a:flags)
  if a:flags.buffers
    return has_key(tool, 'grepprgbuf')
          \ ? substitute(tool.grepprgbuf, '\V$.', '$+', '')
          \ : tool.grepprg .' -- $* $+'
  elseif a:flags.buffer
    return has_key(tool, 'grepprgbuf')
          \ ? tool.grepprgbuf
          \ : tool.grepprg .' -- $* $.'
  endif
  return tool.grepprg
endfunction

" s:store_errorformat() {{{2
function! s:store_errorformat(flags) abort
  let prog = s:get_current_tool(a:flags)
  let s:errorformat = &errorformat
  let &errorformat = has_key(prog, 'grepformat') ? prog.grepformat : &errorformat
endfunction

" s:restore_errorformat() {{{2
function! s:restore_errorformat() abort
  let &errorformat = s:errorformat
endfunction

" s:restore_mapping() {{{2
function! s:restore_mapping(mapping)
  if !empty(a:mapping)
    execute printf('%s %s%s%s%s %s %s',
          \ (a:mapping.noremap ? 'cnoremap' : 'cmap'),
          \ (a:mapping.silent  ? '<silent>' : ''    ),
          \ (a:mapping.buffer  ? '<buffer>' : ''    ),
          \ (a:mapping.nowait  ? '<nowait>' : ''    ),
          \ (a:mapping.expr    ? '<expr>'   : ''    ),
          \  a:mapping.lhs,
          \  substitute(a:mapping.rhs, '\c<sid>', '<SNR>'.a:mapping.sid.'_', 'g'))
  endif
endfunction

" s:escape_query() {{{2
function! s:escape_query(flags, query)
  let tool = s:get_current_tool(a:flags)
  let a:flags.query_escaped = 1
  return shellescape(has_key(tool, 'escape')
        \ ? escape(a:query, tool.escape)
        \ : a:query)
endfunction

" s:unescape_query() {{{2
function! s:unescape_query(flags, query)
  let tool = s:get_current_tool(a:flags)
  let q = a:query
  if has_key(tool, 'escape')
    for c in reverse(split(tool.escape, '\zs'))
      let q = substitute(q, '\V\\'.c, c, 'g')
    endfor
  endif
  return q
endfunction

" s:requote_query() {{{2
function! s:requote_query(flags) abort
  if a:flags.cword
    let a:flags.query = s:escape_cword(a:flags, a:flags.query_orig)
  else
    let is_findstr = s:get_current_tool_name(a:flags) == 'findstr'
    if has_key(a:flags, 'query_orig')
      let a:flags.query = (is_findstr ? '' : '-- '). s:escape_query(a:flags, a:flags.query_orig)
    else
      if a:flags.prompt_quote >= 2
        let a:flags.query = a:flags.query[1:-2]
      else
        let a:flags.query = a:flags.query[:-1]
      endif
    endif
  endif
endfunction

" s:escape_cword() {{{2
function! s:escape_cword(flags, cword)
  let tool = s:get_current_tool(a:flags)
  let escaped_cword = has_key(tool, 'escape')
        \ ? escape(a:cword, tool.escape)
        \ : a:cword
  let wordanchors = has_key(tool, 'wordanchors')
        \ ? tool.wordanchors
        \ : ['\b', '\b']
  if a:cword =~# '^\k'
    let escaped_cword = wordanchors[0] . escaped_cword
  endif
  if a:cword =~# '\k$'
    let escaped_cword = escaped_cword . wordanchors[1]
  endif
  let a:flags.query_orig = a:cword
  let a:flags.query_escaped = 1
  return shellescape(escaped_cword)
endfunction

" s:compute_working_directory() {{{2
function! s:compute_working_directory(flags) abort
  if has_key(a:flags, 'cd')
    return a:flags.cd
  endif
  for dir in split(a:flags.dir, ',')
    if dir == 'repo'
      if s:get_current_tool_name(a:flags) == 'git'
        let dir = systemlist(printf('git -C %s rev-parse --show-toplevel',
              \ shellescape(expand('%:p:h'))))
        if !v:shell_error
          return dir[0]
        endif
      endif
      for repo in g:grepper.repo
        let repopath = finddir(repo, expand('%:p:h').';')
        if empty(repopath)
          let repopath = findfile(repo, expand('%:p:h').';')
        endif
        if !empty(repopath)
          let repopath = fnamemodify(repopath, ':h')
          return fnameescape(repopath)
        endif
      endfor
    elseif dir == 'filecwd'
      let cwd = getcwd()
      let bufdir = expand('%:p:h')
      if stridx(bufdir, cwd) != 0
        return fnameescape(bufdir)
      endif
    elseif dir == 'file'
      let bufdir = expand('%:p:h')
      return fnameescape(bufdir)
    elseif dir == 'cwd'
      return getcwd()
    else
      call s:error("Invalid -dir flag '" . a:flags.dir . "'")
    endif
  endfor
  return ''
endfunction

" s:chdir_push() {{{2
function! s:chdir_push(work_dir)
  if !empty(a:work_dir)
    let cwd = getcwd()
    execute 'lcd' a:work_dir
    return cwd
  endif
  return ''
endfunction

" s:chdir_pop() {{{2
function! s:chdir_pop(buf_dir)
  if !empty(a:buf_dir)
    execute 'lcd' fnameescape(a:buf_dir)
  endif
endfunction

" s:get_config() {{{2
function! s:get_config() abort
  let g:grepper = exists('g:grepper')
        \ ? s:merge_configs(g:grepper, s:defaults)
        \ : deepcopy(s:defaults)
  let flags = deepcopy(g:grepper)
  if exists('b:grepper')
    let flags = s:merge_configs(b:grepper, g:grepper)
  endif
  return flags
endfunction

" s:set_prompt_text() {{{2
function! s:set_prompt_text(flags) abort
  let text = get(a:flags, 'simple_prompt') ? '$t> ' : a:flags.prompt_text
  let text = substitute(text, '\V$t', s:get_current_tool_name(a:flags), '')
  let text = substitute(text, '\V$c', s:get_grepprg(a:flags), '')
  return text
endfunction

" s:set_prompt_op() {{{2
function! s:set_prompt_op(op) abort
  let s:prompt_op = a:op
  return getcmdline()
endfunction

" s:git_add_column_flag() {{{2
function! s:git_add_column_flag(flags) abort
  if !empty(filter(copy(a:flags.tools), 'v:val == "git"'))
        \ && a:flags.git.grepprg == 'git grep -nI'
    let m = matchlist(system('git --version'), '\v \zs(\d+)\.(\d+)')
    if !empty(m) && (m[1] > 2 || (m[1] == 2 && m[2] >= 19))
      let a:flags.git.grepprg   = 'git grep -nI --column'  " for current invocation
      let g:grepper.git.grepprg = 'git grep -nI --column'  " for subsequent invocations
    endif
  endif
  let s:git_column_flag_checked = 1
endfunction

" s:query2vimregexp() {{{2
function! s:query2vimregexp(flags) abort
  if has_key(a:flags, 'query_orig')
    let query = a:flags.query_orig
  else
    " Remove any flags at the beginning, e.g. when using '-uu' with rg, but
    " keep plain '-'.
    let query = substitute(a:flags.query, '\v^\s+', '', '')
    let query = substitute(query, '\v\s+$', '', '')
    let pos = 0
    while 1
      let [mtext, mstart, mend] = matchstrpos(query, '\v^-\S+\s*', pos)
      if mstart < 0
        break
      endif
      let pos = mend
      if mtext =~ '\v^--\s*$'
        break
      endif
    endwhile
    let query = strpart(query, pos)
  endif

  " Change Vim's '\'' to ' so it can be understood by /.
  let vim_query = substitute(query, "'\\\\''", "'", 'g')

  " Remove surrounding quotes that denote a string.
  let start = vim_query[0]
  let end = vim_query[-1:-1]
  if start == end && start =~ "\['\"]"
    let vim_query = vim_query[1:-2]
  endif

  if a:flags.query_escaped
    let vim_query = s:unescape_query(a:flags, vim_query)
    let vim_query = escape(vim_query, '\')
    if a:flags.cword
      if a:flags.query_orig =~# '^\k'
        let vim_query = '\<' . vim_query
      endif
      if a:flags.query_orig =~# '\k$'
        let vim_query = vim_query . '\>'
      endif
    endif
    let vim_query = '\V'. vim_query
  else
    " \bfoo\b -> \<foo\> Assume only one pair.
    let vim_query = substitute(vim_query, '\v\\b(.{-})\\b', '\\<\1\\>', '')
    " *? -> \{-}
    let vim_query = substitute(vim_query, '*\\\=?', '\\{-}', 'g')
    " +? -> \{-1,}
    let vim_query = substitute(vim_query, '\\\=+\\\=?', '\\{-1,}', 'g')
    let vim_query = escape(vim_query, '+')
  endif

  return vim_query
endfunction
" }}}1

" s:parse_flags() {{{1
function! s:parse_flags(args) abort
  let flags = s:get_config()
  let flags.query = ''
  let flags.query_escaped = 0
  let [flag, args] = s:split_one(a:args)

  while !empty(flag)
    if     flag =~? '\v^-%(no)?(quickfix|qf)$' | let flags.quickfix  = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?open$'          | let flags.open      = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?switch$'        | let flags.switch    = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?jump$'          | let flags.jump      = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?prompt$'        | let flags.prompt    = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?highlight$'     | let flags.highlight = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?buffer$'        | let flags.buffer    = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?buffers$'       | let flags.buffers   = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?append$'        | let flags.append    = flag !~? '^-no'
    elseif flag =~? '\v^-%(no)?side$'          | let flags.side      = flag !~? '^-no'
    elseif flag =~? '^-cword$'                 | let flags.cword     = 1
    elseif flag =~? '^-stop$'
      if empty(args) || args[0] =~ '^-'
        let flags.stop = -1
      else
        let [numstring, args] = s:split_one(args)
        let flags.stop = str2nr(numstring)
      endif
    elseif flag =~? '^-dir$'
      let [dir, args] = s:split_one(args)
      if empty(dir)
        call s:error('Missing argument for: -dir')
      else
        let flags.dir = dir
      endif
    elseif flag =~? '^-grepprg$'
      if empty(args)
        call s:error('Missing argument for: -grepprg')
      else
        if !exists('tool')
          let tool = g:grepper.tools[0]
        endif
        let flags.tools = [tool]
        let flags[tool] = copy(g:grepper[tool])
        let flags[tool].grepprg = args
      endif
      break
    elseif flag =~? '^-query$'
      if empty(args)
        " No warning message here. This allows for..
        " nnoremap ... :Grepper! -tool ag -query<space>
        " ..thus you get nicer file completion.
      else
        let flags.query = args
      endif
      break
    elseif flag =~? '^-tool$'
      let [tool, args] = s:split_one(args)
      if tool == ''
        call s:error('Missing argument for: -tool')
        break
      endif
      if index(g:grepper.tools, tool) >= 0
        let flags.tools =
              \ [tool] + filter(copy(g:grepper.tools), 'v:val != tool')
      else
        call s:error('No such tool: '. tool)
      endif
    elseif flag ==# '-cd'
      if empty(args)
        call s:error('Missing argument for: -cd')
        break
      endif
      let dir = fnamemodify(args, ':p')
      if !isdirectory(dir)
        call s:error('Invalid directory: '. dir)
        break
      endif
      let flags.cd = dir
      break
    else
      call s:error('Ignore unknown flag: '. flag)
    endif

    let [flag, args] = s:split_one(args)
  endwhile

  return s:start(flags)
endfunction

" s:process_flags() {{{1
function! s:process_flags(flags)
  if a:flags.stop == -1
    if exists('s:id')
      if has('nvim')
        silent! call jobstop(s:id)
      else
        silent! call job_stop(s:id)
      endif
      unlet! s:id
    endif
    return 1
  endif

  let s:tmp_work_dir = s:compute_working_directory(a:flags)
  if s:get_current_tool_name(a:flags) ==# 'git'
        \ && empty(finddir('.git', s:tmp_work_dir.';'))
        \ && empty(findfile('.git', s:tmp_work_dir.';'))
    call remove(a:flags.tools, 0)
    if empty(a:flags.tools)
      call s:error('Using git outside of repo and no other tool to switch to. Try ":Grepper -dir repo,file" instead.')
      return 1
    endif
  endif

  if a:flags.buffer
    let a:flags.buflist = [fnamemodify(bufname(''), ':p')]
    if !filereadable(a:flags.buflist[0])
      call s:error('This buffer is not backed by a file!')
      return 1
    endif
  endif

  if a:flags.buffers
    let a:flags.buflist = filter(map(filter(range(1, bufnr('$')),
          \ 'bufloaded(v:val)'), 'fnamemodify(bufname(v:val), ":p")'), 'filereadable(v:val)')
    if empty(a:flags.buflist)
      call s:error('No buffer is backed by a file!')
      return 1
    endif
  endif

  if a:flags.cword
    let a:flags.query = s:escape_cword(a:flags, expand('<cword>'))
  endif

  if a:flags.prompt
    call s:prompt(a:flags)
    if s:prompt_op == 'cancelled'
      return 1
    endif

    if a:flags.query =~ '^\s*$'
      let a:flags.query = s:escape_cword(a:flags, expand('<cword>'))
      " input() got empty input, so no query was added to the history.
      call histadd('input', a:flags.query)
    elseif a:flags.prompt_quote == 1
      let a:flags.query = shellescape(a:flags.query)
    endif
  else
    " input() was skipped, so add query to the history manually.
    call histadd('input', a:flags.query)
  endif

  if a:flags.side
    let a:flags.highlight = 1
    let a:flags.open      = 0
  endif

  if a:flags.searchreg || a:flags.highlight
    let @/ = s:query2vimregexp(a:flags)
    call histadd('search', @/)
    if a:flags.highlight
      call feedkeys(":set hls\<bar>echo\<cr>", 'n')
    endif
  endif

  return 0
endfunction

" s:start() {{{1
function! s:start(flags) abort
  let s:prompt_op = ''

  if empty(g:grepper.tools)
    call s:error('No grep tool found!')
    return
  endif

  if !s:git_column_flag_checked
    call s:git_add_column_flag(a:flags)
  endif

  if s:process_flags(a:flags)
    return
  endif

  return s:run(a:flags)
endfunction

" s:prompt() {{{1
function! s:prompt(flags)
  let prompt_text = s:set_prompt_text(a:flags)

  if s:prompt_op == 'flag_dir'
    let changed_mode = '[-dir '. a:flags.dir .'] '
    let prompt_text = changed_mode . prompt_text
  elseif s:prompt_op == 'flag_side'
    let changed_mode = '['. (a:flags.side ? '-side' : '-noside') .'] '
    let prompt_text = changed_mode . prompt_text
  endif

  " Store original mappings
  let mapping_cr   = maparg('<cr>', 'c', '', 1)
  let mapping_tool = maparg(get(g:grepper, 'next_tool', g:grepper.prompt_mapping_tool), 'c', '', 1)
  let mapping_dir  = maparg(g:grepper.prompt_mapping_dir,  'c', '', 1)
  let mapping_side = maparg(g:grepper.prompt_mapping_side, 'c', '', 1)

  " Set plugin-specific mappings
  cnoremap <silent> <cr> <c-\>e<sid>set_prompt_op('cr')<cr><cr>
  execute 'cnoremap <silent>' g:grepper.prompt_mapping_tool "\<c-\>e\<sid>set_prompt_op('flag_tool')<cr><cr>"
  execute 'cnoremap <silent>' g:grepper.prompt_mapping_dir  "\<c-\>e\<sid>set_prompt_op('flag_dir')<cr><cr>"
  execute 'cnoremap <silent>' g:grepper.prompt_mapping_side "\<c-\>e\<sid>set_prompt_op('flag_side')<cr><cr>"

  " Set low timeout for key codes, so <esc> would cancel prompt faster
  let ttimeoutsave = &ttimeout
  let ttimeoutlensave = &ttimeoutlen
  let &ttimeout = 1
  let &ttimeoutlen = 100

  if a:flags.prompt_quote == 2 && !has_key(a:flags, 'query_orig')
    let a:flags.query = "'". a:flags.query ."'\<left>"
  elseif a:flags.prompt_quote == 3 && !has_key(a:flags, 'query_orig')
    let a:flags.query = '"'. a:flags.query ."\"\<left>"
  else
    let a:flags.query = a:flags.query
  endif

  " s:prompt_op indicates which key ended the prompt's input() and is needed to
  " distinguish different actions.
  "   'cancelled':  don't start searching
  "   'flag_tool':  don't start searching; toggle -tool flag
  "   'flag_dir':   don't start searching; toggle -dir flag
  "   'flag_side':  don't start searching; toggle -side flag
  "   'cr':         start searching
  let s:prompt_op = 'cancelled'

  echohl GrepperPrompt
  call inputsave()

  try
    if has('nvim-0.3.4')
      let a:flags.query = input({
            \ 'prompt':     prompt_text,
            \ 'default':    a:flags.query,
            \ 'completion': 'customlist,grepper#complete_files',
            \ 'highlight':  { cmdline -> [[0, len(cmdline), 'String']] },
            \ })
    else
      let a:flags.query = input(prompt_text, a:flags.query,
            \ 'customlist,grepper#complete_files')
    endif
  catch /^Vim:Interrupt$/  " Ctrl-c was pressed
    let s:prompt_op = 'cancelled'
  finally
    redraw!

    " Restore mappings
    cunmap <cr>
    execute 'cunmap' g:grepper.prompt_mapping_tool
    execute 'cunmap' g:grepper.prompt_mapping_dir
    execute 'cunmap' g:grepper.prompt_mapping_side
    call s:restore_mapping(mapping_cr)
    call s:restore_mapping(mapping_tool)
    call s:restore_mapping(mapping_dir)
    call s:restore_mapping(mapping_side)

    " Restore original timeout settings for key codes
    let &ttimeout = ttimeoutsave
    let &ttimeoutlen = ttimeoutlensave

    echohl NONE
    call inputrestore()
  endtry

  if s:prompt_op != 'cr' && s:prompt_op != 'cancelled'
    if s:prompt_op == 'flag_tool'
      call s:next_tool(a:flags)
    elseif s:prompt_op == 'flag_dir'
      let states = ['cwd', 'file', 'filecwd', 'repo']
      let pattern = printf('v:val =~# "^%s.*"', a:flags.dir)
      let current_index = index(map(copy(states), pattern), 1)
      let a:flags.dir = states[(current_index + 1) % len(states)]
      let s:tmp_work_dir = s:compute_working_directory(a:flags)
    elseif s:prompt_op == 'flag_side'
      let a:flags.side = !a:flags.side
    endif

    call s:requote_query(a:flags)
    return s:prompt(a:flags)
  endif
endfunction

" s:build_cmdline() {{{1
function! s:build_cmdline(flags) abort
  let grepprg = s:get_grepprg(a:flags)

  if has_key(a:flags, 'buflist')
    if has('win32')
      " cmd.exe does not use single quotes for quoting. Using 'noshellslash'
      " forces path separators to be backslashes and makes shellescape() using
      " double quotes. Beforehand escape all backslashes, otherwise \t in
      " 'dir\test' would be considered a tab etc.
      let [shellslash, &shellslash] = [&shellslash, 0]
      call map(a:flags.buflist, 'shellescape(escape(fnamemodify(v:val, ":."), "\\"))')
      let &shellslash = shellslash
    else
      call map(a:flags.buflist, 'shellescape(fnamemodify(v:val, ":."))')
    endif
  endif

  if stridx(grepprg, '$.') >= 0
    let grepprg = substitute(grepprg, '\V$.', a:flags.buflist[0], '')
  endif
  if stridx(grepprg, '$+') >= 0
    let grepprg = substitute(grepprg, '\V$+', join(a:flags.buflist), '')
  endif
  if stridx(grepprg, '$*') >= 0
    let grepprg = substitute(grepprg, '\V$*', escape(a:flags.query, '\&'), 'g')
  else
    let grepprg .= ' ' . a:flags.query
  endif

  return grepprg
endfunction

" s:run() {{{1
function! s:run(flags)
  if !a:flags.append
    if a:flags.quickfix
      call setqflist([])
    else
      call setloclist(0, [])
    endif
  endif

  let orig_dir  = s:chdir_push(s:tmp_work_dir)
  let s:cmdline = s:build_cmdline(a:flags)

  " 'cmd' and 'options' are only used for async execution.
  if has('win32')
    let cmd = 'cmd.exe /c '. s:cmdline
  else
    let cmd = ['sh', '-c', s:cmdline]
  endif

  let options = {
        \ 'cmd':       s:cmdline,
        \ 'work_dir':  s:tmp_work_dir,
        \ 'flags':     a:flags,
        \ 'addexpr':   a:flags.quickfix ? 'caddexpr' : 'laddexpr',
        \ 'window':    winnr(),
        \ 'tabpage':   tabpagenr(),
        \ 'stdoutbuf': '',
        \ 'num_matches': 0,
        \ }

  call s:store_errorformat(a:flags)

  if &verbose
    echomsg 'grepper: running' string(cmd)
  endif

  let msg = printf('Running: %s', s:cmdline)
  if exists('v:echospace') && strwidth(msg) > v:echospace
    let msg = printf('%.*S...', v:echospace - 3, msg)
  endif
  echo msg

  if has('nvim')
    if exists('s:id')
      silent! call jobstop(s:id)
    endif
    try
      let s:id = jobstart(cmd, extend(options, {
            \ 'on_stdout': function('s:on_stdout_nvim'),
            \ 'on_stderr': function('s:on_stdout_nvim'),
            \ 'stdout_buffered': 1,
            \ 'stderr_buffered': 1,
            \ 'on_exit':   function('s:on_exit'),
            \ }))
    finally
      call s:chdir_pop(orig_dir)
    endtry
  elseif !get(w:, 'testing') && has('patch-7.4.1967')
    if exists('s:id')
      silent! call job_stop(s:id)
    endif

    try
      let s:id = job_start(cmd, {
            \ 'in_io':    'null',
            \ 'err_io':   'out',
            \ 'out_cb':   function('s:on_stdout_vim', options),
            \ 'close_cb': function('s:on_exit', options),
            \ })
    finally
      call s:chdir_pop(orig_dir)
    endtry
  else
    try
      execute 'silent' (a:flags.quickfix ? 'cgetexpr' : 'lgetexpr') 'system(s:cmdline)'
    finally
      call s:chdir_pop(orig_dir)
    endtry
    call s:finish_up(a:flags)
  endif
endfunction

" s:finish_up() {{{1
function! s:finish_up(flags)
  let qf = a:flags.quickfix
  let list = qf ? getqflist() : getloclist(0)
  let size = len(list)

  let cmdline = s:cmdline
  let s:cmdline = ''

  call s:restore_errorformat()

  try
    " TODO: Remove condition if nvim 0.2.0+ enters Debian stable.
    let attrs = has('nvim') && !has('nvim-0.2.0')
          \ ? cmdline
          \ : {'title': cmdline, 'context': {'query': @/}}
    if qf
      call setqflist(list, a:flags.append ? 'a' : 'r', attrs)
    else
      call setloclist(0, list, a:flags.append ? 'a' : 'r', attrs)
    endif
  catch /E118/
  endtry

  if size == 0
    execute (qf ? 'cclose' : 'lclose')
    redraw
    echo 'No matches found.'
    return
  endif

  if a:flags.jump
    execute (qf ? 'cfirst' : 'lfirst')
  endif

  let has_errors = !empty(filter(list, 'v:val.valid == 0'))

  " Also open if the side mode is off and the list contains any invalid entry.
  if a:flags.open || (has_errors && !a:flags.side)
    execute (qf ? 'botright copen' : 'lopen') (size > 10 ? 10 : size)
    let w:quickfix_title = cmdline
    setlocal nowrap

    if !a:flags.switch
      call feedkeys("\<c-w>p", 'n')
    endif
  endif

  redraw
  echo printf('Found %d matches.', size)

  if a:flags.side
    call s:side(a:flags)
  endif

  if exists('#User#Grepper')
    execute 'doautocmd' (s:has_doau_modeline ? '<nomodeline>' : '') 'User Grepper'
  endif
endfunction

" }}}1

" -side {{{1
let s:filename_regexp = '\v^%(\>\>\>|\]\]\]) ([[:alnum:][:blank:]\/\-_.~]+):(\d+)'

let s:error_marker = '!^@ERR '

" s:side() {{{2
function! s:side(flags) abort
  call s:side_create_window(a:flags)
  call s:side_buffer_settings()
endfunction

" s:side_create_window() {{{2
function! s:side_create_window(flags) abort
  " Contexts are lists of a fixed format:
  "
  "   [0] = line number of the match
  "   [1] = start of context
  "   [2] = end of context
  let regions = {}
  let errors = []
  let list = a:flags.quickfix ? getqflist() : getloclist(0)

  " process quickfix entries
  for entry in list
    let bufname = bufname(entry.bufnr)
    if !entry.valid
      " collect lines with error messages
      call add(errors, entry.text)
      continue
    endif
    if has_key(regions, bufname)
      if (regions[bufname][-1][2] + 2) > entry.lnum
        " merge entries that are close to each other into the same context
        let regions[bufname][-1][2] = entry.lnum + 2
      else
        " new context in same file
        let start = (entry.lnum < 4) ? 0 : (entry.lnum - 4)
        let regions[bufname] += [[entry.lnum, start, entry.lnum + 2]]
      endif
    else
      " new context in new file
      let start = (entry.lnum < 4) ? 0 : (entry.lnum - 4)
      let regions[bufname] = [[entry.lnum, start, entry.lnum + 2]]
    end
  endfor

  execute a:flags.side_cmd

  " write error messages first
  if !empty(errors)
    call append('$', map(errors + [''], 's:error_marker . v:val'))
  endif

  " write contexts to buffer
  for filename in sort(keys(regions))
    let contexts = regions[filename]
    let file = readfile(expand(filename))

    let context = contexts[0]
    call append('$', '>>> '. filename .':'. context[0])
    call append('$', file[context[1]:context[2]])

    for context in contexts[1:]
      call append('$', ']]] '. filename .':'. context[0])
      call append('$', file[context[1]:context[2]])
    endfor

    call append('$', '')
  endfor

  silent 1delete _

  let nummatches = len(getqflist())
  let numfiles = len(uniq(map(getqflist(), 'bufname(v:val.bufnr)')))
  let &l:statusline = printf(' Found %d matches in %d files.', nummatches, numfiles)
endfunction

" s:side_buffer_settings() {{{2
function! s:side_buffer_settings() abort
  nnoremap <silent><buffer> q :bdelete<cr>

  nnoremap <silent><plug>(grepper-side-context-jump) :<c-u>call <sid>context_jump(1)
  nnoremap <silent><plug>(grepper-side-context-open) :<c-u>call <sid>context_jump(0)
  nnoremap <silent><plug>(grepper-side-context-next) :<c-u>call <sid>context_next()
  nnoremap <silent><plug>(grepper-side-context-prev) :<c-u>call <sid>context_previous()

  nmap <buffer> <cr> <plug>(grepper-side-context-jump)<cr>
  nmap <buffer> o    <plug>(grepper-side-context-open)<cr>
  nmap <buffer> }    <plug>(grepper-side-context-next)<cr>
  nmap <buffer> {    <plug>(grepper-side-context-prev)<cr>

  setlocal buftype=nofile bufhidden=wipe nonumber norelativenumber foldcolumn=0
  set nowrap

  normal! zR
  silent! normal! n

  set conceallevel=2
  set concealcursor=nvic

  let b:grepper_side = s:filename_regexp

  setfiletype GrepperSide

  syntax match GrepperSideSquareBracket /]/ contained containedin=GrepperSideSquareBrackets conceal cchar=.
  execute 'syntax match GrepperSideSquareBrackets /^]]] \v'.s:filename_regexp[20:].'/ conceal contains=GrepperSideSquareBracket'

  syntax match GrepperSideAngleBracket  /> \?/ contained containedin=GrepperSideFile conceal
  execute 'syntax match GrepperSideFile /^>>> \v'.s:filename_regexp[20:].'/ contains=GrepperSideAngleBracket'

  execute 'syntax match GrepperSideErrorMarker /^'.s:error_marker.'/ contained containedin=GrepperSideError conceal'
  execute 'syntax match GrepperSideError /^'.s:error_marker.'.*/ contains=GrepperSideCaret'

  highlight default link GrepperSideFile Directory
  highlight default link GrepperSideSquareBrackets Conceal
  highlight default link GrepperSideError ErrorMsg
endfunction

" s:side_context_next() {{{2
function! s:context_next() abort
  call search(s:filename_regexp)
  call s:side_context_scroll_into_viewport()
endfunction

" s:side_context_previous() {{{2
function! s:context_previous() abort
  call search(s:filename_regexp, 'bc')
  if line('.') == 1
    $
    call s:side_context_scroll_into_viewport()
  else
    -
  endif
  call search(s:filename_regexp, 'b')
endfunction

" s:side_context_scroll_into_viewport() {{{2
function! s:side_context_scroll_into_viewport() abort
  redraw  " needed for line('w$')
  let next_context_line = search(s:filename_regexp, 'nW')
  let current_line      = line('.')
  let last_line         = line('$')
  let last_visible_line = line('w$')
  if next_context_line > 0
    let context_length = (next_context_line - 1) - current_line
  else
    let context_length = last_line - current_line
  endif
  let scroll_length = context_length - (last_visible_line - current_line)
  if scroll_length > 0
    execute 'normal!' scroll_length."\<c-e>"
  endif
endfunction

" s:side_context_jump() {{{2
function! s:context_jump(close_window) abort
  let fileline = search(s:filename_regexp, 'bcn')
  if empty(fileline)
    return
  endif
  let [filename, line] = matchlist(getline(fileline), s:filename_regexp)[1:2]
  if a:close_window
    silent! close
    execute 'edit +'.line fnameescape(filename)
  else
    wincmd p
    execute 'edit +'.line fnameescape(filename)
    wincmd p
  endif
endfunction
" }}}1

" Operator {{{1
function! GrepperOperator(type) abort
  let regsave = @@
  let selsave = &selection
  let &selection = 'inclusive'

  if a:type =~? 'v'
    silent execute "normal! gvy"
  elseif a:type == 'line'
    silent execute "normal! '[V']y"
  else
    silent execute "normal! `[v`]y"
  endif

  let &selection = selsave
  let flags = s:get_config().operator
  let flags.query_orig = @@
  let flags.query_escaped = 0

  let flags.query = s:escape_query(flags, @@)
  if s:get_current_tool_name(flags) != 'findstr'
        \ && !flags.buffer && !flags.buffers
    let flags.query = '-- '. flags.query
  endif
  let @@ = regsave

  return s:start(flags)
endfunction

" Mappings {{{1
nnoremap <silent> <plug>(GrepperOperator) :set opfunc=GrepperOperator<cr>g@
xnoremap <silent> <plug>(GrepperOperator) :<c-u>call GrepperOperator(visualmode())<cr>

if hasmapto('<plug>(GrepperOperator)')
  silent! call repeat#set("\<plug>(GrepperOperator)", v:count)
endif

" Commands {{{1
command! -nargs=* -complete=customlist,grepper#complete Grepper call <sid>parse_flags(<q-args>)

for s:tool in g:grepper.tools
  let s:utool = substitute(toupper(s:tool[0]) . s:tool[1:], '-\(.\)',
        \ '\=toupper(submatch(1))', 'g')
  execute 'command! -nargs=+ -complete=file Grepper'. s:utool
        \ 'Grepper -noprompt -tool' s:tool '-query <args>'
endfor

" vim: tw=80 et sts=2 sw=2 fdm=marker
