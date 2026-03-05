cmake_minimum_required(VERSION 3.16)
project(PlaygroundCpp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(MSVC)
    add_compile_options(/utf-8 /W4 /permissive-)
else()
    add_compile_options(-Wall -Wextra -pedantic)
endif()

include(cmake/CompilerOptions.cmake)

enable_testing()

add_subdirectory(src)
add_subdirectory(tests)

#### AUTO-Generated: libs start ####
if(EXISTS ${CMAKE_SOURCE_DIR}/libs/googletest/CMakeLists.txt)
    add_subdirectory(libs/googletest)
endif()
#### AUTO-Generated: libs end ####
