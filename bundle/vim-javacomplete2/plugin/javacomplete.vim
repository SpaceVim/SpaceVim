" Java complete plugin file
" Maintainer:	artur shaik <ashaihullin@gmail.com>
" this file comtains command,custom g:var init and maps

""
" @section Overview, overview
" @library
" @order overview usage faq history todo thanks
" This is javacomplete, an omni-completion script of JAVA language
" for vim 7 and above. It includes javacomplete.vim, java_parser.vim,
" javavi library, javaparser library and javacomplete.txt.


""
" @section Features, features
" @parentsection overview
" 1. List members of a class, including (static) fields, (static) methods and ctors;
" 2. List classes or subpackages of a package;
" 3. Provide parameters information of a method, list all overload methods;
" 4. Complete an incomplete word;
" 5. Provide a complete JAVA parser written in Vim script language;
" 6. Use the JVM to obtain most information;
" 7. Use the embedded parser to obtain the class information from source files;
" 8. JSP is supported, Builtin objects such as request, session can be recognized;
" 9. The classes and jar files in the WEB-INF will be appended automatically to the classpath;
" 10. Server side java reflection class loader and parsing library;
" 11. Search class files automatically;
" 12. Complete class name;
" 13. Add import statement for a given class name;
" 14. Complete methods declaration after '@Override';
" 15. Support for maven, gradle and Eclipse's '.classpath';
" 16. Cross-session cache;
" 17. Auto insert methods that need to be implemented;
" 18. `toString`, `equals`, `hashCode`, Accessors generation.


""
" @section Requirements, requirements
" @parentsection overview
"
" 1. Vim version 7.4 and above with python support;
" 2. JDK8.
"

""
" @section Download, download
" @parentsection overview
" You can download the lastest version from this url:
	" https://github.com/artur-shaik/vim-javacomplete2

""
" @section Install, install
" @parentsection overview
" 1. This assumes you are using `Vundle`.
" Adapt for your plugin manager of choice. Put this into your `.vimrc`.
" >
"   " Java completion plugin.
"   Plugin 'artur-shaik/vim-javacomplete2'
" <
" 2. Set 'omnifunc' option. e.g.
" >
"   autocmd Filetype java setlocal omnifunc=javacomplete#Complete
" <
" 3. Map keys you prefer:
" For smart (trying to guess import option) insert class import with <F4>:
" >
"     nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
"     imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
" <
" For usual (will ask for import option) insert class import with <F5>:
" >
"     nmap <F5> <Plug>(JavaComplete-Imports-Add)
"     imap <F5> <Plug>(JavaComplete-Imports-Add)
" <
" For add all missing imports with <F6>:
" >
"     nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
"     imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
" <
" For remove all missing imports with <F7>:
" >
"     nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
"     imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
" <
" For sorting all imports with <F8>:
" >
"     nmap <F8> <Plug>(JavaComplete-Imports-SortImports)
"     imap <F8> <Plug>(JavaComplete-Imports-SortImports)
" <
" 
" Default mappings:
" >
"     nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
"     nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
"     nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
"     nmap <leader>jii <Plug>(JavaComplete-Imports-Add)
"     nmap <Leader>jis <Plug>(JavaComplete-Imports-SortImports)
" 
"     imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
"     imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
"     imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
"     imap <C-j>ii <Plug>(JavaComplete-Imports-Add)
" 
"     nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)
" 
"     imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)
" 
"     nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
"     nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
"     nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
"     nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
"     nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
"     nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
"     nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
"     nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)
" 
"     imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
"     imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
"     imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)
" 
"     vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
"     vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
"     vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
" <
" 
" 4. Javavi library will be automatcally compiled when you
" use first time. 
" If no libs/javavi/target is generated, check that you have the write permission
" and jdk installed.

""
" @section History, history
"
" This section document the history of `vim-javacomplete2`.
"
" - v2.3.4 2015-12-14
"
"   Use maven, gradle, or Eclipse's 'classpath` file to generate classpath
" 
"   Complete methods declaration on '@Override'.
" 
" - v2.3.3 2015-10-08
"       
"   Jsp files support, no taglibs yet.
"       
"   Vimscript refactored.
"       
"   Read eclipse ".classpath" file.
"       
"   Option to set jvm launcher and compiler for javavi server.
"       
"   Using <Plug> mappings.
"       
"   Bug fixes.
" 
" - v2.3.2 2015-09-18
"       
"   Nested classes.
"
"   Vimscript refactored.
" 
" - v2.3.1 2015-09-07
"   
"   Better experience with imports.
"       
"   Commands added.
" 
" - v2.3 2015-07-29
"   
"   Annotations completion support.
"   
"   Option to swtich use of FQN in completion suggestions.
"   
"   Check python support before start.
" 
" - v2.2 2015-07-08
"   
"   Lambda expressions parsing.
" 
" - v2.1 2015-06-12
"
"   Generics completion. Bug fixes. 
"   
"   Added g:JavaComplete_MavenRepositoryDisable option.
" 
" - v2.0 2015-05-26
"   
"   Writed new library for reflection and parsing. Parsing make by
"   
"   third party library. Library run in server like way.
"   
"   Added class name completion and insertion of class import.
"   
"   Added auto classpath searcher.
" 
" - v0.77.1.2 2011-01-30
"
"   Fixed to adapt globpath() (vim < 7.2). Patched by Sam Lidder.
" 
" - v0.77.1.1 2010-11-12
"
"   Fixed to ignore the 'suffixes' and 'wildignore' options which 
"   
"   make Reflection.class can not be found.
" 
" - v0.77.1 2007-09-19
"
"   Supported showing method parameters information in any place
"   
"   between parenthesises.
" 
" - v0.77 2007-09-19
"
"   bug fix
"     
"   Added GetCurrentFileKey() avoid empty key of s:files for current buffer.
"     
"   Use a new strategy for searching inherited members.
"     
"   Supported new contexts "jav|", "var|", just after an incomplete word.
"     
"   Supported new context "abs(|)", a imported static method.
"     
"   Improved FoundClassDeclaration()
"     
"   Fixed bug calling cursor(0, 0)
"     
"   Rewrote DoGetClassInfo(), GetFQN() and IsFQN()
"     
"   Fixed a bug when merging superclass's members
"     
"   Improved s:MergeLines() and s:ExtractCleanExpr().
"     
"   Rewrote CompleteAfterDot(). Added ParseExpr(). Removed s:GetNextSubexprType()
"     
"   Supported accessible static imported members.
"     
"   Supported accessible inherited members.
" 
"   Used b:changedtick and getftime() to check buffer (or other file) for changing.
"     
"   Supported not-file-name toplevel or static member class in source files.
" 
" - v0.76.8 2007-08-30
"   
"   Created the s:TreeVisitor to search type or symbol names.
"   
"   Supported local and anonymous class.
"   
"   Supported appending automatically classpath under WEB-INF for jsp files.
" 
" - v0.76.7 2007-08-28
"   
"   Fixed case of "new java.util.zip.ZipFile().|"
"   
"   Improved process of type arguments and method parameters. JAVA5+
"   
"   Reorganize codes in javacomplete#Complete()
"   
"   Added CONTEXT_NEED_TYPE, removed CONTEXT_INCOMPLETE_WORD
" 
"   Add Context types for type declaration: CONTEXT_NEED_TYPE
" 
" - v0.76.6 2007-08-23
"
"   Improved GetStatement() and related. Bug fixed.
" 
" - v0.76.5 2007-08-21
"
"   Fixed bug: "foo().|", "getFoo().foo().|", 
" 	
" 	"for (Enumeration entries = ; entries.|; )".
"   
"   Supported input contexts: "((Object)o).|", "((Object)o).getClass().|",
" 	
" 	"new ZipFile(path).|", "(new String().)|".
" 
" - v0.76.4 2007-08-17
"   
"   Improved input contexts: "int.class.toString().|", "list.toArray().|".
"   
"   Fixed recognizing "this(|)", "method1(|)"
"   
"   Added the 'kind' letter to distinguish between classes and packages.
"   
"   Support accessible nested classes.
"   
"   Support import static members and import accessible nested classes.
"   
"   Fixed a bug when Reflection.java is in the path which contains space.
"   
"   Improved process of this and super in JSP.
"   
"   Fixed an severe bug parsing current jsp file.
" 
" - v0.76.3 2007-08-10
"   
"   Add an option 'searchdecl' set by javacomplete#SetSearchdeclMethod().
"   
"   Make an improvement for jsp file.
"   
"   Clear cache when set options affecting classpath.
"   
"   Improved DoGetPackageList() and s:GenerateImports().
"   
"   Replace codes searching list of string with index().
" 
" - v0.76.2 2007-08-08
"   
"   Fix failing to list members of nested class.
"   
"   Combine members of local packages and loadable packages.
"   
"   Add quick recognition of package or import. 
"   
"   Add inherited fields and methods to local class.
" 
" - v0.76.1 2007-08-04
"   
"   Fix using a: in javacomplete#SetClassPath()
"   
"   Fix a bug in javacomplete#GetClassPath()
" 
" - v0.76 2007-08-04
"   
"   2007-08-04
"   
"   Fix a infinite loop bug in s:GetMatchedIndexEx()
"   
"   Fix that array type not recognised in compound expression.
"   
"   Add a option for JDK1.1. See FAQ 3.
"   
"   2007-08-03
"   
"   Improve for 'this' or 'super'.
"   
"   Support searching toplevel class in sourcepath.
"   
"   Clean
"   
"   2007-08-02  
"   
"   Improve the process of checking a class in one of packages.
"   
"   2007-08-01
"   
"   Add Searchdecl() using java_parser.vim to provide quick information.
"   
"   Supports input context: "StringLiteral".|, "int.|", "void.|"
"   
"   2007-07-28
"   
"   Automatcally compile Reflection.java and place it to $HOME.
"   
"   Add option 'javacompiler', default 'javac'
"   
"   Add option 'java', default 'java'
" 
" - v0.75 2007-02-13
"   
"   Add java_parser.vim.
"   
"   Add b:sourcepath option.
"   
"   Improve recognition of classes defined in current buffer or in source path.
"   
"   Support generating class information from tags instead of returning list directly.
" 
" - v0.74 2007-02-03
"   
"   Support jre1.2 (and above).
"   
"   Support input context like "boolean.class.|"
"   
"   Handle java primitive types like 'int'.
" 
" - v0.73 2007-02-01
"   
"   Fix bug that CLASSPATH not used when b:classpath or g:java_classpath not set.
"   
"   Fix bug that call filter() without making a copy for incomplete.
"   
"   Improve recognition of declaration of this class
" 
" - v0.72 2007-01-31
"
"   Handle nested expression.
" 
" - v0.71 2007-01-28
"
"   Add Basic support for class in current folder.
" 
" - v0.70 2007-01-27
"
"   Complete the reflection part.
" 
" - v0.60 2007-01-25
"
"   Design TClassInfo, etc.
" 
" - v0.50 2007-01-21
"
"   Use java and Reflection.class directly.

""
" @section Thanks, thanks
" * Cheng Fang author of original javacomplete plugin;
" * Zhang Li author of vim-javacompleteex plugin;
" * http://github.com/javaparser/javaparser library.
"
" FeedBack:
" Any problem, bug or suggest are welcome to send to ashaihullin@gmail.com

let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('g:JavaComplete_PluginLoaded')
  finish
endif
let g:JavaComplete_PluginLoaded = 1

let g:JavaComplete_IsWindows = javacomplete#util#IsWindows()

if g:JavaComplete_IsWindows
  let g:PATH_SEP    = ';'
  let g:FILE_SEP    = '\'
else
  let g:PATH_SEP    = ':'
  let g:FILE_SEP    = '/'
endif

""
" @section Options, config
" @parentsection usage
" All these options are supported when encoding with java project.


""
" Base cache directory of javacomplete2 (default is ~/.cache):
" >
"   let g:JavaComplete_BaseDir = '~/.your_cache_dir'
" <
let g:JavaComplete_BaseDir =
      \ get(g:, 'JavaComplete_BaseDir', expand('~'. g:FILE_SEP. '.cache'))

""
" In the import selection the default behavior is to use the first option available:
" >
"   let g:JavaComplete_ImportDefault = 0
" <
" To avoid this behavior use:
" >
"   let g:JavaComplete_ImportDefault = -1
" <
let g:JavaComplete_ImportDefault =
      \ get(g:, 'JavaComplete_ImportDefault', 0)
""
" Import selection is activated automatically when completing new class
" name. This can be avoided by setting:
" >
"   let g:JavaComplete_InsertImports = 0
" <
let g:JavaComplete_InsertImports =
      \ get(g:, 'JavaComplete_InsertImports', 1)
""
" Set the path of gradle executable file. by default it is empty string.
let g:JavaComplete_GradleExecutable = ''
""
" The Java daemon should kill itself when Vim stops.
" Also its possible to configure the timeout,
" so if there is no request during this time the daemon will stop.
" To configure the timemout use the following (in seconds).
" By default this option is 0.
let g:JavaComplete_ServerAutoShutdownTime = 0
let g:JavaComplete_ShowExternalCommandsOutput =
      \ get(g:, 'JavaComplete_ShowExternalCommandsOutput', 0)

let g:JavaComplete_ClasspathGenerationOrder =
      \ get(g:, 'JavaComplete_ClasspathGenerationOrder', ['Maven', 'Eclipse', 'Gradle', 'Ant'])
""
" Sorting can by jar archives `jarName` or by package names `packageName`.
" This option is to set the imports sorting type. By default this
" option is `jarName`:
" >
"   let g:JavaComplete_ImportSortType = 'jarName'
" <
" 
let g:JavaComplete_ImportSortType =
      \ get(g:, 'JavaComplete_ImportSortType', 'jarName')
""
" Specifies the order of import groups, when use `packageName`
" sorting type, for example:
" >
"   let g:JavaComplete_ImportOrder = ['java.', 'javax.', 'com.', 'org.', 'net.']
" <
" An import group is a list of individual import statements that all
" start with the same beginning of package name surrounded by blank
" lines above and below the group.
let g:JavaComplete_ImportOrder =
      \ get(g:, 'JavaComplete_ImportOrder', ['java.', 'javax.', 'com.', 'org.', 'net.'])

let g:JavaComplete_StaticImportsAtTop =
      \ get(g:, 'JavaComplete_StaticImportsAtTop', 0)
""
" Regular class names that will be used automatically
" when you insert import:
" >
"   let g:JavaComplete_RegularClasses = ['java.lang.String', 'java.lang.Object']
" <
" You can populate it with your custom classes,
" or it will be populated automatically when you choose any import option.
" List will be persisted, so it will be used next time you run the same project.
let g:JavaComplete_RegularClasses =
      \ get(g:, 'JavaComplete_RegularClasses', ['java.lang.String', 'java.lang.Object', 'java.lang.Exception', 'java.lang.StringBuilder', 'java.lang.Override', 'java.lang.UnsupportedOperationException', 'java.math.BigDecimal', 'java.lang.Byte', 'java.lang.Short', 'java.lang.Integer', 'java.lang.Long', 'java.lang.Float', 'java.lang.Double', 'java.lang.Character', 'java.lang.Boolean'])
""
" Disable automatic startup of server:
" >
"   let g:JavaComplete_AutoStartServer = 0
" <
" By default this option is disabled (1).
let g:JavaComplete_AutoStartServer = 
      \ get(g:, 'JavaComplete_AutoStartServer', 1)
""
" Use fully qualified name in description:
" >
"   let g:JavaComplete_UseFQN = 1
" <
" By default this option is disabled (0).
let g:JavaComplete_UseFQN = get(g:, 'JavaComplete_UseFQN', 0)
""
" Enable or disable default key mappings,
" by default this option is 1, and default mappings are defined.
" To disable default mappings, set this option to 1.
" >
"   let g:JavaComplete_EnableDefaultMappings = 1
" <
let g:JavaComplete_EnableDefaultMappings = 0
""
" Set pom.xml path explicitly:
" >
"   let g:JavaComplete_PomPath = /path/to/pom.xml
" <
" It will be set automatically, if pom.xml is in underlying path.
let g:JavaComplete_PomPath = ''
""
" Close brace on method declaration completion:
" >
"   let g:JavaComplete_ClosingBrace = 1
" <
" Add close brace automatically, when complete method declaration.
" By default this option is enabled (1).
" Disable if it conflicts with another plugins.
let g:JavaComplete_ClosingBrace = 1

""
" Set the directory where to write server logs. By default this option is
" empty.
let g:JavaComplete_JavaviLogDirectory = ''
let g:JavaComplete_CompletionResultSort =
      \ get(g:, 'JavaComplete_CompletionResultSort', 0)
""
" Set directory that contains custom templates for class creation,
" for example:
" >
"   let g:JavaComplete_CustomTemplateDirectory = '~/jc_templates'
" <
" By default this options is empty string.
let g:JavaComplete_CustomTemplateDirectory = ''

""
" @section Commands, commands
" @parentsection usage
" All these commands are supported when encoding with java project.

""
" add all missing 'imports'
command! JCimportsAddMissing call javacomplete#imports#AddMissing()
command! JCDisable call javacomplete#Disable()
command! JCEnable call javacomplete#Enable()
""
" remove all unsused 'imports'
command! JCimportsRemoveUnused call javacomplete#imports#RemoveUnused()
""
" add 'import' for classname that is under cursor, or before it
command! JCimportAdd call javacomplete#imports#Add()
""
" add 'import' for classname trying to guess variant without ask user to choose an option (it will ask on false guessing)
command! JCimportAddSmart call javacomplete#imports#Add(1)
""
" sort all 'imports'
command! JCimportsSort call javacomplete#imports#SortImports()

command! JCGetSymbolType call javacomplete#imports#getType()

""
" show port, through which vim plugin communicates with server;
command! JCserverShowPort call javacomplete#server#ShowPort()
""
" show server process identificator;
command! JCserverShowPID call javacomplete#server#ShowPID()
""
" start server manually;
command! JCserverStart call javacomplete#server#Start()
""
" stop server manually;
command! JCserverTerminate call javacomplete#server#Terminate()
""
" compile server manually;
command! JCserverCompile call javacomplete#server#Compile()
command! JCserverLog call javacomplete#server#GetLogContent()
command! JCserverEnableDebug call javacomplete#server#EnableDebug()
command! JCserverEnableTraceDebug call javacomplete#server#EnableTraceDebug()

""
" enable logs;
command! JCdebugEnableLogs call javacomplete#logger#Enable()

""
" disable logs;
command! JCdebugDisableLogs call javacomplete#logger#Disable()
""
" get debug logs;
command! JCdebugGetLogContent call javacomplete#logger#GetContent()

""
" clear cache manually.
command! JCcacheClear call javacomplete#ClearCache()

command! JCstart call javacomplete#Start()

""
" generate methods that need to be implemented
command! JCgenerateAbstractMethods call javacomplete#generators#AbstractDeclaration()
""
" generate getters and setters for all fields;
command! JCgenerateAccessors call javacomplete#generators#Accessors()
""
" generate setter for field under cursor;
command! JCgenerateAccessorSetter call javacomplete#generators#Accessor('s')
""
" generate getter for field under cursor;
command! JCgenerateAccessorGetter call javacomplete#generators#Accessor('g')
""
" generate getter and setter for field under cursor;
command! JCgenerateAccessorSetterGetter call javacomplete#generators#Accessor('sg')
""
" generate 'toString' method;
command! JCgenerateToString call javacomplete#generators#GenerateToString()
""
" generate 'equals' and 'hashCode' methods;
command! JCgenerateEqualsAndHashCode call javacomplete#generators#GenerateEqualsAndHashCode()
""
" generate constructor with chosen fields;
command! JCgenerateConstructor call javacomplete#generators#GenerateConstructor(0)
""
" generate default constructor;
command! JCgenerateConstructorDefault call javacomplete#generators#GenerateConstructor(1)

command! JCclasspathGenerate call javacomplete#classpath#classpath#RebuildClassPath()

""
" open prompt to enter class creation command;
command! JCclassNew call javacomplete#newclass#CreateClass()
""
" open prompt to choose template that will be used for creation class boilerplate in current empty file;
command! JCclassInFile call javacomplete#newclass#CreateInFile()

if g:JavaComplete_AutoStartServer
  augroup vim_javacomplete2
    autocmd!
    autocmd Filetype java,jsp JCstart
  augroup END
endif

function! s:nop(s)
  return ''
endfunction

nnoremap <silent> <Plug>(JavaComplete-Imports-AddMissing) :call javacomplete#imports#AddMissing()<cr>
inoremap <silent> <Plug>(JavaComplete-Imports-AddMissing) <c-r>=<SID>nop(javacomplete#imports#AddMissing())<cr>
nnoremap <silent> <Plug>(JavaComplete-Imports-RemoveUnused) :call javacomplete#imports#RemoveUnused()<cr>
inoremap <silent> <Plug>(JavaComplete-Imports-RemoveUnused) <c-r>=<SID>nop(javacomplete#imports#RemoveUnused())<cr>
nnoremap <silent> <Plug>(JavaComplete-Imports-Add) :call javacomplete#imports#Add()<cr>
inoremap <silent> <Plug>(JavaComplete-Imports-Add) <c-r>=<SID>nop(javacomplete#imports#Add())<cr>
nnoremap <silent> <Plug>(JavaComplete-Imports-AddSmart) :call javacomplete#imports#Add(1)<cr>
inoremap <silent> <Plug>(JavaComplete-Imports-AddSmart) <c-r>=<SID>nop(javacomplete#imports#Add(1))<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-AbstractMethods) :call javacomplete#generators#AbstractDeclaration()<cr>
inoremap <silent> <Plug>(JavaComplete-Generate-AbstractMethods) <c-r>=<SID>nop(javacomplete#generators#AbstractDeclaration())<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-Accessors) :call javacomplete#generators#Accessors()<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetter) :call javacomplete#generators#Accessor('s')<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-AccessorGetter) :call javacomplete#generators#Accessor('g')<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetterGetter) :call javacomplete#generators#Accessor('sg')<cr>
inoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetter) <c-r>=<SID>nop(javacomplete#generators#Accessor('s'))<cr>
inoremap <silent> <Plug>(JavaComplete-Generate-AccessorGetter) <c-r>=<SID>nop(javacomplete#generators#Accessor('g'))<cr>
inoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetterGetter) <c-r>=<SID>nop(javacomplete#generators#Accessor('sg'))<cr>
vnoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetter) :call javacomplete#generators#Accessor('s')<cr>
vnoremap <silent> <Plug>(JavaComplete-Generate-AccessorGetter) :call javacomplete#generators#Accessor('g')<cr>
vnoremap <silent> <Plug>(JavaComplete-Generate-AccessorSetterGetter) :call javacomplete#generators#Accessor('sg')<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-ToString) :call javacomplete#generators#GenerateToString()<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-EqualsAndHashCode) :call javacomplete#generators#GenerateEqualsAndHashCode()<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-Constructor) :call javacomplete#generators#GenerateConstructor(0)<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-DefaultConstructor) :call javacomplete#generators#GenerateConstructor(1)<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-NewClass) :call javacomplete#newclass#CreateClass()<cr>
nnoremap <silent> <Plug>(JavaComplete-Generate-ClassInFile) :call javacomplete#newclass#CreateInFile()<cr>
nnoremap <silent> <Plug>(JavaComplete-Imports-SortImports) :call javacomplete#imports#SortImports()<cr>
inoremap <silent> <Plug>(JavaComplete-Imports-SortImports) <c-r>=<SID>nop(javacomplete#imports#SortImports())<cr>

let &cpoptions = s:save_cpo
unlet s:save_cpo
augroup vim_javacomplete2
  autocmd User CmSetup call cm#sources#java#register()
augroup END
" vim:set fdm=marker sw=2 nowrap:
