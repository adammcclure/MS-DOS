;0
; page 80,132

; title CP/DOS KbdFlushBuffer mapper

SECTION .kbdxxx
	; assume	cs:kbdxxx,ds:nothing,es:nothing,ss:nothing

; ************************************************************************* *
; *
; *	 MODULE: kbdflushbuffer
; *
; *************************************************************************
;
	global kbdflushbuffer
	; .sall
	; .xlist
	%include "kbd.inc"
	; .list

	global savedkbdinput
savedkbdinput:
		db	0	; Character goes here
		db	0	; Not zero means char is here


struc str
old_bp: resw 1
return: resd 1
handle: resw 1; kbd handle
endstruc

kbdflushbuffer:
	Enter	KbdFlushBuffer	  ; push registers
	mov	ah,0bh		  ; Check for ^C
	int	021h

	mov	ax,0c06h
	mov	dl,-1
	int	021h
	jz	nochar

	mov	ah,1
	mov	savedkbdinput,ax
	jmp	done
nochar:
	mov	savedkbdinput,0

done:	sub	ax,ax		  ; set good return code
	Mexit			  ; pop registers
	ret	str_size - 6	  ; return

; ENDP kbdflushbuffer

; END SECTION .kbdxxx

	; end
