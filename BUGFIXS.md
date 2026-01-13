# Bug Fixes

## Level 2 Basic

Affect both Model I and Model III See - 
[TRS-80 ROM Errors - Vernon Hester](https://www.trs-80.com/sub-rom-bugs.htm) - for further details.

### Error 1 - Line breaks printing numbers in 32 Char Mode

When BASIC prints an unformatted number, it keeps the number on one video,
line. However, in the 32 character mode the rule is violated.

The issue is caused because the variable `LINLEN` ($409D) - which holds the number of
characters per line - is never updated. When entering 32 character mode it retains the value 64.
Thus routines that use this variable, will be affected.

The updating of `LINLEN` was investigated, but this was incompatible with TRSDOS on the Model III which
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

On the Model III the fix is almost identical except the shadow control port is `SHADEC`
($4210) and the mask used is `SHADM32` ($04)

This fix requires 11 extra bytes.

#### Test Program

The following test program should display numbers without line breaks

```
10 CLS:PRINT CHR$(23);
20 FOR X = 12345 TO 12360:PRINT X;:NEXT
```

### Error 2 - Random Number Overrun

A problem exists with random number generation, where it is possible to overrun
and produce a value out of bounds. The following produces `257`.

```
10 POKE 16554,2: POKE 16555,15: POKE 16556,226
20 PRINT RND(256)
```

**NOTE:** that the POKE's setup a random number seed which could take
several million iterations to obverse the bug. This is **highly dependant**
on the **number seed** setup during startup, which is based on Z80 R register

The actual problem exists in the function `RND(0)`, which `RND(n)` is derived from. 
The following produces a result of `1` which violates the rule that: `0 < result < 1`

```
10 POKE 16554,2: POKE 16555,15: POKE 16556,226
20 PRINT RND(0)
```

#### Investigation

You should refer to [Error 13](#error-13---display-of-single-precision-numbers) (below)
for a in-depth discussion of the underlying problem.

Debugging the execution of `RND(0)` (using basic program above) the result 
after `RND(0)` has completed (in the ACCumulator at `$4121`) has the bytes `FF FF 7F 80` 
which clearly extends past the formal 6 digits, leaving a large remaining fraction

Truncating this number (while debugging) by removing the last 3 bits
of the signed number i.e. `F8 FF 7F 80` corrects the issue, and a valid 
random numer `0.999999` is printed in BASIC

This Test program was used to understand the numerical rounding aspects

```
30 POKE 16554,2: POKE 16555,15: POKE 16556,226
40 Z! = RND(0)
41 Y#=Z!
42 X!=Y#
48 PRINT
49 PRINT "= RND(0)"," -> DBL",," -> SNG"
50 PRINT Z!   ,Y#   ,X!
51 PRINT Z!/9!;"(/9)",Y#/9#,X!/9!;""
52 PRINT
60 POKE 16554,2: POKE 16555,15: POKE 16556,226
69 PRINT "= RND(256)"
70 PRINT RND(256)," ( RND(256) -> CINT(RND(0)*256)+1 )"
99 PRINT
```

#### Resolution

The last line of the RND(0) function at address `153Eh`, is a `jp 0765H` instruction to
a routine (NORMAL) which completes the generation of the number, before returning.
So to fix, replace with a JUMP to the following code:

```
 	call NORMAL	    ; Call normalise then apply fixes
SINGLEFIX:
	GETYPE          ; gettype in accumulator
	ret	nc		    ; ignore doubles
	ld	a,(FACLO)   ; the LSB's of the ACC
	and	$F8		    ; zero out the lower 3 bits
	ld	(FACLO),a   ; write the updated value
	ret
```

#### Test Program

The following test program is a good candidate for stress test the RND(n) funtion
to see if it will break over time.

```
5 I=0
10 FOR L% = 1 to 5000 : X%=RND(256)
20 IF X%<1 OR X%>256 THEN PRINT X%,I,L%:STOP
30 NEXT L%
40 I=I+5000
50 PRINT USING "###,###,###";I
60 GOTO 10
```

And the following is a graphical sanity check for the distribution of numbers
to ensure any changes haven't broken a random distribution

```
5 CLS
10 DIM Z%(128)
20 X%=RND(128)-1
30 Z%(X%) = Z%(X%) + 1
40 SET (X%,Z%(X%))
60 GOTO 20
```

### Error 5 - INT(DoubleValue) rounding issue

INT(value) should produce a result equal to or less than value.
However, if the value is double-precision (by definition), the ROM rounds value
to single-precision first, then performs the INT function. e.g.

```
PRINT INT(2.9999999) 
3
```
Should produce `2`. It is cased because single precision rounding, rounds up.

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

The fix requires 9 extra bytes.

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

The solution then is to remove the additional `(` leaving just `TAB`
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
`TAB 10 ) ` when in-fact the previous intention it shoudl have been ` TAB( 10 )`
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

The fix requires 6 extra bytes.

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

A `PRINT USING` statement with a negative sign at the end of the field prints
a negative sign after negative numbers and prints a space for positive numbers.
However, if the field specifiers in the string also has two asterisks at the
beginning of the field, the ROM prints an asterisk instead of a space after a
positive number.

```
PRINT USING "**####-";1234
```

Produces `**1234*` instead of `**1234-`

#### Resolution

Address 1009 Change instruction `LD B,C` to a `NOP`

### Error 11 - Overflow on Integer FOR loop

`FOR NEXT` loops with valid integer values should complete without error 
i.e. The following should not produce an overflow error.

```
FOR J% = 0 TO 30000 STEP 5000 : PRINT J%; : NEXT J%
?OV Error
```

#### Resolution

The overflow error occurs (as explicitly not handled) when adding the `STEP` value to the loop variable
causing an Integer (-32768 to 32767 ) overflow. This is easy to produce with large `STEP` values.

The code issue is found in Code from address `22F9H` to `2301H` where the loop variable is advanced.
This code is part of the `NEXT` loop processing

```
    call    IADD        ;22f9 - ADD the loop and STEP integer values
    ld      a,(VALTYP)  ;22fc - Get value type of result
    cp      VTSNG       ;22ff - Is it Single Precision
    jp      z,OVERR     ;2301 - **** Jump to OVERFLOW Error
```

In BASIC code a FOR NEXT loop using Integer `%` variable must be specified using only Integer values.
The execution of the FOR statement itself will fail for any `TO` or `STEP` values that fall outside this range.

Thus, if the addition `call IADD` produces a single precision then by definition
the loop itself has exceeded its bounds and should complete normally, proceeding the statement
following the `NEXT`.
This can be achieved by replacing the instruction at `2301H` with a `jp z,INTNXTOVER`

```
INTNXTOVER:
	pop	    hl      ; restore the loop variable pointer (2305)
	pop	    hl      ; restore the for entry pointer (2309)
	ld	    bc,6    ; need to consume 6 more bytes off the stack
	add	    hl,bc   ; which is passed as HL into the next routine
	jp	    LOOPDN  ; Normal NEXT completion of loop - 2324H   
```

The code above is responsible for winding back the stack pointer address which it passes in `HL`
to the `LOOPDN` routine.

The fix requires 9 extra bytes

#### Test Program

The following test program should not fail with `OV Error`

```
10 FOR J% = 0 TO 30000 STEP 5000
20 PRINT J%;
30 NEXT J%
```

### Error 13 - Display of Single Precision Numbers

In base 10, rounding to k-digits examines digit k+1. If digit k+1 is 5 through 9, 
then digit k is adjusted up by one and carries to the most significant digit, if necessary. 
If digit k+1 is less than 5, then digit k is not adjusted. 
This should not get muddled with the conversion of base 2 to base 10. e.g.

```
PRINT 4/9
```

Four divided by nine should be: `.444444` and not `.444445`

#### Investigation

Debugging the execution of the program, the printing of the value has to call the 
Floating Point to ASCII conversion routine (0FBEh). 

This routine is quite long as it deals with a multitude of different number formatting
but eventually arrives down at a shared routine (1201h) – Normalise Number in Accumulator.

This routine seems responsible for shifting the number to be in range 100,000 to 999,999 i.e. 
Six digits in positive integer range. To do this routine FINMLT (multiply by 10) at 0F0Bh is used. 
The multiply routine uses addition by sequence 1x+1x, 2x+2x, 4x+1x, 5x+5x, to arrive at 10x. 

When this routine is called the value (in the ACCumulator at `$4121`) has the
bytes `39 8E 63 7F`. Noting the `39` indicating a `1` bit in the least significant bit.

Noting: Any of the 3 lowest bits are not required and should be truncated, i.e.
changing the number in the accumulator to `38 8E 63 7F` ( `39 AND F8` ), 

To test this a Breakpoint was set at `1222h` (after a SINGLE value is detected), 
the value (in the ACCumulator at `$4121`) changed to `38` then when the display routine 
completes the display of the number correctly shows as:

```
 .444444
```

#### Underlying Cause

Single precision numbers in Level 2 BASIC occupy 3 bytes for the mantissa, of which one bit is the sign.
Thus there are 23 bits available where only 20 bits are actually required. The extra three bits are
still stored and used in computation and display purposes. 

Issues seem to relate to the handling of these extra bits, specifically as it relates to
the extra bits causing rounding issues during any computation.

As already seen the display routines themselves truncate with rounding Single Prevision values

#### Resolution

At 1222h replace the `call FOUNVC` with a `jp FOUNDBFIX` - to the routine below

```
FOUNDBFIX:
	call	SINGLEFIX	; apply the fix - See BUGFIX 2 for this routine
	call	FOUNVC		;1222 - compare the ACCumulator to 999999.5
	jp	    FOUNDV1		; continue
```

#### Test Program

A test program shows the issues

``` 
10 D#=4#/9#
11 S!=D#
12 R#=S!
19 CLS
20 PRINT "= 4/9#              -> SNG    -> DBL"
21 PRINT D#   ;S!   ;R#
22 PRINT D#/4#;S!/4!;R#/4#;" (/4)
30 S5$= "0.99999!"
31 S6$= "0.999999!"
32 S7$= "0.9999999!"
34 D8$= "0.99999999#"
35 D9$= "0.999999999#"
39 PRINT
40 PRINT "String Input","VAL(str)","CSNG(val)","INT(val)"
41 PRINT S5$,VAL(S5$),,INT(VAL(S5$)); " SNG"
42 PRINT S6$,VAL(S6$),,INT(VAL(S6$)); " SNG"
43 PRINT S7$,VAL(S7$); " (*1)",,INT(VAL(S7$)); " SNG" 
44 PRINT D8$,VAL(D8$),CSNG(VAL(D8$)) ; " (*2)",INT(VAL(D8$)); " DBL"
45 PRINT D9$,VAL(D9$),CSNG(VAL(D9$)) ; " (*2)",INT(VAL(D9$)); " DBL"
50 PRINT "      *1 rounded up during display"
51 PRINT "      *2 rounded up during conversion to Single"
```

## Model III

The following are Specific to Model III, typically related to issue's porting code from Model I

### Error 27 (29, 31) - Basic Entry Point

On the Model I The routine located at 06CCH contains the correct entry 
point to BASIC from a machine language routine that moved the stack pointer.
The routine resets the stack pointer to the last CLEAR n address

```
    ld  bc,1A18H
    jp  19AEH
```

The Model III does not have this routine, 06CCH is in the middle of the 
Model III 's modified list routine. This causes compatibility issues 
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

05D1H: The Printer Status Routine - carried over from Model I is broken
Rumor has it that this is a malicious destruction of the
"printer ready" function was used to hide the name "RON"
See 044BH which has the correct implementation. It is a relatively easy
fix to reinstate the correct code
