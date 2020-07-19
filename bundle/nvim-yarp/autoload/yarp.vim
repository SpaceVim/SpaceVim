
func! yarp#py3(module)
    if type(a:module) == v:t_string
        let rp = {}
        let rp.module = a:module
    else
        let rp = a:module
    endif
    let rp.init = function('yarp#pyx#init')
    let rp.type = 'py3'
    return yarp#core#new(rp)
endfunc

func! yarp#py(module)
    if type(a:module) == v:t_string
        let rp = {}
        let rp.module = a:module
    else
        let rp = a:module
    endif
    let rp.init = function('yarp#pyx#init')
    let rp.type = 'py'
    return yarp#core#new(rp)
endfunc

