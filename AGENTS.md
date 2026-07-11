# CRITICAL RULES - MUST FOLLOW

## RESPONSES

- Keep responses concise and to the point - unless the user asks otherwise

## PLANNING MODE

- Always ask clarifying questions
- Never assume design, tech stack or features
- Use deep-dive sub-agents to assist with research
- Use deep-dive sub-agents to review the different aspects of your plan before presenting to the user

## CHANGE / EDIT MODE

- Never implement features yourself when possible - use sub-agents!
- Identify changes from the plan that can be implemented in parallel, and use sub-agents to implement the features efficiently
- When using sub-agents to implement features, act as a coordinator only
- Use the best model for the task - premium models for complex tasks (like coding) and mid-tier models for simpler tasks, like documentation
- After completing features (large or small), always run commands like lint, type check and next build to check code quality

## Project Overview
- This project is software written in the Prog8 programming language.
- Files in the `agent_context` directory provide additional sample code and references to paths should also look in the `agent_context` directory.  So if `docs/source/` is mentioned, look in `agent_context/docs/source/` as well.
- Prog8 is a programming language primarily targeting 8-bit retro systems with the 6502 CPU, such as the Commodore 64, Commodore 128, and Commander X16.
- The compiler has a 6502 code generator backend, and an IR code generator. The compiler is called via the `prog8c` binary in the path or by running `make`, so the `Makefile` in the project root can be referenced to understand appropriate compiler options. Try `prog8c -help` to get a list of commandline arguments and their brief explanation.
- The compiler includes a simple 'virtual machine' that can execute the IR code directly via interpretation.
- Prog8 source files have .p8 extension – these are *not* LUA or PICO-8 source files in this case!
- Prog8 source files are a "module" that can contain one or more "blocks". They can also import other modules, from internal library files or from source files on the filesystem.
- The standard library is mostly written in Prog8 and assembly code, and can be found in the "compiler" module, in the 'res/prog8lib' directory.
- **Library Reference**: For a quick overview of all available modules, routines, and their signatures, **consult the skeleton files (symboldumps)** in `docs/source/_static/symboldumps/`. They are named `skeletons-<target>.txt`.
- Java 17 is used as Java runtime version.
- ANTLR4 version 4.13 is used for the parser implementation.

### Target Differences
- **CPU instruction set differences**: Only the CommanderX16 target (cx16) can use 65C02 instructions such as STZ. The other targets (C64, C128, PET32) can only use original 6502 instructions.
- When writing or understanding assembly code, load the `asm6502-coder` skill for 64tass syntax and conventions.


## DEBUGGING TIP: Use `-noopt` to isolate problems
When investigating a possible code generation problem (both IR and 6502), **FIRST try compiling the program with the `-noopt` switch** to disable most of the compiler optimizations.
- **Problem gone with `-noopt`**: Issue is in **optimization phases** (`optimizeAst()`, `UnusedCodeRemover`, `Inliner`, etc.)
- **Problem persists with `-noopt`**: Issue is in **parsing, semantic analysis, symboltable, or the regular code generation path**.

This way you can determine if the problem is caused by a faulty optimization step, or just occurs in the regular code generation path.

## DEBUGGING TIP: Use `-compareir` to see what changed
When investigating optimization-related issues or tracking regressions:
```bash
# Compile without optimizations (baseline)
prog8c -target virtual -noopt -out dir program.p8

# Compile with optimizations and compare
prog8c -target virtual -compareir dir/program_noopt.p8ir program.p8
```
**Output shows:**
- Instruction/chunk/register count changes with percentages
- First 10 actual instruction differences
- Helps identify which optimization transformed the code

## DEBUGGING TIP: Use `-vmtrace` to trace execution
When debugging VM execution or control flow issues:
```bash
prog8c -target virtual -vm program.p8ir -vmtrace
prog8c -target virtual -emu -vmtrace program.p8
```
**Output format:** `[chunkName:instructionIndex] instruction`
- Shows each executed IR instruction with location
- Useful for understanding control flow and finding where execution diverges
- **Only works on virtual target**

## Typical debugging workflow:
1. **Quick check:** `-check` for syntax errors
2. **Isolate:** `-noopt` to determine if problem is optimizer-related
3. **Compare:** `-compareir` to see what instructions changed
4. **Trace:** `-vmtrace` to watch actual execution flow
5. **Deep dive:** `-printast1` / `-printast2` for compiler internals

## IMPORTANT: Compiler Crashes Must Be Fixed in the Compiler
A Kotlin/Java crash in the compiler itself (as opposed to a compilation error in the user's program) indicates a bug in the compiler code. **Such crashes should NEVER be worked around by modifying the Prog8 source file that triggered them.**

The user's program is correct - the compiler needs to handle it properly.  If the user's program has a syntax erorr the compiler should generate an error message, not crash with an exception.

Steps when encountering a compiler crash:
1. Create a minimal reproduction case of the Prog8 source that triggers the crash

## CRITICAL: NO FORMATTING
- DO NOT change indentation and formatting of lines that are not being modified. NEVER run formatters (black, ruff, prettier, etc.) after edits,
- .editorconfig handles basic formatting (indentation, line endings, whitespace)
- Make ONLY the requested changes, touch nothing else
- **NO EMOJI in user documentation**. Do not use emoji or decorative unicode symbols in documentation files. Functional unicode symbols are acceptable when they serve a clear purpose (e.g., → for arrows, ± for plus-minus, × for multiplication, ° for degrees). Avoid decorative emoji like ❌ ✅ ⚠️ 🎉 etc.

### Code Style Guidelines
**Minimal comments when making changes**: When modifying existing code, add only essential comments that explain *why* a change was made or document non-obvious behavior. **Do not add verbose comments** that restate what the code does; let the code speak for itself. Existing extensive comments should be preserved, but new changes should have minimal commentary.

## Prog8 language information

When the task involves writing or understanding `.p8` (Prog8 source) or `.p8ir` (Prog8 intermediate representation) files, **load the `prog8-coder` skill** — it contains the full language reference, syntax rules, and standard library guidance.

## Project Module Descriptions

## Prog8 sample code locations
- `agent_context/compiler` - Contains the Prog8 standard library and Prog8 test code used during building the compiler
- `agent_context/parser` - ANTLR4 parser implementation
- `agent_context/docs` - Documentation files
- `agent_context/examples` - Example Prog8 programs

## Key Information
- never read the files and directories that are ignored via the .aiignore and .gitignore files (EXCEPT when it is a folder for agent config such as .junie, .opencode, .qwen or .agent)
- never perform any git source control write/update/add/commit/branch operations. Read and status operations are allowed.
- **git log/history queries can be useful** for understanding when/why a feature was added or tracking down when a bug was introduced, but for locating code use grep_search or glob instead.
- Architecture decisions: separation of frontend/parser, IR intermediate representation, multiple backends

## Junie Agent Commitments
These instructions apply specifically to the Junie agent:

*   **Code Discovery and Navigation**: Use the `get_file_structure` tool to understand the API and structure of files before reading or editing them.
*   **Symbol-Aware Searching**: Use the `search_project` tool as the primary method for finding symbol definitions (classes, methods, variables) across the project.
*   **Project-Wide Refactoring**: Exclusively use the `rename_element` tool for any symbol renames to ensure all references, imports, and documentation are updated correctly.
*   **Contextual Exploration**: Use the `open` tool with specific `line_number` parameters to navigate directly to relevant code sections.

**Note on Terminal usage**: When calling the compiler with `prog8c` the `-plaintext` option should be specified to avoid getting colored text or ansi graphics on the output.

# Dev environment tips

- Source code should be kept in the `src/` directory.  If the source code is specific to a target and not portable, it should be in a target specific directory in `src/` Example: Commodore 64 specific source would be in `src/c64/` and virtual target specific source would be in `src/virtual`. 
- Try to use portable libraries, and create portable libraries and code as much as possible.  Ask questions if you're unsure.
- The compiler needs to be told what directories to search for source code besides the current directory.  This is done by passing the `-srcdirs` option with a directory or multiple directories listed.  This should be used on a per target basis to search the `src/` directory as well as the target specific directory like `src/c64` only.  This allows code that is specific to the targets to be put into the target specific directories and have the same name used when importing it.  Example: `-srcdirs src:src/c64` would be used with `-target c64` and `-srcdirs src:src/virtual` would be used with `-target virtual`.
- Target specific code can go into a file called `platform.p8` in each target directory and be imported with `%import platform` and based on the arguments to the `-srcdirs` option the correct `platform.p8` for that target will be imported.
- If a project uses part of another project's source code, like a library module, there can be conflicting names if both use `platform.p8` for target specific source code. For a project called "game" it would be better to create a file called `game_platform.p8` for each target.  That way if we also reference a library project called "sound" that can use `sound_platform.p8` for target specific details.

## Development Workflows

**1. Testing your own Prog8 programs**:
- Just run `prog8c` directly
- Edit your `.p8` file → compile/run → check stdout output
- Example: `prog8c -target virtual -emu myprogram.p8`

## Using the Compiler (prog8c)
- The compiler is in the path as the binary `prog8c` which can easily be verified by running `prog8c -version` in the terminal.
- For Prog8 code, unless it is specific to a target like Commodore 64 (`-target c64`), or Commander X16 (`-target cx16`) it is best to compile with the virtual machine target (`-target virtual`) which does not require running an additional emulator.
- Tell the compiler to output to the build directory to keep the project clean.  Example: `prog8c -out build -target virtual -emu myprogam.p8`
- When writing Prog8 code, or changing existing code, use the `-check` option to the compiler.  This will quickly check for correct syntax without generating any output. If Prog8 code is correct, then the compiler can be run normally.  Example **syntax check**: `prog8c -check -target virtual myuprogram.p8`

- the prog8c compiler executable can be found in the shell's path. If it is not in the path, ask how the compiler can be run.
- **the `-check` switch performs a quick syntax/semantic check only; it will NOT produce any output files (no .prg, .asm, etc.)**. Use it only for fast error checking during development.
- **the `-noopt` switch DISABLES all optimizations** - useful for debugging to determine if a problem is caused by the optimizer. **Optimizations are ENABLED by default** (no flag needed).
- **prog8c uses single-dash command line options** (e.g., `-target`, `-noopt`, `-check`), NOT double-dash (`--target` is invalid).
- **the `-printast1` switch prints out the internal Compiler AST** after parsing and semantic analysis.
- **the `-printast2` switch prints out the optimized Simple AST** just before it goes to the code generator. This is useful for debugging optimizer issues.
- **the `-out outdir` switch sets an alternative output directory** for compiled files (.prg, .asm, .list, etc.). **By default, output files are written to the same directory as the source file**.
- **Other useful flags**: `-quiet` (suppress messages), `-warnimplicitcasts` (warn on implicit type widening), `-daemon` (keep a background compiler process alive — must be passed on every invocation)

### Compilation Output Files
- `*.prg` - The final compiled program file for the target system (e.g., Commander X16)
- `*.asm` - Generated assembly code from the Prog8 source
- `*.list` - Generated full assembly listing file from the Prog8 source
- `*.p8ir` - Intermediate representation file, can be executed in the Virtual Machine
- `*.vice-mon-list` - Vice emulator monitor list file for debugging

### Execution Examples
- `prog8c -target targetname input.p8` - Compile a Prog8 source file "input.p8" for the given target (cx16, c64, pet32, c128, virtual)
- `prog8c -target targetname -emu input.p8` - Compile and execute a prog8 file in the emulator for the given target (cx16, c64, pet32, c128, virtual)
- `prog8c -vm input.p8ir` - Execute an existing prog8 program, compiled in IR form, in the Virtual Machine

### Library Tools
- **Library search**: `prog8c -libsearch <regex>` — search for a regex pattern in the embedded stdlib files. Extremely useful to quickly find library routines, variables, or signatures (e.g., `prog8c -libsearch "txt\."` lists all textio routines)
- **Library dump**: `prog8c -libdump <dir>` — extract all embedded library source files into a directory for direct inspection

## Testing and Verification

- Never assume your changes simply work, always test!
- If the project does not have any testing tools, scripts, MCP tools, skills, etc. available for testing, ask the user whether testing should be skipped.

### Manual Verification & Emulators

**Testing tip**: When writing and testing Prog8 programs, **use the `virtual` target** (e.g., `prog8c -target virtual -emu input.p8` or `prog8c -vm input.p8ir`). This is the preferred way to test because the virtual target can easily write output to stdout, making it simple to verify program behavior and check results.

**CX16 output verification**: Use `x16emu -echo iso -run -prg input.prg` to echo screen output to stdout **and auto-start the program**. The `-run` flag is **critical**: without it, the program loads but doesn't execute, so you'll see no output. Pipe through `strings` or `grep` to filter: `x16emu -echo iso -run -prg input.prg 2>&1 | grep -E "(PASS|FAIL)"`.
**IMPORTANT**: Always add `%encoding iso` at the top of your source file and call `txt.iso()` in `start()`. This prevents PETSCII→ISO charset translation errors that garble uppercase/special characters and make output unreadable:
```prog8
%encoding iso
%import textio
main { sub start() { txt.iso(); txt.print("PASS\n") } }
```
**IMPORTANT: Always use `sys.poweroff_system()` to exit the CX16 emulator cleanly!** Add `sys.poweroff_system()` at the end of your main program block - this exits x16emu automatically in most cases.
**Note:** The `sys` module is always available, there is no need to import it ever.

**Commodore 64 (x64sc)**: `x64sc input.prg` - run an existing compiled program in the Commodore-64 emulator. Ignore any errors and warnings, because the emulator doesn't produce any output on STDOUT.

### actual 6502 CPU simulation tests
For high-fidelity functional verification of generated 6502 code without a full emulator, you can use the `ksim65` simulator in your unit tests. This allows executing the compiled machine code and asserting on memory or register states.
- Use the `simulate()` extension function on a `CompilationResult`.
- See `prog8tests.codegeneration.TestExecution6502` for examples.
- Both 6502 and 65C02 CPUs can be simulated.
- The simulator supports capturing serial output and handling hardware reset/poweroff signals.
- There are various assertion helper methods to test on the state of CPU registers, memory contents, etc.
- Using the simulator is much faster and way more controllable than using a full emulator to run the code.
- The simulator DOES NOT represent an actual real world machine and has VERY LIMITED hardware devices so it can generally not be used to run full example prorams on.

## Git Operations for File Moves/Deletes

**When renaming or moving git-tracked files, ALWAYS use `git mv`:**
```bash
# CORRECT - preserves git history
git mv old/path/file.p8 new/path/file.p8

# WRONG - git sees this as delete + add (loses history)
mv old/path/file.p8 new/path/file.p8
```

**When deleting git-tracked files, ALWAYS use `git rm`:**
```bash
# CORRECT - properly stages the deletion
git rm path/to/file.p8

# WRONG - git sees this as unstaged deletion
rm path/to/file.p8
```

**Why this matters:** `git mv` and `git rm` properly stage the changes and preserve file history. Plain `mv`/`rm` requires git to detect renames heuristically, which may not always work correctly.

