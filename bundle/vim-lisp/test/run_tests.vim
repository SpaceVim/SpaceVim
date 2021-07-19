let s:script_path = resolve(expand('<sfile>:p'))
let s:test_home = fnamemodify(s:script_path, ':h')
let s:path_sep = s:script_path[len(s:test_home)]
let s:test_file_pattern = join([s:test_home, 'test_*.vim'], s:path_sep)

let s:test_file_list = glob(s:test_file_pattern, v:true, v:true)
for tfile in s:test_file_list
    echom 'Running ' . string(tfile)
    execut 'source ' . escape(tfile, ' \')
    if len(v:errors) > 0
        echohl ErrorMsg
        echom string(tfile) . ' failed. Check v:errors.'
        echohl None
        break
    endif
endfor

if len(v:errors) <= 0
    echom "All tests passed"
endif
