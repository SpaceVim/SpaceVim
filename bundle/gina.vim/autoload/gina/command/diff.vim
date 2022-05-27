let s:SCHEME = gina#command#scheme(expand('<sfile>'))


function! gina#command#diff#call(range, args, mods) abort
  call gina#core#options#help_if_necessary(a:args, s:get_options())
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)

  let bufname = gina#core#buffer#bufname(git, s:SCHEME, {
        \ 'treeish': args.params.treeish,
        \ 'params': [
        \   args.params.cached ? 'cached' : '',
        \   args.params.R ? 'R' : '',
        \   args.params.partial ? '--' : '',
        \ ],
        \ 'noautocmd': !empty(args.params.path),
        \})
  call gina#core#buffer#open(bufname, {
        \ 'mods': a:mods,
        \ 'group': args.params.group,
        \ 'opener': args.params.opener,
        \ 'cmdarg': args.params.cmdarg,
        \ 'callback': {
        \   'fn': function('s:init'),
        \   'args': [args],
        \ }
        \})
endfunction

function! gina#command#diff#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if a:arglead =~# '^--opener='
    return gina#complete#common#opener(a:arglead, a:cmdline, a:cursorpos)
  elseif a:arglead =~# '^\%(--diff-algorithm=\)'
    let leading = matchstr(a:arglead, '^--diff-algorithm=')
    return gina#util#filter(a:arglead, map(
          \ ['patience', 'minimal', 'histogram', 'myers'],
          \ 'leading . v:val'
          \))
  elseif a:arglead =~# '^\%(--dirstat=\)'
    let leading = matchstr(a:arglead, '^--dirstat=')
    let dirstat = matchstr(a:arglead, '^--dirstat=\zs\%([^,]\+,\)*[^,]*')
    let candidates = filter(
          \ ['changes', 'lines', 'files', 'cumulative'],
          \ 'dirstat !~# ''\<'' . v:val . ''\>''',
          \)
    return gina#util#filter(a:arglead, map(
          \ candidates, 'leading . dirstat . v:val'
          \))
  elseif a:arglead =~# '^\%(--submodule=\)'
    let leading = matchstr(a:arglead, '^--submodule=')
    return gina#util#filter(a:arglead, map(
          \ ['short', 'log', 'diff'],
          \ 'leading . v:val'
          \))
  elseif a:arglead =~# '^\%(--diff-filter=\)'
    let leading = matchstr(a:arglead, '^--diff-filter=[ACDMRTUXB]*')
    return gina#util#filter(a:arglead, map(
          \ split('ACDMRTUXB', '\zs'),
          \ 'leading . v:val'
          \))
  elseif a:arglead =~# '^\%(--ignore-submodules=\)'
    let leading = matchstr(a:arglead, '^--ignore-submodules=')
    return gina#util#filter(a:arglead, map(
          \ ['none', 'untracked', 'dirty', 'all'],
          \ 'leading . v:val'
          \))
  elseif a:cmdline =~# '\s--\s'
    return gina#complete#filename#any(a:arglead, a:cmdline, a:cursorpos)
  elseif a:arglead[0] ==# '-'
    let options = s:get_options()
    return options.complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return gina#complete#common#treeish(a:arglead, a:cmdline, a:cursorpos)
endfunction


" Private --------------------------------------------------------------------
function! s:get_options() abort
  let options = gina#core#options#new()
  call options.define(
        \ '-h|--help',
        \ 'Show this help.',
        \)
  call options.define(
        \ '--opener=',
        \ 'A Vim command to open a new buffer.',
        \ ['edit', 'split', 'vsplit', 'tabedit', 'pedit'],
        \)
  call options.define(
        \ '--cached',
        \ 'Compare to the index rather than the working tree',
        \)
  call options.define(
        \ '-U|--unified=',
        \ 'Generate diffs with <n> lines of context',
        \)
  call options.define(
        \ '--raw',
        \ 'Generate the diff in raw format',
        \)
  call options.define(
        \ '--patch-with-raw',
        \ 'Synonym for -p --raw',
        \)
  call options.define(
        \ '--minimal',
        \ 'Spend extra time to make sure the smallest possible diff is produced',
        \)
  call options.define(
        \ '--patience',
        \ 'Generate a diff using the "patience diff" algorithm',
        \)
  call options.define(
        \ '--histogram',
        \ 'Generate a diff using the "histogram diff" algorithm',
        \)
  call options.define(
        \ '--diff-algorithm',
        \ 'Choose a diff algorithm',
        \)
  call options.define(
        \ '--stat',
        \ 'Generate a diffstat',
        \)
  call options.define(
        \ '--numstat',
        \ 'Similar to --stat, but with more machine friendly output',
        \)
  call options.define(
        \ '--shortstat',
        \ 'Output only the last line of the --stat format',
        \)
  call options.define(
        \ '--dirstat',
        \ 'Output the dirstat numbers',
        \)
  call options.define(
        \ '--summary',
        \ 'Output a condensed summary of extended header information',
        \)
  call options.define(
        \ '--patch-with-stat',
        \ 'Synonym for -p --stat',
        \)
  call options.define(
        \ '--name-only',
        \ 'Show only names of changed files',
        \)
  call options.define(
        \ '--name-status',
        \ 'Show only names and status of changed files',
        \)
  call options.define(
        \ '--submodule',
        \ 'Specify how differences in submodules are shown',
        \)
  call options.define(
        \ '--submodule',
        \ 'Specify how differences in submodules are shown',
        \)
  call options.define(
        \ '--no-renames',
        \ 'Turn off rename detection',
        \)
  call options.define(
        \ '--check',
        \ 'Warn if changes introduce conflict markers or whitespace errors',
        \)
  call options.define(
        \ '--full-index',
        \ 'Instead of the first handful of characters,show the full blob',
        \)
  call options.define(
        \ '--binary',
        \ 'In addition to --full-index, output a binary diff',
        \)
  call options.define(
        \ '--abbrev',
        \ 'Show only a particular prefix hexadecimal object name',
        \)
  call options.define(
        \ '-B|--break-rewrites',
        \ 'Break complete rewrite changes into pair of delete and create',
        \)
  call options.define(
        \ '-M|--find-renames',
        \ 'Detect renames. -M<n> to specify the threshold.',
        \)
  call options.define(
        \ '-C|--find-copies',
        \ 'Detect copies as well as renames. -C<n> to specify the threshold',
        \)
  call options.define(
        \ '--find-copies-harder',
        \ 'Detect copies more harder than -C/--find-copies',
        \)
  call options.define(
        \ '-D|--irreversible-delete',
        \ 'Omit the preimage for deletes',
        \)
  call options.define(
        \ '-l',
        \ 'Specify the threshold of -M or -C',
        \)
  call options.define(
        \ '--diff-filter=', join([
        \   'Specify the Select only files that are Added(A), Copied(C), ',
        \   'Deleted (D), Modified (M), Renamed (R), ',
        \   'have their type changed (T), are Unmerged (U), ',
        \   'are Unknown (X), or have had their pairing Broken (B)',
        \ ])
        \)
  call options.define(
        \ '-S', join([
        \   'Look for differences that change the number of occurrences of ',
        \   'the specified string in a file.'
        \ ])
        \)
  call options.define(
        \ '-G', join([
        \   'Look for differences whose patch text contains added/removed ',
        \   'line that match <regex>'
        \ ])
        \)
  call options.define(
        \ '--pickaxe-all', join([
        \   'Wnen -S or -G finds a change, show all the changes in that ',
        \   'changeset, not just the files and contain the change'
        \ ])
        \)
  call options.define(
        \ '--pickaxe-regex', join([
        \   'Treat the <string> given to -S as an extended POSIX regular ',
        \   'expression to match'
        \ ])
        \)
  call options.define(
        \ '-O',
        \ 'Output the patch in the order specified in the <orderfile>',
        \)
  call options.define(
        \ '-R',
        \ 'Swap two inputs',
        \)
  call options.define(
        \ '--relative',
        \ 'Show pathnames relative to',
        \)
  call options.define(
        \ '-a|--text',
        \ 'Treat all files as text',
        \)
  call options.define(
        \ '--ignore-space-at-eol',
        \ 'Ignore changes in whitespace at EOL',
        \)
  call options.define(
        \ '-b|--ignore-space-change',
        \ 'Ignore changes in amount of whitespace',
        \)
  call options.define(
        \ '-w|--ignore-all-space',
        \ 'Ignore whitespace when comparing lines',
        \)
  call options.define(
        \ '--ignore-blank-lines',
        \ 'Ignore changes whose line are all blank',
        \)
  call options.define(
        \ '--inter-hunk-context=',
        \ 'Show the context between diff hunks',
        \)
  call options.define(
        \ '-W|--function-context',
        \ 'Show whole surrounding functions of changes',
        \)
  call options.define(
        \ '--ext-diff',
        \ 'Allow an external diff helper to be executed',
        \)
  call options.define(
        \ '--no-ext-diff',
        \ 'Disallow external diff drivers',
        \)
  call options.define(
        \ '--textconv',
        \ 'Allow an external text conversion filters',
        \)
  call options.define(
        \ '--no-textconv',
        \ 'Disallow an external text conversion filters',
        \)
  call options.define(
        \ '--ignore-submodules',
        \ 'Ignore changes to submodules in the diff generation',
        \)
  call options.define(
        \ '--src-prefix=',
        \ 'Show the given source prefix instead of "a/"',
        \)
  call options.define(
        \ '--dst-prefix=',
        \ 'Show the given destination prefix instead of "a/"',
        \)
  call options.define(
        \ '--no-prefix',
        \ 'Do not show any source or destination prefix',
        \)
  call options.define(
        \ '--line-prefix=',
        \ 'Prepend an additional prefix to every line of output',
        \)
  return options
endfunction

function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  let args.params.cached = args.get('--cached')
  let args.params.R = args.get('-R')
  let args.params.partial = !empty(args.residual())

  " Remove unsupported options
  call args.pop('-z')
  call args.pop('--color')
  call args.pop('--word-diff')
  call args.pop('--word-diff-regex')
  call args.pop('--color-words')
  call args.pop('--ws-error-highlight')

  " Force --no-color
  call args.set('--no-color', 1)

  call gina#core#args#extend_treeish(a:git, args, args.pop(1))
  call gina#core#args#extend_diff(a:git, args, args.params.rev)
  call args.set(1, args.params.rev)
  if args.params.path isnot# v:null
    call args.residual([args.params.path] + args.residual())
  endif
  return args.lock()
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal nomodeline
  setlocal buftype=nowrite
  setlocal noswapfile
  setlocal nomodifiable
  if a:args.params.partial
    setlocal bufhidden=wipe
  else
    setlocal bufhidden&
  endif

  augroup gina_command_diff_internal
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer>
          \ call gina#core#revelator#call(function('s:BufReadCmd'), [])
    autocmd BufWinEnter <buffer> call setbufvar(str2nr(expand('<abuf>')), '&buflisted', 1)
    autocmd BufWinLeave <buffer> call setbufvar(str2nr(expand('<abuf>')), '&buflisted', 0)
  augroup END

  nnoremap <buffer><silent> <Plug>(gina-diff-jump)
        \ :<C-u>call gina#core#diffjump#jump()<CR>
  nnoremap <buffer><silent> <Plug>(gina-diff-jump-split)
        \ :<C-u>call gina#core#diffjump#jump('split')<CR>
  nnoremap <buffer><silent> <Plug>(gina-diff-jump-vsplit)
        \ :<C-u>call gina#core#diffjump#jump('vsplit')<CR>
  if g:gina#command#diff#use_default_mappings
    nmap <buffer> <CR> <Plug>(gina-diff-jump)
  endif
endfunction

function! s:BufReadCmd() abort
  let git = gina#core#get_or_fail()
  let args = gina#core#meta#get_or_fail('args')
  let pipe = gina#process#pipe#stream(s:writer)
  call gina#core#buffer#assign_cmdarg()
  call gina#process#open(git, args, pipe)
  setlocal filetype=diff
endfunction


" Writer ---------------------------------------------------------------------
function! s:_writer_on_exit() abort dict
  call call(s:original_writer.on_exit, [], self)
  call gina#core#emitter#emit('command:called', s:SCHEME)
endfunction

let s:original_writer = gina#process#pipe#stream_writer()
let s:writer = extend(deepcopy(s:original_writer), {
      \ 'on_exit': function('s:_writer_on_exit'),
      \})


" Config ---------------------------------------------------------------------
call gina#config(expand('<sfile>'), {
      \ 'use_default_mappings': 1,
      \})
