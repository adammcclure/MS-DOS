;
; page 80,132
;
; title CP/DOS  DosDelete  mapper
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosDelete
; *
; *	 FILE NAME: DOS012.ASM
; *
; *	 FUNCTION: This module removes a directory entry associated with a
; *		   filename.
; *
; *
; *	 CALLING SEQUENCE:
; *
; *		   PUSH@ ASCIIZ FileName  ;  FileName path
; *		   PUSH@ DWORD 0	  ;  Reserved (must be zero)
; *		   CALL  DosDelete
; *
; *	 RETURN SEQUENCE:
; *
; *		   IF ERROR (AX not = 0)
; *
; *		      AX = Error Code:
; *		      o   Invalid file path name
; *
; *	 MODULES CALLED:  DOS int 21H  function 41H
; *
; *
; *
; *************************************************************************

	global DosDelete
	; .sall
	; .xlist
	%include "macros.inc"
	; .list

struc str
old_bp: resw 1
return: resd 1
dtrm12: resd 1; reserved, always 0
asc012: resd 1; file name path pointer
endstruc

DosDelete:
	Enter	DosDelete		    ; push registers

	lds	dx,dword [bp].asc012    ; file path name

	mov	ah,041h
	int	21h			    ; delete the file
	jc	err012			    ; jump if no error

	sub	ax,ax			    ; set good return code

err012:
	mexit				    ; pop registers
	ret	str_size - 6		    ; return

; ENDP DosDelete

; END SECTION .dosxxx

	; end
