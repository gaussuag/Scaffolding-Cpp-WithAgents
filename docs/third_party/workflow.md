# Third-Party Workflow

## 新增依赖

1. 建目录：`third_party/<library>/`。
2. 放入固化内容：
   - header-only：通常放 `include/`。
   - 源码依赖：通常放 `source/`。
   - 二进制依赖：按 `include/`、`lib/<triplet>/<config>/`、`bin/<triplet>/<config>/` 组织。
3. 写 `THIRD_PARTY.yml`。
4. 写 `<Lib>Package.cmake`，导出 `ScaffoldingCpp::ThirdParty::<Lib>`。
5. 在需要的位置 include 这个 package 文件。
6. 运行校验和构建。

## Metadata Contract

`THIRD_PARTY.yml` 必须包含：

```yaml
name: <directory-name>
display_name: <human-readable-name>
version: "<pinned-version>"
revision: "<commit/tag/build-revision>"
category: foundation
update_policy: frozen
source:
  provider: vendored-source
  url: "https://example.invalid/upstream"
license:
  name: "<license>"
  file: "LICENSE"
triplets:
  - x64-windows
crt_linkage: dynamic
features: []
dependencies: []
artifacts: []
```

`dependencies` 用来声明依赖的其他 frozen package。依赖版本必须和目标 package 的 `version` 一致，否则校验失败。

`artifacts` 用来声明需要存在的固化产物。header-only 或源码依赖可以为空数组。

## CMake Package Contract

`<Lib>Package.cmake` 只做三件事：

1. 检查固化文件是否存在。
2. 创建内部 target。
3. 导出 `ScaffoldingCpp::ThirdParty::<Lib>` alias target。

不要在 package 文件里做：

- `FetchContent` 下载。
- `ExternalProject_Add` 构建。
- `find_package()` 探测系统或 vcpkg 包。
- 从 `vcpkg_installed`、`Program Files`、用户目录等环境路径找依赖。

## 升级依赖

1. 在独立变更中完成升级。
2. 更新固化源码或 artifact。
3. 更新 `version`、`revision`、`features`、`artifacts` 和 license 信息。
4. 检查依赖它的 package 是否需要同步版本。
5. 运行校验和完整构建测试。
6. 在提交说明中写清楚升级原因和兼容性风险。
