add_executable(${PROJECT_NAME}_tests
    main_test.cpp
)

target_link_libraries(${PROJECT_NAME}_tests
    PRIVATE
        ScaffoldingCpp::ThirdParty::ConcurrentQueue
        ScaffoldingCpp::ThirdParty::GoogleTest
)

include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME}_tests)
