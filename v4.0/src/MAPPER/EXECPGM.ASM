;
; page 60,132
;
; title CP/DOS  DOSExecPrg  mapper

SECTION .buffer
			global DosExecPgmCalled
DosExecPgmCalled	db	0			  ;????????????
			global DosExecPgmReturnCode
DosExecPgmReturnCode	dw	0

DosExecParameterBlock:
EnvironmentSegment	dw	0
ArgumentPointer 	dd	0
Default_5C_FCB		dd	0
Default_6C_FCB		dd	0

; END SECTION .buffer

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosExecPgm
; *
; *	 FUNCTION:  Allows a program to execute another program
; *
; *	 CALLING SEQUENCE:
; *
; *		push	Asyncindic	; execute asynchronously
; *		push	TraceIndic	; trace process
; *		push	Argpointer	; address of arguments string
; *		push	Envpointer	; address of environment string
; *		push	Processid	; address to put process id
; *		push	PgmPointer	; address of program filename
; *		call	dosexecpgm
; *
; *	 RETURN SEQUENCE:    AX = error code
; *
; *
; *
; *	 MODULES CALLED:   INT 21H   function 4BH and 4DH
; *
; *
; *
; *************************************************************************

	global dosexecpgm
	; .sall
	; .xlist
	%include "macros.inc"
	; .list

inv_parm equ 0002
not_suf_mem equ 0004

struc str
old_bp: resw 1
return: resd 1
Pgmpointer: resd 1; address of program file name
Processid: resd 1; this is used when only sync exec
EnvPointer: resd 1; address of environment string
ArgPointer: resd 1; address of argument string
Traceindic: resw 1; ignored,  what is a trace process?
Asyncindic: resw 1; ignored,  PC-DOS always waits!
endstruc

dosexecpgm:; push registers
	Enter	dosexecpgm

	mov	ax,seg buffer			; setup buffer segment
	mov	ds,ax				;   and copy info into
	; assume	ds:buffer;      data buffer

	mov	ax,word [bp+2].EnvPointer	; seg portion only for pc-dos
	mov	EnvironmentSegment,ax		; copy environment string

	les	di,[bp].ArgPointer
	mov	word ArgumentPointer+0,di	; copy argument string
	mov	word ArgumentPointer+2,es

	xor	ax,ax
	mov	word Default_5C_FCB+0,ax	; setup defaults
	mov	word Default_5C_FCB+2,ax

	mov	word Default_6C_FCB+0,ax
	mov	word Default_6C_FCB+2,ax

	mov	bx,ds
	mov	es,bx
	mov	bx,DosExecParameterBlock

	lds	dx,[bp].PgmPointer	   ; setup program name
	mov	ax,4b00h
	int	21h			   ; exec program  and
	jc	ErrorExit		   ;   check for error

	mov	ah,4dh
	int	21h			   ; get return code of program
	jc	ErrorExit		   ;   just executed and jump if
					   ;	   error
	mov	bx,seg buffer
	mov	ds,bx
	mov	DosExecPgmReturnCode,ax    ; else, save return code

	xor	ax,ax			   ; set no error code

ErrorExit:
	Mexit				   ; pop registers
	ret	str_size - 6		   ; return

; ENDP dosexecpgm

; END SECTION .dosxxx

	; end
