
%warning MSBDS.INC...
;	SCCSID = @(#)IBMBDS.ASM 1.9 85/09/16
;==============================================================================
;REVISION HISTORY:
;AN000 - New for DOS Version 4.00 - J.K.
;AC000 - Changed for DOS Version 4.00 - J.K.
;AN00x - PTM number for DOS Version 4.00 - J.K.
;==============================================================================
;AN001; D113 Disable I/O access to unformatted media		    9/03/87 J.K.
;==============================================================================

; VALUES FOR VARIOUS FLAGS IN BDS.FLAGS.

FNON_REMOVABLE	    EQU     01H 	;FOR NON-REMOVABLE MEDIA
FCHANGELINE	    EQU     02H 	;IF CHANGELINE SUPPORTED ON DRIVE
RETURN_FAKE_BPB     EQU     04H 	; WHEN SET, DON'T DO A BUILD BPB
					; JUST RETURN THE FAKE ONE
GOOD_TRACKLAYOUT    EQU     08H 	; THE TRACK LAYOUT HAS NO FUNNY SECTORS
; FCHANGED_BY_FORMAT  EQU	    08H
FI_AM_MULT	    EQU     10H 	;IF MORE THAN ONE LOGICAL FOR THIS PHYSICAL
FI_OWN_PHYSICAL     EQU     20H 	;SIGNIFY LOGICAL OWNER OF THIS PHYSICAL
FCHANGED	    EQU     40H 	;INDICATES MEDIA CHANGED
SET_DASD_TRUE	    EQU     80H 	; SET DASD BEFORE NEXT FORMAT
FCHANGED_BY_FORMAT  EQU    100H 	;MEDIA CHANGED BY FORMAT
UNFORMATTED_MEDIA   EQU    200H 	;AN001; Fixed disk only

;
; VARIOUS FORM FACTORS TO DESCRIBE MEDIA
;
FF48TPI 	    EQU     0
FF96TPI 	    EQU     1
FFSMALL 	    EQU     2
FFHARDFILE	    EQU     5
FFOTHER 	    EQU     7

struc BDS_TYPE
LINK: resd 1; LINK TO NEXT BDS
DRIVENUM: resb 1; INT 13 DRIVE NUMBER
DRIVELET: resb 1; DOS DRIVE NUMBER
BYTEPERSEC: resw 1; NUMBER OF BYTES/SEC
SECPERCLUS: resb 1; SEC PER ALLOCATION UNIT
RESSEC: resw 1; NUMBER OF RESERVED SECTORS
CFAT: resb 1; NUMBER OF FATS
CDIR: resw 1; NUMBER OF DIRECTORY ENTRIES
DRVLIM: resw 1; NUMBER OF SECTORS ON MEDIUM
MEDIAD: resb 1; MEDIA DESCRIPTOR BYTE
CSECFAT: resw 1; NUMBER OF SECTORS/FAT
SECLIM: resw 1; SECTORS PER TRACK
HDLIM: resw 1; MAX NUMBER OF HEADS
HIDSEC_L: resw 1; NUMBER OF HIDDEN SECTORS
HIDSEC_H	dw		0	;J.K.87
DRVLIM_L	dw		0	;J.K.87
DRVLIM_H	dw		0	;J.K.87
FATSIZ: resb 1; FLAGS...
OPCNT: resw 1; OPEN REF. COUNT
FORMFACTOR: resb 1; FORM FACTOR INDEX
FLAGS: resw 1; VARIOUS FLAGS
CCYLN: resw 1; MAX NUMBER OF CYLINDERS
RBYTEPERSEC: resw 1; RECOMMENDED BPB
RSECPERCLUS: resb 1
RRESSEC: resw 1
RCFAT: resb 1
RCDIR: resw 1
RDRVLIM: resw 1
RMEDIAD: resb 1
RCSECFAT: resw 1
RSECLIM: resw 1
RHDLIM: resw 1
RHIDSEC_L: resw 1
RHIDSEC_H	DW		0	;J.K.87
RDRVLIM_L	dw		0	;J.K.87
RDRVLIM_H	dw		0	;J.K.87
RESERVE: resb 6; RESERVED FOR FUTURE
TRACK: resb 1; LAST TRACK ACCESSED ON DRIVE
TIM_LO: resw 1; TIME OF LAST ACCESS. KEEP
TIM_HI: resw 1; THESE CONTIGUOUS.
VOLID: resb 12; VOLUME ID OF MEDIUM
VOL_SERIAL	dd	0	  ;J.K.87 Current volume serial number from Boot record
FILESYS_Id: resb 9;J.K.87 Current file system id from Boot record
endstruc

BPBSIZE equ TRACK - RBYTEPERSEC; SIZE IN BYTES OF RECBPB AREA IN THE BDS


;*********************************************************************
;	BDS structure for mini disk - J.K. 4/7/86
;*********************************************************************

struc BDSM_type
mlink		DW	-1			;Link to next structure
		resw 1
mdriveNum	DB	80			;Int 13 Drive Number
mdriveLet	DB	3			;Logical Drive Number
mBytePerSec	DW	512
mSecPerClus	DB	1			;Sectors/allocation unit
mRESSEC 	DW	1			;Reserved sectors for DOS
mcFAT		DB	2			;No. of allocation tables
mcDIR		DW	16			;Number of directory entries
mDRVLIM 	DW	0			;Number of sectors (at 512 bytes each)
mMediad 	DB	11111000B		;Media descriptor
mcSecFat	DW	1			;Number of FAT sectors
mSECLIM 	DW	0			;Sector limit
mHDLIM		DW	0			;Head limit
mHIDSEC_L	DW	0			;Hidden sector count
mHidsec_H	dw	0			;J.K.87
mDrvlim_L	dw	0			;J.K.87
mDrvlim_H	dw	0			;J.K.87
mFatSiz 	DB	0			;TRUE => bigfat
mOPCNT		DW	0			;Open Ref. Count
mFormFactor	DB	3			;Form Factor
mFLAGS		DW	0020H			;Various Flags
mcCyln		dw	40			;max number of cylinders
mRecBPB: resb 31;Recommended BPB for drive
mTrack		db	-1
IsMini		dw	1			;Overlapping TIM_LOH
Hidden_Trks	dw	0			;Overlapping TIM_HIH
mVOLID		DB	"NO NAME    "           ;Volume ID for this disk
		resb 1;ASCIZII for "NO NAME    "
mVol_Serial	dd	0	   ;Current volume serial number from Boot record
mFileSys_Id	db	"FAT12   " ;Current file system id from Boot record
		resb 1

endstruc
;******************************************************************************
Max_mini_dsk_num equ 23;J.K. 4/7/86 - max # of mini disk ibmbio can support
;

