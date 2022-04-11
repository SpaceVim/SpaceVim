let s:save_cpo = &cpo
set cpo&vim

if exists('g:JavaUnit_autoload')
    finish
endif
let g:JavaUnit_autoload = 1

let s:Fsep = javaunit#util#Fsep()
let s:Psep = javaunit#util#Psep()

let g:JavaUnit_Home = fnamemodify(expand('<sfile>'), ':p:h:h:gs?\\?'. s:Fsep. '?')

if exists("g:JavaUnit_custom_tempdir")
    let s:JavaUnit_tempdir = g:JavaUnit_custom_tempdir
else
    let s:JavaUnit_tempdir = g:JavaUnit_Home .s:Fsep .'bin'
endif

let s:JavaUnit_TestMethod_Source =
            \g:JavaUnit_Home
            \.s:Fsep
            \.join(['src' , 'com' , 'wsdjeg' , 'util' , '*.java'],s:Fsep)

function! javaunit#Compile() abort
    silent exec '!javac -encoding utf8 -d '.s:JavaUnit_tempdir.' '.s:JavaUnit_TestMethod_Source 
endfunction

if findfile(s:JavaUnit_tempdir.join(['','com','wsdjeg','util','TestMethod.class'],s:Fsep))==""
    call javaunit#Compile()
endif


function javaunit#TestMethod(args,...)
    let line = getline(search("package","nb",getline("0$")))
    if line != ''
        let currentClassName = split(split(line," ")[1],";")[0].".".expand("%:t:r")
    else
        let currentClassName = expand("%:t:r")
    endif
    if a:args == ""
        let cwords = split(tagbar#currenttag('%s', '', ''),'(')[0]
        if filereadable('pom.xml')
            let cmd="java -cp '"
                        \.s:JavaUnit_tempdir
                        \.s:Psep
                        \.getcwd()
                        \.join(['','target','test-classes'],s:Fsep)
                        \.s:Psep
                        \.get(g:,'JavaComplete_LibsPath','.')
                        \."' com.wsdjeg.util.TestMethod "
                        \.currentClassName
                        \.' '
                        \.cwords
        else
            let cmd="java -cp '"
                        \.s:JavaUnit_tempdir
                        \.s:Psep
                        \.get(g:,'JavaComplete_LibsPath','.')
                        \."' com.wsdjeg.util.TestMethod "
                        \.currentClassName
                        \.' '
                        \.cwords
        endif
        call javaunit#util#ExecCMD(cmd)
    else
        if filereadable('pom.xml')
            let cmd="java -cp '"
                        \.s:JavaUnit_tempdir
                        \.s:Psep
                        \.getcwd()
                        \.join(['','target','test-classes'],s:Fsep)
                        \.s:Psep
                        \.get(g:,'JavaComplete_LibsPath','.')
                        \."' com.wsdjeg.util.TestMethod "
                        \.currentClassName
                        \.' '
                        \.a:args
        else
            let cmd="java -cp '"
                        \.s:JavaUnit_tempdir
                        \.s:Psep
                        \.get(g:,'JavaComplete_LibsPath','.')
                        \."' com.wsdjeg.util.TestMethod "
                        \.currentClassName
                        \.' '
                        \.a:args
        endif
        call javaunit#util#ExecCMD(cmd)
    endif
endfunction

function javaunit#TestAllMethods()
    let line = getline(search("package","nb",getline("0$")))
    let currentClassName = split(split(line," ")[1],";")[0].".".expand("%:t:r")
    let cmd="java -cp '" . s:JavaUnit_tempdir.s:Psep.g:JavaComplete_LibsPath . "' com.wsdjeg.util.TestMethod " . currentClassName
    call javaunit#util#ExecCMD(cmd)
endfunction


function javaunit#MavenTest()
    let line = getline(search("package","nb",getline("0$")))
    let currentClassName = split(split(line," ")[1],";")[0].".".expand("%:t:r")
    let cmd = 'mvn test -Dtest='.currentClassName
    call javaunit#util#ExecCMD(cmd)
endfunction

function javaunit#MavenTestAll()
    let cmd = 'mvn test'
    call javaunit#util#ExecCMD(cmd)
endfunction

function javaunit#NewTestClass(classNAME)
    let filePath = expand("%:h")
    let flag = 0
    let packageName = ''
    for a in split(filePath,s:Fsep)
        if flag
            if a == expand("%:h:t")
                let packageName .= a.';'
            else
                let packageName .= a.'.'
            endif
        endif
        if a == "java"
            let flag = 1
        endif
    endfor
    call append(0,"package ".packageName)
    call append(1,"import org.junit.Test;")
    call append(2,"import org.junit.Assert;")
    call append(3,"public class ".a:classNAME." {")
    call append(4,"@Test")
    call append(5,"public void testM() {")
    call append(6,"//TODO")
    call append(7,"}")
    call append(8,"}")
    call feedkeys("gg=G","n")
    call feedkeys("/testM\<cr>","n")
    call feedkeys("viw","n")
    "call feedkeys("/TODO\<cr>","n")
endfunction
function! javaunit#Get_method_name() abort
    let name = 'sss'
    return name
endfunction

function! javaunit#TestMain(...) abort
    let line = getline(search("package","nb",getline("0$")))
    if line != ''
        let currentClassName = split(split(line," ")[1],";")[0].".".expand("%:t:r")
    else
        let currentClassName = expand("%:t:r")
    endif
    if filereadable('pom.xml')
        let cmd="java -cp '"
                    \.s:JavaUnit_tempdir
                    \.s:Psep
                    \.getcwd()
                    \.join(['','target','test-classes'],s:Fsep)
                    \.s:Psep
                    \.get(g:,'JavaComplete_LibsPath','.')
                    \."' "
                    \.currentClassName
                    \.' '
                    \.(len(a:000) > 0 ? join(a:000,' ') : '')
    else
        let cmd='java -cp "' . get(g:,'JavaComplete_LibsPath','.') . s:Psep
                    \.s:JavaUnit_tempdir
                    \.s:Psep
                    \.'" '
                    \.currentClassName
                    \.' '
                    \.(len(a:000) > 0 ? join(a:000,' ') : '')
    endif
    call javaunit#util#ExecCMD(cmd)
endfunction

fu! javaunit#GenerateTestMethods()
    let testClassName = expand('%:t:r')
    if stridx(testClassName, 'test') != -1  || stridx(testClassName, 'Test') != -1
        let line = getline(search("package","nb",getline("0$")))
        let testClassName = split(split(line," ")[1],";")[0]."." . testClassName
        if stridx(testClassName, 'Test') == len(testClassName) - 4
            let className = strpart(testClassName, 0,len(testClassName) - 4)
            let cmd="java -cp '"
                        \.s:JavaUnit_tempdir
                        \.s:Psep
                        \.getcwd()
                        \.join(['','target','test-classes'],s:Fsep)
                        \.s:Psep
                        \.get(g:,'JavaComplete_LibsPath','.')
                        \."' com.wsdjeg.util.GenerateMethod "
                        \.className
            let methods =  split(join(systemlist(cmd)),'|')
            let curPos = getpos('.')
            let classdefineline = search("class " . expand('%:t:r'),"nb",getline("0$"))
            for m in methods
                call append(classdefineline, "/* test " . m . " */")
                call append(classdefineline + 1,"public void test" . toupper(strpart(m,0,1)) . strpart(m,1,len(m)) . "() {")
                call append(classdefineline + 2,"//TODO")
                call append(classdefineline + 3,"}")
            endfor
            call feedkeys("gg=G","n")
            call cursor(curPos[1] + 1, curPos[2])
        else
            echohl WarningMsg | echomsg "This is not a testClassName,now only support className end with 'Test'" | echohl None
        endif
    else
        echohl WarningMsg | echomsg "This is not a testClassName" | echohl None
    endif
endf


let &cpo = s:save_cpo
unlet s:save_cpo
