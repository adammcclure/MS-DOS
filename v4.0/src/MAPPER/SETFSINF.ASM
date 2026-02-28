
; page 80,132
;0
; title CP/DOS  DosSetFsInfo	mapper


SECTION .dosxxx
	; assume	cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
; ************************************************************************* *
; *
; *	 MODULE: DosSetFsInfo
; *
; *	 FUNCTION: This module will delete the volume label on a specified
; *		   drive.
; *
; *	 CALLING SEQUENCE:
; *
; *		   PUSH  WORD	DriveNumber	  ; Drive Number
; *		   PUSH  OTHER	FSInfoLevel	  ; File system info required
; *		   PUSH@ OTHER	FSInfoBuf	  ; File system info buffer
; *		   PUSH  WORD	FSInfoBufSize	  ; file system info buffer size
; *		   Call  DosSetFsInfo
; *
; *
; *	 MODULES CALLED:  DOS int 21H function 13H
; *
; *************************************************************************

	global DosSetFsInfo
	; .sall
	; .xlist
	%include "macros.inc"
	%include "error.inc"
	; .list

struc str
old_bp: dw 0
return: dd 0
sbufsize: dw 0; info buffer size
sbuffoff: dw 0; info buffer offset
sbuffseg: dw 0; info buffer segment
slevel: dw 0; info level
sdrive: dw 0; drive number
endstruc


;-----------------------------------------------
;---	Extended FCB, used to delete Volume Labels.
;-----------------------------------------------
Ext_FCB 	db	0FFh			;Indicates extended FCB
		db	0,0,0,0,0		;Reserved
FCB_Attr	db	08			;Attribute for vol label
FCBDrive	db	0			;Drive number
VLabel		db	"???????????"           ;Match any vol name found
		times 25 db 0;Rest of the opened FCB








DosSetFsInfo:
	Enter	DosSetfsinfo	; push registers
	mov	ax,[bp].sdrive	; Get drive number
	mov	FCBDrive,al	; Place it in the extended FCB
;--------------------------
;-- FCB Delete old volume label
;--------------------------
	mov	ah,013h 	; FCB Delete
	push	cs
	pop	ds
	mov	dx,Ext_FCB
	int	021h		; Call DOS to delete volume label
;---------------------------------
;-- Handle_Create new Volume label
;---------------------------------
	mov	cx,08h		; Volume label attribute
	mov	ah,03ch 	; Handle create new volume label
	mov	dx,[bp].sbuffoff
	push	[bp].sbuffseg
	pop	ds
	int	021h		; Do it
	jc	retrn		; Oops, there was an error. Not surprised...
;--------------------------
;-- Close the Volume Label
;--------------------------
	mov	bx,ax		; Place handle in BX
	mov	ah,03eh 	; Close the volume label
	int	021h		; Do IT!


deleted:
	sub	ax,ax		   ; set good return code
retrn:
	mexit			   ; pop registers
	ret	str_size - 6	   ; return

; ENDP DosSetFsInfo

; END SECTION .dosxxx

	; end
