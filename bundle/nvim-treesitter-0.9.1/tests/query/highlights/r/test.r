init <- 1
# ^ @variable
#     ^ @operator
#       ^ @float

r"{(\1\2)}" -> `%r%`
#  ^ @string
#    ^ @string.escape
#           ^ @operator
#               ^ @variable


foo <- c(1L, 2L)
#      ^ @function.call
#        ^ @number

b <- list(TRUE, FALSE, NA, Inf)
#          ^ @boolean
#                ^ @boolean
#                      ^ @constant.builtin
#                           ^ @constant.builtin

b <- list(name = "r", version = R.version$major)
#          ^ @parameter
#                 ^ @string
#                                        ^ @operator
#                                           ^ @field

Lang$new(name = "r")$print()
#     ^ @method.call

for(i in 1:10) {
# <- @repeat
#      ^ @repeat
}

add <- function(a, b = 1, ...) {
#        ^ @keyword.function
#               ^ @parameter
#                  ^ @parameter
#                         ^ @keyword
  return(a + b)
}

base::letters
# ^ @namespace
#        ^ @variable
