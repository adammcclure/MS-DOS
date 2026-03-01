; page 80,132

; title CP/DOS  DosQFsInfo  mapper

SECTION .buffer

clsdr40: dw 0
avlcls40: dw 0
secalc40: dw 0
bytsec40: dw 0

; END SECTION .buffer

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosQFsInfo
; *
; *	 FILE NAME: DOS040.ASM
; *
; *	 FUNCTION: This module will return the information for a file
; *		   system device.
; *
; *	 CALLING SEQUENCE:
; *
; *		   PUSH  WORD	DriveNumber	  ; Drive Number
; *		   PUSH  OTHER	FSInfoLevel	  ; File system info required
; *		   PUSH@ OTHER	FSInfoBuf	  ; File system info buffer
; *		   PUSH  WORD	FSInfoBufSize	  ; file system info buffer size
; *		   Call  DosQFsInfo
; *
; *
; *	 RETURN SEQUENCE:
; *
; *		   IF ERROR (AX not = 0)
; *
; *		      AX = Error Code:
; *
; *		      o   Invalid parameter
; *
; *
; *	 MODULES CALLED:  DOS int 21H function 19H
; *			  DOS int 25H
; *
; *
; *************************************************************************

	global DosQFsInfo
	; .sall
	; .xlist
	%include "macros.inc"
	%include "error.inc"
	; .list

struc str
old_bp: resw 1
return: resd 1
FSIBS40: resw 1; info buffer size
FSIB40: resd 1; info buffer
ILL40: resw 1; info level
DRNUM40: resw 1; driver number
endstruc

DosQFsInfo:
	Enter	Dosqfsinfo	   ; push registers

	mov	dx,[bp].drnum40    ; load drive number
	mov	ah,036h
	int	21h		   ; get disk space

	cmp	ax,0ffffh	   ; check if valid drive number
	jne	valdr40 	   ; jump if drive is ok

	mov	ax,error_invalid_parameter  ; esle set error code
	jmp	erret40 	   ; error return

valdr40:;
	push	ax
	mov	ax,buffer	   ; set the data segment and save
	push	ax		   ; space information in the data area
	pop	ds
	; assume	ds:buffer
	mov	avlcls40,bx	   ; save available cluster
	mov	clsdr40,dx	   ; save clusters per drive
	mov	bytsec40,cx	   ; save bytes per sector
	pop	ax		   ;
	mov	secalc40,ax	   ; save sectors per allocation unit
	mov	ax,[bp].ill40	   ; get info level
	cmp	al,01		   ; valid level ??
	je	getinfo40	   ; jump if valid

	mov	ax,error_invalid_parameter  ; else invalid parameter
	jmp	erret40 	   ; error return

getinfo40:;
	mov	ax,[bp].fsibs40    ; get info buffer size address
	cmp	ax,18		   ; check if valid
	jge	bufok40 	   ; jump if valid

	mov	ax,error_buffer_overflow  ; move buffer not big enough
	jmp	erret40 	   ; error return

bufok40:;
	les	di,[bp].fsib40	   ; get FSI buffer pointer
	sub	ax,ax		   ; return
	mov	[es:di],ax	   ;	    null
	mov	[es:di]+2,ax	   ;		File system ID
	add	di,4		   ; set pointer to number of sectors in alloc
	sub	ax,ax		   ;
	mov	[es:di]+2,ax	   ; set high order # of sectors in alloc to 0
	mov	ax,secalc40	   ;
	mov	[es:di],ax	   ; store low order # of sectors in alloc
	add	di,4		   ; set pointer to number of allocation units
	mov	ax,clsdr40	   ; load low order number
	mov	[es:di],ax	   ;		     of alloc units
	sub	ax,ax		   ;
	mov	[es:di]+2,ax	   ; set high order # of alloc units to 0
	mov	ax,avlcls40	   ; load low order number
	mov	[es:di]+4,ax	   ;		       of avail alloc units
	sub	ax,ax		   ;
	mov	[es:di]+6,ax	   ; set high order # of avail alloc to 0
	mov	ax,bytsec40	   ; get number
	mov	[es:di]+8,ax	   ;	       of bytes per sector
	sub	ax,ax		   ; set good return code

erret40:;
	mexit			   ; pop registers
	ret	str_size - 6	   ; return

; ENDP DosQFsInfo

; END SECTION .dosxxx

	; end
