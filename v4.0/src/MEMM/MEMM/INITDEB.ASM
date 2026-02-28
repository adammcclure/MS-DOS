

; page	58,132
;******************************************************************************
	; title	InitDeb - initialize debugger
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM.EXE - MICROSOFT Expanded Memory Manager 386 Driver
;
;   Module:   InitDeb - initialize debugger
;
;   Version:  0.04
;
;   Date:     June 16,1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   06/16/86  Original	from VDM MAIN.ASM module
;   06/28/86  0.02	Name changed from MEMM386 to MEMM
;   07/06/86  0.04	Changed assume to DGROUP
;
;******************************************************************************
;
;   Functional Description:
;
;	This routine is linked in when linking with the kernel debugger.
;    InitDeb calls the debugger initialization routine.
;
;******************************************************************************
; .lfcond; list false conditionals
CPU 386
;******************************************************************************
;	P U B L I C S
;******************************************************************************

	global InitDeb

;******************************************************************************
;	D E F I N E S
;******************************************************************************
	%include "VDMseg.inc"
	%include "VDMsel.inc"

FALSE		equ	0
TRUE		equ	not FALSE
CR		equ	0dh
LF		equ	0ah

MASTER_IMR	equ	21h		; mask port for master 8259

;
; Definition of the packet used in debug initialization. A pointer to
; this structure is passed to Debug_Entry.
;
struc DebugInit
	CSseg: dw 0;Real mode code segment
	DSseg: dw 0;Real mode data segment
	CSsel: dw 0;Prot mode code selector
	DSsel: dw 0;Prot mode data selector
	SpareSel1: dw 0;Prot mode alias selector 1
	SpareSel2: dw 0;Prot mode alias selector 2
	GDTalias: dw 0;Prot mode GDT r/w alias
	ProtIDTaddr: dq 0;Prot mode IDT base & limit
	RealIDTaddr: dq 0;Real mode IDT base & limit
	BrkFlag: db 0;TRUE if break to debugger
	ComFlag: db 0;TRUE if com1, FALSE if com2
endstruc


;******************************************************************************
;	E X T E R N A L   R E F E R E N C E S
;******************************************************************************
%ifndef NoBugMode
SECTION .dcode
extern _Debug_Entry; (debinit.asm)
; END SECTION .dcode
%endif

SECTION ._DATA

extern GDT_Seg

; END SECTION ._DATA

;******************************************************************************
;	S E G M E N T	D E F I N I T I O N S
;******************************************************************************

SECTION ._DATA

InitData	DebugInit	<>

; END SECTION ._DATA

;
;   code
;
SECTION .LAST

	; assume cs:LAST, ds:DGROUP, es:DGROUP

;******************************************************************************
;	InitDeb - initialize kernel debugger
;
;
;    ENTRY:	Real Mode
;		DS = DGROUP
;		AL = 00h => dont't break on debug init
;		AL = FFh => break on debug init
;
;    EXIT:	Real Mode
;		Kernel debugger initialized
;
;    USED:	none
;
;******************************************************************************
InitDeb:
;
%ifndef NoBugMode
	pusha
	push	ds
	push	es
;
	push	ds
	pop	es		; ES = data
;
	mov	di, InitData

	mov	bx, dcode
	mov	[di].CSseg, bx
	mov	bx, ddata
	mov	[di].DSseg, bx
	mov	[di].CSsel, DEBC_GSEL
	mov	[di].DSsel, DEBD_GSEL
	mov	[di].SpareSel1, DEBW1_GSEL
	mov	[di].SpareSel2, DEBW2_GSEL
	mov	[di].GDTalias, GDTD_GSEL
	mov	[di].BrkFlag, al		; ? break on entry ?
	mov	[di].ComFlag, FALSE		; com2

	sidt	[di].RealIDTaddr

	push	ds
	push	di
	mov	ax, [GDT_Seg]
	mov	ds, ax

	lgdt	qword ds:[GDTD_GSEL]

	mov	si, IDTD_GSEL
	mov	cx, 6
	lea	di, [di].ProtIDTaddr
	cld
	rep movsb
	pop	di
	pop	ds

	call	_Debug_Entry
;
; and return
;
	pop	es
	pop	ds
	popa
%endif
	ret
; ENDP InitDeb


; END SECTION .LAST

	; END
