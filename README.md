# TRS-80

## Model I / III ROM Source Code

This repository contains well documented, well-structured Source Code for the Tandy TRS-80 line of computers.
The source code has also been extended with optional `#DEFINE`'s to provide common customisation options.

Three ROMS are available:
* [Tandy TRS-80 Model 1 Level 2 BASIC ROMS](./MODEL1.md)
* [Tandy TRS-80 Model 1 Level 2 BASIC Rev 1.4](./MODEL1.4.md)
* [Tandy TRS-80 Model III Level 2 BASIC ROMS](./MODEL3.md)

### Motivation

I read a post asking why Model 1 BASIC hadn’t been ported to a modern hobbyist CP/M environment. Of course there are 
many reasons why this has not been done but one of the issues is (after doing a search) I could not locate original 
source code, which would be needed for such a port. I did locate several disassembles, but none we adequately 
complete, well formatted, or well documented

I am unsure why the original source code has not been published (in its original form), since the ROM contents have 
been very heavily documented over the years. However, this repository aims to address this.

### Description

While originally based off a (low quality) disassembly, the following improvements have been made: 
* Replaced all disassembler generated labels with meaningful labels.
* Ensured all jumps (JR and JP) reference valid code labels.
* Replaced all $3xxx hardware references with `.EQU` definitions.
* Replaced all $4xxx buffer references with `.EQU` definitions.
* Replaced all $xx byte references with appropriate decimal or ascii values, and/or `.EQU` definitions.
* Replaced all generated op-code with Byte `.DB` `.DW` definitions for DataTables/Text/Constants/Etc
* Added code documentation from various sources at the code block / function level.
* Replaced incorrect op-codes, where Better Else "Trick" was used. See Reference below.

On the last point I was unaware of these optimisations until I worked on this code.
If you are interested search the code for `Trick` you will find cope optimisations
that save a few bytes by allowing Jumps to the second byte of 2 byte instruction

## Source Code

See The following for details of source code including Build Options:
* [Model 1 Build Options](./MODEL1.md)
* [Model 1 Build Options Rev 1.4](./MODEL1.4.md)
* [Model III Build Options](./MODEL3.md)

### Compiling

This source code has been compiled with Telemark Assembler, and tested using a DIFF tool to ensure binary
compatibility of the generated output. If you have issues compiling it with a different assembler
please let me know how the code can be fixed

## Extensions

### L2 Basic for CP/M

I have created an implementation of Level 2 Basic that runs as an executable CP/M 2.2 (or greater). 

Switch to the branch "cpmbasic" which takes this source code and you will find TBASIC.Z80 which will
compile to a CP/M COM executable file. It is partially documented in the TBASIC.ASM file, it has many
limitations but does work. 

i.e. You do need to be careful though RAM starts at 3000H (not 4000H), so POKE's to what would normally be video
RAM would easily corrupt your program. No attempt has been mad to address these issues. 

It also includes the `LOAD filename.BAS` which will load a TRS-80 basic program from CP/M filesystem

## Fine Print

### Legal

The source code is NOT the original code, it is a derivative work assembled from multiple sources.
By providing this code I do not claim any ownership of the original code, those rights belong with
the original authors.

### Contributing

If you wish to improve the quality of this source code (better documentation) I  would be happy to accept Pull Requests,
please ensure you test that the build works using Telemark Assembler.

### References

Following References
* [Ira Goldklang's TRS-80 Site - ROM Main Page](https://www.trs-80.com/wordpress/roms/) - Invaluable documentation
* [Tribute to the Dick Smith System 80 - Model 1 ROM differences](https://www.classic-computers.org.nz/system-80/hardware_rom.htm)
* [https://gitlab.com/retroabandon/trs80i34-re] - The disassembly I based this work on.
* [https://rosettacode.org/wiki/Category:Z80_Assembly#Inlined_bytecode] - Better Else Z80 optimisation
* [https://wikiti.brandonw.net/index.php?title=Z80_Optimization#Better_else] - Better Else optimisation
* [https://www.cpcalive.com/docs/TASMMAN.HTM] - Telemark Assembler
* [TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm)
* MOD III ROM COMMENTED - 1981 - Soft Sector Marketing
* Microsoft BASIC Decoded & Other Mysteries - James Farvour
* TRS-80 Rom Routines Documented (The Alternate Source) - Jack Decker
