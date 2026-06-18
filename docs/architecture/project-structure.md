# 工程结构

本脚手架面向 SDK 和 Windows 客户端类项目，默认目标是：源码结构清晰、CMake target 可组合、第三方库版本可审计且不会隐式升级。

## 顶层模块

```text
src/                    应用或 SDK 示例入口
tests/                  单元测试
cmake/                  项目级 CMake helper
cmake/third_party/      第三方依赖策略和统一入口
third_party/            固化第三方包
tools/third_party/      第三方包校验和维护工具
docs/third_party/       第三方依赖治理文档
```

## Source Module

`src/` 只依赖 CMake target，不直接拼 include/lib 路径。示例程序当前链接：

```cmake
target_link_libraries(PlaygroundCpp
    PRIVATE
        ScaffoldingCpp::ThirdParty::ConcurrentQueue
)
```

这样生产代码只看到稳定 target，不关心依赖是源码、header-only 还是二进制 artifact。

## Test Module

`tests/` 通过 `ScaffoldingCpp::ThirdParty::GoogleTest` 接入 GoogleTest。GoogleTest 是测试依赖，只在 `BUILD_TESTING=ON` 时进入构建图。

## ThirdParty Package Module

每个第三方库是一个独立 package：

```text
third_party/<library>/
|-- THIRD_PARTY.yml
|-- <Lib>Package.cmake
`-- source/include/lib/bin/...
```

`THIRD_PARTY.yml` 是审计入口，`<Lib>Package.cmake` 是 CMake 唯一入口。生产 target 不允许从 `vcpkg.json`、系统路径或本机 installed 目录自动探测依赖。

## CMake Policy Module

`cmake/third_party/ThirdPartyPolicy.cmake` 负责统一策略：

- 正常构建禁用 vcpkg toolchain 和 manifest 自动解析。
- 记录项目默认 third-party triplet。
- 为后续依赖固化、feature gate 和 artifact 校验提供统一位置。

`cmake/third_party/ThirdPartyPackages.cmake` 负责 include 当前默认启用的第三方 package。
