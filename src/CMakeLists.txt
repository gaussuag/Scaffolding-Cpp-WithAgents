add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        ScaffoldingCpp::ThirdParty::ConcurrentQueue
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)
