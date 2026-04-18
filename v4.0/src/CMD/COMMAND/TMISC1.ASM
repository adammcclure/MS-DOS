 ; page 80,132
;	SCCSID = @(#)tmisc1.asm 4.1 85/09/22
;	SCCSID = @(#)tmisc1.asm 4.1 85/09/22
; TITLE	Part7 COMMAND Transient Routines

;	More misc routines

; .xlist
; .xcref
	%include "comsw.asm"
	%include "DOSSYM.INC"
	%include "comseg.asm"
	%include "comequ.asm"
; .list
; .cref



SECTION .CODERES;AC000;
	extern RSTACK
; END SECTION .CodeRes

SECTION .DATARES;AC000;
	extern CALL_FLAG
	extern EchoFlag
	extern EXEC_BLOCK
	extern EXTCOM
	extern PIPEFLAG
	extern PIPEPTR
	extern PIPESTR
	extern RESTDIR
	extern RE_OUT_APP
	extern RE_OUTSTR
; END SECTION .DATARES

SECTION .TRANDATA;AC000;
	extern BADDRV_PTR
	extern BADNAM_PTR
	extern COMTAB;AC000;
	extern extend_buf_ptr;AN000;
	extern msg_disp_class;AN000;
; END SECTION .TRANDATA

SECTION .TRANSPACE;AC000;
	extern arg; the arg structure!
	extern APPEND_EXEC;AN041;
	extern CHKDRV
	extern COMBUF
	extern EXECPATH
	extern EXEC_ADDR
	extern FILTYP
	extern IDLEN
	extern KPARSE;AC000;
	extern PARM1
	extern PARM2
	extern PathPos
	extern RESSEG
	extern RE_INSTR
	extern SPECDRV
	extern SWITCHAR
	extern switch_list
	extern TRAN_TPA

	%if IBM
	extern ROM_CALL
	extern ROM_CS
	extern ROM_IP
	%endif

; END SECTION .TRANSPACE

SECTION .TRANCODE

; ASSUME	CS:TRANGROUP,DS:NOTHING,ES:NOTHING,SS:NOTHING

	extern APPEND_PARSE;AN010;
	extern BATCOM
	extern DOCOM1
	extern PIPEERRSYN
	extern TCOMMAND

	%if IBM
	extern ROM_EXEC
	extern ROM_SCAN
	%endif

	global CERROR
	global DRVBAD
	global EXTERNAL
	global FNDCOM
	global PRESCAN
	global SWITCH


; ASSUME	DS:TRANGROUP

;---------------------------
; We can get rid of this switch processing code if we can take
; care of the remaining two calls to switch, later in the file.
; However, I have not checked whether or not any other files use
; switch -- after all, it IS public!
;---------------------------
RETSW:
	XCHG	AX,BX				; Put switches in AX
	return

SWITCH:
	XOR	BX,BX				; Initialize - no switches set
SWLOOP:
	INVOKE	SCANOFF 			; Skip any delimiters
	CMP	AL,[SWITCHAR]			; Is it a switch specifier?
	JNZ	RETSW				; No -- we're finished
	OR	BX,fSwitch			; Indicate there is a switch specified
	INC	SI				; Skip over the switch character
	INVOKE	SCANOFF
	CMP	AL,0DH
	JZ	RETSW				; Oops
	INC	SI
; Convert lower case input to upper case
	INVOKE	UPCONV
	MOV	DI,switch_list
	MOV	CX,SWCOUNT
	REPNE	SCASB				; Look for matching switch
	JNZ	BADSW
	MOV	AX,1
	SHL	AX,CL				; Set a bit for the switch
	OR	BX,AX
	JMP	SHORT SWLOOP

BADSW:
	JMP	SHORT SWLOOP

SWCOUNT EQU	5				; Length of switch_list

DRVBAD:
	MOV	DX,BADDRV_ptr
	JMP	CERROR

externalj:
	jmp	EXTERNAL

fndcom: 					; search the internal command table
    OR	    AL,AL				; Get real length of first arg
    jz	    externalj				; If 0, it must begin with "\" so has
						;  to be external.
; barryf code starts here

	%if IBM
	call	test_append			; see if APPEND installed
	je	contcom 			; not loaded

append_internal:
	mov	cl,IDLEN
	mov	ch,0
	mov	pathpos,cx
	inc	append_exec			;AN041; set APPEND to ON

	invoke	ioset				; re-direct the o'l io

	mov	SI, IDLEN	; address command name, DS already set
	mov	DX,-1				; set invoke function
	mov	di,APPEND_PARSE;AN010; Get the entry point for PARSE for APPEND
	mov	AX,0AE01H
	int	2FH				; execute command
	cmp	IDLEN,0		; execute requested
	jne	contcom
	jmp	Cmd_done

contcom:					; continue with internal scan
	%endif

; barryf code ends here

    mov     DI, COMTAB
    XOR     CX,CX

findcom:
    mov     SI, IDLEN+1	; pointer to command argument
    mov     CL, [DI]				; load length of internal command
    inc     di					; advance past length
    jcxz    externalj				; if it's zero, we're out of internals
    cmp     CL, IDLEN				; that of the command argument
    jnz     abcd				; lengths not equal ==> strings not eq
    MOV     PathPos,CX				; store length of command
    repz    cmpsb

abcd:
    lahf					; save the good ol' flags
    add     DI, CX				; skip over remaining internal, if any
    mov     AL, byte [DI]			; load drive-check indicator byte (DCIB)
    mov     [CHKDRV], AL			; save command flag byte in chkdrv
    inc     DI					; increment DI (OK, OK, I'll stop)
    mov     BX, word [DI]			; load internal command address
    inc     DI					; skip over the puppy
    inc     DI
    sahf					; remember those flags?
    jnz     findcom				; well, if all the cmps worked...
;
; All messages get redirected.
;
    cmp     append_exec,0			;AN041; APPEND just executed?
    jnz     dont_set_io 			;AN041; Yes - this junk is already set
    invoke  ioset				; re-direct the ol' i/o

dont_set_io:					;AN041;
    invoke  SETSTDINON				;AN026; turn on critical error on STDIN
    invoke  SETSTDOUTOFF			;AN026; turn off critical error on STDOUT
    test    [CHKDRV], fCheckDrive		; did we wanna check those drives?
    jz	    nocheck
    mov     AL, [PARM1] 			; parse_file_descriptor results tell
    or	    AL, [PARM2] 			; us whether those drives were OK
    cmp     AL, -1
    jnz     nocheck
    jmp     drvbad


;
; The user may have omitted the space between the command and its arguments.
; We need to copy the remainder of the user's command line into the buffer.
; Note that thisdoes not screw up the arg structure; it points into COMBUF not
; into the command line at 80.
;
nocheck:
    call    cmd_copy

switcheck:
    test    [CHKDRV], fSwitchAllowed		; Does the command take switches
    jnz     realwork				; Yes, process the command
    call    noswit				; No, check to see if any switches
    jnz     realwork				; None, process the command
    mov     msg_disp_class,parse_msg_class	;AN000; set up parse error msg class
    MOV     DX,Extend_Buf_ptr	;AC000; get extended message pointer
    mov     Extend_Buf_ptr,BadSwt_ptr		;AN000; get "Invalid switch" message number
    jmp     CERROR				; Print error and chill out...
realwork:
    call    BX					; do some real work, at last

; See if we're in a batch CALL command. If we are, reprocess the command line,
; otherwise, go get another command.

Cmd_done:
    push    cs					; g  restore data segment
    pop     ds					; g
    push    ds					; g  save data segment
    mov     ds,[resseg] 			; g  get segment containing call flag
    ; ASSUME  ds:resgroup
    cmp     call_flag, call_in_progress 	; G  Is a call in progress?
    mov     call_flag, 0			; G  Either way, reset flag
    pop     ds					; g  get data segment back
    jz	    incall				; G
    jmp     tcommand				; chill out...

incall:
    JMP     DOCOM1

noswit:
    push    di					; Save di
    mov     di,81h				; di = ptr to command args
    mov     si,80h				; Get address of length of command args
    lodsb					; Load length
    mov     cl,al				; Move length to cl
    xor     ch,ch				; Zero ch
    mov     al,[SWITCHAR]			; al = switch character
    cmp     al,0				; Turn off ZF
    repnz   scasb				; Scan for a switch character and return
    pop     di					;  with ZF set if one was found
    ret

EXTERNAL:

%if IBM
	call	test_append			; check to see if append installed
	je	not_barryf			; no - truly external command
	jmp	append_internal 		; yes - go to Barryf code

not_barryf:

%endif

	MOV	[FILTYP],0
	MOV	DL,[SPECDRV]
	MOV	[IDLEN],DL
%if IBM
	MOV	[ROM_CALL],0
	PUSH	DX
	MOV	DX,IDLEN
	CALL	ROM_SCAN
	POP	DX
	JNC	DO_SCAN
	INC	[ROM_CALL]
	JMP	PostSave
DO_SCAN:
%endif
%if IBM
PostSave:
%endif
	MOV	DI,EXECPATH
	MOV	byte [DI],0 		; Initialize to current directory
%if IBM
	CMP	[ROM_CALL],0
	JZ	Research
	JMP	NeoExecute
%endif
RESEARCH:
	invoke	path_search			; find the mother (result in execpath)
	or	AX, AX				; did we find anything?
	je	badcomj45			; null means no (sob)
	cmp	AX, 04H 			; 04H and 08H are .exe and .com
	jl	rsrch_br1			; fuckin' sixteen-bit machine ought
	jmp	execute 			; to be able to handle a SIXTEEN-BIT
rsrch_br1:					; DISPLACEMENT!!
	jmp	batcom				; 02H is .bat
BADCOMJ45:
	JMP	BADCOM

; ASSUME	DS:TRANGROUP,ES:TRANGROUP

EXECUTE:
NeoExecute:
	invoke	IOSET
	invoke	SETSTDINOFF			;AN026; turn off critical error on STDIN
	invoke	SETSTDOUTOFF			;AN026; turn off critical error on STDOUT
	MOV	ES,[TRAN_TPA]
	MOV	AH,DEALLOC
	INT	int_command			; Now running in "free" space
	MOV	ES,[RESSEG]
; ASSUME	ES:RESGROUP
	INC	[EXTCOM]			; Indicate external command
	MOV	[RESTDIR],0			; Since USERDIR1 is in transient, insure
						;  this flag value for re-entry to COMMAND
	MOV	DI,FCB
	MOV	SI,DI
	MOV	CX,052H 			; moving (100h-5Ch)/2 = 80h-2Eh
	REP	MOVSW				; Transfer parameters to resident header
	MOV	DX,EXECPATH
	MOV	BX,EXEC_BLOCK
	MOV	AX,EXEC SHL 8
%if IBM
	TEST	[ROM_CALL],-1
	JZ	OK_EXEC
	JMP	ROM_EXEC
OK_EXEC:
%endif
;
; we are now running in free space.  anything we do from here on may get
; trashed.  Move the stack (also in free space) to allocated space because
; since EXEC restores the stack, somebody may trash what is on the stack.
;
	MOV	CX,ES
	MOV	SS,CX
	MOV	SP,RSTACK
	JMP	[EXEC_ADDR]			; Jmp to the EXEC in the resident

BADCOM:
	PUSH	CS
	POP	DS
	MOV	DX,BADNAM_ptr

CERROR:
	INVOKE	std_eprintf
	JMP	TCOMMAND

;
; Prescan converts the input buffer into a canonicalized form.	All
; redirections and pipes are removed.
;
PRESCAN:					; Cook the input buffer

; ASSUME	DS:TRANGROUP,ES:TRANGROUP

	XOR	CX,CX
	MOV	ES,[RESSEG]
; ASSUME	ES:RESGROUP
	MOV	SI,COMBUF+2
	MOV	DI,SI

CountQuotes:
	LODSB					; get a byte
	CMP	AL,22h				; is it a quote?
	JNZ	CountEnd			; no, try for end of road
	INC	CH				; bump count
	JMP	CountQuotes			; go get next char

CountEnd:
	CMP	AL,13				; end of road?
	JNZ	CountQuotes			; no, go back for next char

;;;;	IF	KANJI		3/3/KK
	PUSH	CX				; save count
	MOV	SI,DI				; get back beginning of buffer

KanjiScan:
	LODSB					; get a byte
	INVOKE	TestKanj			; is it a leadin byte
	JZ	KanjiQuote			; no, check for quotes
	MOV	AH,AL				; save leadin
	LODSB					; get trailing byte
	CMP	AX,8140h			; is it Kanji space
	JNZ	KanjiScan			; no, go get next
	MOV	[SI-2],2020h			; replace with spaces
	JMP	KanjiScan			; go get next char

KanjiQuote:
	CMP	AL,22h				; beginning of quoted string
	JNZ	KanjiEnd			; no, check for end
	DEC	CH				; drop count
	JZ	KanjiScan			; if count is zero, no quoting

KanjiQuoteLoop:
	LODSB					; get next byte
	CMP	AL,22h				; is it another quote
	JNZ	KanjiQuoteLoop			; no, get another
	DEC	CH				; yes, drop count
	JMP	KanjiScan			; go get next char

KanjiEnd:
	CMP	AL,13				; end of line character?
	JNZ	KanjiScan			; go back to beginning
	POP	CX				; get back original count
;;;;	ENDIF		3/3/KK

	MOV	SI,DI				; restore pointer to begining

PRESCANLP:
	LODSB

;;;;	IF	KANJI		3/3/KK
	INVOKE	TESTKANJ
	JZ	NOTKANJ6
	MOV	[DI],AL
	INC	DI				; fake STOSB into DS
	LODSB					; grab second byte
	MOV	[DI],AL 			; fake stosb into DS
	INC	DI
	INC	CL
	INC	CL
	JMP	PRESCANLP

NOTKANJ6:
;;;;	ENDIF			3/3/KK

	CMP	AL,'"'                          ; " character
	JNZ	TRYGREATER
	DEC	CH
	JZ	TRYGREATER

QLOOP:
	MOV	[DI],AL
	INC	DI
	INC	CL
	LODSB
	CMP	AL,'"'                          ; " character
	JNZ	QLOOP
	DEC	CH

TRYGREATER:
	CMP	AL,rabracket
	JNZ	NOOUT
;
; We have found a ">" char.  We need to see if there is another ">"
; following it.
;
	CMP	byte [SI],al
	JNZ	NOAPPND
	LODSB
	INC	[RE_OUT_APP]			; Flag >>

NOAPPND:
;
; Now we attempt to find the file name.  First, scan off all whitespace
;
	INVOKE	SCANOFF
	CMP	AL,labracket			;AN040; was there no filename?
	JZ	REOUT_ERRSET			;AN040; yes - set up error
	CMP	AL,0DH
	JNZ	GOTREOFIL
;
; There was no file present.  Set us up at end-of-line.
;
REOUT_ERRSET:					;AN040; set up for an error
	mov	byte [di], 0dh		; Clobber first ">"
	MOV	word [RE_OUTSTR],09H	; Cause an error later
	JMP	PRESCANEND

GOTREOFIL:
	PUSH	DI
	MOV	DI,RE_OUTSTR
	MOV	BX,DI
	PUSH	ES

SETREOUTSTR:					; Get the output redirection name
	LODSB
	CMP	AL,0DH
	JZ	GOTRESTR
	INVOKE	DELIM
	JZ	GOTRESTR
	CMP	AL,[SWITCHAR]
	JZ	GOTRESTR
	CMP	AL,'"'                          ;AN033; Is the character a quote?
	JZ	PIPEERRSYNJ5			;AN033; Yes - get out quick - or system crashes
	CMP	AL,labracket			;AN002; Is char for input redirection
	JZ	ABRACKET_TERM			;AN002; yes - end of string
	CMP	AL,rabracket			;AN002; Is char for output redirection
	JNZ	NO_ABRACKET			;AN002; no - not end of string

abracket_term:					;AN002; have end of string by < or >
	DEC	SI				;AN002; back up over symbol
	MOV	AL,BLANK			;AN002; show delimiter as char
	JMP	SHORT GOTRESTR			;AN002; go process it

no_abracket:					;AN002; not at end of string
	STOSB					; store it into resgroup
	JMP	SHORT SETREOUTSTR

NOOUT:
	CMP	AL,labracket
	JNZ	CHKPIPE
	mov	bx,si				; Save loc of "<"
	INVOKE	SCANOFF
	CMP	AL,rabracket			;AN040; was there no filename?
	JZ	REIN_ERRSET			;AN040; yes - set up error
	CMP	AL,0DH
	JNZ	GOTREIFIL

REIN_ERRSET:					;AN040; set up for error
	mov	byte [di],0dh		; Clobber "<"
	MOV	word [RE_INSTR],09H 	; Cause an error later
	JMP	SHORT PRESCANEND

GOTREIFIL:
	PUSH	DI
	MOV	DI,RE_INSTR
	MOV	BX,DI
	PUSH	ES
	PUSH	CS
	POP	ES				; store in TRANGROUP
	JMP	SHORT SETREOUTSTR		; Get the input redirection name

CHKPIPE:
	MOV	AH,AL
	CMP	AH,AltPipeChr
	JZ	IsPipe3
	CMP	AH,vbar
	JNZ	CONTPRESCAN

IsPipe3:
;
; Only push the echo flag if we are entering the pipe for the first time.
;
	CMP	PipeFlag,0
	JNZ	NoEchoPush
	SHL	EchoFlag,1			; push echo state and turn it off
NoEchoPush:
	INC	[PIPEFLAG]
	INVOKE	SCANOFF
	CMP	AL,0DH
	JZ	PIPEERRSYNJ5
	CMP	AL,AltPipeChr
	JZ	PIPEERRSYNJ5
	CMP	AL,vbar 			; Double '|'?
	JNZ	CONTPRESCAN

PIPEERRSYNJ5:
	PUSH	ES
	POP	DS				; DS->RESGROUP
	JMP	PIPEERRSYN

;
; Trailing :s are allowed on devices.  Check to be sure that there is more
; than just a :  in the redir string.
;
GOTRESTR:
	XCHG	AH,AL
	mov	al,':'
	SUB	BX,DI				; compute negatinve of number of chars
	CMP	BX,-1				; is there just a :?
	JZ	NotTrailCol			; yep, don't change
	CMP	byte [ES:DI-1],al		; Trailing ':' OK on devices
	JNZ	NOTTRAILCOL
	DEC	DI				; Back up over trailing ':'

NOTTRAILCOL:
	XOR	AL,AL
	STOSB					; NUL terminate the string
	POP	ES
	POP	DI				; Remember the start

CONTPRESCAN:
	MOV	[DI],AH 			; "delete" the redirection string
	INC	DI
	CMP	AH,0DH
	JZ	PRESCANEND
	INC	CL
	JMP	PRESCANLP

PRESCANEND:
	CMP	[PIPEFLAG],0
	JZ	ISNOPIPE
	MOV	DI,PIPESTR
	MOV	[PIPEPTR],DI
	MOV	SI,COMBUF+2
	INVOKE	SCANOFF

PIPESETLP:					; Transfer the pipe into the resident
	LODSB					; pipe buffer
	STOSB
	CMP	AL,0DH
	JNZ	PIPESETLP

ISNOPIPE:
	MOV	[COMBUF+1],CL
	CMP	[PIPEFLAG],0
	PUSH	CS
	POP	ES
	return

cmd_copy:

	MOV	SI,COMBUF+2
	INVOKE	Scanoff 			; advance past separators...
	add	si,PathPos
	mov	di,81h
	xor	cx,cx

CmdCopy:
	lodsb
	stosb
	cmp	al,0dh
	jz	CopyDone
	inc	cx
	jmp	CmdCopy

CopyDone:
	 mov	 byte [ds:80h],cl		; Store count

	 ret
; ENDP cmd_copy


test_append:

	mov	BX,COMBUF	;   barry can address
	mov	SI, IDLEN	; address command name, DS already set
	mov	DX,-1				; set install check function
	mov	AX,0AE00H
	int	2FH				; see if loaded
	cmp	AL,00H

	ret

; ENDP test_append

; END SECTION .TRANCODE
	    ; END
