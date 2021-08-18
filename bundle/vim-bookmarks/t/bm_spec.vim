describe 'empty model'

  it 'should have no bookmarks'
    Expect bm#has_bookmarks_in_file('foo') to_be_false
    Expect bm#next('foo',  1) ==# 0
    Expect bm#prev('foo',  1) ==# 0
  end

  it 'should add bookmark'
    Expect bm#has_bookmarks_in_file('foo') to_be_false
    Expect bm#has_bookmark_at_line('foo', 3) to_be_false

    call bm#add_bookmark('foo', 1, 3, 'bar')

    Expect bm#has_bookmarks_in_file('foo') to_be_true
    Expect bm#has_bookmark_at_line('foo', 3) to_be_true
  end

  it 'should add bookmark with annotation'
    call bm#add_bookmark('foo', 1, 3, 'bar', 'a remark')

    Expect bm#get_bookmark_by_sign('foo', 1) ==# {'line_nr': 3, 'sign_idx': 1, 'content': 'bar', 'annotation': 'a remark'}
  end

  it 'should deserialize bookmarks'
    let data = []
    call add(data, "let l:bm_file_version = 1")
    call add(data, "let l:bm_sessions = {'default': {'file1': [{'sign_idx': 99, 'line_nr': 1, 'content': 'foo ''test''', 'annotation': 'a note'},],'file2': [{'sign_idx': 50, 'line_nr': 12, 'content': 'bar'},{'sign_idx': 51, 'line_nr': 15, 'content': '''test'''},],}}")
    call add(data, "let l:bm_current_session = 'default'")

    let result = bm#deserialize(data)

    Expect bm#has_bookmarks_in_file('file1') to_be_true
    Expect bm#has_bookmark_at_line('file1', 1) to_be_true
    Expect bm#location_list() ==# ["file1:1:Annotation: a note", "file2:12:bar", "file2:15:'test'"]
    Expect len(result) ==# 3
    Expect result ==# [{"file": "file1", "line_nr": 1, "sign_idx": 99, "content": "foo 'test'", "annotation": "a note"},
                      \{"file": "file2", "line_nr": 12, "sign_idx": 50, "content": "bar", "annotation": ""},
                      \{"file": "file2", "line_nr": 15, "sign_idx": 51, "content": "'test'", "annotation": ""}]
  end

  after
    call bm#del_all()
  end

end

describe 'model with bookmark'

  before
    call bm#add_bookmark('foo', 1, 3, 'bar', 'note')
  end

  it 'should get bookmark by line'
    let bookmark = bm#get_bookmark_by_line('foo', 3)

    Expect bookmark['line_nr']    ==# 3
    Expect bookmark['sign_idx']   ==# 1
    Expect bookmark['content']    ==# 'bar'
    Expect bookmark['annotation'] ==# 'note'
  end

  it 'should get bookmark by sign'
    let bookmark = bm#get_bookmark_by_sign('foo', 1)

    Expect bookmark['line_nr']  ==# 3
    Expect bookmark['sign_idx'] ==# 1
    Expect bookmark['content']  ==# 'bar'
  end

  it 'should update bookmark'
    call bm#update_bookmark_for_sign('foo', 1, 5, 'baz')

    let bookmark = bm#get_bookmark_by_line('foo', 5)
    Expect bookmark['line_nr']    ==# 5
    Expect bookmark['sign_idx']   ==# 1
    Expect bookmark['content']    ==# 'baz'
    Expect bookmark['annotation'] ==# 'note'
    Expect bookmark ==# bm#get_bookmark_by_sign('foo', 1)
  end

  it 'should update annotation'
    call bm#update_annotation('foo', 1, 'awesome annotation')

    let bookmark = bm#get_bookmark_by_line('foo', 3)
    Expect bookmark['annotation'] ==# 'awesome annotation'
  end

  it 'should delete bookmark at line'
    call bm#del_bookmark_at_line('foo', 3)

    Expect bm#has_bookmark_at_line('foo', 3) to_be_false
  end

  after
    call bm#del_all()
  end

end

describe 'model with multiple bookmarks in different files'

  before
    call bm#add_bookmark('file3', 1, 10, 'file3/line10')
    call bm#add_bookmark('file1', 1, 12, 'file1/line12')
    call bm#add_bookmark('file2', 2, 34, 'file2/line34', 'an annotation')
    call bm#add_bookmark('file1', 3, 2,  'file1/line2')
    call bm#add_bookmark('file1', 4, 45, '''test''')
    call bm#add_bookmark('file2', 5, 45, '')
  end

  it 'should return all bookmarks of file per line'
    let dict1 = bm#all_bookmarks_by_line('file1')
    let dict2 = bm#all_bookmarks_by_line('file2')

    Expect len(keys(dict1)) ==# 3
    Expect len(keys(dict2)) ==# 2
    Expect dict1[12]['sign_idx'] ==# 1
    Expect dict2[34]['sign_idx'] ==# 2
    Expect dict1[2]['sign_idx']  ==# 3
    Expect dict1[45]['sign_idx'] ==# 4
    Expect dict2[45]['sign_idx'] ==# 5
  end

  it 'should return total count of bookmarks'
    Expect bm#total_count() ==# 6
  end

  it 'should return all lines'
    let lines = bm#all_lines('file1')

    Expect lines ==# ['2', '12', '45']
  end

  it 'should return all files with bookmarks'
    let files = bm#all_files()

    Expect files ==# ['file1', 'file2', 'file3']
  end

  it 'should return next bookmark'
    Expect bm#next('file1',  1) ==#  2
    Expect bm#next('file1',  3) ==# 12
    Expect bm#next('file1', 11) ==# 12
    Expect bm#next('file1', 12) ==# 45
    Expect bm#next('file1', 13) ==# 45
    Expect bm#next('file1', 59) ==#  2
  end

  it 'should return previous bookmark'
    Expect bm#prev('file1',  1) ==# 45
    Expect bm#prev('file1',  3) ==#  2
    Expect bm#prev('file1', 11) ==#  2
    Expect bm#prev('file1', 12) ==#  2
    Expect bm#prev('file1', 13) ==# 12
    Expect bm#prev('file1', 59) ==# 45
  end

  it 'should return location list'
    let locations = bm#location_list()
    Expect len(locations) ==# 6
    Expect locations[0] ==# 'file1:2:file1/line2'
    Expect locations[1] ==# 'file1:12:file1/line12'
    Expect locations[2] ==# 'file1:45:''test'''
    Expect locations[3] ==# 'file2:34:Annotation: an annotation'
    Expect locations[4] ==# 'file2:45:empty line'
    Expect locations[5] ==# 'file3:10:file3/line10'
  end

  it 'should serialize'
    exec join(bm#serialize(), " | ")

    let s = l:bm_sessions["default"]
    Expect l:bm_file_version ==# 1
    Expect len(keys(l:bm_sessions)) ==# 1
    Expect len(s) ==# 3
    Expect len(s["file1"]) ==# 3
    Expect len(s["file2"]) ==# 2
    Expect len(s["file3"]) ==# 1
    Expect s["file1"] ==# [{"line_nr": 2, "sign_idx": 3, "content": "file1/line2"}, {"line_nr": 12, "sign_idx": 1, "content": "file1/line12"}, {"line_nr": 45, "sign_idx": 4, "content": "'test'"}]
    Expect s["file2"] ==# [{"line_nr": 34, "sign_idx": 2, "content": "file2/line34", "annotation": "an annotation"}, {"line_nr": 45, "sign_idx": 5, "content": ""}]
    Expect s["file3"] ==# [{"line_nr": 10, "sign_idx": 1, "content": "file3/line10"}]
    Expect l:bm_current_session ==# 'default'
  end

  after
    call bm#del_all()
  end

end

describe 'bm#del_all'

  it 'should reset the model'
    call bm#add_bookmark('file1', 1, 1, 'line1')
    call bm#add_bookmark('file2', 2, 1, 'line1')

    call bm#del_all()

    Expect empty(g:line_map) to_be_true
    Expect empty(g:sign_map) to_be_true
    Expect bm#has_bookmarks_in_file('file1') to_be_false
    Expect bm#has_bookmarks_in_file('file2') to_be_false
  end

end
