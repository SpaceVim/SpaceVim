" Fruitpunch - A fruity airline theme!
" vim: tw=80 et sw=2 ts=2

" Colors {{{
let s:dark_gray       = ['#303030', 236]
let s:med_gray_hi     = ['#444444', 238]
let s:med_gray_lo     = ['#3a3a3a', 237]
let s:light_gray      = ['#b2b2b2', 249]
let s:pretty_pink     = ['#f29db4', 217]
let s:banana_smoothie = ['#fce78d', 222]
let s:faded_red       = ['#f97070', 203]
let s:icy_sky         = ['#79e5e0', 116]
let s:orangarine      = ['#e8a15a', 179]
"}}}

" Init {{{
" Translate color defs to airline format
fun! s:gen_def(fg, bg)
  return [a:fg[0], a:bg[0], a:fg[1], a:bg[1]]
endfun
let s:bar_main = s:gen_def(s:light_gray, s:med_gray_lo) + ['']
let g:airline#themes#fruit_punch#palette = {}
"}}}

" Normal mode {{{
let s:airline_a_normal = s:gen_def(s:dark_gray, s:pretty_pink)
let s:airline_c_normal = s:gen_def(s:pretty_pink, s:med_gray_hi)
let g:airline#themes#fruit_punch#palette.normal =
      \ airline#themes#generate_color_map(s:airline_a_normal
      \ , s:bar_main, s:airline_c_normal)
"}}}

" Insert mode {{{
let s:airline_a_insert = s:gen_def(s:dark_gray, s:banana_smoothie)
let s:airline_c_insert = s:gen_def(s:banana_smoothie, s:med_gray_hi)
let g:airline#themes#fruit_punch#palette.insert =
      \ airline#themes#generate_color_map(s:airline_a_insert
      \ , s:bar_main, s:airline_c_insert)
"}}}

" Visual mode {{{
let s:airline_a_visual = s:gen_def(s:dark_gray, s:icy_sky)
let s:airline_c_visual = s:gen_def(s:icy_sky, s:med_gray_hi)
let g:airline#themes#fruit_punch#palette.visual =
      \ airline#themes#generate_color_map(s:airline_a_visual
      \ , s:bar_main, s:airline_c_visual)
"}}}

" Replace mode {{{
let s:airline_a_replace = s:gen_def(s:dark_gray, s:faded_red)
let s:airline_c_replace = s:gen_def(s:faded_red, s:med_gray_hi)
let g:airline#themes#fruit_punch#palette.replace =
      \ airline#themes#generate_color_map(s:airline_a_replace
      \ , s:bar_main, s:airline_c_replace)
"}}}

" Inactive color {{{
let s:airline_inactive = s:gen_def(s:light_gray, s:med_gray_hi)
let g:airline#themes#fruit_punch#palette.inactive =
      \ airline#themes#generate_color_map(s:airline_inactive
      \ , s:airline_inactive, s:airline_inactive)
"}}}

" Global colors {{{
let s:tmp = {'normal_modified': {}, 'insert_modified': {}
      \, 'visual_modified': {}, 'replace_modified': {}}

for mode in keys(s:tmp)
  let s:tmp[mode]['airline_c'] = s:airline_c_insert
endfor
call extend(g:airline#themes#fruit_punch#palette, s:tmp)

let s:warning = s:gen_def(s:dark_gray, s:orangarine)
for mode in keys(g:airline#themes#fruit_punch#palette)
  if mode == 'accents'
    continue
  endif
  let g:airline#themes#fruit_punch#palette[mode]['airline_warning'] = s:warning
endfor
"}}}
