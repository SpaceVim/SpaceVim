let g:bm_sign_index = 1
let g:bookmark_sign = 'xy'
let g:bookmark_annotation_sign = 'yz'
let g:bookmark_highlight_lines = 0

describe 'with uninitialized signs'

  it 'should initialize'
    call bm_sign#init()

    Expect g:bm_sign_index ==# 1
    Expect util#redir_execute(":sign list Bookmark") ==#
          \ "sign Bookmark text=xy linehl= texthl=BookmarkSign"
    Expect util#redir_execute(":sign list BookmarkAnnotation") ==#
          \ "sign BookmarkAnnotation text=yz linehl= texthl=BookmarkAnnotationSign"
    Expect split(util#redir_execute(":highlight BookmarkSignDefault"), '\n')[0] ==#
          \ "BookmarkSignDefault xxx ctermfg=33"
    Expect split(util#redir_execute(":highlight BookmarkAnnotationSignDefault"), '\n')[0] ==#
          \ "BookmarkAnnotationSignDefault xxx ctermfg=28"
    Expect split(util#redir_execute(":highlight BookmarkLineDefault"), '\n')[0] ==#
          \ "BookmarkLineDefault xxx ctermfg=232 ctermbg=33"
    Expect split(util#redir_execute(":highlight BookmarkAnnotationLineDefault"), '\n')[0] ==#
          \ "BookmarkAnnotationLineDefault xxx ctermfg=232 ctermbg=28"
  end

  it 'should initialize with line highlight'
    let g:bookmark_highlight_lines = 1

    call bm_sign#init()

    Expect util#redir_execute(":sign list Bookmark") ==#
          \ "sign Bookmark text=xy linehl=BookmarkLine texthl=BookmarkSign"
  end

end

describe "with initialized signs"

  before
    let g:bm_sign_index = 1
    call bm_sign#init()
    execute ":new"
    execute ":e LICENSE"
    let g:test_file = expand("%:p")
  end

  it 'should add signs'
    Expect bm_sign#add(g:test_file, 2, 0) ==# 1
    Expect bm_sign#add(g:test_file, 10, 1) ==# 2

    let signs = util#redir_execute(":sign place file=". g:test_file)
    let lines = bm_sign#lines_for_signs(g:test_file)

    Expect g:bm_sign_index ==# 3
    Expect len(split(signs, '\n')) ==# 4
    Expect lines ==# {'1': '2', '2': '10'}
  end

  it 'should delete signs'
    let idx1 = bm_sign#add(g:test_file, 2, 0)
    let idx2 = bm_sign#add(g:test_file, 10, 0)
    Expect idx1 ==# 1
    Expect idx2 ==# 2
    call bm_sign#del(g:test_file, idx1)
    call bm_sign#del(g:test_file, idx2)

    let signs = util#redir_execute(":sign place file=". g:test_file)
    let lines = bm_sign#lines_for_signs(g:test_file)

    Expect lines ==# {}
    Expect len(split(signs, '\n')) ==# 1
  end

  it 'should not fail to delete signs from invalid buffer'
    call bm_sign#del("invalid", 1)
  end

  after
    execute ":q!"
  end

end

describe "with added signs"

  before
    let g:bm_sign_index = 3
    call bm_sign#init()
    execute ":new"
    execute ":e LICENSE"
    let g:test_file = expand("%:p")
  end

  it 'should add sign with lower index'
    call bm_sign#add_at(g:test_file, 1, 5, 0)
    Expect g:bm_sign_index ==# 3
  end

  it 'should add sign with equal index'
    call bm_sign#add_at(g:test_file, 3, 5, 0)
    Expect g:bm_sign_index ==# 4
  end

  it 'should add sign with higher index'
    call bm_sign#add_at(g:test_file, 4, 5, 0)
    Expect g:bm_sign_index ==# 5
  end

  it 'should transform sign to annotation'
    call bm_sign#add_at(g:test_file, 4, 5, 0)
    call bm_sign#update_at(g:test_file, 4, 5, 1)

    let signs = util#redir_execute(":sign place file=". g:test_file)
    let lines = split(signs, "\n")
    Expect match(lines, 'name=bookmarkannotation\c') ># 0
  end

  after
    execute "sign unplace *"
    execute ":q!"
  end

end
