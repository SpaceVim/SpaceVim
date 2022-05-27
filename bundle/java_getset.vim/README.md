java_getset.vim
===============

Vim file type plugin for the creation of Java getters and setters. 
This code was written in 2002 and I've not programmed in Java for 
about the same amount of time. However, I post the code here for 
anyone interested.

## Description
This filetype plugin enables a user to automatically add getter/setter 
methods for Java properties.  The script will insert a getter, setter, 
or both depending on the command/mapping invoked.  Users can select 
properties one at a time, or in bulk (via a visual block or specifying a 
range).  In either case, the selected block may include comments as they 
will be ignored during the parsing.  For example, you could select all 
of these properties with a single visual block. 

```
public class Test 
{ 
   // Start your selection here 
   private static int count; 

   /** The name */ 
   private String name; 

   /** The array of addresses */ 
   private String[] address; 
   // End your selection here 

   public static void main(String[] args) 
   { 
   } 
}
```

The script will also add the `static` modifier to the method if the 
property was declared as `static`.  Array-based properties will get 
additional methods added to support indexing.  In addition, if a 
property is declared `final`, it will not generate a setter for it. 
If a previous getter OR setter exists for a property, the script will 
not add any methods (under the assumption that you've manually added 
your own). 

The getters/setters that are inserted can be configured by the user. 
First, the insertion point can be selected.  It can be one of the 
following: before the current line / block, after the current line / 
block, or at the end of the class (default).  Finally, the text that is 
inserted can be configured by defining your own templates.  This allows 
the user to format for his/her coding style.  For example, the default 
value for `s:javagetset_getterTemplate` is: 

```
    /** 
     * Get %varname%. 
     * 
     * @return %varname% as %type%. 
     */ 
    %modifiers% %type% %funcname%() 
    {   
        return %varname%; 
    } 
```

Where the items surrounded by `%` are parameters that are substituted when 
the script is invoked on a particular property.  For more information on 
configuration, please see the section below on the INTERFACE. 

## Installation

1. Download the script from Vim's script [repository] or from this
   repository.

1. Copy the script to your `${HOME}/.vim/ftplugins` directory and make 
   sure its named `java_getset.vim` or `java_something.vim` where 
   `something` can be anything you want. 

2. (Optional) Customize the mapping and/or templates.  You can create 
   your own filetype plugin (just make sure its loaded before this one) 
   and set the variables in there (i.e. `${HOME}/.vim/ftplugin/java.vim`) 

[repository]: http://www.vim.org/scripts/script.php?script_id=490

## Interface

The following section documents the commands, mappings, and variables 
used to customize the behavior of this script. 

### Commands

`:InsertGetterSetter`
Inserts a getter/setter for the property on the current line, or 
the range of properties specified via a visual block or x,y range 
notation.  The user is prompted to determine what type of method 
to insert. 
   
`:InsertGetterOnly`
Inserts a getter for the property on the current line, or the 
range of properties specified via a visual block or x,y range 
notation.  The user is not prompted. 
   
`:InsertSetterOnly`
Inserts a setter for the property on the current line, or the 
range of properties specified via a visual block or x,y range 
notation.  The user is not prompted. 
   
`:InsertBothGetterSetter`
Inserts a getter and setter for the property on the current line, 
or the range of properties specified via a visual block or x,y 
range notation.  The user is not prompted. 

### Mappings

The following mappings are pre-defined.  You can disable the mappings 
by setting a variable (see the Variables section below).  The default 
key mappings use the `<LocalLeader>` which is the backslash key by 
default ''.  This can also be configured via a variable (see below). 
   
`<LocalLeader>p` (or `<Plug>JavagetsetInsertGetterSetter`) 
Inserts a getter/setter for the property on the current line, or 
the range of properties specified via a visual block.  User is 
prompted for choice. 
   
`<LocalLeader>g` (or `<Plug>JavagetsetInsertGetterOnly`)
Inserts a getter for the property on the current line, or the 
range of properties specified via a visual block.  User is not 
prompted. 
   
`<LocalLeader>s` (or `<Plug>JavagetsetInsertSetterOnly`)
Inserts a getter for the property on the current line, or the 
range of properties specified via a visual block.  User is not 
prompted. 
   
`<LocalLeader>b` (or `<Plug>JavagetsetInsertBothGetterSetter`) 
Inserts both a getter and setter for the property on the current 
line, or the range of properties specified via a visual block. 
User is not prompted. 
   
If you want to define your own mapping, you can map whatever you want 
to `<Plug>JavagetsetInsertGetterSetter` (or any of the other `<Plug>`s 
defined above).  For example, 

```
      map <buffer> <C-p> <Plug>JavagetsetInsertGetterSetter 
```

When you define your own mapping, the default mapping does not get 
set, only the mapping you specify. 

### Variables

The following variables allow you to customize the behavior of this 
script so that you do not need to make changes directly to the script. 
These variables can be set in your vimrc. 
   
`no_plugin_maps` 
Setting this variable will disable all key mappings defined by any 
of your plugins (if the plugin writer adhered to the standard 
convention documented in the scripting section of the VIM manual) 
including this one. 
   
`no_java_maps`
Setting this variable will disable all key mappings defined by any 
java specific plugin including this one. 
   
`maplocalleader`
By default, the key mappings defined by this script use 
`<LocalLeader>` which is the backslash character by default.  You can 
change this by setting this variable to a different key.  For 
example, if you want to use the comma-key, you can add this line to 
your vimrc: 

```         
        let maplocalleader = ',' 
```
   
`b:javagetset_insertPosition`
This variable determines the location where the getter and/or setter 
will be inserted.  Currently, three positions have been defined: 

```
        0 - insert at the end of the class (default) 
        1 - insert before the current line / block 
        2 - insert after the current line / block 
```

`b:javagetset_getterTemplate`,
`b:javagetset_setterTemplate`,
`b:javagetset_getterArrayTemplate`,
`b:javagetset_setterArrayTemplate`
These variables determine the text that will be inserted for a getter,
setter, array-based getter, and array-based setter respectively.  The
templates may contain the following placeholders which will be
substituted by their appropriate values at insertion time:

```         
        %type%          Java type of the property 
        %varname%       The name of the property 
        %funcname%      The method name ("getXzy" or "setXzy") 
        %modifiers%     "public" followed by "static" if the property is static 
```
     
For example, if you wanted to set the default getter template so that
it would produce the following block of code for a property defined as
`public static String name`:

```         
        /** 
         * Get name. 
         * @return name as String 
         */ 
        public static String getName() { return name; } 
```
     
This block of code can be produced by adding the following variable 
definition to your vimrc file. 

```         
        let b:javagetset_getterTemplate = 
          \ "\n" . 
          \ "/**\n" . 
          \ " * Get %varname%.\n" . 
          \ " * @return %varname% as %type%.\n" . 
          \ " */\n" . 
          \ "%modifiers% %type% %funcname%() { return %varname%; }" 
```

The defaults for these variables are defined in the script.  For both
the getterTemplate and setterTemplate, there is a corresponding
array-baded template that is invoked if a property is array-based.
This allows you to set indexed-based getters/setters if you desire.
This is the default behavior.
