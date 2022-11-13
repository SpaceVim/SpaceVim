if !has('patch-7.4.480')
    " Before this patch, vim used modula2 for .md.
    " https://github.com/vim/vim/commit/7d76c804af900ba6dcc4b1e45373ccab3418c6b2
    au! filetypedetect BufRead,BufNewFile *.md
endif
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn} set filetype=markdown
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} set filetype=markdown
