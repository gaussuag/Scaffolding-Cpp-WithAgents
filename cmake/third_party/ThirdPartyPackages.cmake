include_guard(GLOBAL)

include("${CMAKE_CURRENT_LIST_DIR}/ThirdPartyPolicy.cmake")
scaffolding_cpp_configure_third_party_policy()

include("${CMAKE_SOURCE_DIR}/third_party/concurrentqueue/ConcurrentQueuePackage.cmake")
