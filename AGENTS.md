# AGENTS

## Prog8 context
Read the file `CONTEXT.md` in the root of the repository as the starting
point for understanding the Prog8 language and how to use it.

## This project
- This project is software written in the Prog8 programming language.






- Source code should be kept in the `src/` directory.  If the source code is specific to a target and not portable, it should be in a target specific directory in `src/` Example: Commodore 64 specific source would be in `src/c64/` and virtual target specific source would be in `src/virtual`. 
- Try to use portable libraries, and create portable libraries and code as much as possible.  Ask questions if you're unsure.
- The compiler needs to be told what directories to search for source code besides the current directory.  This is done by passing the `-srcdirs` option with a directory or multiple directories listed.  This should be used on a per target basis to search the `src/` directory as well as the target specific directory like `src/c64` only.  This allows code that is specific to the targets to be put into the target specific directories and have the same name used when importing it.  Example: `-srcdirs src:src/c64` would be used with `-target c64` and `-srcdirs src:src/virtual` would be used with `-target virtual`.
- Target specific code can go into a file called `platform.p8` in each target directory and be imported with `%import platform` and based on the arguments to the `-srcdirs` option the correct `platform.p8` for that target will be imported.
- If a project uses part of another project's source code, like a library module, there can be conflicting names if both use `platform.p8` for target specific source code. For a project called "game" it would be better to create a file called `game_platform.p8` for each target.  That way if we also reference a library project called "sound" that can use `sound_platform.p8` for target specific details.


- The compiler is in the path as the binary `prog8c` which can easily be verified by running `prog8c -version` in the terminal.
- For Prog8 code, unless it is specific to a target like Commodore 64 (`-target c64`), or Commander X16 (`-target cx16`) it is best to compile with the virtual machine target (`-target virtual`) which does not require running an additional emulator.
- Tell the compiler to output to the build directory to keep the project clean.  Example: `prog8c -out build -target virtual -emu myprogam.p8`
- When writing Prog8 code, or changing existing code, use the `-check` option to the compiler.  This will quickly check for correct syntax without generating any output. If Prog8 code is correct, then the compiler can be run normally.  Example **syntax check**: `prog8c -check -target virtual myuprogram.p8`

- the prog8c compiler executable can be found in the shell's path. If it is not in the path, ask how the compiler can be run.

