; TITLE   BIOS SYSTEM INITIALIZATION

FALSE   EQU     0
TRUE    EQU     NOT FALSE

IBMVER     EQU     FALSE
IBM        EQU     IBMVER
IBMJAPVER  EQU     FALSE                ; If TRUE set KANJI true also
MSVER      EQU     TRUE 
ALTVECT    EQU     FALSE                ; Switch to build ALTVECT version
HIGHMEM    EQU     FALSE
KANJI      EQU     FALSE

        %if IBMVER OR IBMJAPVER
NOEXEC  EQU     TRUE
        %else
NOEXEC  EQU     FALSE
        %endif

; Set to agree with those in DOST:MSHEAD.ASM, ALTVECT version only
MAJOR_VERSION   EQU      2
MINOR_VERSION   EQU     0B	;2.11

DOSSIZE EQU     5000H

; Internal DOS data returned by DOSINIT

struc SYSINITVAR
DPBHEAD: dd 0; Pointer to head of DPB-FAT list
sft_addr: dd 0; Pointer to first FCB table
; The following address points to the CLOCK device
BCLOCK: dd 0
; The following address is used by DISKSTATCHK it is always
; points to the console input device header
BCON: dd 0; Console device entry points
NUMIO       DB      0                   ; Number of disk tables
MAXSEC      DW      0                   ; Maximum allowed sector size
BUFFHEAD: dd 0; Head of buffer queue
DEVHEAD: dd 0
endstruc

        %include "DOSSYM.ASM"
        %include "DEVSYM.ASM"

        %if NOT IBM
        %if NOT IBMJAPVER
        extern RE_INIT
        %endif
        %endif

SECTION .SYSINITSEG

; ASSUME  CS:SYSINITSEG,DS:NOTHING,ES:NOTHING,SS:NOTHING

        extern BADOPM,CRLFM,BADCOM
        extern BADSIZ_PRE,BADLD_PRE
        extern BADSIZ_POST,BADLD_POST
        extern SYSSIZE,BADCOUNTRY

        global CURRENT_DOS_LOCATION
        global FINAL_DOS_LOCATION
        global DEVICE_LIST
        global MEMORY_SIZE
        global DEFAULT_DRIVE
        global BUFFERS
        global FILES
        global SYSINIT

        %if HIGHMEM
        global DPBBUF_SIZ
        %endif

SYSINIT:
        JMP     GOINIT

DOSINFO:
                        DW      0000
CURRENT_DOS_LOCATION    DW      0000

MSDOS:
ENTRY_POINT:
                        DW      0000
FINAL_DOS_LOCATION      DW      0000
DEVICE_LIST             DD      00000000

        %if HIGHMEM
DPBBUF_SIZ              DW      (4472  + 15) / 16
        %endif

MEMORY_SIZE             DW      0001
DEFAULT_DRIVE           DB      00
BUFFERS                 DB      2
FILES                   DB      8
COMMAND_LINE            DB      2,0,"P" ; Default Command.com Args
                        times 29 db 0
ZERO                    DB      0

        %if NOT NOEXEC
COMEXE  EXEC0 <0,COMMAND_LINE,DEFAULT_DRIVE,ZERO>
        %endif

COUNT   DW      0000
CHRPTR  DW      0000

BUFPTR:; LEAVE THIS STUFF IN ORDER!
MEMLO   DW      0
PRMBLK:
MEMHI   DW      0
LDOFF   DW      0
AREA    DW      0

PACKET                  DB      22
                        DB      0
                        DB      0       ; INITIALIZE CODE
                        DW      0
                        times 8 db 0
UNITCOUNT               DB      0
BREAK_ADDR              DD      0
BPB_ADDR                DD      0

GOINIT:
        CLD
        XOR     SI,SI
        MOV     DI,SI

        %if MSVER
        MOV     CX,[MEMORY_SIZE]
        CMP     CX,1
        JNZ     NOSCAN
        MOV     CX,2048                 ; START SCANNING AT 32K BOUNDARY
        XOR     BX,BX

MEMSCAN:INC     CX
        JZ      SETEND
        MOV     DS,CX
        MOV     AL,[BX]
        NOT     AL
        MOV     [BX],AL
        CMP     AL,[BX]
        NOT     AL
        MOV     [BX],AL
        JZ      MEMSCAN
SETEND:
        MOV     [MEMORY_SIZE],CX
        %endif

        %if IBMVER OR IBMJAPVER
        MOV     CX,[MEMORY_SIZE]
        %endif

NOSCAN:
        MOV     AX,CS
        MOV     DS,AX
; ASSUME  DS:SYSINITSEG

        %if HIGHMEM
        SUB     CX,(DOSSIZE / 16)       ; Leave room for DOS
        SUB     CX,CS:[DPBBUF_SIZ]      ; Allow OEM to tune
        %endif

        MOV     AX,SYSSIZE + 15
        SHR     AX,1                    ; Divide by 16 for paras
        SHR     AX,1
        SHR     AX,1
        SHR     AX,1
        SUB     CX,AX
        MOV     ES,CX
        MOV     CX,SYSSIZE + 1
        SHR     CX,1                    ; Divide by 2 to get words
        REP     MOVSW                   ; RELOCATE SYSINIT

        ; ASSUME  ES:SYSINITSEG

        PUSH    ES
        MOV     AX,SYSIN
        PUSH    AX

AAA:
        RET
; ENDP AAA
;
;       MOVE THE DOS TO ITS PROPER LOCATION
;
SYSIN:

        ; ASSUME  DS:NOTHING,ES:SYSINITSEG,SS:NOTHING

        MOV     AX,[CURRENT_DOS_LOCATION]
        MOV     DS,AX
        MOV     AX,[FINAL_DOS_LOCATION]
        MOV     ES,AX

        ; ASSUME  ES:NOTHING

        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,DOSSIZE/2
        REP     MOVSW

        LDS     SI,[DEVICE_LIST]
        MOV     DX,[MEMORY_SIZE]

        CLI
        MOV     AX,CS
        MOV     SS,AX
        MOV     SP,LOCSTACK

        ; ASSUME  SS:SYSINITSEG

        %if NOT ALTVECT
        STI                             ; Leave INTs disabled for ALTVECT
        %endif
LOCSTACK:

        CALL    MSDOS
        MOV     word [DOSINFO+2],ES ; SAVE POINTER TO DOS INFO
        MOV     word [DOSINFO],DI

        %if NOT IBM
        %if NOT IBMJAPVER
        CALL    RE_INIT                 ; Re-call the BIOS
        %endif
        %endif

        STI
        CLD

        %if HIGHMEM
        PUSH    DS
        MOV     BX,DS
        ADD     BX,10H
        MOV     ES,BX
        PUSH    CS
        POP     DS
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,SYSSIZE + 1
        SHR     CX,1                    ; Divide by 2 to get words
        REP     MOVSW
        POP     DS
        PUSH    ES
        MOV     AX,SECONDRELOC
        PUSH    AX
BBB:
        RET
; ENDP BBB

SECONDRELOC:
        MOV     AX,CS
        CLI
        MOV     SS,AX
        MOV     SP,LOCSTACK
        STI
      %else
        MOV     BX,CS
        SUB     BX,10H
        MOV     ES,BX
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,80H
        REP     MOVSW
        MOV     AH,SET_CURRENT_PDB
        INT     21H
        %endif

        PUSH    DS
        PUSH    CS
        POP     DS
        MOV     DX,INT24         ; SET UP INT 24 HANDLER
        MOV     AX,(SET_INTERRUPT_VECTOR SHL 8) OR 24H
        INT     21H

        %if ALTVECT
        MOV     DX,BOOTMES
        CALL    PRINT                   ; Print message DOSINIT couldn't
        %endif

        POP     DS

        MOV     DL,[DEFAULT_DRIVE]
        OR      DL,DL
        JZ      NODRVSET
        DEC     DL                      ; A = 0
        MOV     AH,SET_DEFAULT_DRIVE
        INT     21H                     ; SELECT THE DISK
NODRVSET:

        CALL    DOCONF                  ; DO THE CONFIG STUFF

        %if HIGHMEM
        PUSH    DS
        MOV     AX,SYSSIZE + 15
        MOV     CL,4
        SHR     AX,CL                   ; Divide by 16 to get para
        MOV     CX,ES
        SUB     CX,AX
        MOV     ES,CX
        PUSH    CS
        POP     DS
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,SYSSIZE + 1
        SHR     CX,1                    ; Divide by 2 to get words
        REP     MOVSW
        POP     DS
        PUSH    ES
        MOV     AX,THIRDRELOC
        PUSH    AX
CCC:
        RET
; ENDP CCC

THIRDRELOC:
        MOV     AX,CS
        CLI
        MOV     SS,AX
        MOV     SP,LOCSTACK
        STI
        %endif

        %if NOEXEC
        MOV     BP,DS                   ; SAVE COMMAND.COM SEGMENT

        PUSH    DS
        POP     ES

        MOV     BX,CS
        SUB     BX,10H
        MOV     DS,BX
        XOR     SI,SI
        MOV     DI,SI
        MOV     CX,80H
        REP     MOVSW
        MOV     BX,ES
        MOV     AH,SET_CURRENT_PDB
        INT     21H

        MOV     ES:[PDB_PARENT_PID],ES  ; WE ARE THE ROOT
        %endif

        PUSH    CS
        POP     DS
; ASSUME  DS:SYSINITSEG
        MOV     AL,[FILES]
        CBW
        MOV     CX,AX
        XOR     BX,BX                   ; Close standard input
        MOV     AH,CLOSE
        INT     21H
        MOV     BX,2
RCCLLOOP:                               ; Close everybody but standard output
        MOV     AH,CLOSE
        INT     21H
        INC     BX
        LOOP    RCCLLOOP

        MOV     DX,CONDEV
        MOV     AL,2
        MOV     AH,OPEN                 ; OPEN CON FOR READ/WRITE
        STC
        INT     21H
        JNC     GOAUX
        CALL    BADFIL
        JMP     SHORT GOAUX2

GOAUX:  PUSH    AX
        MOV     BX,1                    ; close standard output
        MOV     AH,CLOSE
        INT     21H
        POP     AX

        MOV     BX,AX                   ; New device handle
        MOV     AH,XDUP
        INT     21H                     ; Dup to 1, STDOUT
        MOV     AH,XDUP
        INT     21H                     ; Dup to 2, STDERR

GOAUX2: MOV     DX,AUXDEV
        MOV     AL,2                    ; READ/WRITE ACCESS
        CALL    OPEN_DEV

        MOV     DX,PRNDEV
        MOV     AL,1                    ; WRITE ONLY
        CALL    OPEN_DEV
;
; SET UP THE PARAMETERS FOR COMMAND
;
GOSET:
        MOV     SI,COMMAND_LINE+1

        %if NOEXEC
        MOV     DI,81H
        %else
        PUSH    DS
        POP     ES
        MOV     DI,SI
        %endif

        MOV     CL,-1
COMTRANLP:                              ; FIND LENGTH OF COMMAND LINE
        INC     CL
        LODSB
        STOSB                           ; COPY COMMAND LINE IN
        OR      AL,AL
        JNZ     COMTRANLP
        DEC     DI
        MOV     AL,0DH
        STOSB

        %if NOEXEC
        MOV     ES:[80H],CL
        MOV     AL,[DEFAULT_DRIVE]
        MOV     ES:[5CH],AL
        %else
        MOV     [COMMAND_LINE],CL       ; Count
        %endif

        PUSH    CS
        POP     ES

        ; ASSUME  ES:SYSINITSEG

        MOV     DX,COMMND        ; NOW POINTING TO FILE DESCRIPTION

        %if NOEXEC
        MOV     ES,BP                   ; SET LOAD ADDRESS
        MOV     BX,100H
        CALL    LDFIL                   ; READ IN COMMAND
        JC      COMERR
        MOV     DS,BP
        CLI
        MOV     DX,80H
        MOV     SS,BP
        MOV     SP,DX
        STI

        XOR     AX,AX                   ; PUSH A WORD OF ZEROS
        PUSH    AX
        MOV     AH,SET_DMA              ; SET DISK TRANFER ADDRESS
        INT     21H
        PUSH    BP                      ; SET HIGH PART OF JUMP ADDRESS
        MOV     AX,100H
        PUSH    AX                      ; SET LOW PART OF JUMP ADDRESS
CCC:
        RET                             ; CRANK UP COMMAND!
; ENDP CCC

        %else
        MOV     BX,COMEXE
        MOV     word [BX.EXEC0_COM_LINE+2],CS
        MOV     word [BX.EXEC0_5C_FCB+2],CS
        MOV     word [BX.EXEC0_6C_FCB+2],CS

        XOR     AX,AX
        MOV     AH,EXEC
        STC                             ; IN CASE OF INT 24
        INT     21H                     ; GO START UP COMMAND
        %endif

COMERR:
        MOV     DX,BADCOM        ; WANT TO PRINT COMMAND ERROR
        CALL    BADFIL
STALL:  JMP     STALL

DOCONF:
        PUSH    CS
        POP     DS

        ; ASSUME  DS:SYSINITSEG

        MOV     BX,0FFFFH
        MOV     AH,ALLOC
        INT     21H                     ; FIRST TIME FAILS
        MOV     AH,ALLOC
        INT     21H                     ; SECOND TIME GETS IT
        MOV     [AREA],AX

        %if HIGHMEM
        ADD     AX,BX
        %endif

        MOV     [MEMHI],AX

        MOV     AX,(CHAR_OPER SHL 8)    ; GET SWITCH CHARACTER
        INT     21H
        MOV     [COMMAND_LINE+1],DL

        MOV     DX,CONFIG        ; NOW POINTING TO FILE DESCRIPTION
        MOV     AX,OPEN SHL 8           ; OPEN FILE "CONFIG.SYS"
        STC                             ; IN CASE OF INT 24
        INT     21H                     ; FUNCTION REQUEST
        JC      ENDFILE
        JMP     NOPROB                  ; PROBLEM WITH OPEN

ENDFILE:
        PUSH    CS
        POP     DS
        CALL    ROUND
        MOV     AL,[FILES]
        SUB     AL,5
        JBE     DOBUFF
        CBW

        %if HIGHMEM
        PUSH    AX
        MOV     BL,SF_ENTRY_size
        MUL     BL
        ADD     AX,15+6
        MOV     CL,4
        SHR     AX,CL
        SUB     [MEMHI],AX
        POP     AX
        %endif

        MOV     BX,[MEMLO]
        MOV     DX,[MEMHI]
        LDS     DI,[DOSINFO]            ; GET POINTER TO DOS DATA
        LDS     DI,[DI+SFT_ADDR]        ; DS:BP POINTS TO SFT
        MOV     word [DI+SFT_LINK],BX
        MOV     word [DI+SFT_LINK+2],DX ; SET POINTER TO NEW SFT
        PUSH    CS
        POP     DS
        LES     DI,dword [MEMLO]    ; POINT TO NEW SFT
        MOV     word ES:[DI+SFT_LINK],-1
        MOV     ES:[DI+SFT_COUNT],AX
        MOV     BL,SF_ENTRY_size
        MUL     BL                      ; AX = NUMBER OF BYTES TO CLEAR
        MOV     CX,AX

        %if HIGHMEM
        MOV     AX,6
        %else
        ADD     [MEMLO],AX              ; ALLOCATE MEMORY
        MOV     AX,6
        ADD     [MEMLO],AX              ; REMEMBER THE HEADER TOO
        %endif

        ADD     DI,AX
        XOR     AX,AX
        REP     STOSB                   ; CLEAN OUT THE STUFF

DOBUFF: CALL    ROUND

        DEC     [BUFFERS]
        JZ      BUF1

        PUSH    DS
        LES     DI,BUFPTR
        LDS     BX,DOSINFO

        %if HIGHMEM
        MOV     AX,[BX.MAXSEC]
        ADD     AX,BUFINSIZ + 15
        MOV     CL,4
        SHR     AX,CL
        SUB     CS:[MEMHI],AX
        MOV     ES,CS:[MEMHI]
        %endif

        MOV     AX,word [BX.BUFFHEAD]
        MOV     word ES:[DI.NEXTBUF],AX
        MOV     AX,word [BX.BUFFHEAD+2]
        MOV     word ES:[DI.NEXTBUF+2],AX

        MOV     word [BX.BUFFHEAD],DI
        MOV     word [BX.BUFFHEAD+2],ES

        MOV     word ES:[DI.BUFDRV],00FFH   ; NEW BUFFER FREE
        MOV     BX,[BX.MAXSEC]
        POP     DS

        %if NOT HIGHMEM
        ADD     BX,BUFINSIZ
        ADD     [MEMLO],BX
        %endif

        JMP     DOBUFF

BUF1:   CALL    ROUND
        MOV     BX,[MEMHI]
        MOV     AX,[AREA]
        MOV     ES,AX                   ; CALC WHAT WE NEEDED
        SUB     BX,AX

        %if HIGHMEM
        DEC     BX                      ; Arena
        PUSH    BX
        %endif

        MOV     AH,SETBLOCK
        INT     21H                     ; GIVE THE REST BACK

        %if NOT HIGHMEM
        PUSH    ES
        MOV     AX,ES
        DEC     AX
        MOV     ES,AX
        MOV     ES:[arena_owner],8      ; Set impossible owner
        POP     ES
        %endif

        %if HIGHMEM
        MOV     BX,0FFFFH
        MOV     AH,ALLOC
        INT     21H
        MOV     AH,ALLOC
        INT     21H

        PUSH    ES
        DEC     AX
        MOV     ES,AX
        MOV     ES:[arena_owner],8      ; Set impossible owner
        POP     ES

        %if NOT NOEXEC
        MOV     ES,[AREA]
        MOV     AH,DEALLOC
        INT     21H
        %endif

        POP     BX
        MOV     AX,[AREA]
        MOV     DS,AX
        ADD     AX,BX
        MOV     ES,AX
      %else
        %if NOEXEC
        MOV     BX,0FFFFH               ; ALLOCATE THE REST OF MEM FOR COMMAND
        MOV     AH,ALLOC
        INT     21H
        MOV     AH,ALLOC
        INT     21H
        MOV     DS,AX
        %endif
        %endif

        RET

BADOP:  MOV     DX,BADOPM        ; WANT TO PRINT COMMAND ERROR
        CALL    PRINT
        JMP     COFF

NOPROB:                                 ; GET FILE SIZE (NOTE < 64K!!)
        MOV     BX,AX
        XOR     CX,CX
        XOR     DX,DX
        MOV     AX,(LSEEK SHL 8) OR 2
        INT     21H
        MOV     [COUNT],AX
        XOR     DX,DX
        MOV     AX,LSEEK SHL 8          ; Reset pointer to beginning of file
        INT     21H
        MOV     DX,CS

        %if HIGHMEM
        MOV     AX,SYSSIZE + 15
        MOV     CL,4
        SHR     AX,CL
        ADD     DX,AX
        %else
        MOV     AX,[COUNT]
        ADD     AX,15
        MOV     CL,4
        SHR     AX,CL                   ; NUMBER OF SEGMENTS
        SUB     DX,AX
        SUB     DX,11H                  ; ROOM FOR HEADER
        %endif

        MOV     DS,DX
        MOV     ES,DX
; ASSUME  DS:NOTHING,ES:NOTHING
        XOR     DX,DX
        MOV     CX,[COUNT]
        MOV     AH,READ
        STC                             ; IN CASE OF INT 24
        INT     21H                     ; Function request
        PUSHF
        PUSH    CS
        POP     DS
; ASSUME  DS:SYSINITSEG
        PUSH    AX
        MOV     AH,CLOSE
        INT     21H
        POP     AX
        POPF
        JC      CONFERR                 ; IF NOT WE'VE GOT A PROBLEM
        CMP     CX,AX
        JZ      GETCOM                  ; COULDN'T READ THE FILE
CONFERR:
        MOV     DX,CONFIG        ; WANT TO PRINT CONFIG ERROR
        CALL    BADFIL
ENDFILV:JMP     ENDFILE

GETCOM:
        CALL    ORGANIZE                ; ORGANIZE THE FILE
        CALL    GETCHR

CONFLP: JC      ENDFILV
        MOV     AH,AL
        CALL    GETCHR

        CMP     AH,'B'                  ; BUFFER COMMAND?
        JNZ     TRYC
        CALL    GETNUM
        JZ      COFF
        CMP     AX,100
        JAE     badop
        MOV     [BUFFERS],AL
        JMP     SHORT COFF

TRYC:   CMP     AH,'C'
        JZ      GOTC
        JMP     TRYD
GOTC:
        CMP     AL,'O'                  ; FIRST LETTER OF "ON"
        JNZ     COFF
        CALL    GETCHR
        JC      ENDFILV
        CMP     AL,'N'                  ; SECOND LETTER OF "ON"
        JNZ     COFF
        MOV     AH,SET_CTRL_C_TRAPPING  ; TURN ON CONTROL-C CHECK
        MOV     AL,1
        MOV     DL,AL
        INT     21H

COFF:   PUSH    CS
        POP     DS
        CALL    NEWLINE
        JMP     CONFLP

TRYD:   CMP     AH,'D'
        JZ      GOTD
        JMP     TRYF
GOTD:   MOV     BX,CS
        MOV     DS,BX

        MOV     word [BPB_ADDR],SI
        MOV     word [BPB_ADDR+2],ES

        CALL    ROUND

        %if HIGHMEM
        PUSH    DS
        PUSH    ES
        POP     DS
        MOV     DX,SI
        MOV     AX,OPEN SHL 8
        STC                             ; In case INT 24H
        INT     21H
        POP     DS
        JC      BADBRK
        MOV     BX,AX
        XOR     DX,DX
        MOV     CX,DX
        MOV     AX,(LSEEK SHL 8) OR 2
        INT     21H
        PUSH    AX
        MOV     AH,CLOSE
        INT     21H
        POP     AX                      ; DX:AX is size of file
        ADD     AX,15
        ADC     DX,0
        MOV     CL,4
        SHR     AX,CL
        MOV     CL,12
        SHL     DX,CL
        OR      AX,DX                   ; AX is size in PARA
        MOV     CX,[MEMHI]
        SUB     [MEMHI],AX
        JNC     SIZEOK
        MOV     [MEMHI],CX              ; Not enough memory
        JMP     SHORT BADBRK
SIZEOK:
        MOV     BX,CS
        %endif

        XOR     AX,AX
        MOV     word [ENTRY_POINT],AX
        MOV     AX,[MEMHI]
        MOV     word [ENTRY_POINT+2],AX ; SET ENTRY POINT


        %if NOT NOEXEC
        MOV     [LDOFF],AX              ; SET LOAD OFFSET
        %endif

        PUSH    ES
        POP     DS
        MOV     DX,SI                   ; DS:DX POINTS TO FILE NAME

        %if NOEXEC
        LES     BX,dword CS:[MEMLO]
        CALL    LDFIL                   ; LOAD IN THE DEVICE DRIVER
        %else
        MOV     ES,BX
        MOV     BX,PRMBLK        ; ES:BX POINTS TO PARAMETERS
        MOV     AL,3
        MOV     AH,EXEC
        STC                             ; IN CASE OF INT 24
        INT     21H                     ; LOAD IN THE DEVICE DRIVER
        %endif

        PUSH    DS
        POP     ES                      ; ES:SI BACK TO CONFIG.SYS
        PUSH    CS
        POP     DS                      ; DS BACK TO SYSINIT
        JNC     GOODLD
BADBRK: CALL    BADLOAD
        JMP     COFF

GOODLD: PUSH    ES                      ; INITIALIZE THE DEVICE
        PUSH    SI

        PUSH    CS
        POP     ES
        MOV     BX,SDEVSTRAT
        CALL    CALLDEV
        MOV     BX,SDEVINT
        CALL    CALLDEV

        PUSH    CS
        POP     DS

        %if NOT HIGHMEM
        MOV     AX,word [BREAK_ADDR+2]  ; REMOVE THE INIT CODE
        CMP     AX,[MEMORY_SIZE]
        JB      BREAKOK
        POP     SI
        POP     ES
        JMP     BADBRK
BREAKOK:

        MOV     [MEMHI],AX
        MOV     AX,word [BREAK_ADDR]; REMOVE THE INIT CODE
        MOV     [MEMLO],AX
        %endif

        LDS     DX,[ENTRY_POINT]        ; SET DS:DX TO HEADER
        MOV     SI,DX
        ADD     SI,SDEVATT              ; DS:SI POINTS TO ATTRIBUTES
        LES     DI,CS:[DOSINFO]         ; ES:DI POINT TO DOS INFO
        MOV     AX,DS:[SI]              ; GET ATTRIBUTES
        TEST    AX,DEVTYP               ; TEST IF BLOCK DEV
        JZ      ISBLOCK

        TEST    AX,ISCIN                ; IS IT A CONSOLE IN?
        JZ      TRYCLK
        MOV     word ES:[DI.BCON],DX
        MOV     word ES:[DI.BCON+2],DS

TRYCLK: TEST    AX,ISCLOCK              ; IS IT A CLOCK DEVICE?
        JZ      GOLINK
        MOV     word ES:[DI+BCLOCK],DX
        MOV     word ES:[DI+BCLOCK+2],DS
GOLINK: JMP     LINKIT

ISBLOCK:
        MOV     AL,CS:[UNITCOUNT]       ; IF NO UNITS FOUND....
        OR      AL,AL
        JNZ     PERDRV

        %if NOT HIGHMEM
        MOV     CS:[MEMLO],0            ; ...ERASE THE DEVICE
        %endif

        MOV     AX,-1
        JMP     ENDDEV

PERDRV:
        CBW
        MOV     CX,AX
        MOV     DH,AH
        MOV     DL,ES:[DI.NUMIO]        ; GET NUMBER OF DEVICES
        ADD     ES:[DI.NUMIO],AL        ; UPDATE THE AMOUNT

        LDS     BX,CS:[BPB_ADDR]        ; POINT TO BPB ARRAY
PERUNIT:
        LES     BP,CS:[DOSINFO]
        LES     BP,dword ES:[BP.DPBHEAD]; GET FIRST DPB

SCANDPB:CMP     word ES:[BP.DPB_NEXT_DPB],-1
        JZ      FOUNDPB
        LES     BP,ES:[BP.DPB_NEXT_DPB]
        JMP     SCANDPB
FOUNDPB:
        MOV     AX,CS:[MEMLO]
        MOV     word ES:[BP.DPB_NEXT_DPB],AX

        %if HIGHMEM
        MOV     AX,(DPBSIZ + 15) / 16
        SUB     CS:[MEMHI],AX
        %endif

        MOV     AX,CS:[MEMHI]
        MOV     word ES:[BP.DPB_NEXT_DPB+2],AX
        LES     BP,dword CS:[MEMLO]

        %if NOT HIGHMEM
        ADD     word CS:[MEMLO],DPBSIZ
        %endif

        MOV     word ES:[BP.DPB_NEXT_DPB],-1
        MOV     ES:[BP.DPB_FIRST_ACCESS],-1

        MOV     SI,[BX]                 ; DS:SI POINTS TO BPB
        INC     BX
        INC     BX                      ; POINT TO NEXT GUY
        MOV     word ES:[BP.DPB_DRIVE],DX
        MOV     AH,SETDPB               ; HIDDEN SYSTEM CALL
        INT     21H
        MOV     AX,ES:[BP.DPB_SECTOR_SIZE]
        PUSH    ES
        LES     DI,CS:[DOSINFO]         ; ES:DI POINT TO DOS INFO
        CMP     AX,ES:[DI.MAXSEC]
        POP     ES
        JBE     NOTMAX
        POP     SI
        POP     ES
        MOV     DX,BADSIZ_PRE
        MOV     BX,BADSIZ_POST
        CALL    PRNERR
        JMP     COFF

NOTMAX: PUSH    DS
        PUSH    DX
        LDS     DX,CS:[ENTRY_POINT]
        MOV     word ES:[BP.DPB_DRIVER_ADDR],DX
        MOV     word ES:[BP.DPB_DRIVER_ADDR+2],DS
        POP     DX
        POP     DS
        INC     DX
        INC     DH
        LOOP    PERUNIT

LINKIT:
        LES     DI,CS:[DOSINFO]         ; ES:DI = DOS TABLE
        MOV     CX,word ES:[DI.DEVHEAD] ; DX:CX = HEAD OF LIST
        MOV     DX,word ES:[DI.DEVHEAD+2]

        LDS     SI,CS:[ENTRY_POINT]     ; DS:SI = DEVICE LOCATION
        MOV     word ES:[DI.DEVHEAD],SI ; SET HEAD OF LIST IN DOS
        MOV     word ES:[DI.DEVHEAD+2],DS
        MOV     AX,DS:[SI]              ; GET POINTER TO NEXT DEVICE
        MOV     word CS:[ENTRY_POINT],AX; AND SAVE IT

        MOV     word DS:[SI],CX     ; LINK IN THE DRIVER
        MOV     word DS:[SI+2],DX
ENDDEV:
        POP     SI
        POP     ES
        INC     AX                      ; AX = FFFF?
        JZ      COFFV
        JMP     GOODLD                  ; OTHERWISE PRETEND WE LOADED IT IN
COFFV:  JMP     COFF

TRYQ:
        CMP     AH,'Q'
        JNZ     TRYW
        CALL    GETNUM
        JZ      COFFV
        OR      AH,AH
        JNZ     COFFV
        MOV     AH,INTERNATIONAL        ; AL is country code
        MOV     DX,-1                   ; Set country
        INT     21H
        JNC     COFFV
        MOV     DX,BADCOUNTRY
        CALL    PRINT
        JMP     COFFV

TRYF:
        CMP     AH,'F'
        JNZ     TRYQ
        CALL    GETNUM
        JZ      COFFV
        CMP     AX,100
        JAE     TryX
        MOV     [FILES],AL
        JMP     COFFV
TRYW:
        CMP     AH,'W'
        JNZ     TRYA
        MOV     DL,AL
        MOV     AX,(CHAR_OPER SHL 8) OR 1   ; SET SWITCH CHARACTER
        MOV     [COMMAND_LINE+1],DL
        INT     21H
        JMP     COFF

TRYA:
        CMP     AH,'A'
        JNZ     TRYS
        CMP     AL,'F'                  ; FIRST LETTER OF "FALSE"
        JNZ     COFFJ
        MOV     AX,(CHAR_OPER SHL 8) OR 3   ; TURN ON "/DEV" PREFIX
        XOR     DL,DL
        INT     21H
COFFJ:  JMP     COFF

TRYS:
        CMP     AH,'S'
        JNZ     TRYX
        MOV     [COMMAND_LINE+1],0
        MOV     DI,COMMND + 1
        MOV     [DI-1],AL
STORESHELL:
        CALL    GETCHR
        OR      AL,AL
        JZ      GETSHPARMS
        CMP     AL," "
        JB      ENDSH
        MOV     [DI],AL
        INC     DI
        JMP     STORESHELL

ENDSH:
        MOV     byte [DI],0
        CALL    GETCHR
        CMP     AL,10
        JNZ     CONV
        CALL    GETCHR
CONV:   JMP     CONFLP

TRYX:
        JMP     BADOP

GETSHPARMS:
        MOV     byte [DI],0
        MOV     DI,COMMAND_LINE+1
PARMLOOP:
        CALL    GETCHR
        CMP     AL," "
        JB      ENDSH
        MOV     [DI],AL
        INC     DI
        JMP     PARMLOOP

GETCHR: MOV     CX,COUNT
        JCXZ    NOCHAR
        MOV     SI,CHRPTR
        MOV     AL,ES:[SI]
        DEC     COUNT
        INC     CHRPTR
        CLC
        RET
NOCHAR: STC
        RET

ORGANIZE:
        MOV     CX,[COUNT]
        JCXZ    NOCHAR
        CALL    MAPCASE
        XOR     SI,SI
        MOV     DI,SI

ORG1:   CALL    GET                     ; SKIP LEADING CONTROL CHARACTERS
        CMP     AL,' '
        JB      ORG1

        PUSH    CX
        PUSH    SI
        PUSH    DI
        MOV     BP,SI
        DEC     BP
        MOV     SI,COMTAB        ; Prepare to search command table
        MOV     CH,0
FINDCOM:
        MOV     DI,BP
        MOV     CL,[SI]
        INC     SI
        JCXZ    NOCOM
        REPE    CMPSB
        LAHF
        ADD     SI,CX                   ; Bump to next position without affecting flags
        SAHF
        LODSB                           ; Get indicator letter
        JNZ     FINDCOM
        POP     DI
        POP     SI
        POP     CX
        JMP     SHORT GOTCOM

NOCOM:
        POP     DI
        POP     SI
        POP     CX
        MOV     AL,'Z'
GOTCOM: STOSB                           ; SAVE INDICATOR CHAR IN BUFFER

ORG2:   CALL    GET2                    ; SKIP NAME UNTIL DELIMETER
        CALL    DELIM                   ;
        JNZ     ORG2

        CALL    GET                     ; GET CHARS TO RIGHT OF EQUALS SIGN
        STOSB

ORG4:   CALL    GET2
        STOSB
        CMP     AL,' '
        JA      ORG4
        CMP     AL,10
        JZ      ORG1

        MOV     byte ES:[DI-1],0
ORG5:   CALL    GET2
        STOSB
        CMP     AL,10
        JNZ     ORG5
        JMP     ORG1

GET2:
        JCXZ    NOGET
        MOV     AL,ES:[SI]
        INC     SI
        DEC     CX
        RET

GET:    JCXZ    NOGET
        MOV     AL,ES:[SI]
        INC     SI
        DEC     CX
        CALL    DELIM
        JZ      GET
GRET:   RET


DELIM:  CMP     AL,' '
        JZ      GRET
        CMP     AL,9
        JZ      GRET
        CMP     AL,'='
        JZ      GRET
        CMP     AL,','
        JZ      GRET
        CMP     AL,';'
        RET


NOGET:  POP     CX
        MOV     COUNT,DI
        XOR     SI,SI
        MOV     CHRPTR,SI
        RET
;
;  NEWLINE RETURNS WITH FIRST CHARACTER OF NEXT LINE
;
NEWLINE:CALL    GETCHR                  ; SKIP NON-CONTROL CHARACTERS
        JC      NONEW
        CMP     AL,10                   ; LOOK FOR LINE FEED
        JNZ     NEWLINE
        CALL    GETCHR
NONEW:  RET

MAPCASE:
        PUSH    CX
        PUSH    SI
        PUSH    DS
        PUSH    ES
        POP     DS
        XOR     SI,SI
CONVLOOP:
        LODSB

        %if KANJI
        CALL    TESTKANJ
        JZ      NORMCONV
        INC     SI                      ; Skip next char
        DEC     CX
        JCXZ    CONVDONE                ; Just ignore 1/2 kanji error
; Fall through, know AL is not in 'a'-'z' range
NORMCONV:
        %endif

        CMP     AL,'a'
        JB      NOCONV
        CMP     AL,'z'
        JA      NOCONV
        SUB     AL,20H
        MOV     [SI-1],AL
NOCONV:
        LOOP    CONVLOOP
CONVDONE:
        POP     DS
        POP     SI
        POP     CX
        RET

        %if KANJI
TESTKANJ:
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
        XOR     AX,AX                   ; Set zero
        POP     AX
        RET

ISLEAD:
        PUSH    AX
        XOR     AX,AX                   ; Set zero
        INC     AX                      ; Reset zero
        POP     AX
        RET
        %endif

; ASSUME DS:NOTHING

ROUND:  MOV     AX,[MEMLO]

        %if NOT HIGHMEM
        ADD     AX,15
        %endif

        SHR     AX,1
        SHR     AX,1
        SHR     AX,1
        SHR     AX,1
        ADD     [MEMHI],AX
        XOR     AX,AX
        MOV     [MEMLO],AX
        RET

CALLDEV:MOV     DS,word CS:[ENTRY_POINT+2]
        ADD     BX,word CS:[ENTRY_POINT]; Do a little relocation
        MOV     AX,DS:[BX]
        PUSH    word CS:[ENTRY_POINT]
        MOV     word CS:[ENTRY_POINT],AX
        MOV     BX,PACKET
        CALL    [ENTRY_POINT]
        POP     word CS:[ENTRY_POINT]
        RET

BADNUM: POP     AX                      ; POP RETURN ADDRESS
        JMP     BADOP

ToDigit:
        SUB     AL,'0'
        JB      NotDig
        CMP     AL,9
        JA      NotDig
        CLC
        RET
NotDig: STC
        RET

GETNUM: XOR     BX,BX                   ; running count is zero
B2:     CALL    ToDigit                 ; do we have a digit
        JC      BadNum                  ; no, bomb
        XCHG    AX,BX                   ; put total in AX
        PUSH    BX                      ; save digit
        MOV     BX,10                   ; base of arithmetic
        MUL     BX                      ; shift by one decimal digit
        POP     BX                      ; get back digit
        ADD     AL,BL                   ; get total
        ADC     AH,0                    ; make that 16 bits
        JC      BADNUM                  ; too big a number
        XCHG    AX,BX                   ; stash total
        CALL    GETCHR                  ; GET NEXT DIGIT
        JC      B1                      ; no more characters
        OR      AL,AL                   ; end of line separator?
        JNZ     B2                      ; no, try as a valid character
        INC     COUNT                   ; one more character to scan
        DEC     CHRPTR                  ; back up over separator
B1:     MOV     AX,BX                   ; get proper count
        OR      AX,AX
        RET
;
;       ES:SI POINTS TO FILE NAME (NUL TERMINATED)
;       DS:DX POINTS TO STRING TO OUTPUT IN FRONT OF NAME ($ TERM)
;
BADFIL:
        PUSH    CS
        POP     ES
        MOV     SI,DX
BADLOAD:
        MOV     DX,BADLD_PRE     ; WANT TO PRINT CONFIG ERROR
        MOV     BX,BADLD_POST
PRNERR:
        PUSH    CS
        POP     DS
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
PRN1:   MOV     DL,ES:[SI]
        OR      DL,DL
        JZ      PRN2
        MOV     AH,STD_CON_OUTPUT
        INT     21H
        INC     SI
        JMP     PRN1
PRN2:   MOV     DX,BX
PRINT:  MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
        RET
;
; LOAD FILE CALLED [DS:DX] AT MEMORY LOCATION ES:BX
;
LDFIL:
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        PUSH    DS
        PUSH    BX

        XOR     AX,AX                   ; OPEN THE FILE
        MOV     AH,OPEN
        STC                             ; IN CASE OF INT 24
        INT     21H
        POP     DX                      ; Trans addr is DS:DX
        JC      LDRET

        PUSH    ES                      ; READ THE FILE IN
        POP     DS
        MOV     BX,AX                   ; Handle in BX
        MOV     CX,0FF00H
        MOV     AH,READ
        STC                             ; IN CASE OF INT 24
        INT     21H
        JC      LDRET
        MOV     SI,DX                   ; CHECK FOR EXE FILE
        CMP     word [SI],"ZM"
        JNZ     LDCLS
LDERR:  STC
        JMP     SHORT LDRET

LDCLS:  MOV     AH,CLOSE                ; CLOSE THE FILE
        STC
        INT     21H

LDRET:  POP     DS
        POP     SI
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
;
;  OPEN DEVICE POINTED TO BY DX, AL HAS ACCESS CODE
;   IF UNABLE TO OPEN DO A DEVICE OPEN NULL DEVICE INSTEAD
;
OPEN_DEV:
        CALL    OPEN_FILE
        JNC     OPEN_DEV3
OPEN_DEV1:
        MOV     DX,NULDEV
        CALL    OPEN_FILE
OPEN_DEV2:
        RET
OPEN_DEV3:
        XOR     AX,AX                   ; GET DEVICE INFO
        MOV     AH,IOCTL
        INT     21H
        TEST    DL,10000000B
        JNZ     OPEN_DEV2
        MOV     AH,CLOSE
        INT     21H
        JMP     OPEN_DEV1

OPEN_FILE:
        MOV     AH,OPEN
        STC
        INT     21H
        RET

INT24:  ADD     SP,6                    ; RESTORE MACHINE STATE
        POP     AX
        POP     BX
        POP     CX
        POP     DX
        POP     SI
        POP     DI
        POP     BP
        POP     DS
        POP     ES
        PUSH    AX
        MOV     AH,GET_DEFAULT_DRIVE    ; INITIALIZE DOS
        INT     21H
        POP     AX
        IRET                            ; BACK TO USER

        %if ALTVECT
BOOTMES DB      13
TEN:    DB      10
        DB      "MS-DOS version "
        DB      MAJOR_VERSION + "0"
        DB      "."
        DB      (MINOR_VERSION / 10) + "0"
        DB      (MINOR_VERSION MOD 10) + "0"
        DB      13,10
        DB      "Copyright 1981,82 Microsoft Corp.",13,10,"$"
        %endif

NULDEV  DB      "\DEV\NUL",0
CONDEV  DB      "\DEV\CON",0
AUXDEV  DB      "\DEV\AUX",0
PRNDEV  DB      "\DEV\PRN",0

CONFIG  DB      "\CONFIG.SYS",0

COMMND  DB      "\COMMAND.COM",0

COMTAB:
        DB      7,"BUFFERS",'B'
        DB      5,"BREAK",'C'
        DB      5,"SHELL",'S'
        DB      6,"DEVICE",'D'
        DB      5,"FILES",'F'
        DB      8,"SWITCHAR",'W'
        DB      8,"AVAILDEV",'A'
        DB      7,"COUNTRY",'Q'
        DB      0


; END SECTION .SYSINITSEG
        ; END
                                                        

