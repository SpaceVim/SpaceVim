# DEPRECATED in favor of [jc.nvim](https://github.com/artur-shaik/jc.nvim)

# vim-javacomplete2

Updated version of the original [javacomplete plugin](http://www.vim.org/scripts/script.php?script_id=1785) for vim.

## Demo

![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/demo.gif)

Generics demo

![vim-javacomplete2](https://github.com/artur-shaik/vim-javacomplete2/raw/master/doc/generics_demo.gif)

## Intro

This is vim-javacomplete2, an omni-completion plugin for [Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) requiring vim 7.

It includes javacomplete.vim, java_parser.vim, javavi (reflecton and source parsing library), javavibridge.py, and the [javaparser](https://github.com/javaparser/javaparser) library.

I have kept java_parser.vim for local (live) continuous parsing, because the javaparser library can't parse unfinished files.

For now the main difference from the original plugin is the existence of a server-like java library, that allows communication over sockets. This speeds up reflection and parsing.

One more issue I had with the original javacomplete plugin is losing my classpath and as a result, completion not working.
So now the javacomplete2 plugin detects the JRE library path, thus bringing standard java completion out of the box - no configuration required!
The plugin will scan child directory tree for `src` directory and add it to the sources path (For this, it is nice to have [vim-rooter](https://github.com/airblade/vim-rooter.git) plugin).

For the first run the plugin will compile the Javavi library.

## Features

Features:
- Server side java reflection class loader and parsing library;
- Searches class files automatically, using `maven`, `gradle` or Eclipse's `.classpath` file to append completion classpath;
- Generics;
- Lambdas;
- Annotations completion;
- Nested classes;
- Adding imports automatically, includes `static` imports and imports of nested classes;
- Complete methods declaration after '@Override';
- Jsp support, without taglibs;
- Cross-session cache;
- Auto insert methods that need to be implemented;
- `toString`, `equals`, `hashCode`, Constructors, Accessors generation;
- Class creation.

Features (originally existed):
- List members of a class, including (static) fields, (static) methods and ctors;
- List classes or subpackages of a package;
- Provide parameters information of a method, list all overload methods;
- Complete an incomplete word;
- Provide a complete JAVA parser written in Vim script language;
- Use the JVM to obtain most information.

Features borrowed and ported to vimscript from vim-javacompleteex:
- Complete class name;
- Add import statement for a given class name.

## Requirements

- Vim version 7.4 or above with python support;
- JDK8.

## Installation

### pathogen
Run:

````Shell
cd ~/.vim/bundle
git clone https://github.com/artur-shaik/vim-javacomplete2.git
````

### Vundle
Add to `.vimrc`:

````vimL
Plugin 'artur-shaik/vim-javacomplete2'
````

### NeoBundle
Add to `.vimrc`:

````vimL
NeoBundle 'artur-shaik/vim-javacomplete2'
````

### vim-plug
Add to `.vimrc`:
````vimL
Plug 'artur-shaik/vim-javacomplete2'
````

## Configuration

### Required

Add this to your `.vimrc` file:

`autocmd FileType java setlocal omnifunc=javacomplete#Complete`

To enable smart (trying to guess import option) inserting class imports with F4, add:

`nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)`

`imap <F4> <Plug>(JavaComplete-Imports-AddSmart)`

To enable usual (will ask for import option) inserting class imports with F5, add:

`nmap <F5> <Plug>(JavaComplete-Imports-Add)`

`imap <F5> <Plug>(JavaComplete-Imports-Add)`

To add all missing imports with F6:

`nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)`

`imap <F6> <Plug>(JavaComplete-Imports-AddMissing)`

To remove all unused imports with F7:

`nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)`

`imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)`

Default mappings:

```
  nmap <leader>jI <Plug>(JavaComplete-Imports-AddMissing)
  nmap <leader>jR <Plug>(JavaComplete-Imports-RemoveUnused)
  nmap <leader>ji <Plug>(JavaComplete-Imports-AddSmart)
  nmap <leader>jii <Plug>(JavaComplete-Imports-Add)

  imap <C-j>I <Plug>(JavaComplete-Imports-AddMissing)
  imap <C-j>R <Plug>(JavaComplete-Imports-RemoveUnused)
  imap <C-j>i <Plug>(JavaComplete-Imports-AddSmart)
  imap <C-j>ii <Plug>(JavaComplete-Imports-Add)

  nmap <leader>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  imap <C-j>jM <Plug>(JavaComplete-Generate-AbstractMethods)

  nmap <leader>jA <Plug>(JavaComplete-Generate-Accessors)
  nmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  nmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  nmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)
  nmap <leader>jts <Plug>(JavaComplete-Generate-ToString)
  nmap <leader>jeq <Plug>(JavaComplete-Generate-EqualsAndHashCode)
  nmap <leader>jc <Plug>(JavaComplete-Generate-Constructor)
  nmap <leader>jcc <Plug>(JavaComplete-Generate-DefaultConstructor)

  imap <C-j>s <Plug>(JavaComplete-Generate-AccessorSetter)
  imap <C-j>g <Plug>(JavaComplete-Generate-AccessorGetter)
  imap <C-j>a <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  vmap <leader>js <Plug>(JavaComplete-Generate-AccessorSetter)
  vmap <leader>jg <Plug>(JavaComplete-Generate-AccessorGetter)
  vmap <leader>ja <Plug>(JavaComplete-Generate-AccessorSetterGetter)

  nmap <silent> <buffer> <leader>jn <Plug>(JavaComplete-Generate-NewClass)
  nmap <silent> <buffer> <leader>jN <Plug>(JavaComplete-Generate-ClassInFile)
```

The default mappings could be disabled with following setting:

```vim
let g:JavaComplete_EnableDefaultMappings = 0
```

### Optional

`g:JavaComplete_LibsPath` - path to additional jar files. This path appends with your libraries specified in `pom.xml`. Here you can add, for example, your glassfish libs directory or your project libs. It will be automatically append your JRE home path.

`g:JavaComplete_SourcesPath` - path of additional sources. Don't try to add all sources you have, this will slow down the parsing process. Instead, add your project sources and necessary library sources. If you have compiled classes add them to the previous config (`g:JavaComplete_LibsPath`) instead. By default the plugin will search the `src` directory and add it automatically.

`let g:JavaComplete_MavenRepositoryDisable = 1` - don't append classpath with libraries specified in `pom.xml` of your project. By default is `0`.

`let g:JavaComplete_UseFQN = 1` - use full qualified name in completions description. By default is `0`.

`let g:JavaComplete_PomPath = /path/to/pom.xml` - set path to `pom.xml` explicitly. It will be set automatically, if `pom.xml` is in underlying path.

`let g:JavaComplete_ClosingBrace = 1` - add close brace automatically, when complete method declaration. Disable if it conflicts with another plugins.

`let g:JavaComplete_JavaviLogDirectory = ''` - directory, where to write server logs.

`let g:JavaComplete_JavaviLogLevel = 'debug'` - enables server side logging (log4j logging levels).

`let g:JavaComplete_BaseDir = '~/.your_cache_dir'` - set the base cache directory of javacomplete2. By default it is `~/.cache`.

`let g:JavaComplete_ImportDefault = 0` - the default selection of import options. By default it is 0, which means automatically select first one. To make nothing on default set `-1`.

`let g:JavaComplete_GradleExecutable = 'gradle'` - use your own path to gradle executable file.

`let g:JavaComplete_ImportSortType = 'jarName'` - imports sorting type. Sorting can be by jar archives `jarName` or by package names `packageName`.

`let g:JavaComplete_StaticImportsAtTop = 1` - imports sorting with static imports at the top. By default this is `0`.

`let g:JavaComplete_ImportOrder = ['java.', 'javax.', 'com.', 'org.', 'net.']` - Specifies the order of import groups, when use `packageName` sorting type.  An import group is a list of individual import statements that all start with the same beginning of package name surrounded by blank lines above and below the group. A `*` indicates all packages not specified, for 'google style' import ordering, e.g. `let g:JavaComplete_ImportOrder = ['com.google.', *, 'java.', 'javax.']`

`let g:JavaComplete_RegularClasses = ['java.lang.String', 'java.lang.Object']` - Regular class names that will be used automatically when you insert import. You can populate it with your custom classes, or it will be populated automatically when you choose any import option. List will be persisted, so it will be used next time you run the same project.

`let g:JavaComplete_CustomTemplateDirectory = '~/jc_templates'` - set directory that contains custom templates, for class creation. By default this options is null.

`let g:JavaComplete_AutoStartServer = 0` - Disable automatic startup of server.

`let g:JavaComplete_CompletionResultSort = 1` - Sort completion results alphabetically.

`let g:JavaComplete_IgnoreErrorMsg = 1` - When it is greater than 0, the error message will be ignored. By default it is 0.

`let g:JavaComplete_CheckServerVersionAtStartup = 0` - Check server version on startup. Can be disabled on slow start, or infinite recompilation. By default it is 1.

`let g:JavaComplete_ExcludeClassRegex = 'lombok\(\.experimental\)\?\.var'` - Exclude matching fully qualified class names from producing import statements.

`let g:JavaComplete_SourceExclude = ['src/frontend']` - Exclude source directories. Accept absolute and relative values.

## Commands

`JCimportsAddMissing` - add all missing 'imports';

`JCimportsRemoveUnused` - remove all unsused 'imports';

`JCimportAdd` - add 'import' for classname that is under cursor, or before it;

`JCimportAddSmart` - add 'import' for classname trying to guess variant without ask user to choose an option (it will ask on false guessing).


`JCgenerateAbtractMethods` - generate methods that need to be implemented;

`JCgenerateAccessors` - generate getters and setters for all fields;

`JCgenerateAccessorSetter` - generate setter for field under cursor;

`JCgenerateAccessorGetter` - generate getter for field under cursor;

`JCgenerateAccessorSetterGetter` - generate getter and setter for field under cursor;

`JCgenerateToString` - generate `toString` method;

`JCgenerateEqualsAndHashCode` - generate `equals` and `hashCode` methods;

`JCgenerateConstructor` - generate constructor with chosen fields;

`JCgenerateConstructorDefault` - generate default constructor;


`JCclassNew` - open prompt to enter class creation command;

`JCclassInFile` - open prompt to choose template that will be used for creation class boilerplate in current empty file;


`JCserverShowPort` - show port, through which vim plugin communicates with server;

`JCserverShowPID` - show server process identificator;

`JCserverStart` - start server manually;

`JCserverTerminate` - stop server manually;

`JCserverCompile` - compile server manually;


`JCdebugEnableLogs` - enable logs;

`JCdebugDisableLogs` - disable logs;

`JCdebugGetLogContent` - get debug logs;

`JCcacheClear` - clear cache manually.

## Class creation

Prompt scheme, for class creation:

    template:[subdirectory]:/package.ClassName extends SuperClass implements Interface(String str, public Integer i):contructor(*):toString(1)

A: (optional) template - which will be used to create class boilerplate. Some existed templates: junit, interface, exception, servlet, etc;

B: (optional) subdirectory in which class will be put. For example: test, androidTest;

C: class name and package. With `/` will use backsearch for parent package to put in it. Without `/` put in relative package to current;

D: (optional) extends and implements classes will be automatically imported;

E: (optional) private str variable, and public i variable will be added to class;

F: (optional) contructor using all fields and toString override method with only `str` field will be created. Also hashCode and equals can be used.

There is autocompletion in command prompt that will try to help you. Your current opened file shouldn't have dirty changes or `hidden` should be set.

## Limitations:

- First run can be slow;
- The embedded parser works a bit slower than expected.

## Todo

- Add javadoc;
- ~~Lambda support~~;
- ~~Cross session cache~~;
- Most used (classes, methods, vars) at first place (smart suggestions);
- FXML support;
- ~~Check for jsp support~~;
- Refactoring support?;
- ~~Class creation helpers~~;
- ~~Generics~~;
- etc...

## Thanks

- Cheng Fang author of original javacomplete plugin;
- Zhang Li author of vim-javacompleteex plugin;
- http://github.com/javaparser/javaparser library.
- [vimdoc](https://github.com/google/vimdoc) generate `:h javacomplete` file

## FeedBack

Any problems, bugs or suggestions are welcome to send to ashaihullin@gmail.com
