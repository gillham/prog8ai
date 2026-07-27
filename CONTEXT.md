# Agent context

## Prog8 language overview

The Prog8 compiler and its source code is a submodule in the `.prog8compiler`
directory off the root of this repository. The compiler is written in Kotlin
and JAVA, but we are  only interested in the Prog8 and 6502 assembler 
portions of the repository.  It is wrong to attempt to use Kotlin or JAVA
examples or source code when developing Prog8 or 6502 assembler programs.

The syntax of the Prog8 language is documented in an ANTLR4 grammar file.
Read `.prog8compiler/parser/src/main/antlr/Prog8ANTLR.g4` to understand the
Prog8 grammar.

There is documentation in `.prog8compiler/docs/source` and here is a
table of the most relevant files to view:
|Filename|
|--------|
|`compiling.rst`|
|`libraries.rst`|
|`programming.rst`|
|`structpointers.rst`|
|`targetsystem.rst`|
|`variables.rst`|


## Agent skills

The author of the Prog8 compiler has created agent skill files for writing
software with Prog8 and 6502 assembler.  Please read the two files below
to understand these skills.  Note that any file references in the skills
files would be relative to the `.prog8compiler` directory since it is a
submodule.

```
.prog8compiler/.agents/skills/prog8-coder/SKILL.md
.prog8compiler/.agents/skills/asm6502-coder/SKILL.md
```

## Prog8 context files

This table will have context files with a status of stub, partial, or done.
These files must only add what the upstream skills don't already cover.
NOTE: Ignore files with the status of "stub" as they are useless.

| Filename                       |Status|Description|
|--------------------------------|------|-----------|
| `.context/asm-integration.md`  |stub|6502 assembly integration|
| `.context/emulators.md`        |stub|emulator integration|
| `.context/errors.md`           |stub|Common errors in Prog8 coding|
| `.context/examples.md`         |stub|Examples of Prog8 coding|
| `.context/gotchas.md`          |stub|Common gotchas in Prog8 coding|
| `.context/hardware-summary.md` |stub|Hardware summaries for Prog8 targets|
| `.context/modules.md`          |stub|Prog8 standard library modules and their use|
| `.context/patterns.md`         |stub|Prog8 coding patterns and best practices|
| `.context/versions.md`         |stub|Prog8 compiler versions and their features|

### Finding context
- When using `grep` to look at context files in `.prog8compiler`
  you need to add `--include=*.p8` to limit the searches to only
  Prog8 source code.
- Never search these directories for files (unless given a specific filename):
  - `.prog8compiler/compiler/src`
  - `.prog8compiler/codeCore`
  - `.prog8compiler/codeGen*`
  - `.prog8compiler/intermediate`
  - `.prog8compiler/parser/` (Except for parser/src/main/antlr/Prog8ANTLR.g4)

## Prog8 compiler versions

Since features are added or regressions might occur in newer versions of the
compiler it is important to check the `prog8c` compiler version against the
git commit of the `.prog8compiler` upstream repository submodule.

At the start of a session you can run these two commands and compare the 
versions:
```
prog8c -version
git -C .prog8compiler rev-parse --short HEAD
```

Compare the git commits and if they don't match you should warn the
user, but you can continue working. You can ask if they want to
run `git submodule update --recursive` but this should only be once
per session not everytime.

## Prog8 standard library code

The source code to the Prog8 standard library for the common modules
and per target modules are in: `.prog8compiler/compiler/res/prog8lib/`.

The Prog8 standard library can be searched using the `prog8c` command
with the `-libsearch` argument which takes a regex in quotes.
Example:
`prog8c -libsearch 'sub\s+print'` searches for any subroutines starting
with `print`
`prog8c -libsearch 'txt\.print_ub'` searches for actual uses of the
`txt.print_ub` subroutine.
`prog8c -libsearch 'sub\s+print\('` looks specifically for the
subroutine `print` but might not find all instances on the different targets.
`prog8c -libsearch 'sub\s+print\s?\('` looks specifically for the
subroutine `print` which could have whitespace after it prior to the '('.

The `prog8c -libsearch` command should be the preferred way to search
the standard library, but see the `-libdump` argument below for a less
efficient option.

The standard library source code can be dumped by the compiler binary
as well by running it with the `-libdump build/` argument.  This allows getting
the example standard library source code for the compiler you will run.
The source code in `.prog8compiler` is likely to be slightly different from
the version `prog8c` will use, but it will be close enough most of the time.

After we run the command `prog8c -libdump build/` there will be a directory in
`build/` with the standard library source code.
Find it by running: `ls -d build/prog8lib-*`

If a different version of the compiler is run you could end up with multiple
directories in `build/` that match. An explicit `make clean` should be run
before running `prog8c -libdump build/` if using a different version.

The results from `prog8c -libsearch` and `prog8c -libdump` should be trusted over
source code from the `.prog8compiler` directory which might be out of date or
not match the `prog8c` binary being used.

When using versions of `prog8c` older than v12.2, warn the user and ask if they
want to proceed with the older version of the compiler.


## Prog8 sample code
- `.prog8compiler/examples/`
- `.prog8compiler/benchmark-program/`
- `.prog8compiler/compiler/test/arithmetic/`
- `.prog8compiler/compiler/test/comparisons/`
- `.prog8compiler/compiler/test/fixtures/`

## Syntax checking Prog8 source

You can run `make check` to have the compiler perform a syntax check of the
source code without attempting to compile it.  This quickly gives feedback
on source code changes.

## Testing Prog8 source code changes

You can run `make test` to compile the source code against the virtual
machine target and compare its output against expected results. Obviously
as software features are written, additional files in `tests/expected` would
need to be added and the test target in `Makefile` adjusted to account for it.

The test target works by compiling for the virtual target and then
running `prog8c` with the `-emu` argument which executes the code
in a virtual machine. This virtual machine outputs to stdout in the terminal
which is why the test works.  Also it demonstrates using `-plaintext` to 
avoid any ANSI sequences and using `-quiet` to avoid compiler messages.

This allows the normal standard output of the command to be evaluated with
normal Unix style pipeline commands.

Ask before changing any of the tests.


