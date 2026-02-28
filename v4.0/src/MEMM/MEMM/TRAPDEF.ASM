

	; page	58,132
;******************************************************************************
	; title	TRAPDEF.ASM - I/O trap Dispatch table
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM.EXE - MICROSOFT Expanded Memory Manager 386 Driver
;
;   Module:   TRAPDEF.ASM - I/O trap Dispatch table
;
;   Version:  0.04
;
;   Date:     July 1, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   08/11/86		Split from IOTrap.asm
;   
;   7/26/88   		Added Trap handler entries for DMA ports on Channel 4
;			 - Jaywant H Bharadwaj
;
;******************************************************************************
;
; .lfcond; list false conditionals
CPU 386
	; page
;******************************************************************************
;			P U B L I C   D E C L A R A T I O N S
;******************************************************************************
;
	global IOTrap_Tab; dispatches I/O trap handlers
	global IOT_BadT; Unknown port trap routine
	global IOT_OEM; OEM specific port emulation

	; page
;******************************************************************************
;			L O C A L   C O N S T A N T S
;******************************************************************************
;
; % - how many of these are actually needed?
; % - Need any includes from Win/386 DMA code - trapdef.asm ?

	%include "VDMseg.inc"
	%include "VDMsel.inc"
	%include "desc.inc"
	%include "elim.inc"
	%include "page.inc"
	%include "oemdep.inc"
	%include "instr386.inc"
	%include "vm386.inc"
;
;******************************************************************************
;			E X T E R N A L   R E F E R E N C E S
;******************************************************************************
;

SECTION ._DATA
;extrn	_map_size:byte		; # of mapping registers used
;extrn	LIMP_Addr:word
; END SECTION ._DATA

SECTION ._TEXT
;
extern RRP_Handler
extern A20_Handler; Kybd Data port - A20 watch
extern DMABase0;  DMA base register for Channel 0
extern DMABase1;  DMA base register for Channel 1
extern DMABase2;  DMA base register for Channel 2
extern DMABase3;  DMA base register for Channel 3
extern DMABase5;  DMA base register for Channel 5
extern DMABase6;  DMA base register for Channel 6
extern DMABase7;  DMA base register for Channel 7
extern DMACnt0;  DMA count register for Channel 0
extern DMACnt1;  DMA count register for Channel 1
extern DMACnt2;  DMA count register for Channel 2
extern DMACnt3;  DMA count register for Channel 3
extern DMACnt5;  DMA count register for Channel 5
extern DMACnt6;  DMA count register for Channel 6
extern DMACnt7;  DMA count register for Channel 7
extern DMAPg0;  DMA page register for Channel 0
extern DMAPg1;  DMA page register for Channel 1
extern DMAPg2;  DMA page register for Channel 2
extern DMAPg3;  DMA page register for Channel 3
extern DMAPg5;  DMA page register for Channel 5
extern DMAPg6;  DMA page register for Channel 6
extern DMAPg7;  DMA page register for Channel 7
extern DMAClrFF1;  clear flip-flop cmd for channels 0-3
extern DMAClrFF2;  clear flip-flop cmd for channels 5-7
extern DMAMode1;  Mode register for channels 0-3
extern DMAMode2;  Mode register for channels 4-7

; END SECTION ._TEXT

;******************************************************************************
;			S E G M E N T	D E F I N I T I O N
;******************************************************************************

;
;------------------------------------------------------------------------------
SECTION ._TEXT
	; assume	cs:_TEXT, ds:DGROUP, es:DGROUP, ss:DGROUP
;
;   IOTrapTab
;	One entry per port in the I/O space from 00h to FFh.
;	Note that ports not specifically mapped otherwise(by IOT_OEM or
;	LIM emulation and whose least significant 10 bits are less than
;	100h are also dispatched through this table(upper 6 bits assumed to
;	be intended as zero since some earlier systems only had 10 bits of
;	I/O addressing).
;
IOTrap_Tab:
	dw	DMAbase0  ;  0 DMA base register for Channel 0
	dw	DMACnt0   ;  1 DMA count register for Channel 0
	dw	DMABase1  ;  2 DMA base register for Channel 1
	dw	DMACnt1   ;  3 DMA count register for Channel 1
	dw	DMABase2  ;  4 DMA base register for Channel 2
	dw	DMACnt2   ;  5 DMA count register for Channel 2
	dw	DMABase3  ;  6 DMA base register for Channel 3
	dw	DMACnt3   ;  7 DMA count register for Channel 3
	dw	IOT_BadT  ;  8
	dw	IOT_BadT  ;  9
	dw	IOT_BadT  ;  a
	dw	DMAMode1  ;  b DMA Mode Register for for Ch 0-3
	dw	DMAClrFF1   ;  c clear flip-flop cmd for channels 0-3
	dw	IOT_BadT  ;  d
	dw	IOT_BadT  ;  e
	dw	IOT_BadT  ;  f
	dw	IOT_BadT  ; 10
	dw	IOT_BadT  ; 11
	dw	IOT_BadT  ; 12
	dw	IOT_BadT  ; 13
	dw	IOT_BadT  ; 14
	dw	IOT_BadT  ; 15
	dw	IOT_BadT  ; 16
	dw	IOT_BadT  ; 17
	dw	IOT_BadT  ; 18
	dw	IOT_BadT  ; 19
	dw	IOT_BadT  ; 1a
	dw	IOT_BadT  ; 1b
	dw	IOT_BadT  ; 1c
	dw	IOT_BadT  ; 1d
	dw	IOT_BadT  ; 1e
	dw	IOT_BadT  ; 1f
	dw	IOT_BadT  ; 20
	dw	IOT_BadT  ; 21
	dw	IOT_BadT  ; 22
	dw	IOT_BadT  ; 23
	dw	IOT_BadT  ; 24
	dw	IOT_BadT  ; 25
	dw	IOT_BadT  ; 26
	dw	IOT_BadT  ; 27
	dw	IOT_BadT  ; 28
	dw	IOT_BadT  ; 29
	dw	IOT_BadT  ; 2a
	dw	IOT_BadT  ; 2b
	dw	IOT_BadT  ; 2c
	dw	IOT_BadT  ; 2d
	dw	IOT_BadT  ; 2e
	dw	IOT_BadT  ; 2f
	dw	IOT_BadT  ; 30
	dw	IOT_BadT  ; 31
	dw	IOT_BadT  ; 32
	dw	IOT_BadT  ; 33
	dw	IOT_BadT  ; 34
	dw	IOT_BadT  ; 35
	dw	IOT_BadT  ; 36
	dw	IOT_BadT  ; 37
	dw	IOT_BadT  ; 38
	dw	IOT_BadT  ; 39
	dw	IOT_BadT  ; 3a
	dw	IOT_BadT  ; 3b
	dw	IOT_BadT  ; 3c
	dw	IOT_BadT  ; 3d
	dw	IOT_BadT  ; 3e
	dw	IOT_BadT  ; 3f
	dw	IOT_BadT  ; 40
	dw	IOT_BadT  ; 41
	dw	IOT_BadT  ; 42
	dw	IOT_BadT  ; 43
	dw	IOT_BadT  ; 44
	dw	IOT_BadT  ; 45
	dw	IOT_BadT  ; 46
	dw	IOT_BadT  ; 47
	dw	IOT_BadT  ; 48
	dw	IOT_BadT  ; 49
	dw	IOT_BadT  ; 4a
	dw	IOT_BadT  ; 4b
	dw	IOT_BadT  ; 4c
	dw	IOT_BadT  ; 4d
	dw	IOT_BadT  ; 4e
	dw	IOT_BadT  ; 4f
	dw	IOT_BadT  ; 50
	dw	IOT_BadT  ; 51
	dw	IOT_BadT  ; 52
	dw	IOT_BadT  ; 53
	dw	IOT_BadT  ; 54
	dw	IOT_BadT  ; 55
	dw	IOT_BadT  ; 56
	dw	IOT_BadT  ; 57
	dw	IOT_BadT  ; 58
	dw	IOT_BadT  ; 59
	dw	IOT_BadT  ; 5a
	dw	IOT_BadT  ; 5b
	dw	IOT_BadT  ; 5c
	dw	IOT_BadT  ; 5d
	dw	IOT_BadT  ; 5e
	dw	IOT_BadT  ; 5f
	dw	A20_Handler	; A20 watch on kybd data port
	dw	IOT_BadT  ; 61
	dw	IOT_BadT  ; 62
	dw	IOT_BadT  ; 63
	dw	A20_Handler	; A20 watch on kybd cmd port
	dw	IOT_BadT  ; 65
	dw	IOT_BadT  ; 66
	dw	IOT_BadT  ; 67
	dw	IOT_BadT  ; 68
	dw	IOT_BadT  ; 69
	dw	IOT_BadT  ; 6a
	dw	IOT_BadT  ; 6b
	dw	IOT_BadT  ; 6c
	dw	IOT_BadT  ; 6d
	dw	IOT_BadT  ; 6e
	dw	IOT_BadT  ; 6f
	dw	IOT_BadT  ; 70
	dw	IOT_BadT  ; 71
	dw	IOT_BadT  ; 72
	dw	IOT_BadT  ; 73
	dw	IOT_BadT  ; 74
	dw	IOT_BadT  ; 75
	dw	IOT_BadT  ; 76
	dw	IOT_BadT  ; 77
	dw	IOT_BadT  ; 78
	dw	IOT_BadT  ; 79
	dw	IOT_BadT  ; 7a
	dw	IOT_BadT  ; 7b
	dw	IOT_BadT  ; 7c
	dw	IOT_BadT  ; 7d
	dw	IOT_BadT  ; 7e
	dw	IOT_BadT  ; 7f
	dw	IOT_BadT  ; 80
	dw	DMAPg2    ; 81 DMA page register for Channel 2
	dw	DMAPg3    ; 82 DMA page register for Channel 3
	dw	DMAPg1    ; 83 DMA page register for Channel 1
	dw	RRP_Handler	; return to real port
	dw	RRP_Handler	; return to real port
	dw	IOT_BadT  ; 86
	dw	DMAPg0    ; 87 DMA page register for Channel 0
	dw	IOT_BadT  ; 88
	dw	DMAPg6    ; 89 DMA page register for Channel 6
	dw	DMAPg7    ; 8a DMA page register for Channel 7
	dw	DMAPg5    ; 8b DMA page register for Channel 5
	dw	IOT_BadT  ; 8c
	dw	IOT_BadT  ; 8d
	dw	IOT_BadT  ; 8e
	dw	IOT_BadT  ; 8f
	dw	IOT_BadT  ; 90
	dw	DMAPg2    ; 91 DMA page register for Channel 2
	dw	DMAPg3    ; 92 DMA page register for Channel 3
	dw	DMAPg1    ; 93 DMA page register for Channel 1
	dw	IOT_BadT  ; 94
	dw	IOT_BadT  ; 95
	dw	IOT_BadT  ; 96
	dw	IOT_BadT  ; 97 DMA page register for Channel 0
	dw	IOT_BadT  ; 98
	dw	DMAPg6    ; 99 DMA page register for Channel 6
	dw	DMAPg7    ; 9a DMA page register for Channel 7
	dw	DMAPg5    ; 9b DMA page register for Channel 5
	dw	IOT_BadT  ; 9c
	dw	IOT_BadT  ; 9d
	dw	IOT_BadT  ; 9e
	dw	IOT_BadT  ; 9f
	dw	IOT_BadT  ; a0
	dw	IOT_BadT  ; a1
	dw	IOT_BadT  ; a2
	dw	IOT_BadT  ; a3
	dw	IOT_BadT  ; a4
	dw	IOT_BadT  ; a5
	dw	IOT_BadT  ; a6
	dw	IOT_BadT  ; a7
	dw	IOT_BadT  ; a8
	dw	IOT_BadT  ; a9
	dw	IOT_BadT  ; aa
	dw	IOT_BadT  ; ab
	dw	IOT_BadT  ; ac
	dw	IOT_BadT  ; ad
	dw	IOT_BadT  ; ae
	dw	IOT_BadT  ; af
	dw	IOT_BadT  ; b0
	dw	IOT_BadT  ; b1
	dw	IOT_BadT  ; b2
	dw	IOT_BadT  ; b3
	dw	IOT_BadT  ; b4
	dw	IOT_BadT  ; b5
	dw	IOT_BadT  ; b6
	dw	IOT_BadT  ; b7
	dw	IOT_BadT  ; b8
	dw	IOT_BadT  ; b9
	dw	IOT_BadT  ; ba
	dw	IOT_BadT  ; bb
	dw	IOT_BadT  ; bc
	dw	IOT_BadT  ; bd
	dw	IOT_BadT  ; be
	dw	IOT_BadT  ; bf
	dw	IOT_BadT  ; c0 DMA base register for Channel 4
	dw	IOT_BadT  ; c1
	dw	IOT_BadT  ; c2 DMA count register for Channel 4
	dw	IOT_BadT  ; c3
	dw	DMABase5  ; c4 DMA base register for Channel 5
	dw	IOT_BadT  ; c5
	dw	DMACnt5   ; c6 DMA count register for Channel 5
	dw	IOT_BadT  ; c7
	dw	DMABase6  ; c8 DMA base register for Channel 6
	dw	IOT_BadT  ; c9
	dw	DMACnt6   ; ca DMA count register for Channel 6
	dw	IOT_BadT  ; cb
	dw	DMABase7  ; cc DMA base register for Channel 7
	dw	IOT_BadT  ; cd
	dw	DMACnt7   ; ce DMA count register for Channel 7
	dw	IOT_BadT  ; cf
	dw	IOT_BadT  ; d0
	dw	IOT_BadT  ; d1
	dw	IOT_BadT  ; d2
	dw	IOT_BadT  ; d3
	dw	IOT_BadT  ; d4
	dw	IOT_BadT  ; d5
	dw	DMAMode2  ; d6 DMA Mode Register for channels 4-7
	dw	IOT_BadT  ; d7
	dw	DMAClrFF2   ; d8 clear flip-flop cmd for channels 5-7
	dw	IOT_BadT  ; d9
	dw	IOT_BadT  ; da
	dw	IOT_BadT  ; db
	dw	IOT_BadT  ; dc
	dw	IOT_BadT  ; dd
	dw	IOT_BadT  ; de
	dw	IOT_BadT  ; df
	dw	IOT_BadT  ; e0
	dw	IOT_BadT  ; e1
	dw	IOT_BadT  ; e2
	dw	IOT_BadT  ; e3
	dw	IOT_BadT  ; e4
	dw	IOT_BadT  ; e5
	dw	IOT_BadT  ; e6
	dw	IOT_BadT  ; e7
	dw	IOT_BadT  ; e8
	dw	IOT_BadT  ; e9
	dw	IOT_BadT  ; ea
	dw	IOT_BadT  ; eb
	dw	IOT_BadT  ; ec
	dw	IOT_BadT  ; ed
	dw	IOT_BadT  ; ee
	dw	IOT_BadT  ; ef
	dw	IOT_BadT  ; f0
	dw	IOT_BadT  ; f1
	dw	IOT_BadT  ; f2
	dw	IOT_BadT  ; f3
	dw	IOT_BadT  ; f4
	dw	IOT_BadT  ; f5
	dw	IOT_BadT  ; f6
	dw	IOT_BadT  ; f7
	dw	IOT_BadT  ; f8
	dw	IOT_BadT  ; f9
	dw	IOT_BadT  ; fa
	dw	IOT_BadT  ; fb
	dw	IOT_BadT  ; fc
	dw	IOT_BadT  ; fd
	dw	IOT_BadT  ; fe
	dw	IOT_BadT  ; ff

;******************************************************************************
;   IOT_BadT - GP fault on Unknown I/O address
;
;   DESCRIPTION:    This routine is entered by being in the IOTrap_Tab above
;		and also for I/O ports which are not LIM(DMA) ports and are not
;		emulated by IOT_OEM routine below and the first 10 bits of the
;		address is greater than 100h. Note that only the first 10 bits
;		of the port (times 2) is passed in BX.	If the entire port
;		address is desired, it is available on the stack as the value
;		which is popped into DX.
;
;   ENTRY: Protected Mode Ring 0
;		return address, DX, DS, return address on stack
;		AL = byte to output to port.
;		BX == 2 * port address(either 0-1FE or 200-7FE)
;		DX == 0  => Emulate input
;		   <> 0  => Emulate output
;		DS = DGROUP
;		SS:BP = points to stack frame on entry to GP fault handler
;
;
;   EXIT:  Protected Mode Ring 0
;		First return address, pop'd from stack.
;		DX and DS restored from stack.
;		BX = DX on entry
;		STC => I/O NOT emulated.
;
;   WARNING:***********
;	    This routine is closely allied with IOTrap which is in IOTrap.
;	    It is assumed that IOTrap puts the stack in a certain state!
;	    ***********

;   USED:  Flags
;   STACK:
;------------------------------------------------------------------------------
;
IOT_BadT:
	pop	bx		;   dump return address
	mov	bx,dx		; restore BX
	pop	dx		; restore DX(port address)
	pop	ds		; restore DS
	stc			;   port not emulated !
	ret			;  and return
; ENDP IOT_BadT

;******************************************************************************
;   IOT_OEM - Handles OEM specific I/O traps
;
;   ENTRY: Protected Mode Ring 0
;		AL = byte to output to port.
;		DX = port address for I/O.
;		SS:BP = points to stack frame on entry to GP fault handler
;		BX = 0 => Emulate Input.
;		   <>0 => Emulate Output.
;		DS = DGROUP
;		stack: near return to IOTrap, DX, DS, near return from IOTrap
;
;   EXIT:  Protected Mode Ring 0
;		Either emulate I/O and pop return, DX, DS from stack and RET
;		    with CF = 1(CF = 0 if I/O is to be ignored!?!?).
;		Or just return(no emulation done)
;
;
;   WARNING:***********
;	    This routine is closely allied with IOTrap.
;	    It assumes that the stack is in a certain state!
;	    ***********
;
;
;   USED:  Flags
;   STACK:
;------------------------------------------------------------------------------
IOT_OEM:
;	cmp	dx,????
;	jnz	NoEmulation
;	or	bx,bx
;	jnz	NoEmulation
;	mov	al,???? 	;emulate input
;	pop	dx		;remove return
;	pop	dx		;restore DX
;	pop	ds		;restore DS
;	ret			;return from IOTRAP
;
;NoEmulation:
	ret			; no emulation
; ENDP IOT_OEM


; END SECTION ._TEXT

	; end
