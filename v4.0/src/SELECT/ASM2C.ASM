; page	60,132;AN000;
; name	asm2c;AN000;
; title	Limited assembler to C interface;AN000;
;-------------------------------------------------------------------
;
;	MODULE: 	asm2c
;
;	PURPOSE:
;		This routine is used as to map the assembly language
;		call made by xxx to a C language call.
;
;	INPUT:
;
;		ES:DI points to the buffer area where the table data
;		will be copied
;
;	CALLING FORMAT:
;
;	DATE:		7-16-87
;
;-------------------------------------------------------------------


	global gget_status;AN000;
	global asm2cInRegs;AN000;
	global asm2coutregs;AN000;
	global asm2csegregs;AN000;

SECTION ._TEXT;AN000;
; END SECTION ._TEXT;AN000;
SECTION ._DATA;AN000;
; END SECTION ._DATA;AN000;
SECTION .CONST;AN000;
; END SECTION .CONST;AN000;
SECTION ._BSS;AN000;
; END SECTION ._BSS;AN000;
; DGROUP	GROUP	CONST, _BSS, _DATA;AN000;

SECTION ._DATA;AN000;

;-------------------------------------------------------------------
;	define an assembly language version of the C regs structure
;-------------------------------------------------------------------

asm2cInRegs	equ	$		;AN000;

i_ax		dw	0		;AN000;
i_bx		dw	0		;AN000;
i_cx		dw	0		;AN000;
i_dx		dw	0		;AN000;
i_si		dw	0		;AN000;
i_di		dw	0		;AN000;
i_cflag 	dw	0		;AN000;

Asm2cOutRegs	equ	$		;AN000;

o_ax		dw	0		;AN000;
o_bx		dw	0		;AN000;
o_cx		dw	0		;AN000;
o_dx		dw	0		;AN000;
o_si		dw	0		;AN000;
o_di		dw	0		;AN000;
o_cflag 	dw	0		;AN000;


Asm2cSegRegs	equ	$		;AN000;
s_es		dw	0		;AN000;
s_cs		dw	0		;AN000;
s_ss		dw	0		;AN000;
s_ds		dw	0		;AN000;

	extern _end;AN000;

; END SECTION ._DATA;AN000;

SECTION ._TEXT;AN000;

	extern _get_status;AN000;

	; ASSUME	CS: _TEXT;AN000;
	; assume	ds: nothing;AN000;
	; assume	es: nothing;AN000;
;-------------------------------------------------------------------
;-------------------------------------------------------------------
; page;AN000;
;-------------------------------------------------------------------
;	ggetstatus
;
;		This routine will reside in the C code segment
;
;-------------------------------------------------------------------

segment_of_dgroup	dw	seg dgroup;AN000;

SAVE_STACK:;AN000;
SAVE_SP 	DW	0		;AN000;
SAVE_SS 	DW	0		;AN000;

SAVE_DS 	DW	0		;AN000;
SAVE_ES 	DW	0		;AN000;

gget_status:;AN000;

	MOV	SAVE_DS,DS		;AN000;
	MOV	SAVE_ES,ES		;AN000;

	MOV	SAVE_SS,SS		;AN000;
	MOV	SAVE_SP,SP		;AN000;

	mov	ss,segment_of_dgroup	;AN000;
	add	sp,_end	;AN000;
	; ASSUME	SS: DGROUP;AN000;

	MOV	DS,segment_of_dgroup	;AN000;
	; ASSUME	DS: DGROUP;AN000;

;-------------------------------------------------------------------
;	set up InRegs
;-------------------------------------------------------------------

	mov	i_ax,ax 	;AN000; make InRegs look like real registers
	mov	i_bx,bx 	;AN000;
	mov	i_cx,cx 	;AN000;
	mov	i_dx,dx 	;AN000;
	mov	i_si,si 	;AN000;
	mov	i_di,di 	;AN000;

;-------------------------------------------------------------------
;	set up SegRegs
;-------------------------------------------------------------------

	; IRP	XX,<ES,SS,DS>;AN000;
	MOV	AX,SAVE_&XX	;AN000;
	MOV	S_&XX,AX	;AN000;
	%endmacro;AN000;

	mov	s_cs,cs 	;AN000;

;-------------------------------------------------------------------
;	put far pointers on stack
;-------------------------------------------------------------------

;	push	ds		; push far pointer to SegRegs
	lea	ax,Asm2cSegRegs;AN000;
	push	ax		;AN000;

;	push	ds		; push far pointer to OutRegs
	lea	ax,Asm2cOutRegs;AN000;
	push	ax		;AN000;

;	push	ds		; push far pointer to InRegs
	lea	ax,Asm2cInRegs;AN000;
	push	ax		;AN000;

;-------------------------------------------------------------------
	call	_get_status	;AN000;
;-------------------------------------------------------------------
	add	sp,6		;AN000;
;-------------------------------------------------------------------
;	set up real registers
;-------------------------------------------------------------------

	mov	ax,o_ax 	;AN000; make real registers look like OutRegs
	mov	bx,o_bx 	;AN000;
	mov	cx,o_cx 	;AN000;
	mov	dx,o_dx 	;AN000;
	mov	si,o_si 	;AN000;
	mov	di,o_di 	;AN000;

;-------------------------------------------------------------------
;	must remove the things we put on the stack
;-------------------------------------------------------------------

	MOV	DS,SAVE_DS	;AN000;
	MOV	ES,SAVE_ES	;AN000;
	MOV	SS,SAVE_SS	;AN000;
	MOV	SP,SAVE_SP	;AN000;

	ret			;AN000;


; ENDP gget_status;AN000;

; END SECTION ._TEXT;AN000; end code segment

;-------------------------------------------------------------------
;-------------------------------------------------------------------


	; end;AN000;

