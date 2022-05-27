if !exists('g:org_custom_column_options')
    let g:org_custom_column_options = ['%ITEM %15DEADLINE %35TAGS', '%ITEM %35TAGS'] 
endif

if !exists('g:org_command_for_emacsclient') && (has('unix') || has('macunix'))
    let g:org_command_for_emacsclient = 'emacsclient'
endif
if !exists('g:org_custom_colors')
    let g:org_custom_colors=[]
endif
if !exists('g:org_tags_persistent_alist')
    let g:org_tags_persistent_alist = ''
endif
if !exists('g:org_save_when_searched')
    let g:org_save_when_searched = 0
endif
if !exists('g:org_capture_file')
   let g:org_capture_file = ''
endif
if !exists('g:org_sort_with_todo_words')
    let g:org_sort_with_todo_words=1
endif
if !exists('g:org_tags_alist')
    let g:org_tags_alist = ''
endif
if !exists('g:org_agenda_include_clocktable')
    let g:org_agenda_include_clocktable = 0
endif
if !exists('g:org_confirm_babel_evaluate')
    let g:org_confirm_babel_evaluate = 0
endif
if !exists('g:org_agenda_window_position')
    let g:org_agenda_window_position = 'bottom'
endif
