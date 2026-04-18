 ; page 80,132
;	SCCSID = @(#)tdata.asm	4.3 85/05/17
;	SCCSID = @(#)tdata.asm	4.3 85/05/17
; TITLE	COMMAND Transient Initialized DATA

; MODIFICATION HISTORY
;
;	EE 10-20-83	Changed the drive check indicator bytes (DCIB's) in
;			COMTAB to be a flag byte in which bit 0 is now the
;			DCIB(bit) and bit 1 is on if the command can take
;			switches.

%macro fmt 3
	; LOCAL a
a	db  string
global name
; name	dw  offset trangroup:a
; irp val,<args>
	dw  val
%endmacro
%endmacro

%macro btab 2
    db	b
    dw	    sym
    %endmacro

; .xlist
; .xcref
	%include "comsw.asm";AC000;
	%include "comseg.asm"
	%include "EA.inc";AN030;
	%include "dirent.inc";AN042;
; .list
; .cref

%macro BREAK 1
	; SUBTTL	subtitle
	; PAGE
%endmacro

;
; WARNING: DO NOT INCLUDE DOSSYM.INC BECAUSE IT DESTROYS THE MACRO 'FMT' THAT
; has been defined above - RS.
;
	%include "CURDIR.INC"
	%include "ERROR.INC"
	%include "ifequ.asm"
	%include "comequ.asm"

SECTION .TRANSPACE;AC000;
	extern arg_buf
	extern bwdbuf
	extern bytes_free
	extern charbuf
	extern copy_Num
	extern cpyflag
	extern DATE_OUTPUT;AC000;
	extern Dir_Num
	extern DRIVE_OUTPUT;AC000;
	extern file_size_high
	extern file_size_low
	extern major_ver_num
	extern minor_ver_num
	extern one_char_val
	extern PARSE1_OUTPUT;AC000;
	extern srcbuf
	extern string_ptr_2
	extern system_cpage
	extern TIME_OUTPUT;AC000;
	extern vol_drv
	extern vol_serial;AN000;
; END SECTION .TRANSPACE

SECTION .TRANCODE;AC000;
	extern $CALL
	extern $CHDIR
	extern $EXIT
	extern $FOR
	extern $IF
	extern $MKDIR
	extern $RMDIR
	extern ADD_NAME_TO_ENVIRONMENT
	extern ADD_PROMPT
	extern build_dir_for_prompt
	extern CATALOG
	extern CHCP
	extern CLS
	extern CNTRLC
	extern COPY
	extern CRENAME
	extern CRLF2
	extern CTIME
	extern CTTY
	extern DATE
	extern ECHO
	extern ERASE
	extern GOTO
	extern IFERLEV
	extern IFEXISTS
	extern IFNOT
	extern PATH
	extern PAUSE
	extern PRINT_B
	extern PRINT_BACK
	extern PRINT_DATE
	extern PRINT_CHAR
	extern PRINT_DRIVE
	extern PRINT_EQ
	extern PRINT_ESC
	extern PRINT_G
	extern PRINT_L
	extern PRINT_TIME
	extern PRINT_VERSION
	extern SHIFT
	extern TCOMMAND
	extern TRUENAME;AN000;
	extern TYPEFIL
	extern VERSION
	extern VOLUME
	extern VERIFY
;
; WARNING!!! No code may appear after this label!!!!
;
global TranCodeLast
TranCodeLast:
; END SECTION .TRANCODE

; Data for transient portion

SECTION .TRANDATA

	global accden_ptr;AN000;
	global acrlf_ptr;AN000;
	global arg_buf_ptr;AN000;
	global badbat_ptr;AN000;
	global badcd_ptr;AN000;
	global badCPmes_ptr;AN000;
	global badcurdrv;AN000;
	global baddat_ptr;AN000;
	global baddev_ptr;AN000;
	global baddrv_ptr;AN000;
	global badlab_ptr;AN000;
	global badmkd_ptr;AN000;
	global badnam_ptr;AN000;
	global bad_on_off_ptr;AN000;
	global badPmes_ptr;AN000;
	global badrmd_ptr;AN000;
	global badtim_ptr;AN000;
	global batext
	global bytmes_ptr;AN000;
	global CLSSTRING
	global comext
	global COMSPECSTR
	global COMTAB
	global copied_ptr;AN000;
	global cp_active_ptr;AN000;
	global cp_not_all_ptr;AN000;
	global cp_not_set_ptr;AN000;
	global ctrlcmes_ptr;AN000;
	global curdat_mo_day;AN000;
	global curdat_ptr;AN000;
	global curdat_yr;AN000;
	global curtim_hr_min;AN000;
	global curtim_ptr;AN000;
	global curtim_sec_hn;AN000;
	global dback_ptr;AN000;
	global del_Y_N_ptr;AN000;
	global devwmes_ptr;AN000;
	global dirdattim_ptr;AN000;
	global dirdat_mo_day;AN000;
	global dirdat_yr;AN000;
	global dirhead_ptr;AN000;
	global dirmes_ptr;AN000;
	global dirtim_hr_min;AN000;
	global dirtim_sec_hn;AN000;
	global DIR_W_SYN;AN000;
	global disp_file_size_ptr;AN000;
	global dmes_ptr;AN000;
	global echomes_ptr;AN000;
	global enverr_ptr;AN000;
	global eurdat_ptr;AN000;
	global exeext
	global extend_buf_off;AN000;
	global extend_buf_ptr;AN000;
	global extend_buf_seg;AN000;
	global extend_buf_sub;AN000;
	global file_name_ptr;AN000;
	global fornestmes_ptr;AN000;
	global fuldir_ptr;AN000;
	global IFTAB
	global inBdev_ptr;AN000;
	global inornot_ptr;AN000;
	global Inv_code_page;AN000;
	global inval_path_ptr;AN000;
	global japdat_ptr;AN000;
	global Losterr_ptr;AN000;
	global md_exists_ptr;AN006;
	global msg_cont_flag;AN000;
	global msg_disp_class;AN000;
	global needbat_ptr;AN000;
	global newdat_format;AN000;
	global newdat_ptr;AN000;
	global newtim_ptr;AN000;
	global NLSFUNC_ptr;AN000;
	global nospace_ptr;AN000;
	global no_values;AN000;
	global nulpath_ptr;AN000;
	global offmes_ptr;AN000;
	global onmes_ptr;AN000;
	global overwr_ptr;AN000;
	global PARSE_BREAK;AN000;
	global PARSE_CHCP;AN000;
	global PARSE_CHDIR;AN000;
	global PARSE_CTTY;AN000;
	global PARSE_DATE;AN000;
	global PARSE_DIR;AN000;
	global PARSE_ERASE;AN000;
	global PARSE_MRDIR;AN000;
	global PARSE_RENAME;AN000;
	global PARSE_TIME;AN000;
	global PARSE_VOL;AN000;
	global PATH_TEXT
	global pausemes_ptr;AN000;
	global pipeEmes_ptr;AN000;
	global promptdat_moday;AN000;
	global promptdat_ptr;AN000;
	global promptdat_yr;AN000;
	global PROMPT_TABLE
	global PROMPT_TEXT
	global promtim_hr_min;AN000;
	global promtim_ptr;AN000;
	global promtim_sec_hn;AN000;
	global renerr_ptr;AN000;
	global SLASH_P_SYN;AN000;
	global string_buf_ptr;AN000;
	global suremes_ptr;AN000;
	global switch_list
	global syntmes_ptr;AN000;
	global tab_ptr;AN000;
	global TRANDATAEND
	global usadat_ptr;AN000;
	global verimes_ptr;AN000;
	global vermes_ptr;AN000;
	global volmes_ptr;AN000;
	global volmes_ptr_2;AN000;
	global volsermes_ptr;AN000;
	global WEEKTAB
	global xa_cp;AN030;

%include "tranmsg.asm"

CLSSTRING DB	4,01BH,"[2J"            ; ANSI Clear screen

PROMPT_TABLE:
	btab	"B",Print_B
	btab	"D",PRINT_DATE
	btab	"E",PRINT_ESC
	btab	"G",PRINT_G
	btab	"H",PRINT_BACK
	btab	"L",PRINT_L
	btab	"N",PRINT_DRIVE
	btab	"P",build_dir_for_prompt
	btab	"Q",PRINT_EQ
	btab	"T",PRINT_TIME
	btab	"V",PRINT_VERSION
	btab	"_",CRLF2
	btab	"$",PRINT_CHAR
	DB	0				; NUL TERMINATED

IFTAB:; Table of IF conditionals
	DB	3,"NOT"                         ; First byte is count
	DW	IFNOT
	DB	10,"ERRORLEVEL"
	DW	IFERLEV
	DB	5,"EXIST"
	DW	IFEXISTS
	DB	0

; Table for internal command names
COMTAB	DB	3,"DIR",fSwitchAllowed+fCheckDrive
	DW	CATALOG	; In TCMD1.ASM
	DB	4,"CALL",fSwitchAllowed
	DW	$CALL		; In TBATCH2.ASM
	DB	4,"CHCP",fSwitchAllowed
	DW	CHCP		; In TCMD2B.ASM
	DB	6,"RENAME",fSwitchAllowed+fCheckDrive  ;AC018; P3903
	DW	CRENAME	; In TCMD1.ASM
	DB	3,"REN",fSwitchAllowed+fCheckDrive     ;AC018; P3903
	DW	CRENAME	; In TCMD1.ASM
	DB	5,"ERASE",fSwitchAllowed+fCheckDrive
	DW	ERASE		; In TCMD1.ASM
	DB	3,"DEL",fSwitchAllowed+fCheckDrive
	DW	ERASE		; In TCMD1.ASM
	DB	4,"TYPE",fSwitchAllowed+fCheckDrive  ;AC018; P3903
	DW	TYPEFIL	; In TCMD1.ASM
	DB	3,"REM",fSwitchAllowed
	DW	TCOMMAND	; In TCODE.ASM
	DB	4,"COPY",fSwitchAllowed+fCheckDrive
	DW	COPY		; In COPY.ASM
	DB	5,"PAUSE",fSwitchAllowed
	DW	PAUSE		; In TCMD1.ASM
	DB	4,"DATE",fSwitchAllowed
	DW	DATE		; In TPIPE.ASM
	DB	4,"TIME",fSwitchAllowed         ;AC018; P3903
	DW	CTIME		; In TPIPE.ASM
	DB	3,"VER",0
	DW	VERSION	; In TCMD2.ASM
	DB	3,"VOL",fSwitchAllowed+fCheckDrive   ;AC018; P3903
	DW	VOLUME 	; In TCMD1.ASM
	DB	2,"CD",fSwitchAllowed+fCheckDrive    ;AC018; P3903
	DW	$CHDIR 	; In TENV.ASM
	DB	5,"CHDIR",fSwitchAllowed+fCheckDrive ;AC018; P3903
	DW	$CHDIR 	; In TENV.ASM
	DB	2,"MD",fSwitchAllowed+fCheckDrive    ;AC018; P3903
	DW	$MKDIR 	; In TENV.ASM
	DB	5,"MKDIR",fSwitchAllowed+fCheckDrive ;AC018; P3903
	DW	$MKDIR 	; In TENV.ASM
	DB	2,"RD",fSwitchAllowed+fCheckDrive    ;AC018; P3903
	DW	$RMDIR 	; In TENV.ASM
	DB	5,"RMDIR",fSwitchAllowed+fCheckDrive ;AC018; P3903
	DW	$RMDIR 	; In TENV.ASM
	DB	5,"BREAK",fSwitchAllowed        ;AC018; P3903
	DW	CNTRLC 	; In TUCODE.ASM
	DB	6,"VERIFY",fSwitchAllowed       ;AC018; P3903
	DW	VERIFY 	; In TUCODE.ASM
	DB	3,"SET",fSwitchAllowed
	DW	ADD_NAME_TO_ENVIRONMENT; In TENV.ASM
	DB	6,"PROMPT",fSwitchAllowed
	DW	ADD_PROMPT	; In TENV.ASM
	DB	4,"PATH",fSwitchAllowed
	DW	PATH		; In TCMD2.ASM
	DB	4,"EXIT",0
	DW	$EXIT		; In TCMD2.ASM
	DB	4,"CTTY",fCheckDrive+fSwitchAllowed
	DW	CTTY		; In TCMD2.ASM
	DB	4,"ECHO",fSwitchAllowed
	DW	ECHO		; In TUCODE.ASM
	DB	4,"GOTO",fSwitchAllowed
	DW	GOTO		; In TBATCH.ASM
	DB	5,"SHIFT",fSwitchAllowed
	DW	SHIFT		; In TBATCH.ASM
	DB	2,"IF",fSwitchAllowed
	DW	$IF		; In TBATCH.ASM
	DB	3,"FOR",fSwitchAllowed
	DW	$FOR		; In TBATCH.ASM
	DB	3,"CLS",0
	DW	CLS		; In TCMD2.ASM
	DB	8,"TRUENAME",fSwitchAllowed+fCheckDrive  ;AN000; P3903 changed
	DW	TRUENAME	;AN000;
	DB	0				; Terminate command table


comext	dB	".COM"
exeext	dB	".EXE"
batext	dB	".BAT"

switch_list	DB	"VBAPW"                 ; flags we can recognize


XA_cp:;AN030; list for one extended attribute
	DW	  1				;AN030;
	DB	  EAISBINARY			;AN030; type
	DW	  EASYSTEM			;AN030; flags
	DB	  2				;AN030; name length
	DB	  "CP"                          ;AN030; name




global BatBufLen
BatBufLen   DW	BatLen

; *****************************************************
; EMG 4.00
; DATA STARTING HERE WAS ADDED BY EMG FOR 4.00
; FOR IMPLEMENTATION OF COMMON PARSE ROUTINE
; *****************************************************

;
; COMMON PARSE BLOCKS
;

;
; Indicates no value list for PARSE.
;

NO_VALUES	DW	0			;AN000;  no values

;
; PARSE control block for a required file specification (upper cased)
;

FILE_REQUIRED:;AN000;
		DW	0200H			;AN000;  filespec - required
		DW	1			;AN000;  capitalize - file table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords

;
; PARSE control block for an optional file specification (upper cased)
; or drive number
;

FILE_OPTIONAL:;AN000;
		DW	0301H			;AN000;  filespec or drive number
						;	 optional
		DW	1			;AN000;  capitalize - file table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords

;
; PARSE control block for an optional file specification (upper cased)
;

FILE_OPTIONAL2:;AN000;
		DW	0201H			;AN000;  filespec or drive number
						;	 optional
		DW	1			;AN000;  capitalize - file table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords

;
; PARSE control block for an optional /P switch
;

SLASH_P_SWITCH:;AN000;
		DW	0			;AN000;  no match flags
		DW	2			;AN000;  capitalize - char table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	1			;AN000;  1 keyword
SLASH_P_SYN	DB	"/P",0                  ;AN000;  /P switch



; PARSE BLOCK FOR BREAK, VERIFY, ECHO

;
; The following parse control block can be used for any command which
; needs only the optional "ON" and "OFF" keywords as operands.  Allows
; the equal sign as an additional delimiter.  Returns verified result
; in PARSE1_OUTPUT.  Currently used for the BREAK, VERIFY, and	ECHO
; internal commands.
;

PARSE_BREAK:;AN000;
		DW	BREAK_PARMS	;AN000;
		DB	0			;AN032; no extra delimiter

BREAK_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	BREAK_CONTROL1;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

BREAK_CONTROL1:;AN000;
		DW	2001H			;AN000;  string value - optional
		DW	2			;AN000;  capitalize - char table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	BREAK_VALUES	;AN000;
		DB	0			;AN000;  no keywords

BREAK_VALUES:;AN000;
		DB	3			;AN000;
		DB	0			;AN000;  no ranges
		DB	0			;AN000;  no numeric values
		DB	2			;AN000;  2 string values
		DB	0			;AN000;  returned if ON
		DW	BREAK_ON	;AN000;  point to ON string
		DB	'f'                     ;AN000;  returned if OFF
		DW	BREAK_OFF	;AN000;  point to OFF string

BREAK_ON	DB	"ON",0                  ;AN000;
BREAK_OFF	DB	"OFF",0                 ;AN000;

;
; PARSE BLOCK FOR CHCP
;

;
; The following parse control block can be used for any command which
; needs only one optional three digit decimal parameter for operands.
; Returns verified result in PARSE1_OUTPUT.  Currently used for the
; CHCP internal command.
;
CHCP_MINVAL	EQU	100			;AN000;
CHCP_MAXVAL	EQU	999			;AN000;

PARSE_CHCP:;AN000;
		DW	CHCP_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

CHCP_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	CHCP_CONTROL1 ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

CHCP_CONTROL1:;AN000;
		DW	8001H			;AN000;  numeric value - optional
		DW	0			;AN000;  no function flags
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	CHCP_VALUES	;AN000;
		DB	0			;AN000;  no keywords

CHCP_VALUES:;AN000;
		DB	1			;AN000;
		DB	1			;AN000;  1 range
		DB	1			;AN000;  returned if result
		DD	CHCP_MINVAL,CHCP_MAXVAL ;AN000;  minimum & maximum value
		DB	0			;AN000;  no numeric values
		DB	0			;AN000;  no string values


;
; PARSE BLOCK FOR DATE
;

;
; The following parse control block can be used for any command which
; needs only an optional date string as an operand.  Returns unverified
; result in DATE_OUTPUT.  Currently used for the DATE internal command.
;

PARSE_DATE:;AN000;
		DW	DATE_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

DATE_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	DATE_CONTROL1 ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

DATE_CONTROL1:;AN000;
		DW	1001H			;AN000;  date - optional
		DW	0			;AN000;  no function flags
		DW	DATE_OUTPUT	;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords

;
; PARSE BLOCK FOR TIME
;

;
; The following parse control block can be used for any command which
; needs only an optional time string as an operand.  Returns unverified
; result in TIME_OUTPUT.  Currently used for the TIME internal command.
;

PARSE_TIME:;AN000;
		DW	TIME_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

TIME_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	TIME_CONTROL1 ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

TIME_CONTROL1:;AN000;
		DW	0801H			;AN000;  TIME - optional
		DW	0			;AN000;  no function flags
		DW	TIME_OUTPUT	;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords


;
; PARSE BLOCK FOR VOL
;

;
; The following parse control block can be used for any command which
; needs only an optional drive letter as an operand.  Returns unverified
; drive number (one based) in DRIVE_OUTPUT.  Currently used for the VOL
; internal command.
;

PARSE_VOL:;AN000;
		DW	VOL_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

VOL_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	DRIVE_CONTROL1;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

DRIVE_CONTROL1:;AN000;
		DW	0101H			;AN000;  DRIVE - optional
		DW	1			;AN000;  capitalize - file table
		DW	DRIVE_OUTPUT	;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords


;
; PARSE BLOCK FOR MKDIR, RMDIR, TYPE
;

;
; The following parse control block can be used for any command which
; needs only one required file specification as an operand.  Returns a
; pointer to the unverified string in PARSE1_OUTPUT.  Currently used
; for the MKDIR, RMDIR, and TYPE internal commands.
;

PARSE_MRDIR:;AN000;
		DW	MRDIR_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

MRDIR_PARMS:;AN000;
		DB	1,1			;AN000;  1 positional parm
		DW	FILE_REQUIRED ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

;
; PARSE BLOCK FOR CHDIR, TRUENAME
;

;
; The following parse control block can be used for any command which
; needs only one optional file specification an operand.  Returns a
; pointer to the unverified string in PARSE1_OUTPUT.  Currently used
; for the CHDIR and TRUENAME internal commands.
;

PARSE_CHDIR:;AN000;
		DW	CHDIR_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

CHDIR_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	FILE_OPTIONAL ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

;
; PARSE BLOCK FOR ERASE
;

;
; The following parse control block is used for the DEL/ERASE internal
; commands.  This command has one required file specification and an
; optional switch (/p) as operands. The verified switch or unverified
; file specification is returned in PARSE1_OUTPUT.
;

PARSE_ERASE:;AN000;
		DW	ERASE_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

ERASE_PARMS:;AN000;
		DB	1,1			;AN000;  1 positional parm
		DW	FILE_REQUIRED ;AN000;
		DB	1			;AN000;  1 switch
		DW	SLASH_P_SWITCH;AN000;
		DB	0			;AN000;  no keywords

;
; PARSE BLOCK FOR DIR
;

;
; The following parse control block is used for the DIR internal command.
; This command has one optional file specification and two optional
; switches (/p and /w) as operands.  The verified switch or unverified
; file specification is returned in PARSE1_OUTPUT.
;

PARSE_DIR:;AN000;
		DW	DIR_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

DIR_PARMS:;AN000;
		DB	0,1			;AN000;  1 positional parm
		DW	FILE_OPTIONAL2;AN000;
		DB	2			;AN000;  2 switches
		DW	SLASH_P_SWITCH;AN000;
		DW	DIR_SWITCH1	;AN000;
		DB	0			;AN000;  no keywords

DIR_SWITCH1:;AN000;
		DW	0			;AN000;  no match flags
		DW	2			;AN000;  capitalize by char table
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	1			;AN000;  1 keyword
DIR_W_SYN	DB	"/W",0                  ;AN000;  /W switch

;
; PARSE BLOCK FOR RENAME
;

;
; The following parse control block can be used for any command which
; needs only two required file specifications as operands.  Returns
; pointers to the unverified string in PARSE1_OUTPUT.
; Currently used for the RENAME internal command.
;

PARSE_RENAME:;AN000;
		DW	RENAME_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

RENAME_PARMS:;AN000;
		DB	2,2			;AN000;  2 positional parms
		DW	FILE_REQUIRED ;AN000;
		DW	FILE_REQUIRED ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

;
; PARSE BLOCK FOR CTTY
;

;
; The following parse control block can be used for any command which
; needs one required device name as an operand.  Returns a pointer to
; unverified string in PARSE1_OUTPUT. Currently used for the CTTY
; internal command.
;

PARSE_CTTY:;AN000;
		DW	CTTY_PARMS	;AN000;
		DB	0			;AN000;  no extra delimiter

CTTY_PARMS:;AN000;
		DB	1,1			;AN000;  1 positional parm
		DW	CTTY_CONTROL1 ;AN000;
		DB	0			;AN000;  no switches
		DB	0			;AN000;  no keywords

CTTY_CONTROL1:;AN000;
		DW	2000H			;AN000;  string value - required
		DW	11H			;AN000;  capitalize - file table
						;AN000;  remove colon at end
		DW	PARSE1_OUTPUT ;AN000;  result buffer
		DW	NO_VALUES	;AN000;
		DB	0			;AN000;  no keywords

; END SECTION .TRANDATA

SECTION .TRANCODE;AN000;

; .xlist
; .xcref

%include "SYSMSG.INC";AN000;

; .list
; .cref

; ASSUME DS:TRANGROUP,ES:TRANGROUP,CS:TRANGROUP

MSG_UTILNAME <COMMAND>				;AN000; define utility name

MSG_SERVICES <COMT,COMMAND.CLF,COMMAND.CL1,COMMAND.CL2> ;AN000; The transient messages

%include "msgdcl.inc"

; END SECTION .TRANCODE;AN000;

SECTION .TRANDATA

TRANDATAEND:

; END SECTION .TRANDATA;AN000;

	; END
