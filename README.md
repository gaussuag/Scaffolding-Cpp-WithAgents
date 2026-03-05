# PlaygroundCpp

C++ 项目模板，基于 CMake + GoogleTest

## 目录结构

```
PlaygroundCpp/
├── CMakeLists.txt          # 根 CMake 配置
├── cmake/                  # CMake 工具模块
├── src/                    # 源代码
├── include/                # 头文件
├── libs/                   # 第三方库 (手动管理)
│   └── googletest/         # 内置 GoogleTest
├── tests/                  # 测试代码
├── scripts/                # 构建脚本
│   ├── build.bat           # Windows
│   └── build.sh            # Linux/macOS
├── .gitignore
└── README.md
```

## 快速开始

### Windows (VS2022)

```batch
scripts\build.bat
```

运行程序:
```batch
build\Debug\PlaygroundCpp.exe
```

### Linux / macOS

```bash
chmod +x scripts/build.sh
./scripts/build.sh
```

运行程序:
```bash
./build/PlaygroundCpp
```

## 构建选项

### Windows

| 命令 | 说明 |
|------|------|
| `scripts\build.bat` | 构建项目 |
| `scripts\build.bat clean` | 清理构建目录 |

### Linux / macOS

| 命令 | 说明 |
|------|------|
| `./scripts/build.sh` | 构建项目 |
| `./scripts/build.sh clean` | 清理构建目录 |
| `./scripts/build.sh test` | 运行测试 |
| `./scripts/build.sh all` | 构建并测试 |

## 添加新代码

1. 源代码放 `src/`，头文件放 `include/`
2. 修改 `src/CMakeLists.txt` 添加源文件
3. 重新构建

## 添加测试

1. 测试代码放 `tests/`
2. 修改 `tests/CMakeLists.txt` 添加测试文件
3. 运行 `./scripts/build.sh test`

## 第三方库

将第三方库放入 `libs/` 目录，然后在对应模块的 `CMakeLists.txt` 中添加 `add_subdirectory()`。
