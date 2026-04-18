
	; PAGE	60,132
;	SCCSID = @(#)smifssym.inc 1.0 87/05/11
;
;   Modification history:
;	Created: May 11 1987 
;
;	SMifssym is only for IBMBIO.  It will only has definitions
;	for IFSHEADER, IFSRH of INIT function.
;	When ifssym.inc is Revised, make sure that SMifssym.inc
;	is also correct. - JK.
;

;==================
;IFS drive header
;=================

    IFSDEVICE	EQU	8000H	;  Supports single device/file functions
    IFSDISK	EQU	4000H	;  Supports multi-file functions
    IFSUNC	EQU	2000H	;  Support UNC (nameless) connection
    IFSREMOTE	EQU	0800H	;  File system is remote
    IFSFILTER	EQU	0400H	;  FS will filter (if off, use DOS
				;    standard, cap & 8.3)
    IFSIOCTL	EQU	0002H	;  Supports IOCTL functions
    IFSUSESHARE EQU	0001H	;  Uses DOS share support (vs own share)

struc IFSHEADER
IFS_NEXT	DD	-1	; Next header in list (-1=end)
IFS_NAME	DB	"        " ; IFS name
IFS_ATTRIBUTE: resw 1; Attributes
IFS_VERSION	DW	0	; Request level supported
IFS_DOSCALL@: resd 1; DOS interface routine
				;   (set by TUPPER before the init call)
IFS_CALL@: resw 1; Function entry point
endstruc

;=====================
; IFS Request Header
;=====================

struc IFSRH
IFSR_LENGTH: resw 1; Total length of request
IFSR_FUNCTION: resb 1; Requested function
IFSR_RETCODE: resb 1; Explicit error
IFSR_RETCLASS: resb 1; Error class
IFSR_RESV1: resb 17; DOS reserved
IFSR_FCN_PARMS: resb 38; Additional parameters
endstruc

; IFSR_FUNCTION codes
;	Control requests:
IFSINIT        EQU     1
IFSATTSTART    EQU     2
IFSATTEND      EQU     3
IFSEXECAPI     EQU     4
IFSCRITMSG     EQU     5
IFSCBUPDATE    EQU     6
; INIT function.
IFSR_PARMS@ equ dword  IFSR_FCN_PARMS; command parameters
IFSR_RESSIZE equ word  IFSR_FCN_PARMS+4; driver total size
LENGTH_INIT	   EQU IFSR_RESSIZE-IFSRH+2

