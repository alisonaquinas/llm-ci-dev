# rvm Project Files

## .ruby-version

`.ruby-version` is the standard file for specifying the Ruby version for a project. rvm reads it automatically when entering a directory (if autoswitch is enabled).

```bash
# Write .ruby-version using rvm
rvm --ruby-version use 3.3.0@myapp

# Or write it manually
echo "3.3.0" > .ruby-version
echo "myapp" > .ruby-gemset
```

Commit `.ruby-version` (and optionally `.ruby-gemset`) to version control. Other tools such as rbenv and chruby also read `.ruby-version`, making it a cross-tool standard.

## .ruby-gemset

`.ruby-gemset` (rvm-specific) specifies the gemset to activate alongside `.ruby-version`:

```bash
echo "myapp" > .ruby-gemset
```

When both files exist, rvm activates the version + gemset combination on `cd`.

## .rvmrc (Legacy)

`.rvmrc` is the older rvm-specific project file. It is a shell script that rvm sources on `cd`. Because it executes arbitrary shell code, rvm requires explicit trust before loading it.

```bash
# Trust an .rvmrc in the current directory
rvm rvmrc trust

# Example .rvmrc content
rvm use 3.3.0@myapp --create
```

Prefer `.ruby-version` + `.ruby-gemset` over `.rvmrc` for new projects — they are safer, cross-tool compatible, and do not require per-machine trust grants.

## Autoswitch on cd

rvm installs a `cd` hook automatically. Verify it is active:

```bash
rvm autolibs status
```

To activate the hook manually if it was disabled:

```bash
rvm autoswitch enable
```

## Switching Version + Gemset Together

```bash
# Combine version and gemset in a single command
rvm use 3.3.0@myapp

# Create the gemset if it does not exist
rvm use --create 3.3.0@myapp

# Run a command in a specific version + gemset without switching permanently
rvm 3.3.0@myapp do bundle exec rake spec
```
