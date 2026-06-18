# Legacy vcpkg 自动依赖模型退役说明

这个文档保留旧脚手架的历史背景：早期模板通过 `vcpkg.json`、`VcpkgDeps.cmake` 和本机 `vcpkg_installed` 目录自动解析依赖。这个方式对 demo 很方便，但不适合作为 SDK/App 的默认依赖治理模型。

主要问题：

- 依赖版本可能随本机 vcpkg registry 或 installed 状态变化。
- Debug/Release、CRT、triplet、DLL 拷贝策略容易被本机环境影响。
- CMake target 不完整时，脚本会退化为 glob 搜索 `.lib`，这会放大隐式链接风险。
- SDK 交付需要可审计的第三方版本和 artifact 清单，而不是构建时动态解析。

当前方案：

- 正常构建不再启用 vcpkg manifest 自动安装。
- 第三方依赖固化在 `third_party/<library>/`。
- 每个依赖用 `THIRD_PARTY.yml` 记录版本、revision、features、triplet、CRT linkage、依赖和 artifact。
- 每个依赖只通过 `<Lib>Package.cmake` 导出 `ScaffoldingCpp::ThirdParty::<Lib>` target。
- vcpkg 只允许作为维护人员生成固化 artifact 的工具，不能作为生产构建时的隐式依赖来源。

相关文档：

- `docs/architecture/project-structure.md`
- `docs/third_party/AGENT_GUIDE.md`
- `docs/third_party/workflow.md`
- `docs/third_party/tools.md`
