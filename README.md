# TRS-80

## Model 1 ROM Disassembled

This repository contains reverse engineered source code for Tandy TRS-80 Model 1 Level 2 BASIC ROMS. 

This source code has support for both V1.2, and V1.3 of the ROMS. The version can be selected via the `#DEFINE VER12` code directive. For more information on the differences see the blog article

### Motivation

I read a post asking why Model 1 BASIC hadn’t been ported to a modern hobbyist CP/M environment. Of course there are many reasons why this hasn’t been done but one of the issues is (after doing a search) I couldn’t locate original source code, which would be needed for such a port. I did locate several disassemblies, but none we adequately complete, and would 

I am unsure why the original source code hasn’t been published (in its original form), since the ROM contents have been very heavily documented over the years. However this repository aims to address this.

### Description

While based of a disassembly (which can be low qualtity) the following work has been done: 
* Replaced all disassembler generated labels with meaningful labels
* Ensured all jumps (JR and JP) reference valid code labels.
* Replaced all $3xxx hardware references with `.EQU` definitions
* Replaced all $4xxx buffer references with `.EQU` definitions, with a single `.EQU $4000` reference
* Replaced all generated op-code with Byte `.DB` definitions for DataTables/Text/Constants/Etc
* Added code documentation from various sources at the code block / function level
* Added V1.3 modifications into the source code, with use of `#IFDEF`
* Replaced incorrect op-codes, where Better Else "Trick" was used. See Reference below.

On the last point I was unaware of these optimisations until I worked on this code.

### Build and Test

This source code has been compiled with Telemark Assembler, and tested using a DIFF tool to ensure binary compatibility of the generated output.

There are several Optional `DEFINES` with can be stated. See rom image and uncomment if necessary
* DEFINE VER12 - Defne for V1.2 of the ROM, defaults to the V1.3 ROM Image. Only 1.2 and 1.3 are supported.
* DEFINE NMIHARD - Set NMI (reset) as always perform a hard reset. Normally on non-disk systems NMI performs a soft reset returing to the `READY>` prompt with the basic program intact. This is useful in system without floppy disk to force a full reset (0066h)
* DEFINE LOWCASE - Disable Alpha character translation of letters A-Z to the values on range 00h to 1Fh. This is useful when a lower case mod is installed, but an alternate video driver has not been installed. (0471h)
* DEFINE DONTEND - Disable `.END` directive if `#INCLUDE`ing the source inside another file.

### Example Usage

I have created an implementation of Level 2 Basic that runs as an executable CP/M 2.2 (or greater). 

Switch to the branch "cpmbasic" which takes this source code and you will find TBASIC.Z80 which will
comple to a CP/M COM executable file. It is not well documented (see intose the ASM file), it has many
limitatations but does work. And also includes the LOAD filename.bas which will load a TRS-80 basic program.
You do need to be careful though RAM starts at 3000H (not 4000H), so POKE's to what would normally be video
RAM would easily corrupt your program

### Contributing

If you wish to improve the quality of this source code (better documentation) wuld be happy to accept Pull Requests, please ensure you test that the build works using Telemark Assembler.

### Legal

The source code is NOT the original code, it is a derivative work assembled from multiple sources.

### References

Following References
* [http://www.trs-80.org/model-1-level-2-basic-rom-versions/] - ROM Versions defined
* [https://www.trs-80.com/wordpress/roms/] - Very good source code documentation
* [https://gitlab.com/retroabandon/trs80i34-re] - The disassembly I based this work on.
* [https://rosettacode.org/wiki/Category:Z80_Assembly#Inlined_bytecode] - Better Else
* [https://wikiti.brandonw.net/index.php?title=Z80_Optimization#Better_else] - Better Else
* [https://www.cpcalive.com/docs/TASMMAN.HTM] - Telemark Assembler
* Microsoft BASIC Decoded & Other Mysteries - James Farvour

