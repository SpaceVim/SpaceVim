(module) @indent.begin
(submodule) @indent.begin
(statement) @indent.begin
(extension_statement) @indent.begin
(statement ";" @indent.end)
(extension_statement ";" @indent.end)
(block "}" @indent.end @indent.branch)

((string) @indent.align
 (#set! indent.open_delimiter "\"")
 (#set! indent.close_delimiter "\""))
