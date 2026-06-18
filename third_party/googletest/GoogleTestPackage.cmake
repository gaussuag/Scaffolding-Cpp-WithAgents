include_guard(GLOBAL)

set(_scaffolding_googletest_root "${CMAKE_CURRENT_LIST_DIR}")
set(_scaffolding_googletest_source_dir "${_scaffolding_googletest_root}/source")

if(NOT EXISTS "${_scaffolding_googletest_source_dir}/CMakeLists.txt")
    message(FATAL_ERROR "GoogleTest frozen source package is incomplete: missing source/CMakeLists.txt")
endif()

set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
set(BUILD_GMOCK ON CACHE BOOL "" FORCE)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

if(NOT TARGET gtest_main)
    add_subdirectory("${_scaffolding_googletest_source_dir}" "${CMAKE_BINARY_DIR}/third_party/googletest" EXCLUDE_FROM_ALL)
endif()

if(NOT TARGET ScaffoldingCppThirdPartyGoogleTest)
    add_library(ScaffoldingCppThirdPartyGoogleTest INTERFACE)
    target_link_libraries(ScaffoldingCppThirdPartyGoogleTest
        INTERFACE
            gtest_main
            gmock
    )
endif()

if(NOT TARGET ScaffoldingCpp::ThirdParty::GoogleTest)
    add_library(ScaffoldingCpp::ThirdParty::GoogleTest ALIAS ScaffoldingCppThirdPartyGoogleTest)
endif()
