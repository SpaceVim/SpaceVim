function! unicode#groups()

    return map(split(globpath(g:unite_unicode_data_path, '*.txt'), '\n'),
          \ '[fnamemodify(v:val, ":t:r"), fnamemodify(v:val, ":p")]')

endfunction
