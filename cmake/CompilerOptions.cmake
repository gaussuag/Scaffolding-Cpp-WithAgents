if(MSVC)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS _UNICODE UNICODE)
    
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDebug$<$<CONFIG:Debug>:D>$<$<CONFIG:Release>:>")
    
    string(APPEND CMAKE_CXX_FLAGS_DEBUG " /Od /Zi /MDd")
    string(APPEND CMAKE_CXX_FLAGS_RELEASE " /O2 /Zi /MD")
else()
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG " -g -O0")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE " -O3")
    endif()
endif()
