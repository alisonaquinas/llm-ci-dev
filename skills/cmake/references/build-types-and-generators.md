# CMake Build Types and Generators

## CMAKE_BUILD_TYPE (Single-Config Generators)

| Value | Compiler Flags | Use Case |
| --- | --- | --- |
| `Debug` | `-g` (no optimization) | Local development, debugging |
| `Release` | `-O3 -DNDEBUG` | Production / distribution builds |
| `RelWithDebInfo` | `-O2 -g -DNDEBUG` | Profiling, crash analysis of optimized builds |
| `MinSizeRel` | `-Os -DNDEBUG` | Embedded, size-constrained targets |

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
```

`CMAKE_BUILD_TYPE` is **not** used by multi-config generators (see below).

## Single-Config Generators

One build type per build directory; set with `CMAKE_BUILD_TYPE` at configure time.

| Generator | Command | Notes |
| --- | --- | --- |
| Unix Makefiles | `cmake -G "Unix Makefiles"` | Default on Linux/macOS |
| Ninja | `cmake -G "Ninja"` | Faster than Make; recommended |
| NMake Makefiles | `cmake -G "NMake Makefiles"` | Windows MSVC nmake |

## Multi-Config Generators

Support all build types in a single build directory; select at build time with `--config`.

```bash
# Configure once
cmake -S . -B build -G "Ninja Multi-Config"

# Build different configurations from the same directory
cmake --build build --config Release
cmake --build build --config Debug
```

| Generator | Platform |
| --- | --- |
| Ninja Multi-Config | Cross-platform |
| Visual Studio 17 2022 | Windows |
| Xcode | macOS |

## Toolchain Files

Cross-compile or use a non-default compiler via a toolchain file:

```bash
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/arm-linux.cmake
```

Example toolchain file (`cmake/toolchains/arm-linux.cmake`):

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER   arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)
```

vcpkg integration also uses a toolchain file:

```bash
cmake -S . -B build -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake
```

## CMakePresets.json

Store reusable configurations in `CMakePresets.json` at the project root:

```json
{
  "version": 6,
  "configurePresets": [
    {
      "name": "release",
      "displayName": "Release",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/release",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Release"
      }
    },
    {
      "name": "debug",
      "displayName": "Debug",
      "generator": "Ninja",
      "binaryDir": "${sourceDir}/build/debug",
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug"
      }
    }
  ],
  "buildPresets": [
    { "name": "release", "configurePreset": "release" },
    { "name": "debug",   "configurePreset": "debug" }
  ]
}
```

```bash
cmake --preset release
cmake --build --preset release
```

## Cross-Compilation Basics

Key variables for cross-compilation:

```cmake
set(CMAKE_SYSTEM_NAME    Linux)      # target OS
set(CMAKE_SYSTEM_PROCESSOR aarch64) # target CPU
set(CMAKE_SYSROOT        /opt/sysroots/aarch64-linux)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
```
