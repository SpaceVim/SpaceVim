""
" @section Introduction, intro
" The gtags.vim plugin script integrates the GNU GLOBAL source code tag
" system with Vim. About the details, see http://www.gnu.org/software/global/.

scriptencoding utf-8

let g:gtags_gtagslabel = ''

if !exists('g:gtags_auto_update')
    let g:gtags_auto_update = 1
endif


if !exists('g:gtags_silent')
    let g:gtags_silent = 1
endif

""
" General form of Gtags command is as follows:
" >
"     :Gtags [option] pattern
"
" To go to func, you can say
" >
"     :Gtags func
"
" Input completion is available. If you forgot function name but recall
" only some characters of the head, please input them and press <TAB> key.
" >
"     :Gtags fu<TAB>
"     :Gtags func                     " Vim will append 'nc'.
"
" If you omitted argument, vim ask it like this:
" >
"     Gtags for pattern: <current token>
"
" Vim execute `global -x main', parse the output, list located
" objects in quickfix window and load the first entry.  The quickfix
" windows is like this:
" >
"     gozilla/gozilla.c|200| main(int argc, char **argv)
"     gtags-cscope/gtags-cscope.c|124| main(int argc, char **argv)
"     gtags-parser/asm_scan.c|2056| int main()
"     gtags-parser/gctags.c|157| main(int argc, char **argv)
"     gtags-parser/php.c|2116| int main()
"     gtags/gtags.c|152| main(int argc, char **argv)
"     [Quickfix List]
"
" You can go to any entry using quickfix command.
"
" :cn
"     go to the next entry.
"
" :cp
"     go to the previous entry.
"
" :cc{N}
"     go to the {N}th entry.
"
" :cl
"     list all entries.
"
" You can see the help of quickfix like this:
" >
"     :h quickfix
"
" You can use POSIX regular expression too. It requires more execution time though.
" >
"     :Gtags ^[sg]et_
"
" It will match to both of 'set_value' and 'get_value'.
"
" To go to the referenced point of func, add -r option.
" >
"     :Gtags -r func
"
" To go to any symbols which are not defined in GTAGS, try this.
" >
"     :Gtags -s func
"
" To go to any string other than symbol, try this.
" >
"     :Gtags -g ^[sg]et_
"
" This command accomplishes the same function as grep(1) but is more convenient
" because it retrieves the entire directory structure.
"
" To get list of objects in a file 'main.c', use -f command.
" >
"     :Gtags -f main.c
"
" If you are editing `main.c' itself, you can use '%' instead.
" >
"     :Gtags -f %
"
" You can browse project files whose path includes specified pattern.
" For example:
" >
"     :Gtags -P /vm/                  <- all files under 'vm' directory.
"     :Gtags -P \.h$                  <- all include files.
"     :Gtags -P init                  <- all paths includes 'init'
"
" If you omitted the argument and input only <ENTER> key to the prompt,
" vim shows list of all files in your project.
"
" You can use all options of `global(1)` except for the -c, -p, -u and
" all long name options. They are sent to `global(1)` as is.
" For example, if you want to ignore case distinctions in pattern.
" >
"     :Gtags -gi paTtern
"
" It will match to both of `PATTERN` and `pattern`.
"
" If you want to search a pattern which starts with a hyphen like '-C'
" then you can use the -e option like `grep(1)`.
" >
"     :Gtags -ge -C
"
" By default, Gtags command search only in source files. If you want to
" search in both source files and text files, or only in text files then
" >
"     :Gtags -go pattern              # both source and text
"     :Gtags -gO pattern              # only text file
"
" See `global(1)` for other options.
command! -nargs=* -complete=custom,gtags#complete Gtags call gtags#global(<q-args>)

""
" The GtagsCursor command brings you to the definition or reference of
" the current token.
" >
"     :GtagsCursor
" <
command! -nargs=0 GtagsCursor call gtags#cursor()

""
" Use GtagsRemind command to jump to the previous position from where you
" invoked `:Gtags`.
" >
"   ":GtagsRemind
" <
command! -nargs=0 GtagsRemind call gtags#remind()

""
" Update gtags for current file, with a {bang}, will update the project's
" gtags database.
command! -nargs=0 -bang GtagsGenerate call gtags#update(<bang>1)
