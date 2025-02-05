# TRS-80

## Model 1 ROM Disassembled

This repository contains reverse engineered source code for Tandy TRS-80 Model 1 Level 2 BASIC ROMS. 

This source code has support for both V1.2, and V1.3 ROMS. 
* Version 1.2 (late 1979) was a common version used in many computers
* Version 1.3 (early 1980) was a large (relatively) release notable by the startup message "R/S L2 BASIC"

### Motivation

I read a post asking why Model 1 BASIC hadn’t been ported to a modern hobbyist CP/M environment. Of course there are many reasons why this hasn’t been done but one of the issues is (after doing a search) I couldn’t locate original source code, which would be needed for such a port. I did locate several disassemblies, but none we adequately complete, and would 

I am unsure why the original source code hasn’t been published (in its original form), since the ROM contents have been very heavily documented over the years. However this repository aims to address this.

### Description

While based of a disassembly 

* Replaced all disassembler generated Labels with meaningful labels
* Ensured all jumps (JR and JP) referenced code labels.
* Replaced $3xxx hardware references with EQU definitions
* Replaced $4xxx buffer references with EQU definitions
* Replaced generated op-code with Byte definitions for Data Tables/Text
* Added code Documentation from various sources
* Added Version 1.3 modifications into the source code
* Replaced incorrect op-codes, where better else "Trick" was used.

On the last point (see references that explains better else), I was unaware of these optimisations until I worked on this code.

### Build and Test

This source code has been compiled with Telemark assembler, and tested using a DIFF tool to ensure binary compatibility of the generated output.

### Legal

The source code is NOT the original code, it is a derivative work assembled from multiple sources.

### References

Following References
* [https://www.trs-80.com/wordpress/roms/] - Very good source code documentation
* [https://gitlab.com/retroabandon/trs80i34-re] - The disassembly I based this work on.
* [https://wikiti.brandonw.net/index.php?title=Z80_Optimization#Better_else] - Better Else
* [https://www.cpcalive.com/docs/TASMMAN.HTM] - Telemark Assembler
* Microsoft BASIC Decoded & Other Mysteries - James Farvour

