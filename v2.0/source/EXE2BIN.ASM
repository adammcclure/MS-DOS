        ; title   LOCATE (EXE2BIN)

;Loader for EXE files under 86-DOS

;The following switch allows use with the "old linker", which put a version
;number where the new linker puts the number of bytes used in the last page.
;If enabled, this will cause a test for 0004 at this location (the old linker
;version number), and if equal, change it to 200H so all of the last page
;will be used.

;VER. 1.5
;    05/21/82   Added rev number
;
;VER. 1.6
;    07/01/82   A little less choosy about size matches
;
;VER. 2.0  Rev. 1       M.A.Ulloa
;    10/08/82   Modified to use new 2.0 system calls for file i/o
;
;          Rev. 2       M.A.Ulloa
;    10/27/82   Added the DOS version check

FALSE   EQU     0
TRUE    EQU     ~FALSE

OLDLINK EQU     0                  ;1 to enable, 0 to disable

        ; .xlist
        %include "DOSSYM.ASM"
        ; .list


        ; subttl  Main Code Area
        ; page


SECTION .code
; END SECTION .code

SECTION .DATA


        extern bad_vers_err,NOTFND,NOROOM,DIRFULL
        extern CANTFIX,RDBAD,FULL,PROMPT,CRLF

make    db      "MAUlloa/Microsoft/V20"
rev     db      "2"

file1_ext db    ".EXE",00h
file2_ext db    ".BIN",00h

per1    db      0
per2    db      0

file1: times 64 db 0
handle1: times 1 dw 0

file2: times 64 db 0
handle2: times 1 dw 0


INBUF   DB      5,0
        times 5 db 0

;The following locations must be defined for storing the header:

RUNVAR:;Start of RUN variables
RELPT: dw 0
LASTP:
RELSEG: dw 0
SIZ:;Share these locations
PAGES: dw 0
RELCNT: dw 0
HEADSIZ: dw 0
        dw 0
LOADLOW: dw 0
INITSS: dw 0
INITSP: dw 0
        dw 0
INITIP: dw 0
INITCS: dw 0
RELTAB: dw 0
RUNVARSIZ       EQU     $-RUNVAR

; END SECTION .DATA

SECTION .STACK
        DB      80H DUP (?)
; END SECTION .STACK

SECTION .ZLOAD
; END SECTION .ZLOAD
LOAD    EQU     ZLOAD

SECTION .CODE

        ; ASSUME  CS:CODE

LOCATE:
        JMP     SHORT LOCSTRT

HEADER  DB      "Vers 2.00"

LOCSTRT:
        MOV     SI,81H
        PUSH    DS
        XOR     AX,AX
        PUSH    AX                      ;Push return address to DS:0

;Code to print header
;       PUSH    DS
;       MOV     DX,DATA
;       MOV     DS,DX
;       MOV     DX,OFFSET HEADER
;       MOV     AH,STD_CON_STRING_OUTPUT
;       INT     21H
;       POP     DS

;----- Check Version Number --------------------------------------------;
        mov     ah,Get_Version
        int     21h
        cmp     al,2
        jge     vers_ok                         ; version >= 2, enter locate
        push    ds
        mov     dx,data
        mov     ds,dx
        mov     dx,bad_vers_err
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
        pop     ds
        ret                                     ;long return to DOS

;-----------------------------------------------------------------------;
vers_ok:


        MOV     BX,word DS:2        ;Get size of memory
        MOV     DX,DATA
        MOV     ES,DX

        ; assume  es:data

;-----------------------------------------------------------------------;

;----- Get the first file name
        call    kill_bl
        jnc     sj01
        mov     ds,dx
        jmp     bad_file
sj01:
        mov     di,file1
sj0:
        lodsb                           ;get character of file name
        cmp     al,' '
        je      sj2
        cmp     al,0dh
        je      sj2
        cmp     al,'.'                  ;an extension separator found?
        jne     sj1
        mov     [es:per1],-1
sj1:
        stosb
        jmp     short sj0
sj2:
        dec     si
        mov     byte [es:di],00h    ;nul terminate the filename
        call    kill_bl
        jc      no_second

;----- Get the second file name
        mov     di,file2
sj3:
        lodsb                           ;get character of file name
        cmp     al,' '
        je      sj5
        cmp     al,0dh
        je      sj5
        cmp     al,'.'                  ;an extension separator found?
        jne     sj4
        mov     [es:per2],-1
sj4:
        stosb
        jmp     short sj3
sj5:
        mov     byte [es:di],00h     ;nul terminate
        jmp     short check_ext

;----- Copy file1 to file2
no_second:
        mov     ds,dx

        ; assume  ds:data

        mov     si,file1
        mov     di,file2
sj6:
        lodsb
        cmp     al,'.'
        je      sj7
        cmp     al,00h
        je      sj7
        stosb
        jmp     short sj6
sj7:
        mov     byte [di],00h

;----- Check that files have an extension, otherwise set default
check_ext:
        mov     ds,dx

        ; assume  ds:data

        cmp     [per1],-1
        je      file1_ok
        mov     si,file1
sj8:
        lodsb
        cmp     al,00h
        jne     sj8
        mov     di,si
        mov     si,file1_ext
        call    put_ext

file1_ok:
        cmp     [per2],-1
        je      file2_ok
        mov     si,file2
sj9:
        lodsb
        cmp     al,00h
        jne     sj9
        mov     di,si
        mov     si,file2_ext
        call    put_ext
        jmp     short file2_ok

;----- Fill in the default extent
put_ext:
        dec     di
        mov     cx,5                    ;move extent: period,extent,null
        rep     movsb
        ret
; ENDP put_ext

;----- Find the first non-blank
kill_bl:
        cld
sj10:
        lodsb
        cmp     al,' '
        je      sj10
        dec     si
        cmp     al,0dh
        clc
        jne     sj11
        stc
sj11:
        ret
; ENDP kill_bl

file2_ok:

;-----------------------------------------------------------------------;

        mov     dx,file1
        mov     ah,open
        mov     al,0                    ;ror reading only
        INT     21H                     ;Open input file
        jc      bad_file
        mov     [handle1],ax
        jmp     exeload

bad_file:
        MOV     DX,NOTFND
xERROR:
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
        RET                             ;FAR return to MS-DOS
TOOBIG:
        MOV     DX,NOROOM
        JMP     xERROR
BADEXE:
        MOV     DX,CANTFIX
ERRORJ: JMP     xERROR

EXELOAD:
        MOV     DX,RUNVAR        ;Read header in here
        MOV     CX,RUNVARSIZ            ;Amount of header info we need
        push    bx
        mov     bx,[handle1]
        MOV     AH,read
        INT     21H                      ;Read in header
        pop     bx
        CMP     [RELPT],5A4DH           ;Check signature word
        JNZ     BADEXE
        MOV     AX,[HEADSIZ]            ;size of header in paragraphs
        ADD     AX,31                   ;Round up first
        CMP     AX,1000H                ;Must not be >=64K
        JAE     TOOBIG
        AND     AX,NOT 31
        MOV     CL,4
        SHL     AX,CL                   ;Header size in bytes

        push    dx
        push    cx
        push    ax
        push    bx
        mov     dx,ax
        xor     cx,cx
        mov     al,0
        mov     bx,[handle1]
        mov     ah,lseek
        int     21h
        pop     bx
        pop     ax
        pop     cx
        pop     dx

        XCHG    AL,AH
        SHR     AX,1                    ;Convert to pages
        MOV     DX,[PAGES]              ;Total size of file in 512-byte pages
        SUB     DX,AX                   ;Size of program in pages
        CMP     DX,80H                  ;Fit in 64K?
        JAE     TOOBIG
        XCHG    DH,DL
        SHL     DX,1                    ;Convert pages to bytes
        MOV     AX,[LASTP]              ;Get count of bytes in last page
        OR      AX,AX                   ;If zero, use all of last page
        JZ      WHOLEP

        %if OLDLINK
        CMP     AX,4                    ;Produced by old linker?
        JZ      WHOLEP                  ;If so, use all of last page too
        %endif

        SUB     DX,200H                 ;Subtract last page
        ADD     DX,AX                   ;Add in byte count for last page
WHOLEP:
        MOV     [SIZ],DX
        ADD     DX,15
        SHR     DX,CL                   ;Convert bytes to paragraphs
        MOV     BP,LOAD
        ADD     DX,BP                   ;Size + start = minimum memory (paragr.)
        CMP     DX,BX                   ;Enough memory?
        JA      TOOBIG
        MOV     DX,CANTFIX
        MOV     AX,[INITSS]
        OR      AX,[INITSP]
        OR      AX,[INITCS]
ERRORNZ:
        jz      xj
        JMP     ERRORJ                  ;Must not have SS, SP, or CS to init.
xj:     MOV     AX,[INITIP]
        OR      AX,AX                   ;If IP=0, do binary fix
        JZ      BINFIX
        CMP     AX,100H                 ;COM file must be set up for CS:100
        JNZ     ERRORNZ

        push    dx
        push    cx
        push    ax
        push    bx
        mov     dx,100h                 ;chop off first 100h
        xor     cx,cx
        mov     al,1                    ;seek from current position
        mov     bx,[handle1]
        mov     ah,lseek
        int     21h
        pop     bx
        pop     ax
        pop     cx
        pop     dx

        SUB     [SIZ],AX                ;And count decreased size
        CMP     [RELCNT],0              ;Must have no fixups
        JNZ     ERRORNZ
BINFIX:
        XOR     BX,BX                   ;Initialize fixup segment
;See if segment fixups needed
        CMP     [RELCNT],0
        JZ      LOADEXE
GETSEG:
        MOV     DX,PROMPT
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
        MOV     AH,STD_CON_STRING_INPUT
        MOV     DX,INBUF
        INT     21H                      ;Get user response
        MOV     DX,CRLF
        MOV     AH,STD_CON_STRING_OUTPUT
        INT     21H
        MOV     SI,INBUF+2
        MOV     byte [SI-1],0       ;Any digits?
        JZ      GETSEG
DIGLP:
        LODSB
        SUB     AL,"0"
        JC      DIGERR
        CMP     AL,10
        JB      HAVDIG
        AND     AL,5FH                  ;Convert to upper case
        SUB     AL,7
        CMP     AL,10
        JB      DIGERR
        CMP     AL,10H
        JAE     DIGERR
HAVDIG:
        SHL     BX,1
        SHL     BX,1
        SHL     BX,1
        SHL     BX,1
        OR      BL,AL
        JMP     DIGLP

DIGERR:
        CMP     byte [SI-1],0DH     ;Is last char. a CR?
        JNZ     GETSEG
LOADEXE:
        XCHG    BX,BP                   ;BX has LOAD, BP has fixup

        MOV     CX,[SIZ]
        MOV     AH,read
        push    di
        mov     di,[handle1]
        PUSH    DS
        MOV     DS,BX
        XOR     DX,DX
        push    bx
        mov     bx,di
        INT     21H                     ;Read in up to 64K
        pop     bx
        POP     DS
        pop     di
        Jnc     HAVEXE                  ;Did we get it all?
        MOV     DX,RDBAD
        jmp     xERROR                   ;Non fatal, print warning
HAVEXE:
        CMP     [RELCNT],0              ;Any fixups to do?
        JZ      STORE
        MOV     AX,[RELTAB]             ;Get position of table

        push    dx
        push    cx
        push    ax
        push    bx
        mov     dx,ax
        xor     cx,cx
        mov     al,0
        mov     bx,[handle1]
        mov     ah,lseek
        int     21h
        pop     bx
        pop     ax
        pop     cx
        pop     dx

        MOV     DX,RELPT         ;4-byte buffer for relocation address
RELOC:
        MOV     DX,RELPT         ;4-byte buffer for relocation address
        MOV     CX,4
        MOV     AH,read
        push    bx
        mov     bx,[handle1]
        INT     21H                      ;Read in one relocation pointer
        pop     bx
        Jnc     RDCMP
        JMP     BADEXE
RDCMP:
        MOV     DI,[RELPT]              ;Get offset of relocation pointer
        MOV     AX,[RELSEG]             ;Get segment
        ADD     AX,BX                   ;Bias segment with actual load segment
        MOV     ES,AX
        ADD     [ES:DI],BP              ;Relocate
        DEC     [RELCNT]                ;Count off
        JNZ     RELOC
STORE:
        MOV     AH,CREAT
        MOV     DX,file2
        xor     cx,cx
        INT     21H
        Jc      MKERR
        mov     [handle2],ax
        MOV     CX,[SIZ]
        MOV     AH,write
        push    di
        mov     di,[handle2]
        PUSH    DS
        MOV     DS,BX
        XOR     DX,DX                   ;Address 0 in segment
        push    bx
        mov     bx,di
        INT     21H
        pop     bx
        POP     DS
        pop     di
        Jc      WRTERR                  ;Must be zero if more to come
        MOV     AH,CLOSE
        push    bx
        mov     bx,[handle2]
        INT     21H
        pop     bx
        RET

WRTERR:
        MOV     DX,FULL
        JMP     xERROR
MKERR:
        MOV     DX,DIRFULL
        JMP     xERROR

; ENDP LOCATE
; END SECTION .CODE
        ; END     LOCATE
                                                                                    