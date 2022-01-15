function! org#windows#init()
    let w:v={}
    let w:v.total_columns_width = 30
    let w:v.columnview = 0
    let w:v.org_item_len = 100 
    let w:v.org_colview_list = [] 
    let w:v.org_current_columns = ''
    let w:v.org_column_item_head = ''
    let w:sparse_on = 0
endfunction
