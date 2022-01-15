function! org#buffer#init()
    let b:v={}
    let b:v.prevlev = 0
    let b:v.org_loaded=0
    let b:v.lasttext_lev=''
    let b:v.dateMatch = '\(\d\d\d\d-\d\d-\d\d\)'
    let b:v.headMatch = '^\*\+\s'
    let b:v.tableMatch = '^\(\s*|.*|\s*$\|#+TBLFM\)'
    let b:v.taglineMatch = '^\s*:\S\+:\s*$'
    let b:v.headMatchLevel = '^\(\*\)\{level}\s'
    let b:v.propMatch = '^\s*:\s*\(PROPERTIES\)'
    let b:v.propvalMatch = '^\s*:\s*\(\S*\)\s*:\s*\(\S.*\)\s*$'
    let b:v.drawerMatch = '^\s*:\(PROPERTIES\|LOGBOOK\)'
    let b:v.levelstars = 1
    let b:v.effort=['0:05','0:10','0:15','0:30','0:45','1:00','1:30','2:00','4:00']
    let b:v.tagMatch = '\(:\S*:\)\s*$'
    let b:v.mytags = ['buy','home','work','URGENT']
    let b:v.foldhi = ''
    let b:v.org_inherited_properties = ['COLUMNS']
    let b:v.org_inherited_defaults = {'CATEGORY':expand('%:t:r'),'COLUMNS':'%40ITEM %30TAGS'}
    let b:v.heading_marks = []
    let b:v.heading_marks_dict = {}
    let b:v.chosen_agenda_heading = 0
    let b:v.prop_all_dict = {}
    let b:v.buf_tags_static_spec = ''
    let b:v.buffer_category = ''
    if !exists('g:org_agenda_default_search_spec')
        let g:org_agenda_default_search_spec = 'ANY_TODO'
    endif
    if exists('g:global_column_defaults') 
        let b:v.buffer_columns = g:global_column_defaults 
    else
        let b:v.buffer_columns = '%40ITEM %30TAGS'
    endif
    let b:v.last_dict_time = 0
    let b:v.last_idict_time = 0
    let b:v.last_idict_type = 0
    let b:v.clock_to_logbook = 1
    let b:v.messages = []
    let b:v.global_cycle_levels_to_show=4
    let b:v.src_fold=0
    let b:v.foldhilines = []
    let b:v.cycle_with_text=1
    let b:v.foldcolors=['Normal','SparseSkip','Folded','WarningMsg','WildMenu','DiffAdd','DiffChange','Normal','Normal','Normal','Normal']
    let b:v.cols = []
    let b:v.basedate = strftime("%Y-%m-%d %a")
    let b:v.sparse_list = []
    let b:v.fold_list = []
    let b:v.suppress_indent=0
    let b:v.suppress_list_indent=0

endfunction
