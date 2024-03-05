""
" Start checking the document, and the results will be shown in the local
" list.
command! -nargs=? CheckChinese call ChineseLinter#check(<q-args>)
