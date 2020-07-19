"=============================================================================
" FILE: autoload/incsearch/cli.vim
" AUTHOR: haya14busa
" License: MIT license
"=============================================================================
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:DIRECTION = { 'forward': 1, 'backward': 0 } " see :h v:searchforward

function! incsearch#cli#get() abort
  try
    " It returns current cli object
    return s:Doautocmd.get_cmdline()
  catch /vital-over(_incsearch) Exception/
    " If there are no current cli object, return default one
    return incsearch#cli#make(incsearch#config#make({}))
  endtry
endfunction

" @config: whole configuration
function! incsearch#cli#make(config) abort
  let cli = deepcopy(s:cli)
  call incsearch#cli#set(cli, a:config)
  return cli
endfunction

" To reuse cli object, you should re-set configuration
" @config: whole configuration
function! incsearch#cli#set(cli, config) abort
  let a:cli._base_key = a:config.command
  let a:cli._vcount1 = max([1, a:config.count])
  let a:cli._has_count = a:config.count > 0
  let a:cli._is_expr = a:config.is_expr
  let a:cli._mode = a:config.mode
  let a:cli._pattern = a:config.pattern
  let a:cli._prompt = a:config.prompt
  let a:cli._keymap = a:config.keymap
  let a:cli._converters = a:config.converters
  let a:cli._flag = a:config.is_stay         ? 'n'
  \               : a:config.command is# '/' ? ''
  \               : a:config.command is# '?' ? 'b'
  \               : ''
  let a:cli._direction =
  \ (a:cli._base_key is# '/' ? s:DIRECTION.forward : s:DIRECTION.backward)
  " TODO: provide config? but it may conflict with <expr> mapping
  " NOTE: _w: default cursor view
  let a:cli._w = winsaveview()
  for module in a:config.modules
    call a:cli.connect(module)
  endfor
  call a:cli.set_prompt(a:cli._prompt)
  return a:cli
endfunction

let s:cli = vital#incsearch#import('Over.Commandline').make_default('/')
let s:modules = vital#incsearch#import('Over.Commandline.Modules')

" Add modules
call s:cli.connect('BufferComplete')
call s:cli.connect('Cancel')
call s:cli.connect('CursorMove')
call s:cli.connect('Digraphs')
call s:cli.connect('Delete')
call s:cli.connect('DrawCommandline')
call s:cli.connect('ExceptionExit')
call s:cli.connect('LiteralInsert')
call s:cli.connect(incsearch#over#modules#exit#make())
call s:cli.connect(incsearch#over#modules#insert_register#make())
call s:cli.connect('Paste')
let s:Doautocmd = s:modules.get('Doautocmd')
call s:cli.connect(s:Doautocmd.make('IncSearch'))
call s:cli.connect(s:modules.get('ExceptionMessage').make('incsearch.vim: ', 'echom'))
call s:cli.connect(s:modules.get('History').make('/'))
call s:cli.connect(s:modules.get('NoInsert').make_special_chars())

" Dynamic Module Loading Management
let s:KeyMapping = s:modules.get('KeyMapping')
let s:emacs_like = s:KeyMapping.make_emacs()
let s:vim_cmap = s:KeyMapping.make_vim_cmdline_mapping()
let s:smartbackword = s:modules.get('IgnoreRegexpBackwardWord').make()
function! s:emacs_like._condition() abort
  return g:incsearch#emacs_like_keymap
endfunction
function! s:vim_cmap._condition() abort
  return g:incsearch#vim_cmdline_keymap
endfunction
function! s:smartbackword._condition() abort
  return g:incsearch#smart_backward_word
endfunction
call s:cli.connect(incsearch#over#modules#module_management#make([s:emacs_like, s:vim_cmap, s:smartbackword]))
unlet s:KeyMapping s:emacs_like s:vim_cmap s:smartbackword

call s:cli.connect(incsearch#over#modules#pattern_saver#make())
call s:cli.connect(incsearch#over#modules#bulk_input_char#make())
call s:cli.connect(incsearch#over#modules#bracketed_paste#make())
call s:cli.connect(incsearch#over#modules#incsearch#make())

function! s:cli.__keymapping__() abort
  return copy(self._keymap)
endfunction

call incsearch#over#extend#enrich(s:cli)

let &cpo = s:save_cpo
unlet s:save_cpo
" __END__
" vim: expandtab softtabstop=2 shiftwidth=2 foldmethod=marker
