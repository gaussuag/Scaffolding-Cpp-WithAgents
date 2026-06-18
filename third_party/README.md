# third_party

`third_party/<library>/` 是本项目第三方依赖的唯一固化目录。正常构建不从 vcpkg manifest、系统安装目录或本机临时 installed 目录隐式解析生产依赖。

每个第三方库必须至少包含：

- `THIRD_PARTY.yml`：固化版本、revision、features、triplets、CRT linkage、依赖关系、artifact 清单和升级策略。
- `<Lib>Package.cmake`：唯一 CMake 接入入口，导出 `ScaffoldingCpp::ThirdParty::<Lib>` imported/interface target。
- 固化源码、头文件或二进制 artifact：放在该库自己的目录内。

当前已固化：

- `concurrentqueue`：header-only，导出 `ScaffoldingCpp::ThirdParty::ConcurrentQueue`。
- `googletest`：测试依赖，导出 `ScaffoldingCpp::ThirdParty::GoogleTest`。

更多规则见 `docs/third_party/`。
