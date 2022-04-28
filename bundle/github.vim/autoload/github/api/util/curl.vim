" in vim systemlist() and system() can only use string as it's argv.
function! github#api#util#curl#Get(url,opt) abort
    let cmd = ['curl', '-q','-s', '-i', a:url, '-k']
    call extend(cmd, a:opt)
    return s:parser(systemlist(cmd))
endfunction
fu! s:parser(res) abort
    let status = 0
    let link = {}
    let content = []
    for line in a:res
        if line =~# '^Status:'
            let status = matchstr(line,'\d\+')
        elseif line =~# '^Link:'
            let lastpg = split(matchstr(line,'=\d\+',0,2),'=')[0]
            let nextpg = split(matchstr(line,'=\d\+',0,1),'=')[0]
            let p1 = stridx(line, '<')
            let p2 = stridx(line, '>')
            let p3 = stridx(line, '<', p1 + 1)
            let p4 = stridx(line, '>', p2 + 1)
            let nexturl = strpart(line, p1 + 1, p2 - p1 -1)
            let lasturl = strpart(line, p3 + 1, p4 - p3 -1)
            let link = {
                        \ 'nextpg' : nextpg,
                        \ 'lastpg' : lastpg,
                        \ 'nexturl' : nexturl,
                        \ 'lasturl' : lasturl
                        \}
        elseif line ==# '['
            let res = remove(a:res, index(a:res, '[') ,- 1)
            let content = json_decode(join(res,"\n"))
            break
        endif
    endfor
    return {
                \ 'status' : status,
                \ 'link' : link,
                \ 'content' : content
                \}
endf
