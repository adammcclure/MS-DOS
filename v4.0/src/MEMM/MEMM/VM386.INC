

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   VM386.INC
;
;   Version:  0.03
;
;   Date:     May 12, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;	      Original
;   05/12/86  A 	Cleanup and segment reorganization
;   06/08/86  B 	Added Disable A20 equates
;   06/14/86  C 	Added MOV_CDTR_FRAME, PROT_INS_FRAME, and changed
;			VTFO from 2 to 4 to reflect push of EBP from BP
;   06/15/86  D 	Added GPFAULT_FRAME
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/01/86  0.03	Added structures for accessing memory
;
;******************************************************************************
%ifndef INC_LIST
; .xlist
%endif

;
;   Structures for accessing memory
;
struc WordS
	LowByte: db 0
	HighByte: db 0
endstruc

struc DwordS
	LowWord: dw 0
	HighWord: dw 0
endstruc

;
;   Structure for accessing stack frame pushed during trap exit from VM
;

struc VM_TRAP_FRAME
VMTF_EIP: dw 0; EIP (low)
		dw 0; EIP (high)
VMTF_CS: dw 0; CS
		dw 0;   (padding)
VMTF_EFLAGS: dw 0; EFLAGS (low)
VMTF_EFLAGShi: dw 0; EFLAGS (high)
VMTF_ESP: dw 0; ESP (low)
		dw 0; ESP (high)
VMTF_SS: dw 0; SS
		dw 0;   (padding)
VMTF_ES: dw 0; ES
		dw 0;   (padding)
VMTF_DS: dw 0; DS
		dw 0;   (padding)
VMTF_FS: dw 0; FS
		dw 0;   (padding)
VMTF_GS: dw 0; GS
		dw 0;   (padding)
endstruc
;
					; Used in EmMovCDTR (vminst.asm)
struc MOV_CDTR_FRAME
MCF_WBP: dw 0; Work BP
MCF_WES: dw 0; Work ES
MCF_EAX: dw 0; EAXlo
		dw 0; EAXhi
MCF_ESI: dw 0; ESIlo
		dw 0; ESIhi
MCF_EBX: dw 0; EBXlo
		dw 0; EBXhi
MCF_EBP: dw 0; EBPlo
		dw 0; EBPhi
MCF_VMERR: dw 0; VM Error Code (low)
		dw 0; VM Error Code (high)
MCF_VMEIP: dw 0; VM EIP (low)
		dw 0; VM EIP (high)
MCF_VMCS: dw 0; VM CS
		dw 0;   (padding)
MCF_VMEFLAGS: dw 0; VM EFLAGS (low)
MCF_VMEFLAGShi: dw 0; VM EFLAGS (high)
MCF_VMESP: dw 0; VM ESP (low)
		dw 0; VM ESP (high)
MCF_VMSS: dw 0; VM SS
		dw 0;   (padding)
MCF_VMES: dw 0; VM ES
		dw 0;   (padding)
MCF_VMDS: dw 0; VM DS
		dw 0;   (padding)
MCF_VMFS: dw 0; VM FS
		dw 0;   (padding)
MCF_VMGS: dw 0; VM GS
		dw 0;   (padding)
endstruc
;
					; Used in EmProtIns (vminst.asm)
struc PROT_INS_FRAME
PIF_WBP: dw 0; Work BP
PIF_WES: dw 0; Work ES
PIF_AX: dw 0; EAXlo
PIF_DX: dw 0; EDXlo
PIF_ESI: dw 0; ESIlo
		dw 0; ESIhi
PIF_EBX: dw 0; EBXlo
		dw 0; EBXhi
PIF_EBP: dw 0; EBPlo
		dw 0; EBPhi
PIF_VMERR: dw 0; VM Error Code (low)
		dw 0; VM Error Code (high)
PIF_VMEIP: dw 0; VM EIP (low)
		dw 0; VM EIP (high)
PIF_VMCS: dw 0; VM CS
		dw 0;   (padding)
PIF_VMEFLAGS: dw 0; VM EFLAGS (low)
PIF_VMEFLAGShi: dw 0; VM EFLAGS (high)
PIF_VMESP: dw 0; VM ESP (low)
		dw 0; VM ESP (high)
PIF_VMSS: dw 0; VM SS
		dw 0;   (padding)
PIF_VMES: dw 0; VM ES
		dw 0;   (padding)
PIF_VMDS: dw 0; VM DS
		dw 0;   (padding)
PIF_VMFS: dw 0; VM FS
		dw 0;   (padding)
PIF_VMGS: dw 0; VM GS
		dw 0;   (padding)
endstruc
;
struc GPFAULT_FRAME
GPF_ESI: dw 0; ESIlo
		dw 0; ESIhi
GPF_EBX: dw 0; EBXlo
		dw 0; EBXhi
GPF_EBP: dw 0; EBPlo
		dw 0; EBPhi
endstruc
;
;   The following constants define the offset of the Virtual Mode trap stack
;   frame (from current SP assuming BP has been pushed) for the two cases:
;   1) exceptions that don't push error codes and 2) those that do.
;
VTFO		equ	4		; offset of VM trap stack frame
VTFOE		equ	VTFO + 4	; as above, but including error code
;
;   These constants are used to sanity-check the value of SP when one of
;   the exception handlers has been entered:
;
SECTION .STACK
	extern kstack_top
; END SECTION .STACK

  ; Trap/no error
VMT_STACK	equ	kstack_top - VM_TRAP_FRAME_size - VTFO
  ; Trap w/error
VMTERR_STACK	equ	kstack_top - VM_TRAP_FRAME_size - VTFOE

;******************************************************************************
;			    E R R O R	 C O D E S
;******************************************************************************
;
PrivErr 	equ	0000h	    ; Privileged Operation Error class
ErrLGDT 	equ	0000h	    ; Client tried to execute a LGDT
ErrLIDT 	equ	0001h	    ; Client tried to execute a LIDT
ErrLMSW 	equ	0002h	    ; Client tried to execute a LMSW
Err2LL		equ	0003h	    ; Client tried to execute a 286 Loadall
Err3LL		equ	0004h	    ; Client tried to execute a 386 Loadall
ErrMovCR	equ	0005h	    ; Client tried to execute a CRn mov
ErrMovDR	equ	0006h	    ; Client tried to execute a DRn mov
ErrMovTR	equ	0007h	    ; Client tried to execute a TRn mov

ExcpErr 	equ	0001h	    ; Exception Error class
ErrDIV		equ	0000h	    ; Divide Error
ErrINT1 	equ	0001h	    ; Debug Exception
ErrNMI		equ	0002h	    ; NMI
ErrINT3 	equ	0003h	    ; Int 3
ErrINTO 	equ	0004h	    ; Int O error
ErrBounds	equ	0005h	    ; Array Bounds Check
ErrOpCode	equ	0006h	    ; Invalid Opcode
ErrCoPNA	equ	0007h	    ; Coprocessor Device not available
ErrDouble	equ	0008h	    ; Double Fault
ErrCoPseg	equ	0009h	    ; Coprocessor Segment Overrun
ErrTSS		equ	000Ah	    ; Invalid TSS
ErrSegNP	equ	000Bh	    ; Segment not Present
ErrStack	equ	000Ch	    ; Stack Fault
ErrGP		equ	000Dh	    ; General Protection Fault
ErrPage 	equ	000Eh	    ; Page Fault
ErrCoPerr	equ	0010h	    ; Coprocessor Error
ErrWrite	equ	0020h	    ; Attempt to write to protected area
ErrDMA		equ	0021h	    ; Attempt to DMA into page frame (not for user)
ErrINTProt	equ	0022h	    ; General Protected interrupt error

; .list; end of VM386.INC
