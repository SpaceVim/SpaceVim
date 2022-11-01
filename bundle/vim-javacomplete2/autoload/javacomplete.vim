" Vim completion script for java
" Maintainer:	artur shaik <ashaihullin@gmail.com>




""
" @section Usage, usage
" You can use `vim-javacomplete2` just like other omni-completion plugin.
" Many samples of input context are gived in the following section.
"
" See |javacomplete-faq| in time if some problem occurs.
" When meeting other problems not described in FAQ, you can contact with
" the author by the following e-mail: ashaihullin@gmail.com
"

""
" @section Input contexts, contexts
" @parentsection usage
" It recognize nearly all kinds of Primary Expressions (see langspec-3.0)
" except for `"Primary.new Indentifier"`. Casting conversion is also supported.
" 
" Samples of input contexts are as following: (Note that '|' indicates cursor)
"
" (1). after '.', list members of a class or a package
" >
"     - package.| 	subpackages and classes of a package
"     - Type.| 		static members of the 'Type' class and "class"
"     - var.| or field.|	members of a variable or a field
"     - method().| 	members of result of method()
"     - this.|		members of the current class
"     - ClassName.this.|	members of the qualified class
"     - super.|		members of the super class
"     - array.|		members of an array object
"     - array[i].|	array access, return members of the element of array
"     - "String".|	String literal, return members of java.lang.String
"     - int.| or void.|	primitive type or pseudo-type, return "class"
"     - int[].|		array type, return members of a array type and "class"
"     - java.lang.String[].|
"     - new int[].|	members of the new array instance
"     - new java.lang.String[i=1][].|
"     - new Type().|	members of the new class instance 
"     - Type.class.|	class literal, return members of java.lang.Class
"     - void.class.| or int.class.|
"     - ((Type)var).|	cast var as Type, return members of Type.
"     - (var.method()).|	same with "var.|"
"     - (new Class()).|	same with "new Class().|"
" <
" (2). after '(', list matching methods with parameters information.
" >
"     - method(|) 	methods matched
"     - var.method(|) 	methods matched
"     - new ClassName(|)	constructors matched
"     - this(|) 		constructors of current class matched
"     - super(|) 		constructors of super class matched
"     Any place between '(' and ')' will be supported soon.
"     Help information of javadoc is not supported yet.
" <
" (3). after an incomplete word, list all the matched beginning with it.
" >
"     - var.ab| 	subset of members of var beginning with `ab`
"     - ab|	list of all maybes
" <
" (4). import statement
" >
"     - " import 	java.util.|"
"     - " import 	java.ut|"
"     - " import 	ja|"
"     - " import 	java.lang.Character.|"	e.g. "Subset"
"     - " import static java.lang.Math.|"	e.g. "PI, abs"
" <
" (5). package declaration
" >
"     - " package 	com.|"
" <
"
" The above are in simple expression.
"
" (6). after compound expression:
" >
"     - PrimaryExpr.var.|
"     - PrimaryExpr.method().|
"     - PrimaryExpr.method(|)
"     - PrimaryExpr.var.ab|
"     e.g.
"     - "java.lang	. System.in .|"
"     - "java.lang.System.getenv().|"
"     - "int.class.toString().|"
"     - "list.toArray().|"
"     - "new ZipFile(path).|"
"     - "new ZipFile(path).entries().|"
" <
" (7). Nested expression:
" >
"     - "System.out.println( str.| )"
"     - "System.out.println(str.charAt(| )"
"     - "for (int i = 0; i < str.|; i++)"
"     - "for ( Object o : a.getCollect| )"
" <
" 

""
" @section Kind letter, kindletter
" @parentsection usage
" A single letter indicates the kind of compeltion item. These kinds are:
" >
" 	+	ctor
" 	v	local variable or parameter
" 	f	nonstatic field
" 	F	static field
" 	m	nonstatic method
" 	M	static method
" 	P	package
" 	C	class type
" 	I	interface type
" <

""
" @section Class creation, classnew
" @parentsection usage
" Prompt scheme, for class creation:
" >
"     template:[subdirectory]:/package.ClassName extends SuperClass implements Interface(String str, public Integer i):contructor(*):toString(1)
" <
" A: (optional) template - which will be used to create class boilerplate. Some existed templates: junit, interface, exception, servlet, etcl
"
" B: (optional) subdirectory in which class will be put. For example: test, androidTest;
"
" C: class name and package. With `/` will use backsearch for parent package to put in it. Without `/` put in relative package to current;
"
" D: (optional) extends and implements classes will be automatically imported;
"
" E: (optional) private str variable, and public i variable will be added to class;
"
" F: (optional) contructor using all fields and toString override method with only 'str' field will be created. Also hashCode and equals can be used.
" 
" There is autocompletion in command prompt that will try to help you. Your current opened file shouldn't have dirty changes or 'hidden' should be set.


""
" @section FAQ, faq
" 4.1 Why can not complete in gradle project?
" 
"     Check if 'gradle' is in your runtime path or './gradlew' (or
"     '.\gradlew.bat' for Windows) is in your project's directory.
" 
" 4.2 I have installed gradle, but why I can not complete R.class?
"     
"     In android project, many of the class contains a ton of
"     innerclass, javacomplete2 could works better by reflection, so you need to
"     compile you project, after use './gradlew build', R.java will be
"     automatically generated and compiled. 

""
" @section Todo, todo
" -  Add javadoc
" -  Cross session cache;
" -  Most used (classes, methods, vars) at first place (smart suggestions);
" -  FXML support;
" -  JSP check support;
" -  Refactoring support?;
" -  Class creation helpers;
" -  etc...


if exists('g:JavaComplete_Autoload')
  finish
endif
let g:JavaComplete_Autoload = 1

" It doesn't make sense to do any work if vim doesn't support any Python since
" we relly on it to properly work.
if has('python3')
  command! -nargs=1 JavacompletePy py3 <args>
  command! -nargs=1 JavacompletePyfile py3file <args>
else
  echoerr 'Javacomplete needs Python3 support to run!'
  finish
endif

function! s:Log(log) abort
  let log = type(a:log) ==# type('') ? a:log : string(a:log)
  call javacomplete#logger#Log('[javacomplete] '. a:log)
endfunction

let g:J_ARRAY_TYPE_MEMBERS = [
      \	{'kind': 'm',		'word': 'clone(',	'abbr': 'clone()',	'menu': 'Object clone()', },
      \	{'kind': 'm',		'word': 'equals(',	'abbr': 'equals()',	'menu': 'boolean equals(Object)', },
      \	{'kind': 'm',		'word': 'getClass(',	'abbr': 'getClass()',	'menu': 'Class Object.getClass()', },
      \	{'kind': 'm',		'word': 'hashCode(',	'abbr': 'hashCode()',	'menu': 'int hashCode()', },
      \	{'kind': 'f',		'word': 'length',				'menu': 'int'},
      \	{'kind': 'm',		'word': 'notify(',	'abbr': 'notify()',	'menu': 'void Object.notify()', },
      \	{'kind': 'm',		'word': 'notifyAll(',	'abbr': 'notifyAll()',	'menu': 'void Object.notifyAll()', },
      \	{'kind': 'm',		'word': 'toString(',	'abbr': 'toString()',	'menu': 'String toString()', },
      \	{'kind': 'm',		'word': 'wait(',	'abbr': 'wait()',	'menu': 'void Object.wait() throws InterruptedException', },
      \	{'kind': 'm', 'dup': 1, 'word': 'wait(',	'abbr': 'wait()',	'menu': 'void Object.wait(long timeout) throws InterruptedException', },
      \	{'kind': 'm', 'dup': 1, 'word': 'wait(',	'abbr': 'wait()',	'menu': 'void Object.wait(long timeout, int nanos) throws InterruptedException', }]

let g:J_ARRAY_TYPE_INFO = {'tag': 'CLASSDEF', 'name': '[', 'ctors': [],
      \     'fields': [{'n': 'length', 'm': '1', 't': 'int'}],
      \     'methods':[
      \	{'n': 'clone',	  'm': '1',		'r': 'Object',	'p': [],		'd': 'Object clone()'},
      \	{'n': 'equals',	  'm': '1',		'r': 'boolean',	'p': ['Object'],	'd': 'boolean Object.equals(Object obj)'},
      \	{'n': 'getClass', 'm': '100010001',	'r': 'Class',	'p': [],		'd': 'Class Object.getClass()'},
      \	{'n': 'hashCode', 'm': '100000001',	'r': 'int',	'p': [],		'd': 'int Object.hashCode()'},
      \	{'n': 'notify',	  'm': '100010001',	'r': 'void',	'p': [],		'd': 'void Object.notify()'},
      \	{'n': 'notifyAll','m': '100010001',	'r': 'void',	'p': [],		'd': 'void Object.notifyAll()'},
      \	{'n': 'toString', 'm': '1', 		'r': 'String',	'p': [],		'd': 'String Object.toString()'},
      \	{'n': 'wait',	  'm': '10001',		'r': 'void',	'p': [],		'd': 'void Object.wait() throws InterruptedException'},
      \	{'n': 'wait',	  'm': '100010001',	'r': 'void',	'p': ['long'],		'd': 'void Object.wait(long timeout) throws InterruptedException'},
      \	{'n': 'wait',	  'm': '10001',		'r': 'void',	'p': ['long','int'],	'd': 'void Object.wait(long timeout, int nanos) throws InterruptedException'},
      \    ]}

let g:J_PRIMITIVE_TYPE_INFO = {'tag': 'CLASSDEF', 'name': '!', 'fields': [{'n': 'class','m': '1','t': 'Class'}]}

let g:J_JSP_BUILTIN_OBJECTS = {'session':	'javax.servlet.http.HttpSession',
      \	'request':	'javax.servlet.http.HttpServletRequest',
      \	'response':	'javax.servlet.http.HttpServletResponse',
      \	'pageContext':	'javax.servlet.jsp.PageContext',
      \	'application':	'javax.servlet.ServletContext',
      \	'config':	'javax.servlet.ServletConfig',
      \	'out':		'javax.servlet.jsp.JspWriter',
      \	'page':		'javax.servlet.jsp.HttpJspPage', }


let g:J_PRIMITIVE_TYPES	= ['boolean', 'byte', 'char', 'int', 'short', 'long', 'float', 'double']
let g:J_KEYWORDS_MODS	= ['public', 'private', 'protected', 'static', 'final', 'synchronized', 'volatile', 'transient', 'native', 'strictfp', 'abstract']
let g:J_KEYWORDS_TYPE	= ['class', 'interface', 'enum']
let g:J_KEYWORDS		= g:J_PRIMITIVE_TYPES + g:J_KEYWORDS_MODS + g:J_KEYWORDS_TYPE + ['super', 'this', 'void', 'var'] + ['assert', 'break', 'case', 'catch', 'const', 'continue', 'default', 'do', 'else', 'extends', 'finally', 'for', 'goto', 'if', 'implements', 'import', 'instanceof', 'interface', 'new', 'package', 'return', 'switch', 'throw', 'throws', 'try', 'while', 'true', 'false', 'null']

let g:JC_MODIFIER_PUBLIC               = 1
let g:JC_MODIFIER_PROTECTED            = 3
let g:JC_MODIFIER_FINAL                = 5
let g:JC_MODIFIER_NATIVE               = 9
let g:JC_MODIFIER_ABSTRACT             = 11

let g:RE_BRACKETS	= '\%(\s*\[\s*\]\)'
let g:RE_IDENTIFIER	= '[a-zA-Z_$][a-zA-Z0-9_$]*'
let g:RE_ANNOTATION	= '@[a-zA-Z_][a-zA-Z0-9_$]*'
let g:RE_QUALID		= g:RE_IDENTIFIER. '\%(\s*\.\s*' .g:RE_IDENTIFIER. '\)*'

let g:RE_REFERENCE_TYPE	= g:RE_QUALID . g:RE_BRACKETS . '*'
let g:RE_TYPE		= g:RE_REFERENCE_TYPE

let g:RE_TYPE_ARGUMENT	= '\%(?\s\+\%(extends\|super\)\s\+\)\=' . g:RE_TYPE
let g:RE_TYPE_ARGUMENT_EXTENDS	= '\%(?\s\+\%(extends\|super\)\s\+\)' . g:RE_TYPE
let g:RE_TYPE_ARGUMENTS	= '<' . g:RE_TYPE_ARGUMENT . '\%(\s*,\s*' . g:RE_TYPE_ARGUMENT . '\)*>'
let g:RE_TYPE_WITH_ARGUMENTS_I	= g:RE_IDENTIFIER . '\s*' . g:RE_TYPE_ARGUMENTS
let g:RE_TYPE_WITH_ARGUMENTS	= g:RE_TYPE_WITH_ARGUMENTS_I . '\%(\s*' . g:RE_TYPE_WITH_ARGUMENTS_I . '\)*'

let g:RE_TYPE_MODS	= '\%(public\|protected\|private\|abstract\|static\|final\|strictfp\)'
let g:RE_TYPE_DECL_HEAD	= '\(class\|interface\|enum\)[ \t\n\r]\+'
let g:RE_TYPE_DECL	= '\<\C\(\%(' .g:RE_TYPE_MODS. '\s\+\)*\)' .g:RE_TYPE_DECL_HEAD. '\(' .g:RE_IDENTIFIER. '\)[{< \t\n\r]'

let g:RE_ARRAY_TYPE	= '^\s*\(' .g:RE_QUALID . '\)\(' . g:RE_BRACKETS . '\+\)\s*$'
let g:RE_SELECT_OR_ACCESS	= '^\s*\(' . g:RE_IDENTIFIER . '\)\s*\(\[.*\]\)\=\s*$'
let g:RE_ARRAY_ACCESS	= '^\s*\(' . g:RE_IDENTIFIER . '\)\s*\(\[.*\]\)\+\s*$'
let g:RE_CASTING	= '^\s*(\(' .g:RE_QUALID. '\))\s*\(' . g:RE_IDENTIFIER . '\)\>'

let g:RE_KEYWORDS	= '\<\%(' . join(g:J_KEYWORDS, '\|') . '\)\>'

let g:JAVA_HOME = $JAVA_HOME

let g:JavaComplete_Cache = {}	" FQN -> member list, e.g. {'java.lang.StringBuffer': classinfo, 'java.util': packageinfo, '/dir/TopLevelClass.java': compilationUnit}
let g:JavaComplete_Files = {}	" srouce file path -> properties, e.g. {filekey: {'unit': compilationUnit, 'changedtick': tick, }}

let g:JavaComplete_ProjectKey = ''

fu! SScope() abort
  return s:
endfu

function! javacomplete#Disable() abort
  let g:JavaComplete_Disabled = 1
endfunction

function! javacomplete#Enable() abort
  let g:JavaComplete_Disabled = 0
endfunction

function! javacomplete#ClearCache() abort
  let g:JavaComplete_Cache = {}
  let g:JavaComplete_Files = {}

  call javacomplete#util#RemoveFile(javacomplete#util#GetBase('cache'). g:FILE_SEP. 'class_packages_'. g:JavaComplete_ProjectKey. '.dat')
  call javacomplete#server#Communicate('-collect-packages', '', 's:ClearCache')
endfunction

function! javacomplete#Complete(findstart, base) abort
  return javacomplete#complete#complete#Complete(a:findstart, a:base, 1)
endfunction

" key of g:JavaComplete_Files for current buffer. It may be the full path of current file or the bufnr of unnamed buffer, and is updated when BufEnter, BufLeave.
function! javacomplete#GetCurrentFileKey() abort
  return s:GetCurrentFileKey()
endfunction

function! s:GetCurrentFileKey() abort
  return has('autocmd') ? s:curfilekey : empty(expand('%')) ? bufnr('%') : expand('%:p')
endfunction

function! s:SetCurrentFileKey() abort
  let s:curfilekey = empty(expand('%')) ? bufnr('%') : expand('%:p')
endfunction
call s:SetCurrentFileKey()

function! s:HandleTextChangedI() abort
  if get(g:, 'JC_ClassnameCompletedFlag', 0) && g:JavaComplete_InsertImports
    let saveCursor = getcurpos()
    let line = getline('.')
    if empty(javacomplete#util#Trim(line))
      call cursor(line('.') - 1, 500)
      let line = getline('.')
      let offset = 1
    else
      if line[col('.') - 2] !~# '\v(\s|\.|\(|\<)'
        return
      endif
      let offset = 0
    endif

    let g:JC_ClassnameCompletedFlag = 0
    call javacomplete#imports#Add(1)
    let saveCursor[1] = line('.') + offset
    call setpos('.', saveCursor)
  endif

  if get(g:, 'JC_DeclarationCompletedFlag', 0)
    let line = getline('.')
    if line[col('.') - 2] != ' '
      return
    endif

    let g:JC_DeclarationCompletedFlag = 0

    if line !~# '.*@Override.*'
      let line = getline(line('.') - 1)
    endif

    if line =~# '.*@Override\s\+\(\S\+\|\)\(\s\+\|\)$'
      return
    endif

    if !empty(javacomplete#util#Trim(getline('.')))
      call feedkeys("\b\r", 'n')
    endif
    if g:JavaComplete_ClosingBrace
      call feedkeys("}\eO", 'n')
    endif
  endif
endfunction

function! s:HandleInsertLeave() abort
  if get(g:, 'JC_DeclarationCompletedFlag', 0)
    let g:JC_DeclarationCompletedFlag = 0
  endif
  if get(g:, 'JC_ClassnameCompletedFlag', 0)
    let g:JC_ClassnameCompletedFlag = 0
  endif
endfunction

function! javacomplete#UseFQN() abort
  return g:JavaComplete_UseFQN
endfunction

function! s:RemoveCurrentFromCache() abort
  let package = javacomplete#complete#complete#GetPackageName()
  let classname = split(expand('%:t'), '\.')[0]
  let fqn = package. '.'. classname
  if has_key(g:JavaComplete_Cache, fqn)
    call remove(g:JavaComplete_Cache, fqn)
  endif
  call javacomplete#server#Communicate('-clear-from-cache', fqn, 's:RemoveCurrentFromCache')
  call javacomplete#server#Communicate('-async -recompile-class', fqn, 's:RemoveCurrentFromCache')

  let arguments = '-source '. resolve(expand('%:p'))
  let arguments .= ' -class '. classname
  let arguments .= ' -package '. package
  call javacomplete#server#Communicate('-async -add-source-to-cache', arguments, 's:RemoveCurrentFromCache')
endfunction

function! s:DefaultMappings() abort
  if g:JavaComplete_EnableDefaultMappings
    return
  endif

  nmap <silent> <buffer> <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
  nmap <silent> <buffer> <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
  nmap <silent> <buffer> <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
  nmap <silent> <buffer> <leader>jii <Plug>(JavaComplete-Imports-Add)
  nmap <silent> <buffer> <leader>jis <Plug>(JavaComplete-Imports-SortImports)

  imap <silent> <buffer> <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
  imap <silent> <buffer> <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <silent> <buffer> <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
  imap <silent> <buffer> <C-j>ii <Plug>(JavaComplete-Imports-Add)

  nmap <silent> <buffer> <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  imap <silent> <buffer> <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  nmap <silent> <buffer> <leader>jA <Plug>(JavaComplete-Generate-Accessors)
  nmap <silent> <buffer> <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  nmap <silent> <buffer> <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  nmap <silent> <buffer> <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
  nmap <silent> <buffer> <leader>jts <Plug>(JavaComplete-Generate-ToString)
  nmap <silent> <buffer> <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
  nmap <silent> <buffer> <leader>jc <Plug>(JavaComplete-Generate-Constructor)
  nmap <silent> <buffer> <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

  imap <silent> <buffer> <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
  imap <silent> <buffer> <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
  imap <silent> <buffer> <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  vmap <silent> <buffer> <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  vmap <silent> <buffer> <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  vmap <silent> <buffer> <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  nmap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
  nmap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)
endfunction

augroup javacomplete
  autocmd!
  autocmd BufEnter *.java,*.jsp call s:SetCurrentFileKey()
  autocmd BufEnter *.java call s:DefaultMappings()
  autocmd BufWritePost *.java call s:RemoveCurrentFromCache()
  autocmd VimLeave * call javacomplete#server#Terminate()

  if v:version > 704 || v:version == 704 && has('patch143')
    autocmd TextChangedI *.java,*.jsp call s:HandleTextChangedI()
  else
    echohl WarningMsg
    echomsg 'JavaComplete2 : TextChangedI feature needs vim version >= 7.4.143'
    echohl None
  endif
  autocmd InsertLeave *.java,*.jsp call s:HandleInsertLeave()
augroup END

let g:JavaComplete_Home = fnamemodify(expand('<sfile>'), ':p:h:h:gs?\\?'. g:FILE_SEP. '?')
let g:JavaComplete_JavaParserJar = fnamemodify(g:JavaComplete_Home. join(['', 'libs', 'javaparser-core-3.5.20.jar'], g:FILE_SEP), ':p')

call s:Log('JavaComplete_Home: '. g:JavaComplete_Home)
""
" path of your sources. Don't try to 
" add all sources you have, this will slow down parsing process.
" Add you project sources and necessery library sources. If you
" have compiled classes add them to previous config instead. By
" default plugin will search `src` directory and add it
" automatically.
let g:JavaComplete_SourcesPath = get(g:, 'JavaComplete_SourcesPath', ''). g:PATH_SEP
      \. join(filter(javacomplete#util#GlobPathList(getcwd(), 'src', 0, 3), "match(v:val, '.*build.*') < 0"), g:PATH_SEP)

""
" disable the maven repository.
" >
"   let g:JavaComplete_MavenRepositoryDisabled = 1
" <
" by default this option is disabled (0).
let g:JavaComplete_MavenRepositoryDisabled = 0

if filereadable(getcwd(). g:FILE_SEP. 'build.gradle')
    let g:JavaComplete_SourcesPath = g:JavaComplete_SourcesPath
          \. g:PATH_SEP
          \. join(javacomplete#util#GlobPathList(getcwd()
          \, join(['**', 'build', 'generated', 'source', '**', 'debug'], g:FILE_SEP), 0, 0)
          \, g:PATH_SEP)
endif

for source in get(g:, 'JavaComplete_SourceExclude', [])
  let source = fnamemodify(source, ':p')
  let idx = stridx(g:JavaComplete_SourcesPath, source)
  while idx > 0
    let colon = stridx(g:JavaComplete_SourcesPath, ':', idx + 1)
    let g:JavaComplete_SourcesPath = g:JavaComplete_SourcesPath[:idx - 1] . g:JavaComplete_SourcesPath[colon + 1:]
    let idx = stridx(g:JavaComplete_SourcesPath, source)
  endwhile
endfor

call s:Log('Default sources: '. g:JavaComplete_SourcesPath)

if exists('g:JavaComplete_LibsPath')
  let g:JavaComplete_LibsPath .= g:PATH_SEP
else
  ""
  " path of you jar files. This path will 
  " always appended with '~/.m2/repository' directory. Here you can 
  " add your glassfish libs directory or your project libs. It will 
  " be automatically appended with you jre home path
  let g:JavaComplete_LibsPath = ''
endif

call javacomplete#classpath#classpath#BuildClassPath()

function! javacomplete#Start() abort
  call javacomplete#server#Start()
endfunction

" vim:set fdm=marker sw=2 nowrap:
