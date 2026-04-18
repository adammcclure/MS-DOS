

; page	58,132
;******************************************************************************
	; title	VMINST.ASM - Virtual Mode GP fault instruction emulation
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM.EXE - MICROSOFT Expanded Memory Manager 386 Driver
;
;   Module:   VMINST.ASM - Virtual Mode GP fault instruction emulation
;
;   Version:  0.07
;
;   Date:     February 11, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   02/12/86  Original
;   04/07/86  A-	Added call to LIM emulation routines for all I/O.
;			Bit Map set up to trap only LIM related ports. SBP.
;   05/12/86  B 	Cleanup and segment reorganization
;   05/18/86  C 	Added VM privileged instruction emulation
;   06/08/86  D 	Added calls to RRTrap.
;   06/14/86  E 	Changed stack saves from BP, BX, SI to EBP, EBX, ESI
;   06/15/86  F 	Changed inc [bp.VTFOE+VMTF_EIP] to inc SI in Prefix
;			Handlers
;   06/15/86  G 	Added MOVSB and MOVSW for Rash Rule emulation
;   06/16/86  H 	Added Error Handler interfaces, BugMode conditional
;			assembly constructs, and Error Handler return logic
;   06/19/86  0.01	Changed call JumpReal to jmp JumpReal
;   06/19/86  0.01	Clear TF bit on all INT reflects, but not on emulations.
;   06/19/86  0.01	CLTS now does a clts for the VM client.
;   06/27/86  0.02	INT3 emulation now ALLWAYS reflects
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/01/86  0.03	Call to IO_Trap instead of LIM_Trap
;   07/03/86  0.03	Let IO_Trap handle A20 and Return to real logic
;   07/05/86  0.04	JumpReal in R_CODE
;   07/06/86  0.04	changed assume to DGROUP
;   07/10/86  0.05	added MB_Flag check for move block emulator
;   07/30/86  0.06	removed PortClear reference
;   08/05/86  0.07	Changed EmHalt to really HLT if user IF=0
;   07/20/88		Removed debugger codes (pc)
;
;******************************************************************************
;
;   Functional Description:
;
;   This module contains the routines that handle GP faults fielded from
;   Virtual Mode.  The offending instruction is either emulated or we exit
;   to the debugger.
;
;   NOTE: The current implementation is sufficient for breadboard - see
;	'to do' notes in various header for holes.  Specifically, the only
;	override that is handled is REP, and only for INS/OUTS.  Segment
;	overrides are not yet supported.
;
;******************************************************************************
; .lfcond; list false conditionals
CPU 386
	; page
;******************************************************************************
;			P U B L I C   D E C L A R A T I O N S
;******************************************************************************
;
	global VmInst; module label
	global VmFault
	global EmProtIns; just for debug map
	global EmMovCDTR; just for debug map
	global EmMOVSW; just for debug map
;
;******************************************************************************
;			E X T E R N A L   R E F E R E N C E S
;******************************************************************************
;
SECTION .R_CODE
	extern JumpReal; cont client in RM (rrtrap.asm)
	extern MB_Flag; non-zero => do move block
; END SECTION .R_CODE

SECTION ._TEXT
	extern IO_Trap; I/O Trap Dispatcher
	extern EM286ll; 286 loadall emulator (EM286LL)
	extern EM386ll; 386 loadall emulator (EM386LL)
	extern Move_Block; Int 15h move block function (MOVEB)
	extern hw_int; HW-ROM reflection code (VMTRAP)
	extern ErrHndlr; Handle user's error response
	extern MapLinear; map linear address
	extern UnMapLinear; unmap linear address
; END SECTION ._TEXT

	; page
;******************************************************************************
;			I N C L U D E	F I L E S
;******************************************************************************

%include "VDMseg.inc"
%include "desc.inc"
%include "VDMsel.inc"
%include "vm386.inc"
%include "loadall.inc"
%include "instr386.inc"
%include "oemdep.inc"
;******************************************************************************
;			L O C A L   C O N S T A N T S
;******************************************************************************
;
FALSE	equ	0
TRUE	equ	not FALSE

LOCK_PREFIX	equ	0F0h

IF_FLAG equ	0200h		; IF bit in flags
DF_FLAG equ	0400h		; DF bit in flags

;
; bit flags for instruction prefixes
;
REP_FLAG	equ	0001h
REPNE_FLAG	equ	0002h
REPS_FLAG	equ	(REP_FLAG or REPNE_FLAG)
CS_FLAG 	equ	0004h
DS_FLAG 	equ	0008h
ES_FLAG 	equ	0010h
SS_FLAG 	equ	0020h
FS_FLAG 	equ	0040h
GS_FLAG 	equ	0080h
LOCK_FLAG	equ	0100h
OPER_SZ_FLAG	equ	0200h
ADDR_SZ_FLAG	equ	0400h
P0F_FLAG	equ	0800h

; page
;******************************************************************************
;			L O C A L   D A T A  A R E A
;******************************************************************************
SECTION ._DATA

PrefixFlag	dw	0		; flags for Fault Instr Prefixes
RefNum		dw	0		; Reflect number for RefToRom

; END SECTION ._DATA

; page
;******************************************************************************
;			     C O D E	A R E A
;******************************************************************************
SECTION ._TEXT
	; assume	cs:_TEXT, ds:DGROUP, es:DGROUP, ss:DGROUP

VmInst:
;
;   Index table for opcode emulation dispatch - This is too general-purpose
;   if all we want to handle is INT instructions, but it'll get fleshed out
;   later, when we start emulating IOPL-sensitive stuff
;
; the directive below is giving problems because this segment is byte aligned
; will fix it..sunilp
;	 EVEN				  ; word aligning should make execution
					 ; faster
OpTable:
	dw	BadVmTrap	 ;  0 - LLDT, LTR, SLDT, STR, VERR, VERW
	dw	EmProtIns	 ;  1 - LGDT, LIDT, LMSW
	dw	BadVmTrap	 ;  2 - LAR
	dw	BadVmTrap	 ;  3 - LSL
	dw	BadVmTrap	 ;  4
	dw	EmLoadal2	 ;  5 - 286Loadall
	dw	EmCLTS	 ;  6 - CLTS
	dw	EmLoadal3	 ;  7 - 386Loadall
	dw	BadVmTrap	 ;  8
	dw	BadVmTrap	 ;  9
	dw	BadVmTrap	 ;  a
	dw	BadVmTrap	 ;  b
	dw	BadVmTrap	 ;  c
	dw	BadVmTrap	 ;  d
	dw	BadVmTrap	 ;  e
	dw	Prefix_0F	 ;  f
	dw	BadVmTrap	 ; 10
	dw	BadVmTrap	 ; 11
	dw	BadVmTrap	 ; 12
	dw	BadVmTrap	 ; 13
	dw	BadVmTrap	 ; 14
	dw	BadVmTrap	 ; 15
	dw	BadVmTrap	 ; 16
	dw	BadVmTrap	 ; 17
	dw	BadVmTrap	 ; 18
	dw	BadVmTrap	 ; 19
	dw	BadVmTrap	 ; 1a
	dw	BadVmTrap	 ; 1b
	dw	BadVmTrap	 ; 1c
	dw	BadVmTrap	 ; 1d
	dw	BadVmTrap	 ; 1e
	dw	BadVmTrap	 ; 1f
	dw	EmMovCDTR	 ; 20 - Mov Rn, CRn
	dw	EmMovCDTR	 ; 21 - Mov Rn, DRn
	dw	EmMovCDTR	 ; 22 - Mov CRn, Rn
	dw	EmMovCDTR	 ; 23 - Mov DRn, Rn
	dw	EmMovCDTR	 ; 24 - Mov Rn, TRn
	dw	BadVmTrap	 ; 25
	dw	ESOverride  ; 26 - ES Override & Mov TRn, Rn
	dw	BadVmTrap	 ; 27
	dw	BadVmTrap	 ; 28
	dw	BadVmTrap	 ; 29
	dw	BadVmTrap	 ; 2a
	dw	BadVmTrap	 ; 2b
	dw	BadVmTrap	 ; 2c
	dw	BadVmTrap	 ; 2d
	dw	CSOverride  ; 2e - CS Override
	dw	BadVmTrap	 ; 2f
	dw	BadVmTrap	 ; 30
	dw	BadVmTrap	 ; 31
	dw	BadVmTrap	 ; 32
	dw	BadVmTrap	 ; 33
	dw	BadVmTrap	 ; 34
	dw	BadVmTrap	 ; 35
	dw	SSOverride  ; 36 - SS Override
	dw	BadVmTrap	 ; 37
	dw	BadVmTrap	 ; 38
	dw	BadVmTrap	 ; 39
	dw	BadVmTrap	 ; 3a
	dw	BadVmTrap	 ; 3b
	dw	BadVmTrap	 ; 3c
	dw	BadVmTrap	 ; 3d
	dw	DSOverride  ; 3e - DS Override
	dw	BadVmTrap	 ; 3f
	dw	BadVmTrap	 ; 40
	dw	BadVmTrap	 ; 41
	dw	BadVmTrap	 ; 42
	dw	BadVmTrap	 ; 43
	dw	BadVmTrap	 ; 44
	dw	BadVmTrap	 ; 45
	dw	BadVmTrap	 ; 46
	dw	BadVmTrap	 ; 47
	dw	BadVmTrap	 ; 48
	dw	BadVmTrap	 ; 49
	dw	BadVmTrap	 ; 4a
	dw	BadVmTrap	 ; 4b
	dw	BadVmTrap	 ; 4c
	dw	BadVmTrap	 ; 4d
	dw	BadVmTrap	 ; 4e
	dw	BadVmTrap	 ; 4f
	dw	BadVmTrap	 ; 50
	dw	BadVmTrap	 ; 51
	dw	BadVmTrap	 ; 52
	dw	BadVmTrap	 ; 53
	dw	BadVmTrap	 ; 54
	dw	BadVmTrap	 ; 55
	dw	BadVmTrap	 ; 56
	dw	BadVmTrap	 ; 57
	dw	BadVmTrap	 ; 58
	dw	BadVmTrap	 ; 59
	dw	BadVmTrap	 ; 5a
	dw	BadVmTrap	 ; 5b
	dw	BadVmTrap	 ; 5c
	dw	BadVmTrap	 ; 5d
	dw	BadVmTrap	 ; 5e
	dw	BadVmTrap	 ; 5f
	dw	BadVmTrap	 ; 60
	dw	BadVmTrap	 ; 61
	dw	BadVmTrap	 ; 62
;
; ARPL is used to return from virtual mode to protected mode for use in MEMM
;
	dw	ReturnEMM	 ; 63 - ARPL (return to Protected mode gateway)
	dw	FSOverride  ; 64 - FS override
	dw	GSOverride  ; 65 - GS override
	dw	BadVmTrap	 ; 66 - Operand size override
	dw	BadVmTrap	 ; 67 - Address size override
	dw	BadVmTrap	 ; 68
	dw	BadVmTrap	 ; 69
	dw	BadVmTrap	 ; 6a
	dw	BadVmTrap	 ; 6b
	dw	EmINSB	 ; 6c - INSB
	dw	EmINSW	 ; 6d - INSW
	dw	EmOUTSB	 ; 6e - OUTSB
	dw	EmOUTSW	 ; 6f - OUTSW
	dw	BadVmTrap	 ; 70
	dw	BadVmTrap	 ; 71
	dw	BadVmTrap	 ; 72
	dw	BadVmTrap	 ; 73
	dw	BadVmTrap	 ; 74
	dw	BadVmTrap	 ; 75
	dw	BadVmTrap	 ; 76
	dw	BadVmTrap	 ; 77
	dw	BadVmTrap	 ; 78
	dw	BadVmTrap	 ; 79
	dw	BadVmTrap	 ; 7a
	dw	BadVmTrap	 ; 7b
	dw	BadVmTrap	 ; 7c
	dw	BadVmTrap	 ; 7d
	dw	BadVmTrap	 ; 7e
	dw	BadVmTrap	 ; 7f
	dw	BadVmTrap	 ; 80
	dw	BadVmTrap	 ; 81
	dw	BadVmTrap	 ; 82
	dw	BadVmTrap	 ; 83
	dw	BadVmTrap	 ; 84
	dw	BadVmTrap	 ; 85
	dw	BadVmTrap	 ; 86
	dw	BadVmTrap	 ; 87
	dw	BadVmTrap	 ; 88
	dw	BadVmTrap	 ; 89
	dw	BadVmTrap	 ; 8a
	dw	BadVmTrap	 ; 8b
	dw	BadVmTrap	 ; 8c
	dw	BadVmTrap	 ; 8d
	dw	BadVmTrap	 ; 8e
	dw	BadVmTrap	 ; 8f
	dw	BadVmTrap	 ; 90
	dw	BadVmTrap	 ; 91
	dw	BadVmTrap	 ; 92
	dw	BadVmTrap	 ; 93
	dw	BadVmTrap	 ; 94
	dw	BadVmTrap	 ; 95
	dw	BadVmTrap	 ; 96
	dw	BadVmTrap	 ; 97
	dw	BadVmTrap	 ; 98
	dw	BadVmTrap	 ; 99
	dw	BadVmTrap	 ; 9a
	dw	BadVmTrap	 ; 9b
	dw	BadVmTrap	 ; 9c - PUSHF (not for IOPL=3)
	dw	BadVmTrap	 ; 9d - POPF (not for IOPL=3)
	dw	BadVmTrap	 ; 9e
	dw	BadVmTrap	 ; 9f
	dw	BadVmTrap	 ; a0
	dw	BadVmTrap	 ; a1
	dw	BadVmTrap	 ; a2
	dw	BadVmTrap	 ; a3
	dw	BadVmTrap	 ; a4 - MOVSB
	dw	EmMOVSW	 ; a5 - MOVSW
	dw	BadVmTrap	 ; a6
	dw	BadVmTrap	 ; a7
	dw	BadVmTrap	 ; a8
	dw	BadVmTrap	 ; a9
	dw	BadVmTrap	 ; aa
	dw	BadVmTrap	 ; ab
	dw	BadVmTrap	 ; ac
	dw	BadVmTrap	 ; ad
	dw	BadVmTrap	 ; ae
	dw	BadVmTrap	 ; af
	dw	BadVmTrap	 ; b0
	dw	BadVmTrap	 ; b1
	dw	BadVmTrap	 ; b2
	dw	BadVmTrap	 ; b3
	dw	BadVmTrap	 ; b4
	dw	BadVmTrap	 ; b5
	dw	BadVmTrap	 ; b6
	dw	BadVmTrap	 ; b7
	dw	BadVmTrap	 ; b8
	dw	BadVmTrap	 ; b9
	dw	BadVmTrap	 ; ba
	dw	BadVmTrap	 ; bb
	dw	BadVmTrap	 ; bc
	dw	BadVmTrap	 ; bd
	dw	BadVmTrap	 ; be
	dw	BadVmTrap	 ; bf
	dw	BadVmTrap	 ; c0
	dw	BadVmTrap	 ; c1
	dw	BadVmTrap	 ; c2
	dw	BadVmTrap	 ; c3
	dw	BadVmTrap	 ; c4
	dw	BadVmTrap	 ; c5
	dw	BadVmTrap	 ; c6
	dw	BadVmTrap	 ; c7
	dw	BadVmTrap	 ; c8
	dw	BadVmTrap	 ; c9
	dw	BadVmTrap	 ; ca
	dw	BadVmTrap	 ; cb
	dw	EmINT3	 ; cc - INT 3
	dw	EmINTnn	 ; cd - INT nn
	dw	EmINTO	 ; ce - INTO
	dw	BadVmTrap	 ; cf - IRET/EmIRET (not for IOPL=3)
	dw	BadVmTrap	 ; d0
	dw	BadVmTrap	 ; d1
	dw	BadVmTrap	 ; d2
	dw	BadVmTrap	 ; d3
	dw	BadVmTrap	 ; d4
	dw	BadVmTrap	 ; d5
	dw	BadVmTrap	 ; d6
	dw	BadVmTrap	 ; d7
	dw	BadVmTrap	 ; d8
	dw	BadVmTrap	 ; d9
	dw	BadVmTrap	 ; da
	dw	BadVmTrap	 ; db
	dw	BadVmTrap	 ; dc
	dw	BadVmTrap	 ; dd
	dw	BadVmTrap	 ; de
	dw	BadVmTrap	 ; df
	dw	BadVmTrap	 ; e0
	dw	BadVmTrap	 ; e1
	dw	BadVmTrap	 ; e2
	dw	BadVmTrap	 ; e3
	dw	EmINBimm	 ; e4 - INB imm
	dw	EmINWimm	 ; e5 - INW imm
	dw	EmOUTBimm	 ; e6 - OUTB imm
	dw	EmOUTWimm	 ; e7 - OUTW imm
	dw	BadVmTrap	 ; e8
	dw	BadVmTrap	 ; e9
	dw	BadVmTrap	 ; ea
	dw	BadVmTrap	 ; eb
	dw	EmINB	 ; ec - INB
	dw	EmINW	 ; ed - INW
	dw	EmOUTB	 ; ee - OUTB
	dw	EmOUTW	 ; ef - OUTW
	dw	EmLOCK	 ; f0 - LOCK
	dw	BadVmTrap	 ; f1
	dw	EmREPNE	 ; f2 - REPNE
	dw	EmREP	 ; f3 - REP/REPE
	dw	EmHALT	 ; f4 - HLT
	dw	BadVmTrap	 ; f5
	dw	BadVmTrap	 ; f6
	dw	BadVmTrap	 ; f7
	dw	BadVmTrap	 ; f8
	dw	BadVmTrap	 ; f9
	dw	BadVmTrap	 ; fa - CLI EmCLI (not for IOPL=3)
	dw	BadVmTrap	 ; fb - STI EmSTI (not for IOPL=3)
	dw	BadVmTrap	 ; fc
	dw	BadVmTrap	 ; fd
	dw	BadVmTrap	 ; fe
	dw	BadVmTrap	 ; ff - Change P0F_Invalid, if used

	; page
;******************************************************************************
;   VmFault - entry point for Virtual Mode GP faults (from routine vm_trap0d
;	in module VMTRAP.ASM).	The appropriate instructions are emulated and
;	control is returned to the Virtual Mode client.  Currently, we assume
;	the client is running WITH IOPL, INT gate DPL = 0, and a truncated
;	IDT, so INT instruction fault to here and are emulated.  All other
;	GP faults enter the debugger.
;
;   The following instructions are invalid in Real or Virtual Mode:
;
;	ARPL, LAR, LSL, VERR, VERW, STR, LTR, SLDT, LLDT
;
;   The following instructions are privileged and are thus invalid in
;   Virtual Mode since VM progs run at CPL 3:
;
;	LIDT, LDGT, LMSW, CLTS, HLT, Debug Register ops, Control
;	Register ops, and Test Register ops
;
;   If client does not have IOPL, the following instructions must be handled
;   (in addition to the INT instructions).  This scenario changes for B0:
;
;	IN, INS, OUT, OUTS, STI, CLI, LOCK, PUSHF, POPF, and IRET
;
;   For B0, the following instructions must be handled when they trap
;   according to the bit map in the TSS.
;
;	IN, INS, OUT, and OUTS
;
;   For Invalid Opcode (vm_trap06) emulation:
;   The following instructions are invalid in Real or Virtual Mode:
;
;	LTR, LLDT, LAR, LSL, ARPL, STR, SLDT, VERR, VERW
;
;   In fielding the exception from Virtual Mode, the 386 interrupt gate
;   switched to the Ring 0 stack and pushed 32-bit values as follows:
;
;	 hiword loword	offset (in addition to error code and BP push)
;	+------+------+ <-------- Top of 'kernel' stack
;	| 0000 |  GS  |  +32 (decimal)
;	|------+------|
;	| 0000 |  FS  |  +28
;	|------|------|
;	| 0000 |  DS  |  +24
;	|------|------|
;	| 0000 |  ES  |  +20
;	|------|------|
;	| 0000 |  SS  |  +16
;	|------|------|
;	|     ESP     |  +12
;	|------|------|
;	|    EFLAGS   |  +08
;	|------|------|
;	| 0000 |  CS  |  +04
;	|------|------|
;	|     EIP     |  +00
;	+------|------+
;	| error code  |
;	|------|------| <-------- Ring 0 SS:SP
;	|    (ebp)    |
;	+------+------+ <-------- Ring 0 SS:EBP
;
;
;   ENTRY:  386 Protected Mode - ring 0
;	    EBP is on the stack
;	    SS:BP -> VM trap frame on stack w/error code (faulting selector)
;	    GP exceptions are faults: pushed CS:EIP points to faulting opcode
;   EXIT:   via IRET to VM client, instruction emulated as necessary
;   USED:   (none) (note that DS & ES are free to use - saved during trap)
;   STACK:  n/a
;------------------------------------------------------------------------------
VmFault:
	PUSH_EBX			; local registers
	PUSH_ESI
	HwTabUnlock			; unlock high ram for gdt changes
	mov	bx,GDTD_GSEL		; get GDT data alias
	mov	ds,bx			; DS -> GDT
;
;   Build a selector (VM1_GSEL) to client's stack.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	mov	bx,[bp+VTFOE+VMTF_SS]	; BX = VM SS (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_SS]	; BX = VM SS (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
;
;   Build a selector (VM2_GSEL) to client's code segment, as above.
;
	mov	bx,[bp+VTFOE+VMTF_CS]	; BX = VM CS (in segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM2_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_CS]	; BX = VM CS (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM2_GSEL+4],bh	; place in descriptor
;
;   Reset prefix flags
;
	mov	bx,VDMD_GSEL
	mov	es,bx
	mov	[ES:PrefixFlag],0	; start with no prefixes
;
;   Jump to appropriate instruction handler
;
	mov	bx,VM2_GSEL
	mov	ds,bx			; DS = selector for VM code segment
	mov	si,[bp+VTFOE+VMTF_EIP]	; DS:SI = VM CS:IP
VmInsHandle:
	mov	bl,[ds:si]		; BL = opcode
	mov	bh,0			; BX = opcode
	shl	bx,1			; BX = BX*2 (word table)
					; DS:SI = VM CS:IP
					; ES pts to local data segment
					; VM1_GSEL pts to VM SS
					; VM2_GSEL pts to VM CS
	jmp	cs:OpTable[bx]		; enter instruction emulation routine

; ENDP VmFault

; page
;******************************************************************************
;   BadVmTrap - unsupported Virtual Mode GP exception - enter the debugger
;
;   ENTRY:  EBP,EBX,ESI are on the stack
;   EXIT:   to the debugger
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
BadVmTrap:
	jmp	Reflect6		; Reflect to VM illegal opcode handler
; ENDP BadVmTrap

; page
;******************************************************************************
;   ReturnEMM - user is trying to go back into the protected mode via ARPL
;
;   ENTRY:  EBP,EBX,ESI are on the stack
;   EXIT:   to the debugger
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
ReturnEMM:
	add	si, 2			; "IP" now points to instruction
	push	si			;   after "ARPL reg,reg"
	ret				; back in protected mode!
; ENDP ReturnEMM

; page
;******************************************************************************
;   EmINTnn - emulate software interrupt
;
;   The emulation of the software INT instructions requires us to massage
;   the trap stack frame (see VmFault header) and build a 'real mode'
;   stack frame for the virtual mode client so that we can transfer
;   control to virtual mode at the address specified in the appropriate
;   real mode IDT vector.  The client's IRET out of the interrupt routine
;   will proceed normally (assuming we're letting him run with IOPL = 3).
;   Since we're fielding the trap from Virtual Mode, we assume the high
;   word of ESP and EIP is 0000.
;
;	+-------+ <-------- Client's current SS:SP
;	| Flags |  +4
;	|-------|
;	|  CS	|  +2
;	|-------|
;	|  IP	|  +0
;	+-------+ <-------- Client's SS:SP when we let him have control
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode = CD nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;	    appropriate real mode IRET set up @ client's SS:SP
;   USED:   (none)
;   STACK:
;
;   to do:  Streamline this code - it's on the critical path
;	    Decide about how to handle Trace Bit in general
;------------------------------------------------------------------------------
EmINTnn:

	inc	si			; DS:SI -> nn (int #)

;   Check for Int15 (Move Block call)
	cmp	byte [si], 15h
	jne	NotInt15
	cmp	ah,87h			;Q: is this a move block call ?
	jne	NotInt15		; N: process as normal interrupt
	mov	bx,RCODEA_GSEL		; Y: check local flag
	mov	ds,bx			;    DS -> R_CODE seg
	; ASSUME	DS:R_CODE
	cmp	[MB_Flag],0		; Q: do we see this move block ?
	je	NotInt15		;   N: process as normal int
					;   Y:	emulate move block
					; set up VM1_GSEL to point to ES:0 from
					; Virtual Mode
			;NOTE: DS -> R_CODE
	inc	si
	mov	[bp+VTFOE+VMTF_EIP], si ; point beyond int6 instr
	mov	bx,GDTD_GSEL
	mov	es,bx			; ES pts to GDT
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = ES seg addr
	shl	bx,4			; BX = low 16 bits of ES addr
	mov	[es:VM1_GSEL+2],bx	; set low 16 bits of ES base addr
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = ES seg addr again
	shr	bx,4			; BH = high 8 bits of ES addr
	mov	[es:VM1_GSEL+4],bh	; place in descriptor

	mov	bx,VM1_GSEL
	mov	es,bx			; ES pts to VM ES area

	mov	bx,sp			; SS:BX -> GP Fault stack frame
	mov	si,[SS:bx+GPF_ESI]	; ES:SI pts to caller's gdt
	call	move_block		; move block function
	mov	[ds:MB_Flag],0		;  turn off flag !!

	; ASSUME	DS:DGROUP; done with R_CODE

	jmp	short EmSkipLockExit	;  exit, but skip table lock.
					;	 move block MAY unlock tables.
;
;   Adjust client's SP to make room for building his IRET frame
;
NotInt15:
	sub	word [bp+VTFOE+VMTF_ESP],6	; adjust client's SP
	mov	bx,VM1_GSEL
	mov	ds,bx			; DS = VM stack segment
	mov	si,[bp+VTFOE+VMTF_ESP]	; DS:SI -> client's IRET stack frame
;
;   Move low 16 bits of Flags, CS, and EIP from IRET frame to client stack frame
;
	mov	bx,[bp+VTFOE+VMTF_EFLAGS] ; low word of EFLAGS
;
; *** Clear IF bit on flags for reflect, but leave it unchanged for the
;	flags on the IRET stack we build on the client's stack
; *** Also clear the Trace Flag -> because all software INTs clear the trace
;      flag.
;
	and	[bp+VTFOE+VMTF_EFLAGS],not 300h

	mov	[ds:si+4],bx		; to client's flags
	mov	bx,[bp+VTFOE+VMTF_CS]	;
	mov	[ds:si+2],bx		; to client's CS
	mov	bx,[bp+VTFOE+VMTF_EIP]	; low word of EIP
	add	bx,2			; set IP past the instruction we emulate
	mov	[ds:si+0],bx		; to client's IP
;
;   Replace low 16 bits of IRET frame CS:EIP with vector from real mode IDT
;
	mov	si,VM2_GSEL
	mov	ds,si			; DS -> Client's code segment
	mov	bl,[ds:bx-1]		; get INTerrupt number
	xor	bh,bh			; BX has INT number
	shl	bx,2			; BX = BX * 4 (vector table index)
	mov	si,RM_IDT_GSEL		; get real mode IDT alias
	mov	ds,si			; DS -> Real Mode IDT
	mov	si,[ds:bx]		;
	mov	[bp+VTFOE+VMTF_EIP],si	; move the IP
	mov	si,[ds:bx+2]		;
	mov	[bp+VTFOE+VMTF_CS],si	; move the CS
;
;   32-bit IRET back to client
;
EmExit:
	HwTabLock			; enable the high ram hw protection
EmSkipLockExit: 			; as the label implies...
	POP_ESI 			; restore local regs
	POP_EBX
	POP_EBP
	add	sp,4			; throw away error code
	OP32_IRET			; *** RETURN *** to client
; ENDP EmINTnn

; page
;******************************************************************************
;   EmINT3 - emulate the 'breakpoint' interrupt instruction
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode = CD nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;	    appropriate real mode IRET set up @ client's SS:SP
;   USED:   (none)
;   STACK:
;
;   to do:  implement the handler
;------------------------------------------------------------------------------
EmINT3:
	mov	[ES:RefNum], 03h	    ; Vector to VM int 3 handler
RefIntN:
	inc	si			    ; fault, not a trap
	mov	[bp+VTFOE+VMTF_EIP], si     ; point beyond int3
	jmp	RefToRom		    ; and let the VM OS handle it
; ENDP EmINT3

;******************************************************************************
;   EmINTO - emulate overflow interrupt
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode = CD nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;	    appropriate real mode IRET set up @ client's SS:SP
;   USED:   (none)
;   STACK:
;------------------------------------------------------------------------------
EmINTO:
	mov	[ES:RefNum], 04h	    ; Vector to VM int 3 handler
	jmp	short RefIntN
; ENDP EmINTO

; page
;******************************************************************************
;   EmINB - emulate the IN byte instruction
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode =	nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
EmINB:
	inc	si
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	push	bx
	xor	bx,bx			; IN instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EINB_Exit		;   Y: exit
	in	al,dx			;   N:do the INput
EINB_Exit:
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmINB

; page
;******************************************************************************
;   EmINW - emulate IN word
;
;	This routine emulates the IN word instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;------------------------------------------------------------------------------
EmINW:
	inc	si
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	push	bx
	xor	bx,bx			; IN instruction
	call	IO_Trap 		; Q: Emulated ?
	cbw				; AX= returned value
	jnc	EINW_Exit		;   Y: exit
	in	ax,dx			;   N:do the word INput
EINW_Exit:				;
	pop	bx			;
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmINW

; page
;******************************************************************************
;   EmINBimm - emulate IN word immediate
;
;	This routine emulates the IN word immediate instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;------------------------------------------------------------------------------
EmINBimm:
	push	bx
	push	dx
	mov	dl,[ds:si+1]		; get port number
	xor	dh,dh			; DX has INT number
	add	si, 2
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	xor	bx,bx			; IN instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EINBi_Exit		;   Y: exit
	in	al,dx			;   N:do the INput
EINBi_exit:
	pop	dx
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmINBimm

; page
;******************************************************************************
;***	EmINWimm - emulate IN word immediate
;
;	This routine emulates the IN word immediate instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;------------------------------------------------------------------------------
EmINWimm:
	push	bx
	push	dx
	mov	dl,[ds:si+1]		; get port number
	xor	dh,dh			; DX has INT number
	add	si, 2
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	xor	bx,bx			; IN instruction
	call	IO_Trap 		; Q: Emulated ?
	cbw				; AX = returned value
	jnc	EINWi_Exit		;   Y: exit
	in	ax,dx			;   N:do the word INput
EINWi_Exit:
	pop	dx
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmINWimm

; page
;******************************************************************************
;***	EmOUTB - emulate OUT byte
;
;	This routine emulates the OUT byte instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmOUTB:
	inc	si
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	push	bx
	push	dx
	mov	bx,1			; OUT instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EOUTB_Exit		;  Y:exit
EOUTB_em:
	out	dx,al			;      N:do the byte OUTput
EOUTB_Exit:
	pop	dx
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmOUTB

; page
;******************************************************************************
;***	EmOUTW - emulate OUT word
;
;	This routine emulates the OUT word instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmOUTW:
	inc	si
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	push	bx
	mov	bx,1			; OUT instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EOUTW_Exit		;   Y: exit
					;   N:
	out	dx,ax			; do the word OUTput
EOUTW_Exit:
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmOUTW

; page
;******************************************************************************
;***	EmOUTBimm - emulate OUT byte immediate
;
;	This routine emulates the OUT byte immediate
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmOUTBimm:
	push	bx
	push	dx
	mov	dl,[ds:si+1]		; get port number
	xor	dh,dh			; DX has INT number
	add	si, 2
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	mov	bx,1			; OUT instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EOUTBi_Exit		;   Y:exit
EOUTBi_em:
	out	dx,al			;      N:do the byte OUTput
EOUTBi_Exit:
	pop	dx
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmOUTBimm

; page
;******************************************************************************
;***	EmOUTWimm - emulate OUT word immediate
;
;	This routine emulates the OUT word immediate instruction
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmOUTWimm:
	push	bx
	push	dx
	mov	dl,[ds:si+1]		; get port number
	xor	dh,dh			; DX has INT number
	add	si, 2
	mov	[bp+VTFOE+VMTF_EIP],si	; set IP past the instruction we emulate
	mov	bx,1			; OUT instruction
	call	IO_Trap 		; Q: Emulated ?
	jnc	EOUTWi_Exit		;   Y: exit
	out	dx,ax			;   N:do the word OUTput
EOUTWi_Exit:
	pop	dx
	pop	bx
	jmp	EmExit			; *** RETURN *** to VM client
; ENDP EmOUTWimm
; page
;******************************************************************************
;***	EmHALT - Emulate HALT command
;
;	This routine is entered if a faulting instruction
;	is a HALT command
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	return to VM client unless client IF=0 then
;		    HLT is executed with IF=0
;
EmHALT:
						; Q: client's IF bit is 0?
	test	word [bp+VTFOE+VMTF_EFLAGS], IF_FLAG
	jz     EmDoHlt			       ;   Y: execute HLT if IF=0
	inc	si				; inc VM CS:IP past command
	mov	[bp+VTFOE+VMTF_EIP], si 	;  we emulate
; A halt on an INTEL architecture machine is just waiting for an interrupt
;	We'll pretend an interrupt occurs after a short wait
	push	cx
	mov	cx,4000h
	loop	$				; Wait awhile
	pop	cx
	jmp	EmExit				; then leave
emDoHlt:
	cli
	hlt					; Halt till NMI
	jmp	EmExit

; ENDP EmHALT

; page
;******************************************************************************
;***	EmLoadal2 - Emulate 286 Loadall command
;
;	This routine is entered if a faulting instruction
;	is a Loadall 286 command
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	return to VM client
;
EmLoadal2:

	test	[ES:PrefixFlag],P0F_FLAG    ; Q:Do we have the right prefix?
	jz	Not_Loadall
	jmp	EM286ll 		    ;  Y: emulate 286 loadall

Not_Loadall:
	jmp	BadVmTrap		    ;  N: Vector to VM illegal opcode

; ENDP EmLoadal2

;******************************************************************************
;***	EmLoadal3 - Emulate 386 Loadall command
;
;	This routine is entered if a faulting instruction
;	is a Loadall 386 command
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	return to VM client
;
EmLoadal3:

	test	[ES:PrefixFlag],P0F_FLAG
	jz	Not_Loadall
	jmp	EM386ll 		;  Y: emulate 386 loadall

; ENDP EmLoadal3

;******************************************************************************
;   EmCLTS - emulate the CLTS instruction
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode =	nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
EmCLTS:

	test	[ES:PrefixFlag],P0F_FLAG
	jz	Not_CLTS
	clts					; go ahead and CLTS
	inc	si				; inc VM CS:IP past command
	mov	[bp+VTFOE+VMTF_EIP], si 	;  we emulate
	jmp	EmExit				; and leave

Not_CLTS:
	jmp	BadVmTrap

; ENDP EmCLTS

;******************************************************************************
;   EmProtIns - emulate the protection control instructions
;   Currently this throws LIDT and LGDT to the error handler and only emulates
;   LMSW
;   NOTE:  The Stack configuration is critical!!!  If it is changed, the
;   offsets to the register images must be updated accordingly.
;
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode =	nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;	    bp.VTFOE+VMTF_EIP points beyond offender to next client instruction
;	    VM2_GSEL, DS, and SI may be modified at exit, this should not be a
;	    problem for the IRET
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
EmProtIns:

	test	[ES:PrefixFlag],P0F_FLAG
	jnz	EmPI1
	jmp	Not_ProtIns1
EmPI1:
	push	dx
	push	ax
	push	es
	mov	dx, [ES:PrefixFlag]
	mov	bx,VDMCA_GSEL		; Load CODE (writeable) alias
	mov	es, bx
	; assume	es:_TEXT
	inc	si			; set si past the opcode
	mov	bl,[si] 		; BL = modR/M
	mov	bh, bl			; BH = modR/M
	and	bl, 38h
	cmp	bl, 30h
	je	EmLMSW			; Emulate LMSW
	cmp	bl, 18h
	jne	LGDTerr 		; VM guy not allowed to LGDT
	mov	bx, ErrLIDT
	jmp	ExitPIer		; VM guy not allowed to LIDT
LGDTerr:
	mov	bx, ErrLGDT
	jmp	ExitPIer
EmLMSW:
	inc	si			; set SI past the modR/M
	mov	[bp+VTFOE+VMTF_EIP],si	; VM CS:IP = DS:SI
	mov	bl, bh			; BL = modR/M
	cmp	bl, 0C0h		; is MSW being loaded from a register?
	jb	MoveData		; N: do a move from the VM's memory
	jmp	MoveReg 		; Y: go do a register move

MoveData:
;   Because of all the possible addressing modes this is pretty nasty.	Like
;   MoveReg, it is complicated by the requirement to not clear the PE bit.
;   The general approach is to find the client's data value, put it in AX,
;   set the PE bit in AX, then load the MSW from AX.  To keep from having
;   to know about all the modR/M combinations, we yank the client's possible
;   offset from his code, and put his slightly modified modR/M byte in our
;   home-made MOV AX, MemData instruction.

;   If there is a data offset, yank it from the VM instruction and put it
;   in our instruction.

	and	bl, 0C7h		; Force AX to be the MOV destination
	mov	byte [es:LMSWmod],bl
	mov	ax, 09090h
	mov	word [es:LMSWoff],ax ; initialize offset to NOPS
	cmp	bl, 06h 		; special case for DS:d16
	je	load16off
	and	bl, 0C0h
	cmp	bl, 040h
	je	load8off
	cmp	bl, 080h
	jne	BldDesc 		; No data offset, so go build desc
Load16off:
	mov	ax,[si] 		; AX = 16 bit offset
	mov	word [es:LMSWoff],ax
	add	si, 2
	mov	[bp+VTFOE+VMTF_EIP],si	; VM CS:IP = DS:SI
	jmp	short BldDesc
Load8off:
	mov	al,[si] 		; AL = 8 bit offset
	mov	byte [es:LMSWoff],al
	inc	si
	mov	[bp+VTFOE+VMTF_EIP],si	; VM CS:IP = DS:SI

BldDesc:
;   Build a descriptor to the client's data segment

	mov	bl, bh
	mov	ax, [bp+VTFOE+VMTF_DS]	; Assume DS is the data segment

;   Check for segment override
	and	dx, 00FCh		; strip all but segment overrides
	cmp	dx, CS_FLAG
	jl	GetmodBase		; no override, check base
	je	CS_data
	cmp	dx, ES_FLAG
	je	ES_data
	jl	GetSel			; ds is override
	cmp	dx, FS_FLAG
	jl	SS_data
	je	FS_data
GS_data:
	mov	ax, [bp+VTFOE+VMTF_GS]	; GS is the data segment
	jmp	short GetSel
FS_data:
	mov	ax, [bp+VTFOE+VMTF_FS]	; FS is the data segment
	jmp	short GetSel
SS_data:
	mov	ax, VM1_GSEL
	mov	ds, ax
	jmp	short RestoreRegs
CS_data:
	mov	ax, VM2_GSEL
	mov	ds, ax
	jmp	short RestoreRegs
ES_data:
	mov	ax, [bp+VTFOE+VMTF_ES]	; ES is the data segment
	jmp	short GetSel

GetmodBase:
;   We have no Segment override, so we need to look at the modR/M byte to
;   see whether or not the data index/offset is based on DS (assumed) or SS
	and	bl, 0C7h		; clear instruction bits
	cmp	bl, 46h
	je	SS_Data 		; EA = SS:[BP+d8]
	and	bl, 7
	cmp	bl, 2
	je	SS_Data 		; EA = SS:[BP+SI+?]
	cmp	bl, 3
	je	SS_Data 		; EA = SS:[BP+DI+?]

GetSel:
;   Build a selector (VM2_GSEL) to client's data.  VM2_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;   The Descriptor base VM segment value is in AX
	push	es
	push	bx
	mov	bx,GDTD_GSEL		; get GDT data alias
	mov	es,bx			; DS -> GDT
	mov	bx, ax			; copy the VM data segment value
	shl	ax,4			; BX = low 16 bits of base
	mov	[es:VM2_GSEL+2],ax	; place in descriptor
	shr	bx,4			; BH = high 8 bits of base
	mov	[es:VM2_GSEL+4],bh	; place in descriptor
	mov	ax, VM2_GSEL
	mov	ds, ax
	pop	bx
	pop	es

RestoreRegs:
;   Since BX, SI, DI, and BP can all be used to form an effective address we
;   blindly restore BX, SI, and BP from the stack so that we don't
;   have to know what the instruction is using for its effective address.
;   DI does not need to be restored, because it should still be the client's

	push	bp
	mov	bp, sp

;   Now the Stack had better look like PROT_INS_FRAME. (vm386.inc)
	mov	si, [bp+PIF_ESI]
	mov	bx, [bp+PIF_EBX]
	mov	bp, [bp+PIF_EBP]

;   Move the VM data operand to AX
	db	3Eh			; ds overide (for bp & di)
	db	8Bh			; MOV opcode
LMSWmod db	00h			; modR/M
LMSWoff db	90h, 90h		; possible offset (NOPS otherwise)

	jmp	ExLMSW			; Finally... go do the LMSW

MoveReg:
;   Here we have a LMSW from one of the general registers.  This is pretty
;   ugly because many of the possible registers the client might have used
;   are currently saved on the stack.  It is also complicated by the
;   requirement to not clear the PE bit.  The general approach is to find
;   the client's register value/image, put it in AX, set the PE bit in AX,
;   then load the MSW from AX.	To keep from having to know all the modR/M
;   combinations, we again use a slightly modified client's modR/M byte in
;   our home-made MOV AX, RegData instruction.

	push	bp
	mov	bp, sp

;   Now the Stack had better look like PROT_INS_FRAME. (vm386.inc)

	and	bh, 07h 		; If Src is AX, it hasn't been changed
	jz	ExLMSW			; so just go do the the LMSW
CkSrcBX:				; otherwise, find it and move it to AX
	cmp	bh, 3
	jne	CkSrcBP
	mov	ax, [bp+PIF_EBX]	; src was BX, get from stack
	jmp	short ExLMSW
CkSrcBP:
	cmp	bh, 5
	jne	CkSrcSI
	mov	ax, [bp+PIF_EBP]	; src was BP, get from stack
	jmp	short ExLMSW
CkSrcSI:
	cmp	bh, 6
	jne	CkSrcDX
	mov	ax, [bp+PIF_ESI]	; src was SI, get from stack
	jmp	short ExLMSW
CkSrcDX:
	cmp	bh, 2
	jne	CkSrcSP
	mov	ax, [bp+PIF_DX] 	; src was DX, get from stack
	jmp	short ExLMSW
CkSrcSP:
	cmp	bh, 4
	jne	GetReg
	mov	ax, [bp+PIF_VMESP]	; src was SP, get from stack
	jmp	short ExLMSW
GetReg:
	or	bh, 0C0h		; set register to register move bits
	mov	[es:Lmod], bh		; setup move from client's src register
	jmp	short GetRn		; clear prefetch so that bh gets there
GetRn:
;   Execute MOV AX, Rn
	db	08Bh
Lmod	db	0C0h

;   Finally Execute the LMSW
ExLMSW:

;   At this point we could check for the PE bit and notify the user that
;   he must switch to real mode... but because an old app might do a SMSW,
;   which copies the PE bit (?!!), then set a bit in that image and do a LMSW,
;   (not caring about the PE bit), we just let it go... under the assumption
;   that if he really were trying to enter Protected mode, he would have
;   failed trying to LIDT and LGDT.

;	test	ax, 0001h		; Is client trying to set PE bit
;	jnz	ExitPIer		;  Y: jump to error
	or	ax, 0001h		;  N: we want to stay in Prot mode
	LMSW	ax			; So we must set it (use BTS above)

	pop	bp
	pop	es
	; assume	es:DGROUP
	pop	ax
	pop	dx
	jmp	EmExit			; *** RETURN *** to VM client

ExitPIer:
	pop	es
	; assume	es:DGROUP
	mov	ax, PrivErr		; privileged error
	call	ErrHndlr		; If the user want's to continue
	pop	ax
	pop	dx
	jmp	JumpReal		; we return and go unwind the stack
Not_ProtIns1:
	jmp	BadVmTrap

; ENDP EmProtIns

;******************************************************************************
;   EmMovCDTR - emulate the - MOV Rn, C/D/TRn & MOV C/D/TRn, Rn - instructions
;     This is done by copying the MOV instruction from the VM to our
;     code and then executing it.  If CR0 is being stored, the PE
;     bit is masked clear before completing the instruction.  Execution speed
;     should not be critical for these instructions, so I have lumped them
;     all together to save memory that can be better used for more time
;     critical emulations.
;     NOTE:  The Stack configuration is critical!!!  If it is changed, the
;     offsets to the register images must be updated accordingly.
;
;     Also NOTE: The TR register opcodes have been removed from the legal 0F
;     prefix list, (P0F_OpTab(x)), and the EmMovCDTR address removed from their
;     opcode table ,(OpTable), vectors, so that they don't come here anymore.
;
;   ENTRY:  386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting opcode =	nn  (DS = VM2_GSEL)
;   EXIT:   via IRET to VM client
;	    bp.VTFOE+VMTF_EIP points beyond offender to next client instruction
;   USED:
;   STACK:  n/a
;------------------------------------------------------------------------------
EmMovCDTR:

	test	[ES:PrefixFlag],P0F_FLAG
	jnz	MovCDTR1
	jmp	Not_MovCDTR		; Didn't come from a 0F prefix
MovCDTR1:
	PUSH_EAX
	push	es
	mov	bx,VDMCA_GSEL		; Load CODE (writeable) alias
	mov	es, bx
	; assume	es:_TEXT
	mov	bl,[si] 		; BL = opcode
	mov	[es:CDTRopc], bl
	inc	si			; set SI past the opcode
	mov	bl,[si] 		; BL = modR/M
	mov	bh, bl			; Copy modR/M
	and	bl, 0F8h		; For control, we reroute move thru AX
	mov	[es:CDTRmod], bl
	inc	si			; set SI past the modR/M
	mov	[bp+VTFOE+VMTF_EIP],si	; VM CS:IP = DS:SI

	push	bp
	mov	bp, sp

;   Now the Stack had better look like MOV_CDTR_FRAME. (vm386.inc)

	mov	bl, [es:CDTRopc]	; load opcode
	cmp	bl, 024h		; Check TRn load/store
	jb	NotTRErr		; N: continue
	mov	bx, ErrMovTR		; Y: go flag error
	jmp	CTRErr

NotTRErr:
	and	bh, 7			; strip all but src reg bits
	cmp	bh, 0
	je	ExCDTR			; reg is AX, so just do move

	cmp	bl, 020h		; Check CRn store
	je	ExCDTR1 		; Y: go do it
	cmp	bl, 021h		; Check DRn store
	je	ExCDTR1 		; Y: go do it

ChkSrcBX:
	cmp	bh, 3
	jne	ChkSrcBP
	OP32
	mov	ax, [bp+MCF_EBX]	; mov EBX from stack
	jmp	short ExCDTR
ChkSrcBP:
	cmp	bh, 5
	jne	ChkSrcSI
	OP32
	mov	ax, [bp+MCF_EBP]	; mov EBP from stack
	jmp	short ExCDTR
ChkSrcSI:
	cmp	bh, 6
	jne	ChkSrcSP
	OP32
	mov	ax, [bp+MCF_ESI]	; mov ESI from stack
	jmp	short ExCDTR
ChkSrcSP:
	cmp	bh, 4
	jne	GetFmReg
	OP32
	mov	ax, [bp+MCF_VMESP]	; mov ESP from stack
	jmp	short ExCDTR
GetFmReg:
	or	bh, 0C0h		; set register to register move bits
	mov	[es:CDTRreg], bh	; setup move from client's src register
	jmp	short GetERn		; clear prefetch so that bh gets there
GetERn:
;   Execute MOV EAX, ERn
	OP32
	db	08Bh
CDTRreg db	0C0h

ExCDTR:
	cmp	bl, 022h		; Check CRn load
	jne	FltrDRL3		; N: destination not CRn
	cmp	byte [es:CDTRmod], 0C0h ; Check for CR0 load
	je	CR0FltrL		; Y: filter it
	mov	bx, ErrMovCR
	jmp	CTRErr			; N: go tell user he did a NoNo
FltrDRL3:
	cmp	byte [es:CDTRmod], 0C3h ; Check for DR0-3 load
	ja	FltrGDbit		; N: continue
	call	MapLinear		; Y: convert address to our paging
	jmp	short ExCDTR1		;  linear map, then continue
FltrGDbit:
	cmp	byte [es:CDTRmod], 0C7h ; Check for DR7 load
	jne	ExCDTR1 		; N: continue
	and	ax, 0DFFFh		; Y: don't let client set the GD bit
	jmp	short ExCDTR1		; continue

;   For the reason below, we don't bug the user about setting the PE bit
;   through LMSW.  To be consistent, and because the client would die
;   in his attmept to LGDT or Mov CR3,Reg before this, we let him go here
;   also.
;   LMSW Reason:
;   At this point we could check for the PE bit and notify the user that
;   he must switch to real mode... but because an old app might do a SMSW,
;   which copies the PE bit (?!!), then set a bit in that image and do a LMSW,
;   (not caring about the PE bit), we just let it go... under the assumption
;   that if he really were trying to enter Protected mode, he would have
;   failed trying to LIDT and LGDT.

CR0FltrL:
;	OP32
;	test	AX, 0FFFEh		; Is Client trying to set the
;	dw	7FFFh			; PE bit or the PG bit?
;	jnz	ExitxCRer		; Y: go tell him he can't
	OP32
	or	AX, 0001h		; set PE bit
	dw	8000h			; and PG bit if they weren't
ExCDTR1:
;   Execute MOV CDTRn, EAX  (Finally!)
	db	0Fh
CDTRopc db	020h
CDTRmod db	0C0h

;   The special register move has now been executed, but we altered it to
;   use AX.  If the move was a load, we are done. If it was a store to one of
;   the registers on the stack, we need to stuff the register's stack image,
;   otherwise we need to move AX to the proper register.

	cmp	bl, 022h		; Check CRn load
	je	Exit_MovCDTR		; Y: we're done
	cmp	bl, 023h		; Check DRn load
	je	Exit_MovCDTR		; Y: we're done
	cmp	bl, 021h		; Check DRn store
	je	FltrDRS3		; Y: go filter it
	jmp	short NotDRS3
FltrDRS3:
	cmp	byte [es:CDTRmod], 0C3h ; Check for DR0-3 load
	ja	NotDRS3 		; N: continue
	call	UnMapLinear		; Y: convert address from our paging
					;  linear map, then continue
NotDRS3:
	cmp	bl, 020h		; Check CRn store
	jne	ChkDstBX		; N: source not CRn
	cmp	byte [es:CDTRmod], 0C0h ; Check for CR0 store
	je	CR0FltrS		; Y: filter it
	mov	bx, ErrMovCR
	jmp	short CTRErr		; N: go tell user he did a NoNo

;   Because SMSW shows the PE bit, we let it go through here also
CR0FltrS:
	OP32
	and	AX, 0FFFFh		; Y: clear
	dw	7FFFh			; PG bit if it was set
ChkDstBX:
	cmp	bh, 3
	jne	ChkDstBP
	OP32
	mov	[bp+MCF_EBX], ax	; mov EBX to stack
	jmp	short Exit_MovCDTR
ChkDstBP:
	cmp	bh, 5
	jne	ChkDstSI
	OP32
	mov	[bp+MCF_EBP], ax	; mov EBP to stack
	jmp	short Exit_MovCDTR
ChkDstSI:
	cmp	bh, 6
	jne	ChkDstAX
	OP32
	mov	[bp+MCF_ESI], ax	; mov ESI to stack
	jmp	short Exit_MovCDTR
ChkDstAX:
	cmp	bh, 0
	jne	ChkDstSP
	OP32
	mov	[bp+MCF_EAX], ax	; mov EAX to stack
	jmp	short Exit_MovCDTR	;   at exit
ChkDstSP:
	cmp	bh, 4
	jne	PutInReg
	OP32
	mov	[bp+MCF_VMESP], ax	  ; mov ESP to stack
	jmp	short Exit_MovCDTR	;   at exit
PutInReg:
;   Execute MOV ERn, EAX
	or	bh, 0C0h		; set register to register move bits
	mov	[es:regCDTR], bh	; setup load to client's dest register
	jmp	short PutERn		; clear prefetch so that bh gets there
PutERn:
	db	66h
	db	089h
regCDTR db	0C0h


Exit_MovCDTR:
	pop	bp
	pop	es
	; assume	es:DGROUP
	POP_EAX
	jmp	EmExit			; *** RETURN *** to VM client
CTRErr:
	mov	ax, PrivErr
	pop	bp
	sub	[bp+VTFOE+VMTF_EIP],3	; VM CS:IP = faulting instruction
	pop	es
	; assume	es:DGROUP
	call	ErrHndlr		; If we return here, the user wants to
	POP_EAX 			; continue in real mode... so go unwind
	jmp	JumpReal		; the stack and let him continue
Not_MovCDTR:
	jmp	BadVmTrap

; ENDP EmMovCDTR

;******************************************************************************
;***	EmLOCK - Emulate LOCK prefix
;
;	This routine is entered if a faulting instruction
;	is a LOCK prefix.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;
EmLOCK:

;   6/15 - Probably should jump to VmInsHandle rather than EmExit to handle a
;   a lock prefix on some other offending instruction.	In that case you would
;   have:
;;	or	ES:[PrefixFlag],LOCK_FLAG	; set appropriate flag
;;	inc	si				; inc VM CS:IP past prefix
;;	jmp	VmInsHandle			; and go process offender
;   rather than:
	inc	si				; set IP past the
	mov	[bp+VTFOE+VMTF_EIP], si 	; instruction we emulate
	jmp	EmExit				; and leave

; ENDP EmLOCK

;******************************************************************************
;***	EmREPNE - handle REPNE prefix
;
;	We come here if the trapping instruction has
;	a REPNE prefix. We just pass it on to the handler
;	for the next opcode.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmREPNE:

	or	[ES:PrefixFlag],REPNE_FLAG	; set appropriate flag
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP EmREPNE

;***	EmREP - handle REP prefix
;
;	We come here if the trapping instruction has
;	a REP or REPE prefix. We just pass it on to the handler
;	for the next opcode.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
EmREP:

	or	[ES:PrefixFlag],REP_FLAG	; set appropriate flag
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP EmREP

;******************************************************************************
;***	Prefix_0F - handle 0F overrides
;
;	This routine is entered if an instruction begins with a 0F prefix.
;	  It checks the current opcode against a table of valid 0F-opcodes,
;	  and if the opcode is valid, it indexes back into OpTable to jump
;	  to the proper opcode handler.
;	  (NOTE: This scheme works fine as long as the valid 0F-opcodes
;	    continue to have low values allowing this P0F_OpTabx to stay
;	    relatively small.  If this changes, we probably should go back
;	    to using the P0F_OpTab scheme.)
;
;	ENTRY:	386 Protected Mode
;	    EBP,EBX,ESI pushed on stack
;	    VM1_GSEL = VM client's stack segment
;	    VM2_GSEL = VM client's code segment
;	    DS:SI -> faulting prefix =	nn  (DS = VM2_GSEL)
;	EXIT	xfer directly to handler for next opcode
;
;***
P0F_Invalid equ     0FFh    ; OpTable vector offset to BadVmTrap

P0F_OpTabx:
	db  00h 	    ; 00h - LLDT, LTR, SLDT, STR, VERR, VERW
	db  02h 	    ; 01h - LIDT, LGDT, LMSW
	db  04h 	    ; 02h - LAR
	db  06h 	    ; 03h - LSL
	db  P0F_Invalid     ; 04h - BadVmTrap
	db  0Ah 	    ; 05h - 286 Loadall
	db  0Ch 	    ; 06h - CLTS
	db  0Eh 	    ; 07h - 386 Loadall
	db  P0F_Invalid     ; 08h - BadVmTrap
	db  P0F_Invalid     ; 09h - BadVmTrap
	db  P0F_Invalid     ; 0Ah - BadVmTrap
	db  P0F_Invalid     ; 0Bh - BadVmTrap
	db  P0F_Invalid     ; 0Ch - BadVmTrap
	db  P0F_Invalid     ; 0Dh - BadVmTrap
	db  P0F_Invalid     ; 0Eh - BadVmTrap
	db  P0F_Invalid     ; 0Fh - BadVmTrap
	db  P0F_Invalid     ; 10h - BadVmTrap
	db  P0F_Invalid     ; 11h - BadVmTrap
	db  P0F_Invalid     ; 12h - BadVmTrap
	db  P0F_Invalid     ; 13h - BadVmTrap
	db  P0F_Invalid     ; 14h - BadVmTrap
	db  P0F_Invalid     ; 15h - BadVmTrap
	db  P0F_Invalid     ; 16h - BadVmTrap
	db  P0F_Invalid     ; 17h - BadVmTrap
	db  P0F_Invalid     ; 18h - BadVmTrap
	db  P0F_Invalid     ; 19h - BadVmTrap
	db  P0F_Invalid     ; 1Ah - BadVmTrap
	db  P0F_Invalid     ; 1Bh - BadVmTrap
	db  P0F_Invalid     ; 1Ch - BadVmTrap
	db  P0F_Invalid     ; 1Dh - BadVmTrap
	db  P0F_Invalid     ; 1Eh - BadVmTrap
	db  P0F_Invalid     ; 1Fh - BadVmTrap
	db  40h 	    ; 20h - CR moves
	db  42h 	    ; 21h - DR moves
	db  44h 	    ; 22h - CR moves
	db  46h 	    ; 23h - DR moves
	db  48h 	    ; 24h - TR moves
	db  P0F_Invalid     ; 25h - BadVmTrap
	db  4Ch 	    ; 26h - TR moves
P0F_OpTabx_Size equ $-P0F_OpTabx

;***
Prefix_0F:
	inc	si			    ; inc DS:SI past prefix
	mov	bl,[si] 		    ; BL = opcode
	cmp	bl, P0F_OpTabx_Size
	jae	Bad_0F
	mov	bh,0			    ; BX = opcode
	mov	bl, cs:P0F_OpTabx[bx]
	cmp	bl, P0F_Invalid
	je	Bad_0F
	or	[es:PrefixFlag],P0F_FLAG    ; set appropriate flag
	jmp	cs:OpTable[bx]		    ; enter instr emulation routine

Bad_0F:
	jmp	BadVmTrap

; ENDP Prefix_0F

;******************************************************************************
;***	CSOverride - handle CS overrides
;
;	This routine is entered if a faulting instruction
;	has a CS override.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;
CSOverride:

	or	[ES:PrefixFlag],CS_FLAG 	; set appropriate flag
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP CSOverride

;******************************************************************************
;***	DSOverride - handle DS overrides
;
;	This routine is entered if a faulting instruction
;	has a DS override.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;
DSOverride:

	or	[ES:PrefixFlag],DS_FLAG 	; set appropriate flag
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP DSOverride

;******************************************************************************
;***	ESOverride - handle ES overrides
;
;	This routine is entered if a faulting instruction
;	has a ES override or a MOV TRn, Rn opcode
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;

ESOverride:

	test	[ES:PrefixFlag],P0F_FLAG	; only for TR emulation
	jz	ESO1				; only for TR emulation
	jmp	EmMovCDTR			; only for TR emulation
ESO1:
	or	[ES:PrefixFlag],ES_FLAG 	; set appropriate flag
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP ESOverride

;******************************************************************************
;***	SSOverride - handle SS overrides
;
;	This routine is entered if a faulting instruction
;	has a SS override.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;

SSOverride:

	or	[ES:PrefixFlag],SS_FLAG 	; set appropriate flag
;;	inc	[bp.VTFOE+VMTF_EIP]		; inc VM CS:IP past prefix
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP SSOverride

;******************************************************************************
;***	FSOverride - handle FS overrides
;
;	This routine is entered if a faulting instruction
;	has a FS override.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;

FSOverride:

	or	[ES:PrefixFlag],FS_FLAG 	; set appropriate flag
;;	inc	[bp.VTFOE+VMTF_EIP]		; inc VM CS:IP past prefix
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP FSOverride

;******************************************************************************
;***	GSOverride - handle GS overrides
;
;	This routine is entered if a faulting instruction
;	has a GS override.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	xfer on to handler for next opcode
;

GSOverride:

	or	[ES:PrefixFlag],GS_FLAG 	; set appropriate flag
;;	inc	[bp.VTFOE+VMTF_EIP]		; inc VM CS:IP past prefix
	inc	si				; inc VM CS:IP past prefix
	jmp	VmInsHandle			; handle next part of instr

; ENDP GSOverride

;******************************************************************************
;***	EmINSB - emulate IN byte string
;
;	This routine emulates the IN byte string instruction
;		*** this routine emulates REP instructions entirely	***
;		*** within protected mode.  This effectively masks out	***
;		*** interupts between bytes in the operation, even	***
;		*** if the VM code had interrupts on.			***
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
;	USES	ES,BX,DI
;

EmINSB:
;
;;	inc	[bp.VTFOE+VMTF_EIP]	; set IP past the instruction we emulate
	inc	si			; set IP past the
	mov	[bp+VTFOE+VMTF_EIP], si ; instruction we emulate
;
;
;   Build a selector (VM1_GSEL) to client's ES segment.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	mov	bx,GDTD_GSEL
	mov	ds,bx			; DS = GDT selector
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = VM ES (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = VM ES (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
	mov	bx,VM1_GSEL
	test	[ES:PrefixFlag],REP_FLAG	;Q: REP prefix active ?
	mov	es,bx				; ES = VM ES
	jnz	EINSB_loop			;  Y: go do rep instruction
	insb					;  N: do single instruction
	jmp	EINSB_exit			;     and leave
EINSB_loop:
	cld					; assume cld
	mov	bx,DF_FLAG
	test	bx,word [bp+VTFOE+VMTF_EFLAGS] ;Q: client's DF bit is CLD?
	jz	EINSB_rep			;  Y: go ahead
	std					;  N: set it
EINSB_rep:
	rep insb				;   rep version

EINSB_Exit:			;
	jmp	EmExit		; *** RETURN *** to VM client
;
; ENDP EmINSB


;******************************************************************************
;***	EmINSW - emulate IN word string
;
;	This routine emulates the IN word string instruction
;		*** this routine emulates REP instructions entirely	***
;		*** within protected mode.  This effectively masks out	***
;		*** interupts between bytes in the operation, even	***
;		*** if the VM code had interrupts on.			***
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
;	USES	ES,BX,DI
;

EmINSW:
;
;;	inc	[bp.VTFOE+VMTF_EIP]	; set IP past the instruction we emulate
	inc	si			; set IP past the
	mov	[bp+VTFOE+VMTF_EIP], si ; instruction we emulate
;
;
;
;   Build a selector (VM1_GSEL) to client's ES segment.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	mov	bx,GDTD_GSEL
	mov	ds,bx			; DS = GDT selector
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = VM ES (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_ES]	; BX = VM ES (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
	mov	bx,VM1_GSEL
	test	[ES:PrefixFlag],REP_FLAG	;Q: REP prefix active ?
	mov	es,bx				; ES = VM ES
	jnz	EINSW_loop			;  Y: go do rep instruction
	insw					;  N: do single instruction
	jmp	EINSW_exit			;     and leave
EINSW_loop:
	cld					; assume cld
	mov	bx,DF_FLAG
	test	bx,word [bp+VTFOE+VMTF_EFLAGS] ;Q: client's DF bit is CLD?
	jz	EINSW_rep			;  Y: go ahead
	std					;  N: set it
EINSW_rep:
	rep insw				;   rep version

EINSW_Exit:			;
	jmp	EmExit		; *** RETURN *** to VM client
;
; ENDP EmINSW


;******************************************************************************
;***	EmOUTSB - emulate OUT byte string
;
;	This routine emulates the OUT byte string instruction
;		*** this routine emulates REP instructions entirely	***
;		*** within protected mode.  This effectively masks out	***
;		*** interupts between bytes in the operation, even	***
;		*** if the VM code had interrupts on.			***
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
;	USES	DS,BX,SI
;

EmOUTSB:
;
;;	inc	[bp.VTFOE+VMTF_EIP]	; set IP past the instruction we emulate
	inc	si			; set IP past the
	mov	[bp+VTFOE+VMTF_EIP], si ; instruction we emulate
;
;   restore SI
;
	pop	si
	push	si
;
;   Build a selector (VM1_GSEL) to client's DS segment.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	mov	bx,GDTD_GSEL
	mov	ds,bx			; DS = GDT selector
	mov	bx,[bp+VTFOE+VMTF_DS]	; BX = VM DS (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_DS]	; BX = VM DS (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
	mov	bx,VM1_GSEL
	mov	ds,bx			; DS = VM DS

	test	[ES:PrefixFlag],REP_FLAG ;Q: REP prefix active ?
	jnz	EOUTSB_loop			;  Y: go do rep instruction
	outsb					;  N: do single instruction
	jmp	EOUTSB_exit			;     and leave
EOUTSB_loop:
	cld					; assume cld
	mov	bx,DF_FLAG
	test	bx,word [bp+VTFOE+VMTF_EFLAGS] ;Q: client's DF bit is CLD?
	jz	EOUTSB_rep			;  Y: go ahead
	std					;  N: set it
EOUTSB_rep:
	rep outsb				;   rep version

EOUTSB_Exit:			;
	jmp	EmExit		; *** RETURN *** to VM client
;
; ENDP EmOUTSB


;******************************************************************************
;***	EmOUTSW - emulate OUT word string
;
;	This routine emulates the OUT word string instruction
;		*** this routine emulates REP instructions entirely	***
;		*** within protected mode.  This effectively masks out	***
;		*** interupts between bytes in the operation, even	***
;		*** if the VM code had interrupts on.			***
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
;	USES	DS,BX,SI
;

EmOUTSW:
;
;;	inc	[bp.VTFOE+VMTF_EIP]	; set IP past the instruction we emulate
	inc	si			; set IP past the
	mov	[bp+VTFOE+VMTF_EIP], si ; instruction we emulate
;
;   restore SI
;
	pop	si
	push	si
;
;
;   Build a selector (VM1_GSEL) to client's DS segment.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	mov	bx,GDTD_GSEL
	mov	ds,bx			; DS = GDT selector
	mov	bx,[bp+VTFOE+VMTF_DS]	; BX = VM DS (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFOE+VMTF_DS]	; BX = VM DS (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
	mov	bx,VM1_GSEL
	mov	ds,bx			; DS = VM DS

	test	[ES:PrefixFlag],REP_FLAG ;Q: REP prefix active ?
	jnz	EOUTSW_loop			;  Y: go do rep instruction
	outsw					;  N: do single instruction
	jmp	EOUTSW_exit			;     and leave
EOUTSW_loop:
	cld					; assume cld
	mov	bx,DF_FLAG
	test	bx,word [bp+VTFOE+VMTF_EFLAGS] ;Q: client's DF bit is CLD?
	jz	EOUTSW_rep			;  Y: go ahead
	std					;  N: set it
EOUTSW_rep:
	rep outsw				;   rep version

EOUTSW_Exit:			;
	jmp	EmExit		; *** RETURN *** to VM client
;
; ENDP EmOUTSW

;******************************************************************************
;***	EmMOVSW - emulate MOV word string
;
;	This routine emulates the MOV word string instruction
;	specifically to handle the RASH Rules (Jokes) emulation.
;	For now, the only reason for doing this is to allow a bug
;	in PC Week's benchmark tests to FAIL "properly" so that the test
;	works.	(Unbelievable!)
;
;	NOTE:	After testing, if the ROM properly emulates the RASH
;	requirements, this routine should be reduced to the Reflect6
;	function.
;
;	ENTRY	386 PROTECTED MODE
;		see common description at top
;
;	EXIT	IRET back to VM program
;
;	USES	DS,BX,SI
;
EmMOVSW:
	mov	bx, sp
	cmp	di, 0FFFFh		    ; Q:Does either Di
	je	EmWRASH
	cmp	[ss:bx+GPF_ESI], 0FFFFh     ;	or SI = FFFF?
	je	EmWRASH 		    ;  Y:Assume RASH GPfault
Reflect6:
	mov	[es:RefNum], 06h
RefToROM:
	POP_ESI 			    ;  N: clean up the stack,
	POP_EBX
	POP_EBP
	add	sp,4			    ; throw away error code,
	PUSH_EBP
	mov	bp,sp			    ; reset BP to stack frame
	push	[es:RefNum]		    ; push the trap number
	jmp	hw_int			    ; and, Reflect to ROM
EmWRASH:
	test	[es:PrefixFlag], REPS_FLAG  ; Q:Is this a REP of REPNE?
	jz	EMWCXok 		    ;  N: don't change CX
	inc	cx
EMWCXok:
	mov	ax, 2			    ; assume up counter
	test	[bp+VTFOE+VMTF_EFLAGS], DF_FLAG
	jz	EMWUpdtSI
	not	ax
EMWUpdtSI:
	mov	si, [ss:bx+GPF_ESI]
	add	[ss:bx+GPF_ESI], ax	    ; verify neg???
	cmp	si, 0FFFFh		    ; Q:Did SI cause the GP fault
	jne	EMWUpdtDI		    ;  N:Go fixup DI and CX
	jmp	short EMW_Exit		    ;  Y:We're done
EMWUpdtDI:
	test	[es:PrefixFlag], REPS_FLAG  ; Q:Is this a REP of REPNE?
	jz	EMWCXok2		    ;  N: don't change CX
	inc	cx
EMWCXok2:
	add	di, ax			    ; verify neg???
EMW_Exit:
	jmp	EmExit		; *** RETURN *** to VM client
;
; ENDP EmMOVSW

; END SECTION ._TEXT

	; end

