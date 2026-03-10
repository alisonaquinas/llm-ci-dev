# CMakeLists.txt Reference

## Minimum Required Boilerplate

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyApp VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
```

## add_executable and add_library

```cmake
# Executable
add_executable(myapp src/main.cpp src/utils.cpp)

# Static library
add_library(mylib STATIC src/mylib.cpp)

# Shared (dynamic) library
add_library(mylib SHARED src/mylib.cpp)

# Header-only interface library
add_library(headers INTERFACE)
target_include_directories(headers INTERFACE include/)
```

## target_link_libraries

```cmake
# Link myapp against mylib and the system math library
target_link_libraries(myapp PRIVATE mylib m)

# PUBLIC: propagates to consumers; PRIVATE: internal only; INTERFACE: consumers only
target_link_libraries(mylib PUBLIC fmt::fmt)
```

## target_include_directories

```cmake
target_include_directories(myapp
  PRIVATE   src/       # only myapp sees this
  PUBLIC    include/   # myapp and its consumers see this
)
```

## find_package

```cmake
# Find and link a system or installed package
find_package(OpenSSL REQUIRED)
target_link_libraries(myapp PRIVATE OpenSSL::SSL OpenSSL::Crypto)

# Optional package
find_package(Doxygen)
if(Doxygen_FOUND)
  doxygen_add_docs(docs src/)
endif()
```

## Variables and Options

```cmake
# Set a variable
set(MY_SOURCES src/a.cpp src/b.cpp)

# User-toggleable option (shows up in cmake-gui / -L output)
option(BUILD_TESTS "Build the test suite" ON)

# Cache variable with type hint
set(MY_PORT 8080 CACHE STRING "Port number for the server")
```

## install() Rules

```cmake
install(TARGETS myapp DESTINATION bin)
install(TARGETS mylib
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)
install(DIRECTORY include/ DESTINATION include)
install(FILES README.md DESTINATION share/doc/myapp)
```

## message() for Debugging

```cmake
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(WARNING "OpenSSL not found, TLS disabled")
message(FATAL_ERROR "Required dependency missing")
```

## Subdirectories

```cmake
# Bring in a subdirectory with its own CMakeLists.txt
add_subdirectory(libs/fmt)
add_subdirectory(tests)
```
