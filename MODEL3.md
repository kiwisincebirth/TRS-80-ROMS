
# TRS-80 Model III

## Level 2 Source Code

Source Code File : [MDL3LEV2.Z80](./MDL3LEV2.Z80)

> NOTE: For best results view the code with 8 spaces per tab.

## Main Features

Main Features
* Fully Compilable Source Code for Model III Level 2 14KB ROMS.
* Several optional patches have been included via `#DEFINE`

This source code is based on the following ROM revisions

| ROM | Checksum | Part Num  | Notes             |
|-----|----------|-----------|-------------------|
| A   | 9639     | 8041364   | Standard ROM A    |
| B   | 407C     | 8040332   | Standard ROM B    |
| C   | 2EF8     | 8040316B  | V3 - Rev C - 1981 |

## Make Targets

| Make Target | Description                    | File       | Assembler Defines     |
|-------------|--------------------------------|------------|-----------------------|
| model3      | Model III (Official)           | MDL3.bin   |                       |
| model3p     | Model III - Patched            | MDL3P.bin  | PATCH                 |
| model3f     | Model III - FreHd Patched      | MDL3F.bin  | PATCH FREHDBT         |
| model3p50   | Model III - Patched 50Hz       | MDL3P5.bin | PATCH VIDEO50         |
| model3f50   | Model III - FreHd Patched 50Hz | MDL3F5.bin | PATCH VIDEO50 FREHDBT |

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.

There are some options to define the base ROM
* `#DEFINE VIDEO50` - Enable 50Hz Video Support (Affects RTC)

There are several optional features.
* `#DEFINE FREHDBT` - Enables the FreHD auto boot ROM feature, ie load fre HD at start
* `#DEFINE FASTMEM` - Speed up startup memory size check by checking first byte of every 256 page,
  rather than every byte.

Bug Fixes can be applied
* `#DEFINE BUGFIX5` - Fix Error 5 - 08A7H - INT(DoubleValue) rounding issue
* `#DEFINE BUGFIX8` - Fix Error 8 - 1009H - PRINT USING, - sign at end of field
* `#DEFINE BUGFIX28` - Fix Error 28 - 034BH - Stack Initialisation Problem
* `#DEFINE BUGFIX30` - Fix Error 30 - 034BH - 32 char Mode, Incompatible Model I code
* `#DEFINE BUGFIX40` - Fix Error 40 - 05D1H - Broken "RON" Printer Status Routine

And the following grouped define
* `#DEFINE PATCH` - Includes `FASTMEM` and `BUGFIX5` thru `BUGFIX40`

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom

## Bug Fixes

See [BugFixes](BUGFIXS.md)
