include_guard(GLOBAL)

option(SCAFFOLDING_CPP_ALLOW_VCPKG_TOOLCHAIN "Allow explicit vcpkg toolchain use for third-party package production work." OFF)

set(SCAFFOLDING_CPP_THIRD_PARTY_TRIPLET "x64-windows" CACHE STRING "Pinned third-party package triplet for this scaffold.")
set_property(CACHE SCAFFOLDING_CPP_THIRD_PARTY_TRIPLET PROPERTY STRINGS
    x64-windows
    x64-windows-static
    x86-windows
    x86-windows-static
)

function(scaffolding_cpp_fail_if_implicit_vcpkg)
    if(SCAFFOLDING_CPP_ALLOW_VCPKG_TOOLCHAIN)
        return()
    endif()

    if(DEFINED CMAKE_TOOLCHAIN_FILE AND NOT CMAKE_TOOLCHAIN_FILE STREQUAL "")
        string(REPLACE "\\" "/" _toolchain "${CMAKE_TOOLCHAIN_FILE}")
        string(TOLOWER "${_toolchain}" _toolchain_lower)
        if(_toolchain_lower MATCHES "/vcpkg\.cmake$")
            message(FATAL_ERROR
                "Implicit vcpkg dependency resolution is disabled for normal builds. "
                "Freeze third-party outputs under third_party/<library>/ and expose them via a package CMake file. "
                "Use -DSCAFFOLDING_CPP_ALLOW_VCPKG_TOOLCHAIN=ON only while producing or refreshing frozen packages."
            )
        endif()
    endif()

    if(DEFINED VCPKG_MANIFEST_MODE AND VCPKG_MANIFEST_MODE)
        message(FATAL_ERROR
            "VCPKG_MANIFEST_MODE is disabled for normal builds. Keep production dependencies frozen under third_party/."
        )
    endif()
endfunction()

function(scaffolding_cpp_configure_third_party_policy)
    scaffolding_cpp_fail_if_implicit_vcpkg()

    set(SCAFFOLDING_CPP_THIRD_PARTY_ROOT
        "${CMAKE_SOURCE_DIR}/third_party"
        CACHE PATH
        "Root directory for frozen third-party packages."
        FORCE
    )
endfunction()
