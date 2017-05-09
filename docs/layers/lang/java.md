# [Layers](https://spacevim.org/layers) > lang#java

This layer is for Java development.

## Install

To use this configuration layer, add `SPLayer 'lang#java'` to your custom configuration file.


## Mappings

  Import mappings:

  Mode      Key           Function
  -------------------------------------------------------------
  normal    <F4>          import class under cursor
  insert    <F4>          import class under cursor
  normal    <leader>jI    import missing classes
  normal    <leader>jR    remove unused imports
  normal    <leader>ji    smart import class under cursor
  normal    <leader>jii   same as <F4>
  insert    <c-j>I        import missing imports
  insert    <c-j>R        remove unused imports
  insert    <c-j>i        smart import class under cursor
  insert    <c-j>ii       add import for class under cursor

  Generate mappings:

  Mode      Key           Function
  -------------------------------------------------------------
  normal    <leader>jA    generate accessors
  normal    <leader>js    generate setter accessor
  normal    <leader>jg    generate getter accessor
  normal    <leader>ja    generate setter and getter accessor
  normal    <leader>jts   generate toString function
  normal    <leader>jeq   generate equals and hashcode function
  normal    <leader>jc    generate constructor
  normal    <leader>jcc   generate default constructor
  insert    <c-j>s        generate setter accessor
  insert    <c-j>g        generate getter accessor
  insert    <c-j>a        generate getter and setter accessor
  visual    <leader>js    generate setter accessor
  visual    <leader>jg    generate getter accessor
  visual    <leader>ja    generate setter and getter accessor

## Code formatting

To make neoformat support java file, you should install uncrustify. or
download google's formater jar from:

https://github.com/google/google-java-format

and set 'g:spacevim_layer_lang_java_formatter' to the path of the jar.
