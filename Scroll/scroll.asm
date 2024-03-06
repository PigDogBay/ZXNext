; z80dasm 1.1.6
; command line: z80dasm -a -l -g 59990 -t -o scroll.asm scroll.bin

; This is now set in build.asm 
;	org	0ea56h (59990)

;
; This code will scroll a message along the bottom of the screen 1 pixel at a time
; You will need to periodically call this code to keep scrolling
;

;
; Entry point 
;
;
; First of all need to check how many times the pxiels have been rotated to the left
; If it is 8 times, then need to fetch the the next character of the message
; if not 8 then jump to the code to begin scroll a line of pixels
;	

	ld a,(ROTATIONS)	;ea56	3a c4 ea    Load contents of address ROTATIONS into accumulator
	inc a				;ea59	3c 	        Increase the accumulator
	ld (ROTATIONS),a	;ea5a	32 c4 ea    Load Accumulator into address ROTATIONS      
	cp 008h				;ea5d	fe 08 		Compare the accumulator with 8, subtracts 8 from A and sets Z(zero flag) accordingly
	jr nz,InitScroll	;ea5f	20 2f       Jump if not zero to InitScroll
	ld a,000h			;ea61	3e 00       Set accumulator to 0
	ld (ROTATIONS),a	;ea63	32 c4 ea    Load Accumulator into address ROTATIONS 
	ld hl,(TEXT_PTR)	;ea66	2a c2 ea    Load contents of TEXT_PTR into L, TEXT_PTR+1 into H
	inc hl				;ea69	23          Increase HL by one
	ld (TEXT_PTR),hl	;ea6a	22 c2 ea    Load HL into memory at TEXT_PTR

;
; Get the next character in the message to scroll onto the screen
; If the character is 255 (string terminator) then reset TEXT_PTR 
; to TEXT (start of the message)
;
NextChar:
	ld hl,(TEXT_PTR)	;ea6d	2a c2 ea    Load contents of TEXT_PTR into L, TEXT_PTR+1 into H
	ld a,(hl)			;ea70	7e          Load contents of memory location at HL into A
	cp 0ffh				;ea71	fe ff 	    Compare A with 255 (end of text)
	jr nz,GetPixelData	;ea73	20 08 	    Jump if not zero to label2
	ld hl,TEXT 			;ea75	21 c5 ea    Load HL with address of first character, TEXT
	ld (TEXT_PTR),hl	;ea78	22 c2 ea    Load HL into memory at TEXT_PTR
	jr NextChar			;ea7b	18 f0 	    Jump back to NextChar


;
; System variable CHARS points to the pixel pattern of the character set
; It is 256 bytes less though, which is handy as the first defined char 
; is SPACE which has the ASCII value of 32, 32*8 = 256, nice.
; This section will copy the current char's pixel data into 
; the PIXELS working area
;	
GetPixelData:
	ld h,000h			;ea7d	26 00 	    Load H with 0
	ld l,a				;ea7f	6f 	        Load L with A (current character)
	add hl,hl			;ea80	29 	        Double value of HL
	add hl,hl			;ea81	29 	        Double value of HL
	add hl,hl			;ea82	29 	        Double value of HL
	ld bc,(05c36h)		;ea83	ed 4b 36 5c Load BC with contents of System Variable CHARS
	add hl,bc			;ea87	09 	.       Add BC to HL so HL now pointes to the pixel set for the character
	ld bc,00008h		;ea88	01 08 00    Load BC with 8, as each character is made up of 8 bytes
	ld de,PIXELS		;ea8b	11 ba ea    Load DE with address PIXELS
	ldir				;ea8e	ed b0       Copy the character's 8 bytes of pixel data into the PIXELS working area

;
; Address $50FF is the  top line on pixels for the bottom right character location
;
InitScroll:
	ld de,PIXELS		;ea90	11 ba ea    Load DE with address PIXELS
	ld hl,050ffh		;ea93	21 ff 50    Load HL with address $50ff
	ld b,008h			;ea96	06 08       Load B with 8 as there are 8 lines to scroll


InitLine:
	push bc				;ea98	c5          PUSH BC onto the stack
	ld b,020h			;ea99	06 20       Load B with 32, the screen is 32 chars wide
	jr RotatePIXELS 	;ea9b	18 0d 

;
; rl(HL) will rotate the contents of the memory location pointed to by HL
; rl(HL) will use the Carry Flag as a ninth bit, psuedo micro code:
; 	temporaryFlag = Bit 7 of (HL)
; 	Rotate (HL) left 1 bit
; 	Bit 0 of (HL) = Carry Flag
; 	Carry Flag =  temporaryFlag
;
Scroll: 
	rl (hl)				;ea9d	cb 16      Rotate contents of memory address at HL (screen location) 1 bit left
	dec hl				;ea9f	2b         Point HL to the next character to the left
	djnz Scroll			;eaa0	10 fb      Decrease B register (column count), if not zero jump back to Scroll the next char on the left
	ld bc,00120h		;eaa2	01 20 01   
	add hl,bc			;eaa5	09         Add 256+32 to HL, points to the next lines of pixels of the char at the bottom right
	pop bc				;eaa6	c1         Pop BC off the stack, B contains the count of how many lines are left to scroll
	djnz InitLine		;eaa7	10 ef      If b is not 0, then another line to scroll so jump to InitLine
	ret					;eaa9	c9         Return to BASIC

;
; Rotate 1 byte of the PIXELS working area
; DE will then point to the next byte of PIXELS
;	
RotatePIXELS:
	push hl				;eaaa	e5          Push HL onto the stack
	ex de,hl			;eaab	eb          Exchange contents of DE/HL
	rl (hl)				;eaac	cb 16       Rotate contents of memory address at HL (PIXELS-PIXELS+7) 1 bit left
	ex de,hl			;eaae	eb          Exchange contents of DE/HL
	inc de				;eaaf	13          Inc DE - point to the next line of PIXELS
	pop hl				;eab0	e1          Pop HL off the stack, points to screen address again
	jr Scroll			;eab1	18 ea

; Working Area
PIXELS:	    	    EQU $eaba    ;8 bytes that make up the character been scrolled onto the display
TEXT_PTR:       	EQU $eac2    ;2 byte pointer (low,high) to the next character in the text message to be scrolled onto the screen
ROTATIONS:       	EQU $eac4    ;1 byte, number of rotations needed to scroll the character to the left  
TEXT:            	EQU $eac5    ;n bytes, characters of the text to be scrolled + $ff as the string terminator