 ; page 80,132
;	SCCSID = @(#)tenv2.asm	1.1 85/05/14
;	SCCSID = @(#)tenv2.asm	1.1 85/05/14
; TITLE	Part6 COMMAND Transient routines.

;	Environment utilities and misc. routines

	%include "comsw.asm"

; .xlist
; .xcref
	%include "DOSSYM.INC"
	%include "comseg.asm"
	%include "comequ.asm"
; .list
; .cref


SECTION .DATARES;AC000;
	extern pipeflag
; END SECTION .DATARES

SECTION .TRANDATA;AC000;
	extern ACRLF_PTR
	extern BadCD_Ptr
	extern Badmkd_ptr
	extern BADRMD_PTR
	extern Extend_buf_ptr;AN000;
	extern Extend_buf_sub;AN022;
	extern MD_exists_ptr;AN006;
	extern msg_disp_class;AC000;
	extern NOSPACE_PTR
	extern parse_chdir;AC000;
	extern parse_mrdir;AC000;
	extern PIPEEMES_PTR
	extern string_buf_ptr
; END SECTION .TRANDATA

SECTION .TRANSPACE;AC000;
	extern CURDRV
	extern DESTINFO
	extern DESTTAIL
	extern DIRCHAR
	extern dirflag;AN015;
	extern KPARSE;AC000;  3/3/KK
	extern msg_numb;AN022;
	extern parse1_addr;AC000;
	extern parse1_type;AC000;
	extern PATHPOS
	extern RESSEG
	extern srcxname;AC000;
	extern string_ptr_2
	extern SWITCHAR
	extern USERDIR1
; END SECTION .TRANSPACE

SECTION .TRANCODE

; ASSUME	CS:TRANGROUP,DS:NOTHING,ES:NOTHING,SS:NOTHING

	extern cerror

	global $chdir
	global $mkdir
	global $rmdir
	global crlf2
	global crprint
	global delim
	global error_output
	global fcb_to_ascz
	global pathchrcmp
	global pathcrunch
	global savudir
	global savudir1
	global scanoff
	global strcomp

break	$Chdir

; ****************************************************************
; *
; * ROUTINE:	 $CHDIR
; *
; * FUNCTION:	 Entry point for CHDIR command. Parse the command
; *		 line. If path is found, CHDIR to path. If a drive
; *		 letter is found, get and display the current dir
; *		 of the specified drive. If nothing is found, get
; *		 and display the current dir of the default drive.
; *
; * INPUT:	 command line at offset 81H
; *
; * OUTPUT:	 none
; *
; ****************************************************************

; assume	ds:trangroup,es:trangroup

$CHDIR:

	mov	si,81H
	mov	di,parse_chdir ;AN000; Get adderss of PARSE_CHDIR
	xor	cx,cx				;AN000; clear cx,dx
	xor	dx,dx				;AN000;
	invoke	parse_with_msg			;AC018; call parser

	cmp	ax,end_of_line			;AC000; are we at end of line?
	jz	bwdJ				; No args
	cmp	ax,result_no_error		;AC000; did we have an error?
	jnz	ChDirErr			;AC018; yes - exit

	cmp	parse1_type,result_drive	;AC000; was a drive entered?
	jnz	REALCD				; no
;
; D: was found.  See if there is anything more.
;
	mov	di,parse_chdir ;AC000; get address of parse_chdir
	xor	dx,dx				;AC000;
	invoke	parse_check_eol 		;AC000; call parser
	jnz	ChDirErr			;AC000;

bwdJ:
	invoke	build_dir_for_chdir		; Drive only specified
	call	crlf2
	return

REALCD:

	push	si				;AN000; save position in line
	lds	si,parse1_addr			;AN000; get address of filespec
	invoke	move_to_srcbuf			;AN000; move to srcbuf
	pop	si				;AN000; restore position in line
	mov	di,parse_chdir ;AC000; get address of parse_chdir
	xor	dx,dx				;AC000;
	invoke	parse_check_eol 		;AC000; call parser
	jnz	ChDirErr			;AC000;

	invoke	SETPATH
	TEST	[DESTINFO],2
	JNZ	BadChdir
	MOV	AH,CHDIR
	INT	int_command
	retnc

	invoke	get_ext_error_number		;AN022; get the extended error
	cmp	ax,error_path_not_found 	;AN022; see if path not found
	jz	BadChDir			;AN022; yes - issue old message
	call	Set_Ext_Error_Subst		;AN022;
	jmp	short  chdirerr 		;AN022;

BadChDir:
	MOV	DX,BADCD_ptr

ChDirErr:
	invoke	Std_Eprintf
	return

break	$Mkdir

; assume	ds:trangroup,es:trangroup

$MKDIR:
	CALL	SETRMMK
	JC	MkDirErr
	MOV	AH,MKDIR
	INT	int_command
	retnc

	invoke	get_ext_error_number		;AN022; get the extended error
	cmp	ax,error_path_not_found 	;AN022; see if path not found
	jz	MD_other_err			;AN022; yes - issue old message
	cmp	ax,error_access_denied		;AN022; access denied?
	jz	badmderr			;AN022; yes - see if file exists

	call	Set_Ext_Error_Subst		;AN022;
	jmp	short MkDirerr			;AC022; yes - go print it

BADMDERR:
	mov	dx,srcxname	;AN006; Set Disk transfer address
	mov	ah,Set_DMA			;AN006;
	int	int_command			;AN006;
	MOV	AH,Find_First			;AN006; see if file/dir exists
	mov	cx,attr_directory		;AN006;   search for directory
	INT	int_command			;AN006;
	jc	MD_other_err			;AN006; doesn't exist - must be something else
	mov	dl,srcxname.find_buf_attr	;AN006; we found a file/dir
	test	dl,attr_directory		;AN006; was it a directory?
	jz	MD_other_err			;AN006; no - must have been a file
	mov	dx,MD_exists_ptr ;AN006; set up already exists error
	jmp	short MkDirErr			;AN006; make sure we didn't have network error
MD_other_err:					;AN006;
	MOV	DX,BADMKD_ptr
MkDirErr:
	invoke	Std_Eprintf
	return

Break	<Common MkDir/RmDir set up code>

;****************************************************************
;*
;* ROUTINE:	SETRMMK
;*
;* FUNCTION:	Parse routine for the internal MKDIR and RMDIR
;*		commands. Parses the command line for a required
;*		filespec.
;*
;* INPUT:	command line at offset 81H
;*
;* OUTPUT:	carry clear
;*		    DS:DX points to ASCIIZ argument
;*		carry set
;*		    DS:DX has error message pointer
;*
;****************************************************************

SETRMMK:
	mov	si,81H
	mov	di,parse_mrdir ;AN000; Get adderss of PARSE_MRDIR
	xor	cx,cx				;AN000; clear cx,dx
	xor	dx,dx				;AN000;
	invoke	parse_with_msg			;AC000; call parser
	cmp	ax,result_no_error		;AC000; did we have an error?
	jnz	 NOARGERR			;AC000; yes - exit

	mov	di,srcxname	;AN000; get address of srcxname
	push	di				;AN000; save address
	push	si				;AN000; save position in line
	lds	si,parse1_addr			;AN000; get address of path

mrdir_move_filename:				;AN000; put filespec in srcxname
	lodsb					;get a char from buffer
	stosb					;AN000; store in srcxname
	cmp	al,end_of_line_out		;AC000; it char a terminator?
	jnz	mrdir_move_filename		;AC000; no - keep moving
	pop	si				;AN000; get line position back

;
; we have scanned an argument.	See if any args beyond.
;

	mov	di,parse_mrdir ;AC000; get address of parse_mrdir
	invoke	parse_check_eol 		;AC000; are we at end of line?
	pop	dx				;AC000; get address of SRCXNAME
	retz					;yes - return no error
NOARGERR:
	mov	dx,Extend_Buf_ptr  ;AC000; get extended message pointer
	XOR	AX,AX
	STC
	return

break	$Rmdir

; assume	ds:trangroup,es:trangroup

$RMDIR:
	CALL	SETRMMK
	JC	RmDirErr
	JNZ	BADRDERR
	MOV	AH,RMDIR
	INT	int_command
	retnc

	invoke	get_ext_error_number		;AN022; get the extended error
	cmp	ax,error_path_not_found 	;AN022; see if path not found
	jz	badrderr			;AN022; yes - issue old message
	cmp	ax,error_access_denied		;AN022; access denied?
	jz	badrderr			;AN022; yes - issue old message

	call	Set_Ext_Error_Subst		;AN022;
	jmp	short RmDirerr			;AC022; yes - go print it

BADRDERR:
	MOV	DX,BADRMD_ptr

RmDirErr:
	invoke	STD_Eprintf
	return

;****************************************************************
;*
;* ROUTINE:	Set_ext_error_subst
;*
;* FUNCTION:	Sets up substitution for extended error
;*
;* INPUT:	AX - extended error number
;*		DX - offset of string
;*
;* OUTPUT:	Extend_Buf_Ptr set up for STD_EPRINTF
;*
;****************************************************************

Set_ext_error_subst:;AN022;

	mov	msg_disp_class,ext_msg_class	;AN022; set up extended error msg class
	mov	string_ptr_2,dx 		;AN022; get address of failed string
	mov	Extend_buf_sub,one_subst	;AN022; put number of subst in control block
	mov	dx,Extend_Buf_ptr ;AN022; get extended message pointer
	mov	Extend_Buf_ptr,ax		;AN022; get message number in control block

	ret					;AN022; return

; ENDP Set_ext_error_subst;AN022;





Break	<SavUDir - preserve the users current directory on a particular drive>

;
; SavUDir - move the user's current directory on a drive into UserDir1
; SavUDir1 - move the user's current directory on a drive into a specified
;   buffer
;
;   Inputs:	DL has 1-based drive number
;		ES:DI has destination buffer (SavUDir1 only)
;   Outputs:	Carry Clear
;		    DS = TranGroup
;		Carry Set
;		    AX has error code
;   Registers Modified: AX, SI
;

SAVUDIR:
	MOV	DI,USERDIR1

SAVUDIR1:
	MOV	AL,DL
	ADD	AL,'@'
	CMP	AL,'@'
	JNZ	GOTUDRV
	ADD	AL,[CURDRV]
	INC	AL				; A = 1

GOTUDRV:
	STOSB
	MOV	AH,[DIRCHAR]
	MOV	AL,':'
	STOSW
	PUSH	ES
	POP	DS
; ASSUME	DS:NOTHING

	MOV	SI,DI
	MOV	AH,CURRENT_DIR			; Get the Directory Text
	INT	int_command
	retc
	PUSH	CS
	POP	DS
; ASSUME	DS:TRANGROUP

	return


CRLF2:
	PUSH	DX
	MOV	DX,ACRLF_ptr

PR:
	PUSH	DS
	PUSH	CS
	POP	DS
	invoke	std_printf
	POP	DS
	POP	DX

	return

;
; These routines (SCANOFF, DELIM) are called in batch processing when DS
; may NOT be TRANGROUP
;
; ASSUME	DS:NOTHING,ES:NOTHING

SCANOFF:
	LODSB
	CALL	DELIM
	JZ	SCANOFF
	DEC	SI				; Point to first non-delimiter
	return

;
; Input:    AL is character to classify
; Output:   Z set if delimiter
;	    NZ set otherwise
; Registers modified: none
;

DELIM:
	CMP	AL,' '
	retz
	CMP	AL,'='
	retz
	CMP	AL,','
	retz
	CMP	AL,';'
	retz
	CMP	AL,9				; Check for TAB character
	retz
	CMP	AL,0ah				; Check for line feed character - BAS
	return


; ASSUME	DS:TRANGROUP,ES:TRANGROUP


FCB_TO_ASCZ:					; Convert DS:SI to ASCIZ ES:DI
	MOV	CX,8

MAINNAME:
	LODSB
	CMP	AL,' '
	JZ	SKIPSPC
	STOSB

SKIPSPC:
	LOOP	MAINNAME
	LODSB
	CMP	AL,' '
	JZ	GOTNAME
	MOV	AH,AL
	MOV	AL,dot_chr
	STOSB
	XCHG	AL,AH
	STOSB
	MOV	CL,2

EXTNAME:
	LODSB
	CMP	AL,' '
	JZ	GOTNAME
	STOSB
	LOOP	EXTNAME

GOTNAME:
	XOR	AL,AL
	STOSB
	return

STRCOMP:
;
; Compare ASCIZ DS:SI with ES:DI.
; SI,DI destroyed.
;
	CMPSB
	retnz					; Strings not equal
	cmp	byte [SI-1],0		; Hit NUL terminator?
	retz					; Yes, strings equal
	jmp	short STRCOMP			; Equal so far, keep going


CRPRINT:
	PUSH	AX
	MOV	AL,13
	PUSH	CX
	PUSH	DI
	MOV	DI,DX
	MOV	CX,-1
	PUSH	ES
	PUSH	DS
	POP	ES

	REPNZ	SCASB				; LOOK FOR TERMINATOR
	mov	byte [di-1],0		; nul terminate the string
	POP	ES
	mov	string_ptr_2,dx
	mov	dx,string_buf_ptr
	invoke	std_printf
	mov	ds:byte [di-1],13		; now put the CR back
	JC	ERROR_OUTPUT

	POP	DI
	POP	CX
	POP	AX

	return

ERROR_OUTPUT:
	PUSH	CS
	POP	DS
; ASSUME	DS:TRANGROUP
	MOV	ES,[RESSEG]
; ASSUME	ES:RESGROUP

	MOV	DX,NOSPACE_ptr
	CMP	[PIPEFLAG],0
	JZ	GO_TO_ERROR

	invoke	PipeOff
	MOV	DX,PIPEEMES_ptr
GO_TO_ERROR:
	JMP	CERROR

; ASSUME	DS:TRANGROUP,ES:TRANGROUP

PATHCHRCMP:
;---- Mod for path invocation ----
global pathchrcmp
;----

	push	ax
	mov	ah,'/'
	CMP	[SWITCHAR],ah
	JZ	NOSLASHT
	CMP	AL,'/'
	jz	pccont

NOSLASHT:
	CMP	AL,'\'
pccont:
	pop	ax

	return

; Drive taken from FCB
; User dir saved in userdir1
;
; Zero set if path dir, CHDIR to this dir, FCB filled with ?
; NZ set if path/file, CHDIR to file, FCB has file (parsed fill ' ')
;	[DESTTAIL] points to parse point
; Carry set if no CHDIRs worked, FCB not altered.
; DESTISDIR set non zero if PATHCHRs in path (via SETPATH)
;
PATHCRUNCH:
	mov	[msg_numb],0			;AN022; Set up message flag
	MOV	DL,[DS:FCB]
	CALL	SAVUDIR
	jc	pcrunch_cderrJ			;AN022; if error on current dir - report

	invoke	SETPATH
	TEST	[DESTINFO],2
	JNZ	TRYPEEL 			; If ? or * cannot be pure dir

	MOV	AH,CHDIR
	INT	int_command
	jnc	chdir_worked			;AN022; no error - continue

	invoke	get_ext_error_number		;AN022; get the extended error
	cmp	ax,error_path_not_found 	;AN022; if path not found
	jz	trypeel 			;AC022;     keep trying
	cmp	ax,error_access_denied		;AN022; if access denied
	jz	trypeel 			;AC022;     keep trying
	mov	[msg_numb],ax			;AN022; set up message flag
	jmp	peelfail			;AN022; exit with other error

chdir_worked:
	invoke	SETREST1
	MOV	AL,'?'                          ; *.* is default file spec if pure dir
	MOV	DI,5DH
	MOV	CX,11
	REP	STOSB
	XOR	AL,AL				; Set zero
	return

pcrunch_cderrj: 				;AN022; need this for long jmp
	jmp	pcrunch_cderr			;AN022;

TRYPEEL:
	MOV	SI,[PATHPOS]
	DEC	SI				; Point at NUL
	MOV	AL,[SI-1]

	CMP	[KPARSE],0
	JNZ	DELSTRT 			; Last char is second KANJI byte, might be '\'

	CALL	PATHCHRCMP
	JZ	PEELFAIL			; Trailing '/'

DELSTRT:
	MOV	CX,SI
	MOV	SI,DX
	PUSH	DX
DELLOOP:
	CMP	SI,CX
	JZ	GOTDELE
	LODSB
	invoke	TESTKANJ
	JZ	NOTKANJ8
	INC	SI
	JMP	DELLOOP

NOTKANJ8:
	CALL	PATHCHRCMP
	JNZ	DELLOOP
	MOV	DX,SI
	DEC	DX
	JMP	DELLOOP

GOTDELE:
	MOV	SI,DX
	POP	DX
	CMP	SI,DX
	JZ	BADRET
	MOV	CX,SI
	MOV	SI,DX
DELLOOP2:					; Set value of KPARSE
	CMP	SI,CX
	JZ	TRYCD
	MOV	[KPARSE],0
	LODSB
	INVOKE	TESTKANJ
	JZ	DELLOOP2
	INC	SI
	INC	[KPARSE]
	JMP	DELLOOP2

TRYCD:
	push	ax
	mov	al,dot_chr
	CMP	byte [SI+1],al
	pop	ax
	JZ	PEELFAIL			; If . or .., pure cd should have worked
	mov	al,[si-1]
	CMP	al,':'                          ; Special case d:\file
	JZ	BADRET

	CMP	[KPARSE],0
	JNZ	NOTDOUBLESL			; Last char is second KANJI byte, might be '\'

	CALL	PATHCHRCMP
	JNZ	NOTDOUBLESL
PEELFAIL:
	STC					; //
	return
NOTDOUBLESL:
	MOV	byte [SI],0
	MOV	AH,CHDIR
	INT	int_command
	JNC	CDSUCC
pcrunch_cderr:
	invoke	get_ext_error_number		;AN022; get the extended error
	mov	[msg_numb],ax			;AN022; set up message flag
	or	si,si				;AN022; set up zero flag to not zero
	stc					;AN022; set up carry flag
	return

BADRET:
	MOV	AL,[SI]
	CALL	PATHCHRCMP			; Special case 'DIRCHAR'file
	STC
	retnz
	XOR	BL,BL
	XCHG	BL,[SI+1]
	MOV	AH,CHDIR
	INT	int_command
	jc	pcrunch_cderr			;AN022; go to error exit
	MOV	[SI+1],BL
CDSUCC:
	invoke	SETREST1
	INC	SI				; Reset zero
	MOV	[DESTTAIL],SI
	pushf					;AN015; save flags
	cmp	dirflag,-1			;AN015; don't do parse if in DIR
	jz	pcrunch_end			;AN015;
	MOV	DI,FCB
	MOV	AX,(PARSE_FILE_DESCRIPTOR SHL 8) OR 02H ; Parse with default drive
	INT	int_command
pcrunch_end:
	popf					;AN015; get flags back
	return

; END SECTION .trancode
	    ; end
