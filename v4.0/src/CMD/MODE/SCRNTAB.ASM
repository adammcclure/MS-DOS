; .SALL
	; PAGE	,132;
	; TITLE	SCRNTABL.ASM - SCREEN SHIFT TABLE CONTROL FOR MODE COMMAND


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

%macro SET 2;SET REG TO VALUE. DON'T SPECIFY AX FOR REG

	PUSH	AX
	MOV	AX,VALUE
	MOV	REG,AX
	POP	AX

%endmacro

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

ROM_BIOS_SEG EQU 0F000H 		;USED TO ADDRESS INIT TABLE IN ROM
VIDEO_VECTOR EQU 74H			;OFFSET INTO VECTOR TABLE (SEG=0)
					;TO DOUBLE WORD POINTER TO VIDEO PARMS
VIDEO_PARMS_WORD_LEN EQU 32		;NO. WORDS IN VIDEO PARM AREA

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


SECTION .PRINTF_CODE
	; ASSUME	DS:NOTHING, CS:PRINTF_CODE


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

extern MODELOAD
extern RESSEG;ADD OF POINTER TO RESIDENT CODE
extern NEW_SCRNTABL;OFFSET OF INIT TABLE WITHIN THE RESIDENT CODE
extern NEW_VIDEO_PARMS_OFFSET
extern NEW_VIDEO_PARMS_SEGMENT

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º
;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼



SECTION .ROM_BIOS

	ORG	0FFFEH

	MACHINE_TYPE:;MACHINE TYPE BURNED IN ROM

; END SECTION .ROM_BIOS

; PAGE
;*********************************************************************************************

SCRNTAB:
global SCRNTAB
;	 GO TO THE 64 BYTES POINTED TO BY THE VECTOR AT 0:74H AND MOVE A COPY
;	 OF THESE BYTES TO THE MODE COMMAND RESIDENT AREA LEAVING DS POINTING TO
;	 THE SEGMENT OF THE TABLE, AND BX CONTAINING THE OFFSET OF THE TABLE.
;	 BIGTOP BIOS OVERWRITES AREA AT 40:90, AS DO OTHER APPS SO MUST LOAD THE
;	 TABLE INTO MODE'S RESIDENT CODE.

 PUSH	 ES			 ;SAVE ADDR OF PROGRAM HEADER PREFIX AREA
 MOV	 AX,0			 ;ADDR OF VECTOR TABLE
 MOV	 DS,AX			 ;SET DATA SEGMENT TO 0 MEMORY
 MOV	 BX,DS:VIDEO_VECTOR+2	 ;SEGMENT OF VIDEO PARMS
 CMP	 BX,ROM_BIOS_SEG
;$IF	 E			 ;IF haven't moved the table THEN
 JNE $$IF1
			    ;load the resident code
    PUSH    DS
    SET     DS,CS	    ;MODELOAD DEPENDS ON DS BEING SEG OF TO BE RES CODE
    CALL    MODELOAD	    ;LOAD RESIDENT CODE OVERLAYING PSP
    POP     DS		    ;RESTORE TO SEGMENT 0
			    ;Save address of resident code
    SET     CS:NEW_VIDEO_PARMS_SEGMENT,< word DS:RESSEG+2 >
    MOV     AX,word DS:RESSEG	;AX=offset of MODETO within resident code
    ADD     AX,NEW_SCRNTABL		;AX=OFFSET OF VIDEO PARMS FROM RES CODE SEG
    MOV     word CS:NEW_VIDEO_PARMS_OFFSET,AX ;SEE "RESCODE"

    MOV     DI,AX	;DI=NEW_VIDEO_PARMS_OFFSET, SET UP ES:DI FOR MOVSW INSTRUCTION
    MOV     AX,CS:NEW_VIDEO_PARMS_SEGMENT
    MOV     ES,AX		;ES=RESIDENT CODE SEGMENT
    MOV     SI,DS:VIDEO_VECTOR	;GET SEGMENT OF VIDEO PARMS
    MOV     DS:VIDEO_VECTOR,DI	;CHANGE VIDEO OFFSET
    MOV     DS:VIDEO_VECTOR+2,ES ;CHANGE VIDEO SEGMENT
    MOV     DS,BX		;CHANGE DS TO ROM SEGMENT
    MOV     CX,VIDEO_PARMS_WORD_LEN ;COUNT TO MOVE 32 WORDS
    CLD 			;INCREMENT SI AND DI WHILE MOVING THE TABLE
    REP     MOVSW		;MOVE 64 BYTES VIDEO PARMS TO RES AREA

;$ENDIF 			 ;I HAVE MOVED IT YET
$$IF1:

 SET	 DS,0
 LDS	 BX,DS:RESSEG	     ;DS:BX POINTS TO RESIDENT CODE
 ADD	 BX,NEW_SCRNTABL     ;DS:BX POINTS TO NEW VIDEO TABLE

 POP	 ES			 ;RESTORE ADDR OF PROGRAM HEADER PREFIX
 RET				 ;RETURN TO MODESCRN PROC

; ENDP SCRNTAB


; END SECTION .PRINTF_CODE
	; END
