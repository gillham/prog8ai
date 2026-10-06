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
- The prog8c compiler executable can be found in the shell's path as
  the command `prog8c`. If it is not found, ask how to run the compiler.
- This project uses `make` with instructions written in the `Makefile`.
  - After changing source code run `make check` to syntax check it.
  - Use `make run` to compile and run on the virtual target.
  - Run `make test` to validate the output matches expected.
- When running `prog8c` directly, copy the arguments from the `PCCARGS*`
  variables in the `Makefile`.  Use `-check` for a fast syntax-only pass
  and `-out build/` to keep the project clean.
- Prefer the virtual target (`-target virtual`) since it needs no emulator.
  Even target specific programs can test target independent logic on it.

## Repository rules

- Source code goes in `src/`; the toplevel source file is usually
  `src/main.p8`.
- Target specific (non-portable) code goes in a target directory such as
  `src/c64/` or `src/virtual/`, in a file named after the module with
  `_platform.p8` appended, e.g. `src/c64/input_platform.p8` imported with
  `%import input_platform`.
- `-srcdirs` always includes `src` plus only the current target's
  directory, so the right `_platform.p8` is picked up:
  `-srcdirs src:src/c64` with `-target c64`, `-srcdirs src:src/virtual`
  with `-target virtual`.
- Try to use portable libraries, and create portable libraries and code
  as much as possible.  Ask questions if you're unsure.

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

These files in `.context/` must only add what the upstream skills don't
already cover.

| Filename                       |Status|Description|
|--------------------------------|------|-----------|
| `modules.md`         |partial|Prog8 standard library modules|
| `versions.md`         |partial|Prog8 compiler versions and their features|

Only look in `.context/versions.md` if there is a possible compiler bug.

### Finding context
- When grepping in `.prog8compiler` you need to add `--include=*.p8`
to limit the searches to only Prog8 source code.
- Never search these directories for files (unless given a specific filename):
  - `.prog8compiler/compiler/src`
  - `.prog8compiler/codeCore`
  - `.prog8compiler/codeGen*`
  - `.prog8compiler/intermediate`
  - `.prog8compiler/parser` (Except for parser/src/main/antlr/Prog8ANTLR.g4)

## Prog8 standard library code

The preferred way to search the standard library is `prog8c -libsearch`
with a quoted regex:
- `prog8c -libsearch 'sub\s+print\s?\('` finds the definitions of `print`.
- `prog8c -libsearch 'txt\.print_ub'` finds uses of `txt.print_ub`.

Normally it is not necessary, but `prog8c -libdump build/` dumps the
library source for the exact compiler in use into `build/prog8lib-*`.
Run `make clean` first if a different compiler version was used before,
so only one matching directory exists.

The library source is also in `.prog8compiler/compiler/res/prog8lib/`
(never read whole files), but it may not match the `prog8c` binary, so
trust `-libsearch` and `-libdump` results over it.

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

`make test` compiles for the virtual target, runs it with `prog8c -emu`
(using `-plaintext` and `-quiet` so stdout is clean), and diffs the output
against `tests/expected/`.  New features need new expected files and a
matching change to the `test` target in the `Makefile`.

Ask before changing any of the tests.
