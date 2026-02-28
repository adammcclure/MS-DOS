; 0
; page 80,132

; title CP/DOS DosSetFileInfo mapper


SECTION .FileAttributeSegment

	extern FileAttributeTable

; END SECTION .FileAttributeSegment


SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dossetfileinfo
;*
;*   FUNCTION:	set file information
;*
;*   CALLING SEQUENCE:
;*
;*	 push	   word     file handle
;*	 push	   word     info level
;*	 push@	   other    file info buffer
;*	 push	   word     file buffer size
;*	 call	   dossetfileinfo
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=57h, set file's date/time
;*
;*********************************************************************

	    global dossetfileinfo
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list



struc str
old_bp: dw 0
return: dd 0
BufferSize: dw 0; file info buufer size
BufferPtr: dd 0; file info buffer
Level: dw 0; file info level
Handle: dw 0; file handle
endstruc

dossetfileinfo:
	Enter	dossetfileinfo	      ; push registers

	mov	bx,[bp].Handle	      ; fill registers for function call
	lds	si,[bp].BufferPtr     ; date/time pointer
	mov	dx,word [si]+8    ; date to be set
	mov	cx,word [si]+10   ; time to be set

	mov	ax,5701h
	int	21h
	jc	ErrorExit	      ; check for error

; This code should be un-commented when the attribute can be set from
; the setfileinfo call

;	lds	si,[bp].BufferPtr
;	mov	ax,ds:[si].the offset to the attribute word

;	mov	bx,seg FileAttributeSegment
;	mov	ds,bx
;	assume	ds:FileAttributeSegment

;	mov	bx,[bp].Handle
;	add	bx,bx

;	mov	FileAttributeTable[bx],ax

	sub	ax,ax		       ; set good return code

ErrorExit:
	mexit			       ; pop registers
	ret	str_size - 6	       ; return

; ENDP dossetfileinfo

; END SECTION .dosxxx

	    ; end
