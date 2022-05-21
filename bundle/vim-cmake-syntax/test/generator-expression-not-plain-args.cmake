# not the same highlighting for PUBLIC if simple argument or in generator expression
target_include_directories(target PUBLIC ${CMAKE_CURRENT_BINARY_DIR} $<GENERATOR_EXP PUBLIC>)
