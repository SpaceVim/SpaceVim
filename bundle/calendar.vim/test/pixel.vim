let s:suite = themis#suite('pixel')
let s:assert = themis#helper('assert')

function! s:suite.pixel_get()
  call s:assert.equals(calendar#pixel#get(''), ['', '', '', '', ''])
  call s:assert.equals(calendar#pixel#get(':'), ['....', '.%%.', '....', '.%%.', '....'])
  call s:assert.equals(calendar#pixel#get('0'), ['%%%%%%', '%%..%%', '%%..%%', '%%..%%', '%%%%%%'])
  call s:assert.equals(calendar#pixel#get('1'), ['....%%', '....%%', '....%%', '....%%', '....%%'])
  call s:assert.equals(calendar#pixel#get('8'), ['%%%%%%', '%%..%%', '%%%%%%', '%%..%%', '%%%%%%'])
  call s:assert.equals(calendar#pixel#get('C'), ['.%%%%%.', '%%...%%', '%%.....', '%%...%%', '.%%%%%.'])
  call s:assert.equals(calendar#pixel#get('E'), ['%%%%%%', '%%....', '%%%%%.', '%%....', '%%%%%%'])
  call s:assert.equals(calendar#pixel#get('O'), ['.%%%%%.', '%%...%%', '%%...%%', '%%...%%', '.%%%%%.'])
  call s:assert.equals(calendar#pixel#get('T'), ['%%%%%%%%', '...%%...', '...%%...', '...%%...', '...%%...'])
endfunction

function! s:suite.pixel_len()
  call s:assert.equals(calendar#pixel#len(''), 0)
  call s:assert.equals(calendar#pixel#len(':'), 2)
  call s:assert.equals(calendar#pixel#len('0'), 6)
  call s:assert.equals(calendar#pixel#len('11'), 8)
  call s:assert.equals(calendar#pixel#len('00'), 12)
  call s:assert.equals(calendar#pixel#len('123'), 14)
  call s:assert.equals(calendar#pixel#len('213'), 18)
endfunction
