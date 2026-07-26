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

There is documentation in `.prog8compiler/docs/source` but read the rest of
this file before looking for that documentation.

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

## Prog8 standard library code

The source code to the Prog8 standard library for the common modules
and per target modules are in: ` .prog8compiler/compiler/res/prog8lib/`.

The standard library source code can be dumped by the compiler binary
as well by running it with the `-libdump` argument.  This allows getting
the example standard library source code for the compiler you will run.
The source code in `.prog8compiler` is likely to be slightly different from
the version `prog8c` will use, but it will be close enough most of the time.

The command `prog8c -libdump .` will create a directory based on the compiler
version number in the current directory that holds the exact matching standard
library for this prog8c binary.
Here are some prog8c compiler versions and library directory names.
| Prog8 compiler version | Standard librarys source code directory |
| --- | --- |
|v12.1|prog8lib-12.1|
|v12.1.1|prog8lib-12.1.1|
|v12.2|prog8lib-12.2|
|v12.3-SNAPSHOT|prog8lib-12.3-SNAPSHOT|


.prog8compiler/compiler/test/arithmetic
.prog8compiler/compiler/test/comparisons
.prog8compiler/compiler/test/fixtures
.prog8compiler/docs/


## Prog8 sample code
- `agent_context/compiler` - Contains the Prog8 standard library and Prog8 test code used during building the compiler
- `agent_context/parser` - ANTLR4 parser implementation
- `agent_context/docs` - Documentation files
- `agent_context/examples` - Example Prog8 programs


.prog8compiler/benchmark-program/
.prog8compiler/examples/



## Compiling Prog8 programs

## Running Prog8 programs

## Testing Prog8 programs

## Debugging Prog8 programs

