call vspec#hint({'sid': 'textobj#user#_sid()'})

let g:__FILE__ = expand('<sfile>')

let s:to_be_snr_prefix = {}
function! s:to_be_snr_prefix.match(actual)
  " NB: `Expect a:actual =~# "^\<SNR>\\d\\+_$"` fails depending on 'encoding'.
  return a:actual =~# '\d\+_$' &&
  \      substitute(a:actual, '\d\+_$', '', '') ==# "\<SNR>"
endfunction
call vspec#customize_matcher('to_be_snr_prefix', s:to_be_snr_prefix)

describe 's:snr_prefix'
  context 'in a ordinary situation (verbose=0)'
    it 'works'
      0 verbose Expect Call('s:snr_prefix', g:__FILE__) to_be_snr_prefix
    end
  end

  context 'in a weird situation (verbose=14)'
    it 'works'
      14 verbose Expect Call('s:snr_prefix', g:__FILE__) to_be_snr_prefix
    end
  end

  context 'in a weird situation (verbose=15)'
    it 'works'
      15 verbose Expect Call('s:snr_prefix', g:__FILE__) to_be_snr_prefix
    end
  end
end
