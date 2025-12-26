
# TRS-80 Model 1

## Level 2 Source Code

Source Code File : [MDL1LEV2.Z80](./MDL1LEV2.Z80)

> NOTE: For best results view the code with 8 spaces per tab.

## Main Features

Main Features
* Fully Compilable Source Code for Model 1 Level 2 12KB ROMS.
* Both 1.3 and 1.2 versions, plus EACA clone hardware.
* Several optional patches have been included via `#DEFINE`

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.
By default, the build will create a Version 1.3

The base ROM version can be defined.
* `#DEFINE VER12` - uncomment this to degrade from V1.3 to V1.2 of the ROM.
* `#DEFINE VER13` - this is the default if VER12 is not defined, and doesnt need to be uncommented
* `#DEFINE EACA80` - uncomment to enable Dick Smith System-80 (EACA) hardware support.
  NOTE: While not mandatory you should also define `VER12` since the System-80 ROM was based on V1.2.
  V1.3 has not been formally tested, but assume should work, and opens ability to also specify `FREHDBT`.
  This only targets the core 12kb ROM, and does not include the latter Rom extensions
 
There are several optional features.
* `#DEFINE FREHDBT` - Enables the FreHD auto boot feature, i.e. the Auto boot ROM. This requires version 1.3
  ROM as a base, please do NOT define `VER12` as it is not compatible (it will be ignored anyway)
  Consider also enabling NMIHARD to ensure reset (on non-floppy machine) will force a reset.
* `#DEFINE NMIHARD` - Set NMI (reset) as always perform a hard reset. Normally on non-floppy systems NMI performs
  a soft reset returning to the `READY>` prompt with the basic program intact. This is useful in system without
  floppy disk to force a full reset (0066h)
* `#DEFINE LOWCASE` - Disable Alpha character translation of letters A-Z,a-z to the values on range 00h to 1Fh.
  This is useful when a lower case mod is installed, but an alternate video driver has not been installed,
  or where the font rom on the machine has the alternate characters in the 00h 1Fh range (0471h)

Bug Fixes can be applied
* `#DEFINE BUGFIX5` - Fix Error 5 - 08A7H - INT(DoubleValue) rounding
* `#DEFINE BUGFIX8` - Fix Error 8 - 1009H - PRINT USING, - sign at end of field

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom

VERY Experimental - use at your own risk
* `#DEFINE _EMBED` - Strip all HW, and IO routines leaving just BASIC language as standalone code
  and used in L2 Basic for CP/M

## Bug Fixes

See - [TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm)

