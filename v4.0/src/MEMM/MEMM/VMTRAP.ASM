

; page	58,132
;******************************************************************************
	; title	VMTRAP - 386 Virtual Mode interrupt handler routines
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:	MEMM.EXE - MICROSOFT Expanded Memory Manager 386 Driver
;
;   Module:	VMTRAP - 386 Virtual Mode interrupt handler routines
;
;   Version:	0.02
;
;   Date:	January 26, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	 ------------------------------------------------------
;   01/26/86  Original
;   02/05/86  A-	Added int 15h trap to move block function.
;   05/12/86  A 	Cleanup and segment reorganization
;   06/19/86  0.01	Added emul_reflect entry point for preserving
;			IF and TF flags bits on reflections done by
;			instruction emulators.
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/20/88		Removed debugger codes (pc)
;
;******************************************************************************
;
;   Functional Description:
;
;   This module contains the interrupt and trap handlers for Virtual DOS.
;
;   Note that a conscious decision has been made to attempt to field the
;   Master 8259 interrupts at the normal PC location (vectors 8 - F).  The
;   main problem is that these overlap CPU exception vectors.  While the
;   8259 base vector address could be changed (there's lots of room in the
;   IDT, since we're fielding S/W INTs through GP 13), the primary reason
;   for not doing so is to avoid any potential trouble with an application
;   reprogramming the 8259.  We don't know of any that do, and you could
;   trap them if they tried anyway.
;
;   "to do:" marks potential holes/things to consider
;
;******************************************************************************
; .lfcond; list false conditionals
CPU 386
	; page
;******************************************************************************
;			P U B L I C   D E C L A R A T I O N S
;******************************************************************************
;
	global VmTrap; module label

	global hw_int
	global emul_reflect

	global vm_trap00
	global vm_trap01
	global vm_trap02
	global vm_trap03
	global vm_trap04
	global vm_trap05
	global vm_trap06
	global vm_trap07
	global vm_trap08
	global vm_trap09
	global vm_trap0a
	global vm_trap0b
	global vm_trap0c
	global vm_trap0d
	global vm_trap0e
	global vm_trap0f
	global vm_trap10
	global vm_trap50
	global vm_trap51
	global vm_trap52
	global vm_trap53
	global vm_trap54
	global vm_trap55
	global vm_trap56
	global vm_trap57
	global vm_trap70
	global vm_trap71
	global vm_trap72
	global vm_trap73
	global vm_trap74
	global vm_trap75
	global vm_trap76
	global vm_trap77

	; page
;******************************************************************************
;			E X T E R N A L   R E F E R E N C E S
;******************************************************************************
;
SECTION ._TEXT
	extern VmFault; V Mode GP fault handler (VMINST)
	extern ErrHndlr; Error Handler (ERRHNDLR)
	extern DisableNMI; Disable NMI for NMI trap handler
; END SECTION ._TEXT
	; page
;******************************************************************************
;			I N C L U D E	F I L E S
;******************************************************************************
;
%include "VDMseg.inc"
%include "VDMsel.inc"
%include "vm386.inc"
%include "pic_def.equ"
%include "instr386.inc"
%include "oemdep.inc"

	; page
;******************************************************************************
;			L O C A L   C O N S T A N T S
;******************************************************************************
;
FALSE	equ	0
TRUE	equ	not FALSE

%macro ProcessExcep 1
	mov	bx, ExcepNum
	mov	ax, ExcpErr
	jmp	ErrHndlr
%endmacro
;
;******************************************************************************
;			S E G M E N T	D E F I N I T I O N
;******************************************************************************
;
SECTION .ABS0
; END SECTION .ABS0
;
;------------------------------------------------------------------------------
SECTION ._TEXT
	; assume	cs:_TEXT, ds:NOTHING, es:NOTHING, ss:NOTHING
VmTrap:
;
	db	'WCC'
;
	; page
;******************************************************************************
;   CPU:  Divide error fault
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap00:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt0_dexit		;   N: exit to debugger
	push	0000			;   Y: interrupt 00
	jmp	hw_int			; reflect it to virtual mode
vmt0_dexit:
	ProcessExcep ErrDIV
; ENDP vm_trap00

;******************************************************************************
;   CPU:  Debug trap
;
;   Traps from Virtual mode are reflected to virtual mode.  Unfortunately
;   this breaks the debugger's ability to GO and TRACE the VM program.
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap01:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt1_dexit		;   N: exit to debugger
	push	0001			;   Y: interrupt 01
	jmp	hw_int			; reflect it to virtual mode
vmt1_dexit:
	ProcessExcep ErrINT1
; ENDP vm_trap01

;******************************************************************************
;   H/W:  NMI
;
;   For now, this always traps to the debugger.  It's a general purpose hook
;   to let the debugger get control via an NMI button.
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap02:
	PUSH_EBP
	mov	bp,sp

	call	DisableNMI

	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt2_parity		;     N: error/debug trap
					;     Y: reflect it/debugger
	push	02			; reflect it
	jmp	hw_int
vmt2_parity:
	ProcessExcep ErrNMI

; ENDP vm_trap02

;******************************************************************************
;   CPU:  Breakpoint trap (INT 3 instruction)
;
;   Traps from Virtual mode are reflected to virtual mode.  Unfortunately
;   this breaks the debugger's ability to GO and TRACE the VM program.
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap03:
	ProcessExcep ErrINT3
; ENDP vm_trap03

;******************************************************************************
;   CPU:  Overflow trap (INTO instruction)
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap04:
	ProcessExcep ErrINTO
; ENDP vm_trap04


;******************************************************************************
;   CPU:  Array bounds fault
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap05:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt5_dexit		;   N: exit to debugger
	push	0005			;   Y: interrupt 01
	jmp	hw_int			; reflect it to virtual mode
vmt5_dexit:
	ProcessExcep ErrBounds
; ENDP vm_trap05

;******************************************************************************
;   CPU:  Invalid Opcode fault
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;
;   add Invalid instruction emulator ???  (specifically LOCK prefix)
;
;------------------------------------------------------------------------------
vm_trap06:
	push	0			; align stack with error offset
	push	0			;  for VmFault
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFOE+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt6_dexit		;   N: exit to debugger
	jmp	VmFault 		;   Y: enter VM 06 Invalid handler

vmt6_dexit:
	ProcessExcep ErrOpCode
; ENDP vm_trap06

;******************************************************************************
;   CPU:  Coprocessor not present fault
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap07:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmt7_dexit		;   N: exit to debugger
	push	0007			;   Y: interrupt 07
	jmp	hw_int			; reflect it to virtual mode
vmt7_dexit:
	ProcessExcep ErrCoPNA
; ENDP vm_trap07


;******************************************************************************
;   CPU:  Double Fault
;   H/W:  IRQ0 - System timer
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = 0000
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap08:
	PUSH_EBP
	mov	bp,sp
	cmp	sp,VMT_STACK		; Q: H/W interrupt from VM ?
	jne	vmt8_dexit		;   N: exit to debugger
	push	0008			;   Y: interrupt 8
	jmp	hw_int			; reflect it to virtual mode
vmt8_dexit:
	ProcessExcep ErrDouble
; ENDP vm_trap08


;******************************************************************************
;   CPU:  (none for 386)
;   H/W:  IRQ1 - Keyboard
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap09:
	PUSH_EBP
	mov	bp,sp
	push	0009			;   Y: interrupt 9
	jmp	hw_int			; reflect it to virtual mode
; ENDP vm_trap09

;******************************************************************************
;   CPU:  Invalid TSS fault
;   H/W:  IRQ2 - Cascade from slave 8259 (see INT 70-77)
;		 (shouldn't get H/W interrupts here)
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = Selector
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:

;   to do: someone could reprogram master 8259 - need to handle ?
;------------------------------------------------------------------------------
vm_trap0A:
	ProcessExcep ErrTSS
; ENDP vm_trap0A


;******************************************************************************
;   CPU:  Segment Not Present fault
;   H/W:  IRQ3 - COM2
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = Selector
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap0B:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmtB_dexit		;   N: exit to debugger
	push	000Bh			;   Y: interrupt 0B
	jmp	hw_int			; reflect it to virtual mode
vmtB_dexit:
	ProcessExcep ErrSegNP
; ENDP vm_trap0B

;******************************************************************************
;   CPU:  Stack fault
;   H/W:  IRQ4 - COM1
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = Selector or 0000
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap0C:
	PUSH_EBP
	mov	bp,sp
	test	[bp+VTFO+VMTF_EFLAGShi],2 ; Q: client in Virtual Mode ?
	jz	vmtC_dexit		;   N: exit to debugger
	push	000Ch			;   Y: interrupt 0C
	jmp	hw_int			; reflect it to virtual mode
vmtC_dexit:
	ProcessExcep ErrStack
; ENDP vm_trap0C

;******************************************************************************
;   CPU:  General Protection fault
;   H/W:  IRQ5 - Second parallel printer
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = Selector or 0000
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap0D:
	PUSH_EBP
	mov	bp,sp
	cmp	sp,VMT_STACK		; Q: H/W interrupt from VM ?
	jne	vmtD_1			;   N: continue
	push	000Dh			;   Y: interrupt vector 0Dh
	jmp	hw_int			; reflect it to virtual mode
;
;   Here we have a GP fault that was not a H/W interrupt 13 from VM.
;
vmtD_1:
	cmp	sp,VMTERR_STACK 	; Q: 'normal' exception w/error code ?
	jne	vmtD_dexit		;   N: what the hell was it ???? - exit
	jmp	VmFault 		;   Y: enter VM GP fault handler
					; (fall thru to debugger)
vmtD_dexit:
	ProcessExcep ErrGP
; ENDP vm_trap0D

;******************************************************************************
;   CPU:  Page fault
;   H/W:  IRQ6 - diskette interrupt
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    Error Code on stack = type of fault
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap0E:
	PUSH_EBP
	mov	bp,sp
	cmp	sp,VMT_STACK		; Q: H/W interrupt from VM ?
	jne	vmtE_dexit		;   N: exit to debugger
	push	000Eh			;   Y: interrupt vector 0Eh
	jmp	hw_int			; reflect it to virtual mode
vmtE_dexit:
	ProcessExcep ErrPage
; ENDP vm_trap0E

;******************************************************************************
;   CPU:  (none)
;   H/W:  IRQ7 - parallel printer
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap0F:
	PUSH_EBP
	mov	bp,sp
	push	000Fh			; push interrupt number
	jmp	hw_int			; enter common H/W interrupt handler
; ENDP vm_trap0F

;******************************************************************************
;   CPU:  Coprocessor Error - GOES TO NOT PRESENT FAULT IN DEBUGGER FOR NOW
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;	    No error code on stack
;   EXIT:   to handler or debugger as appropriate
;   USED:
;   STACK:
;------------------------------------------------------------------------------
vm_trap10:
	ProcessExcep ErrCoPerr
; ENDP vm_trap10

;******************************************************************************
;   VmTrap5x - Handlers for hardware interrupts.  Sometimes the master 8259
;		is set to here.
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;   EXIT:   EBP pushed on stack
;	    BP = normal stack frame pointer
;	    Interrupt number pushed on stack
;   USED:
;   STACK:  (4 bytes)
;------------------------------------------------------------------------------
vm_trap50:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0050h
	jmp	short hw_int		; enter common code
; ENDP vm_trap50

;------------------------------------------------------------------------------
vm_trap51:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0051h
	jmp	short hw_int		; enter common code
; ENDP vm_trap51

;------------------------------------------------------------------------------
vm_trap52:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0052h
	jmp	short hw_int		; enter common code
; ENDP vm_trap52

;------------------------------------------------------------------------------
vm_trap53:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0053h
	jmp	short hw_int		; enter common code
; ENDP vm_trap53

;------------------------------------------------------------------------------
vm_trap54:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0054h
	jmp	short	hw_int		; enter common code
; ENDP vm_trap54

;------------------------------------------------------------------------------
vm_trap55:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0055h
	jmp	short hw_int		; enter common code
; ENDP vm_trap55

;------------------------------------------------------------------------------
vm_trap56:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0056h
	jmp	short hw_int		; enter common code
; ENDP vm_trap56

;------------------------------------------------------------------------------
vm_trap57:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0057h
	jmp	short hw_int		; enter common code
; ENDP vm_trap57

;******************************************************************************
;   VmTrap7x - handlers for hardware interrupts from the slave 8259
;
;   ENTRY:  386 Protected Mode via 386 Interrupt gate
;   EXIT:   EBP pushed on stack
;	    BP = normal stack frame pointer
;	    Interrupt number pushed on stack
;   USED:
;   STACK:  (4 bytes)
;------------------------------------------------------------------------------
vm_trap70:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0070h
	jmp	short hw_int		; enter common code
; ENDP vm_trap70

;------------------------------------------------------------------------------
vm_trap71:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0071h
	jmp	short hw_int		; enter common code
; ENDP vm_trap71

;------------------------------------------------------------------------------
vm_trap72:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0072h
	jmp	short hw_int		; enter common code
; ENDP vm_trap72

;------------------------------------------------------------------------------
vm_trap73:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0073h
	jmp	short hw_int		; enter common code
; ENDP vm_trap73

;------------------------------------------------------------------------------
vm_trap74:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0074h
	jmp	short	hw_int		; enter common code
; ENDP vm_trap74

;------------------------------------------------------------------------------
vm_trap75:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0075h
	jmp	short hw_int		; enter common code
; ENDP vm_trap75

;------------------------------------------------------------------------------
vm_trap76:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0076h
	jmp	short hw_int		; enter common code
; ENDP vm_trap76

;------------------------------------------------------------------------------
vm_trap77:
	PUSH_EBP
	mov	bp,sp			; set up BP frame pointer
	push	0077h
	jmp	short hw_int		; enter common code
; ENDP vm_trap77

	; page
;******************************************************************************
;   HW_INT - common handler for hardware interrupts.  The interrupt is
;	reflected directly to the appropriate Real Mode (Virtual) handler.
;	This entry point clear the trace flag (TF) and int flag (IF), since
;	a h/w interrupt would (NOTE: INT n and INTO instructions also clear
;	TF and IF - so this entry is suitable for reflecting these also).
;
;   EMUL_REFLECT - entry point for reflecting emulations.
;	This entry point does not clear the trace flag (TF) and int flag (IF).
;
;   386 interrupt gate switched us to the Ring 0 stack on the way in
;   from Virtual Mode and pushed 32-bit values as follows:
;
;	 hiword loword	offset (in addition to EBP push)
;	+------+------+ <-------- Top of 'kernel' stack
;	| 0000 |  GS  |  +32 (decimal)
;	|------|------|
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
;	+------+------+ <-------- Ring 0 SS:SP
;	|    (ebp)    |
;	+-------------+ <-------- Ring 0 SS:BP
;
;   The object of this routine is to massage the trap stack frame (above)
;   and build a 'real mode' stack frame for the virtual mode client so that
;   we can transfer control to virtual mode at the address specified in
;   the appropriate real mode IDT vector.  The client's IRET out of the
;   interrupt routine will proceed normally (assuming we're letting him
;   run with IOPL = 3).  Since we're fielding the trap from Virtual Mode,
;   we assume the high word of ESP and EIP is 0000.
;
;	+-------+ <-------- Client's current SS:SP
;	| Flags |  +4
;	|-------|
;	|  CS	|  +2
;	|-------|
;	|  IP	|  +0
;	+-------+ <-------- Client's SS:SP when we let him have control
;
;   Assume entry from Virtual Mode, for now.  We shouldn't be getting entered
;   here except via Hardware interrupt, so no sanity checks are performed.
;
;   ENTRY:  386 Protected Mode
;		BP -> standard frame
;		EBP and Interrupt number have been pushed onto stack
;   EXIT:  via IRET to VM86 program
;	   appropriate real mode IRET set up @ client's SS:SP
;   USED:  (none) (note that DS & ES are free to use - saved during trap)
;   STACK:
;
;   to do:  Need to check for entry mode ?
;------------------------------------------------------------------------------
hw_int:
	push	bx
	push	si			;
	mov	si,[bp+VTFO+VMTF_EFLAGS] ; SI = saved low word of EFLAGS
;
; *** clear IF bit and Trace Flag on flags for reflect, but leave them
;	unchanged for the flags on the IRET stack we build on the
;	client's stack.
;
	and	[bp+VTFO+VMTF_EFLAGS],not 300h	; clear IF and TF
reflect_common:
;
;   Build a selector (VM1_GSEL) to client's stack.  VM1_GSEL is already set
;   up with limit (0FFFFh) and access (D_DATA0), so just fill in the base.
;
	HwTabUnlock			; disable HW protection on high ram
	mov	bx,GDTD_GSEL		; get GDT data alias
	mov	ds,bx			; DS -> GDT
	mov	bx,[bp+VTFO+VMTF_SS]	; BX = VM SS (segment form)
	shl	bx,4			; BX = low 16 bits of base
	mov	[ds:VM1_GSEL+2],bx	; place in descriptor
	mov	bx,[bp+VTFO+VMTF_SS]	; BX = VM SS (again)
	shr	bx,4			; BH = high 8 bits of base
	mov	[ds:VM1_GSEL+4],bh	; place in descriptor
;
;   Adjust client's SP to make room for building his IRET frame
;
	sub	word [bp+VTFO+VMTF_ESP],6	; adjust client's SP
	mov	bx, VM1_GSEL
	mov	ds, bx			; DS = VM stack segment
;
	mov	bx,si			; BX = low word of client's EFLAGS
;
	mov	si,[bp+VTFO+VMTF_ESP]	; DS:SI = pointer to client's frame
;
;   Move low 16 bits of Flags, CS, and EIP from IRET frame to client stack frame
;
	mov	[ds:si+4],bx		; to client's flags
	mov	bx,[bp+VTFO+VMTF_CS]	;
	mov	[ds:si+2],bx		; to client's CS
	mov	bx,[bp+VTFO+VMTF_EIP]	; low word of EIP
	mov	[ds:si+0],bx		; to client's IP
;
;   Replace low 16 bits of IRET frame CS:EIP with vector from real mode IDT
;
	mov	bx,[bp-2]		; get the interrupt vector
	shl	bx,2			; BX = BX * 4 (vector table index)
	mov	si,RM_IDT_GSEL		; get real mode IDT alias
	mov	ds,si			; DS -> Real Mode IDT
	mov	si,[ds:bx]		;
	mov	[bp+VTFO+VMTF_EIP],si	; move the IP
	mov	si,[ds:bx+2]		;
	mov	[bp+VTFO+VMTF_CS],si	; move the CS
;
;   32-bit IRET back to client
;
	HwTabLock			; enable HW protection on high ram
	pop	si			; restore local regs
	pop	bx
	pop	bp			; throw away fake interrupt number
	POP_EBP
	db	66h
	iret				; *** RETURN *** to client
; ENDP hw_int

;******************************************************************************
;	EMUL_REFLECT
;******************************************************************************
;
;   emulation relfection entry point - don't mess with client's flags
;
emul_reflect:
	push	bx			; local registers
	push	si			;
	mov	si,[bp+VTFO+VMTF_EFLAGS] ; SI = saved low word of EFLAGS
	jmp	reflect_common


;
; END SECTION ._TEXT; end of segment
;
	; end; end of module
