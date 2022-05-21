project(vim-cmake-syntax-test)

cmake_minimum_required(VERSION 3.2)

macro(test TESTNAME)
    add_test(NAME ${TESTNAME}
        COMMAND ./run-test.sh ${TESTNAME}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
endmacro()

file(GLOB TESTS *.cmake)

enable_testing()

foreach(TEST IN LISTS TESTS)
    get_filename_component(TESTNAME ${TEST} NAME_WE)
    test(${TESTNAME})
endforeach()
