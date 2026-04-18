	   ; PAGE    60,132;
	   ; TITLE DEBDATA.SAL - PC DOS
;======================= START OF SPECIFICATIONS =========================
;
; MODULE NAME: DEBDATA.SAL
;
; DESCRIPTIVE NAME: DATA SEGMENT VALUE DEFINITION
;
; FUNCTION: PROVIDES ALL DATA SEGMENT DEFINITIONS.
;
; ENTRY POINT: NA
;
; INPUT: ANY VALUE IN DATA SEGMENT
;
; EXIT NORMAL: NA
;
; EXIT ERROR: NA
;
; INTERNAL REFERENCES: NA
;
; EXTERNAL REFERENCES: NA
;
; NOTES: THIS MODULE IS TO BE PREPPED BY SALUT WITH THE "PR" OPTIONS.
;	 LINK DEBUG+DEBCOM1+DEBCOM2+DEBCOM3+DEBASM+DEBUASM+DEBERR+
;	      DEBCONST+DEBDATA+DEBMES
;
; REVISION HISTORY:
;
;	AN000	VERSION 4.00 - REVISIONS MADE RELATE TO THE FOLLOWING:
;
;				- IMPLEMENT DBCS HANDLING	DMS:6/17/87
;				- IMPLEMENT MESSAGE RETRIEVER	DMS:6/17/87
;				- > 32 MB SUPPORT		DMS:6/17/87
;
; COPYRIGHT: "MS DOS DEBUG UTILITY"
;	     "VERSION 4.00 (C) COPYRIGHT 1988 Microsoft"
;	     "LICENSED MATERIAL - PROPERTY OF Microsoft  "
;
;======================= END OF SPECIFICATIONS ===========================

	   %if 1  ; IF1 - pass-specific
	       %warning COMPONENT=DEBUG, MODULE=DEBDATA
	   %endif
; .XLIST
; .XCREF
	   %include "DOSSYM.INC"
	   %include "DEBEQU.ASM"
	   %include "DPL.ASM"
; .LIST
; .CREF
SECTION .CODE
; END SECTION .CODE

SECTION .CONST
; END SECTION .CONST

SECTION .DATA
; END SECTION .DATA

SECTION .CSTACK
; END SECTION .CSTACK

; DG	   GROUP CODE,CONST,CSTACK,DATA

SECTION .DATA
	   global PARITYFLAG,XNXOPT,XNXCMD,SWITCHAR,EXTPTR,HANDLE,TRANSADD
	   global PARSERR,ASMADD,DISADD,DISCNT,ASMSP,INDEX,DEFDUMP,DEFLEN
	   global REGSAVE,SEGSAVE,OFFSAVE,TEMP,BUFFER,BYTCNT,OPCODE,AWORD
	   global REGMEM,MIDFLD,MODE,NSEG,BRKCNT,TCOUNT,ASSEM_CNT
	   global ASSEM1,ASSEM2,ASSEM3,ASSEM4,ASSEM5,ASSEM6,BYTEBUF,BPTAB
	   global DIFLG,SIFLG,BXFLG,BPFLG,NEGFLG,NUMFLG,MEMFLG,REGFLG
	   global MOVFLG,TSTFLG,SEGFLG,LOWNUM,HINUM,F8087,DIRFLG,DATAEND
	   global BEGSEG,CREATE_LONG,ARG_BUF_INDEX
	   global FILEEND,FILESTRT,SSINTSAV,BPINTSAV
	   global FZTRACE, PREV24, FIN24

	   global rel_read_write_tab;an000;relative read/write
						;      table
	   global rel_low_sec;an000;sector add. low word
	   global rel_high_sec;an000;sector add. high word
	   global rel_sec_num;an000;# of sectors to access
	   global rel_rw_add;an000;transfer address

	   global lbtbl;an000;lead byte table pointer

	global xm_page;an000;
	global xm_log;an000;
	global xm_phy;an000;
	global xm_handle;an000;
	global xm_handle_ret;an000;
	global xm_page_cnt;an000;
	global xm_handle_pages_buf;an000;
	global xm_frame;an000;
	global xm_deall_han;an000;
	global xm_alloc_pg;an000;
	global xm_total_pg;an000;
	global xm_han_total;an000;
	global xm_han_alloc;an000;

;=========================================================================
; REL_READ_WRITE_TAB : This table provides the new generic IOCTL primitive
;		       read/write with its values.
;
;	Date	  : 6/17/87
;=========================================================================

REL_READ_WRITE_TAB:;an000;relative read/write
						;      table
	rel_low_sec: dw 0;an000;sector add. low word
	rel_high_sec: dw 0;an000;sector add. high word
	rel_sec_num: dw 0;an000;# of sectors to write
	rel_rw_add: dd 0;an000;holds the segment
						;      & offset of the
						;      transfer address

;=========================================================================

lbtbl: dd 0;an000;lead byte table pointer

	xm_page: db 0;an000;page count to allocate
	xm_log: db 0;an000;log. page to map
	xm_phy: db 0;an000;phy. page to map
	xm_deall_han: dw 0;an000;handle to deallocate
	xm_handle: dw 0;an000;handle to map
	xm_handle_ret: dw 0;an000;handle created


	xm_page_cnt: dw 0;an000;current page count

	xm_handle_pages_buf: times 1024 db 0;an000;hold handle pages

	xm_frame: dw 0;an000;holds frame segment

	xm_alloc_pg: dw 0;an000;active page count

	xm_total_pg: dw 0;an000;total possible page cnt.

	xm_han_total: dw 0;an000;total possible handles

	xm_han_alloc: dw 0;an000;handles allocated

	   %if IBMVER
	       global OLD_MASK
OLD_MASK: db 0
	   %endif
PREV24: dd 0; prevvious INT 24 handler
FIN24	   DB	0			; TRUE => in the process of cleaning up
FZTRACE    DB	0			; TRUE => in a Ztrace
FILEEND: dw 0; ARR 2.4
FILESTRT: dw 0; ARR 2.4
SSINTSAV: dd 0; ARR 2.4
BPINTSAV: dd 0; ARR 2.4

PARITYFLAG DB	0

global SAVESTATE
SAVESTATE  DPL	<>			; storage for extended error info

XNXOPT: db 0; AL OPTION FOR DOS COMMAND
XNXCMD: db 0; DOS COMMAND FOR OPEN_A_FILE TO PERFORM
SWITCHAR: db 0; CURRENT SWITCH CHARACTER
EXTPTR: dw 0; POINTER TO FILE EXTENSION
HANDLE: dw 0; CURRENT HANDLE
TRANSADD: dd 0; TRANSFER ADDRESS

PARSERR: db 0
ASMADD: times 4 db 0
DISADD: times 4 db 0
DISCNT: dw 0
ASMSP: dw 0; SP AT ENTRY TO ASM
INDEX: dw 0
DEFDUMP: times 4 db 0
DEFLEN: dw 0
REGSAVE: dw 0
SEGSAVE: dw 0
OFFSAVE: dw 0

;Do NOT move this dword variable - it sets up a long call for
;a Create_process_data_block call issued in DEBUG
CREATE_LONG:
	   DW	100H
BEGSEG: dw 0

; The following data areas are destroyed during hex file read
TEMP: times 4 db 0
BUFFER:
BYTCNT: db 0
ARG_BUF_INDEX: dw 0
OPCODE: dw 0
AWORD: db 0
REGMEM: db 0
MIDFLD: db 0
MODE: db 0
NSEG: dw 0
BRKCNT: dw 0; Number of breakpoints
TCOUNT: dw 0; Number of steps to trace
ASSEM_CNT: db 0; preserve order of assem_cnt and assem1
ASSEM1: db 0
ASSEM2: db 0
ASSEM3: db 0
ASSEM4: db 0
ASSEM5: db 0
ASSEM6: db 0; preserve order of assemx and bytebuf
BYTEBUF    DB	BUFLEN	DUP (?) 	; Table used by LIST
BPTAB	   DB	BPLEN	DUP (?) 	; Breakpoint table
DIFLG: db 0
SIFLG: db 0
BXFLG: db 0
BPFLG: db 0
NEGFLG: db 0
NUMFLG: db 0; ZERO MEANS NO NUMBER SEEN
MEMFLG: db 0
REGFLG: db 0
MOVFLG: db 0
TSTFLG: db 0
SEGFLG: db 0
LOWNUM: dw 0
HINUM: dw 0
F8087: db 0
DIRFLG: db 0
	   DB	BUFFER+BUFSIZ-$ DUP (?)

DATAEND:

; END SECTION .DATA
	   ; END
