; page	       60,132
; name	       _msgret
; title	       C to Message Retriever
;-------------------------------------------------------------------
;
;	MODULE: 	_msgret
;
;	PURPOSE:	Supplies an interface between C programs and
;			the DOS 3.3 message retriever
;
;	CALLING FORMAT:
;			msgret(&inregs,&outregs);
;
;	DATE:		5-21-87
;
;-------------------------------------------------------------------

	%include "SYSMSG.INC";PERMIT SYSTEM MESSAGE HANDLER DEFINITION ;AN000;

	MSG_UTILNAME <FILESYS>		;IDENTIFY THE COMPONENT 		;AN000;

;-------------------------------------------------------------------
;-------------------------------------------------------------------


SECTION ._TEXT
; END SECTION ._TEXT
SECTION ._DATA
; END SECTION ._DATA
SECTION .CONST
; END SECTION .CONST
SECTION ._BSS
; END SECTION ._BSS

; DGROUP	GROUP	CONST, _BSS, _DATA
	; ASSUME	CS: DGROUP, DS: DGROUP, SS: DGROUP, ES: NOTHING

	global data_sysloadmsg
	global data_sysdispmsg

SECTION ._DATA

	MSG_SERVICES <MSGDATA>
	MSG_SERVICES <LOADmsg,FARmsg>
	MSG_SERVICES <DISPLAYmsg,CHARmsg,NUMmsg>
	MSG_SERVICES <FILESYS.CLA,FILESYS.CL1,FILESYS.CL2,FILESYS.CTL>		    ;AN000;


data_sysloadmsg:

	push	bp			; save user's base pointer
	mov	bp,sp			; set bp to current sp
	push	di			; save some registers
	push	si

;	copy C inregs into proper registers

	mov	di,[bp+4+4]		  ; fix di (arg 0)

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
	mov	di,[bp+6+4]		  ; fix di (arg 1)

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

; ENDP data_sysloadmsg


data_sysdispmsg:

	push	bp			; save user's base pointer
	mov	bp,sp			; set bp to current sp
	push	di			; save some registers
	push	si

;	copy C inregs into proper registers

	mov	di,[bp+4+4]		  ; fix di (arg 0)

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

	call	sysdispmsg

;-------------------------------------------------------------------

	pop	bp			; restore base pointer
	push	di			; the di value from call is now on stack
	mov	di,[bp+6+4]		  ; fix di (arg 1)

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

; ENDP data_sysdispmsg

%include "msgdcl.inc"


; END SECTION ._DATA; end code segment

SECTION ._TEXT

	; assume cs:_TEXT

	global _sysdispmsg
	global _sysloadmsg

_sysdispmsg:
		call	data_sysdispmsg
		ret
; ENDP _sysdispmsg

_sysloadmsg:
		call	data_sysloadmsg
		ret
; ENDP _sysloadmsg

; END SECTION ._TEXT
	; end

