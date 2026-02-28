; TITLE   COMMAND Initialization

        %include "COMSW.ASM"

; .xlist
; .xcref
        %include "DOSSYM.ASM"
        %include "DEVSYM.ASM"
        %include "COMSEG.ASM"
; .list
; .cref

        %include "COMEQU.ASM"

ENVIRONSIZ EQU  0A0H            ;Must agree with values in EVIRONMENT segment
ENVIRONSIZ2 EQU 092H

SECTION .CODERES
        extern RSTACK,SETVECT,LODCOM,CONTC,INT_2E
        extern LOADCOM,CHKSUM

        %if IBMVER
        extern EXECHK,SYSCALL
        %endif

; END SECTION .CODERES

SECTION .DATARES
        extern DATARESEND,LTPA,MYSEG,MYSEG1,MYSEG2
        extern MEMSIZ,TRNSEG,ENVIRSEG,RSWITCHAR
        extern COMDRV,COMLET,PERMCOM,SINGLECOM
        extern PARENT,IO_SAVE,COM_PTR,COM_FCB1
        extern COM_FCB2,SUM,BATCH,COMSPEC

        %if IBMVER
        extern SYS_CALL,EXESEG,EXESUM
        %endif

; END SECTION .DATARES

SECTION .ENVIRONMENT
        extern ENVIREND,PATHSTRING,ECOMSPEC
; END SECTION .ENVIRONMENT

SECTION .TRANCODE
        extern DATINIT
; END SECTION .TRANCODE

SECTION .TRANSPACE
        extern TRANSPACEEND
; END SECTION .TRANSPACE

SECTION .ZEXEC_DATA
        %if IBM
        extern ZEXECDATAEND
        %endif
; END SECTION .ZEXEC_DATA

; *******************************************************************
; START OF INIT PORTION
; This code is overlayed the first time the TPA is used.

SECTION .INIT

        extern HEADER
        extern BADCOMLKMES

        global CONPROC

; ASSUME  CS:RESGROUP,DS:RESGROUP,ES:RESGROUP,SS:RESGROUP

        ORG     0
ZERO    =       $

CONPROC:
        MOV     SP,RSTACK

        %if HIGHMEM
        MOV     BX,word DS:[PDB_block_len]
        MOV     AX,ENVIREND + 15
        MOV     CL,4
        SHR     AX,CL
        PUSH    AX                         ; Save size to alloc
        INC     AX                         ; Plus one for arena
        SUB     BX,AX                      ; Subtract size of resident
        MOV     word DS:[PDB_block_len],BX
        MOV     AX,CS
        SUB     BX,AX
        MOV     AH,SETBLOCK
        INT     21H
        POP     BX                          ; Get back size to alloc
        MOV     AH,ALLOC
        INT     21H
        MOV     [REALRES],AX
        MOV     ES,AX
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,ENVIREND
        SHR     CX,1          ; Length of resident and environment in words
                              ; Last byte doesn't matter
        REP     MOVSW                   ; Move to end of memory
        MOV     DS,AX
        MOV     BX,AX
        MOV     AH,SET_CURRENT_PDB
        INT     21H
        MOV     AX,BX
        MOV     BX,DATARESEND + 15
        MOV     CL,4
        SHR     BX,CL           ; BX is size for SETBLOCK
        MOV     word DS:[PDB_block_len],BX
        ADD     word DS:[PDB_block_len],AX
        MOV     [LTPA],CS
        MOV     AH,SETBLOCK
        INT     21H             ;Shrink to not include environment
        MOV     BX,(ENVIRONSIZ + 15) / 16
        MOV     AH,ALLOC
        INT     21H             ;Allocate the environment
        MOV     [ENVIRSEG],AX
        MOV     CS:[ENVIRSEGSAV],AX
        MOV     ES,AX
; ASSUME  ES:ENVIRONMENT
        XOR     DI,DI
        MOV     SI,PATHSTRING
        MOV     CX,ENVIRONSIZ
        REP     MOVSB
        MOV     AX,word CS:[PDB_block_len]
        %endif

        %if NOT HIGHMEM
        MOV     AX,ENVIREND + 15
        MOV     CL,4
        SHR     AX,CL
        MOV     CX,CS
        ADD     AX,CX                         ; Compute segment of TPA
        MOV     [LTPA],AX                     ; Good enough for the moment
        MOV     AX,word DS:[PDB_block_len]
        %endif

        MOV     [MYSEG1],DS
        MOV     [MYSEG2],DS
        MOV     [MYSEG],DS
        MOV     [MEMSIZ],AX

        MOV     DX,TRANSPACEEND + 15
        MOV     CL,4
        SHR     DX,CL

        %if IBM
        PUSH    DX
        MOV     DX,ZEXECDATAEND + 15
        MOV     CL,4
        SHR     DX,CL
        POP     CX
        ADD     DX,CX
        %endif

        SUB     AX,DX
        MOV     [TRNSEG],AX                     ; Read it in here
        MOV     AX,DS:[PDB_environ]
        OR      AX,AX
        JZ      BUILDENV                        ; Need to make an environment

        %if HIGHMEM
        INC     byte CS:[CHUCKENV]          ; Flag no ENVIRONSEG
        %else
        INC     byte [CHUCKENV]             ; Flag no ENVIRONSEG
        %endif

        JMP     SHORT ENVIRONPASSED

BUILDENV:

        %if NOT HIGHMEM
        MOV     AX,PATHSTRING   ; Figure environment pointer
        MOV     CL,4
        SHR     AX,CL
        MOV     DX,DS
        ADD     AX,DX
        %else
        JMP     SHORT GOTTHEENVIR
        %endif

ENVIRONPASSED:
        MOV     [ENVIRSEG],AX

        %if HIGHMEM
        DEC     AX
        MOV     ES,AX
        INC     AX
        MOV     ES:[arena_owner],DS             ; Adjust owner of passed envir
        %endif

        MOV     ES,AX
; ASSUME  ES:ENVIRONMENT

GOTTHEENVIR:
        MOV     AX,CHAR_OPER SHL 8
        INT     int_command
        MOV     [RSWITCHAR],DL

        CMP     DL,'/'
        JNZ     IUSESLASH

        %if HIGHMEM
        MOV     CS:[COMSPECT],'\'
        %else
        MOV     [COMSPECT],'\'
        %endif

        %if HIGHMEM
        CMP     byte CS:[CHUCKENV],0
        %else
        CMP     byte [CHUCKENV],0
        %endif

        JNZ     IUSESLASH

        MOV     ES:[ECOMSPEC-10H],'\'
IUSESLASH:

%if IBMVER
        PUSH    ES
        MOV     AX,(Get_interrupt_vector SHL 8) + int_command
        INT     int_command
        MOV     word [SYS_CALL],BX
        MOV     word [SYS_CALL+2],ES
        MOV     DX,SYSCALL
        MOV     AX,(Set_interrupt_vector SHL 8) + int_command
        INT     int_command
        POP     ES
%endif

        MOV     AL,byte DS:[FCB]         ; get drive spec for default
        MOV     AH,DRVCHAR
        MOV     [COMDRV],AL
        ADD     AL,40H                  ; Convert to letter
        CMP     AL,40H
        JZ      NOCOMDRV
        STD
        %if HIGHMEM
        CMP     byte CS:[CHUCKENV],0
        %else
        CMP     byte [CHUCKENV],0
        %endif

        JNZ     NOTWIDENV

        PUSH    DS
        PUSH    ES
        POP     DS
        MOV     DI,ECOMSPEC + ENVIRONSIZ2 - 1 - 10H
        MOV     SI,ECOMSPEC + ENVIRONSIZ2 - 3 - 10H
        MOV     CX,ENVIRONSIZ2 - 2
        REP     MOVSB

        POP     DS
        MOV     word ES:[ECOMSPEC-10H],AX

NOTWIDENV:
        CLD
        %if HIGHMEM
        MOV     word CS:[AUTOBAT],AX
        %else
        MOV     word [AUTOBAT],AX
        %endif

        MOV     [COMLET],AL
NOCOMDRV:
        CALL    SETVECT         ; Set the vectors

        MOV     SI,80H
        LODSB
        MOV     CL,AL
        XOR     CH,CH
        JCXZ    COMRETURNSJ     ; No parameters
        MOV     SI,81H          ; Start of parms
CHKARG:
        LODSB
        CMP     AL,' '
        JZ      NEXTCH
        CMP     AL,9            ; Tab only other delimiter
        JZ      NEXTCH
        CMP     AL,[RSWITCHAR]   ; Switch?
        JNZ     CHKOTHERARGS    ; No
        DEC     CX
        JCXZ    ARGSDONEJ       ; oops
        LODSB
        OR      AL,20H          ; Lower case
        CMP     AL,'p'          ; PERMCOM switch
        JNZ     NEXTCH
        JMP     SETPERM

NEXTCH:
        CMP     AL,'d'
        JNZ     NEXTCH3

        %if HIGHMEM
        MOV     byte CS:[PRDATTM],1  ; User explicitly says no date time
        %else
        MOV     byte [PRDATTM],1     ; User explicitly says no date time
        %endif

        LOOP    CHKARG
        JMP     SHORT ARGSDONEJ
NEXTCH3:
        CMP     AL,'c'
        JNZ     NEXTCH2         ; SINGLECOM switch 2
        MOV     [SINGLECOM],SI  ; Point to the rest of the command line
        MOV     [PERMCOM],0     ; A SINGLECOM must not be a PERMCOM

        %if HIGHMEM
        MOV     byte CS:[PRDATTM],1  ; No date or time either, explicit
        %else
        MOV     byte [PRDATTM],1     ; No date or time either, explicit
        %endif

ARGSDONEJ:
        JMP  ARGSDONE

NEXTCH2:
        LOOP    CHKARG

COMRETURNSJ:
        JMP COMRETURNS

CHKOTHERARGS:
        DEC     SI
        MOV     DX,SI
        PUSH    CX
        PUSH    SI
CONTRLOOP:
        LODSB
        DEC     CX
        CMP     AL,' '
        JZ      SETCDEV
        CMP     AL,9
        JZ      SETCDEV
        JCXZ    SETCDEVA
        JMP     SHORT CONTRLOOP

SETCDEVA:
        INC     SI
SETCDEV:
        MOV     byte [SI-1],0
        MOV     AX,(OPEN SHL 8) OR 2    ; Read and write
        INT     int_command
        JC      CHKSRCHSPEC             ; Wasn't a file
        MOV     BX,AX
        MOV     AX,IOCTL SHL 8
        INT     int_command
        TEST    DL,80H
        JNZ     ISADEVICE
        MOV     AH,CLOSE       ; Close initial handle, wasn't a device
        INT     int_command
        JMP     CHKSRCHSPEC

ISADEVICE:
        XOR     DH,DH
        OR      DL,3            ; Make sure has CON attributes
        MOV     AX,(IOCTL SHL 8) OR 1
        INT     int_command
        MOV     DX,BX           ; Save new handle
        POP     BX              ; Throw away saved SI
        POP     BX              ; Throw away saved CX
        PUSH    CX
        MOV     CX,3
        XOR     BX,BX
RCCLLOOP:                                ; Close 0,1 and 2
        MOV     AH,CLOSE
        INT     int_command
        INC     BX
        LOOP    RCCLLOOP
        MOV     BX,DX           ; New device handle
        MOV     AH,XDUP
        INT     int_command             ; Dup to 0
        MOV     AH,XDUP
        INT     int_command             ; Dup to 1
        MOV     AH,XDUP
        INT     int_command             ; Dup to 2
        MOV     AH,CLOSE
        INT     int_command             ; Close initial handle
        POP     CX
        JCXZ    ARGSDONEJ2
        JMP     CHKARG

CHKSRCHSPEC:                    ; Not a device, so must be directory spec

        %if HIGHMEM
        MOV     byte CS:[CHUCKENV],0    ; If search specified -- no inheritance
        MOV     AX,CS:[ENVIRSEGSAV]
        MOV     [ENVIRSEG],AX
        %else
        MOV     byte [CHUCKENV],0    ; If search specified -- no inheritance
        MOV     AX,PATHSTRING   ; Figure environment pointer
        MOV     CL,4
        SHR     AX,CL
        MOV     DX,DS
        ADD     AX,DX
        MOV     [ENVIRSEG],AX
        %endif

        MOV     ES,AX
        MOV     byte [SI-1],' '
        POP     SI                      ; Remember location
        POP     CX                      ; and count

        %if HIGHMEM
        MOV     DI,CS:[ECOMLOC]
        %else
        MOV     DI,[ECOMLOC]
        %endif

COMTRLOOP:
        LODSB
        DEC     CX
        CMP     AL,' '
        JZ      SETCOMSR
        CMP     AL,9
        JZ      SETCOMSR
        STOSB

        %if KANJI
        XOR     AH,AH
        %endif

        JCXZ    SETCOMSR

        %if KANJI
        CALL    ITESTKANJ
        JZ      COMTRLOOP
        DEC     CX
        MOVSB
        INC     AH
        JCXZ    SETCOMSR
        %endif

        JMP     SHORT COMTRLOOP

SETCOMSR:
        PUSH    SI
        PUSH    CX

        PUSH    DS

        %if HIGHMEM
        PUSH    CS
        POP     DS
        %endif

        MOV     SI,COMSPECT
        MOV     CX,14

        MOV     AL,ES:[DI-1]

        %if KANJI
        OR      AH,AH
        JNZ     INOTROOT        ; Last char was KANJI second byte, might be '\'
        %endif

        CALL    PATHCHRCMPR
        JNZ     INOTROOT
        INC     SI              ; Don't make a double /
        DEC     CX
INOTROOT:
        REP     MOVSB

        MOV     DX,[ECOMLOC]    ; Now lets make sure its good!
        PUSH    ES
        POP     DS

        MOV     AX,OPEN SHL 8
        INT     int_command             ; Open COMMAND.COM
        POP     DS
        JC      SETCOMSRBAD     ; No COMMAND.COM here
        MOV     BX,AX           ; Handle
        MOV     AH,CLOSE
        INT     int_command             ; Close COMMAND.COM
SETCOMSRRET:
        POP     CX
        POP     SI
ARGSDONEJ2:
        JCXZ    ARGSDONE
        JMP     CHKARG

SETCOMSRBAD:

        %if HIGHMEM
        PUSH    DS
        PUSH    CS
        POP     DS
        %endif

        MOV     DX,BADCOMLKMES
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     int_command
        MOV     SI,COMSPECT
        MOV     DI,[ECOMLOC]
        MOV     CX,14
        REP     MOVSB           ; Get my default back

        %if HIGHMEM
        POP     DS
        %endif

        JMP     SHORT SETCOMSRRET

CHKARGJ:
        JMP    CHKARG

SETPERM:
        INC     [PERMCOM]

        %if HIGHMEM
        CMP     byte CS:[PRDATTM],-1
        %else
        CMP     byte [PRDATTM],-1
        %endif

        JNZ     LOOPIT

        %if HIGHMEM
        MOV     byte CS:[PRDATTM],0          ; If not set explicit, set to prompt
        %else
        MOV     byte [PRDATTM],0             ; If not set explicit, set to prompt
        %endif

LOOPIT:
        LOOP    CHKARGJ
ARGSDONE:
        CMP     [PERMCOM],0
        JZ      COMRETURNS
        PUSH    ES                      ; Save environment pointer
        MOV     AH,SET_CURRENT_PDB
        MOV     BX,DS
        MOV     ES,BX
        INT     int_command                     ; Current process is me
        MOV     DI,PDB_Exit             ; Diddle the addresses in my header
        MOV     AX,LODCOM
        STOSW
        MOV     AX,DS
        STOSW
        MOV     AX,CONTC
        STOSW
        MOV     AX,DS
        STOSW
        MOV     word DS:[PDB_Parent_PID],DS ; Parent is me forever
        MOV     DX,INT_2E
        MOV     AX,(SET_INTERRUPT_VECTOR SHL 8) OR 02EH
        INT     int_command                     ;Set magic interrupt
        POP     ES                              ;Remember environment
COMRETURNS:
        MOV     AX,word DS:[PDB_Parent_PID]
        MOV     [PARENT],AX                     ; Save parent
        MOV     word DS:[PDB_Parent_PID],DS ; Parent is me
        MOV     AX,word DS:[PDB_JFN_Table]
        MOV     [IO_SAVE],AX                    ; Get the default stdin and out
        MOV     word [COM_PTR+2],DS         ; Set all these to resident
        MOV     word [COM_FCB1+2],DS
        MOV     word [COM_FCB2+2],DS
        MOV     DI,COMSPEC

        %if HIGHMEM
        MOV     SI,CS:[ECOMLOC]
        CMP     byte CS:[CHUCKENV],0
        %else
        MOV     SI,[ECOMLOC]
        CMP     byte [CHUCKENV],0
        %endif

        MOV     AX,DS                   ; XCHG ES,DS
        PUSH    ES
        POP     DS
        MOV     ES,AX

        JZ      COPYCOMSP               ; All set up for copy

        PUSH    CS
        POP     DS

        MOV     SI,COMSPSTRING
        PUSH    ES
        PUSH    DI
        CALL    IFINDE
        MOV     SI,DI
        PUSH    ES
        POP     DS
        POP     DI
        POP     ES
        JNC     COPYCOMSP
COMSPECNOFND:

        %if HIGHMEM
        MOV     DS,CS:[ENVIRSEG]
        MOV     SI,CS:[ECOMLOC]
        %else
        MOV     SI,[ECOMLOC]
        ADD     SI,PATHSTRING
        PUSH    CS
        POP     DS
        %endif

COPYCOMSP:
        LODSB
        STOSB
        OR      AL,AL
        JNZ     COPYCOMSP

        %if HIGHMEM
        MOV     DS,CS:[REALRES]
        PUSH    CS
        POP     ES
        MOV     AH,DEALLOC
        INT     21H
        CMP     byte CS:[CHUCKENV],0
        JZ      GOTENVIR                ; Environment is ok
        MOV     ES,CS:[ENVIRSEGSAV]
        MOV     AH,DEALLOC
        INT     21H
        %else
        PUSH    CS
        POP     DS
        MOV     BX,DATARESEND + 15
        MOV     CL,4
        SHR     BX,CL
        MOV     AH,SETBLOCK
        INT     int_command                     ; Shrink me to the resident only
        CMP     byte [CHUCKENV],0
        JNZ     GOTENVIR                ; Environment was passed
        MOV     BX,(ENVIRONSIZ + 15) /16
        MOV     AH,ALLOC
        INT     int_command                     ; "ALLOCATE" the environment
        MOV     DS,[ENVIRSEG]
        MOV     [ENVIRSEG],AX
        MOV     ES,AX
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,ENVIRONSIZ
        REP     MOVSB
        PUSH    CS
        POP     DS
        %endif

GOTENVIR:
        CALL    LOADCOM                 ; Load the transient in the right place
        CALL    CHKSUM                  ; Compute the checksum
        MOV     [SUM],DX                ; Save it
%if IBM
        MOV     AX,[MEMSIZ]
        MOV     DX,ZEXECDATAEND + 15
        MOV     CL,4
        SHR     DX,CL
        SUB     AX,DX
        MOV     [EXESEG],AX
        CALL    EXECHK
        MOV     [EXESUM],DX
%endif
        %if MSVER
        CMP     [SINGLECOM],0
        JNZ     NOPHEAD                 ; Don't print header if SINGLECOM
        %if HIGHMEM
        PUSH    DS
        PUSH    CS
        POP     DS
        %endif
        MOV     DX,HEADER
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     int_command
        %if HIGHMEM
        POP     DS
        %endif
NOPHEAD:
        %endif

        %if HIGHMEM
        CMP     byte CS:[PRDATTM],0
        %else
        CMP     byte [PRDATTM],0
        %endif

        JNZ     NODTTM                  ; Don't do AUTOEXEC or date time
        MOV     BX,3                    ; 48 BYTES ENOUGH
        MOV     AH,ALLOC
        INT     int_command
        JC      DODTTM                  ; PRETEND NO BATCH
        MOV     [BATCH],AX
        MOV     ES,AX
        XOR     DI,DI

        %if HIGHMEM
        CMP     byte CS:[AUTOBAT],0
        %else
        CMP     byte [AUTOBAT],0
        %endif

        JNZ     NOAUTSET
        MOV     AH,GET_DEFAULT_DRIVE
        INT     int_command
        ADD     AL,'A'

        %if HIGHMEM
        MOV     CS:[AUTOBAT],AL
        %else
        MOV     [AUTOBAT],AL
        %endif

NOAUTSET:

        %if HIGHMEM
        PUSH    DS
        PUSH    CS
        POP     DS
        %endif

        MOV     SI,AUTOBAT
        MOV     CX,8
        REP     MOVSW   ; NAME
        MOV     AX,-1
        MOV     CL,10
        REP     STOSW   ; PARMS
        MOV     DX,AUTOBAT
        MOV     AX,OPEN SHL 8
        INT     int_command                      ; See if AUTOEXEC.BAT exists
        JC      NOABAT
        MOV     BX,AX
        MOV     AH,CLOSE
        INT     int_command

        %if HIGHMEM
        POP     DS
        %endif

        JMP     SHORT DRV0

NOABAT:

        %if HIGHMEM
        POP     DS
        %endif

        MOV     ES,[BATCH]      ; Not found--turn off batch job
        MOV     AH,DEALLOC
        INT     int_command
        MOV     [BATCH],0       ; AFTER DEALLOC in case of ^C
DODTTM:

        %if HIGHMEM
        MOV     AX,DATINIT
        MOV     word CS:[INITADD],AX
        MOV     AX,[TRNSEG]
        MOV     word CS:[INITADD+2],AX
        CALL    dword CS:[INITADD]
        %else
        MOV     AX,DATINIT
        MOV     word[INITADD],AX
        MOV     AX,[TRNSEG]
        MOV     word[INITADD+2],AX
        CALL    dword [INITADD]
        %endif

NODTTM:

        %if IBMVER
        CMP     [SINGLECOM],0
        JNZ     DRV0                    ; Don't print header if SINGLECOM
        MOV     DX,HEADER
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     int_command
        %endif

DRV0:
        %if HIGHMEM
        PUSH    DS
        MOV     AX,LODCOM
        PUSH    AX
MQQ:
        RET
; ENDP MQQ
        %else
        JMP     LODCOM                  ; Allocate the transient
        %endif

PATHCHRCMPR:
        CMP     [RSWITCHAR],'/'
        JZ      RNOSLASHT
        CMP     AL,'/'
        JZ      RET41
RNOSLASHT:
        CMP     AL,'\'
RET41:
        RET


IFINDE:
        CALL    IFIND                    ; FIND THE NAME
        JC      IFIND2                   ; CARRY MEANS NOT FOUND
        JMP     ISCASB1                  ; SCAN FOR = SIGN
;
; On return of FIND1, ES:DI points to beginning of name
;
IFIND:
        CLD

        CALL    ICOUNT0                  ; CX = LENGTH OF NAME

        %if HIGHMEM
        MOV     ES,CS:[REALRES]
; ASSUME  ES:RESGROUP
        MOV     ES,ES:[ENVIRSEG]
; ASSUME  ES:NOTHING
        %else
        MOV     ES,[ENVIRSEG]
        %endif

        XOR     DI,DI
IFIND1:
        PUSH    CX
        PUSH    SI
        PUSH    DI
IFIND11:
        LODSB

        %if KANJI
        CALL    ITESTKANJ
        JZ      NOTKANJ4
        DEC     SI
        LODSW
        INC     DI
        INC     DI
        CMP     AX,ES:[DI-2]
        JNZ     IFIND12
        DEC     CX
        LOOP    IFIND11
        JMP     SHORT IFIND12

NOTKANJ4:
        %endif

        CALL    IUPCONV
        INC     DI
        CMP     AL,ES:[DI-1]
        JNZ     IFIND12
        LOOP    IFIND11
IFIND12:
        POP     DI
        POP     SI
        POP     CX
        JZ      IFIND2
        PUSH    CX
        CALL    ISCASB2                  ; SCAN FOR A NUL
        POP     CX
        CMP     byte ES:[DI],0
        JNZ     IFIND1
        STC                             ; INDICATE NOT FOUND
IFIND2:
        RET

ICOUNT0:
        PUSH    DS
        POP     ES
        MOV     DI,SI

        PUSH    DI                      ; COUNT NUMBER OF CHARS UNTIL "="
        CALL    ISCASB1
        JMP     SHORT ICOUNTX
        PUSH    DI                      ; COUNT NUMBER OF CHARS UNTIL NUL
        CALL    ISCASB2
ICOUNTX:
        POP     CX
        SUB     DI,CX
        XCHG    DI,CX
        RET

ISCASB1:
        MOV     AL,"="                  ; SCAN FOR AN =
        JMP     SHORT ISCASBX
ISCASB2:
        XOR     AL,AL                   ; SCAN FOR A NUL
ISCASBX:
        MOV     CX,100H
        REPNZ   SCASB
        RET

        %if KANJI
ITESTKANJ:
        CMP     AL,81H
        JB      NOTLEAD
        CMP     AL,9FH
        JBE     ISLEAD
        CMP     AL,0E0H
        JB      NOTLEAD
        CMP     AL,0FCH
        JBE     ISLEAD
NOTLEAD:
        PUSH    AX
        XOR     AX,AX           ;Set zero
        POP     AX
        RET

ISLEAD:
        PUSH    AX
        XOR     AX,AX           ;Set zero
        INC     AX              ;Reset zero
        POP     AX
        RET
        %endif

IUPCONV:
        CMP     AL,"a"
        JB      IRET22
        CMP     AL,"z"
        JA      IRET22
        SUB     AL,20H          ; Lower-case changed to upper-case
IRET22:
        RET

ICONDEV:
        DB      "/DEV/"
        DB      "CON",0,0,0,0,0,0          ; Room for 8 char device
BADCSPFL DB     0
COMSPECT DB     "/COMMAND.COM",0,0
AUTOBAT DB      0,":\AUTOEXEC.BAT",0

PRDATTM DB      -1                      ;Init not to prompt for date time
INITADD: dd 0
CHUCKENV DB     0
ECOMLOC DW      ECOMSPEC-10H

        %if HIGHMEM
REALRES: dw 0
ENVIRSEGSAV: dw 0
        %endif

COMSPSTRING DB  "COMSPEC="


; END SECTION .INIT

        ; END
                                                              