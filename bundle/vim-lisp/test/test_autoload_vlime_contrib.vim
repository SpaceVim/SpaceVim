function! TestCallInitializers()
    function! s:DummyContribInitializer(conn)
        let b:vlime_test_dummy_contrib_initializer_called = v:true
    endfunction

    function! s:DummyUserContribInitializer(conn)
        let b:vlime_test_dummy_user_contrib_initializer_called = v:true
    endfunction

    function! s:DummyInitializersCB(conn)
        let b:vlime_test_dummy_initializers_cb_called = v:true
    endfunction

    let conn = vlime#New()
    let conn['cb_data'] = {}
    " XXX: autoload vlime/contrib.vim
    call vlime#contrib#CallInitializers(conn)

    let conn['cb_data'] = {'contribs': ["DUMMY-CONTRIB"]}
    let g:vlime_contrib_initializers['DUMMY-CONTRIB'] =
                \ function('s:DummyContribInitializer')
    let g:vlime_user_contrib_initializers =
                \ {'DUMMY-CONTRIB': function('s:DummyUserContribInitializer')}
    let b:vlime_test_dummy_contrib_initializer_called = v:false
    let b:vlime_test_dummy_user_contrib_initializer_called = v:false
    let b:vlime_test_dummy_initializers_cb_called = v:false
    call vlime#contrib#CallInitializers(conn, v:null, function('s:DummyInitializersCB'))
    call assert_true(b:vlime_test_dummy_contrib_initializer_called)
    call assert_false(b:vlime_test_dummy_user_contrib_initializer_called)
    call assert_true(b:vlime_test_dummy_initializers_cb_called)

    call remove(g:vlime_contrib_initializers, 'DUMMY-CONTRIB')
    let b:vlime_test_dummy_contrib_initializer_called = v:false
    let b:vlime_test_dummy_user_contrib_initializer_called = v:false
    call vlime#contrib#CallInitializers(conn, v:null, function('s:DummyInitializersCB'))
    call assert_false(b:vlime_test_dummy_contrib_initializer_called)
    call assert_true(b:vlime_test_dummy_user_contrib_initializer_called)

    unlet b:vlime_test_dummy_contrib_initializer_called
    unlet b:vlime_test_dummy_user_contrib_initializer_called
    unlet b:vlime_test_dummy_initializers_cb_called
endfunction

let v:errors = []
call TestCallInitializers()
