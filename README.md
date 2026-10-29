# Prog8 AI context for developing user programs

This repository uses reference material from the official Prog8 compiler
repository, downloaded by `setup.py`.  The AGENTS.md file references upstream documents and add additional
information to help with writing programs with Prog8 and inline 6502 assembly.

Some critical code sections like startup code for a target might be written
directly in 6502 assembly language in .asm files and included either by
the inline assembly directly or defined in the custom target properties file.

Prog8 code can easily load modules and call routines written directly in
6502 assembly, but the typical case would be Prog8 and some inline assembly.

The compiler source code is not downloaded, but the standard library source
code (written in Prog8) is critical.

The upstream compiler repository, under the GPLv3 license, is here:
https://github.com/irmen/prog8

`setup.py` does a sparse, shallow download of only the agent skills, docs,
grammar, standard library and example code, matching the version of the
installed `prog8c` compiler.  This gives AI agents the upstream context
without duplicating it here or checking out the whole compiler repository.

# Usage

You *must* run `setup.py` to get the Prog8 reference materials for AI agent
context.  It ends up in the `.prog8-reference` directory, which is in the 
`.gitignore` file to avoid accidentally committing it.

Depending on your platform run one of these commands:
```
py setup.py
python setup.py
python3 setup.py
```
