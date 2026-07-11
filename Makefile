#
# Simple Makefile for a Prog8 program.
#

# Cross-platform removal command
ifeq ($(OS),Windows_NT)
    CLEAN = del /Q build\*
    CP = copy
    RM = del /Q
    MD = mkdir
else
    CLEAN = rm -f build/*
    CP = cp -p
    RM = rm -f
    MD = mkdir -p
endif

# Emulator settings
EMU_CMD=x64sc
EMU_BASE=-default -keymap 1 -model ntsc
EMU_DISK=-fs8 build -device8 1 -iecdevice8 -virtualdev8
#EMU_KERNAL=-kernal jiffykernal
EMU_REUSIZE=2048
EMU_REU=-reu -reusize $(EMU_REUSIZE) -reuimage bin/reu-image.bin -reuimagerw
EMU=$(EMU_CMD) $(EMU_BASE) $(EMU_KERNAL) $(EMU_DISK) $(EMU_REU)

PCC=prog8c
PCCARGSC64=-srcdirs src -plaintext -asmlist -target c64 -out build
PCCARGSVM=-srcdirs src -plaintext -asmlist -target virtual -out build

PROGS	= build/main.p8ir
#PROGS	= build/mainc64.prg
SRCS	= src/main.p8

all: build $(PROGS)

build:
	$(MD) build/

build/mainc64.prg: $(SRCS)
	$(PCC) $(PCCARGSC64) $<

build/main.p8ir: $(SRCS)
	$(PCC) $(PCCARGSVM) $<

clean:
	$(RM) build/*

run:	all
	prog8c -vm build/main.p8ir

emu:	all
	$(EMU)

#
# end-of-file
#
