"=============================================================================
" logger.vim --- SpaceVim logger
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if $SPACEVIM_LUA && has('nvim-0.5.0')
  function! SpaceVim#logger#info(msg) abort
    lua require("spacevim.logger").info(
          \ require("spacevim").eval("a:msg")
          \ )
  endfunction

  function! SpaceVim#logger#warn(msg, ...) abort
    let issilent = get(a:000, 0, 1)
    lua require("spacevim.logger").warn(
          \ require("spacevim").eval("a:msg"),
          \ require("spacevim").eval("issilent")
          \ )
  endfunction


  function! SpaceVim#logger#error(msg) abort
    lua require("spacevim.logger").error(
          \ require("spacevim").eval("a:msg")
          \ )
  endfunction

  function! SpaceVim#logger#debug(msg) abort
    lua require("spacevim.logger").debug(
          \ require("spacevim").eval("a:msg")
          \ )
  endfunction

  function! SpaceVim#logger#viewRuntimeLog() abort
    lua require("spacevim.logger").viewRuntimeLog()
  endfunction


  function! SpaceVim#logger#viewLog(...) abort
    if a:0 >= 1
      let bang = get(a:000, 0, 0)
      return luaeval('require("spacevim.logger").viewLog(require("spacevim").eval("bang"))')
    else
      return luaeval('require("spacevim.logger").viewLog()')
    endif
  endfunction

  function! SpaceVim#logger#setLevel(level) abort
    lua require("spacevim.logger").setLevel(require("spacevim").eval("a:level"))
  endfunction

  function! SpaceVim#logger#setOutput(file) abort
    lua require("spacevim.logger").setOutput(require("spacevim").eval("a:file"))
  endfunction

  function! SpaceVim#logger#derive(name) abort
    return luaeval('require("spacevim.logger").derive(require("spacevim").eval("a:name"))')
  endfunction
else
  let s:LOGGER = SpaceVim#api#import('logger')

  call s:LOGGER.set_name('SpaceVim')
  call s:LOGGER.set_level(get(g:, 'spacevim_debug_level', 1))
  call s:LOGGER.set_silent(1)
  call s:LOGGER.set_verbose(1)

  function! SpaceVim#logger#info(msg) abort

    call s:LOGGER.info(a:msg)

  endfunction

  function! SpaceVim#logger#warn(msg, ...) abort
    let issilent = get(a:000, 0, 1)
    call s:LOGGER.warn(a:msg, issilent)
  endfunction


  function! SpaceVim#logger#error(msg) abort

    call s:LOGGER.error(a:msg)

  endfunction

  function! SpaceVim#logger#debug(msg) abort

    call s:LOGGER.debug(a:msg)

  endfunction

  function! SpaceVim#logger#viewRuntimeLog() abort
    let info = "### SpaceVim runtime log :\n\n"
    let info .= s:LOGGER.view(s:LOGGER.level)
    tabnew +setl\ nobuflisted
    nnoremap <buffer><silent> q :tabclose!<CR>
    for msg in split(info, "\n")
      call append(line('$'), msg)
    endfor
    normal! "_dd
    setl nomodifiable
    setl buftype=nofile
    setl filetype=SpaceVimLog
  endfunction


  function! SpaceVim#logger#viewLog(...) abort
    let info = "<details><summary> SpaceVim debug information </summary>\n\n"
    let info .= "### SpaceVim options :\n\n"
    let info .= "```toml\n"
    let info .= join(SpaceVim#options#list(), "\n")
    let info .= "\n```\n"
    let info .= "\n\n"

    let info .= "### SpaceVim layers :\n\n"
    let info .= SpaceVim#layers#report()
    let info .= "\n\n"

    let info .= "### SpaceVim Health checking :\n\n"
    let info .= SpaceVim#health#report()
    let info .= "\n\n"

    let info .= "### SpaceVim runtime log :\n\n"
    let info .= "```log\n"

    let info .= s:LOGGER.view(s:LOGGER.level)

    let info .= "\n```\n</details>\n\n"
    if a:0 > 0
      if a:1 == 1
        tabnew +setl\ nobuflisted
        nnoremap <buffer><silent> q :bd!<CR>
        for msg in split(info, "\n")
          call append(line('$'), msg)
        endfor
        normal! "_dd
        setl nomodifiable
        setl buftype=nofile
        setl filetype=markdown
      else
        echo info
      endif
    else
      return info
    endif
  endfunction

  function! s:syntax_extra() abort
    call matchadd('ErrorMsg','.*[\sError\s\].*')
    call matchadd('WarningMsg','.*[\sWarn\s\].*')
  endfunction

  ""
  " @public
  " Set debug level of SpaceVim. Default is 1.
  "
  "     1 : log all messages
  "
  "     2 : log warning and error messages
  "
  "     3 : log error messages only
  function! SpaceVim#logger#setLevel(level) abort
    call s:LOGGER.set_level(a:level)
  endfunction

  ""
  " @public
  " Set the log output file of SpaceVim. Default is empty.
  function! SpaceVim#logger#setOutput(file) abort
    call s:LOGGER.set_file(a:file)
  endfunction


  " derive a logger for built-in plugins
  " [ name ] [11:31:26] [ Info ] log message here

  let s:derive = {}
  let s:derive.origin_name = s:LOGGER.get_name()

  function! s:derive.info(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.info(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.warn(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.warn(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.error(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.error(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! s:derive.debug(msg) abort
    call s:LOGGER.set_name(self.derive_name)
    call s:LOGGER.debug(a:msg)
    call s:LOGGER.set_name(self.origin_name)
  endfunction

  function! SpaceVim#logger#derive(name) abort
    let s:derive.derive_name = printf('%' . strdisplaywidth(s:LOGGER.get_name()) . 'S', a:name)
    return deepcopy(s:derive)
  endfunction
endif
