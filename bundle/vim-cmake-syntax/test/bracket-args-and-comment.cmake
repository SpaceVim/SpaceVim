message(FATAL_ERROR [[
This is the first line in a bracket argument with bracket length 1.
No \-escape sequences or ${variable} references are evaluated.
This is always one argument even though it contains a ; character.
It does end in a closing bracket of length 1.
]])

message(FATAL_ERROR [=[
This is the first line in a bracket argument with bracket length 1.
No \-escape sequences or ${variable} references are evaluated.
This is always one argument even though it contains a ; character.
The text does not end on a closing bracket of length 0 like ]].
It does end in a closing bracket of length 1.
]=])

message(FATAL_ERROR [=123[
This is the first line in a bracket argument with bracket length 1.
No \-escape sequences or ${variable} references are evaluated.
This is always one argument even though it contains a ; character.
The text does not end on a closing bracket of length 0 like ]].
It does end in a closing bracket of length 1.
]=123])

[[ # this will make a cmake-error but defines a bracket-arguemnt
cmake_minimum_required(VERSION 4.0 FATAL_ERROR) # Should be string-colored
]]

#[[
cmake_minimum_required(VERSION 4.0 FATAL_ERROR) # Should be greyed out
]] target_link_libraries(t lib)

#[[
cmake_minimum_required(VERSION 4.0 FATAL_ERROR) # Should be greyed out
#]] target_link_libraries(t lib)

# commented bracket-comment
##[[
cmake_minimum_required(VERSION 4.0 FATAL_ERROR) # Should not be greyed out
#]]

#[[This is a bracket comment.
It runs until the close bracket.]]

message("First Argument\n" #[[Bracket Comment]] "Second Argument")

#[=12[
comment
]=12]

