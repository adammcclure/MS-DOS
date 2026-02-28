
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
IFS_ATTRIBUTE: dw 0; Attributes
IFS_VERSION	DW	0	; Request level supported
IFS_DOSCALL@: dd 0; DOS interface routine
				;   (set by TUPPER before the init call)
IFS_CALL@: dw 0; Function entry point
endstruc

;=====================
; IFS Request Header
;=====================

struc IFSRH
IFSR_LENGTH: dw 0; Total length of request
IFSR_FUNCTION: db 0; Requested function
IFSR_RETCODE: db 0; Explicit error
IFSR_RETCLASS: db 0; Error class
IFSR_RESV1: times 17 db 0; DOS reserved
IFSR_FCN_PARMS: times 38 db 0; Additional parameters
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
IFSR_PARMS@	   =  dword  IFSR_FCN_PARMS    ; command parameters
IFSR_RESSIZE	   =  word  IFSR_FCN_PARMS+4  ; driver total size
LENGTH_INIT	   EQU IFSR_RESSIZE-IFSRH+2

