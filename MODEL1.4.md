
# TRS-80 Model 1

## Level 2 ( Revision 1.4 )

This is modernised Level 2 Basic ROM for the Model1
It is based of the Tandy rev 1.3 ROMS with several enhancements
that can be applied. This should be considered 
a successor to the L2 ROM's, but does break some compatibility

Source Code File : [MDL1REV4.Z80](./MDL1REV4.Z80)

> NOTE: For best results view the code with 8 spaces per tab.

## Main Features

Main Features
* Mostly Compilable with Model 1 Level 2 12KB ROMS.
* Patches have been included via `#DEFINE`, and can be removed at user discretion
* The Rom has free space, divided into several areas for extension
* ROM entry points have been maintained as much as possible.
* Lower case suport is embraced where possible.  
* EACA clone hardware supported

Breaking Features
* Cassette Support has been removed, in favour of newer features

## Cassette Support

The following has been changed
* CLOAD - loadig program from cassette will cause `SN Error`
* CSAVE - saving program to cassette will cause `SN Error`
* SYSTEM - binary file loading will cause `SN Error`, only `/nnnnn` is supported
* PRINT #-1 - writing to cassette will silently fail, it will be skipped.
* INPUT #-1 - reading from cassette will cause `FD Error`

Machine language programs that use any cassette routines will fail
and potentially cause a system crash.

It is unknown how disk basic will treat these changes.

## Free Space

The build output has a listing of the available free space in the ROMS.

__TBD__

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.
By default, all of these options are enabled (unless noted), and can individually be disabled. 

There are several enhanced features:
* `#DEFINE FREHDBT` - Enables the FreHD auto boot feature, i.e. the Auto boot ROM. This requires version 1.3
  ROM as a base, please do NOT define `VER12` as it is not compatible (it will be ignored anyway)
  Consider also enabling NMIHARD to ensure reset (on non-floppy machine) will force a reset.
* `#DEFINE NMIHARD` - Set NMI (reset) as always perform a hard reset. Normally on non-floppy systems NMI performs
  a soft reset returning to the `READY>` prompt with the basic program intact. This is useful in system without
  floppy disk to force a full reset (0066h)
* `#DEFINE LOWCASE` - Disable Alpha character translation of letters A-Z,a-z to the values on range 00h to 1Fh.
  This is useful when a lower case mod is installed, but an alternate video driver has not been installed,
  or where the font rom on the machine has the alternate characters in the 00h 1Fh range (0471h)
* `#DEFINE KEYBOUNCE` - Enables the Keyboard debounce routines that where introduced in rev1.3
* `#DEFINE NEWBOOT` - Enables a new boot routine which asks for "diskette?" when no disk is detected and retries. 
  It also allows for break to be pressed at any time. (Credit : John Swiderski)

Bug Fixes Applied
* `#DEFINE BUGFIX1` - Fix Error 1 - 04F6H - 32 Character Mode Line Length
* `#DEFINE BUGFIX5` - Fix Error 5 - 08A7H - INT(DoubleValue) rounding
* `#DEFINE BUGFIX8` - Fix Error 8 - 1009H - PRINT USING, - sign at end of field

The base ROM can also be customised to hardware.
* `#DEFINE EACA80` - (OPTIONAL) uncomment to enable Dick Smith System-80 (EACA) hardware support.

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - (OPTIONAL) Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom

## Bug Fixes

See - [TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm)

