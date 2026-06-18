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

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/CompilerOptions.cmake")
include(CTest)
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/third_party/ThirdPartyPackages.cmake")

if(BUILD_TESTING)
    include("${CMAKE_CURRENT_SOURCE_DIR}/third_party/googletest/GoogleTestPackage.cmake")
endif()

add_subdirectory(src)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
