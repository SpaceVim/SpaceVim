if (exists('g:loaded_grammarous') && g:loaded_grammarous) || &cp
    finish
endif

command! -nargs=* -bar -range=% -complete=customlist,grammarous#complete_opt GrammarousCheck call grammarous#check_current_buffer(<q-args>, [<line1>, <line2>])
command! -nargs=0 -bar GrammarousReset call grammarous#reset()

nnoremap <silent><Plug>(grammarous-move-to-info-window) :<C-u>call grammarous#create_and_jump_to_info_window_of(b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-open-info-window) :<C-u>call grammarous#create_update_info_window_of(b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-reset) :<C-u>call grammarous#reset()<CR>
nnoremap <silent><Plug>(grammarous-fixit) :<C-u>call grammarous#fixit(grammarous#get_error_at(getpos('.')[1 : 2], b:grammarous_result))<CR>
nnoremap <silent><Plug>(grammarous-fixall) :<C-u>call grammarous#fixall(b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-close-info-window) :<C-u>call grammarous#info_win#close()<CR>
nnoremap <silent><Plug>(grammarous-remove-error) :<C-u>call grammarous#remove_error_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-disable-rule) :<C-u>call grammarous#disable_rule_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-disable-category) :<C-u>call grammarous#disable_category_at(getpos('.')[1 : 2], b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-move-to-next-error) :<C-u>call grammarous#move_to_next_error(getpos('.')[1 : 2], b:grammarous_result)<CR>
nnoremap <silent><Plug>(grammarous-move-to-previous-error) :<C-u>call grammarous#move_to_previous_error(getpos('.')[1 : 2], b:grammarous_result)<CR>

try
    call operator#user#define('grammarous', 'operator#grammarous#do')
catch /^Vim\%((\a\+)\)\=:E117/
    " vim-operator-user is not installed
endtry

let g:loaded_grammarous = 1
