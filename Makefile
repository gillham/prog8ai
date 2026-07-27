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
# The C64 emulator requires VICE.
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
# build/main.p8ir:
#     builds the program for the virtual target
#
# run:
#     depends on the `all` target and then runs in the virtual emulator target
#
# emu:
#     depends on `all` and runs the C64 binary under the VICE emulator.

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

# Emulator settings
EMU_CMD=x64sc
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK=-fs8 build -devicebackend8 1 -busdevice8 -trapdevice8
#EMU_KERNAL=-kernal jiffykernal
EMU_REUSIZE=2048
# build/reu-image.bin is a runtime artifact that we want cleaned up
# by the `make clean` target.  Normal edit/compile/run cycles will
# reuse the file, but `make clean` should clean it.  This matters
# when the REU contents gets corrupted.
EMU_REU=-reu -reusize $(EMU_REUSIZE) -reuimage build/reu-image.bin -reuimagerw
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_REU)

PCC=prog8c
PCCARGSC64=-srcdirs src:src/c64 -plaintext -asmlist -target c64 -out build/
PCCARGSVM=-srcdirs src:src/virtual -plaintext -asmlist -target virtual -out build/

PROGS	= build/main.p8ir
#PROGS	= build/mainc64.prg
SRCS	= src/main.p8

.PHONY:	all check test clean run emu

all: build $(PROGS)

build:
	$(MD) build/

build/mainc64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<
	$(MV) build/main.prg $@

build/main.p8ir: $(SRCS)
	$(PCC) $(PCCARGSVM) $<

check:
	$(PCC) -check -quiet $(PCCARGSVM) $(SRCS)

clean:
	$(CLEAN)

run:	all
	$(PCC) -vm build/main.p8ir

emu:	all
	$(EMU)

test:	all
	$(PCC) -quiet $(PCCARGSVM) -emu $(SRCS) | diff -u tests/expected/virtual_main.txt -

#
# end-of-file
#
