

	; page 58,132
;******************************************************************************
	; TITLE	M_STATE:MODULE to establish machine state at emm boot time
;******************************************************************************
;
;   (C) Copyright MICROSOFT Corp. 1986
;
;   Title:	MEMM.EXE - MICROSOFT Expanded Memory Manager 386 Driver
;
;   Module:	M_STATE
;
;   Version:	0.01
;
;   Date:	Aug 29,1988
;
;   Author:	ISP (ISP)
;******************************************************************************
;
;	Change Log:
;
;	DATE	 REVISION	Description
;	-------- --------	--------------------------------------------
;******************************************************************************
;   Functional Description:
;
;******************************************************************************
; .lfcond
CPU 386

	; page
;******************************************************************************
;		P U B L I C   D E C L A R A T I O N S
;******************************************************************************

	global estb_mach_state

	; page
;******************************************************************************
;			L O C A L   C O N S T A N T S
;******************************************************************************
;

;******************************************************************************
;			INCLUDE FILES
;******************************************************************************
    %include "vdmseg.inc"; segment definitions

	; page
;******************************************************************************
;			E X T E R N A L    R E F E R E N C E S
;******************************************************************************
;
;
SECTION ._DATA
; END SECTION ._DATA

;
SECTION .LAST
;
	extern estb_a20_state
;
; END SECTION .LAST

	; page
;******************************************************************************
;			S E G M E N T	D E F I N I T I O N
;******************************************************************************


;******************************************************************************
;
;	Code Segments
;
;******************************************************************************
;
SECTION ._TEXT
; END SECTION ._TEXT

SECTION .LAST
	; assume	cs:LAST, ds:DGROUP, es:DGROUP

	; page
;-----------------------------------------------------------------------;
; estb_mach_state							;
;                                                                       ;
; establishes the state of the machine at memm boot. the only thing we	;
; are concerned about right now is the a20 state which needs to be	;
; preserved via emulation						;
; 									;
; Arguments:                                                            ;
;	nothing 							;
; Returns:                                                              ;
; 	nothing								;
; Alters:                                                               ;
;	flags								;
; Calls:                                                                ;
;	estb_a20_state							;
; History:                                                              ;
;	ISP (isp).					;
;-----------------------------------------------------------------------;
estb_mach_state:
;
	call	estb_a20_state
	ret
;
; ENDP estb_mach_state

; END SECTION .LAST; End of segment
;

	; end; End of module

