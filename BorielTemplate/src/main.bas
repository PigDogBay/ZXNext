' Set up ORG, HEAP and OPTIMIZE in build.py
' 
' Forum https://www.boriel.com/forum
' Documentation https://zxbasic.readthedocs.io/en/docs
' Facebook Group https://www.facebook.com/groups/1138577884066191

cls:paper 0:ink 7
do
    PRINT "HELLO WORLD!   ";
loop

' Variables
DIM lives as UByte = 3
DIM position as Integer 
DIM score as ULong
DIM message, status as String
DIM x,y,z as Fixed           '4 byte float
DIM specRomFloat as Float    '5 byte float
DIM pointerUDG as UInteger AT 23675

score = CAST(Uinteger, lives) * 100

status = "Message: " + message
message(2) = "X"
PRINT message(2 to 6)


' Arrays
' Note that 8 is index of last element, so array is of size 9 (crazy)
DIM fib(8) AS UByte => {1,1,2,3,5,8,13,21,34}
DIM weekDays as String 
weekDays(0) = "Monday"

DIM copy(8) as UByte
copy = fib

DIM grid(16,12) AS UByte
grid(0,0) = 42


' Conditionals
IF score>1000 THEN
    PRINT "Next Level"
ELSEIF score>2000 THEN
    PRINT "Bonus life"
ELSE
    PRINT "Try again"
END IF

DIM bool AS UByte          '0 - False
IF bool THEN PRINT "TRUE"

DIM pos as UInteger
IF (pos > 10 AND pos < 20) OR pos = 42 THEN 
    PRINT "In range"
END IF



' Loops
loop_g:
    GOTO loop_g

DIM i as UByte
FOR i = 0 TO 20 STEP 5
    PRINT i
    EXIT FOR
NEXT i

DIM col as UInteger
WHILE INKEY$=""
    BORDER col : col = col + 1
    EXIT WHILE
    CONTINUE WHILE
WEND

DO
    CLS : PRINT"FLASHY"
LOOP

DO UNTIL x>42
    EXIT DO
LOOP

DO WHILE x<42
    EXIT DO
LOOP



' Subrtoutines
SUB printLocal()
    DIM a AS UByte = 42
    PRINT "Local variable: "; a
END SUB

SUB printText(text AS String, col AS UByte)
    INK col : PRINT text
END SUB


' Functions return values and need to be declared
DECLARE FUNCTION mult(a AS Integer, b AS Integer) AS Integer
FUNCTION mult(a AS Integer, b AS Integer) AS Integer
    RETURN a*b
END FUNCTION


' Assembly
SUB changeColour(newColour AS UByte)
    ASM
        ld hl,$5800
        ld (hl),a          ; newColour parameter is in register a
        ld de,$5801
        ld bc,767
        ldir
    END ASM
END SUB


' Multiple parameters use ix+5 to ix+9, for UByte just use relevant first index
FUNCTION getScrAttribute(x AS UByte, y as UByte) AS UByte
    ASM
        ld hl,$5800
        ld a,(ix+7)        ; Parameter y (ix+7 and ix+8)
        ld b,a   
        ld de,32
CalcY:        
        add hl,de  
        djnz CalcY
        ld a,(ix+5)        ; Parameter x (ix+5 and ix+6)
        ld d,0
        ld e,a
        add hl,de  
        ld a,(hl)          ; Return accumulator
    END ASM
END FUNCTION

' FASTCALL saves memory, cannot use local variables
' First parameter: A if UByte, HL if UInteger
' Second parameter: Stored on stack after return address, SP+2
' Third paramter: SP+4
FUNCTION FASTCALL getFastAttribute(x AS UByte, y as UByte) AS UByte
END FUNCTION

DIM varBasic AS UByte
DO
    PRINT AT 0,0;varBasic;"  ";
   ASM
        ld hl,_varBasic          ; Use _ to get varBasic address
        inc (hl)                 ; inc varBasic
   END ASM
LOOP

' I/O
PRINT AT x, y; PAPER 7; INK 2; "[-O-]"

' INKEY$ can only detect one key at a time
IF INKEY$ = "o" THEN 
    PRINT "O"
END IF

#INCLUDE <keys.bas>

IF MultiKeys(KEYO) THEN 
    PRINT "O"
END IF

' Miscellaneous
DIM colour AS UByte
RANDOMIZE 0
x = RND * 30
colour = INT(RND*6)+1

PAUSE 5            ' Wait for 100ms for 50Hz machines

' Directives
#DEFINE MAX_STARS 42

#IFDEF DEBUG
    print("Debug mode")
#ELSE
    print("Release mode")
#ENDIF
