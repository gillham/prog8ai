#
# Simple Makefile for a Prog8 program.
#
# This Makefile requires basic Windows or Unix shell tools
# and the Prog8 compiler as `prog8c`.  The `PCC` variable
# can be overridden to use the compiler as a JAR file but
# the JAR file would need to be downloaded or located.
# `java -jar prog8c-12.2-all.jar` would be equivalent to
# running `prog8c` for example.
#
# The 64tass (or Tass64) assembler is needed by the compiler.
# The C64 emulation requires VICE.
# The X16 emulation requires x16emu.
#
# Make targets and explanations:
# all:
#     default target if you just run `make` which ensures
#     the `build/` directory exists and tries to compile
#     whatever targets are in the PROGS variable
#
# build:
#     creates the `build/` directory
#
# clean:
#     removes everything in `build/`
#
# build/mainc64.prg:
#     builds the program for the C64 target
#
# build/maincx16.prg:
#     builds the program for the CX16 target
#
# build/main.p8ir:
#     builds the program for the virtual target
#
# run:
#     depends on the `all` target and then runs in the virtual emulator target
#
# c64:
#     depends on $(SRCS), builds the C64 binary and launches it in VICE.
#
# cx16:
#     depends on $(SRCS), builds the CX16 binary and launches it in x16emu.
#
# check:
#     runs a compiler syntax check without attempting to compile.
#     use it for quickly finding syntax errors in the source code.
#
# test:
#     compiles and runs on the virtual target and compares the output
#     to expected output.  use to validate correct source code changes
#     (presumably the expected results will change as features are written)

# Cross-platform removal command
ifeq ($(OS),Windows_NT)
    CLEAN = del /S /Q build\*
    CP = copy
    RM = del /Q
    MD = mkdir
    MV = cmd -c "move"
else
    CLEAN = rm -fr build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
    MV = mv
endif

PCC=prog8c
PCCARGSC64=-srcdirs src:src/c64 -plaintext -asmlist -target c64 -out build/
PCCARGSCX16=-srcdirs src:src/cx16 -plaintext -asmlist -target cx16 -out build/
PCCARGSVM=-srcdirs src:src/virtual -plaintext -asmlist -target virtual -out build/

PROGS	= build/mainc64.prg build/maincx16.prg build/main.p8ir
SRCS	= src/main.p8

.PHONY:	all check test clean run emu

all: build $(PROGS)

build:
	$(MD) build/

build/mainc64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(MV) build/main.prg $@

build/maincx16.prg: $(SRCS)
	$(PCC) $(PCCARGSCX16) $<
	$(MV) build/main.prg $@

build/main.p8ir: $(SRCS)
	$(PCC) $(PCCARGSVM) $<

check:
	$(PCC) -check -quiet $(PCCARGSVM) $(SRCS)

clean:
	$(CLEAN)

run:	all
	$(PCC) -vm build/main.p8ir

c64:	$(SRCS)
	$(PCC) $(PCCARGSC64) $< -emu

cx16:	$(SRCS)
	$(PCC) $(PCCARGSCX16) $< -emu

test:	all
	$(PCC) -quiet $(PCCARGSVM) -emu $(SRCS) | diff -u tests/expected/virtual_main.txt -

#
# end-of-file
#
