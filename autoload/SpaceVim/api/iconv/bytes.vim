let s:ns = expand('<sfile>:p:r:gs?[\\/]?#?:s?^.*#autoload#??:s?$?#?')

function {s:ns}import()
  return s:bytes
endfunction

let s:bytes = {}

function s:bytes.tobytes(v)
  if type(a:v) == type([])
    return a:v
  elseif type(a:v) == type("")
    return self.str2bytes(a:v)
  else
    throw "Can't convert to bytes"
  endif
endfunction

function s:bytes.str2bytes(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function s:bytes.bytes2str(bytes)
  return eval('"' . join(map(copy(a:bytes), 'printf(''\x%02x'', v:val)'), '') . '"')
endfunction

function s:bytes.bytes2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02x", v:val)'), '')
endfunction

function s:bytes.hex2bytes(hex)
  return map(split(a:hex, '..\zs'), 'str2nr(v:val, 16)')
endfunction

function s:bytes.lines2bytes(lines)
  let bytes = []
  let first = 1
  for line in a:lines
    if !first
      call add(bytes, 10)
    endif
    let first = 0
    call extend(bytes, map(range(len(line)), 'line[v:val] == "\n" ? 0 : char2nr(line[v:val])'))
  endfor
  return bytes
endfunction

function s:bytes.bytes2lines(bytes)
  let table = map(range(256), 'printf(''\x%02x'', v:val == 0 ? 10 : v:val)')
  let lines = []
  let start = 0
  while start < len(a:bytes)
    let end = index(a:bytes, 10, start)
    if end == -1
      let end = len(a:bytes)
    endif
    let line = eval('"' . join(map(range(start, end - 1), 'table[a:bytes[v:val]]'), '') . '"')
    call add(lines, line)
    if end == len(a:bytes) - 1
      call add(lines, '')
    endif
    let start = end + 1
  endwhile
  return lines
endfunction

function s:bytes.readfile(filename)
  try
    let lines = readfile(a:filename, 'b')
  catch /^Vim\%((\a\+)\)\=:E484:/
    throw "Can't read file"
  endtry
  let bytes = self.lines2bytes(lines)
  return bytes
endfunction

function s:bytes.writefile(bytes, filename)
  let lines = self.bytes2lines(a:bytes)
  if writefile(lines, a:filename, 'b') != 0
    throw "Can't write file"
  endif
endfunction

