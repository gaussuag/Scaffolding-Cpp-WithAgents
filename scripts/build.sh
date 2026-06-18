#!/bin/bash

set -euo pipefail

BUILD_DIR="build"
CONFIG="Debug"

clean() {
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        echo "Build directory cleaned."
    fi
}

configure() {
    cmake -S . -B "$BUILD_DIR"
}

build() {
    cmake --build "$BUILD_DIR" --config "$CONFIG"
}

test_project() {
    ctest --test-dir "$BUILD_DIR" --output-on-failure
}

case "${1:-build}" in
    clean)
        clean
        ;;
    configure)
        configure
        ;;
    test)
        test_project
        ;;
    build)
        configure
        build
        ;;
    all)
        configure
        build
        test_project
        ;;
    *)
        echo "Usage: $0 {clean|configure|build|test|all}"
        exit 1
        ;;
esac
