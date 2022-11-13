(module) @indent
(submodule) @indent
(statement) @indent
(extension_statement) @indent
(statement ";" @indent_end)
(extension_statement ";" @indent_end)
(block "}" @indent_end @branch)

((string) @aligned_indent
 (#set! "delimiter" "\"\""))
