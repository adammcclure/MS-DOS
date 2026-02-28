

;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:    MEMM - MICROSOFT Expanded Memory Manager 386
;
;   Module:   VDMSEG.INC - Segment Ordering and attributes for VDM
;
;   Version:  0.04
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
;   06/03/86  C 	changed order and added STACK and STACK0,STACK0_SIZE
;   06/06/86  C 	changed CODE to _TEXT and DATA to _DATA
;   06/28/86  0.02	Name change from MEMM386 to MEMM
;   07/05/86  0.04	Re-organized to allow code seg move
;   06/03/88		add use16 to all segments
;
;******************************************************************************
%ifndef INC_LIST
; .xlist
%endif

%ifndef NOHIMEM
;
;  SEGMENT definitions and order
;

;*     CODE area containing EMM/VDISK headers and writeable Real mode code
SECTION .R_CODE
; END SECTION .R_CODE

;*	Contains initialized variables and variables used at startup.
SECTION ._DATA
; END SECTION ._DATA

;* read only constants for C
SECTION .CONST
; END SECTION .CONST

;* uninitialized static data for C
SECTION ._BSS
; END SECTION ._BSS

;* Ring 0 stack in VDM
SECTION .STACK
; END SECTION .STACK

;
; data group
;
; DGROUP	GROUP	_DATA,CONST,_BSS

;*	The code comprising the system.  Must be READ-ONLY in real mode.
SECTION ._TEXT
; END SECTION ._TEXT

;*	Global Descriptor Table
SECTION .GDT
; END SECTION .GDT

;*	Local Descriptor Table
SECTION .LDT
; END SECTION .LDT

;*	Interrupt Descriptor Table
SECTION .IDT
; END SECTION .IDT

;*	Task State Segment
SECTION .TSS
; END SECTION .TSS

;*	Contains initialized variables and variables used at startup.
SECTION .PAGESEG
; END SECTION .PAGESEG

;*	Initialization code and variables.  Used for data later.
;	Must be last segment.
SECTION .LAST
; END SECTION .LAST



%else
;
;  SEGMENT definitions and order
;

;*     CODE area containing EMM/VDISK headers and writeable Real mode code
SECTION .R_CODE
; END SECTION .R_CODE

;*	Global Descriptor Table
SECTION .GDT
; END SECTION .GDT

;*	Local Descriptor Table
SECTION .LDT
; END SECTION .LDT

;*	Interrupt Descriptor Table
SECTION .IDT
; END SECTION .IDT

;*	Task State Segment
SECTION .TSS
; END SECTION .TSS

;*	Contains initialized variables and variables used at startup.
SECTION ._DATA
; END SECTION ._DATA

;* read only constants for C
SECTION .CONST
; END SECTION .CONST

;* uninitialized static data for C
SECTION ._BSS
; END SECTION ._BSS

;* Ring 0 stack in VDM
SECTION .STACK
; END SECTION .STACK

;
; data group
;
; DGROUP	GROUP	_DATA,CONST,_BSS

;*	The code comprising the system.  Must be READ-ONLY in real mode.
SECTION ._TEXT
; END SECTION ._TEXT

;*	Contains dynamically sized emm data structures.
SECTION .VDATA
; END SECTION .VDATA

;*	Contains initialized variables and variables used at startup.
SECTION .PAGESEG
; END SECTION .PAGESEG

;*	Initialization code and variables.  Used for data later.
;	Must be last segment.
SECTION .LAST
; END SECTION .LAST
%endif
;
;  segment related equates
;

; ring 0 stack size
STACK0_SIZE	equ	512

; .list; end of VDMSEG.INC

