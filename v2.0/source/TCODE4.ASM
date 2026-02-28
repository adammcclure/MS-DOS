; TITLE   PART4 - COMMAND Transient routines.

        %include "COMSW.ASM"

; .xlist
; .xcref
        %include "DOSSYM.ASM"
        %include "DEVSYM.ASM"
        %include "COMSEG.ASM"
; .list
; .cref

        %include "COMEQU.ASM"


SECTION .DATARES
        extern RESTDIR
; END SECTION .DATARES

SECTION .TRANDATA
        extern BADDRV,BADSWT
        extern BADDAT,NEWDAT,BADTIM
        extern DMES,CURDAT_PRE,CURDAT_MID,CURDAT_POST
        extern RENERR,VERMES_PRE,VERMES_POST
        extern DIRHEAD_PRE,DIRHEAD_POST
        extern ACRLF,BADARGS,NOTFND
        extern NEWTIM,BADCD,BADMKD,CLSSTRING
        extern CURTIM_PRE,CURTIM_POST,PauseMes
        extern BADRMD
; END SECTION .TRANDATA

SECTION .TRANSPACE
        extern COMBUF,DIRCHAR,USERDIR1
        extern BYTCNT,CURDRV,COMSW,ARGTS
        extern LINCNT,LINLEN,FILECNT,CHARBUF
        extern DIRBUF,BITS,PATHPOS
        extern DESTISDIR,DESTTAIL,DESTINFO,FULLSCR
        extern INTERNATVARS,RESSEG,TPA
; END SECTION .TRANSPACE


SECTION .TRANCODE
; ASSUME  CS:TRANGROUP,DS:NOTHING,ES:NOTHING,SS:NOTHING

        extern NOTEST2,PRINTVOL,Print_Date
        extern CERROR,SWITCH,PWD,SETREST,MESTRAN
        extern NOTFNDERR,CHKCNT,GETKEYSTROKE
        extern SETPATH,PATHCRUNCH,PRINT,ZPRINT
        extern DISPSIZE,OUT,OUT2,ERROR_PRINT
        extern SCANOFF,OUTBYTE,GETNUM,ERROR_OUTPUT


        global PRINT_TIME,CATALOG
        global BADCDERR,PRINT_VERSION,CLS,SAVUDIR,SAVUDIR1
        global TYPEFIL,CRENAME,$RMDIR
        global CTIME,$CHDIR,ONESPC,DATINIT
        global $MKDIR,VERSION,RESTUDIR1
        global RESTUDIR,CRLF2,ERASE
        global volume,date,P_date,PAUSE
 

CATALOG:
        CALL    OKVOLARG
        MOV     AL,"?"                  ; *.* is default file spec.
        MOV     DI,5DH
        MOV     CX,11
        REP     STOSB
        MOV     SI,81H
        CALL    SWITCH
        MOV     DI,FCB
        MOV     AX,(PARSE_FILE_DESCRIPTOR SHL 8) OR 0DH          ; Parse with default name and extension
        INT     int_command

; Begin by processing any switches that may have been specified.
; BITS will contain any information about switches that was
; found when the command line was parsed.

SETSWT:
        MOV     AX,[COMSW]              ; Get switches from command
        OR      AX,[ARGTS]              ; OR in switches from all of tail
        MOV     [BITS],AX
        MOV     byte[FULLSCR],LINPERPAG
        TEST    AL,1                    ; Look for W switch
        MOV     AL,NORMPERLIN
        JZ      DIR
        MOV     AL,WIDEPERLIN
DIR:
        MOV     [LINLEN],AL             ; Set number of entries per line
        MOV     [LINCNT],AL
        MOV     [FILECNT],0     ; Keep track of how many files found
        MOV     DX,DIRBUF      ; Set Disk transfer address
        MOV     AH,SET_DMA
        INT     int_command
        CALL    PATHCRUNCH                      ; Get where we're going
        PUSHF
        JNC     NOTEST
        CMP     [DESTISDIR],0           ; No CHDIRs worked
        JZ      NOTEST                  ; see if they should have
        JMP     BADCDERR

NOTEST:
        MOV     SI,FCB
        MOV     DI,DIRBUF
        MOV     DX,DI
        MOV     CX,12
        REP     MOVSB
        MOV     AH,FCB_OPEN
        INT     int_command
        MOV     DX,DIRHEAD_PRE ; Print "Directory of"
        PUSH    AX                              ; save return code
        CALL    PRINT
        CALL    PWD                             ; print the path
        MOV     DX,DIRHEAD_POST
        CALL    PRINT
        POP     AX
        OR      AL,AL
        JNZ     OKDODIR                         ; Go ahead and dir if open fail
        TEST    [DIRBUF+fcb_DEVID],devid_device
        JZ      OKDODIR
        JMP     NOTFNDERR                       ; Can't DIR a device
OKDODIR:
        MOV     AH,DIR_SEARCH_FIRST
        MOV     byte DS:[FCB-7],0FFH
        MOV     byte DS:[FCB-1],010H
        POPF
        JC      SHOWDIR                         ; Current dir
        JZ      DOFIRST                         ; FCB is *.*
        MOV     AL,"?"
        MOV     DI,5DH
        MOV     CX,11
        REP     STOSB           ; Remake default FCB
        MOV     SI,[DESTTAIL]
        MOV     DI,FCB
        MOV     AX,(PARSE_FILE_DESCRIPTOR SHL 8) OR 0EH  ; Parse with default drive, name and extension
        INT     int_command
        MOV     AH,DIR_SEARCH_FIRST
DOFIRST:
        MOV     DX,FCB-7
        INT     int_command
        PUSH    AX
        CALL    RESTUDIR
        POP     AX
        JMP     SHORT DIRSTART

SHOWDIR:
        MOV     DX,FCB-7        ; DX -> Unopened FCB
        INT     int_command             ; Search for a file to match FCB
DIRSTART:
        INC     AL              ; FF = file not found
        JNZ     AGAIN           ; Either an error or we are finished
        JMP     CHKCNT
NEXENTJ:
        JMP    NEXENT
AGAIN:
        INC     [FILECNT]       ; Keep track of how many we find
        MOV     SI,DIRBUF+8    ; SI -> information returned by sys call
        CALL    SHONAME
        TEST    byte[BITS],WSWITCH  ; W switch set?
        JNZ     NEXENTJ         ; If so, no size, date, or time
        MOV     SI,DIRBUF+8+dir_attr
        TEST    byte [SI],attr_directory
        JZ      FILEENT
        MOV     DX,DMES
        CALL    PRINT
        JMP     SHORT NOFSIZ
FILEENT:
        CALL    DISPSIZE        ; Print size of file
NOFSIZ:
        MOV     AX,word [DIRBUF+8+dir_date]  ; Get date
        OR      AX,AX
        JZ      NEXENT          ; Skip if no date
        MOV     DI,CHARBUF
        PUSH    AX
        MOV     AX,"  "
        STOSW
        POP     AX
        MOV     BX,AX
        AND     AX,1FH          ; get day
        MOV     DL,AL
        MOV     AX,BX
        MOV     CL,5
        SHR     AX,CL           ; Align month
        AND     AL,0FH          ; Get month
        MOV     DH,AL
        MOV     CL,BH
        SHR     CL,1            ; Align year
        XOR     CH,CH
        ADD     CX,80           ; Relative 1980
        CMP     CL,100
        JB      MILLENIUM
        SUB     CL,100
MILLENIUM:
        CALL    DATE_CXDX
        MOV     CX,word[DIRBUF+8+dir_time]  ; Get time
        JCXZ    PRBUF           ; Time field present?
        MOV     AX,"  "
        STOSW
        SHR     CX,1
        SHR     CX,1
        SHR     CX,1
        SHR     CL,1
        SHR     CL,1            ; Hours in CH, minutes in CL
        MOV     BL,[INTERNATVARS.Time_24]
        OR      BL,80H          ; Tell P_TIME called from DIR
        CALL    P_TIME          ; Don't care about DX, never used with DIR
PRBUF:
        XOR     AX,AX
        STOSB
        MOV     DX,CHARBUF
        CALL    ZPRINT
NEXENT:
        DEC     [LINCNT]
        JNZ     SAMLIN
NEXLIN:
        MOV     AL,[LINLEN]
        MOV     [LINCNT],AL
        CALL    CRLF2
        TEST    byte[BITS],PSWITCH  ; P switch present?
        JZ      SCROLL          ; If not, just continue
        DEC     byte[FULLSCR]
        JNZ     SCROLL
        MOV     byte[FULLSCR],LINPERPAG
        MOV     DX,PAUSEMES
        CALL    PRINT
        CALL    GetKeystroke
        CALL    CRLF2
SCROLL:
        MOV     AH,DIR_SEARCH_NEXT
        JMP     SHOWDIR

SAMLIN:
        MOV     AL,9            ; Output a tab
        CALL    OUT
        JMP     SHORT SCROLL

SHONAME:
        MOV     DI,CHARBUF
        MOV     CX,8
        REP     MOVSB
        MOV     AL," "
        STOSB
        MOV     CX,3
        REP     MOVSB
        XOR     AX,AX
        STOSB
        PUSH    DX
        MOV     DX,CHARBUF
        CALL    ZPRINT
        POP     DX
        return

ONESPC:
        MOV     AL," "
        JMP     OUT

CRLF2:
        PUSH    DX
        MOV     DX,ACRLF
PR:
        PUSH    DS
        PUSH    CS
        POP     DS
        CALL    PRINT
        POP     DS
        POP     DX
        return

PAUSE:
        MOV     DX,PAUSEMES
        CALL    ERROR_PRINT
        CALL    GetKeystroke
        CALL    CRLF2
        return

ERASE:
        MOV     DX,BADARGS
        MOV     SI,80H
        LODSB
        OR      AL,AL
        JZ      ERRJ2
        CALL    SCANOFF
        CMP     AL,13           ; RETURN KEY?
        JZ      ERRJ2           ; IF SO NO PARAMETERS SPECIFIED

ERA1:
        CALL    PATHCRUNCH
        JNC     NOTEST2J
        CMP     [DESTISDIR],0           ; No CHDIRs worked
        JZ      NOTEST2J                ; see if they should have
BADCDERR:
        MOV     DX,BADCD
ERRJ2:
        JMP     CERROR

NOTEST2J:
        JMP     NOTEST2

CRENAME:
        CALL    PATHCRUNCH
        JNC     NOTEST3
        CMP     [DESTISDIR],0           ; No CHDIRs worked
        JZ      NOTEST3                 ; see if they should have
        JMP     BADCDERR

NOTEST3:
        MOV     SI,[PATHPOS]
        MOV     DI,FCB+10H
        CALL    SCANOFF
        MOV     AX,(PARSE_FILE_DESCRIPTOR SHL 8) OR 01H
        INT     int_command
        CMP     byte DS:[FCB+10H+1]," "  ; Check if parameter exists
        MOV     DX,BADARGS
        JZ      ERRJ            ; Error if missing parameter
        MOV     AH,FCB_RENAME
        MOV     DX,FCB
        INT     int_command
        PUSH    AX
        CALL    RESTUDIR
        POP     AX
        MOV     DX,RENERR
        INC     AL
        retnz
ERRJ:
        JMP     CERROR

; ASSUME  DS:TRANGROUP,ES:TRANGROUP
TYPEFIL:
        mov     si,81H
        call    SCANOFF         ; Skip to first non-delim
        cmp     al,0DH
        jnz     GOTTARG
        jmp     NOARGERR        ; No args
GOTTARG:
        CALL    SETPATH
        MOV     AX,OPEN SHL 8
        INT     int_command
        MOV     DX,NOTFND
        JC      ERRJ
        MOV     BX,AX           ; Handle
        MOV     DS,[TPA]
        XOR     DX,DX
; ASSUME  DS:NOTHING
TYPELP:
        MOV     CX,[BYTCNT]
        MOV     AH,READ
        INT     int_command
        MOV     CX,AX
        JCXZ    RET56
        PUSH    BX
        MOV     BX,1
        MOV     AH,WRITE
        INT     int_command
        POP     BX
        JC      ERROR_OUTPUTJ
        CMP     AX,CX
        JZ      TYPELP
        DEC     CX
        CMP     AX,CX
        retz                            ; One less byte OK (^Z)
ERROR_OUTPUTJ:
        MOV     BX,1
        MOV     AX,IOCTL SHL 8
        INT     int_command
        TEST    DL,devid_ISDEV
        retnz                           ; If device, no error message
        JMP     ERROR_OUTPUT

RESTUDIR1:
        PUSH    DS
        MOV     DS,[RESSEG]
; ASSUME  DS:RESGROUP
        CMP     [RESTDIR],0
        POP     DS
; ASSUME  DS:TRANGROUP
        retz
RESTUDIR:
        MOV     DX,USERDIR1
        MOV     AH,CHDIR
        INT     int_command             ; Restore users DIR
        XOR     AL,AL
        CALL    SETREST
RET56:
        return


VOLUME:
        mov     si,81H
        call    SCANOFF         ; Skip to first non-delim
        CMP     byte DS:[FCB],0     ;Default drive?
        JZ      CHECKNOARG              ;Yes
        INC     SI
        INC     SI      ;Skip over d:
        MOV     BX,SI
        CALL    SCANOFF
        CMP     BX,SI
        JNZ     OKVOLARG        ; If we skipped some delims at this point, OK
CHECKNOARG:
        cmp     al,0DH
        JZ      OKVOLARG
BADVOLARG:
        MOV     DX,BADDRV
        JMP     CERROR

OKVOLARG:
        CALL    CRLF2
        PUSH    DS
        POP     ES
        MOV     DI,FCB-7        ; Set up extended FCB
        MOV     AX,-1
        STOSB
        XOR     AX,AX
        STOSW
        STOSW
        STOSB
        MOV     AL,8            ; Look for volume label
        STOSB
        INC     DI              ; Skip drive byte
        MOV     CX,11
        MOV     AL,'?'
        REP     STOSB
        MOV     DX,DIRBUF
        MOV     AH,SET_DMA
        INT     int_command
        MOV     DX,FCB-7
        MOV     AH,DIR_SEARCH_FIRST
        INT     int_command
        JMP     PRINTVOL

VERSION:
        CALL    CRLF2
        CALL    PRINT_VERSION
        JMP     CRLF2

PRINT_VERSION:
        MOV     DI,CHARBUF
        MOV     SI,VERMES_PRE
        CALL    MESTRAN
        MOV     AH,GET_VERSION
        INT     int_command
        PUSH    AX
        XOR     AH,AH
        MOV     CL,10
        DIV     CL
        MOV     CL,4
        SHL     AL,CL
        OR      AL,AH
        MOV     CX,1110H
        MOV     DL,AL
        CALL    OUTBYTE
        MOV     AL,'.'
        STOSB
        POP     AX
        MOV     AL,AH
        XOR     AH,AH
        MOV     CL,10
        DIV     CL
        MOV     CL,4
        SHL     AL,CL
        OR      AL,AH
        MOV     CX,1010H
        MOV     DL,AL
        CALL    OUTBYTE
        MOV     SI,VERMES_POST
        CALL    MESTRAN
        XOR     AX,AX
        STOSB
        MOV     DX,CHARBUF
        JMP     ZPRINT

; ASSUME  DS:TRANGROUP

CLS:
        %if IBMVER
        MOV     BX,1
        MOV     AX,IOCTL SHL 8
        INT     int_command
        TEST    DL,devid_ISDEV
        JZ      ANSICLS         ; If a file put out ANSI
        TEST    DL,devid_SPECIAL
        JZ      ANSICLS         ; If not special CON, do ANSI
        MOV     AX,(GET_INTERRUPT_VECTOR SHL 8) OR 29H
        INT     int_command
        MOV     DX,ES
        MOV     AX,(GET_INTERRUPT_VECTOR SHL 8) OR 20H
        INT     int_command
        MOV     AX,ES
        CMP     DX,AX
        JA      ANSICLS         ; If not default driver, do ANSI
        MOV     AH,11           ; Set overscan to black
        XOR     BX,BX
        INT     16
        MOV     AH,15
        INT     16
        MOV     DL,AH
        DEC     DL

        %if KANJI
        MOV     DH,23
        %else
        MOV     DH,25
        %endif

        XOR     AX,AX
        MOV     CX,AX

        %if KANJI
        MOV     BH,0
        %else
        MOV     BH,7
        %endif

        MOV     AH,6
        INT     16
        XOR     DX,DX
        MOV     BH,0
        MOV     AH,2
        INT     16
        return

ANSICLS:
        %endif

        MOV     SI,CLSSTRING
        LODSB
        MOV     CL,AL
        XOR     CH,CH
        MOV     AH,RAW_CON_IO
CLRLOOP:
        LODSB
        MOV     DL,AL
        INT     int_command
        LOOP    CLRLOOP
        return

$CHDIR:
        MOV     AX,[COMSW]
        OR      AX,[ARGTS]
        MOV     DX,BADSWT
        JNZ     CERRORJ3
        mov     si,81H
        call    SCANOFF         ; Skip to first non-delim
        cmp     al,0DH
        jz      PWDJ            ; No args
        inc     si              ; Skip first char
        lodsw
        cmp     ax,(0DH SHL 8) OR ':'   ; d:<CR> ?
        jnz     REALCD          ; no
PWDJ:
        jmp     PWD             ; Drive only specified
REALCD:
        CALL    SETPATH
        TEST    [DESTINFO],2
        JNZ     BADCDERRJ
        MOV     AH,CHDIR
        INT     int_command
        retnc
BADCDERRJ:
        JMP  BADCDERR

$MKDIR:
        CALL    SETRMMK
        JNZ     BADMDERR
        MOV     AH,MKDIR
        INT     int_command
        retnc
BADMDERR:
        MOV     DX,BADMKD
CERRORJ3:
        JMP    CERROR

NOARGERR:
        MOV     DX,BADARGS
        JMP     SHORT CERRORJ3

SETRMMK:
        mov     si,81H
        call    SCANOFF         ; Skip to first non-delim
        cmp     al,0DH
        jz      NOARGERR        ; No args
        MOV     AX,[COMSW]
        OR      AX,[ARGTS]
        MOV     DX,BADSWT
        JNZ     CERRORJ3
        CALL    SETPATH
        TEST    [DESTINFO],2
        return

$RMDIR:
        CALL    SETRMMK
        JNZ     BADRDERR
        MOV     AH,RMDIR
        INT     int_command
        retnc
BADRDERR:
        MOV     DX,BADRMD
        JMP     CERROR

SAVUDIR:
; DL is drive number A=1
        MOV     DI,USERDIR1
SAVUDIR1:
        MOV     AL,DL
        ADD     AL,'@'
        CMP     AL,'@'
        JNZ     GOTUDRV
        ADD     AL,[CURDRV]
        INC     AL                 ; A = 1
GOTUDRV:
        STOSB
        MOV     AH,[DIRCHAR]
        MOV     AL,DRVCHAR
        STOSW
        PUSH    ES
        POP     DS
; ASSUME  DS:NOTHING
        MOV     SI,DI
        MOV     AH,CURRENT_DIR      ; Get the Directory Text
        INT     int_command
        retc
        PUSH    CS
        POP     DS
; ASSUME  DS:TRANGROUP
        return

; ASSUME  DS:TRANGROUP,ES:TRANGROUP

; Date and time are set during initialization and use
; this routines since they need to do a long return

DATINIT:
        PUSH    ES
        PUSH    DS              ; Going to use the previous stack
        MOV     AX,CS           ; Set up the appropriate segment registers
        MOV     ES,AX
        MOV     DS,AX
        MOV     DX,INTERNATVARS        ;Set up internat vars
        MOV     AX,INTERNATIONAL SHL 8
        INT     21H
        MOV     word DS:[81H],13    ; Want to prompt for date during initialization
        MOV     [COMBUF],COMBUFLEN      ; Init COMBUF
        MOV     word [COMBUF+1],0D01H
        CALL    DATE
        CALL    CTIME
        POP     DS
        POP     ES
        RET
; ENDP DATINIT

; DATE - Gets and sets the time

DATE_CXDX:
        MOV     BX,CX
P_DATE:
        MOV     AX,BX
        MOV     CX,DX
        MOV     DL,100
        DIV     DL
        XCHG    AL,AH
        XCHG    AX,DX
        MOV     BH,"0"-" "      ; Enable leading zero suppression
        MOV     AX,word [INTERNATVARS.Date_tim_format]
        OR      AX,AX
        JZ      USPDAT
        DEC     AX
        JZ      EUPDAT
        MOV     BH,0            ; Disable leading zero suppression
        CALL    P_YR
        CALL    P_DSEP
        CALL    P_MON
        CALL    P_DSEP
        CALL    P_DAY
        return

USPDAT:
        CALL    P_MON
        CALL    P_DSEP
        CALL    P_DAY
PLST:
        CALL    P_DSEP
        CALL    P_YR
        return

EUPDAT:
        CALL    P_DAY
        CALL    P_DSEP
        CALL    P_MON
        JMP     PLST

P_MON:
        MOV     AL,CH
        CALL    OUT2
        return

P_DSEP:
        MOV     AL,byte [INTERNATVARS.Date_sep]
        STOSB
        return

P_DAY:
        MOV     AL,CL
        CALL    OUT2
        return

P_YR:
        MOV     AL,DH
        OR      AL,AL
        JZ      TWODIGYR        ; Two instead of 4 digit year
        CALL    OUT2
TWODIGYR:
        MOV     AL,DL
        CALL    OUT2
        return

DATE:
        MOV     SI,81H          ; Accepting argument for date inline
        CALL    SCANOFF
        CMP     AL,13
        JZ      PRMTDAT
        JMP     COMDAT

PRMTDAT:
        MOV     DX,CURDAT_PRE
        CALL    PRINT           ; Print "Current date is "
        CALL    PRINT_DATE
        MOV     DX,CURDAT_POST
        CALL    PRINT
GETDAT:
        MOV     DX,NEWDAT
        CALL    ERROR_PRINT     ; Print "Enter new date: "
        MOV     AH,STD_CON_STRING_INPUT
        MOV     DX,COMBUF
        INT     int_command             ; Get input line
        CALL    CRLF2
        MOV     SI,COMBUF+2
        CMP     byte[SI],13 ; Check if new date entered
        retz
COMDAT:
        MOV     AX,word [INTERNATVARS.Date_tim_format]
        OR      AX,AX
        JZ      USSDAT
        DEC     AX
        JZ      EUSDAT
        CALL    GET_YR
        JC      DATERRJ
        CALL    GET_DSEP
        JC      DATERRJ
        CALL    GET_MON
        JC      DATERRJ
        CALL    GET_DSEP
        JC      DATERRJ
        CALL    GET_DAY
DAT_SET:
        JC      DATERR
        LODSB
        CMP     AL,13
        JNZ     DATERR
        MOV     AH,SET_DATE
        INT     int_command
        OR      AL,AL
        JNZ     DATERR
        return

USSDAT:
        CALL    GET_MON
        JC      DATERR
        CALL    GET_DSEP
DATERRJ:
        JC      DATERR
        CALL    GET_DAY
TGET:
        JC      DATERR
        CALL    GET_DSEP
        JC      DATERR
        CALL    GET_YR
        JMP     DAT_SET

EUSDAT:
        CALL    GET_DAY
        JC      DATERR
        CALL    GET_DSEP
        JC      DATERR
        CALL    GET_MON
        JMP     TGET

GET_MON:
        CALL    GETNUM          ; Get one or two digit number
        retc
        MOV     DH,AH           ; Put in position
        return

GET_DAY:
        CALL    GETNUM
        MOV     DL,AH           ; Put in position
        return

GET_YR:
        CALL    GETNUM
        retc
        MOV     CX,1900
        CALL    GET_DSEP
        PUSHF
        DEC     SI
        POPF
        JZ      BIAS
        CMP     byte[SI],13
        JZ      BIAS
        MOV     AL,100
        MUL     AH
        MOV     CX,AX
        CALL    GETNUM
        retc
BIAS:
        MOV     AL,AH
        MOV     AH,0
        ADD     CX,AX

        %if IBM AND KANJI
;
; Gross hack for PC-J machine: CMOS clock cannot handle years after 2079
;
        CMP     CX,2080
        JB      YearOk
        STC
        return
YearOk: CLC
        %endif
        return

DATERR:
        MOV     DX,BADDAT
        CALL    PRINT
        JMP     GETDAT

GET_DSEP:
        LODSB
        CMP     AL,'/'
        retz
        CMP     AL,'.'
        retz
        CMP     AL,'-'
        retz
        STC
        return

; TIME gets and sets the time

CTIME:
        MOV     SI,81H                  ; Accepting argument for time inline
        CALL    SCANOFF
        CMP     AL,13
        JZ      PRMTTIM
        MOV     BX,".:"
        CALL    INLINE
        JMP     COMTIM

PRINT_TIME:
        MOV     AH,GET_TIME
        INT     int_command              ; Get time in CX:DX
        PUSH    DI
        PUSH    ES
        PUSH    CS
        POP     ES
        MOV     DI,CHARBUF
        MOV     BL,1            ; Always 24 hour time
        CALL    P_TIME
        XOR     AX,AX
        STOSB
        MOV     DX,CHARBUF
        CALL    ZPRINT
        POP     ES
        POP     DI
        return

P_TIME:
        MOV     AL,CH
        TEST    BL,07FH         ; Ignore high bit
        JNZ     T24             ; 24 hr time?
        MOV     BH,"a"          ; Assume A.M.
        CMP     AL,12           ; In the afternoon?
        JB      MORN
        MOV     BH,"p"
        JE      MORN
        SUB     AL,12           ; Keep it to 12 hours or less
MORN:
        OR      AL,AL           ; Before 1 am?
        JNZ     T24
        MOV     AL,12
T24:
        PUSH    BX
        MOV     BH,"0"-" "      ; Enable leading zero suppression
        CALL    OUT2
        CALL    P_TSEP
        MOV     AL,CL
        CALL    OUT2
        POP     BX
        PUSH    BX
        TEST    BL,80H
        JNZ     PAP             ; If from DIR, go directly to am pm
        MOV     BH,0            ; Disable leading zero suppression
        CALL    P_TSEP
        MOV     AL,DH
        CALL    OUT2
        %if NOT IBMJAPAN
        MOV     AL,"."
        STOSB
        MOV     AL,DL
        CALL    OUT2
        %endif
PAP:
        POP     BX
        TEST    BL,07FH         ; Ignore high bit
        retnz                   ; 24 hour time, no am pm
        MOV     AL,BH
        STOSB                   ; Store 'a' or 'p'
        return

P_TSEP:
        MOV     AL,[INTERNATVARS.Time_sep]
        STOSB
        return


PRMTTIM:
        MOV     DX,CURTIM_PRE
        CALL    PRINT           ; Print "Current time is "
        CALL    PRINT_TIME
        MOV     DX,CURTIM_POST
        CALL    PRINT
GETTIM:
        XOR     CX,CX           ; Initialize hours and minutes to zero
        MOV     DX,NEWTIM
        MOV     BX,".:"
        CALL    GETBUF
COMTIM:
        retz                    ; If no time present, don't change it
        JC      TIMERR
        MOV     CX,DX
        XOR     DX,DX
        LODSB
        CMP     AL,13
        JZ      SAVTIM
        CMP     AL,BL
        JZ      GOTSEC
        CMP     AL,BH
        JNZ     TIMERR
GOTSEC:
        CALL    GETNUM
        JC      TIMERR
        MOV     DH,AH           ; Position seconds
        LODSB
        CMP     AL,13
        JZ      SAVTIM
        CMP     AL,"."
        JNZ     TIMERR
        CALL    GETNUM
        JC      TIMERR
        MOV     DL,AH
        LODSB
        CMP     AL,13
        JNZ     TIMERR
SAVTIM:
        MOV     AH,SET_TIME
        INT     int_command
        OR      AL,AL
        retz                    ; Error in time?
TIMERR:
        MOV     DX,BADTIM
        CALL    PRINT           ; Print error message
        JMP     GETTIM          ; Try again

GETBUF:
        CALL    ERROR_PRINT     ; Print "Enter new time: "
        MOV     AH,STD_CON_STRING_INPUT
        MOV     DX,COMBUF
        INT     int_command             ; Get input line
        CALL    CRLF2
        MOV     SI,COMBUF+2
        CMP     byte[SI],13 ; Check if new time entered
        retz
INLINE:
        CALL    GETNUM          ; Get one or two digit number
        retc
        MOV     DH,AH           ; Put in position
        LODSB
        CMP     AL,BL
        JZ      NEXT
        CMP     AL,BH
        JZ      NEXT
        DEC     SI              ; Clears zero flag
        CLC
        MOV     DL,0
        return                  ; Time may have only an hour specified

NEXT:
        CALL    GETNUM
        MOV     DL,AH           ; Put in position
        return


; END SECTION .TRANCODE
                ; END
                                                    
                                                               