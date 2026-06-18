include_guard(GLOBAL)

set(_scaffolding_concurrentqueue_root "${CMAKE_CURRENT_LIST_DIR}")
set(_scaffolding_concurrentqueue_include_dir "${_scaffolding_concurrentqueue_root}/include")

if(NOT EXISTS "${_scaffolding_concurrentqueue_include_dir}/concurrentqueue/concurrentqueue.h")
    message(FATAL_ERROR "ConcurrentQueue frozen package is incomplete: missing include/concurrentqueue/concurrentqueue.h")
endif()

if(NOT TARGET ScaffoldingCppThirdPartyConcurrentQueue)
    add_library(ScaffoldingCppThirdPartyConcurrentQueue INTERFACE)
    target_include_directories(ScaffoldingCppThirdPartyConcurrentQueue
        INTERFACE
            "${_scaffolding_concurrentqueue_include_dir}"
    )
endif()

if(NOT TARGET ScaffoldingCpp::ThirdParty::ConcurrentQueue)
    add_library(ScaffoldingCpp::ThirdParty::ConcurrentQueue ALIAS ScaffoldingCppThirdPartyConcurrentQueue)
endif()
