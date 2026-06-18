# Scaffolding C++ With Agents

这是一个用于 SDK 或 Windows 客户端开发的 CMake C++ 脚手架。当前版本把第三方依赖从 `libs/` 和 vcpkg 自动解析，收束为仓库内固化的 `third_party/<library>/` 包模型，优先保证可复现构建和依赖版本不可隐式升级。

## 目录结构

```text
Scaffolding-Cpp-WithAgents/
|-- CMakeLists.txt
|-- cmake/
|   |-- CompilerOptions.cmake
|   `-- third_party/
|       |-- ThirdPartyPolicy.cmake
|       `-- ThirdPartyPackages.cmake
|-- docs/
|   |-- architecture/project-structure.md
|   `-- third_party/
|       |-- AGENT_GUIDE.md
|       |-- workflow.md
|       `-- tools.md
|-- scripts/
|   |-- build.bat
|   |-- build.sh
|   `-- config.bat
|-- src/
|-- tests/
|-- third_party/
|   |-- README.md
|   |-- concurrentqueue/
|   `-- googletest/
`-- tools/third_party/validate-third-party.ps1
```

## 第三方依赖策略

- `third_party/<library>/` 是第三方依赖唯一固化目录。
- 每个库必须提供 `THIRD_PARTY.yml`，记录 `version`、`revision`、`features`、`triplets`、`crt_linkage`、`dependencies`、`artifacts` 和 `update_policy`。
- 每个库必须提供一个 `<Lib>Package.cmake`，导出 `ScaffoldingCpp::ThirdParty::<Lib>` target。
- 正常构建禁止通过 vcpkg manifest、系统目录或本机 installed 目录隐式解析生产依赖。
- `category: foundation` 且 `update_policy: frozen` 的依赖必须显式升级，依赖不满足时失败，不自动拉新版本。

## 当前固化依赖

- `concurrentqueue`：header-only，生产样例使用。
- `googletest`：测试依赖，仅在 `BUILD_TESTING=ON` 时接入。

## 构建

Windows:

```bat
scripts\build.bat
scripts\build.bat release
scripts\build.bat clean
```

Linux/macOS 或 Git Bash:

```bash
./scripts/build.sh all
```

手动 CMake:

```bash
cmake -S . -B build
cmake --build build --config Debug
ctest --test-dir build -C Debug --output-on-failure
```

## 校验第三方包结构

```powershell
.\tools\third_party\validate-third-party.ps1
```

这个校验只管理 `third_party/` 自己的 scope：metadata、package CMake 入口、artifact 路径、依赖版本一致性和 Git LFS 规则。它不会对仓库中其他业务目录做额外限制。

## 增加或升级第三方库

1. 在 `third_party/<library>/` 下放入固化源码、头文件或二进制 artifact。
2. 编写 `THIRD_PARTY.yml`，把版本、revision、features、triplet、CRT linkage、依赖和 artifact 清单写死。
3. 编写 `<Lib>Package.cmake`，只导出 `ScaffoldingCpp::ThirdParty::<Lib>` target，不做下载、探测或自动升级。
4. 在 `cmake/third_party/ThirdPartyPackages.cmake` 或需要该库的 feature gate 中 include 这个 package 文件。
5. 运行 `tools/third_party/validate-third-party.ps1` 和 CMake 构建。

详见 `docs/third_party/workflow.md`。
