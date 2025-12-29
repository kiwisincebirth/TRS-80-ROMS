# Bug Fixes

## Level 2 Basic

Affect both Model 1 and Model 3 See - 
[TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm) - for further details.

### Error 1 - Line breaks printing numbers in 32 Char Mode

When BASIC prints an unformatted number, BASIC prints keeps the number on one video,
line. However, in the 32 character mode the rule is violated.

#### Resolution

**TODO**

This fix requires **todo** bytes 

Test Program -> Should display number without breaks

```
10 CLS:PRINT CHR$(23);
20 FOR X = 12345 TO 12350:PRINT X;:NEXT
```

### Error 5 - INT(DoubleValue) rounding issue

EXPECTATION: INT(value) should produce a result equal to or less than value.
However, if the value is double-precision (by definition), the ROM rounds value
to single-precision first, then performs the INT function. e.g.

```
PRINT INT(2.9999999) 
```
Produces `3` instead of `2`.

#### Resolution

Address 08A7 change `CALL NC,CONSD` to `NOP`'s

### Error 7 - Space after Type declaration Tag

When processing a statement with a type declaration tag after a number and a space before :
* 7A - An add or subtract -> the operator is applied as a unary operator for next argument
* 7B - A multiply or divide -> Syntax error.

#### Resolution

**TODO** Need to write this up


Test Program -> Should consistently display a single result - regardless of the spaces

```
5 N=3
10 PRINT 2#+N
11 PRINT 2# +N
12 PRINT 2#+ N
20 PRINT 2# + N
30 PRINT 2#*N
31 PRINT 2# *N
32 PRINT 2#* N
40 PRINT 2# * N
50 PRINT 2#-N
51 PRINT 2# -N
52 PRINT 2#- N
60 PRINT 2# - N
70 PRINT 2#/N
71 PRINT 2# /N
72 PRINT 2#/ N
80 PRINT 2# / N
```



### Error 7C - Space after TAB declaration

**TODO** Need to write this up

#### Resolution

Test Program -> Should consistently display `Hello` tabbed by 10

```
10 REM Spaces between brackets
11 PRINT TAB(10);"Hello"
12 PRINT TAB(10 );"Hello"
13 PRINT TAB( 10);"Hello"
14 PRINT TAB( 10 );"Hello"
20 REM No Brackets with spaces around the 10
21 PRINT TAB 10 ;"Hello"
22 PRINT TAB10 ;"Hello"
23 PRINT TAB 10;"Hello"
24 PRINT TAB10;"Hello"
30 REM Handle training ) for legacy code
31 PRINT TAB(10));"Hello"
32 PRINT TAB10);"Hello"
40 REM Spaces between brackets COMMA
41 PRINT TAB(10),"Hello"
42 PRINT TAB(10 ),"Hello"
43 PRINT TAB( 10),"Hello"
44 PRINT TAB( 10 ),"Hello"
```

### Error 8 - PRINT USING, sign at end of field

RULE: A PRINT USING statement with a negative sign at the end of the field prints
a negative sign after negative numbers and prints a space for positive numbers.
However, if the field specifiers in the string also has two asterisks at the
beginning of the field, the ROM prints an asterisk instead of a space after a
positive number.

```
PRINT USING "**####-";1234
```

Produces `**1234*` instead of `**1234-`

#### Resolution

Address 1099 Change instruction `LD B,C` to a `NOP`

## Model 3

The following are Specific to Model 3, typically related to issues porting code from Model 1

### Error 27 (29, 31) - Basic Entry Point

Location 0072H: Instruction here is JP 06CCH. Location 06CCH on the
Model I contained the correct entry to BASIC from a machine language
routine that moved the stack pointer. On the Model III, 0072H still has
the instruction JP 06CCH; however, that is in the middle of the Model III's
modified list routine.

This is a bona fide screw up that was never fixed.

#### Resolution

This actually Fixes a number of reported issues (27, 29, 31)
which all relate to the 06CCh BASIC entry point being incorrectly
removed from the Model III. It may also improve compatibility
for third party software that expects this entry point

To implement this the routines at $06CC were reinstated and code 
in this location rellocated to startup messages, truncated to:

```
Mem Size?
R/S Model 3 Basic
```

### Error 28 - Stack Pointer Initialisation

Instruction at 02B5H is LD SP,4288H. The instruction here was changed
to LD SP,4388H because the Model III moved up the start of BASIC by 100H.

### Error 30 - 32 Character Mode

0348H: Instruction here is LD A,(403DH). 403DH is the code that
is jumped to when port 0E0H has bit 3 reset (IOBUS interrupt).
403DH was used in the Model I to hold an image of what was outputted
to port 0FFH. If bit 3 of port 0FFH is set then the Model I is in the
32 characters per line video mode. Another screw up.
The Model III uses bit 2 of port 0ECH with image in 4210H.

034BH: Instruction here is AND 08H. Wrong bit is tested. The correct
instruction should be AND 04H. OP-ED: Once Radio Shack explained the
cursor movement when in the 32 characters per line video mode, Radio
Shack did not fix the code. And, Radio Shack made Logical Systems modify
TRSDOS 6 to behave the same way! However, with LSDOS 6.3, someone should
have had the guts to correct the code.

### Error 40 - Printer Status Routine

05D1H: The Printer Status Routine - carried over from Model 1 is broken
Rumor has it that this is a malicious destruction of the
"printer ready" function was used to hide the name "RON"
See 044BH which has the correct implementation. It is a relatively easy
fix to reinstate the correct code
