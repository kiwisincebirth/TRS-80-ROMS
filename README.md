# TRS-80

## Description

This repository contains well documented, well-structured Source Code for the Tandy TRS-80 line of computers.
Since the actual source code has not been published (in its original form), this code is based
of disassembly and significant documentation published over the years.
* Provides TRS-80 Model I and Model III ROM source code
* Provides Traditional and Enhanced (improved) ROM versions.
* Supports EACA clone (aka [Disk Smith System-80](https://www.classic-computers.org.nz/system-80/)) hardware
* Provides [prebuilt ROM images](About_Release.txt) for common configurations
* Provides [fixes to known bugs](BUGFIXS.md) in the ROM images
* Based of disassembly, and publicly available documentation.
* Assembled and verified against official ROM images
* Good source code quality, with reasonable comments.

## Source Code

### Model I / III ROM Source Code

Source Code for the "official" ROM's for Tandy TRS-80 computers. These ROM's include options
for improvements while maintaining full backwards compatibility

Two primary ROMS are available:
* [Tandy TRS-80 Model I Level 2 BASIC ROM](./MODEL1.md)
* [Tandy TRS-80 Model III Level 2 BASIC ROM](./MODEL3.md)

### Enhanced Model I / III ROM Source Code

The following provides a much **Enhanced** ROM's with features, fixes for modern enthusiasts.

Two **Enhanced** ROMS are available:
* [TRS-80 Model I (Enhanced) Level 2 BASIC ROM](./MODEL1.4.md)
* [TRS-80 Model III (Enhanced) Level 2 BASIC ROM](./MODEL3.4.md)

### Source Code Files

The following files are supplied:

| File                 | Description                                            |
|----------------------|--------------------------------------------------------|
| CONSTANTS.Z80        | Included - Defines Constants used in Source Code       |
| LEVEL2BASIC-0708.Z80 | Included - Shared Level 2 Basic Code starting at $0708 |
| LEVEL2BASIC-2CA5.Z80 | Included - Shared Level 2 Basic Code starting at $2CA5 |
| makefile             | make                                                   |
| MDL1LEV2.Z80         | Model I Level 2 - Main source                          |
| MDL1REV4.Z80         | Model I Level 2 (Enhanced) - Main source               |
| MDL3LEV2.Z80         | Model III Level 2 - Main source file                   |
| MDL3REV4.Z80         | Model III Level 2 (Enhanced) - Main source             |

### Building

This source code is assembled with Z88DK. Please the seperate [Build Guide](BUILDING.md)

*Previously assembly was with Telemark Assembler / UZ80AS*

### Distribution

Fully Built ROM files are available please see the
[Releases](https://github.com/kiwisincebirth/TRS-80/releases) for the link to download

## Background

### Original Motivation

I read a post asking why Model I BASIC hadn’t been ported to a modern hobbyist CP/M environment. Of course there are
many reasons why this has not been done but one of the issues is (after doing a search) I could not locate original
source code, which would be needed for such a port. I did locate several disassembles, but none we adequately
complete, well formatted, or well documented

I am unsure why the original source code has not been published (in its original form), since the ROM contents have
been very heavily documented over the years. However, this repository aims to address this.

### Source Code Improvements

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

## Fine Print

### Legal

The source code is NOT the original code, it is a derivative work assembled from multiple sources.
By providing this code I do not claim any ownership of the original code, those rights belong with
the original authors.

### Contributing

If you wish to improve the quality of this source code (better documentation) I  would be happy to accept Pull Requests,
please ensure you test that the build works using Telemark Assembler.

### Credits

**TODO**

### References

Following References
* [Ira Goldklang's TRS-80 Site - ROM Main Page](https://www.trs-80.com/wordpress/roms/) - Invaluable documentation
* [Tribute to the Dick Smith System 80 - Model 1 ROM differences](https://www.classic-computers.org.nz/system-80/hardware_rom.htm)
* [https://gitlab.com/retroabandon/trs80i34-re] - The disassembly I based this work on.
* [https://rosettacode.org/wiki/Category:Z80_Assembly#Inlined_bytecode] - Better Else Z80 optimisation
* [https://wikiti.brandonw.net/index.php?title=Z80_Optimization#Better_else] - Better Else optimisation
* [Z88DK - Z80 Assembler (z80asm)](https://github.com/z88dk/z88dk/wiki/Tool---z80asm) - used on this project
* [TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm)
* MOD III ROM COMMENTED - 1981 - Soft Sector Marketing
* Microsoft BASIC Decoded & Other Mysteries - James Farvour
* TRS-80 Rom Routines Documented (The Alternate Source) - Jack Decker
