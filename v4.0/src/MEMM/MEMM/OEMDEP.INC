

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   OEMDEP.INC
;
;   Version:  0.04
;
;   Date:     June 13, 1986
;
;   Author:
;
;******************************************************************************
;
;   Change log:
;
;     DATE    REVISION			DESCRIPTION
;   --------  --------	-------------------------------------------------------
;   06/13/86  Original
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/05/86  0.04	Moved Diagbyte to _DATA
;   07/06/86  0.04	Change from _DATA assume to DGROUP
;   08/06/86  0.05	Broke out OEMPROC.ASM from OEMDEP.INC
;
;******************************************************************************
%ifndef INC_LIST
; .xlist
%endif


SECTION ._TEXT

extern MaskIntAll; Mask interrupts routine
extern RestIntMask; restore interrupt mask routine

extern Map_Lin_OEM; MapLinear hook
extern UMap_Lin_OEM; UnMapLinear hook
extern MB_Map_Src; Move block map source hook
extern MB_Map_Dest; Move block map destination hook
extern MB_Start; Move block start move hook

; END SECTION ._TEXT


SECTION .LAST

extern VerifyMachine; Verify machine valid for software

; END SECTION .LAST

%ifndef NOHIMEM; only for high memory

;Define routines in OEMPROC module

SECTION ._TEXT

extern HwMemLock
extern HwMemUnlock

; END SECTION ._TEXT

SECTION .LAST

extern hbuf_chk
extern HiAlloc
extern HiSysAlloc
extern HImod
extern LockROM
extern UnLockROM

; END SECTION .LAST

%endif

;******************************************************************************
;
;   HwTabUnlock - unlocks high system RAM - makes tables writeable
;
;	EXIT:	FS points to DIAG segment
;		high system RAM writeable
;
%macro HwTabUnlock 0
%ifndef NOHIMEM; only for high memory
	call	HwMemUnlock
%endif
	%endmacro

;******************************************************************************
;
;   HwTabLock - update client's hi system RAM write locks state
;
;	ENTRY:	CS = _TEXT
;		CS:[DiagByte] = last byte written to diag byte by user.
;
;	EXIT:	high system RAM write protect ON or OFF depenending on
;		write protect bit in CS:[DiagByte].
;		Bit 1 = 0 => write protect ON
;		Bit 1 = 1 => write protect OFF
;
%macro HwTabLock 0
%ifndef NOHIMEM; only for high memory
	call	HwMemLock
%endif

	%endmacro

; .list; end of OEMDEP.INC
