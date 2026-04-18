

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
	LowByte: resb 1
	HighByte: resb 1
endstruc

struc DwordS
	LowWord: resw 1
	HighWord: resw 1
endstruc

;
;   Structure for accessing stack frame pushed during trap exit from VM
;

struc VM_TRAP_FRAME
VMTF_EIP: resw 1; EIP (low)
		resw 1; EIP (high)
VMTF_CS: resw 1; CS
		resw 1;   (padding)
VMTF_EFLAGS: resw 1; EFLAGS (low)
VMTF_EFLAGShi: resw 1; EFLAGS (high)
VMTF_ESP: resw 1; ESP (low)
		resw 1; ESP (high)
VMTF_SS: resw 1; SS
		resw 1;   (padding)
VMTF_ES: resw 1; ES
		resw 1;   (padding)
VMTF_DS: resw 1; DS
		resw 1;   (padding)
VMTF_FS: resw 1; FS
		resw 1;   (padding)
VMTF_GS: resw 1; GS
		resw 1;   (padding)
endstruc
;
					; Used in EmMovCDTR (vminst.asm)
struc MOV_CDTR_FRAME
MCF_WBP: resw 1; Work BP
MCF_WES: resw 1; Work ES
MCF_EAX: resw 1; EAXlo
		resw 1; EAXhi
MCF_ESI: resw 1; ESIlo
		resw 1; ESIhi
MCF_EBX: resw 1; EBXlo
		resw 1; EBXhi
MCF_EBP: resw 1; EBPlo
		resw 1; EBPhi
MCF_VMERR: resw 1; VM Error Code (low)
		resw 1; VM Error Code (high)
MCF_VMEIP: resw 1; VM EIP (low)
		resw 1; VM EIP (high)
MCF_VMCS: resw 1; VM CS
		resw 1;   (padding)
MCF_VMEFLAGS: resw 1; VM EFLAGS (low)
MCF_VMEFLAGShi: resw 1; VM EFLAGS (high)
MCF_VMESP: resw 1; VM ESP (low)
		resw 1; VM ESP (high)
MCF_VMSS: resw 1; VM SS
		resw 1;   (padding)
MCF_VMES: resw 1; VM ES
		resw 1;   (padding)
MCF_VMDS: resw 1; VM DS
		resw 1;   (padding)
MCF_VMFS: resw 1; VM FS
		resw 1;   (padding)
MCF_VMGS: resw 1; VM GS
		resw 1;   (padding)
endstruc
;
					; Used in EmProtIns (vminst.asm)
struc PROT_INS_FRAME
PIF_WBP: resw 1; Work BP
PIF_WES: resw 1; Work ES
PIF_AX: resw 1; EAXlo
PIF_DX: resw 1; EDXlo
PIF_ESI: resw 1; ESIlo
		resw 1; ESIhi
PIF_EBX: resw 1; EBXlo
		resw 1; EBXhi
PIF_EBP: resw 1; EBPlo
		resw 1; EBPhi
PIF_VMERR: resw 1; VM Error Code (low)
		resw 1; VM Error Code (high)
PIF_VMEIP: resw 1; VM EIP (low)
		resw 1; VM EIP (high)
PIF_VMCS: resw 1; VM CS
		resw 1;   (padding)
PIF_VMEFLAGS: resw 1; VM EFLAGS (low)
PIF_VMEFLAGShi: resw 1; VM EFLAGS (high)
PIF_VMESP: resw 1; VM ESP (low)
		resw 1; VM ESP (high)
PIF_VMSS: resw 1; VM SS
		resw 1;   (padding)
PIF_VMES: resw 1; VM ES
		resw 1;   (padding)
PIF_VMDS: resw 1; VM DS
		resw 1;   (padding)
PIF_VMFS: resw 1; VM FS
		resw 1;   (padding)
PIF_VMGS: resw 1; VM GS
		resw 1;   (padding)
endstruc
;
struc GPFAULT_FRAME
GPF_ESI: resw 1; ESIlo
		resw 1; ESIhi
GPF_EBX: resw 1; EBXlo
		resw 1; EBXhi
GPF_EBP: resw 1; EBPlo
		resw 1; EBPhi
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
