" Vars:
let s:vim_tab_options = {
      \ '&tabline':     '%!choosewin#tabline()',
      \ '&guitablabel': '%{choosewin#get_tablabel(v:lnum)}',
      \ }

" Util::
let s:_ = choosewin#util#get()

function! s:win_all() "{{{1
  return range(1, winnr('$'))
endfunction

function! s:tab_all() "{{{1
  return range(1, tabpagenr('$'))
endfunction
"}}}

" Wins:
let s:wins = {}

function! s:wins.get(...) "{{{1
  let amt = get(a:000, 0)
  let idx = empty(amt) ? -1 : amt - 1
  return self._data[0 : idx]
endfunction

function! s:wins.set(wins) "{{{1
  " Filter out non-existing window before store.
  let self._data = filter(a:wins, 'index(s:win_all(), v:val) isnot -1')
  return self
endfunction
"}}}

" Main:
let s:cw = {}

function! s:cw.start(wins, ...) "{{{1
  call self.init(a:wins, get(a:000, 0, {}))

  try
    let status = []
    " Some status bar plugin need to know if choosewin active or not.
    let g:choosewin_active = 1

    if empty(self.wins.get()) ||
          \ ( len(self.wins.get()) is 1 && self.conf['return_on_single_win'] )
      throw 'RETURN'
    endif
    if len(self.wins.get()) is 1 && self.conf['auto_choose']
      call self.action.do_win(self.wins.get()[0])
    endif

    call self.setup()
    call self.choose()

  catch /\v^(CHOSE \d+)$/
    if self.conf['noop'] 
      let tab    = tabpagenr()
      let win    = str2nr(matchstr(v:exception, '\v^CHOSE \zs\d+'))
      if tab isnot self.src.tab
        call self.action.do_tab(self.src.tab)
      endif
      let status = [ tab, win ]
    else
      let status = [ tabpagenr(), winnr() ]
    endif
    let self.previous = [ self.src.tab, self.src.win ]
  catch /\v^SWAP$/
    let status = [ tabpagenr(), winnr() ]
    if self.conf['swap_stay']
      let self.previous = status
      call self.action._goto_tabwin(self.src.tab, self.src.win)
    else
      let self.previous = [ self.src.tab, self.src.win ]
    endif
  catch /\v^Vim:Interrupt$/
    call self.label_clear()
    call self.action.do_cancel()
  catch /\v^(RETURN|CANCELED)$/
  catch
    let self.exception = v:exception
  finally
    call self.finish()
    let g:choosewin_active = 0
    return status
  endtry
endfunction

function! s:cw.init(wins, conf) "{{{1
  call choosewin#color#init()
  let self.wins        = s:wins.set(a:wins)
  let self.conf        = extend(choosewin#config#get(), a:conf)
  let self.action      = choosewin#action#init(self)
  let self.exception   = ''
  let self.tab_options = {}
  let self.statusline  = {}
  let self.src         = {'win': winnr(), 'tab': tabpagenr()}
endfunction

function! s:cw.setup() "{{{1
  let self.label2tab  = s:_.dict_create(self.conf['tablabel'], s:tab_all())

  if self.conf['overlay_enable']
    let self.overlay = choosewin#overlay#get()
  endif

  if self.conf['tabline_replace']
    let self.tab_options = s:_.buffer_options_set(bufnr(''), s:vim_tab_options)
  endif
endfunction

function! s:cw.choose() "{{{1
  while 1
    call self.label_show()
    let prompt = (self.conf['swap'] ? '[swap] ' : '') . 'choose > '
    let char = s:_.read_char(prompt)

    call self.label_clear()

    " Tab label is chosen.
    let num = s:_.get_ic(self.label2tab, char)
    if !empty(num)
      call self.action.do_tab(num)
      continue
    endif

    " Win label is chosen.
    let num = s:_.get_ic(self.label2win, char)
    if !empty(num)
      if self.conf['swap']
        call self.action._swap(tabpagenr(), num)
      else
        call self.action.do_win(num)
      endif
    endif

    let action_name = 'do_' . get(self.conf['keymap'], char, 'cancel')
    if !s:_.is_Funcref(get(self.action, action_name))
      throw 'UNKNOWN_ACTION'
    endif
    call self.action[action_name]()
  endwhile
endfunction

function! s:cw.finish() "{{{1
  if !empty(self.tab_options)
    call s:_.buffer_options_set(bufnr(''), self.tab_options)
  endif
  echo ''
  redraw
  if self.conf['blink_on_land']
    call s:_.blink(2, "ChooseWinLand", '\k*\%#\k*')
  endif
  if !empty(self.exception)
    call s:_.message(self.exception)
  endif
endfunction

function! s:cw.call_hook(hook_point, arg) "{{{1
  let HOOK = get(self.conf['hook'], a:hook_point, 0)
  if s:_.is_Funcref(HOOK)
    return call(HOOK, [a:arg])
  else
    return a:arg
  endif
endfunction
"}}}

" Label:
function! s:cw.label_show() "{{{1
  if self.conf['hook_enable'] && index(self.conf['hook_bypass'], 'filter_window' ) is -1
    let wins_new = self.call_hook('filter_window', copy(self.wins.get()))
    call self.wins.set(wins_new)
  endif

  let wins = self.wins.get(len(self.conf['label']))

  let self.label2win = s:_.dict_create(self.conf.label, wins)
  let self.win2label = s:_.dict_create(wins, self.conf.label)

  if self.conf['statusline_replace']
    for n in wins
      let self.statusline[n] = s:_.window_options_set(n,
            \ { '&statusline': self.prepare_label(n) })
    endfor
  endif

  if self.conf['overlay_enable']
    call self.overlay.start(wins, self.conf)
  endif
  redraw
endfunction

function! s:cw.label_clear() "{{{1
  if self.conf['statusline_replace']
    for n in self.wins.get(len(self.conf['label']))
      call s:_.window_options_set(n, self.statusline[n])
    endfor
  endif

  if self.conf['overlay_enable']
    call self.overlay.restore()
  endif
endfunction

function! s:cw.prepare_label(win) "{{{1
  let align = self.conf['label_align']
  let pad   = repeat(' ', self.conf['label_padding'])
  let label = self.win2label[a:win]
  let win_s = pad . label . pad
  let color = "ChooseWinLabel" . (winnr() is a:win ? "Current" : "")

  if align is 'left'
    return printf('%%#%s# %s %%#%s# %%= ', color, win_s, "ChooseWinOther")
  endif

  if align is 'right'
    return printf('%%#%s# %%= %%#%s# %s ', "ChooseWinOther", color, win_s)
  endif

  if align is 'center'
    let padding = repeat(' ', winwidth(a:win)/2-len(win_s))
    return printf('%%#%s# %s %%#%s# %s %%#%s# %%= ',
          \ "ChooseWinOther", padding, color, win_s, "ChooseWinOther")
  endif
endfunction
"}}}

" Tabline:
function! s:cw.tabline() "{{{1
  let R   = ''
  let pad = repeat(' ', self.conf['label_padding'])
  let sepalator = printf('%%#%s# ', "ChooseWinOther")
  let tab_all = s:tab_all()
  for tabnum in tab_all
    let color = "ChooseWinLabel" . (tabpagenr() is tabnum ? "Current" : "")
    let R .= printf('%%#%s# %s ', color,  pad . self.get_tablabel(tabnum) . pad)
    let R .= tabnum isnot tab_all[-1] ? sepalator : ''
  endfor
  let R .= printf('%%#%s#', "ChooseWinOther")
  return R
endfunction

function! s:cw.get_tablabel(num) "{{{1
  return len(self.conf['tablabel']) > a:num
        \ ? self.conf['tablabel'][a:num-1]
        \ : '..'
endfunction
"}}}

" API:
function! choosewin#start(...) "{{{1
  return call(s:cw.start, a:000, s:cw)
endfunction

function! choosewin#tabline() "{{{1
  return s:cw.tabline()
endfunction

function! choosewin#get_tablabel(num) "{{{1
  return s:cw.get_tablabel(a:num)
endfunction

function! choosewin#noop() "{{{1
  return s:cw.conf['noop']
endfunction
"}}}

" vim: foldmethod=marker
