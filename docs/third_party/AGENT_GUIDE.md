# Agent Guide: Third-Party Dependencies

任何 agent 修改第三方依赖时，必须遵守这个模型。目标不是让依赖接入最快，而是让 SDK/App 构建可复现、可审计、不会被本机环境悄悄改变。

## 硬规则

1. 第三方库只能固化在 `third_party/<library>/`。
2. 每个库必须有 `THIRD_PARTY.yml` 和一个 `<Lib>Package.cmake`。
3. CMake 业务 target 只能链接 `ScaffoldingCpp::ThirdParty::<Lib>`，不能直接 glob `third_party`、`libs`、`vcpkg_installed` 或系统 include/lib 目录。
4. 正常构建不能使用 vcpkg manifest 自动安装、`FetchContent`、`ExternalProject_Add` 或 `find_package()` 隐式发现生产依赖。
5. `category: foundation` 的库默认 `update_policy: frozen`。升级必须修改 metadata、artifact/source 和相关文档，不能只改一个版本号。
6. 依赖版本冲突时失败，不自动选择“更高版本”。

## vcpkg 的位置

vcpkg 可以作为“生产固化包的工具”，不能作为“正常构建时的依赖解析器”。如果确实需要用 vcpkg 生成二进制 artifact，应在维护流程中显式开启：

```bash
cmake -S . -B build-package -DSCAFFOLDING_CPP_ALLOW_VCPKG_TOOLCHAIN=ON
```

生成结果必须复制并记录到 `third_party/<library>/`，正常构建仍然从固化目录读取。

## 修改检查清单

- 是否新增或修改了 `THIRD_PARTY.yml`？
- 是否新增或修改了 `<Lib>Package.cmake`？
- 是否避免了自动下载、自动探测和隐式升级？
- 是否更新了 `dependencies` 并确认版本一致？
- 是否运行 `tools/third_party/validate-third-party.ps1`？
- 是否运行 CMake configure/build/test？
