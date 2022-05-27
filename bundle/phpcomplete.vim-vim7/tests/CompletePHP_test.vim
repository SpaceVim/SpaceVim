fun! TestCase_split_height_doesnt_change_when_completing()
    " set up
    set noequalalways

    let winno = winnr()

    " open a second split, get back to the first one
    below 1new
    let winno2 = winnr()
    silent! exec winno.'wincmd w'

    " measure height
    let before_height = winheight(0)
    " trigger plugin
    let ret = phpcomplete#CompletePHP(0, 2)
    " take a second measurement
    let after_height = winheight(0)

    call VUAssertEquals(before_height, after_height, 'split heights should not change')

    " clean up
    silent! exec winno2.'wincmd w'
    silent! bw! %
    set equalalways
endfun

" vim: foldmethod=marker:expandtab:ts=4:sts=4
