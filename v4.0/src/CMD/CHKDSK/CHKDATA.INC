
SECTION .CONST
	extern STACKMES
	extern BADVER, BADDRV_ARG, INVPATH_ARG
	extern FILE_ARG
	extern BADCD_ARG, BADSUBDIR
	extern no_mem_arg;an030;bgb
	extern BADRDMES
	extern BADDRVM
	extern BADIDBYT
	extern OPNERR_ARG, NOEXT_ARG, EXTENT_ARG
	extern IDMES_ARG
	extern ORPH_ARG
	extern FILE_ARG1, FILE_ARG2
	extern badrw_num, BADRW_STR, BLOCK_NUM
	extern FATAL_ARG1, FATAL_ARG2
	extern FATmsg2;an024;bgb
	extern BADSW_ARG, DSKSPC;an049;bgb
	extern HIDMES, DIRMES, FILEMES, ORPHMES2
	extern ORPHMES3, BADSPC, FRESPC
	extern FREMEM, REPORT_ARG, CRLF_ARG
	extern RARG1, RARG3, ORPHCNT
	extern NO_NET_ARG, MONTAB,  SubstErr
	extern ExitStatus,Badr_Arg;an000;bgb
	extern Sublist_msg_Idmes;an000;bgb
	extern msgserialnumber;an000;bgb
	extern psp_segment;an000;bgb;an034;bgb
										;an000;bgb
	global SWITCHAR
	global TCHAR
	global HECODE
	global conbuf
	global DOTMES
	global NOISY
	global DOTENT
	global HAVFIX
	global DOFIX
	global DIRBUF
	global PARSTR, DDOTENT, NUL, ERRSUB, SECONDPASS, ALLFILE
	global ORPHFCB, ORPHEXT, HIDCNT, HIDSIZ, FILCNT, FILSIZ, DIRCNT
	global DIRSIZ, DIRTYFAT, CROSSCNT, BADSIZ, ORPHSIZ, LCLUS
	global USERDIR, FRAGMENT, ALLDRV, FIXMFLG, DIRCHAR
	global BIGFAT, EOFVAL, BADVAL,CHAIN_END
	global fTrunc,Volnam
	global temp_dd;an049;bgb

DIRBUF:;Entry buffer for searches
VOLID	DB	-1,0,0,0,0,0,8		;Volume ID FCB
VOLNAM	DB	0,"???????????"
	times 25 db 0

ALLFILE DB	-1			;Extended FCB indicator
	DB	0,0,0,0,0		;reserved bytes
	DB	1EH	;attribute byte 0001-1110 hidden, system, label, subdir
ALLDRV	DB	0			;default drive
	DB	"???????????"           ;any file name
	times 25 db 0

ORPHFCB DB	0,"FILE0000"
ORPHEXT DB	"CHK"
	times 25 db 0

fcb_copy: times 32 db 0

;Non-message data

pFileName: dw 0; pointer
SWITCHAR DB	"/"
ROOTSTR:;use this to change dir to the root
DIRCHAR DB	"\"
NUL	DB	0
PARSTR	DB	"..",0
DOTMES	DB	".",0
DOTENT	DB	".          "
DDOTENT DB	"..         "
HECODE: db 0
FIXMFLG DB	0			;Flag for printing fixmes
ERRSUB	DW	0			;Flag for bad subdir error
FRAGMENT DB	0			;Flag for extent processing
DIR_FIX  DB	0			;Flag for changing dir back to users'
DIRTYFAT DB	0			;Dirty flag for FAT
;
;note - all these fields that count allocation units can remain the same,
;	because the total au's are always less than 64k (1 word).
; looks like the number of files and directories should change, though.
DIRCNT	dd	0			;# directories				;an049;bgb
DIRSIZ	dw	0			;# alloc units in dirs			;an049;bgb
FILCNT	dd	0			;# reg files
FILSIZ	dw	0			;# alloc units in reg files
HIDCNT	dd	0			;# hidden files
HIDSIZ	dw	0			;# alloc units in hid files
BADSIZ	dw	0			;# alloc units in bad sectors
ORPHSIZ dw	0			;# alloc units in orphan files
LCLUS	dw	0			;# alloc units in lost clusters
DISPFLG DB	0			;used by number routines
CROSSCNT dd	0			;# crosslinked files (first pass)
;end of display fields
;
temp_dd    dd	0		    ;temporary double word field for orphcnt;an049;bgb
SECONDPASS DB	0			;Pass flag
HAVFIX	DB	0			;non zero if any fixes
DOFIX	DB	0			;flag for F switch
NOISY	DB	0			;flag for V switch
BIGFAT	DB	0			;0=12 bit FAT, NZ=16bit FAT
EOFVAL	DW	0FF8H			;0FF8 for 12 bit FAT,0FFF8 for 16 bit
CHAIN_END DW	0FFFH			;0FFF for 12 bit FAT,0FFFF for 16 bit	;AN000;
BADVAL	DW	0FF7H			;0FF7 for 12 bit FAT,0FFF7 for 16 bit

mon_name: times 3 db 0
TCHAR	DB	'a'
USERDIR DB	"\",0                   ;Users current dir for drive
	DB	(DIRSTRLEN-1) DUP (?)
CONBUF	DB	15,0			;Input buffer
	times 15 db 0

fTrunc	DB	FALSE			; TRUE => couldn't chdir, no freeing.

badread db	"   File allocation table bad",0
; END SECTION .CONST








SECTION .DATA
	global THISDPB,DOTSNOGOOD,NUL_ARG,STACKLIM,ZEROTRUNC
	global NAMBUF,SRFCBPT,fatmap,ISCROSS,MCLUS,CSIZE,SSIZE
	global DSIZE,ARG1,ARG_BUF,ERRCNT,USERDEV,SECBUF
	global HARDCH,CONTCH,PATH_NAME,TMP_SPC,mem_size
	global Read_Write_Relative,Transrc, fatcnt, fattbl_seg;an000;bgb
	global firstfat, fatsiz, secs_per_64k, paras_per_fat, sec_count;an000;bgb
	global firstsec;an047;bgb
	global dirsec;an047;bgb
     global root_entries;an047;bgb
	global paras_per_64k, save_drive;an000;bgb
	global sernum;an000;bgb;an024;bgb
%ifdef fsexec;an038;bgb
	global exec_path;an038;bgb;an000;bgb;an027;bgb
	global exec_block;an038;bgb;an000;bgb;an027;bgb
	global path_string;an038;bgb;an000;bgb;an027;bgb
%endif;an038;bgb
	global end_of_fatmap;an000;bgb;an030;bgb
	global DBCS_VECTOR;an055;bgb
	global DBCS_VECTOR_off;an055;bgb
	global DBCS_VECTOR_seg;an055;bgb

DBCS_VECTOR DB 0
DBCS_VECTOR_off dw 0
DBCS_VECTOR_seg dw 0

%ifdef fsexec;an038;bgb
Exec_Block Exec_Block_Parms <>							;an038;bgb;an027;bgb
EXEC_Path: times 66 db 0;an038;bgb;an027;bgb
;These next two should stay togather						;an027;bgb
; ---------------------------------------					;an027;bgb
Path_String db	"PATH="                         ;                               ;an027;bgb
Len_Path_String equ $ - Path_String		;				;an027;bgb;AN000;
;----------------------------------------					;an027;bgb
%endif;an038;bgb
										;an038;bgb;an027;bgb
										;an027;bgb
;These should stay togather							;an027;bgb
; ---------------------------------------					;an027;bgb
						;				;an027;bgb
Search_Chkdsk db "KSDKHC"                       ;                               ;an027;bgb
Len_Search_Chkdsk equ $ - Search_Chkdsk 	;				;an027;bgb
Search_Chkdsk_End equ $-1							;an027;bgb
						;				;an027;bgb
;----------------------------------------					;an027;bgb
save_drive	db	0   ;determines whether drive specified is valid
firstfat	dw	0   ;sector number of fat     ;an005;bgb
firstsec	dw	0   ;sector number of data area 			;an047;bgb
dirsec		dw	0   ;sector number of dir  area 			;an047;bgb
root_entries   dw   0	;number of entries in root dir				;an047;bgb
fattbl_seg	dw	0   ;segment of the fat-table ;an005;bgb
sec_count	dw	0  ;sectors / 64k
secs_per_64k	dw	0			   ;an005;bgb
paras_per_64k	dw	0			   ;an005;bgb
fatsiz		dw	0			   ;an005;bgb
paras_per_fat	dw	0			   ;an005;bgb
fatcnt		db	2			;number of fats on disk 		;an005;bgb
HARDCH: dd 0;Pointer to real INT 24 handler
CONTCH: dd 0;Pointer to real INT 23 handler
THISDPB: dd 0;Pointer to drive DPB
USERDEV: db 0;Users current device
CSIZE: db 0;Sectors per cluster 1-256
SSIZE: dw 0;bytes per sector 1-64k
DSIZE: dw 0;# alloc units on disk
MCLUS: dw 0;DSIZE + 1
NAMBUF: times 14 db 0;Buffer
DOTSNOGOOD: db 0;. or .. error flag
ZEROTRUNC: db 0;Trimming flag
ISCROSS: db 0;Crosslink flag
OLDCLUS: dw 0
SRFCBPT: dw 0
fatmap: dw 0;segment of fatmap table		;an005;bgb
end_of_fatmap: dw 0;last mem segment used			;an030;bgb
SECBUF: dw 0;Offset of sector buffer (in ram)
ERRCNT: db 0;Used by FATread and write
PATH_NAME: times 128 db 0
FNAME_LEN DW	128
NUL_ARG: db 0
ARG1: dw 0
ARG2: dw 0
ARG3: dw 0


;
; The following is used as a PRINTF buffer and also as the source/destination
; for a name trans
;
ARG_BUF: times 256 db 0
TMP_SPC: times 128 db 0
mon: dw 0
day: dw 0
year: dw 0
mem_size: dw 0
;;;TRANSRC DB	   "A:CON",0,0                     ; Device so we don't hit the drive
TRANSRC DB	"A:\",0,0                     ; Device so we don't hit the drive
Read_Write_Relative	Relative_Sector_Buffer <>  ;				;AN000;

STACKLIM: dw 0;Stack growth limit
INTERNATVARS	internat_block <>
		DB	(internat_block_max - ($ - INTERNATVARS)) DUP (?)


;	      Structure for Get_Media_Id					;an024;bgb
SerNumBuf:;AN000;S GENERIC_IOCTL buffer		;an024;bgb
		   dw	0	   ;AN000;S Info level (set on input)		;an024;bgb
SerNum		   dd	0	   ;AN000;S Serial #				;an024;bgb
		   times 11 db ' ';AN000;S Volume label                       ;an024;bgb
		   times 8 db ' ';AN000;S File system type                    ;an024;bgb
; END SECTION .DATA

										;an000;bgb
										;an000;bgb
SECTION .lastseg;an000;bgb
 global fattbl;an000;bgb
fattbl	db	0   ;this is the last thing in the pgm				;an000;bgb;an005;bgb
; END SECTION .lastseg;this is where the fat is put in ram			;an000;bgb

