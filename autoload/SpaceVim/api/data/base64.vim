"=============================================================================
" base64.vim --- SpaceVim base64 API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

let s:CMP = SpaceVim#api#import('vim#compatible')

if s:CMP.has('python')
  " @vimlint(EVL103, 1, a:text)
  function! s:self.encode(text) abort
    py import vim
    py import base64

    py ret = base64.b64encode(vim.eval('a:text'))
    py vim.command("return '{}'".format(ret))
  endfunction
  " base64Test => YmFzZTY0VGVzdA==

function! s:self.decode(text) abort
python <<EOF
import vim
import base64

ret = vim.eval('a:text')
try:
    ret = base64.b64decode(ret)
    vim.command("return '{}'".format(ret))
except TypeError, e:
    vim.command("return '{}'".format(ret))
EOF
endfunction
  " @vimlint(EVL103, 0, a:text)
else
  function! s:self.encode(data) abort
    let b64 = self._b64encode(self._str2bytes(a:data), self.standard_table, '=')
    return join(b64, '')
  endfunction

  function! s:self.encodebin(data) abort
    let b64 = self._b64encode(self._binstr2bytes(a:data), self.standard_table, '=')
    return join(b64, '')
  endfunction

  function! s:self.decode(data) abort
    let bytes = self._b64decode(split(a:data, '\zs'), self.standard_table, '=')
    return self._bytes2str(bytes)
  endfunction

  let s:self.standard_table = [
        \ 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        \ 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
        \ 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
        \ 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/']

  let s:self.urlsafe_table = [
        \ 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
        \ 'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
        \ 'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
        \ 'w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','_']

  function! s:self._b64encode(bytes, table, pad) abort
    let b64 = []
    for i in range(0, len(a:bytes) - 1, 3)
      let n = a:bytes[i] * 0x10000
            \ + get(a:bytes, i + 1, 0) * 0x100
            \ + get(a:bytes, i + 2, 0)
      call add(b64, a:table[n / 0x40000])
      call add(b64, a:table[n / 0x1000 % 0x40])
      call add(b64, a:table[n / 0x40 % 0x40])
      call add(b64, a:table[n % 0x40])
    endfor
    if len(a:bytes) % 3 == 1
      let b64[-1] = a:pad
      let b64[-2] = a:pad
    endif
    if len(a:bytes) % 3 == 2
      let b64[-1] = a:pad
    endif
    return b64
  endfunction

  function! s:self._b64decode(b64, table, pad) abort
    let a2i = {}
    for i in range(len(a:table))
      let a2i[a:table[i]] = i
    endfor
    let bytes = []
    for i in range(0, len(a:b64) - 1, 4)
      let n = a2i[a:b64[i]] * 0x40000
            \ + a2i[a:b64[i + 1]] * 0x1000
            \ + (a:b64[i + 2] == a:pad ? 0 : a2i[a:b64[i + 2]]) * 0x40
            \ + (a:b64[i + 3] == a:pad ? 0 : a2i[a:b64[i + 3]])
      call add(bytes, n / 0x10000)
      call add(bytes, n / 0x100 % 0x100)
      call add(bytes, n % 0x100)
    endfor
    if a:b64[-1] == a:pad
      unlet a:b64[-1]
    endif
    if a:b64[-2] == a:pad
      unlet a:b64[-1]
    endif
    return bytes
  endfunction

  function! s:self._binstr2bytes(str) abort
    return map(range(len(a:str)/2), 'eval("0x".a:str[v:val*2 : v:val*2+1])')
  endfunction

  function! s:self._str2bytes(str) abort
    return map(range(len(a:str)), 'char2nr(a:str[v:val])')
  endfunction

  function! s:self._bytes2str(bytes) abort
    return eval('"' . join(map(copy(a:bytes), 'printf(''\x%02x'', v:val)'), '') . '"')
  endfunction

endif




function! SpaceVim#api#data#base64#get() abort

  return deepcopy(s:self)

endfunction
