# Make Patterns and Functions

## Static Pattern Rules

Build multiple targets with a single rule using `%` as a stem wildcard:

```makefile
OBJS := main.o utils.o parser.o

# Pattern: each .o file depends on the corresponding .c file
$(OBJS): %.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```

## Implicit Rules

GNU Make has built-in rules for common file types. These activate automatically:

```makefile
# Built-in: %.o from %.c (uses CC, CFLAGS)
# Built-in: %.o from %.cpp (uses CXX, CXXFLAGS)
# Rely on them by listing the dependency without a recipe:
myapp: main.o utils.o
	$(CC) -o $@ $^
```

## Built-In Functions

### File and String Functions

```makefile
# Expand glob patterns
SRCS := $(wildcard src/*.c)

# Replace suffixes: .c → .o
OBJS := $(patsubst %.c,%.o,$(SRCS))

# Simple text substitution
MSG  := $(subst hello,world,hello there)

# Filter a list to matching pattern
C_FILES := $(filter %.c,$(SRCS) $(HDRS))

# Filter out matching items
NON_TESTS := $(filter-out test_%.c,$(SRCS))
```

### Shell Function

```makefile
# Capture command output into a variable
GIT_HASH := $(shell git rev-parse --short HEAD)
DATE     := $(shell date +%Y-%m-%d)
```

### foreach Function

```makefile
DIRS := src lib tests

# Run a command for each item
$(foreach dir,$(DIRS),$(info Processing $(dir)))

# Build a list of objects from multiple directories
OBJS := $(foreach dir,$(DIRS),$(patsubst %.c,%.o,$(wildcard $(dir)/*.c)))
```

## include Directive

Split large Makefiles into reusable fragments:

```makefile
include config.mk
include $(wildcard *.d)   # include all generated dependency files
-include optional.mk      # leading dash suppresses errors if file is missing
```

## override Directive

Force a variable value even if set on the command line:

```makefile
override CFLAGS += -Wall -Wextra
```

## MAKECMDGOALS

Access the targets specified on the command line:

```makefile
# Skip dependency generation if only cleaning
ifneq ($(MAKECMDGOALS),clean)
  -include $(DEPS)
endif
```

## Conditional Directives

```makefile
# ifeq: compare two values
ifeq ($(OS),Windows_NT)
  EXT := .exe
else
  EXT :=
endif

# ifdef: check if a variable is defined
ifdef DEBUG
  CFLAGS += -g -DDEBUG
endif
```
