# Makefile Syntax

## Basic Structure

A Makefile rule has three parts:

```makefile
target: prerequisites
	recipe
```

- **target** — the file to build, or a phony action name
- **prerequisites** — files that must be up to date before the recipe runs
- **recipe** — shell commands to run (each line **must** start with a **tab**, not spaces)

```makefile
main.o: main.c utils.h
	gcc -c main.c -o main.o
```

## Variables

| Syntax | Expansion | Description |
| --- | --- | --- |
| `VAR = value` | Recursive (lazy) | Expanded each time `$(VAR)` is used |
| `VAR := value` | Immediate (eager) | Expanded once at assignment time |
| `VAR ?= value` | Default | Set only if `VAR` is not already defined |
| `VAR += more` | Append | Appends to existing value |

```makefile
CC      := gcc
CFLAGS  := -Wall -O2
SRCS    := $(wildcard src/*.c)
```

## Automatic Variables

| Variable | Meaning |
| --- | --- |
| `$@` | The target name |
| `$<` | The first prerequisite |
| `$^` | All prerequisites (deduplicated) |
| `$*` | The stem matched by `%` in a pattern rule |
| `$?` | Prerequisites newer than the target |

```makefile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```

## .PHONY Declaration

Declare targets that do not represent files to prevent conflicts with same-named files:

```makefile
.PHONY: all clean install test

all: myapp

clean:
	rm -f *.o myapp
```

## .DEFAULT_GOAL

Override which target runs when `make` is called with no arguments:

```makefile
.DEFAULT_GOAL := build

build: main.o
	$(CC) -o myapp main.o
```

## Multi-Line Variables

```makefile
define HELP_TEXT
Usage:
  make build   - compile the project
  make clean   - remove build artifacts
endef

help:
	@echo "$(HELP_TEXT)"
```
