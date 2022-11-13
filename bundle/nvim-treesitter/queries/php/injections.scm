(text) @html

(comment) @phpdoc

;; regex

((function_call_expression
  function: (_) @_preg_func_identifier
  arguments: (arguments . (argument (_ (string_value) @regex))))
    (#lua-match? @_preg_func_identifier "^preg_"))

;; bash

((function_call_expression
  function: (_) @_shell_func_identifier
  arguments: (arguments . (argument (_ (string_value) @bash))))
  (#any-of? @_shell_func_identifier "shell_exec" "escapeshellarg" 
   "escapeshellcmd" "exec" "passthru" "proc_open" "shell_exec" "system"))

((expression_statement (shell_command_expression (string_value) @bash)))
