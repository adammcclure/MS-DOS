; page 60,132

; title CP/DOS  DOSPutMessage  mapper

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosPutMessage
; *
; *	 FILE NAME: dos035.asm
; *
; *	 FUNCTION:   diplay message
; *
; *	 CALLING SEQUENCE:
; *
; *		push	handle		; file handle
; *		push	messlgth	; message length
; *		push	messbuff	; message buffer
; *		call	dosputmessage
; *
; *	 RETURN SEQUENCE:   AX = return code
; *
; *
; *
; *	 MODULES CALLED:     INT 21H  function 4
; *
; *************************************************************************

	global dosputmessage
	; .sall
	; .xlist
	%include "macros.inc"
	; .list

struc str
old_bp: resw 1
return: resd 1
MessagePtr: resd 1; message pointer
MessageLength: resw 1; message length
Handle: resw 1; file handle
endstruc

dosputmessage:

	Enter	dosputmessage		      ; save registers

	mov	bx,[bp].Handle		      ; get handle
	mov	cx,[bp].MessageLength	      ; get message length
	lds	dx,[bp].MessagePtr	      ; setup message buffer

	mov	ah,40h			      ; load opcode
	int	21h			      ; display message
	jc	ErrorExit		      ; jump if error

	xor	ax,ax			      ; else set good return code

ErrorExit:
	Mexit				      ; pop registers
	ret	str_size - 6		      ; return

; ENDP dosputmessage

; END SECTION .dosxxx

	; end
