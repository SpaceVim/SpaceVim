[
 (assign_block "{")
 (object)
 (array)
] @indent.begin

(assign_block "}" @indent.branch)
(assign_block "}" @indent.end)

(object "}" @indent.branch)
(object "}" @indent.end)

(array "]" @indent.branch)
(array "]" @indent.end)
