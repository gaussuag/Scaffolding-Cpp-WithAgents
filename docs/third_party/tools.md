# Third-Party Tools

## validate-third-party.ps1

```powershell
.\tools\third_party\validate-third-party.ps1
```

校验内容：

- `third_party/` 是否存在。
- 每个 package 是否包含 `THIRD_PARTY.yml`。
- metadata 必填字段是否完整。
- `name` 是否和目录名一致。
- `category: foundation` 是否使用 `update_policy: frozen`。
- 每个 package 是否只有一个 `<Lib>Package.cmake`。
- package CMake 是否导出 `ScaffoldingCpp::ThirdParty::<Lib>` target。
- package CMake 是否避免 `FetchContent`、`ExternalProject_Add` 和 `find_package()` 隐式发现。
- artifact path 是否存在且没有逃出当前 package 目录。
- package 之间声明的依赖版本是否一致。
- `.gitattributes` 是否允许 `third_party/**/*.lib/.dll/.exe/.pdb` 走 Git LFS。

这个工具只约束 `third_party/` 自己的 scope，不负责禁止业务目录名，也不会因为仓库中出现其他目录而失败。
