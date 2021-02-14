let s:LOG = SpaceVim#logger#derive('git')

function! git#logger#info(msg) abort

    call s:LOG.info(a:msg)

endfunction
