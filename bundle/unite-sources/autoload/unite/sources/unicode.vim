let s:unite_source = {
            \ 'name': 'unicode',
            \ 'hooks': {},
            \ 'action_table': {'*': {}},
            \ }

function! s:unite_source.gather_candidates(args, context)
    let filelist = unite#util#sort_by(unite#util#uniq_by(
                 \ map(split(globpath(g:unite_unicode_data_path, '*.txt'), '\n'),
                 \'[fnamemodify(v:val, ":t:r"), fnamemodify(v:val, ":p")]'), 'v:val[0]'),
                 \'v:val[0]')

    return map(filelist, '{
                \ "word": v:val[0],
                \ "source": "unicode",
                \ "kind": "unicode",
                \ }')
endfunction

function! unite#sources#unicode#define()
    return s:unite_source
endfunction

