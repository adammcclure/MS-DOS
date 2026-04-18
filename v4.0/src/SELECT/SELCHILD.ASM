; PAGE 55,132;AN000;
; NAME	SELCHILD;AN000;
; TITLE	SELCHILD - CHILD processing for SELECT.EXE;AN000;
; SUBTTL	selchild.asm;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	HANDLE_CHILDREN
;
; Entry:
;
;
;
; Exit:
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	extern QM_ID;AN000;
	extern QM_OPT1;AN000;
	extern QM_ACTIVEPAN;AN000;
					;
SECTION .SELECT;AN000;segment for far routine
	; ASSUME	CS:SELECT;AN000;
					;
	extern GET_PCB;AN000;
	extern PCDISPQ_CALL;AN000;
					;
	%include "PCEQUATE.INC";AN000;
	%include "CASTRUC.INC";AN000;
	%include "MACROS.INC";AN000;
					;
	global HANDLE_CHILDREN;AN000;
HANDLE_CHILDREN:;AN000;
	PUSHH	<AX,BX,CX,DI,ES>	;AN000;
	MOV	QM_OPT1,QM_PUSHCHD	;AN000; push child panels
					;
	MOV	BX,QM_ACTIVEPAN 	;AN000;
	CALL	GET_PCB 		;AN000; get panel control block
					; for active parent panel
	MOV	CX,[ES:DI]+PCB_CHILDNUM ;AN000;
	OR	CX,CX			;AN000;
	JZ	HC_1			;AN000;
					;
	PUSH	[ES:DI]+PCB_CHILDSEG	;AN000; get address of first child panel
	PUSH	[ES:DI]+PCB_CHILDOFF	;AN000;
	POP	DI			;AN000;
	POP	ES			;AN000;
					;
HC_0:	MOV	AX,[ES:DI]+CHD_PCB	;AN000;
	MOV	QM_ID,AX		;AN000;
	PUSHH	<ES,DI> 		;AN000;
	CALL	PCDISPQ_CALL		;AN000; push next child on the stack
	POPP	<DI,ES> 		;AN000;
					;
	ADD	DI,TYPE CHD_PB		;AN000; get next child control block
	LOOP	HC_0			;AN000;
					;
HC_1:	POPP	<ES,DI,CX,BX,AX>	;AN000;
	RET				;AN000;
; ENDP HANDLE_CHILDREN;AN000;
; END SECTION .SELECT;AN000;
	; END;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

