
# TRS-80 Model III

## Level 2 (Revision 1.4)

This is modernised Level 2 Basic ROM for the Model III.
It is based of the Tandy (V3 Rev C 1981) ROMS with several enhancements
that can be applied. This should be considered
a successor to the L2 ROM's, but does break some compatibility

Source Code File : [MDL3REV4.Z80](./MDL3REV4.Z80)

> NOTE: For best results view the code with 8 spaces per tab.

## Main Features

Main Features
* Mostly Compilable Source Code for Model III Level 2 14KB ROMS.
* Patches have been included via `#DEFINE`, and can be removed at user discretion
* The Rom has free space, divided into several areas for extension
* ROM entry points have been maintained as much as possible.

Breaking Features
* Cassette Support WILL (in future as required) be removed, in favour of newer features

## Make Targets

| Make Target | Description      | File           | Assembler Defines |
|-------------|------------------|----------------|-------------------|
| model34     | Model III        | MDL3REV4.bin   |                   |
| model3450   | Model III (50Hz) | MDL3REV450.bin | VIDEO50           |

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.
By default, **ALL** of these options are enabled (unless OPTIONAL), and can individually be disabled.

There are several enhanced features:
* `#DEFINE FREHDBT` - Enables the FreHD auto boot ROM feature, ie load fre HD at start

Bug Fixes Applied
* `#DEFINE BUGFIX1` - Fix Error 1 - 04F6H - 32 Character Mode Line Length
* `#DEFINE BUGFIX2` - Fix Error 2 - 153EH - Random Number Single Precision Overrun
* `#DEFINE BUGFIX5` - Fix Error 5 - 08A7H - INT(DoubleValue) rounding issue
* `#DEFINE BUGFIX7` - Fix Error 7 - 0EF2H - Space after type declaration tag
* `#DEFINE BUGFIX7C` - Fix Error 7C - 213DH - Space after TAB token
* `#DEFINE BUGFIX8` - Fix Error 8 - 1009H - PRINT USING, - sign at end of field
* `#DEFINE BUGFIX11` - Fix Error 11 - 2301H - Overflow on Integer FOR loop
* `#DEFINE BUGFIX13` - Fix Error 13 - 1222H - Display of Single Precision Numbers
* `#DEFINE BUGFIX27` - Fix Error 27 - 06CCH - Basic Entry Point. Also Fixes 29, 31.
* `#DEFINE BUGFIX28` - Fix Error 28 - 034BH - Stack Initialisation Problem
* `#DEFINE BUGFIX30` - Fix Error 30 - 034BH - 32 char Mode, Incompatible Model I code
* `#DEFINE BUGFIX32` - Fix Error 32 - 0176H - SET should place a graphic on screen
* `#DEFINE BUGFIX40` - Fix Error 40 - 05D1H - Broken "RON" Printer Status Routine

And some smaller improvements
* `#DEFINE MSGSTART` - Enhanced Startup Message

The base ROM can also be customised to hardware.
* `#DEFINE VIDEO50` - (OPTIONAL) Enable 50Hz Video Support (Affects RTC)

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - (OPTIONAL) Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom

## Bug Fixes

See [BugFixes](BUGFIXS.md)

## Cassette Support

Cassette support has been removed to make way for new features

The following has been changed / removed
* CLOAD - loadig program from cassette will cause `SN Error`
* CSAVE - saving program to cassette will cause `SN Error`
* SYSTEM - binary file loading will cause `SN Error`, only `/nnnnn` is supported
* PRINT #-1 - writing to cassette will silently fail, it will be skipped.
* INPUT #-1 - reading from cassette will cause `FD Error`
* Cassette? startup prompt has been removed

Machine language programs that use any cassette routines will fail
and potentially cause a system crash.

These changes have been tested on TRS-DOS disk basic without issue

## Free Space

The Model III ROM has 5 main regions of usage space left over from cassette removal

| Region | Address       | Capacity  | Available | Formally             |
|--------|---------------|-----------|-----------|----------------------|
| 0      | $0232 - $0266 | 52 bytes  | 52 bytes  | Misc Cassette        |
| 1      | $02D7 - $032A | 83 bytes  | 27 bytes  | SYSTEM Tape Loader   |
| 2      | $2BF5 - $2CA4 | 176 bytes | 153 bytes | CLOAD CSAVE          |
| 3      | $3145 - $338D | 489 bytes | 489 bytes | Cassette IO Routines |
| 4      | $37AF - $37DC | 45 bytes  | 5 bytes   | Cassette?            |

As at 14/Jan/26 there were 672 bytes free (easily utilised) in the ROM.
Future removal of the Printer Translation table could free an additional 96 bytes.

The build output has a listing of the available free space in the ROMS.

| Region | Contents              |
|--------|-----------------------|
| 0      | -nil-                 |
| 1      | BUGFIX1 thru BUGFIX13 |
| 2      | FREHDBOOT             | 
| 3      | -nil-                 |
| 4      | MSGSTART, BUGFIX27    | 
