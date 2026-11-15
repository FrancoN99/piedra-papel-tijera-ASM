@echo off
tasm mint.asm
tlink /t mint.obj
tasm ppt.asm
tasm pptlib.asm
tlink /t ppt.obj pptlib.obj
pause
