;; General syntax
(ERROR) @error

(generic_command) @function
(caption
  command: _ @function)

(key_value_pair
  key: (_) @parameter
  value: (_))

[
 (line_comment)
 (block_comment)
 (comment_environment)
] @comment

[
 (brack_group)
 (brack_group_argc)
] @parameter

[(operator) "="] @operator

"\\item" @punctuation.special

((word) @punctuation.delimiter
(#eq? @punctuation.delimiter "&"))

["[" "]" "{" "}"] @punctuation.bracket ; "(" ")" has no syntactical meaning in LaTeX

;; General environments
(begin
 command: _ @text.environment
 name: (curly_group_text
         (text) @text.environment.name)
  (#not-any-of? @text.environment.name
      "displaymath" "displaymath*"
      "equation" "equation*"
      "multline" "multline*"
      "eqnarray" "eqnarray*"
      "align" "align*"
      "array" "array*"
      "split" "split*"
      "alignat" "alignat*"
      "gather" "gather*"
      "flalign" "flalign*"))

(end
 command: _ @text.environment
 name: (curly_group_text
         (text) @text.environment.name)
  (#not-any-of? @text.environment.name
      "displaymath" "displaymath*"
      "equation" "equation*"
      "multline" "multline*"
      "eqnarray" "eqnarray*"
      "align" "align*"
      "array" "array*"
      "split" "split*"
      "alignat" "alignat*"
      "gather" "gather*"
      "flalign" "flalign*"))

;; Definitions and references
(new_command_definition
 command: _ @function.macro
 declaration: (curly_group_command_name (_) @function))
(old_command_definition
 command: _ @function.macro
 declaration: (_) @function)
(let_command_definition
 command: _ @function.macro
 declaration: (_) @function)

(theorem_definition
 command: _ @function.macro
 name: (curly_group_text (_) @text.environment.name))

(label_definition
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))
(label_reference_range
 command: _ @function.macro
 from: (curly_group_text (_) @text.reference)
 to: (curly_group_text (_) @text.reference))
(label_reference
 command: _ @function.macro
 names: (curly_group_text_list (_) @text.reference))
(label_number
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference)
 number: (_) @text.reference)

(citation
 command: _ @function.macro
 keys: (curly_group_text_list) @text.reference)

(glossary_entry_definition
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))
(glossary_entry_reference
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))

(acronym_definition
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))
(acronym_reference
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))

(color_definition
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))
(color_reference
 command: _ @function.macro
 name: (curly_group_text (_) @text.reference))

;; Math
[
 (displayed_equation)
 (inline_formula)
] @text.math

((generic_environment
  (begin
   command: _ @text.math
   name: (curly_group_text
           (text) @_env))) @text.math
   (#any-of? @_env
      "displaymath" "displaymath*"
      "equation" "equation*"
      "multline" "multline*"
      "eqnarray" "eqnarray*"
      "align" "align*"
      "array" "array*"
      "split" "split*"
      "alignat" "alignat*"
      "gather" "gather*"
      "flalign" "flalign*"))
((generic_environment
  (end
   command: _ @text.math
   name: (curly_group_text
           (text) @_env))) @text.math
   (#any-of? @_env
      "displaymath" "displaymath*"
      "equation" "equation*"
      "multline" "multline*"
      "eqnarray" "eqnarray*"
      "align" "align*"
      "array" "array*"
      "split" "split*"
      "alignat" "alignat*"
      "gather" "gather*"
      "flalign" "flalign*"))

;; Sectioning
(chapter
  command: _ @namespace
  text: (curly_group) @text.title)

(part
  command: _ @namespace
  text: (curly_group) @text.title)

(section
  command: _ @namespace
  text: (curly_group) @text.title)

(subsection
  command: _ @namespace
  text: (curly_group) @text.title)

(subsubsection
  command: _ @namespace
  text: (curly_group) @text.title)

(paragraph
  command: _ @namespace
  text: (curly_group) @text.title)

(subparagraph
  command: _ @namespace
  text: (curly_group) @text.title)

;; Beamer frames
(generic_environment
  (begin
    name: (curly_group_text
            (text) @text.environment.name)
    (#any-of? @text.environment.name "frame"))
  .
  (curly_group (_) @text.title))

((generic_command
  command: (command_name) @_name
  arg: (curly_group
          (text) @text.title))
 (#eq? @_name "\\frametitle"))

;; Formatting
((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @text.emphasis))
  (#eq? @_name "\\emph"))

((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @text.emphasis))
  (#match? @_name "^(\\\\textit|\\\\mathit)$"))

((generic_command
  command: (command_name) @_name
  arg: (curly_group (_) @text.strong))
  (#match? @_name "^(\\\\textbf|\\\\mathbf)$"))

((generic_command
  command: (command_name) @_name
  .
  arg: (curly_group (_) @text.uri))
 (#match? @_name "^(\\\\url|\\\\href)$"))

;; File inclusion commands
(class_include
  command: _ @include
  path: (curly_group_path) @string)

(package_include
  command: _ @include
  paths: (curly_group_path_list) @string)

(latex_include
  command: _ @include
  path: (curly_group_path) @string)
(import_include
  command: _ @include
  directory: (curly_group_path) @string
  file: (curly_group_path) @string)

(bibtex_include
  command: _ @include
  path: (curly_group_path) @string)
(biblatex_include
  "\\addbibresource" @include
  glob: (curly_group_glob_pattern) @string.regex)

(graphics_include
  command: _ @include
  path: (curly_group_path) @string)
(tikz_library_import
  command: _ @include
  paths: (curly_group_path_list) @string)

