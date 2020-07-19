"=============================================================================
" commands.vim --- commands in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#commands#load() abort
  ""
  " Load exist layer, {layers} can be a string of a layer name, or a list
  " of layer names.
  command! -nargs=+ SPLayer call SpaceVim#layers#load(<f-args>)
  ""
  " Print the version of SpaceVim.  The following lines contain information
  " about which features were enabled.  When there is a preceding '+', the
  " feature is included, when there is a '-' it is excluded.
  command! -nargs=0 SPVersion call SpaceVim#commands#version()
  ""
  " Set or check SpaceVim option. {opt} should be the option name of
  " spacevim, This command will use [value] as the value of option name.
  command! -nargs=+ SPSet call SpaceVim#options#set(<f-args>)
  ""
  " print the debug information of spacevim, [!] forces the output into a
  " new buffer.
  command! -nargs=0 -bang SPDebugInfo call SpaceVim#logger#viewLog('<bang>' == '!')
  ""
  " view runtime log
  command! -nargs=0 SPRuntimeLog call SpaceVim#logger#viewRuntimeLog()
  ""
  " edit custom config file of SpaceVim, by default this command will open
  " global custom configuration file, '-l' option will load local custom
  " configuration file.
  " >
  "   :SPConfig -g
  " <
  command! -nargs=*
        \ -complete=customlist,SpaceVim#commands#complete_SPConfig
        \ SPConfig call SpaceVim#commands#config(<f-args>)
  ""
  " Command for update plugin, support completion of plugin name. If run
  " without argv, All the plugin will be updated.
  " >
  "     :SPUpdate vim-airline
  " <
  command! -nargs=*
        \ -complete=custom,SpaceVim#commands#complete_plugin
        \ SPUpdate call SpaceVim#commands#update_plugin(<f-args>)

  ""
  " Command for reinstall plugin, support completion of plugin name. 
  command! -nargs=+
        \ -complete=custom,SpaceVim#commands#complete_plugin
        \ SPReinstall call SpaceVim#commands#reinstall_plugin(<f-args>)

  ""
  " Command for install plugins.
  command! -nargs=* SPInstall call SpaceVim#commands#install_plugin(<f-args>)
  command! -nargs=* SPClean call SpaceVim#commands#clean_plugin()
  command! -nargs=0 Report call SpaceVim#issue#new()
endfunction

" @vimlint(EVL103, 1, a:ArgLead)
" @vimlint(EVL103, 1, a:CmdLine)
" @vimlint(EVL103, 1, a:CursorPos)
function! SpaceVim#commands#complete_plugin(ArgLead, CmdLine, CursorPos) abort
  if g:spacevim_plugin_manager ==# 'dein'
    return join(keys(dein#get()) + ['SpaceVim'], "\n")
  elseif g:spacevim_plugin_manager ==# 'neobundle'
    return join(map(neobundle#config#get_neobundles(), 'v:val.name'), "\n")
  endif
endfunction
" @vimlint(EVL103, 0, a:ArgLead)
" @vimlint(EVL103, 0, a:CmdLine)
" @vimlint(EVL103, 0, a:CursorPos)

" @vimlint(EVL103, 1, a:ArgLead)
" @vimlint(EVL103, 1, a:CmdLine)
" @vimlint(EVL103, 1, a:CursorPos)
function! SpaceVim#commands#complete_SPConfig(ArgLead, CmdLine, CursorPos) abort
  return ['-g', '-l']
endfunction
" @vimlint(EVL103, 0, a:ArgLead)
" @vimlint(EVL103, 0, a:CmdLine)
" @vimlint(EVL103, 0, a:CursorPos)

function! SpaceVim#commands#config(...) abort
  if a:0 > 0
    if a:1 ==# '-g'
      exe 'tabnew' g:_spacevim_global_config_path
    elseif  a:1 ==# '-l'
      exe 'tabnew' g:_spacevim_config_path
    endif
  else
    if g:spacevim_force_global_config ||
          \ get(g:, '_spacevim_config_path', '0') ==# '0'
      exe 'tabnew' g:_spacevim_global_config_path
    else
      exe 'tabnew' g:_spacevim_config_path
    endif
  endif
  setlocal omnifunc=SpaceVim#custom#complete
endfunction

function! SpaceVim#commands#update_plugin(...) abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    if a:0 == 0
      call SpaceVim#plugins#manager#update()
    else
      call SpaceVim#plugins#manager#update(a:000)
    endif
  elseif g:spacevim_plugin_manager ==# 'dein'
    if a:0 == 0
      call SpaceVim#plugins#manager#update()
    else
      call SpaceVim#plugins#manager#update(a:000)
    endif
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
  endif
endfunction

function! SpaceVim#commands#reinstall_plugin(...) abort
  if g:spacevim_plugin_manager ==# 'dein'
    call SpaceVim#plugins#manager#reinstall(a:000)
  elseif g:spacevim_plugin_manager ==# 'neobundle'
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
  endif
endfunction

function! SpaceVim#commands#clean_plugin() abort
  if g:spacevim_plugin_manager ==# 'dein'
    call map(dein#check_clean(), "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  elseif g:spacevim_plugin_manager ==# 'neobundle'
    " @todo add SPClean support for neobundle
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
    " @todo add SPClean support for vim-plug
  endif
endfunction

function! SpaceVim#commands#install_plugin(...) abort
  if g:spacevim_plugin_manager ==# 'neobundle'
    if a:0 == 0
      call SpaceVim#plugins#manager#install()
    else
      call SpaceVim#plugins#manager#install(a:000)
    endif
  elseif g:spacevim_plugin_manager ==# 'dein'
    if a:0 == 0
      call SpaceVim#plugins#manager#install()
    else
      call SpaceVim#plugins#manager#install(a:000)
    endif
  elseif g:spacevim_plugin_manager ==# 'vim-plug'
  endif
endfunction

function! SpaceVim#commands#version() abort
  echo 'SpaceVim ' . g:spacevim_version  . s:SHA() . "\n" .
        \ "\n" .
        \ 'Optional features included (+) or not (-):' . "\n" .
        \ s:check_features([
        \ 'tui',
        \ 'jemalloc',
        \ 'acl',
        \ 'arabic',
        \ 'autocmd',
        \ 'browse',
        \ 'byte_offset',
        \ 'cindent',
        \ 'clientserver',
        \ 'clipboard',
        \ 'cmdline_compl',
        \ 'cmdline_hist',
        \ 'cmdline_info',
        \ 'comments',
        \ 'conceal',
        \ 'cscope',
        \ 'cursorbind',
        \ 'cursorshape',
        \ 'debug',
        \ 'dialog_gui',
        \ 'dialog_con',
        \ 'dialog_con_gui',
        \ 'digraphs',
        \ 'eval',
        \ 'ex_extra',
        \ 'extra_search',
        \ 'farsi',
        \ 'file_in_path',
        \ 'find_in_path',
        \ 'folding',
        \ 'gettext',
        \ 'iconv',
        \ 'iconv/dyn',
        \ 'insert_expand',
        \ 'jumplist',
        \ 'keymap',
        \ 'langmap',
        \ 'libcall',
        \ 'linebreak',
        \ 'lispindent',
        \ 'listcmds',
        \ 'localmap',
        \ 'menu',
        \ 'mksession',
        \ 'modify_fname',
        \ 'mouse',
        \ 'mouseshape',
        \ 'multi_byte',
        \ 'multi_byte_ime',
        \ 'multi_lang',
        \ 'path_extra',
        \ 'persistent_undo',
        \ 'postscript',
        \ 'printer',
        \ 'profile',
        \ 'python',
        \ 'python3',
        \ 'quickfix',
        \ 'reltime',
        \ 'rightleft',
        \ 'scrollbind',
        \ 'shada',
        \ 'signs',
        \ 'smartindent',
        \ 'startuptime',
        \ 'statusline',
        \ 'syntax',
        \ 'tablineat',
        \ 'tag_binary',
        \ 'tag_old_static',
        \ 'tag_any_white',
        \ 'termguicolors',
        \ 'terminfo',
        \ 'termresponse',
        \ 'textobjects',
        \ 'tgetent',
        \ 'timers',
        \ 'title',
        \ 'toolbar',
        \ 'user_commands',
        \ 'vertsplit',
        \ 'virtualedit',
        \ 'visual',
        \ 'visualextra',
        \ 'vreplace',
        \ 'wildignore',
        \ 'wildmenu',
        \ 'windows',
        \ 'writebackup',
        \ 'xim',
        \ 'xfontset',
        \ 'xpm',
        \ 'xpm_w32',
        \ ])
endfunction

function! s:check_features(features) abort
  let flist = map(a:features, "(has(v:val) ? '+' : '-') . v:val")
  let rst = ''
  let id = 1
  for f in flist
    let rst .= '    '
    let rst .= f . repeat(' ', 20 - len(f))
    if id == 3
      let rst .= "\n"
      let id = 1
    else
      let id += 1
    endif
  endfor
  return substitute(rst, '\n*\s*$', '', 'g')
endfunction

function! s:SHA() abort
  let sha = system('git --no-pager -C ~/.SpaceVim  log -n 1 --oneline')[:7]
  if v:shell_error
    return ''
  endif
  return '-' . sha
endfunction


" vim:set et sw=2 cc=80:
