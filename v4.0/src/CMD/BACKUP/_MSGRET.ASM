; page	60,132
; name	_msgret
; title	C	to Message Retriever
;-------------------------------------------------------------------
;
;	MODULE: 	_msgret
;
;	PURPOSE:	Supplies an interface between C programs and
;			the DOS 3.30 message retriever
;
;	CALLING FORMAT:
;			sysloadmsg(&inregs,&outregs);
;			sysdispmsg(&inregs,&outregs);
;			sysgetmsg(&inregs,&outregs);
;
;	DATE:		5-21-87
;
;-------------------------------------------------------------------

	%include "SYSMSG.INC";PERMIT SYSTEM MESSAGE HANDLER DEFINITION ;AN000;

	MSG_UTILNAME <BACKUP>		;IDENTIFY THE COMPONENT 		;AN000;

	; .8087
SECTION ._TEXT
; END SECTION ._TEXT
SECTION ._DATA
; END SECTION ._DATA
SECTION .CONST
; END SECTION .CONST
SECTION ._BSS
; END SECTION ._BSS
; DGROUP	GROUP	CONST, _BSS, _DATA
	; ASSUME	CS: _TEXT, DS: _TEXT, SS: DGROUP, ES: DGROUP


	global _sysloadmsg
	global _sysdispmsg
	global _update_logfile

;-------------------------------------------------------------------
;-------------------------------------------------------------------

SECTION ._DATA
; .XLIST
; .XCREF
	MSG_SERVICES <MSGDATA>		;DATA AREA FOR THE MESSAGE HANDLER	     ;AN000;

; .LIST
; .CREF
; END SECTION ._DATA


SECTION ._TEXT

;-------------------------------------------------------------------
					;DEFAULT=CHECK DOS VERSION
					;DEFAULT=NEARmsg
					;DEFAULT=INPUTmsg
					;DEFAULT=NUMmsg
					;DEFAULT=NO TIMEmsg
					;DEFAULT=NO DATEmsg
; .XLIST
; .XCREF
	MSG_SERVICES <LOADmsg,DISPLAYmsg,GETmsg,INPUTmsg,CHARmsg,NUMmsg,TIMEmsg,DATEmsg,FARmsg> ;AN000;
	MSG_SERVICES <BACKUP.CTL,BACKUP.CLA,BACKUP.CL1,BACKUP.CL2> ;AN000;
; .LIST
; .CREF
;-------------------------------------------------------------------

_sysloadmsg:

	push	bp			; save user's base pointer
	mov	bp,sp			; set bp to current sp
	push	di			; save some registers
	push	si

;	copy C inregs into proper registers

	mov	di,[bp+4]		; fix di (arg 0)

;-------------------------------------------------------------------

	mov	ax,[di+0ah]		; load di
	push	ax			; the di value from inregs is now on stack

	mov	ax,[di+00]		; get inregs.x.ax
	mov	bx,[di+02]		; get inregs.x.bx
	mov	cx,[di+04]		; get inregs.x.cx
	mov	dx,[di+06]		; get inregs.x.dx
	mov	si,[di+08]		; get inregs.x.si
	pop	di			; get inregs.x.di from stack

	push	bp			; save base pointer

;-------------------------------------------------------------------
	call	sysloadmsg		; call the message retriever
;-------------------------------------------------------------------

	pop	bp			; restore base pointer
	push	di			; the di value from call is now on stack
	mov	di,[bp+6]		; fix di (arg 1)

	mov	[di+00],ax		; load outregs.x.ax
	mov	[di+02],bx		; load outregs.x.bx
	mov	[di+04],cx		; load outregs.x.cx
	mov	[di+06],dx		; load outregs.x.dx
	mov	[di+08],si		; load outregs.x.si

	lahf				; get flags into ax
	mov	al,ah			; move into low byte
	mov	[di+0ch],ax		; load outregs.x.cflag

	pop	ax			; get di from stack
	mov	[di+0ah],ax		; load outregs.x.di

;-------------------------------------------------------------------

	pop	si			; restore registers
	pop	di
	mov	sp,bp			; restore sp
	pop	bp			; restore user's bp
	ret

; ENDP _sysloadmsg


;============================================================================
;============================================================================
;============================================================================


_update_logfile:

	push	bp			; save user's base pointer
	mov	bp,sp			; set bp to current sp
	push	di			; save some registers
	push	si

	mov	di,[bp+4]		; fix di (arg 0)
;-------------------------------------------------------------------
	mov	ax,[di+0ah]		; load di
	push	ax			; the di value from inregs is now on stack

	mov	ax,[di+00]		; get inregs.x.ax
	mov	bx,[di+02]		; get inregs.x.bx
	mov	cx,[di+04]		; get inregs.x.cx
	mov	dx,[di+06]		; get inregs.x.dx
	mov	si,[di+08]		; get inregs.x.si
	pop	di			; get inregs.x.di from stack

	push	bp			; save base pointer
;-------------------------------------------------------------------
	mov	dh,-1			; Message class, Utility message
	mov	cs:handle,bx		;AN000;9 Save logfile handle
	mov	cs:len,cx		;AN000;9  Save write length
	push	ds			;AN000;9
	pop	cs:save_ds		;AN000;9
	call	sysgetmsg		; call the message retriever
;-------------------------------------------------------------------
	pop	bp			; restore base pointer
	push	di			; the di value from call is now on stack
	mov	di,[bp+6]		; fix di (arg 1)

	mov	[di+00],ax		; load outregs.x.ax
	mov	[di+02],bx		; load outregs.x.bx
	mov	[di+04],cx		; load outregs.x.cx
	mov	[di+06],dx		; load outregs.x.dx
	mov	[di+08],si		; load outregs.x.si

	lahf				; get flags into ax
	mov	al,ah			; move into low byte
	mov	[di+0ch],ax		; load outregs.x.cflag

	pop	ax			; get di from stack
	mov	[di+0ah],ax		; load outregs.x.di
	mov	cs:offst,si		;AN000;9

	pop	si			; restore registers
	pop	di
	mov	sp,bp			; restore sp
	pop	bp			; restore user's bp

	mov	ah,040h 		;AN000;9 Write the message to logfile
	mov	bx,cs:handle		;AN000;9
	mov	cx,cs:len		;AN000;9
	mov	dx,cs:offst		;AN000;9
	int	021h			;AN000;9
	push	cs:save_ds		;AN000;9
	pop	ds			;AN000;9
	ret

	handle: dw 0;AN000;9
	len: dw 0;AN000;9
	offst: dw 0;AN000;9
	save_ds: dw 0;AN000;9
; ENDP _update_logfile

;============================================================================
;============================================================================
;============================================================================


_sysdispmsg:

	push	bp			; save user's base pointer
	mov	bp,sp			; set bp to current sp
	push	di			; save some registers
	push	si

;	copy C inregs into proper registers

	mov	di,[bp+4]		; fix di (arg 0)
;-------------------------------------------------------------------
	mov	ax,[di+0ah]		; load di
	push	ax			; the di value from inregs is now on stack

	mov	ax,[di+00]		; get inregs.x.ax
	mov	bx,[di+02]		; get inregs.x.bx
	mov	cx,[di+04]		; get inregs.x.cx
	mov	dx,[di+06]		; get inregs.x.dx
	mov	si,[di+08]		; get inregs.x.si
	pop	di			; get inregs.x.di from stack

	push	bp			; save base pointer
;-------------------------------------------------------------------
	call	sysdispmsg		; call the message retriever
;-------------------------------------------------------------------
	pop	bp			; restore base pointer
	push	di			; the di value from call is now on stack
	mov	di,[bp+6]		; fix di (arg 1)

	mov	[di+00],ax		; load outregs.x.ax
	mov	[di+02],bx		; load outregs.x.bx
	mov	[di+04],cx		; load outregs.x.cx
	mov	[di+06],dx		; load outregs.x.dx
	mov	[di+08],si		; load outregs.x.si

	lahf				; get flags into ax
	mov	al,ah			; move into low byte
	mov	[di+0ch],ax		; load outregs.x.cflag

	pop	ax			; get di from stack
	mov	[di+0ah],ax		; load outregs.x.di
;-------------------------------------------------------------------
	pop	si			; restore registers
	pop	di
	mov	sp,bp			; restore sp
	pop	bp			; restore user's bp
	ret

; ENDP _sysdispmsg

;============================================================================
;============================================================================
;============================================================================

;============================================================================
;============================================================================
;============================================================================

%include "msgdcl.inc"


; END SECTION ._TEXT; end code segment
	; end

