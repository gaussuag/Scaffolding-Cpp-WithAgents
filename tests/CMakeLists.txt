add_executable(${PROJECT_NAME}_tests 
    main_test.cpp
)

target_link_libraries(${PROJECT_NAME}_tests 
    gtest_main
    gmock
)

target_include_directories(${PROJECT_NAME}_tests
    PRIVATE
        ${CMAKE_SOURCE_DIR}/include
)

include(GoogleTest)
gtest_discover_tests(${PROJECT_NAME}_tests)
