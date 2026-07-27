# Prog8 AI context for developing user programs

This repository uses the official Prog8 compiler repository as a submodule.
The various AGENTS.md and CONTEXT.md files reference upstream documents and
add additional information to help with writing programs with Prog8 and
inline 6502 assembly.

Some critical code sections like startup code for a target might be written
directly in 6502 assembly language in .asm files and included either by
the inline assembly directly or defined in the custom target properties file.

Prog8 code can easily load modules and call routines written directly in
6502 assembly, but the typical case would be Prog8 and some inline assembly.

The compiler source code is ignored, but the standard library source
code (written in Prog8) is critical.

The upstream compiler repository, under the GPLv3 license, is here:
https://github.com/irmen/prog8

Adding the whole Prog8 compiler repository as a submodule significantly
increases the checked out size of this repository but is important to properly
use AI agents and provide context without duplication.

# Usage

You *must* init the git submodules if you did not recursively clone this repo.
Run: `git submodule update --init --depth 1` to clone the Prog8 compiler source
as a submodule which is critical for AI context.
