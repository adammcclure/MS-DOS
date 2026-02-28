; 0
; page 80,132
;
; title CP/DOS DosQFileInfo mapper
;

SECTION .FileAttributeSegment

	 extern FileAttributeTable

; END SECTION .FileAttributeSegment

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosQfileinfo
;*
;*   FILE NAME: dos052.asm
;*
;*   CALLING SEQUENCE:
;*
;*	 push	   word     filehandle
;*	 push	   word     fileinfolevel
;*	 push@	   other    fileinfobuffer
;*	 push	   word     filebuffersize
;*	 call	   dossetfileinfo
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=57h, set file's date/time
;*
;*********************************************************************

	    global dosQfileinfo
	    ; .sall
	    ; .xlist
	    %include "macros.inc"
	    ; .list


struc FileInfo
CreateDate: dw 0
CreateTime: dw 0
LastAccessDate: dw 0
LastAccessTime: dw 0
LastWriteDate: dw 0
LastWriteTime: dw 0
DataLength: dd 0; File size
FileSpace: dd 0; falloc_size
Attributes: dw 0; attributes
endstruc


struc str
old_bp: dw 0
return: dd 0
BufferSize: dw 0; file data buffer size
BufferPtr: dd 0; file data buffer
Level: dw 0; file data info level
Handle: dw 0; file handle
endstruc

dosQfileinfo:
	Enter	dosQfileinfo		   ; save registers

	mov	bx,[bp].handle		   ;fill registers for function call

	mov	ax,05700h
	int	21h			   ; get file date and time
	jc	ErrorExit		   ; jump if error

	lds	si,[bp].BufferPtr	   ; copy date and time to
	mov	ds:[si].CreateDate,dx	   ; file info return data area
	mov	ds:[si].CreateTime,cx
	mov	ds:[si].LastAccessDate,dx
	mov	ds:[si].LastAccessTime,cx
	mov	ds:[si].LastWriteDate,dx
	mov	ds:[si].LastWriteTime,cx

;  Calculate the file length and file space and save in the file info data area

	mov	cx,0			   ; get the current position
	mov	dx,0
	mov	bx,[bp].handle		   ; get file handle

	mov	ax,04201h
	int	21h			   ; move file pointer to the
	jc	ErrorExit		   ; current position

	push	dx
	push	ax

	mov	cx,0
	mov	dx,0
	mov	bx,[bp].Handle

	mov	ax,04202h		   ; move file pointer to end-of-file
	int	21h

	lds	si,[bp].BufferPtr		  ; save the file length in
	mov	ds:word DataLength[si+0],ax   ; file info data area
	mov	ds:word DataLength[si+2],dx

	test	ax,511
	jz	HaveSpace

	and	ax,not 511
	add	ax,512
	adc	dx,0

HaveSpace:
	mov	ds:word FileSpace[si+0],ax	    ; save file space
	mov	ds:word FileSpace[si+2],dx	    ; in return data area

;   calculate the file attribute  and save

	pop	dx
	pop	cx

	mov	bx,[bp].Handle

	mov	ax,04200h
	int	21h			       ; move the file pointer
	jc	ErrorExit

	mov	ax,seg FileAttributeSegment
	mov	ds,ax
	; assume	ds:FileAttributeSegment

	mov	bx,[bp].Handle
	add	bx,bx

	mov	ax,FileAttributeTable[bx]
	mov	[bp].Attributes,ax	       ; save file attribute

	sub	ax,ax			       ; set good return code

ErrorExit:
	mexit				       ; restore registers
	ret	 str_size - 6		       ; return

; ENDP dosqfileinfo

; END SECTION .dosxxx

	    ; end
