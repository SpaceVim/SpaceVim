function! s:is_empty_region(begin, end)
    return a:begin[1] > a:end[1] || (a:begin[1] == a:end[1] && a:end[2] < a:begin[2])
endfunction

function! operator#grammarous#do(visual_kind)
    if s:is_empty_region(getpos("'["), getpos("']"))
        return
    endif

    call grammarous#check_current_buffer('', [getpos("'[")[1], getpos("']")[1]])
endfunction
