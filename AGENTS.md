# AGENTS

## Prog8 context
Read the file `CONTEXT.md` in the root of the repository as the starting
point for understanding the Prog8 language and how to use it.

## This project
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
  can be run normally.  Example syntax check:
  `prog8c -check -target virtual myprogram.p8`
