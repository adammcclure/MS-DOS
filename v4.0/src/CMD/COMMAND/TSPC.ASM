 ; page 80,132
;	SCCSID = @(#)tspc.asm	4.1 85/09/22
;	SCCSID = @(#)tspc.asm	4.1 85/09/22
; TITLE	COMMAND Transient Uninitialized DATA

	%include "comsw.asm"
; .xlist
; .xcref
	%include "DOSSYM.INC"
	%include "comequ.asm"
	%include "comseg.asm"
	%include "EA.inc";AN030;
; .list
; .cref

; Uninitialized transient data
SECTION .TRANSPACE

	global ALLSWITCH
	global append_exec;AN041;
	global arg
	global argbufptr
	global ARGC
	global ARG1S
	global ARG2S
	global ARGTS
	global arg_buf
	global ASCII
	global BatBuf
	global BatBufEnd
	global BatBufPos
	global BATHAND
	global BINARY
	global BITS
	global BWDBUF
	global BYTCNT
	global bytes_free
	global CFLAG
	global CHARBUF
	global CHKDRV
	global COM
	global COMBUF
	global comma
	global comptr
	global comspec_flag
	global COMSW
	global CONCAT
	global concat_xa;AN000;
	global copy_Num
	global CPDATE
	global CPTIME
	global cpyflag
	global CURDRV
	global DATE_DAY;AN000;
	global DATE_MONTH;AN000;
	global DATE_OUTPUT;AN000;
	global DATE_TYPE;AN000;
	global DATE_YEAR;AN000;
	global DEST
	global DESTBUF
	global DestClosed
	global DESTDIR
	global DESTFCB
	global DESTFCB2
	global DESTHAND
	global DESTINFO
	global DESTISDEV
	global DESTISDIR
	global DESTNAME
	global DESTSIZ
	global DESTSWITCH
	global DESTTAIL
	global DESTVARS
	global DIRBUF
	global DIRCHAR
	global dirflag;AN015;
	global Dir_Num
	global display_ioctl;AN000;
	global display_mode;AN000;
	global display_width;AN000;
	global DRIVE_NUMBER;AN000;
	global DRIVE_OUTPUT;AN000;
	global DRIVE_TYPE;AN000;
	global DRIVE_VALUE;AN000;
	global ELCNT
	global ELPOS
	global EXECPATH
	global EXEC_ADDR
	global EXEFCB
	global expand_star
	global ext_entered;AN005;
	global ext_open_off;AN000;
	global ext_open_parms;AN000;
	global ext_open_seg;AN000;
	global FBUF
	global FILECNT
	global file_size_high
	global file_size_low
	global FILTYP
	global FIRSTDEST
	global FRSTSRCH
	global FULLSCR
	global GOTOLEN
	global HEADCALL
	global ID
	global IDLEN
	global IFNOTFLAG
	global if_not_count
	global INEXACT
	global INTERNATVARS
	global KPARSE
	global last_arg
	global LINCNT
	global LINLEN
	global linperpag;AN000;
	global major_ver_num
	global MELCOPY
	global MELSTART
	global minor_ver_num
	global msg_flag;AN022;
	global msg_numb;AN022;
	global NOWRITE
	global NXTADD
	global objcnt
	global one_char_val
	global PARM1
	global PARM2
	global parse_last;AN018;
	global PARSE1_ADDR;AN000;
	global PARSE1_CODE;AN000;
	global PARSE1_OUTPUT;AN000;
	global PARSE1_SYN;AN000;
	global PARSE1_TYPE;AN000;
	global PATHCNT
	global pathinfo
	global PATHPOS
	global PATHSW
	global PLUS
	global plus_comma
	global print_err_flag;AN000;
	global psep_char
	global RCH_ADDR
	global RDEOF
	global RE_INSTR
	global RESSEG
	global SCANBUF
	global SDIRBUF
	global search_best
	global search_best_buf
	global search_curdir_buf
	global search_error
	global SKPDEL
	global SOURCE
	global SPECDRV
	global SRCBUF
	global SRCHAND
	global SRCINFO
	global SRCISDEV
	global SRCISDIR
	global SRCPT
	global SRCSIZ
	global SRCTAIL
	global SRCVARS
	global srcxname
	global src_xa_seg;AN000;
	global src_xa_size;AN000;
	global STACK
	global STARTEL
	global string_ptr_2
;AD061; PUBLIC	string_ptr_2_sb 	;AN000;
	global subst_buffer;AN061;
	global SWITCHAR
	global system_cpage
	global TERMREAD
	global TIME_FRACTION;AN000;
	global TIME_HOUR;AN000;
	global TIME_MINUTES;AN000;
	global TIME_OUTPUT;AN000;
	global TIME_SECONDS;AN000;
	global TIME_TYPE;AN000;
	global TPA
	global tpbuf
	global TRANSPACEEND
	global TRAN_TPA
	global trgxname
	global UCOMBUF
	global USERDIR1
	global vol_drv
	global vol_ioctl_buf;AC030;
	global vol_serial;AC030;
	global vol_label;AC030;
	global WRITTEN
	global xa_cp_length;AN030;
	global xa_cp_out;AN030;
	global xa_list_attr;AN030;
	global zflag

	%if IBM
	global ROM_CALL
	global ROM_CS
	global ROM_IP
	%endif


	ORG	0
ZERO	=	$
SRCXNAME	DB	DIRSTRLEN + times 20 db 0	;g buffer for name translate
TRGXNAME	DB	DIRSTRLEN + times 20 db 0	;g buffer for name translate
UCOMBUF 	DB	COMBUFLEN+times 3 db 0	; Raw console buffer
COMBUF		DB	COMBUFLEN+times 3 db 0	; Cooked console buffer
USERDIR1	DB	DIRSTRLEN+times 3 db 0	; Storage for users current directory
EXECPATH	DB	COMBUFLEN+times 3 db 0	; Path for external command
RE_INSTR	DB	DIRSTRLEN+3+times 13 db 0	; path for input to redirection

; Variables passed up from resident
HEADCALL:
		dw 0
RESSEG: dw 0
TPA: dw 0
SWITCHAR: db 0
DIRCHAR: db 0
EXEC_ADDR: dd 0
RCH_ADDR: dd 0
fTest: dw 0
TRAN_TPA: dw 0

CHKDRV: db 0
RDEOF:; Misc flags
IFNOTFLAG:
FILTYP: db 0
CURDRV: db 0
concat_xa	db	0			;AN000; flag for XA on file concatenations
CONCAT:
PARM1: db 0
ARGC:
PARM2: db 0
COMSW: dw 0; Switches between command and 1st arg
ARG1S: dw 0; Switches between 1st and 2nd arg
DESTSWITCH:
ARG2S: dw 0; Switches after 2nd arg
ALLSWITCH:
ARGTS: dw 0; ALL switches except for COMSW
CFLAG: db 0
DESTCLOSED:
SPECDRV: db 0
BYTCNT: dw 0; Size of buffer between RES and TRANS
NXTADD: dw 0
FRSTSRCH: db 0
LINCNT: db 0
LINLEN: db 0
FILECNT: dw 0
CHARBUF: times 80 db 0;line byte character buffer for xenix write
DESTFCB2:
IDLEN: db 0
ID: times 8 db 0
COM: times 3 db 0
DEST: times 37 db 0
DESTNAME: times 11 db 0
DESTFCB:
DESTDIR 	DB	DIRSTRLEN DUP(?)	; Directory for PATH searches
GOTOLEN:
BWDBUF:
EXEFCB:
DIRBUF		DB	DIRSTRLEN+times 3 db 0
SDIRBUF: times 12 db 0
BITS: dw 0
PATHCNT: dw 0
PATHPOS: dw 0
PATHSW: dw 0
FULLSCR: dw 0
comma		db	0			;g flag set if +,, occurs
plus_comma	db	0			;g flag set if +,, occurs
dirflag 	db	0			;AN015; set when pathcrunch called from DIR
parse_last	dw	0			;AN018; used to hold parsing position

system_cpage	DW	0			;AC001; used for CHCP variable
src_XA_size	DW	0			;AN000; size of extended attributes
src_XA_seg	DW	0			;AN000; segment of extended attributes

ext_open_parms:;AN000; extended open parameter list
;emg340 ext_open_off	dw	offset trangroup:srcbuf ;AN000; offset of file name
ext_open_off: dw 0;AN030; offset of extended attributes
ext_open_seg: dw 0;AN000; segment of extended attributes
		dw	0			;AN000; no additional parameters

XA_cp_out:;AN030; list for one extended attribute
		DW	1			;AN030; count of entries
		DB	EAISBINARY		;AN030; ea_type
		DW	EASYSTEM		;AN030; ea_flags
		db 0;AN030; ea_rc
		DB	2			;AN030; ea_namelen
		DW	2			;AN030; ea_valuelen
		DB	"CP"                    ;AN030; ea_name
xa_list_attr	DW	0			;AC030; code page
xa_cp_length	DW	$-XA_cp_out		;AN030; length of buffer



arg_buf: times 128 db 0
file_size_low: dw 0;AC000;
file_size_high: dw 0;AC000;
string_ptr_2: dw 0
;AD061;string_ptr_2_sb dw      ?
copy_Num: dw 0
cpyflag: db 0
Dir_Num: dw 0
bytes_free: dw 0
		dw 0
major_ver_num: dw 0
minor_ver_num: dw 0
one_char_val	db	?,0
vol_drv: db 0

%if IBM
ROM_CALL: db 0; flag for rom function
ROM_IP: dw 0
ROM_CS: dw 0
%endif

DESTVARS:
DESTISDIR: db 0
DESTSIZ: db 0
DESTTAIL: dw 0
DESTINFO: db 0
DESTBUF 	DB	DIRSTRLEN + times 20 db 0

DESTHAND: dw 0
DESTISDEV: db 0
FIRSTDEST: db 0
MELCOPY: db 0
MELSTART: dw 0

SRCVARS:
SRCISDIR: db 0
SRCSIZ: db 0
SRCTAIL: dw 0
SRCINFO: db 0
SRCBUF		DB	DIRSTRLEN + times 20 db 0

SRCHAND: dw 0
SRCISDEV: db 0

SCANBUF 	DB	DIRSTRLEN + times 20 db 0

SRCPT: dw 0
INEXACT: db 0
NOWRITE: db 0
BINARY: db 0
WRITTEN: dw 0
TERMREAD: db 0
ASCII: db 0
PLUS: db 0
objcnt: db 0; Used in copy
CPDATE: dw 0
CPTIME: dw 0
BATHAND: dw 0; Batch handle
STARTEL: dw 0
ELCNT: db 0
ELPOS: db 0
SKPDEL: db 0
SOURCE: times 11 db 0

ext_entered	db	0			;AN005;

display_ioctl	db	0			;AN000; info level
		db	0			;AN000; reserved
		dw	crt_ioctl_ln		;AN000; length of data
		dw 0;AN000; control flags
display_mode: db 0;AN000; display mode, colors
		db	0			;AN000; reserved
		dw 0;AN023; colors
		dw 0;AN000; display width (PELS)
		dw 0;AN000; display length (PELS)
display_width: dw 0;AN000; display width
linperpag	dw	linesperpage		;AN000; display length (default to linesperpage)

vol_ioctl_buf:;AN000; buffer for ioctl volume label/serial call
		dw	0			;AN000; info level
vol_serial	dd	0			;AN000; volume serial number
vol_label: times 11 db " ";AN000; volume label - init to blanks
		times 8 db " ";AN000; file system type

expand_star: db 0
comspec_flag: db 0
msg_flag: db 0;AN022; flag set if non-utility message issued
msg_numb	dw	0			;AN022; set with extended error message issued
append_exec	db	0			;AN041; set if internal append executed
print_err_flag	dw	0			;AN000; flag set if error during sysdispmsg
subst_buffer	db	parm_block_size*times 2 db 0;AN061;

;;;;	IF	KANJI		3/3/KK
KPARSE: db 0
;;;;	ENDIF			3/3/KK

; Data declarations taken out of parse.asm

arg	arg_unit	<>			; pointers, arg count, string buffer
argbufptr: dw 0; index for argv[].argpointer
tpbuf: times 128 db 0; temporary buffer
LAST_ARG: dw 0; point at which to accumulate switch info
comptr: dw 0; ptr into combuf

; Data declarations taken out of path.asm
fbuf	find_buf	<>			; dma buffer for findfirst/findnext
pathinfo: times 3 dw 0; ES, SI(old), and SI(new) of user path
psep_char: db 0; '/' or '\'
search_best	DB	(?)			; best code, best filename so far
fname_max_len	equ	13
search_best_buf DB	fname_max_len DUP (?)
search_curdir_buf: times 64 db 0; a place for CurDir info, if successful
search_error	DW	(?)			; address of error message to be printed

; Data declarations taken out of tbatch.asm
if_not_count: dw 0

zflag: db 0; Used by typefil to indicate ^Z's

		DW	80H DUP(0)		; Init to 0 to make sure the linker is not fooled
STACK:

INTERNATVARS	internat_block <>
		DB	(internat_block_max - ($ - INTERNATVARS)) DUP (?)

BatBufPos: dw 0; integer position in buffer of next byte
BatBuf		DB	BatLen DUP (?)
BatBufEnd: dw 0

; *****************************************************
; EMG 4.00
; DATA STARTING HERE WAS ADDED BY EMG FOR 4.00
; FOR IMPLEMENTATION OF COMMON PARSE ROUTINE
; *****************************************************
;
; COMMON PARSE OUTPUT BLOCKS
;


;
; Common output blocks for PARSE number, complex, or string values.
;

PARSE1_OUTPUT:;AN000;
PARSE1_TYPE	DB	0			;AN000;  type
PARSE1_CODE	DB	0			;AN000;  return value
PARSE1_SYN	DW	0			;AN000;  es offset of synonym
PARSE1_ADDR	DD	0			;AN000;  numeric value / address
						;	 of string value

;
;  Common output block for PARSE date strings.
;

DATE_OUTPUT:;AN000;
DATE_TYPE	DB	0			;AN000;  type
		DB	0			;AN000;  return value
		DW	0			;AN000;  es offset of synonym
DATE_YEAR	DW	0			;AN000;  year
DATE_MONTH	DB	0			;AN000;  month
DATE_DAY	DB	0			;AN000;  day

;
;  Common output block for PARSE time strings.
;

TIME_OUTPUT:;AN000;
TIME_TYPE	DB	0			;AN000;  type
		DB	0			;AN000;  return value
		DW	0			;AN000;  es offset of synonym
TIME_HOUR	DB	0			;AN000;  hour
TIME_MINUTES	DB	0			;AN000;  minutes
TIME_SECONDS	DB	0			;AN000;  seconds
TIME_FRACTION	DB	0			;AN000;  hundredths

;
;  Common output block for PARSE drive specifier (one based drive number).
;

DRIVE_OUTPUT:;AN000;
DRIVE_TYPE	DB	0			;AN000;  type
DRIVE_VALUE	DB	0			;AN000;  return value
		DW	0			;AN000;  es offset of synonym
DRIVE_NUMBER	DB	0			;AN000;  drive number
		DB	0,0,0			;AN000;  reserved

TRANSPACEEND:

; END SECTION .TRANSPACE
	; END
