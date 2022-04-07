" Vim filetype plugin file for adding getter/setter methods
" Language:	Java
" Maintainer: Pete Kazmier (pete-vim AT kazmier DOT com)
" Last Change: 2002 Nov 21 
" Revision: $Id: java_getset.vim,v 1.10 2002/12/02 15:14:31 kaz Exp $
" Credit: 
"    - Based on jcommenter.vim by Kalle Björklid <bjorklid@st.jyu.fi.
"    - Thanks to Dan Sharp for his feedback, suggestions and help.
"    - Thanks to Steven Op de beeck for his feedback and help.
"
" =======================================================================
"
" Copyright 2002 by Peter Kazmier
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions
" are met:
"
"  1. Redistributions of source code must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"
"  2. Redistributions in binary form must reproduce the above
"       copyright notice, this list of conditions and the following
"       disclaimer in the documentation and/or other materials provided
"       with the distribution.
"
"  3. The name of the author may not be used to endorse or promote
"       products derived from this software without specific prior
"       written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
" OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
" ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
" GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
" INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
" WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
" NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
"
" =======================================================================
"
" DESCRIPTION
" This filetype plugin enables a user to automatically add getter/setter
" methods for Java properties.  The script will insert a getter, setter,
" or both depending on the command/mapping invoked.  Users can select
" properties one at a time, or in bulk (via a visual block or specifying a
" range).  In either case, the selected block may include comments as they
" will be ignored during the parsing.  For example, you could select all
" of these properties with a single visual block.
" 
" public class Test 
" { 
"    // The global count
"    private static int count;
"
"    /** The name */
"    private String name;
"
"    /** The array of addresses */
"    private String[] address;
" }
"
" The script will also add the 'static' modifier to the method if the
" property was declared as 'static'.  Array-based properties will get
" additional methods added to support indexing.  In addition, if a
" property is declared 'final', it will not generate a setter for it.
" If a previous getter OR setter exists for a property, the script will
" not add any methods (under the assumption that you've manually added
" your own).
"
" The getters/setters that are inserted can be configured by the user.
" First, the insertion point can be selected.  It can be one of the
" following: before the current line / block, after the current line /
" block, or at the end of the class (default).  Finally, the text that is
" inserted can be configured by defining your own templates.  This allows
" the user to format for his/her coding style.  For example, the default
" value for s:javagetset_getterTemplate is:
"
"     /**
"      * Get %varname%.
"      *
"      * @return %varname% as %type%.
"      */
"     %modifiers% %type% %funcname%()
"     {
"         return %varname%;
"     }
"
" Where the items surrounded by % are parameters that are substituted when
" the script is invoked on a particular property.  For more information on
" configuration, please see the section below on the INTERFACE.
"
" INTERFACE (commands, mappings, and variables)
" The following section documents the commands, mappings, and variables
" used to customize the behavior of this script.  
"
" Commands:
"   :InsertGetterSetter
"       Inserts a getter/setter for the property on the current line, or
"       the range of properties specified via a visual block or x,y range
"       notation.  The user is prompted to determine what type of method
"       to insert.
"
"   :InsertGetterOnly
"       Inserts a getter for the property on the current line, or the
"       range of properties specified via a visual block or x,y range
"       notation.  The user is not prompted.
"
"   :InsertSetterOnly
"       Inserts a setter for the property on the current line, or the
"       range of properties specified via a visual block or x,y range
"       notation.  The user is not prompted.
"
"   :InsertBothGetterSetter
"       Inserts a getter and setter for the property on the current line,
"       or the range of properties specified via a visual block or x,y
"       range notation.  The user is not prompted.
"
"
" Mappings:
"   The following mappings are pre-defined.  You can disable the mappings
"   by setting a variable (see the Variables section below).  The default
"   key mappings use the <LocalLeader> which is the backslash key by
"   default '\'.  This can also be configured via a variable (see below).
"
"   <LocalLeader>p   (or <Plug>JavagetsetInsertGetterSetter)
"       Inserts a getter/setter for the property on the current line, or
"       the range of properties specified via a visual block.  User is
"       prompted for choice.
"
"   <LocalLeader>g   (or <Plug>JavagetsetInsertGetterOnly)
"       Inserts a getter for the property on the current line, or the
"       range of properties specified via a visual block.  User is not
"       prompted.
"
"   <LocalLeader>s   (or <Plug>JavagetsetInsertSetterOnly)
"       Inserts a getter for the property on the current line, or the
"       range of properties specified via a visual block.  User is not
"       prompted.
"
"   <LocalLeader>b   (or <Plug>JavagetsetInsertBothGetterSetter)
"       Inserts both a getter and setter for the property on the current
"       line, or the range of properties specified via a visual block.
"       User is not prompted.
"
"   If you want to define your own mapping, you can map whatever you want
"   to <Plug>JavagetsetInsertGetterSetter (or any of the other <Plug>s
"   defined above).  For example,
"
"       map <buffer> <C-p> <Plug>JavagetsetInsertGetterSetter
"
"   When you define your own mapping, the default mapping does not get
"   set, only the mapping you specify.  
"
" Variables:
"   The following variables allow you to customize the behavior of this
"   script so that you do not need to make changes directly to the script.
"   These variables can be set in your vimrc.
"
"   no_plugin_maps
"     Setting this variable will disable all key mappings defined by any
"     of your plugins (if the plugin writer adhered to the standard
"     convention documented in the scripting section of the VIM manual)
"     including this one.
"
"   no_java_maps
"     Setting this variable will disable all key mappings defined by any
"     java specific plugin including this one.
"
"   maplocalleader
"     By default, the key mappings defined by this script use
"     <LocalLeader> which is the backslash character by default.  You can
"     change this by setting this variable to a different key.  For
"     example, if you want to use the comma-key, you can add this line to
"     your vimrc:
"       
"         let maplocalleader = ','
"
"   g:javagetset_insertPosition
"     This variable determines the location where the getter and/or setter
"     will be inserted.  Currently, three positions have been defined:
"
"         0 - insert at the end of the class (default)
"         1 - insert before the current line / block
"         2 - insert after the current line / block
"
"   g:javagetset_getterTemplate
"   g:javagetset_setterTemplate
"   g:javagetset_getterArrayTemplate
"   g:javagetset_setterArrayTemplate
"     These variables determine the text that will be inserted for a
"     getter, setter, array-based getter, and array-based setter
"     respectively.  The templates may contain the following placeholders
"     which will be substituted by their appropriate values at insertion
"     time:
"
"         %type%          Java type of the property
"         %varname%       The name of the property
"         %funcname%      The method name ("getXzy" or "setXzy")
"         %modifiers%     "public" followed by "static" if the property is static
"
"     For example, if you wanted to set the default getter template so
"     that it would produce the following block of code for a property
"     defined as "public static String name":
"
"         /**
"          * Get name.
"          * @return name as String
"          */
"         public static String getName() { return name; }
"     
"     This block of code can be produced by adding the following variable
"     definition to your vimrc file.
"
"         let g:javagetset_getterTemplate = 
"           \ "\n" .
"           \ "/**\n" .
"           \ " * Get %varname%.\n" .
"           \ " * @return %varname% as %type%.\n" .
"           \ " */\n" .
"           \ "%modifiers% %type% %funcname%() { return %varname%; }"
"
"     The defaults for these variables are defined in the script.  For
"     both the getterTemplate and setterTemplate, there is a corresponding
"     array-baded template that is invoked if a property is array-based.
"     This allows you to set indexed-based getters/setters if you desire.
"     This is the default behavior.
"
"
" INSTALLATION
" 1. Copy the script to your ${HOME}/.vim/ftplugins directory and make
"    sure its named "java_getset.vim" or "java_something.vim" where
"    "something" can be anything you want.  
"
" 2. (Optional) Customize the mapping and/or templates.  You can create
"    your own filetype plugin (just make sure its loaded before this one)
"    and set the variables in there (i.e. ${HOME}/.vim/ftplugin/java.vim)
"
" =======================================================================
"
" NOTE:
" This is my very first VIM script.  I read all of the documentation, and
" have tried to follow the conventions outlined there; however, I may have
" missed some so please bear with me.

" Only do this when not done yet for this buffer
if exists("b:did_javagetset_ftplugin")
  finish
endif
let b:did_javagetset_ftplugin = 1

" Make sure we are in vim mode
let s:save_cpo = &cpo
set cpo&vim

" TEMPLATE SECTION:
" The templates can use the following placeholders which will be replaced
" with appropriate values when the template is invoked:
"
"   %type%          Java type of the property
"   %varname%       The name of the property
"   %funcname%      The method name ("getXzy" or "setXzy")
"   %modifiers%     "public" followed by "static" if the property is static
"
" The templates consist of a getter and setter template.  In addition,
" there are also templates for array-based properties.  These are defined
" below.
"
" Getter Templates (non-array and array-based)
if exists("g:javagetset_getterTemplate")
  let s:javagetset_getterTemplate = g:javagetset_getterTemplate
else  
  let s:javagetset_getterTemplate = 
    \ "\n" .
    \ "/**\n" .
    \ " * Get %varname%.\n" .
    \ " *\n" .
    \ " * @return %varname% as %type%.\n" .
    \ " */\n" .
    \ "%modifiers% %type% %funcname%()\n" .
    \ "{\n" .
    \ "    return %varname%;\n" .
    \ "}"
endif

if exists("g:javagetset_getterArrayTemplate")
  let s:javagetset_getterArrayTemplate = g:javagetset_getterArrayTemplate
else  
  let s:javagetset_getterArrayTemplate =
    \ "\n" .
    \ "/**\n" .
    \ " * Get %varname%.\n" .
    \ " *\n" .
    \ " * @return %varname% as %type%[].\n" .
    \ " */\n" .
    \ "%modifiers% %type%[] %funcname%()\n" .
    \ "{\n" .
    \ "    return %varname%;\n" .
    \ "}\n" .
    \ "\n" .
    \ "/**\n" .
    \ " * Get %varname% element at specified index.\n" .
    \ " *\n" .
    \ " * @param index the index.\n" .
    \ " * @return %varname% at index as %type%.\n" .
    \ " */\n" .
    \ "%modifiers% %type% %funcname%(int index)\n" .
    \ "{\n" .
    \ "    return %varname%[index];\n" .
    \ "}"
endif

" Setter Templates (non-array and array-based)
if exists("g:javagetset_setterTemplate")
  let s:javagetset_setterTemplate = g:javagetset_setterTemplate
else  
  let s:javagetset_setterTemplate = 
  \ "\n" .
  \ "/**\n" .
  \ " * Set %varname%.\n" .
  \ " *\n" .
  \ " * @param %varname% the value to set.\n" . 
  \ " */\n" .
  \ "%modifiers% void %funcname%(%type% %varname%)\n" .
  \ "{\n" .
  \ "    this.%varname% = %varname%;\n" .
  \ "}"
endif

if exists("g:javagetset_setterArrayTemplate")
  let s:javagetset_setterArrayTemplate = g:javagetset_setterArrayTemplate
else  
  let s:javagetset_setterArrayTemplate =
  \ "\n" .
  \ "/**\n" .
  \ " * Set %varname%.\n" .
  \ " *\n" .
  \ " * @param %varname% the value to set.\n" . 
  \ " */\n" .
  \ "%modifiers% void %funcname%(%type%[] %varname%)\n" .
  \ "{\n" .
  \ "    this.%varname% = %varname%;\n" .
  \ "}\n" .
  \ "\n" .
  \ "/**\n" .
  \ " * Set %varname% at the specified index.\n" .
  \ " *\n" .
  \ " * @param %varname% the value to set.\n" . 
  \ " * @param index the index.\n" . 
  \ " */\n" .
  \ "%modifiers% void %funcname%(%type% %varname%, int index)\n" .
  \ "{\n" .
  \ "    this.%varname%[index] = %varname%;\n" .
  \ "}"
endif

" Position where methods are inserted.  The possible values are: 
"   0 - end of class 
"   1 = above block / line
"   2 = below block / line
if exists("g:javagetset_insertPosition")
  let s:javagetset_insertPosition = g:javagetset_insertPosition
else  
  let s:javagetset_insertPosition = 0
endif

" Script local variables that are used like globals.
"
" If set to 1, the user has requested that getters be inserted
let s:getter    = 0 

" If set to 1, the user has requested that setters be inserted
let s:setter    = 0

" If set to 1, the property was a static property (i.e. static methods)
let s:static    = 0

" If set to 1, the property was declared final (i.e. doesn't need a setter)
let s:final     = 0

" If set to 1, use the array based templates
let s:isarray   = 0

" The current indentation level of the property (i.e. used for the methods)
let s:indent    = ''

" The list of property modifiers
let s:modifiers = ''

" The type of the property
let s:vartype   = ''

" If the property is an array, the []'s will be stored here
let s:vararray  = ''

" The name of the property
let s:varname   = ''

" The function name of the property (capitalized varname)
let s:funcname  = ''

" The first line of the block selected
let s:firstline = 0

" The last line of the block selected
let s:lastline  = 0

" Regular expressions used to match property statements
let s:javaname = '[a-zA-Z_$][a-zA-Z0-9_$]*'
let s:brackets = '\(\s*\(\[\s*\]\)\)\='
let s:modifier = '\(private\|protected\|public\|volatile\|static\|final\)'
let s:variable = '\(\s*\)\(\(' . s:modifier . '\s\+\)*\)\(' . s:javaname . '\)' . s:brackets . '\s\+\(' . s:javaname . '\)\s*\(;\|=[^;]\+;\)'

" The main entry point. This function saves the current position of the
" cursor without the use of a mark (see note below)  Then the selected
" region is processed for properties.
" 
" FIXME: I wanted to avoid clobbering any marks in use by the user, so I
" manually try to save the current position and restore it.  The only drag
" is that the position isn't restored correctly if the user opts to insert
" the methods ABOVE the current position.  Using a mark would solve this
" problem as they are automatically adjusted.  Perhaps I just haven't
" found it yet, but I wish that VIM would let a scripter save a mark and
" then restore it later.  Why?  In this case, I'd be able to use a mark
" safely without clobbering any user marks already set.  First, I'd save
" the contents of the mark, then set the mark, do my stuff, jump back to
" the mark, and finally restore the mark to what the user may have had
" previously set.  Seems weird to me that you can't save/restore marks.
"
if !exists("*s:InsertGetterSetter")
  function s:InsertGetterSetter(flag) range
    let restorepos = line(".") . "normal!" . virtcol(".") . "|"
    let s:firstline = a:firstline
    let s:lastline = a:lastline

    if s:DetermineAction(a:flag)
      call s:ProcessRegion(s:GetRangeAsString(a:firstline, a:lastline))
    endif

    execute restorepos
   
    " Not sure why I need this but if I don't have it, the drawing on the
    " screen is messed up from my insert.  Perhaps I'm doing something
    " wrong, but it seems to me that I probably shouldn't be calling
    " redraw.
    redraw!

  endfunction
endif

" Set the appropriate script variables (s:getter and s:setter) to
" appropriate values based on the flag that was selected.  The current
" valid values for flag are: 'g' for getter, 's' for setter, 'b' for both
" getter/setter, and 'a' for ask/prompt user.
if !exists("*s:DetermineAction")
  function s:DetermineAction(flag)
  
    if a:flag == 'g'
      let s:getter = 1
      let s:setter = 0
  
    elseif a:flag == 's'
      let s:getter = 0
      let s:setter = 1
  
    elseif a:flag == 'b'
      let s:getter = 1
      let s:setter = 1
  
    elseif a:flag == 'a'
      return s:DetermineAction(s:AskUser())
  
    else
      return 0
    endif
  
    return 1
  endfunction
endif

" Ask the user what they want to insert, getter, setter, or both.  Return
" an appropriate flag for use with s:DetermineAction, or return 0 if the
" user cancelled out.
if !exists("*s:AskUser")
  function s:AskUser()
    let choice = 
        \   confirm("What do you want to insert?", 
        \           "&Getter\n&Setter\n&Both", 3)

    if choice == 0
      return 0

    elseif choice == 1
      return 'g'

    elseif choice == 2
      return 's'

    elseif choice == 3
      return 'b'

    else
      return 0

    endif
  endfunction
endif

" Gets a range specified by a first and last line and returns it as a
" single string that will eventually be parsed using regular expresssions.
" For example, if the following lines were selected:
"
"     // Age
"     private int age;
"
"     // Name
"     private static String name;
"
" Then, the following string would be returned:
"
"     // Age    private int age;    // Name    priavte static String name;
"
if !exists("*s:GetRangeAsString")
  function s:GetRangeAsString(first, last)
    let line = a:first
    let string = s:TrimRight(getline(line))

    while line < a:last
      let line = line + 1
      let string = string . s:TrimRight(getline(line))
    endwhile

    return string
  endfunction
endif

" Trim whitespace from right of string.
if !exists("*s:TrimRight")
  function s:TrimRight(text)
    return substitute(a:text, '\(\.\{-}\)\s*$', '\1', '')
  endfunction
endif

" Process the specified region indicated by the user.  The region is
" simply a concatenated string of the lines that were selected by the
" user.  This string is searched for properties (that match the s:variable
" regexp).  Each property is then processed.  For example, if the region
" was:
"
"     // Age    private int age;    // Name    priavte static String name;
" 
" Then, the following strings would be processed one at a time:
"
" private int age;
" private static String name;
"
if !exists("*s:ProcessRegion") 
  function s:ProcessRegion(region)
    let startPosition = match(a:region, s:variable, 0) 
    let endPosition = matchend(a:region, s:variable, 0)

    while startPosition != -1
      let result = strpart(a:region, startPosition, endPosition - startPosition)

      "call s:DebugParsing(result)
      call s:ProcessVariable(result)

      let startPosition = match(a:region, s:variable, endPosition) 
      let endPosition = matchend(a:region, s:variable, endPosition)
    endwhile

  endfunction
endif

" Process a single property.  The first thing this function does is
" break apart the property into the following components: indentation,
" modifiers ,type, array, and name.  In addition, the following other
" components are then derived from the previous: funcname, static,
" final, and isarray.  For example, if the specified variable was:
"
" private static String name;
"
" Then the following would be set for the global variables:
"
" indent    = '    '
" modifiers = 'private static'
" vartype   = 'String'
" vararray  = ''
" varname   = 'name'
" funcname  = 'Name'
" static    = 1
" final     = 0
" isarray   = 0
" 
if !exists("*s:ProcessVariable")
  function s:ProcessVariable(variable)
    let s:static    = 0
    let s:isarray   = 0
    let s:final     = 0
    let s:indent    = substitute(a:variable, s:variable, '\1', '') 
    let s:modifiers = substitute(a:variable, s:variable, '\2', '') 
    let s:vartype   = substitute(a:variable, s:variable, '\5', '') 
    let s:vararray  = substitute(a:variable, s:variable, '\7', '') 
    let s:varname   = substitute(a:variable, s:variable, '\8', '') 
    let s:funcname  = toupper(s:varname[0]) . strpart(s:varname, 1)

    " If any getter or setter already exists, then just return as there
    " is nothing to be done.  The assumption is that the user already
    " made his choice.
    if s:AlreadyExists()
      return
    endif

    if s:modifiers =~ 'static'
      let s:static = 1
    endif

    if s:modifiers =~ 'final'
      let s:final = 1
    endif

    if s:vararray =~ '['
      let s:isarray = 1
    endif

    if s:getter
      call s:InsertGetter()
    endif

    if s:setter && !s:final
      call s:InsertSetter()
    endif

  endfunction
endif

" Checks to see if any getter/setter exists.
if !exists("*s:AlreadyExists")
  function s:AlreadyExists()
    return search('\(get\|set\)' . s:funcname . '\_s*([^)]*)\_s*{', 'w')
  endfunction
endif

" Inserts a getter by selecting the appropriate template to use and then
" populating the template parameters with actual values.
if !exists("*s:InsertGetter")
  function s:InsertGetter()

    if s:isarray
      let method = s:javagetset_getterArrayTemplate
    else
      let method = s:javagetset_getterTemplate
    endif

    let mods = "public"
    if s:static
      let mods = mods . " static"
    endif

    let method = substitute(method, '%type%', s:vartype, 'g')
    let method = substitute(method, '%varname%', s:varname, 'g')
    let method = substitute(method, '%funcname%', 'get' . s:funcname, 'g')
    let method = substitute(method, '%modifiers%', mods, 'g')

    call s:InsertMethodBody(method)

  endfunction
endif

" Inserts a setter by selecting the appropriate template to use and then
" populating the template parameters with actual values.
if !exists("*s:InsertSetter")
  function s:InsertSetter()

    if s:isarray
      let method = s:javagetset_setterArrayTemplate
    else
      let method = s:javagetset_setterTemplate
    endif

    let mods = "public"
    if s:static
      let mods = mods . " static"
    endif

    let method = substitute(method, '%type%', s:vartype, 'g')
    let method = substitute(method, '%varname%', s:varname, 'g')
    let method = substitute(method, '%funcname%', 'set' . s:funcname, 'g')
    let method = substitute(method, '%modifiers%', mods, 'g')

    call s:InsertMethodBody(method)

  endfunction
endif

" Inserts a body of text using the indentation level.  The passed string
" may have embedded newlines so we need to search for each "line" and then
" call append separately.  I couldn't figure out how to get a string with
" newlines to be added in one single call to append (it kept inserting the
" newlines as ^@ characters which is not what I wanted).
if !exists("*s:InsertMethodBody")
  function s:InsertMethodBody(text)
    call s:MoveToInsertPosition()

    let pos = line('.')
    let string = a:text

    while 1
      let len = stridx(string, "\n")

      if len == -1
        call append(pos, s:indent . string)
        break
      endif

      call append(pos, s:indent . strpart(string, 0, len))

      let pos = pos + 1
      let string = strpart(string, len + 1)

    endwhile
  endfunction
endif

" Move the cursor to the insertion point.  This insertion point can be
" defined by the user by setting the g:javagetset_insertPosition variable.  
if !exists("*s:MoveToInsertPosition")
  function s:MoveToInsertPosition()

    " 1 indicates above the current block / line
    if s:javagetset_insertPosition == 1
      execute "normal! " . (s:firstline - 1) . "G0"

    " 2 indicates below the current block / line
    elseif s:javagetset_insertPosition == 2
      execute "normal! " . s:lastline . "G0"
    
    " 0 indicates end of class (and is default)
    else
      execute "normal! ?{\<CR>w99[{%k" | nohls

    endif 

  endfunction
endif

" Debug code to decode the properties.
if !exists("*s:DebugParsing")
  function s:DebugParsing(variable)
    echo 'DEBUG: ===================================================='
    echo 'DEBUG:' a:variable
    echo 'DEBUG: ----------------------------------------------------'
    echo 'DEBUG:    indent:' substitute(a:variable, s:variable, '\1', '')
    echo 'DEBUG: modifiers:' substitute(a:variable, s:variable, '\2', '') 
    echo 'DEBUG:      type:' substitute(a:variable, s:variable, '\5', '') 
    echo 'DEBUG:     array:' substitute(a:variable, s:variable, '\7', '') 
    echo 'DEBUG:      name:' substitute(a:variable, s:variable, '\8', '') 
    echo ''
  endfunction
endif

" Add mappings, unless the user didn't want this.  I'm still not clear why
" I need to have two (2) noremap statements for each, but that is what the
" example shows in the documentation so I've stuck with that convention.
" Ideally, I'd prefer to use only one noremap line and map the <Plug>
" directly to the ':call <SID>function()<CR>'.
if !exists("no_plugin_maps") && !exists("no_java_maps") && !exists('g:java_getset_disable_map')
  if !hasmapto('<Plug>JavagetsetInsertGetterSetter')
    map <silent> <buffer> <LocalLeader>p <Plug>JavagetsetInsertGetterSetter
  endif
  noremap <buffer> <script> 
    \ <Plug>JavagetsetInsertGetterSetter 
    \ <SID>InsertGetterSetter
  noremap <buffer> 
    \ <SID>InsertGetterSetter 
    \ :call <SID>InsertGetterSetter('a')<CR>

  if !hasmapto('<Plug>JavagetsetInsertGetterOnly')
    map <silent> <buffer> <LocalLeader>g <Plug>JavagetsetInsertGetterOnly
  endif
  noremap <buffer> <script> 
    \ <Plug>JavagetsetInsertGetterOnly
    \ <SID>InsertGetterOnly
  noremap <buffer> 
    \ <SID>InsertGetterOnly
    \ :call <SID>InsertGetterSetter('g')<CR>

  if !hasmapto('<Plug>JavagetsetInsertSetterOnly')
    map <silent> <buffer> <LocalLeader>s <Plug>JavagetsetInsertSetterOnly
  endif
  noremap <buffer> <script> 
    \ <Plug>JavagetsetInsertSetterOnly
    \ <SID>InsertSetterOnly
  noremap <buffer> 
    \ <SID>InsertSetterOnly
    \ :call <SID>InsertGetterSetter('s')<CR>

  if !hasmapto('<Plug>JavagetsetInsertBothGetterSetter')
    map <silent> <buffer> <LocalLeader>b <Plug>JavagetsetInsertBothGetterSetter
  endif
  noremap <buffer> <script> 
    \ <Plug>JavagetsetInsertBothGetterSetter
    \ <SID>InsertBothGetterSetter
  noremap <buffer> 
    \ <SID>InsertBothGetterSetter 
    \ :call <SID>InsertGetterSetter('b')<CR>
endif

" Add commands, unless already set.
if !exists(":InsertGetterSetter")
  command -range -buffer 
    \ InsertGetterSetter 
    \ :<line1>,<line2>call s:InsertGetterSetter('a')
endif
if !exists(":InsertGetterOnly")
  command -range -buffer 
    \ InsertGetterOnly
    \ :<line1>,<line2>call s:InsertGetterSetter('g')
endif
if !exists(":InsertSetterOnly")
  command -range -buffer 
    \ InsertSetterOnly
    \ :<line1>,<line2>call s:InsertGetterSetter('s')
endif
if !exists(":InsertBothGetterSetter")
  command -range -buffer 
    \ InsertBothGetterSetter
    \ :<line1>,<line2>call s:InsertGetterSetter('b')
endif

let &cpo = s:save_cpo

"if !exists("*s:InsertText")
"  function s:InsertText(text)
"    let pos = line('.')
"    let beg = 0
"    let len = stridx(a:text, "\n")
"
"    while beg < strlen(a:text)
"      if len == -1
"        call append(pos, s:indent . strpart(a:text, beg))
"        break
"      endif
"
"      call append(pos, s:indent . strpart(a:text, beg, len))
"      let pos = pos + 1
"      let beg = beg + len + 1
"      let len = stridx(strpart(a:text, beg), "\n")
"    endwhile
"
"    " Not too sure why I have to call redraw, but weirdo things appear
"    " on the screen if I don't.
"    redraw!
"
"  endfunction
"endif
"
"if !exists("*s:InsertAccessor")
"  function s:InsertAccessor()
"    echo "InsertAccessor was called"
"  endfunction
"endif
"
"if !exists("*s:SqueezeWhitespace")
"  function s:SqueezeWhitespace(string)
"      return substitute(a:string, '\_s\+', ' ', 'g')
"  endfunction
"endif
