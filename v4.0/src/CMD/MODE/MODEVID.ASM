	; PAGE	,132;
	; TITLE	MODEVID.SAL

; .XLIST
%include "STRUC.INC";macro library for 'struc'
; .LIST

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
;  AC000 - P3200: Was displaying a message that Sam Nunn had deleted from the
;		  USA.MSG file because it looked like a common message.  Now
;		  I use a different (better) message.  It was "Invalid paramters",
;		  is now "Function not supported - ????".

;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
SECTION .SIGNITURE
	ORG	0
SIGWORD: dw 0;SIGNITURE OF THE EGA IS STORED HERE IF THE CARD IS PRESENT
; END SECTION .SIGNITURE


SECTION .LOW_MEM
	ORG	410H
EQUIP_FLAG EQU	THIS WORD
; END SECTION .LOW_MEM


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º


%macro DISPLAY 1
	MOV	DX,MSG
	CALL	PRINTF
%endmacro


;-------------------------------------------------------------------------------


%macro find_number 2

;Purpose: See if num is in the list of numbers.

;Input:  num - number to be checked
;	 list - label of list to scan
;	 list_len - length of the list to scan.  This name is built from the
;		    label 'list' that is input.

;Output:       zero flag set if the number is found in 'list'

;Assumption:   A label of the name list_len exists and is in segment addressed by
;	       DS, where 'list' is the label passed in.  ES and DS are the same.

;Side effects: The direction flag is cleared.

PUSH  DI
PUSH  CX

MOV	AL,num
MOV	DI,list
CLD				;want to increment DI
MOV	CX,list&_len		;CX=number of nums in the list
REPNE	SCASB

POP   CX
POP   DI

%endmacro

;-------------------------------------------------------------------------------


%macro SET_CURSOR_POS 0
	MOV	AH,2			;SET CURSOR
	MOV	DX,0			;ROW=0,COL=0
	MOV	BH,0			;SELECT SCREEN 0
	INT	10H

	%endmacro

%macro MODE_VIDEO 1
	MOV	AH,0			;SET MODE
	MOV	AL,OPTION
	INT	10H

	%endmacro

%macro SET_CURSOR_TYPE 0
	MOV	AH,1			;SET CURSOR TYPE
	MOV	CX,CURSOR_TYPE		;ROW=0,COL=0
	INT	10H

	%endmacro

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

B	EQU	0		       ;POSITION OF "B" IN PARM1 FOR BW?0
W	EQU	1		       ;POSITION OF "W" IN PARM1 FOR BW?0
C	EQU	0		       ;POSITION OF "C" IN PARM1 FOR CO?0
O	EQU	1		       ;POSITION OF "O" IN PARM1 FOR CO?0
M	EQU	0		       ;POSITION OF "M" IN PARM1 FOR MONO
N	EQU	2		       ;POSITION OF "N" IN PARM1 FOR MONO
OH	EQU	3		       ;POSITION OF SECOND "O" IN PARM1 FOR MONO

all			EQU   0FEH     ;descreet value representing adapter/monitor that can be in mono and color
ALT_SELECT EQU	12H		       ;ALTERNATE SELECT FUNCTION OF INT10
AMOAMA			EQU   01       ;map to check 'all modes on all monitors active' bit of misc state info byte
bw7			EQU   7        ;another mono (emulation) mode (VGA with analog monochrome)
bw0B			EQU   0BH      ;analog black and white on a PALACE
cga			EQU   02       ;plain color card
COLOR_CURSOR_TYPE	EQU   0607H    ;CURSOR TYPE FOR ALL COLOR AND BW MODES
color6			EQU   6        ;another color supporting combination (PGA with color display)
color8			EQU   8        ;another color supporting combination
colorA			EQU   0AH      ;yet another color combo (color display or ehnanced color display on PALACE)
colorC			EQU   0CH      ;even another color combo (PALACE with analog color)
ega_color		EQU   4        ;value for color support of EGA
EGA_INFO EQU	10H		       ;RETURN EGA INFORMATION OPTION OF ALT. SELECT FUNCTION OF INT10
EGA_MONO EQU	05H
EGA_SIG EQU	0AA55H		       ;SIGNITURE FOR EGA CARD
EMPTY	EQU	0		       ;THE REMAINING 6 CHARACTERS OF PARM1  SHOULD BE 0
FALSE	EQU	0
get_sys_stat	EQU	43H	       ;get system status function of INT 15H
LCD_attached	EQU	00000000B      ;bit 0=0 if the LCD is attached
LCD_bit 	EQU	00000001B      ;mask to check the LCD attached bit of status byte
LOWERCASE EQU	20H		       ;OR THIS TO UPPER/LOWER CASE TO ASSURE LOWERCASE
mono_card		EQU   1        ;BIOS INT 10 AH=1B representation of plain mono card
MONO_CURSOR_TYPE  EQU	0B0CH
MONO_ON_IT EQU	1		       ;VALUE RETURNED FROM EGA INFORMATION IN BH IF MONO IN EFFECT
OPTION_BW4025 EQU 0		       ;40 X 25 BW
OPTION_CO4025 EQU 1		       ;40 X 25 COLOR
OPTION_BW8025 EQU 2		       ;80 X 25 BW
OPTION_CO8025 EQU 3		       ;80 X 25 COLOR
OPTION_MONO   EQU 7		       ;monochrome
parm_list		EQU   [BP]     ;addressing for array of parsed parameters in form "parm_list_entry"

COLOR_ON_IT EQU 0		       ;VALUE RETURNED FROM EGA INFORMATION IN BH IF COLOR IN EFFECT
BITBW40 EQU	10H		       ;40X25 BW USING COLOR CARD
BITBW80 EQU	20H		       ;80X25 BW USING COLOR CARD
BITMONO EQU	30H		       ;80X25 BW CARD
video_info_DI	  EQU	[DI]

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼




;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

global ALT_SELECT
global BW40
global BW80
global CHECK_BUFF
global CO40
global CO80
global COLOR_ON_IT
global EGA_INFO
global GET_VIDEO_INFO
global MONO

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

%include "common.stc";definition of the following struc

;parm_list_entry   STRUC		   ;used by parse_parameters and invoke
;
;parm_type	      DB       bogus
;item_tag	      DB       0FFH
;value1 	      DW       bogus	   ;used only for filespecs and code page numbers
;value2 	      DW       bogus	   ;used only for filespecs and code page numbers
;keyword_switch_ptr   DW    0
;
;parm_list_entry   ENDS


struc info_block;layout of info returned by INT 10 AH=1B
   who_cares1	     DB    025H  DUP ("V")
   active_display    DB    "V"
   alternate_display DB    "V"
   who_cares2: resb 6
   misc_state_info   DB    "V"
   who_cares3	     DB    12H	 DUP ("V")
endstruc


;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼




;THE FOLLOWING 'RECORD' STATEMENT DEFINES THE BITS BITS OF THE EQUIPMENT FLAG:
;BIT 15,14 = NUMBER OF PRINTERS ATTACHED
;BIT 13    = NOT USED
;BIT 12    = GAME I/O ATTACHED
;BIT 11-9  = NUMBER OF RS232 CARDS ATTACHED
;BIT 8	   = UNUSED
;BIT 7,6   = NUMBER OF DISKETTE DRIVES
;BIT 5,4   = INITIAL VIDEO MODE:
;   00-UNUSED
;   01-40X25 BW USING COLOR CARD
;   10-80X25 BW USING COLOR CARD
;   11-80X25 BW USING BW CARD
;BIT 3,2   = PLANAR RAM SIZE (00=16K, 01=32K, 10=48K, 11=64K)
;BIT 1	   = NOT USED
;BIT 0	   = IPL FROM DISKETTE
FLAG	RECORD	PR:2,NA1:1,GAME:1,COMN:3,NA2:1,DISKD:2,VIDEO:2,RAM:2,NA3:1,IPL:1
;DEFINITION OF ABOVE VIDEO BITS:



	; PAGE
SECTION .PRINTF_CODE
	; ASSUME	CS:PRINTF_CODE,DS:PRINTF_CODE,SS:PRINTF_CODE


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ D A T A ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

color_combos:;list of adapter/display combinations supporting color modes
   DB	 bw0B
   DB	 color6
   DB	 color8
   DB	 colorA
   DB	 colorC
   DB	 cga
   DB	 ega_color
color_combos_len  EQU	$ - color_combos

CURSOR_TYPE	DW	0607H		;HOLDER OF APPROPRIATE CURSOR TYPE
information_block    info_block  <>	  ;area to hold info returned from INT 10 AH=1B

mono_combos:
   DB	 mono_card
   DB	 ega_mono
   DB	 bw7
mono_combos_len   EQU	$ - mono_combos

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ D A T A ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

extern Function_not_supported;'INVALID PARAMETERS'
extern NOERROR;INDICATE THAT NO ERROR MESSAGES HAVE BEEN ISSUED YET
extern not_supported_ptr;pointer to the screen mode that the configuration can't do.
extern machine_type;holder of model byte
extern parm_lst;the array of the structure parm_list_entry  max_pos_parms DUP (<>)
extern PRINTF;"C" LIKE FORMATTED SCREEN OUTPUT ROUTINE
extern PARM1;PARAMETER HOLDING AREA, SEE "RESCODE"
extern P14_model_byte

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



;***********************************************************
;SET VIDEO TO 40 X 25, BLACK AND WHITE
BW40:

	CALL	get_video_info
	; .IF    <video_info_DI.active_display EQ all> OR
	find_number  <video_info_DI.active_display>,color_combos
	; .IF    Z OR
	find_number  <video_info_DI.alternate_display>,color_combos
	; .IF    Z THEN

	    MOV     DL,BITBW40		;SET FOR BW 40 X 80
	    MOV     DH,OPTION_BW4025
	    MOV     CURSOR_TYPE,COLOR_CURSOR_TYPE
					;DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
					;DH HAS BYTE OF VIDEO OPTION
	    CALL    setup

	; .ELSE

	    MOV   DI,0			  ;the screen mode is always the first parm					   ;AC000;
	    MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]				   ;AC000;
	    MOV   CX,parm_list[DI].value1										   ;AC000;
	    MOV   not_supported_ptr,CX	       ;FILL IN pointer to the parameter that is not supported			  ;AC000;
	    DISPLAY Function_not_supported	;'Function not supported - BW40"
	    MOV     NOERROR,FALSE

	; .ENDIF

	RET				;RETURN TO MAIN ROUTINE
; ENDP BW40
;******************************************************
;SET VIDEO TO 80 X 25, BLACK AND WHITE
BW80:

	CALL	get_video_info
	; .IF    <video_info_DI.active_display EQ all> OR
	find_number  <video_info_DI.active_display>,color_combos
	; .IF    Z OR
	find_number  <video_info_DI.alternate_display>,color_combos
	; .IF    Z THEN

	    MOV     DL,BITBW80		;80 X 25 BW USING GRAPHICS CARD
	    MOV     DH,OPTION_BW8025
	    MOV     CURSOR_TYPE,COLOR_CURSOR_TYPE
					;DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
					;DH HAS BYTE OF VIDEO OPTION
	    CALL    setup

	; .ELSE

	    MOV   DI,0			  ;the screen mode is always the first parm					   ;AC000;
	    MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]				   ;AC000;
	    MOV   CX,parm_list[DI].value1										   ;AC000;
	    MOV   not_supported_ptr,CX	       ;FILL IN pointer to the parameter that is not supported			  ;AC000;
	    DISPLAY Function_not_supported	;'Function not supported - BW80"
	    MOV     NOERROR,FALSE

	; .ENDIF

	RET
; ENDP BW80
;******************************************************
;SET VIDEO TO 80 X 25, MONOCHROME
MONO:

	CALL	get_video_info
	; .IF    <video_info_DI.active_display EQ all> OR
	find_number  <video_info_DI.active_display>,mono_combos
	; .IF    Z OR
	find_number  <video_info_DI.alternate_display>,mono_combos
	; .IF    Z THEN

	    MOV     DL,BITMONO	    ;EQUIP FLAG INDICATING 80 X 25 BW USING MONO CARD
	    MOV     DH,OPTION_MONO  ;MONOCHROME MODE
	    MOV     CURSOR_TYPE,MONO_CURSOR_TYPE

					;DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
					;DH HAS BYTE OF VIDEO OPTION
		CALL	SETUP

	; .ELSE

	    MOV   DI,0			  ;the screen mode is always the first parm					   ;AC000;
	    MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]				   ;AC000;
	    MOV   CX,parm_list[DI].value1										   ;AC000;
	    MOV   not_supported_ptr,CX	       ;FILL IN pointer to the parameter that is not supported			  ;AC000;
	    DISPLAY Function_not_supported	;'Function not supported - MONO"
	    MOV     NOERROR,FALSE

	; .ENDIF

	RET				;RETURN TO MAIN ROUTINE
; ENDP MONO
;*******************************************************
CO40:

	CALL	get_video_info
	; .IF    <video_info_DI.active_display EQ all> OR
	find_number  <video_info_DI.active_display>,color_combos
	; .IF    Z OR
	find_number  <video_info_DI.alternate_display>,color_combos
	; .IF    Z THEN

	   MOV	   DL,BITBW40	       ;40 X 25 USING COLOR CARD
	   MOV	   DH,OPTION_CO4025    ; REQUEST COLOR
	   MOV	   CURSOR_TYPE,COLOR_CURSOR_TYPE
				    ;DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
				    ;DH HAS BYTE OF VIDEO OPTION
	   CALL    setup

	; .ELSE

	    MOV   DI,0			  ;the screen mode is always the first parm					   ;AC000;
	    MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]				   ;AC000;
	    MOV   CX,parm_list[DI].value1										   ;AC000;
	    MOV   not_supported_ptr,CX	       ;FILL IN pointer to the parameter that is not supported			  ;AC000;
	    DISPLAY Function_not_supported	;'Function not supported - CO40"
	    MOV     NOERROR,FALSE

	; .ENDIF

	RET				;RETURN TO MAIN ROUTINE
; ENDP CO40
;******************************************************
CO80:

	CALL	get_video_info
	; .IF    <video_info_DI.active_display EQ all> OR
	find_number  <video_info_DI.active_display>,color_combos
	; .IF    Z OR
	find_number  <video_info_DI.alternate_display>,color_combos
	; .IF    Z THEN

	   MOV	   DL,BITBW80	       ;80 X 25 USING COLOR CARD
	   MOV	   DH,OPTION_CO8025    ; REQUEST COLOR
	   MOV	   CURSOR_TYPE,COLOR_CURSOR_TYPE

					;DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
					;DH HAS BYTE OF VIDEO OPTION
	   CALL    setup

	; .ELSE

	    MOV   DI,0			  ;the screen mode is always the first parm					   ;AC000;
	    MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]				   ;AC000;
	    MOV   CX,parm_list[DI].value1										   ;AC000;
	    MOV   not_supported_ptr,CX	       ;FILL IN pointer to the parameter that is not supported			  ;AC000;
	    DISPLAY Function_not_supported	;'Function not supported - CO80"
	    MOV     NOERROR,FALSE

	; .ENDIF

	RET				;RETURN TO MAIN ROUTINE
; ENDP CO80
;******************************************************
SETUP:
;INPUT: DL HAS BYTE TO BE OR'ED INTO EQUIP_FLAG
;	DH HAS BYTE OF VIDEO OPTION

	XOR	AX,AX			;ZERO A REG
	MOV	ES,AX			;POINT TO SEGMENT AT ZERO
	MOV	AX,ES:EQUIP_FLAG	;GET CURRENT STATUS FLAG BYTE
	AND	AL,0FFH-MASK VIDEO	;CLEAR VIDEO DEFINITION BITS
	OR	AL,DL			;TURN ON REQUESTED VIDEO BITS
	MOV	ES:EQUIP_FLAG,AX	;RESTORE UPDATED FLAG BYTE

	MODE_VIDEO DH			;SET MODE TO DESIRED OPTION

	SET_CURSOR_POS			;TO ROW=0, COL=0

	SET_CURSOR_TYPE 		;TO 6,7 FOR COLOR MODES, B,C FOR MONO

	RET				;RETURN TO CALLER
; ENDP SETUP
;******************************************************
GET_VIDEO_INFO:

;Determine what display adapters are in the machine.


;Assumption:
;
;

;Notes: I assume that if an EGA is present then it is the active display.  This
;	 is not always the case, but the routines that call for that kind of
;	 information do not care which is active, or already know.

;Conventions:  'video_info_DI'([DI]) is used to address the info table returned
;		  by INT 10 AH=1B as defined by the structure 'info_block' and
;		  stored in 'information_block'.  If the INT 10 AH=1A was
;		  successfull then the result is stored here.








PUSH  ES

XOR   AX,AX				  ;ZAP previous contents
MOV   AH,01BH				  ;functionality/state information
PUSH  CS
POP   ES
MOV   DI,information_block	     ;initialize 'video_info_DI'
MOV   BX,0				     ;parm to allow for future expansion
INT   010H
; .IF <AL EQ 01BH> THEN NEAR;IF the call is supported THEN
					     ;ES:DI=>info returned from BIOS
   ; .IF <video_info_DI.alternate_display EQ 0> THEN NEAR;only 1 display, so see if it can handle all modes

      TEST  video_info_DI.misc_state_info,AMOAMA      ;check the 'all modes on all monitors active' bit
      ; .IF   NZ;IF all modes are supported THEN
	 MOV   video_info_DI.active_display,all 	      ;return the active display type as everything
      ; .ENDIF

   ; .ENDIF

; .ELSE;display code call not supported, look for EGA
   ;SINCE the display type call was not supported SEE IF IN AN EGA ADVANCED MODE

   MOV	   AX,SIGNITURE
   MOV	   ES,AX	       ;PUT SEGMENT OF SIGNITURE OF EGA IN ES
   ; .IF	 <ES:SIGWORD EQ EGA_SIG> AND;IF maybe an EGA IN THE MACHINE THEN
   MOV	   AH,ALT_SELECT       ;AH GETS INT FUNCTION SPECIFIER
   MOV	   BL,EGA_INFO	       ;SPECIFY IN BL THE OPTION OF THE FUNCTION OF INT 10 WE
   INT	   10H		       ;RETURN MONITOR TYPE HOOKED TO EGA IN BH
   ; .IF	 <BL NE 010H> THEN;EGA support available
      ; .IF   <BH EQ COLOR_ON_IT> THEN;IF COLOR HOOKED TO EGA THEN
	  MOV  video_info_DI.active_display,ega_color

	  MOV	  AX,0B000H	      ;GET BASE OF MONO SCREEN BUFFER
	  CALL	  check_buff	      ;IF THERE IS MEMORY WHERE THE MONO CARD HAS IT
	  ; .IF  <AH EQ AL> THEN;IF there is a monchrome card buffer present THEN
	     MOV   video_info_DI.alternate_display,mono_card
	  ; .ENDIF

      ; .ELSE
	  MOV  video_info_DI.active_display,ega_mono

	  MOV	  AX,0B800H		  ;AX= BASE OF GRAPHICS SCREEN BUFFER
	  CALL	  CHECK_BUFF		  ;DATA PUT OUT IN AL, DATA RETURNED IN AH
	  ; .IF  <AH EQ AL> THEN;IF WHAT I GOT BACK IS SAME AS I PUT OUT, THEN BUFFER IS PRESENT
	     MOV   video_info_DI.alternate_display,cga
	  ; .ENDIF
      ; .ENDIF
   ; .ELSE;no display type call, no EGA
					  ;check for convertible
      ; .IF   <machine_type EQ P14_model_byte> AND
      MOV     AH,get_sys_stat
      INT     15H			   ;AL=system status
      AND     AL,LCD_bit		   ;check bit 0
      ; .IF   <AL EQ LCD_attached> THEN
	 MOV   video_info_DI.active_display,all 	;LCD supports mono and color
      ; .ELSE;no analog displays, no EGA, no LCD

	  MOV	  AX,0B000H	      ;GET BASE OF MONO SCREEN BUFFER
	  CALL	  check_buff	      ;IF THERE IS MEMORY WHERE THE MONO CARD HAS IT
	  ; .IF  <AH EQ AL> THEN;IF there is a monchrome card buffer present THEN
	    MOV   video_info_DI.active_display,mono_card
	  ; .ENDIF

	  MOV	  AX,0B800H		  ;AX= BASE OF GRAPHICS SCREEN BUFFER
	  CALL	  CHECK_BUFF		  ;DATA PUT OUT IN AL, DATA RETURNED IN AH
	  ; .IF  <AH EQ AL> THEN;IF WHAT I GOT BACK IS SAME AS I PUT OUT, THEN BUFFER IS PRESENT
	     MOV   video_info_DI.alternate_display,cga
	  ; .ENDIF

      ; .ENDIF

   ; .ENDIF

; .ENDIF

POP   ES

RET				;RETURN TO CALLER


; ENDP GET_VIDEO_INFO
;******************************************************
;VMONO	 PROC	 NEAR
;;VERIFY THAT A MONOCHROME CARD EXISTS OR LCD IS ATTACHED
;;Input: - AX=base of monochrome screen buffer
;;Output: - AH=AL if have monochrome card or LCD attached
;;	    AH<>AL if don't have mono card and LCD is not attached
;
;;One way to have a valid MONO setting on a P1X is to have the LCD attached.  Another is
;;to have the LCD detached and have a MONO card attached.
;;The logic is as follows:
;;
;;BEGIN
;;   ok_to_put_in_MONO_mode:=false
;;   IF on a P1X AND LCD is attached THEN
;;	ok_to_put_in_MONO_mode:=true
;;   ELSE
;;	verify_the_buffer_exists
;;   ENDIF
;;END
;
;   PUSH    AX
;   CMP     machine_type,P14_model_byte
;   $IF     E,AND
;   MOV     AH,get_sys_stat
;   INT     15H 			 ;AL=system status
;   AND     AL,LCD_bit			 ;check bit 0
;   CMP     AL,LCD_attached
;   $IF     E				 ;IF on a P1X AND LCD is attached THEN
;      POP     AX			 ;   clean the stack
;      MOV     AX,0000H 		 ;   AH=ALðOK to put in MONO mode
;   $ELSE				 ;ELSE
;      POP     AX			 ;   AX=mono buffer base
;      CALL    check_buff		 ;   see if the MONO card exists
;   $ENDIF				 ;ENDIF
;RET					 ;RETURN TO MAIN ROUTINE
;VMONO	 ENDP
;******************************************************
CHECK_BUFF:
;SEE IF MEMORY EXISTS AT THE SEGMENT PASSED IN AX

	PUSH	DS			;SAVE DATA SEGMENT REGISTER
;				MOVE SEG ID OF VIDEO BUFFER
	MOV	DS,AX			; TO THE DATA SEGMENT REG
	MOV	CH,DS:0 		;GET A BYTE FROM THAT BUFFER
	MOV	AL,55H			;GET A SAMPLE DATA BYTE
	MOV	DS:0,AL 		; TO THE SCREEN BUFFER, IF THERE
	PUSH	BX			;TERMINATE THE BUS SO WE DON'T GET THE SAME THING
	POP	BX			;BACK BECAUSE IT WAS STILL ON THE BUS
	MOV	AH,DS:0 		;FETCH IT BACK
	MOV	DS:0,CH 		;REPAIR THE DAMAGE IN THE BUFFER
	POP	DS			;RESTORE DATA SEGMENT REGISTER
	RET
; ENDP CHECK_BUFF
;********************************************************
; END SECTION .PRINTF_CODE
	; END
