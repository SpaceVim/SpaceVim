function! neoformat#formatters#pandoc#enabled() abort
   return ['pandoc']
endfunction

function! neoformat#formatters#pandoc#pandoc() abort
   let l:input_flags = ['markdown',
       \ '+abbreviations',
       \ '+autolink_bare_uris',
       \ '+markdown_attribute',
       \ '+mmd_header_identifiers',
       \ '+mmd_link_attributes',
       \ '+tex_math_double_backslash',
       \ '+emoji',
       \ '+task_lists',
       \ ]

   let l:target_flags = ['markdown',
       \ '+raw_tex',
       \ '-native_spans',
       \ '-simple_tables',
       \ '-multiline_tables',
       \ '-fenced_code_attributes',
       \ '+emoji',
       \ '+task_lists',
       \ ]

   return {
            \ 'exe': 'pandoc',
            \ 'args': [
                \ '-f' ,
                \ join(l:input_flags, ''),
                \ '-t',
                \ join(l:target_flags, ''),
                \ '-s',
                \ '--wrap=auto',
                \ '--atx-headers',
            \],
            \ 'stdin': 1,
            \ }
endfunction
