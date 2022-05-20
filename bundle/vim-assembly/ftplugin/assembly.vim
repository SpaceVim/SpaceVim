if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
let &l:comments = ':;;;,:;;,sr:#|,mb:|,ex:|#,:;'
