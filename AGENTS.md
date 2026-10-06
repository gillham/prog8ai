# AGENTS

## Agent skills

The author of the Prog8 compiler has created agent skill files for writing
software with Prog8 and 6502 assembler.

Note that any file references in the skills files below would be relative
to the `.prog8compiler` directory since it is a submodule.

Read `.prog8compiler/.agents/skills/prog8-coder/SKILL.md` when writing or
reviewing Prog8 code (skip this if your tool already loaded it as a skill).

Only read `.prog8compiler/.agents/skills/asm6502-coder/SKILL.md`
when writing or debugging `%asm`, `asmsub`, `extsub`, or `.asm` code.

## Prog8 project
- This project is software written in the Prog8 programming language.
- This project uses `make` with instructions written in the `Makefile`.
  - After changing source code run `make check` to syntax check it
  - Use `make run` to compile and run on the virtual target.
  - After `make clean` you might need to run `prog8c -libdump build/` again,
    but only if you're using the `-libdump` workflow.  The preferred
    tool is using `-libsearch` which doesn't need the `-libdump` at all.
  - You should run `make test` to validate the output matches expected.

## Repository rules

- Source code should be kept in the `src/` directory.  The toplevel source
  file is usually `src/main.p8`.
- If the source code is specific to a target and not portable, it should
  be in a target specific directory in `src/`
  - For example: Commodore 64 specific source would be in `src/c64/`
  - Another example: virtual target specific source would be in `src/virtual/`
- Try to use portable libraries, and create portable libraries and code
  as much as possible.  Ask questions if you're unsure.
- The compiler needs to be told what directories to search for source code
  besides the current directory.
  - This is done by passing the `-srcdirs` option with a directory or
    multiple directories listed.
  - The `src/` directory should always be included in the `-srcdirs` option.
  - Target specific directories like `src/c64` should also be added to
    `-srcdirs`, but only for the current target.
  - This allows code that is specific to the targets to be put into the
    target specific directories and have the same name used when importing it.
  - Example: `-srcdirs src:src/c64` would be used with `-target c64` and
    `-srcdirs src:src/virtual` would be used with `-target virtual`.
- Target specific code should go into a file in each target directory
  and should use the module name/type with `_platform.p8` appended.
  So an input library would be `src/input_platform.p8` and be imported with
  `%import input_platform`. Based on the arguments to the `-srcdirs` option
  the correct `input_platform.p8` for that target will be imported.
- The prog8c compiler executable can be found in the shell's path as
  the command `prog8c`. If it is not found, ask how to run the compiler.
- For Prog8 code, unless it is specific to a target like Commodore 64
  (`-target c64`), or Commander X16 (`-target cx16`) it is best to compile
  and test with the virtual machine target (`-target virtual`) which does not
  require running an additional emulator.  Even with programs that are
  target specific it can be useful to use the virtual target to test game
  logic that is target independent.
- Tell the compiler to output to the `build/` directory to keep the project
  clean.  Example: `prog8c -out build/ -target virtual -emu myprogram.p8`
- When writing Prog8 code, or changing existing code, use the `-check`
  option to the compiler.  This will quickly check for correct syntax
  without generating any output. If Prog8 code is correct, then the compiler
  can be run normally.

# Agent context

## Prog8 language overview

The Prog8 compiler and its source code is a submodule in the `.prog8compiler`
directory off the root of this repository. The compiler is written in Kotlin
and JAVA, but we are only interested in the Prog8 and 6502 assembler 
portions of the repository.  It is wrong to attempt to use Kotlin or JAVA
examples or source code when developing Prog8 or 6502 assembler programs.

The syntax of the Prog8 language is documented in an ANTLR4 grammar file.
If a syntax question isn't answered by an existing skill file or a `-check`
message, grep `.prog8compiler/parser/src/main/antlr/Prog8ANTLR.g4` for the rule.

There is documentation in `.prog8compiler/docs/source` and below is a
table of the most relevant files to view.
Do not blindly read all of the files.  Use the command below, replacing `libraries.rst`
with the appropriate file, to see the section headers.

`awk 'NR>1 && /^[\^\*=~-]+$/ && prev ~ /^[A-Za-z]/ {print (NR-1) ": " prev} {prev=$0}' .prog8compiler/docs/source/libraries.rst`

|Filename|
|--------|
|`compiling.rst`|
|`libraries.rst`|
|`programming.rst`|
|`structpointers.rst`|
|`targetsystem.rst`|
|`variables.rst`|


## Prog8 context files

This table will have context files with a status of stub, partial, or done.
These files must only add what the upstream skills don't already cover.
NOTE: Ignore files with the status of "stub" as they are useless.

The filenames below are all in the `.context/` directory off the
root of the repository.

| Filename                       |Status|Description|
|--------------------------------|------|-----------|
| `modules.md`         |partial|Prog8 standard library modules|
| `versions.md`         |partial|Prog8 compiler versions and their features|

### Finding context
- When grepping in `.prog8compiler` you need to add `--include=*.p8`
to limit the searches to only Prog8 source code.
- Never search these directories for files (unless given a specific filename):
  - `.prog8compiler/compiler/src`
  - `.prog8compiler/codeCore`
  - `.prog8compiler/codeGen*`
  - `.prog8compiler/intermediate`
  - `.prog8compiler/parser` (Except for parser/src/main/antlr/Prog8ANTLR.g4)

## Prog8 compiler versions

Only look in `.context/versions.md` if there is a possible compiler bug.

## Prog8 standard library code

The source code to the Prog8 standard library for the common modules
and per target modules are in: `.prog8compiler/compiler/res/prog8lib/`, but
you should never blindly read the whole files.

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

The `prog8c -libsearch` command is the preferred way to search
the standard library.

Normally it should not be necessary, but the standard library source code
can be dumped by the compiler binary by running it with `-libdump build/`.
The command will create a directory in `build/` with the standard library
source code.  Find it by running: `ls -d build/prog8lib-*`

This allows getting the example standard library source code for the exact compiler
in use.
The source code in `.prog8compiler` is likely to be slightly different from
the version `prog8c` will use, but it will be close enough most of the time.

If a different version of the compiler is run you could end up with multiple
directories in `build/` that match. An explicit `make clean` should be run
before running `prog8c -libdump build/` if using a different version.

The results from `prog8c -libsearch` and `prog8c -libdump` should be trusted
over source code from the `.prog8compiler` directory which might be out of
date or not match the `prog8c` binary being used.

When using versions of `prog8c` older than v12.2, warn the user and ask if they
want to proceed with the older version of the compiler.


## Prog8 sample code
Do not blindly read whole example files.  Use `grep`.

Directories with some example code written in Prog8:
- `.prog8compiler/examples/`
- `.prog8compiler/benchmark-program/`
- `.prog8compiler/compiler/test/arithmetic/`
- `.prog8compiler/compiler/test/comparisons/`
- `.prog8compiler/compiler/test/fixtures/`

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


