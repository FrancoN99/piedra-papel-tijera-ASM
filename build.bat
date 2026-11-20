@echo off
tasm 81.asm
tlink /t 81
81
tasm tpf
tasm tpflib
tlink tpf tpflib
