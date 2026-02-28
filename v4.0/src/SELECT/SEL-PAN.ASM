

; PAGE	55,132;AN000;
; NAME	SELPAN;AN000;
; TITLE	SELPAN	 - Table of entry points of panels, scroll fields, color;AN000;
; SUBTTL	sel-pan.asm;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	SELPAN .ASM
;
;
; Copyright 1988 Microsoft
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; .alpha; arrange segments alphabetically

	extern PCB_VECTOR;AN000;
	extern NUM_PCB;AN000;
	extern WR_SCBVEC;AN000;
	extern NUM_SCB;AN000;
	extern WR_CIS;AN000;
	extern L_WR_CIS;AN000;
	extern WR_CIS2;AN000;
	extern L_WR_CIS2;AN000;
					;
struc EXT_FILE;AN000;
PCBS	DW	0			;AN000;
NPCBS	DW	0			;AN000;
SCBS	DW	0			;AN000;
NSCBS	DW	0			;AN000;
COLTBL	DW	0			;AN000;
NCOLTBL DW	0			;AN000;
MONTBL	DW	0			;AN000;
NMONTBL DW	0			;AN000;
endstruc;AN000;
					;
SECTION .CODE;AN000;
	DW	PCB_VECTOR		;AN000;
	DW	NUM_PCB 		;AN000;
	DW	WR_SCBVEC		;AN000;
	DW	NUM_SCB 		;AN000;
	DW	WR_CIS2			;AN000;
	DW	L_WR_CIS2		;AN000;
	DW	WR_CIS2 		;AN000;
	DW	L_WR_CIS2		;AN000;
; END SECTION .CODE;AN000;
	; END;AN000;
