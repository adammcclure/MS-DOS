;0
; page 80,132
;
; title CP/DOS  DosAllocSeg  mapper
;
SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosAllocSeg
; *
; *	 FUNCTION: This module allocates a segment of memory to the
; *		requesting process
; *
; *	 CALLING SEQUENCE:
; *
; *		push	size		; number of bytes requested
; *		push@	selector	; selector allocated (returned)
; *		push	shareind	; whether segment will be shared
; *		call	dosallocseg
; *
; *	 RETURN SEQUENCE:
; *
; *		AX = error	, 0 = no error
; *
; *	 MODULES CALLED:  DOS int 21h
; *
; *************************************************************************
;
	global dosallocseg
	; .sall
	; .xlist
	%include "macros.inc"
	; .list
;
struc str
old_bp: dw 0
return: dd 0
ShareIndicator: dw 0; whether segment will be shared
SelectorPtr: dd 0; selector allocated
SegmentSize: dw 0; number of bytes requested
endstruc

dosallocseg:
	Enter	dosallocseg		 ; push registers

	mov	bx,[bp].SegmentSize	 ; Get segment size

	test	bx,0000fh		 ; check segment size
	jz	NoRoundRequired

	and	bx,not 0000fh
	add	bx,00010h

NoRoundRequired:
	cmp	bx,0			 ; check for 0 (full seg)
	je	AllocateMax		 ; jmp to full seg

	shr	bx,1			 ; convert segment in bytes to
	shr	bx,1			 ; paragraph
	shr	bx,1
	shr	bx,1
	jmp	HaveSize

AllocateMax:
	mov	bx,4096 		 ; setup default paragraph size

HaveSize:
	mov	ah,48h			 ; set up for dos allocate call
	int	21h			 ; allocate segment
	jc	ErrorExit		 ; jump if error

	lds	si,[bp].SelectorPtr	 ; get selector address
	mov	ds:[si],ax		 ; save allocated memory block

AllocDone:
	sub	ax,ax			 ; set good return code
ErrorExit:
	mexit				 ; pop registers
	ret	str_size - 6		 ; return

; ENDP dosallocseg

; END SECTION .dosxxx

	; end
