
func! yarp#pyx#init() dict
    if self.type == 'py'
        let l:Detect = function('s:pyexe')
    else
        let l:Detect = function('s:py3exe')
    endif

    let exe = call(l:Detect, [], self)

    if get(s:, 'script', '') == ''
        let s:script = globpath(&rtp,'pythonx/yarp.py',1)
    endif

    let self.cmd = [exe, 
                \ '-u',
                \ s:script,
                \ yarp#core#serveraddr(),
                \ self.id,
                \ self.module]

     call self.jobstart()
endfunc

func! s:pyexe() dict
    if get(g:, '_yarp_py', '')
        return g:_yarp_py
    endif
    let g:_yarp_py = get(g:, 'python_host_prog', '')
    if g:_yarp_py == '' && has('nvim') && has('python')
        " heavy weight
        " but better support for python detection
        python import sys
        let g:_yarp_py = pyeval('sys.executable')
    endif
    if g:_yarp_py == ''
        let g:_yarp_py = 'python2'
    endif
    return g:_yarp_py
endfunc

func! s:py3exe() dict
    if get(g:, '_yarp_py3', '')
        return g:_yarp_py3
    endif
    let g:_yarp_py3 = get(g:, 'python3_host_prog', '')
    if g:_yarp_py3 == '' && has('nvim') && has('python3')
        " heavy weight
        " but better support for python detection
        python3 import sys
        let g:_yarp_py3 = py3eval('sys.executable')
    endif
    if g:_yarp_py3 == ''
        let g:_yarp_py3 = 'python3'
    endif
    if exepath(g:_yarp_py3) == ''
        call self.error(
                    \ "Python3 executable [" .
                    \ g:_yarp_py3 .
                    \ "] not found.")
        if has('vim_starting')
            call self.error("")
        endif
        call self.error("###### Please configure g:python3_host_prog properly ######")
        if has('vim_starting')
            call self.error("")
        endif
    endif
    return g:_yarp_py3
endfunc

