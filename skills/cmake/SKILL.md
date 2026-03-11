---
name: cmake
description: Configure and build C/C++ projects with CMake. Use when tasks mention cmake commands, CMakeLists.txt, build configuration, generators, or cross-platform C/C++ builds.
---

# CMake

## Intent Router

| Request | Reference | Load When |
| --- | --- | --- |
| Install tool, first-time setup | `references/install-and-setup.md` | Install or verify CMake |
| CMakeLists.txt, targets, find_package | `references/cmakelists.md` | Write or debug CMakeLists.txt |
| CLI commands, configure, build, test | `references/command-cookbook.md` | Run cmake or ctest commands |
| Build types, generators, presets | `references/build-types-and-generators.md` | Select build type or generator |

## Quick Start

```bash
# Configure (out-of-source — ALWAYS use -B, never cmake . in source root)
cmake -S . -B build

# Build
cmake --build build

# Run tests
ctest --test-dir build

# Install
cmake --install build --prefix /usr/local
```

## Core Command Tracks

- **Configure:** `cmake -S . -B build` — generates build system in `build/`
- **Set build type:** `cmake -S . -B build -DCMAKE_BUILD_TYPE=Release`
- **Build:** `cmake --build build` — invokes the underlying build tool
- **Specific target:** `cmake --build build --target <target>`
- **Test:** `ctest --test-dir build` — runs registered tests
- **Install:** `cmake --install build --prefix /usr/local`
- **Use preset:** `cmake --preset <name>` — reads from `CMakePresets.json`
- **List cache:** `cmake -L build` — show all cache variables

## Safety Guardrails

- **Always** build out-of-source using `-B build` — never run `cmake .` in the source root as it contaminates the source tree with generated files.
- Clean a build by deleting the `build/` directory; running `cmake --build build --clean-first` rebuilds without reconfiguring.
- Use `--dry-run` with install to preview what gets installed before committing.
- Commit `CMakePresets.json` for reproducible configurations, but add `build/` to `.gitignore`.
- Pin `cmake_minimum_required(VERSION X.Y)` to avoid behavior changes across CMake versions.

```bash
# Troubleshoot a broken build: clean and reconfigure with verbose output
rm -rf build
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build --verbose 2>&1 | tail -20
```

## Related Skills

- **make** — GNU Make, often the underlying build tool used by CMake's Unix Makefiles generator
- **ci-architecture** — integrating CMake builds into CI/CD pipelines

## References

- `references/install-and-setup.md`
- `references/cmakelists.md`
- `references/command-cookbook.md`
- `references/build-types-and-generators.md`
- Official docs: <https://cmake.org/cmake/help/latest/>
- CMake tutorial: <https://cmake.org/cmake/help/latest/guide/tutorial/index.html>
- CMakePresets reference: <https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html>
