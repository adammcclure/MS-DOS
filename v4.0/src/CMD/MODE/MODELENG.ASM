; PAGE ,132;
; TITLE MODELENG.ASM - VARIOUS SERVICE ROUTINES

;This module contains procedures:
;MODELENG - convert 3 digit or less ASCII string to binary number
;GET_MACHINE_TYPE - determine the machine type based on model byte and sub model byte

; .XLIST
   %include "STRUC.INC"
; .LIST
;.SALL

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

;  AX001 - P4031: Was allowing rate and delay settings on ATs that did not have
;		  the functionality in the BIOS.  Have to check specifically for
;		  a date of 11/15/85 or later.

;  AX002 - P4543: Add VAIL and SNOWMASS to legal choices for 19200 baud

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

global get_machine_type
global MODELENG

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

%macro BREAK 1;AN001;

JMP   ENDCASE_&destination	 ;AN001;

%endmacro;AN001;

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ E Q U A T E S ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

AT_or_XT286_or_PS2_50_or_PS2_60  EQU   0FCH  ;AN000;primary model byte for all 286 based machines
BIOS_date			 EQU   [ES:DI]	   ;used for accessing parts of the BIOS date ;AN001;
INTCONV 			 EQU   48	   ;CONVERT ASCII TO NUMERIC
model_byte_AH			 EQU   AH
return_system_configuration	 EQU   0C0H	   ;INT 15H subfunction
system_descriptor_table 	 EQU   [ES:BX]
system_services 		 EQU   15H	   ;ROM BIOS call
XT2				 EQU   0FBH  ;AN000;model byte for 2nd release of XT

%include "modequat.inc"

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

struc BIOS_date_struc;in form mm/dd/yy  ;AN001;
   month: resw 1;AN001;
   slash1: resb 1;AN001;
   day: resw 1;AN001;
   slash2: resb 1;AN001;
   year: resw 1;AN001;
endstruc;AN001;


struc system_descriptor
   length_of_descriptor    DW	 bogus			;number of bytes in the descriptor table
   primary_model_byte	   DB	 bogus
   secondary_model_byte    DB	 bogus
endstruc

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


SECTION .ROM

ORG   0FFF5H				     ;location of date ROM BIOS for the release was written ;AN001;
date_location:;AN001;

ORG   0FFFEH
model_byte:

; END SECTION .ROM



SECTION .PRINTF_CODE
	 ; ASSUME CS:PRINTF_CODE,DS:PRINTF_CODE



;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

HUNDRED  DB    100
TEN	 DB    10


;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

extern machine_type;see 'rescode.sal'
extern submodel_byte;see 'rescode.sal'

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


MODELENG:
;
;INPUT:BP HAS ADDR OF PARM FIELD IN DATA SPACE (DS:)
;
    MOV    BL,0 		  ;INIT BL TO 0
;   IF THIS PARAMETER IS A THREE DIGIT NUMBER,
    CMP    byte [DS:BP]+2,0 ;LOOK AT THIRD DIGIT
    JE	   ENDIF01
    CMP    byte [DS:BP]+2,20H		;see if third char is a blank
    JE	   ENDIF01		;IF there is a third digit THEN
;
      MOV    AL,[DS:BP]     ;GET FIRST DIGIT
      SUB    AL,INTCONV     ;CONVERT TO INT
      MUL    HUNDRED	    ;HUNDREDTHS PLACE
      ADD    BL,AL	    ;ADD TO BL
      INC    BP 	    ;BUMP TO NEXT DIGIT
    ENDIF01:	;ENDIF THIS PARAMETER IS A THREE DIGIT NUMBER
    MOV    AL,[DS:BP]	    ;GET NEXT DIGIT
    SUB    AL,INTCONV	    ;CONVERT TO INT
       JNC    ENDIF02
       MOV     BL,0FFH	  ;encountered an error so put a bogus number in the sum
    ENDIF02:
    MUL    TEN		    ;TENS PLACE
    ADD    BL,AL	    ;ADD TO BL
    INC    BP		    ;GO TO NEXT DIGIT
    MOV    AL,[DS:BP]	    ;GET NEXT DIGIT
    SUB    AL,INTCONV	    ;CONVERT TO INT
    ADD    BL,AL	    ;ADD TO BL
    RET
; ENDP MODELENG


ascii_to_int:;input: AX=2 digit ascii number ;AN001;
			   ;output: BL has binary value 	   ;AN001;
			   ;assume: no overflow or underflow	   ;AN001;

    PUSH   AX		    ;the MUL destroys AH		   ;AN001;
    SUB    AL,INTCONV	    ;CONVERT high order digit to binary    ;AN001;
    MUL    TEN		    ;TENS PLACE 			   ;AN001;
    MOV    BL,AL	    ;ADD TO BL				   ;AN001;
    POP    AX							   ;AN001;
    MOV    AL,AH	    ;AL=low order digit 		   ;AN001;
    SUB    AL,INTCONV	    ;CONVERT TO binary			   ;AN001;
    ADD    BL,AL	    ;ADD TO BL				   ;AN001;
    RET 							   ;AN001;

; ENDP ascii_to_int;AN001;


;------------------------------------------------------------------------------

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
;³
;³ GET_MACHINE_TYPE
;³ ----------------
;³
;³  Get the machine type and store for future reference.
;³
;³
;³  INPUT: none
;³
;³
;³  RETURN: A scalar value indicating the type of machine is stored in
;³	    'machine_type'.
;³
;³
;³  MESSAGES: none
;³
;³
;³
;³  REGISTER
;³  USAGE AND
;³  COMVENTIONS: AX - general usage
;³		 BX - used to address the system descriptor table
;³
;³
;³
;³
;³
;³  ASSUMPTIONS: DS has segment of MODE's data area
;³
;³
;³  SIDE EFFECT: ES is changed.
;³
;³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


get_machine_type:



PUSH  ES
PUSH  BX			       ;will be used to point to 'system descriptor table'
MOV   AH,return_system_configuration
INT   15H
; .IF   NC;IF the call was handled successfully
   MOV	 AH,system_descriptor_table.secondary_model_byte
   MOV	 submodel_byte,AH				;save submodel byte
   MOV	 AH,system_descriptor_table.primary_model_byte
; .ELSE
   MOV	 AX,ROM 		;get addressability to the model byte
   MOV	 ES,AX
   MOV	 AH,ES:model_byte
; .ENDIF

; .IF <model_byte_AH EQ AT_or_XT286_or_PS2_50_or_PS2_60> THEN;AN000;may have a submodel byte, check it

   ; .IF <submodel_byte EQ PS2Model60> THEN;AN000;
      MOV   AH,PS2Model60			;AN000;
   .ELSEIF <submodel_byte EQ VAIL> OR		;AN000;
   ; .IF <submodel_byte EQ PS2Model50> THEN;AN000;
      MOV   AH,PS2Model50			;AN000;
   .ELSEIF <submodel_byte EQ XT286> THEN	;AN000;
      MOV   AH,XT286				;AN000;
   .ELSEIF <submodel_byte EQ AT3> THEN		;AN000;
      MOV   DI,date_location		       ;ES:DI=>BIOS date (BIOS_date EQU ES:[DI])	       ;AN001;

;     CASE BIOS_date=											;AN001;

;	 later than 1985:										;AN001;

	       MOV   AX,BIOS_date.year			 ;AX=ASCII form of BIOS date year	       ;AN001;
	       CALL  ascii_to_int			 ;BL=binary form of BIOS date year		;AN001;
	       ; .IF <BL GT 85> THEN;IF AT built in 86 or later		  ;AN001;

	    MOV   AH,AT4										;AN001;
	    BREAK 0											;AN001;

	       ; .ENDIF;AN001;

;	 1985, on 11/15:	       ;BL already has year from above check				;AN001;

	       ; .IF <BL EQ 85> AND;AN001;
	       ; .IF <BIOS_date.month EQ "11"> AND;AN001;
	       ; .IF <BIOS_date.day EQ "51"> THEN;"51" is the word form of "15"                    ;AN001;

	    MOV   AH,AT4										;AN001;
	    BREAK 0											;AN001;

	       ; .ENDIF;AN001;

;	 otherwise:		       ;internal release of third version of AT 				       ;AN001;

	    MOV   AH,AT3										;AN001;


       ENDCASE_0:											;AN001;

   .ELSEIF <submodel_byte EQ AT2> THEN		;AN000;
      MOV   AH,AT2				;AN000;
   ; .ENDIF;AN000;IF none of the above AH has correct value for AT1 (FC)
.ELSEIF <model_byte_AH EQ XT2> THEN		;AN000;
   MOV	 AH,PCXT				;AN000;no difference from XT1
; .ENDIF;AN000;

MOV   DS:machine_type,AH	 ;AH was set as result of getting the system configuration or during the IF.
POP   BX
POP   ES

RET			;RETURN TO MODE MAIN ROUTINE
; ENDP get_machine_type
; END SECTION .PRINTF_CODE
    ; END
