let s:User = {}

function! s:User.New(json) abort
    let s:User.html_url = get(a:json, 'html_url' ,'')
    let s:User.name = get(a:json, 'name', '')
    let s:User.blog = get(a:json, 'blog', '')
    let s:User.email = get(a:json, 'email', '')

endfunction

function! s:User.ToString() abort

    echo 'Name : ' . s:User.name ."\n"
                \. 'github url : ' . s:User.html_url . "\n"
                \. 'blog : ' . s:User.blog . "\n"
                \. 'email : ' . s:User.email 
    
endfunction

let g:github#api#obj#User = copy(s:User)

