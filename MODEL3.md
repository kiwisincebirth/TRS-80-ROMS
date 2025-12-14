
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
| C   | 2EF8     | 8040316B  | v2 - Rev B - 1980 |

## Build Options

There are several `DEFINE`'s that can be set in the code (very start) to enable certain features.

There are some options to define the base ROM
* `#DEFINE VIDEO50` - Enable 50Hz Video Support (Affects RTC)

There are several optional features.
* `#DEFINE FREHDBT` - Enables the FreHD auto boot ROM feature, ie load fre HD at start

Bug Fixes can be applied
* `#DEFINE BUGFIX5` - Fix Bug 5 - 08A7H - INT(DoubleValue) rounding issue
* `#DEFINE BUGFIX27` - Fix Bug 27 - 06CCH - Basic Entry Point. Also Fixes 29, 31.
* `#DEFINE BUGFIX28` - Fix Bug 28 - 034BH - Stack Initialisation Problem
* `#DEFINE BUGFIX30` - Fix Bug 30 - 034BH - 32 char Mode, Incompatible Model 1 code
* `#DEFINE BUGFIX40` - Fix Bug 40 - 05D1H - Broken "RON" Printer Status Routine

Some additional defines, which are build options rather than features
* `#DEFINE SIZE16K` - Will pad the end of the rom with $FF to 16KB size. useful if want to append multiple ROM
  images for used in large 16K paged rom
* `#DEFINE DONTEND` - Disable `.END` directive if `#INCLUDE`ing the source inside another file.

## Bug Fixes

See - [TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm)

### BugFix 27

This actually Fixes a number of reported issues (27, 29, 31)
which all relate to the 06CCh BASIC entry point being incorrectly 
removed from the Model III. It may also improve compatibility 
for third party software that expects this entry point

To Implement this the Startup messages were truncated to:

```
Mem Size?
R/S Model 3 Basic
```
