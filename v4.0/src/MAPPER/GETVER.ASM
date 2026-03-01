; page 80,132

; title CP/DOS DosGetVersion mapper

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosgetversion
;*
;*   CALLING SEQUENCE:
;*
;*	 push@	   word  versionword pointer
;*	 call	   dosgetversion
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=30h, get version
;*
;*********************************************************************

	    global dosgetversion
	    ; .sall
	    %include "macros.inc"

struc str
old_bp: resw 1
Return: resd 1
Data: resd 1; return data area pointer
endstruc

dosgetversion:
	Enter	dosgetversion
	lds	si,[bp].data	      ; set pointer

	mov	ah,30h		      ; get DOS version
	int	21h

	mov	byte [si],ah      ; minor version
	mov	byte [si]+1,al    ; major version

exit:	mexit			      ; pop registers
	sub	ax,ax
	ret	str_size - 6
;
; ENDP dosgetversion

; END SECTION .dosxxx

	    ; end
