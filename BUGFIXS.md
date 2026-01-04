# Bug Fixes

## Level 2 Basic

Affect both Model 1 and Model 3 See - 
[TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm) - for further details.

### Error 1 - Line breaks printing numbers in 32 Char Mode

When BASIC prints an unformatted number, it keeps the number on one video,
line. However, in the 32 character mode the rule is violated.

The issue is caused because the variable `LINLEN` ($409D) - which holds the number of
characters per line - is never updated. When entering 32 character mode it retains the value 64.
Thus routines that use this variable, will be affected.

The updating of `LINLEN` was investigated, but this was incompatible with TRSDOS on the Model 3 which
used this memory space for other purposes, only initializing it when launching BASIC.

#### Resolution

The fix requires ignores the `LINLEN` variable, instead derives it from the shadow cassette port.

The instruction at `ld a,(LINLEN)` at address $20DD needs to be replaced with a 
`call DSPLINLTH` (below) to get the correct line length, this fixes the issue.
The new routine being called is.

```
DSPLINLTH:
    ld  a,(CAST)    ; get shadow copy of Cassette port
    and CAST32      ; check if 32 char mode
    ld  a,64        ; assume 64 line length
    ret z           ; flag not set so return the 64
    srl a           ; set 32 line length
    ret             ; and return it.
```

On the Model 3 the fix is almost identical except the shadow control port is `SHADEC`
($4210) and the mask used is `SHADM32` ($04)

This fix requires 11 bytes.

#### Test Program

The following test program should display numbers without line breaks

```
10 CLS:PRINT CHR$(23);
20 FOR X = 12345 TO 12360:PRINT X;:NEXT
```

### Error 5 - INT(DoubleValue) rounding issue

INT(value) should produce a result equal to or less than value.
However, if the value is double-precision (by definition), the ROM rounds value
to single-precision first, then performs the INT function. e.g.

```
PRINT INT(2.9999999) 
```
Produces `3` instead of `2`, because single precision rounding, rounds up.

#### Resolution

Address 08A7 change `CALL NC,CONSD` to `NOP`'s

### Error 7 - Space after Type declaration Tag

In BASIC spaces have no significance (except in messages to be printed).
When processing a statement with a type declaration tag after a number and a space before :
* 7A - An add or subtract -> the operator is applied as a unary operator for next argument
* 7B - A multiply or divide -> Syntax error.

#### Resolution

Modify the ROM to skip spaces after consuming the suffix, advancing HL past them.
Replacing the following code ($0EF2)

```
INFINE:
    inc hl
    jr  FINE
```

With the instruction `jp INFINEFIX` which jumps to the following routine

```
INFINEFIX:
    inc hl          ; next program byte
    ld  a,(hl)      ; get program byte
    cp  SPACE       ; Is it a space
    jp  nz,FINE     ; NO - Exit and Continue
    jr  INFINEFIX   ; loop around
```
The fix requires 9 extra bytes

#### Test Program

The following test program should consistently display a single result - regardless of the spaces

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

In BASIC spaces have no significance (except in messages to be printed).
When processing a statement with a type declaration tag after a number and a space before :
* 7C - TAB( also suffers from the issue.

i.e. `PRINT TAB( 63);"*";` will function correctly. However `PRINT TAB (63);"*";` 
will print the 63rd element of an array named TAB.

#### Resolution

The Token used for TAB includes the `(` as part of the token. The token is actually `TAB(`.
The parser is not capable of handling the extra space. 
The interesting thing is no other functions include a `(` in their token. i.e. 
the token for the function PEEK has no `(` and does not suffer from the same issue as TAB

The solution then is to remove the additonal `(` leaving just `TAB`
The interpreter will just parse the expression following the TAB keyword
and if the expression is ` ( 63 )` - spacing not to important it will correctly 
parse the number consuming both brackets. 

Two changes are required
* Remove the `(` character from the TAB token in the keyword list - $1752 
* Add a padding byte at the end of the reserved keyword list. $1821
* Code at $213D that consumes the trailing `)` needs to be commented.

There is one issue:

When an existing program is loaded (pre-tokenised) form there will be an issue
with trailing `)`. Thus the program read would be interpreted as
`_TAB_10_)_` when infact the previous intention it shoudl have been `_TAB(_10_)_`
This is a result of the brackets not matching, ie the is an implicit `(` in the
TAB token.

Thus for backwards compatibility we need to consume a trailing `)` is it exists
To do this the code 

```
    SYNTAX  (')')   ;213d - rst 08h
    dec     hl      ;213f - decrement back, will consume latter
```

needs to be replaced with a `CALL` to

```
TABERFIX:
    GETCHR      ; get next char RST 10
    cp  ')'     ; if close bracket
    ret z       ; found closing bracket, continue normally
    dec hl      ; not a closing bracket, so DONT consume it.
    ret
```

#### Test Program

The following test program should consistently display `Hello` indented by 10 spaces

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

On the Model 1 The routine located at 06CCH contains the correct entry 
point to BASIC from a machine language routine that moved the stack pointer.
The routine resets the stack pointer to the last CLEAR n address

```
    ld  bc,1A18H
    jp  19AEH
```

The Model 3 does not have this routine, 06CCH is in the middle of the 
Model 3's modified list routine. This causes compatibility issues 
and additionally code itself in the ROM is incorrect
* Bug 27 - Location 0072H: Instruction here is an incorrect `jp 06CCH` 
* Bug 29 - Location 02C3H: Instruction here is an incorrect `jp 06CCH` 

In Model III BASIC, key SYSTEM ENTER then, at the *? prompt, press BREAK.
If you do this, the system will crash and restart, and you will get the CASS prompt.

#### Resolution

Re-implement (reinstate) the routine at 06CCH and code in this location 
relocated. By reinstating this code all other issues are resolved including any
issues in "other" code that relies on this entry point.

This fix requires 12 bytes for the relocated code

### Error 28 - Stack Pointer Initialisation

Instruction at 02B5H is `LD SP,4288H`. The instruction here was changed
to `LD SP,4388H` because the Model III moved up the start of BASIC by 100H.

### Error 30 - 32 Character Mode

0348H: Instruction here is `ld a,(403DH)`. 403DH is the code that
is jumped to when port 0E0H has bit 3 reset (IOBUS interrupt).
403DH was used in the Model I to hold an image of what was outputted
to port 0FFH. If bit 3 of port 0FFH is set then the Model I is in the
32 characters per line video mode. Another screw up.
The Model III uses bit 2 of port 0ECH with image in 4210H.

034BH: Instruction here is `and 08H`. Wrong bit is tested. The correct
instruction should be `and 04H`. OP-ED: Once Radio Shack explained the
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
