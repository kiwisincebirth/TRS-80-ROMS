
# TRS-80 Model I

## Level 2 ( Revision 1.4 )

This is modernised Level 2 Basic ROM for the Model I.
It is based of the Tandy Rev 1.3 ROMS and includes several enhancements. 
This should be considered a successor to the L2 ROM's, but does break some compatibility.

Source Code File : [MDL1REV4.Z80](./MDL1REV4.Z80)

> NOTE: For best results view the code with 8 spaces per tab.

## Main Features

Main Features
* Mostly Compilable with Model I Level 2 12KB ROMS.
* Patches have been included via `#DEFINE`, and can be removed at user discretion
* The Rom has free space, divided into several areas for extension
* ROM entry points have been maintained as much as possible.
* Lower case suport is embraced where possible.  
* EACA clone hardware supported

Breaking Features
* Cassette Support has been removed, in favour of newer features
* See section [Cassette Support](#cassette-support) below for more details.

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.
By default, **ALL** of these options are enabled (unless OPTIONAL), and can individually be disabled. 

There are several enhanced features:
* `#DEFINE NEWBOOT` - Enables a new boot routine which asks for "diskette?" when no disk is detected and retries.
  It also allows for break to be pressed at any time. (Credit : John Swiderski)
* `#DEFINE FREHDBT` - Enables the FreHD auto boot feature, i.e. the Auto boot ROM. This requires version 1.3
  ROM as a base, please do NOT define `VER12` as it is not compatible (it will be ignored anyway)
  Consider also enabling NMIHARD to ensure reset (on non-floppy machine) will force a reset.
* `#DEFINE NOMEMSIZE` - Skip user input of Memory Size? override at startup with `M` key. (Credit : John Swiderski)
* `#DEFINE FASTMEM` - Speed up startup memory size check by checking first byte of every 256 page,
  rather than every byte.
* `#DEFINE NMIHARD` - Set NMI (reset) as always perform a hard reset. Normally on non-floppy systems NMI performs
  a soft reset returning to the `READY>` prompt with the basic program intact. This is useful in system without
  floppy disk to force a full reset (0066h)
* `#DEFINE LOWCASE` - Disable Alpha character translation of letters A-Z,a-z to the values on range 00h to 1Fh.
  This is useful when a lower case mod is installed, but an alternate video driver has not been installed,
  or where the font rom on the machine has the alternate characters in the 00h 1Fh range (0471h)
* `#DEFINE MSGSTART` - Enhanced startup message showing Free Bytes available to BASIC
* `#DEFINE KEYBOUNCE` - Enables the Keyboard debounce routines that where introduced in rev1.3

Bug Fixes Applied
* `#DEFINE BUGFIX1` - Fix Error 1 - 04F6H - 32 Character Mode Line Length
* `#DEFINE BUGFIX2` - Fix Error 2 - 153EH - Random Number Single Precision Overrun
* `#DEFINE BUGFIX5` - Fix Error 5 - 08A7H - INT(DoubleValue) rounding
* `#DEFINE BUGFIX7` - Fix Error 7 - 0EF2H - Space after type declaration tag
* `#DEFINE BUGFIX7C` - Fix Error 7C - 213DH - Space after TAB token
* `#DEFINE BUGFIX8` - Fix Error 8 - 1009H - PRINT USING, - sign at end of field
* `#DEFINE BUGFIX11` - Fix Error 11 - 2301H - Overflow on Integer FOR loop
* `#DEFINE BUGFIX13` - Fix Error 13 - 1222H - Display of Single Precision Numbers

The base ROM can also be customised to hardware.
* `#DEFINE EACA80` - (OPTIONAL) uncomment to enable Dick Smith System-80 (EACA) hardware support.
  This only targets the core 12kb ROM, and does not include the latter Rom extensions

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - (OPTIONAL) Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom

## Make Targets

| Make Target | Description                  | File             | Assembler Defines |
|-------------|------------------------------|------------------|-------------------|
| model14     | Model I Rev 1.4 (Enhanced)   | MDL1REV4.bin     |                   |
| model14eaca | System 80 Rev 1.4 (Enhanced) | MDL1REV4EACA.bin | EACA80            |

## Bug Fixes

See [BugFixes](BUGFIXS.md)

## Cassette Support

Cassette support has been removed to make way for new features

Cassette was chosen for removal since many modern devices exist to provide mass storage, 
cassette would seem to be the least used medium.

In an ideal world you would have Bank switched ROM, and could switch back to the traditional ROM 
when needing cassette. Otherwise the traditional ROM's, (with minimal fixes) still exist
for cassette users

The following has been changed / removed
* CLOAD - loadig program from cassette will cause `SN Error`
* CSAVE - saving program to cassette will cause `SN Error`
* SYSTEM - binary file loading will cause `SN Error`, only `/nnnnn` is supported
* PRINT #-1 - writing to cassette will silently fail, it will be skipped.
* INPUT #-1 - reading from cassette will cause `FD Error`

Machine language programs that use any cassette routines will fail
and potentially cause a system crash.

These changes have been tested on TRS-DOS disk basic without issue

## Free Space

One of the issues with traditional approaches to adding code to the ROMS's
is tailoring code to fit into very small cracks, jumping between the cracks.
This leads to code that is highly coupled and not very maintainable. 

By removing the cassette routines several large regions have opened up.

Any fix/improvement can add its code (to these larger regions) without worrying 
about other code that may exist (or not). This makes it much simpler and easy to maintain

The Model I Rom has 3 large regions of usage space left over from cassette removal

| Region | Address        | Capacity  | Available | Formally             |
|--------|----------------|-----------|-----------|----------------------|
| 1      | $01E9 - $02B1  | 201 bytes | 201 bytes | Cassette IO Routines |
| 2      | $02D7 - $0329  | 82 bytes  | 8 bytes   | SYSTEM Tape Loader   |
| 3      | $2BF5 - $2CA4  | 175 bytes | 55 bytes  | CLOAD CSAVE          |

As at 29/Jan/26 there were 264 bytes free (easily utilised) in the ROM.
Plus another 53 bytes (4 very small regions) which could be utilised 
with some additional effort. (9,10,7,27)

The build output has a listing of the available free space in the ROMS.

| Region | Contents                              |
|--------|---------------------------------------|
| 1      | -nil-                                 |
| 2      | BUGFIX1 thru BUGFIX13, KEYBOUNCE      |
| 3      | MSGSTART, FREHDBT, NEWBOOT, NOMEMSIZE |
