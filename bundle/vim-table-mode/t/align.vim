" vim: fdm=indent
source t/config/options.vim

function! ConvertLines2Dict(lines)
  let lines = []
  for idx in range(len(a:lines))
    call insert(lines, {"lnum": idx+1, "text": a:lines[idx]})
  endfor
  return lines
endfunction

describe 'Align'
  it 'should align table content correctly'
    Expect tablemode#align#Align(ConvertLines2Dict(readfile('t/fixtures/align/simple_before.txt'))) == ConvertLines2Dict(readfile('t/fixtures/align/simple_after.txt'))
  end

  it 'should align table content with unicode characters correctly'
    Expect tablemode#align#Align(ConvertLines2Dict(readfile('t/fixtures/align/unicode_before.txt'))) == ConvertLines2Dict(readfile('t/fixtures/align/unicode_after.txt'))
  end
end
