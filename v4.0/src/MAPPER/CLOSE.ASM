;0
; page 80,132

; title CP/DOS  DosClose  mapper   * * *

SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosClose
; *
; *	 FUNCTION: This module will close a file or a device.
; *
; *	 CALLING SEQUENCE:
; *
; *		   PUSH  WORD  FileHandle ;  File Handle or device handle
; *		   CALL  DosClose
; *
; *	 RETURN SEQUENCE:
; *
; *		   IF ERROR (AX not = 0)
; *
; *		      AX = Error Code:
; *
; *		      o   Invalid file handle
; *
; *
; *	 MODULES CALLED:  DOS int 21H function 3EH
; *
; *
; *************************************************************************

	global DosClose
	; .sall
	; .xlist
	%include "macros.inc"
	; .list

struc str
old_bp: dw 0
return: dd 0
FileHandle: dw 0; file or device handle
endstruc


DosClose:
	Enter	DosClose	       ; push registers

; Only files are closed.  Devices are not closed, since OPEN creates
; a dummy device handle without actually openning the device.

	mov	bx,[bp].FileHandle     ; load the handle
	mov	ax,bx		       ; check for device handle
	neg	ax		       ; if device handle, return
	jns	GoodExit	       ; do not close the device

FileCloseRequest:
	mov	ax,03e00h	       ; load opcode
	int	21h		       ; close the file
	jc	ErrorExit	       ; return if error

GoodExit:
	sub	ax,ax		       ; else, set good return code

ErrorExit:
	mexit			       ; pop registers
	ret	str_size - 6	       ; return

; ENDP DosClose

; END SECTION .dosxxx

	; end
