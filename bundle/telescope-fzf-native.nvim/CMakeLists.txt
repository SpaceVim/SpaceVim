cmake_minimum_required(VERSION 3.2)
project(fzf C)

add_library(${PROJECT_NAME} SHARED "src/fzf.c")

set_target_properties(${PROJECT_NAME} PROPERTIES
    PREFIX "lib"
    C_STANDARD 99
    WINDOWS_EXPORT_ALL_SYMBOLS ON
)

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

if (CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else ()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall)
endif ()

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_BINARY_DIR})
