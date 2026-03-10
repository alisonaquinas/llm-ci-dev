# Make Command Cookbook

## Basic Invocations

```bash
# Run the default target
make

# Run a specific named target
make build
make clean
make install
make all

# Dry run — print commands without executing
make -n
make --dry-run
```

## Parallelism

```bash
# Run 4 jobs in parallel
make -j4

# Use all available CPU cores
make -j$(nproc)      # Linux
make -j$(sysctl -n hw.logicalcpu)  # macOS
```

## Specifying Files and Directories

```bash
# Use a non-default Makefile
make -f GNUmakefile
make -f path/to/Makefile target

# Change to a directory before running
make -C src/
make -C build/ install
```

## Forcing and Debugging

```bash
# Force rebuild of all targets (ignore timestamps)
make -B
make --always-make

# Print the internal database (all rules and variables)
make --print-data-base
make -p

# Trace rule execution
make --trace
```

## Verbosity

```bash
# Suppress command echoing (make all output silent)
make -s
make --silent

# Enable verbose output (project-specific V variable)
make V=1

# Keep going after errors
make -k
make --keep-going
```

## Common Conventional Targets

```bash
make all        # build everything (usually the default)
make clean      # remove build artifacts
make install    # install built files to system paths
make uninstall  # remove installed files
make test       # run the test suite
make dist       # create a distribution archive
make check      # alias for test in many projects
```

## Variable Overrides on the Command Line

```bash
# Override a variable defined in the Makefile
make CC=clang
make PREFIX=/opt/myapp install
make CFLAGS="-O0 -g" build
```
