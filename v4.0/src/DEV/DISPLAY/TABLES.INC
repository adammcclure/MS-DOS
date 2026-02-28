;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	TABLES.INC
;
;	THIS FILE CONTAINS THE CONFIGURATION INFORMATION FOR THE CPS CON
;	DEVICE DRIVER.	THE INFORMATION IS INDEXED USING THE FULL DEVICE
;	SUB-TYPE ID.
;
;	THE TABLE STRUCTURE IS AS FOLLOWS:
;
;	DB	"........"       device sub-type id
;	DB	00000xxxb	 encoded font resolution byte
;	DW	OFFSET modes	 pointer to list of display modes
;	DW	OFFSET fonts	 pointer to list of font resolutions
;
;    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;    ³ Loading mechanism bit incoding			    ³
;    ³							    ³
;    ³	 USER ? 					    ³
;    ³	   ³	  BIOS SUPPORT				    ³
;    ³	ÚÄÄÁÄÄ¿ ÚÄÄÁÄÄ¿ 				    ³
;    ³							    ³
;    ³	7 6 5 4 3 2 1 0 				    ³
;    ³	x x x x 0 0 x x 				    ³
;    ³	³ ³ ³ ³     ³ ÀÄÄ 1 - INT 10 - AX=1100H 	    ³
;    ³	³ ³ ³ ³     ³					    ³
;    ³	³ ³ ³ ³     ÀÄÄÄÄ 1 = INT 10 - AX=1400H 	    ³
;    ³	³ ³ ³ ³ 					    ³
;    ³	³ ³ ³ ÀÄÄÄÄÄÄÄÄÄÄ 1 = INT 1FH			    ³
;    ³	³ ³ ³						    ³
;    ³	³ ³ ÀÄÄÄÄÄÄÄÄÄÄÄÄ 1 = INT 43H			    ³
;    ³	³ ³						    ³
;    ³	³ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 1 = LCD 1FH handling needed	    ³
;    ³	³						    ³
;    ³	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 1 = LCD 44H handling needed	    ³
;    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;
;    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;    ³ Memory Requirements				    ³
;    ³							    ³
;    ³	7 6 5 4 3 2 1 0 				    ³
;    ³	0 0 0 0 x x x x 				    ³
;    ³		³ ³ ³ ÀÄÄ 200 scan lines		    ³
;    ³		³ ³ ÀÄÄÄÄ 350 scan lines		    ³
;    ³		³ ÀÄÄÄÄÄÄ 400 scan lines		    ³
;    ³		ÀÄÄÄÄÄÄÄÄ 480 scan lines		    ³
;    ³							    ³
;    ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;
;	THE TABLES ARE FILLED BEYOND THE SUPPORTED MODES.  THIS
;	IS 'GUESSING' AT THE APPROACH FOR ANY FUTURE DISPLAY MODES
;	WHICH MAY BE BEYOND THE CON-CPS V1.0 SUPPORT.  TO DATE,
;	NO ADAPTER SUPPORTS THE EXTRA MODES - NOT EVEN <insert IBM codeword>.
;
;	Numerous <insert IBM code words> WOULD USE THE
;	SUBSET OF THE EGA MODES.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%if 1  ; IF1 - pass-specific
	%warning .		     ®TABLES  .INC¯
%endif
						;
DISPLAY_CONFIG:;
	DB	"EGA     "                      ; EGA SUPPORT
DC_FONT DB	00000111b			;
	DW	EGA_MODES		;
	DW	EGA_FONT_SIZE		;
DC_ENTRY	EQU ($-DISPLAY_CONFIG)		;
	DB	"EGA 8   "                      ; EGA (5153)
	DB	00000001b			;
	DW	EGA_MODES		;
	DW	EGA8_FONT_SIZE		;
	DB	"EGA 14  "                      ; EGA (5154)
	DB	00000011b			;
	DW	EGA_MODES		;
	DW	EGA14_FONT_SIZE		;
	DB	"EGA 14M "                      ; EGA (5151)
	DB	00000011b			; WGR load 8x8 for > 25.       ;AN000;
	DW	EGAM_MODES		;
	DW	EGA14_FONT_SIZE		;
	DB	"LCD     "                      ; CONVERTIBLE
	DB	00000001b			;
	DW	LCD_MODES		;
	DW	LCD_FONT_SIZE		;
	DB	"MONO    "                      ; MONOCHROME ADAPTER
	DB	00000000b			;
	DW	MONO_MODES		;
	DW	MONO_FONT_SIZE		;
	DB	"CGA     "                      ; COLOUR GRAPHICS ADAPTER
	DB	00000000b			;
	DW	MONO_MODES		;
	DW	MONO_FONT_SIZE		;
NUM_DISPLAY_CONFIG EQU ($-DISPLAY_CONFIG)/DC_ENTRY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA_MODES:			;
	DB	00000001b	;0
	DB	00000001b	;1
	DB	00000001b	;2
	DB	00000001b	;3
	DB	00110000b	;4
	DB	00110000b	;5
	DB	00110000b	;6
	DB	00000001b	;7
	DB	11111111b     ;D;8 ÄÄÄÄÄÄ¿
	DB	11111111b     ;D;9	 ³
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 ³
	DB	11111111b     ;D;C ÄÄÄÄÄÄÙ
	DB	00110000b	;D
	DB	00110000b	;E
	DB	00100000b	;F
	DB	00100000b	;10
	DB	00100000b	;11
	DB	00100000b	;12
	DB	00110000b	;13
	DB	00110000b	;14
	DB	00110000b	;15
	DB	00110000b	;16
	DB	00110000b	;17
	DB	00110000b	;18
	DB	00110000b	;19
	DB	00110000b	;1A
	DB	00110000b	;1B
	DB	00110000b	;1C
	DB	00110000b	;1D
	DB	00110000b	;1E
	DB	00110000b	;1F
NUM_MODES    EQU ($-EGA_MODES)	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGAM_MODES:			;
	DB	11111111b	;0
	DB	11111111b	;1
	DB	11111111b	;2
	DB	11111111b	;3
	DB	11111111b	;4
	DB	11111111b	;5
	DB	11111111b	;6
	DB	00010001b	;7
	DB	11111111b     ;D;8 ÄÄÄÄÄÄ¿
	DB	11111111b     ;D;9	 ³
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 ³
	DB	11111111b     ;D;C ÄÄÄÄÄÄÙ
	DB	11111111b	;D
	DB	11111111b	;E
	DB	00100000b	;F
	DB	11111111b	;10
	DB	11111111b	;11
	DB	11111111b	;12
	DB	11111111b	;13
	DB	11111111b	;14
	DB	11111111b	;15
	DB	11111111b	;16
	DB	11111111b	;17
	DB	11111111b	;18
	DB	11111111b	;19
	DB	11111111b	;1A
	DB	11111111b	;1B
	DB	11111111b	;1C
	DB	11111111b	;1D
	DB	11111111b	;1E
	DB	11111111b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_MODES:			;
	DB	00000010b	;0
	DB	00000010b	;1
	DB	00000010b	;2
	DB	00000010b	;3
	DB	11010000b	;4
	DB	11010000b	;5
	DB	11010000b	;6
	DB	00000010b	;7
	DB	11111111b     ;D;8 ÄÄÄÄÄÄ¿
	DB	11111111b     ;D;9	 ³
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 ³
	DB	11111111b     ;D;C ÄÄÄÄÄÄÙ
	DB	11010000b	;D
	DB	11010000b	;E
	DB	11010000b	;F
	DB	11010000b	;10
	DB	11010000b	;11
	DB	11010000b	;12
	DB	11010000b	;13
	DB	11010000b	;14
	DB	11010000b	;15
	DB	11010000b	;16
	DB	11010000b	;17
	DB	11010000b	;18
	DB	11010000b	;19
	DB	11010000b	;1A
	DB	11010000b	;1B
	DB	11010000b	;1C
	DB	11010000b	;1D
	DB	11010000b	;1E
	DB	11010000b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MONO_MODES:			;
MONO_FONT_SIZE: 		;
	DB	11111111b	;0
	DB	11111111b	;1
	DB	11111111b	;2
	DB	11111111b	;3
	DB	11111111b	;4
	DB	11111111b	;5
	DB	11111111b	;6
	DB	11111111b	;7
	DB	11111111b     ;D;8 ÄÄÄÄÄÄ¿
	DB	11111111b     ;D;9	 ³
	DB	11111111b     ;D;A    RESERVED
	DB	11111111b     ;D;B	 ³
	DB	11111111b     ;D;C ÄÄÄÄÄÄÙ
	DB	11111111b	;D
	DB	11111111b	;E
	DB	11111111b	;F
	DB	11111111b	;10
	DB	11111111b	;11
	DB	11111111b	;12
	DB	11111111b	;13
	DB	11111111b	;14
	DB	11111111b	;15
	DB	11111111b	;16
	DB	11111111b	;17
	DB	11111111b	;18
	DB	11111111b	;19
	DB	11111111b	;1A
	DB	11111111b	;1B
	DB	11111111b	;1C
	DB	11111111b	;1D
	DB	11111111b	;1E
	DB	11111111b	;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA_FONT_SIZE:			;		this needs to be adjusted
	DB	0		;0		*************************
	DB	0		;1		*************************
	DB	0		;2
	DB	0		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	0		;7
	DB	0FFH	      ;D;8 ÄÄÄÄÄÄ¿
	DB	0FFH	      ;D;9	 ³
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 ³
	DB	0FFH	      ;D;C ÄÄÄÄÄÄÙ
	DB	0		;D
	DB	0		;E
	DB	0		;F
	DB	0		;10
	DB	0		;11
	DB	0		;12
	DB	0		;13
	DB	0		;14
	DB	0		;15
	DB	0		;16
	DB	0		;17
	DB	0		;18
	DB	0		;19
	DB	0		;1A
	DB	0		;1B
	DB	0		;1C
	DB	0		;1D
	DB	0		;1E
	DB	0		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA8_FONT_SIZE: 		;
	DB	8		;0
	DB	8		;1
	DB	8		;2
	DB	8		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	0FFH		;7
	DB	0FFH	      ;D;8 ÄÄÄÄÄÄ¿
	DB	0FFH	      ;D;9	 ³
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 ³
	DB	0FFH	      ;D;C ÄÄÄÄÄÄÙ
	DB	8		;D
	DB	8		;E
	DB	8		;F
	DB	0FFH		;10
	DB	0FFH		;11
	DB	0FFH		;12
	DB	0FFH		;13
	DB	0FFH		;14
	DB	0FFH		;15
	DB	0FFH		;16
	DB	0FFH		;17
	DB	0FFH		;18
	DB	0FFH		;19
	DB	0FFH		;1A
	DB	0FFH		;1B
	DB	0FFH		;1C
	DB	0FFH		;1D
	DB	0FFH		;1E
	DB	0FFH		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EGA14_FONT_SIZE:		;
	DB	14		;0
	DB	14		;1
	DB	14		;2
	DB	14		;3
	DB	 8		;4
	DB	 8		;5
	DB	 8		;6
	DB	14		;7
	DB	0FFH	      ;D;8 ÄÄÄÄÄÄ¿
	DB	0FFH	      ;D;9	 ³
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 ³
	DB	0FFH	      ;D;C ÄÄÄÄÄÄÙ
	DB	 8		;D
	DB	 8		;E
	DB	14		;F
	DB	14		;10
	DB	0FFH		;11
	DB	0FFH		;12
	DB	0FFH		;13
	DB	0FFH		;14
	DB	0FFH		;15
	DB	0FFH		;16
	DB	0FFH		;17
	DB	0FFH		;18
	DB	0FFH		;19
	DB	0FFH		;1A
	DB	0FFH		;1B
	DB	0FFH		;1C
	DB	0FFH		;1D
	DB	0FFH		;1E
	DB	0FFH		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LCD_FONT_SIZE:			;
	DB	8		;0
	DB	8		;1
	DB	8		;2
	DB	8		;3
	DB	8		;4
	DB	8		;5
	DB	8		;6
	DB	8		;7
	DB	0FFH	      ;D;8 ÄÄÄÄÄÄ¿
	DB	0FFH	      ;D;9	 ³
	DB	0FFH	      ;D;A    RESERVED
	DB	0FFH	      ;D;B	 ³
	DB	0FFH	      ;D;C ÄÄÄÄÄÄÙ
	DB	8		;D
	DB	8		;E
	DB	8		;F
	DB	8		;10
	DB	8		;11
	DB	8		;12
	DB	8		;13
	DB	8		;14
	DB	8		;15
	DB	8		;16
	DB	8		;17
	DB	8		;18
	DB	8		;19
	DB	8		;1A
	DB	8		;1B
	DB	8		;1C
	DB	8		;1D
	DB	8		;1E
	DB	8		;1F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
