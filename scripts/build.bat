@echo off
setlocal

set "BUILD_DIR=build"
set "GENERATOR=Visual Studio 17 2022"

if "%1"=="clean" (
    if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
    echo Build directory cleaned.
    exit /b 0
)

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

cmake -S . -B "%BUILD_DIR%" -G "%GENERATOR%"
if errorlevel 1 (
    echo CMake configuration failed!
    exit /b 1
)

cmake --build "%BUILD_DIR%" --config Debug
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo.
echo Build succeeded!
