## About
Improved PHP omni-completion. Based on the default phpcomplete.vim.

 [![Build Status](https://travis-ci.org/shawncplus/phpcomplete.vim.svg?branch=master)](https://travis-ci.org/shawncplus/phpcomplete.vim)

## Features
 * Correct restriction of static or standard methods based on context ( show only static methods with `::` and only standard with `->`)
 * Real support for `self::` and `$this->` with the aforementioned context restriction
 * Constant variable completion (not just `define(VARIABLE, 1)` but `const VARIABLE = 1`)
 * Better class detection:
     - Recognize `/* @var $yourvar YourClass */` type mark comments
     - Recognize `$instance = new Class;` class instantiations
     - Recognize `$instance = Class::getInstance();` singleton instances
     - Recognize `$date = DateTime::createFromFormat(...)` built-in class return types
     - Recognize type hinting in function prototypes
     - Recognize types in `@param` lines in function docblocks
     - Recognize `$object = SomeClass::staticCall(...)` return types from docblocks
     - Recognize array of objects via docblock like `$foo[42]->` or for variables created in `foreach`
 * Displays docblock info in the preview for methods and properties
 * Updated built-in class support with constants, methods and properties
 * Updated list of PHP constants
 * Updated list of built-in PHP functions
 * Namespace support ( **Requires** [patched ctags](https://github.com/shawncplus/phpcomplete.vim/wiki/Getting-better-tags) )
 * Enhanced jump-to-definition on <kbd>ctrl</kbd>+<kbd>]</kbd>

## Install

### Pathogen
 1. Install the [pathogen.vim](https://github.com/tpope/vim-pathogen) plugin, [follow the instructions here](https://github.com/tpope/vim-pathogen#installation)
 2. Clone the repository under your `~/.vim/bundle/` directory:

         cd ~/.vim/bundle
         git clone git://github.com/shawncplus/phpcomplete.vim.git

### Vundle
 1. Install and configure the [Vundle](https://github.com/gmarik/vundle) plugin manager, [follow the instructions here](https://github.com/gmarik/vundle#quick-start)
 2. Add the following line to your `.vimrc`:

         Plugin 'shawncplus/phpcomplete.vim'
 3. Source your `.vimrc` with `:so %` or otherwise reload your vim
 4. Run the `:PluginInstall` command

## Usage
If you're new to auto-completion in Vim, we recommend reading our ["Beginner's Guide"](GUIDE.md).

## ctags
In order to support some php features introduced in PHP 5.3 you will have to use
a ctags binary that can generate the appropriate tags files. Most unix like systems 
have a ctags version built in that's really outdated. Please read the "[getting better tags](https://github.com/shawncplus/phpcomplete.vim/wiki/Getting-better-tags)" wiki page for more information.

## Options

**let g:phpcomplete\_relax\_static\_constraint = 1/0  [default 0]** <br>
Enables completion for non-static methods when completing for static context (`::`).
This generates `E_STRICT` level warning, but php calls these methods nonetheless.

**let g:phpcomplete\_complete\_for\_unknown\_classes = 1/0 [default 0]** <br>
Enables completion of variables and functions in "everything under the sun" fashion
when completing for an instance or static class context but the code can't tell the class
or locate the file that it lives in.
The completion list generated this way is only filtered by the completion base
and generally not much more accurate then simple keyword completion.

**let g:phpcomplete\_search\_tags\_for\_variables = 1/0 [default 0]** <br>
Enables use of tags when the plugin tries to find variables.
When enabled the plugin will search for the variables in the tag files with kind 'v',
lines like `$some_var = new Foo;` but these usually yield highly inaccurate results and
can	be fairly slow.

**let g:phpcomplete\_min\_num\_of\_chars\_for\_namespace\_completion = n [default 1]** *Requires [patched ctags](https://github.com/shawncplus/phpcomplete.vim/wiki/Getting-better-tags)* <br>
This option controls the number of characters the user needs to type before
the tags will be searched for namespaces and classes in typed out namespaces in
"use ..." context. Setting this to 0 is not recommended because that means the code
have to scan every tag, and vim's taglist() function runs extremely slow with a
"match everything" pattern.<br>

**let g:phpcomplete\_parse\_docblock\_comments = 1/0 [default 0]**<br>
When enabled the preview window's content will include information
extracted from docblock comments of the completions.
Enabling this option will add return types to the completion menu for functions too.

**let g:phpcomplete\_cache\_taglists = 1/0 [default 1]**<br>
When enabled the taglist() lookups will be cached and subsequent searches
for the same pattern will not check the tagfiles any more, thus making the
lookups faster. Cache expiration is based on the mtimes of the tag files.

**let g:phpcomplete_enhance_jump_to_definition = 1/0  [default 1]<br>**
When enabled the `<C-]>` will be mapped to `phpcomplete#JumpToDefinition()`
which will try to make a more educated guess of the current
symbol's location than simple tag search. If the symbol's location
cannot be found the original `<C-]>` functionality will be invoked

**let g:phpcomplete\_mappings = {..} <br>**
Defines the mappings for the enhanced jump-to-definition.

**Recognized keys:**

 - **jump\_to\_def**: Jumps to the definition in the current buffer
 - **jump\_to\_def\_split**: Jumps to the definition in a new split buffer
 - **jump\_to\_def\_vsplit**: Jumps to the definition in a new vertical split buffer
 - **jump\_to\_def\_tabnew**: Jumps to the definition in a new tab buffer

You change any of them like this in your `vimrc`:

    let g:phpcomplete_mappings = {
      \ 'jump_to_def': ',g',
      \ 'jump_to_def_tabnew': ',t',
      \ }
The keys you don't specify will be mapped to the defaults:

    let g:phpcomplete_mappings = {
       \ 'jump_to_def': '<C-]>',
       \ 'jump_to_def_split': '<C-W><C-]>',
       \ 'jump_to_def_vsplit': '<C-W><C-\>',
       \ 'jump_to_def_tabnew': '<C-W><C-[>',
       \}

**let g:phpcomplete\_add\_function\_extensions = [...]**<br>
**let g:phpcomplete\_add\_class\_extensions = [...]**<br>
**let g:phpcomplete\_add\_interface\_extensions = [...]**<br>
**let g:phpcomplete\_add\_constant\_extensions = [...]**<br>
**let g:phpcomplete\_remove\_function\_extensions = [...]**<br>
**let g:phpcomplete\_remove\_class\_extensions = [...]**<br>
**let g:phpcomplete\_remove\_interface\_extensions = [...]**<br>
**let g:phpcomplete\_remove\_constant\_extensions = [...]**<br>
Built-in functions, classes, interfaces and constatns are grouped together by the extension.
Only the enabled extensions will be loaded for the plugin, the defaultly enabled ones can be
found in.

    g:phpcomplete_active_function_extensions
    g:phpcomplete_active_class_extensions
    g:phpcomplete_active_interface_extensions
    g:phpcomplete_active_constant_extensions

If you want to enable an extension that is disabled you can add it to the enabled lists
in your vimrc. Let's say you want to have the mongo extension's classes and functions
to be completed by the plugin, you can add it like this (in your `.vimrc`):

    let g:phpcomplete_add_class_extensions = ['mongo']
    let g:phpcomplete_add_function_extensions = ['mongo']

If you want to disable an otherwise enabled one, use the ..._remove_... version of these options:

    let g:phpcomplete_remove_function_extensions = ['xslt_php_4']
    let g:phpcomplete_remove_constant_extensions = ['xslt_php_4']

For the available extension files, check the [`misc/available_extensions`](https://github.com/shawncplus/phpcomplete.vim/blob/master/misc/available_extensions). file
