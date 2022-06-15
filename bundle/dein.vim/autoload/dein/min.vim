function! dein#min#_init() abort
  let g:dein#name = ''
  let g:dein#plugin = {}
  let g:dein#_cache_version = 410
  let g:dein#_plugins = {}
  let g:dein#_multiple_plugins = []
  let g:dein#_base_path = ''
  let g:dein#_cache_path = ''
  let g:dein#_runtime_path = ''
  let g:dein#_hook_add = ''
  let g:dein#_ftplugin = {}
  let g:dein#_called_lua = {}
  let g:dein#_off1 = ''
  let g:dein#_off2 = ''
  let g:dein#_vimrcs = []
  let g:dein#_block_level = 0
  let g:dein#_event_plugins = {}
  let g:dein#_on_lua_plugins = {}
  let g:dein#_is_sudo = $SUDO_USER !=# '' && $USER !=# $SUDO_USER
        \ && $HOME !=# expand('~'.$USER)
        \ && $HOME ==# expand('~'.$SUDO_USER)
  let g:dein#_progname = fnamemodify(v:progname, ':r')
  let g:dein#_init_runtimepath = &runtimepath
  let g:dein#_loaded_rplugins = v:false

  if get(g:, 'dein#lazy_rplugins', v:false)
    " Disable remote plugin loading
    let g:loaded_remote_plugins = 1
  endif

  augroup dein
    autocmd!
    autocmd FuncUndefined *
          \ if stridx(expand('<afile>'), 'remote#') != 0 |
          \   call dein#autoload#_on_func(expand('<afile>')) |
          \ endif
    autocmd BufRead *? call dein#autoload#_on_default_event('BufRead')
    autocmd BufNew,BufNewFile *? call dein#autoload#_on_default_event('BufNew')
    autocmd VimEnter *? call dein#autoload#_on_default_event('VimEnter')
    autocmd FileType *? call dein#autoload#_on_default_event('FileType')
    autocmd BufWritePost *.lua,*.vim,*.toml,vimrc,.vimrc
          \ call dein#util#_check_vimrcs()
  augroup END
  augroup dein-events | augroup END

  if !exists('##CmdUndefined') | return | endif
  autocmd dein CmdUndefined *
        \ call dein#autoload#_on_pre_cmd(expand('<afile>'))
  if has('nvim')
    lua <<END
table.insert(package.loaders, 1, (function()
  return function(mod_name)
    if vim.g['dein#_on_lua_plugins'][mod_name] then
      vim.fn['dein#autoload#_on_lua'](mod_name)
    end
    return nil
  end
end)())
END
  endif
endfunction
function! dein#min#_load_cache_raw(vimrcs) abort
  let g:dein#_vimrcs = a:vimrcs
  let cache = get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ .'/cache_' . g:dein#_progname
  let time = getftime(cache)
  if !empty(filter(map(copy(g:dein#_vimrcs),
        \ { _, val -> getftime(expand(val)) }), { _, val -> time < val }))
    return [{}, {}]
  endif
  return has('nvim') ? json_decode(readfile(cache))
        \ : js_decode(readfile(cache)[0])
endfunction
function! dein#min#load_state(path, ...) abort
  if !exists('#dein')
    call dein#min#_init()
  endif
  let sourced = a:0 > 0 ? a:1 : has('vim_starting') &&
        \  (!exists('&loadplugins') || &loadplugins)
  if (g:dein#_is_sudo || !sourced) | return 1 | endif
  let g:dein#_base_path = expand(a:path)

  let state = get(g:, 'dein#cache_directory', g:dein#_base_path)
        \ . '/state_' . g:dein#_progname . '.vim'
  if !filereadable(state) | return 1 | endif
  try
    execute 'source' fnameescape(state)
  catch
    if v:exception !=# 'Cache loading error'
      call dein#util#_error('Loading state error: ' . v:exception)
    endif
    call dein#clear_state()
    return 1
  endtry
endfunction
