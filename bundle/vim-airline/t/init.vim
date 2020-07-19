let s:sections = ['a', 'b', 'c', 'gutter', 'x', 'y', 'z', 'warning']

function! s:clear()
  for key in s:sections
    unlet! g:airline_section_{key}
  endfor
endfunction

call airline#init#bootstrap()

describe 'init sections'
  before
    call s:clear()
    call airline#init#sections()
  end

  after
    call s:clear()
  end

  it 'section a should have mode, paste, spell, iminsert'
    Expect g:airline_section_a =~ 'mode'
    Expect g:airline_section_a =~ 'paste'
    Expect g:airline_section_a =~ 'spell'
    Expect g:airline_section_a =~ 'iminsert'
  end

  it 'section b should be blank because no extensions are installed'
    Expect g:airline_section_b == ''
  end

  it 'section c should be file and coc_status'
    Expect g:airline_section_c == '%<%f%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#%#__accent_bold#%#__restore__#'
  end

  it 'section x should be filetype'
    Expect g:airline_section_x == '%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#wrap(airline#parts#filetype(),0)}'
  end

  it 'section y should be fenc and ff'
    Expect g:airline_section_y =~ 'ff'
    Expect g:airline_section_y =~ 'fenc'
  end

  it 'section z should be line numbers'
    Expect g:airline_section_z =~ '%3p%%'
    Expect g:airline_section_z =~ '%4l'
    Expect g:airline_section_z =~ '%3v'
  end

  it 'should not redefine sections already defined'
    for s in s:sections
      let g:airline_section_{s} = s
    endfor
    call airline#init#bootstrap()
    for s in s:sections
      Expect g:airline_section_{s} == s
    endfor
  end

  it 'all default statusline extensions should be blank'
    Expect airline#parts#get('ale_error_count').raw == ''
    Expect airline#parts#get('ale_warning_count').raw == ''
    Expect airline#parts#get('lsp_error_count').raw == ''
    Expect airline#parts#get('lsp_warning_count').raw == ''
    Expect airline#parts#get('hunks').raw == ''
    Expect airline#parts#get('branch').raw == ''
    Expect airline#parts#get('eclim').raw == ''
    Expect airline#parts#get('neomake_error_count').raw == ''
    Expect airline#parts#get('neomake_warning_count').raw == ''
    Expect airline#parts#get('obsession').raw == ''
    Expect airline#parts#get('syntastic-err').raw == ''
    Expect airline#parts#get('syntastic-warn').raw == ''
    Expect airline#parts#get('tagbar').raw == ''
    Expect airline#parts#get('whitespace').raw == ''
    Expect airline#parts#get('windowswap').raw == ''
    Expect airline#parts#get('ycm_error_count').raw == ''
    Expect airline#parts#get('ycm_warning_count').raw == ''
    Expect airline#parts#get('languageclient_error_count').raw == ''
    Expect airline#parts#get('languageclient_warning_count').raw == ''
    Expect airline#parts#get('coc_status').raw == ''
    Expect airline#parts#get('vista').raw == ''
    Expect airline#parts#get('coc_warning_count').raw == ''
    Expect airline#parts#get('coc_error_count').raw == ''
  end
end

describe 'init parts'
  it 'should not redefine parts already defined'
    call airline#parts#define_raw('linenr', 'bar')
    call airline#init#sections()
    Expect g:airline_section_z =~ 'bar'
  end
end
