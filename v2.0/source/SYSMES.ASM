   ; TITLE Message file for MS-DOS SYS Program

FALSE   EQU     0
TRUE    EQU     NOT FALSE

        %include "DOSSYM.ASM"

%macro Message 2
        global label,label&Len
label       DB  text
label&Len   DW  $-label
%endmacro


IBMJAPVER EQU   FALSE

SECTION .CONST

; only this message must be terminated with a $
        global BadVer
BADVER  DB      "Incorrect DOS version",13,10,"$"

        %if IBMJAPVER
        Message BadDisk,<"Destination disk cannot be booted">
        %endif

        Message BadDrv,<"Invalid drive specification">
        Message BadParm,<"Invalid parameter">
        Message NoDest,<"No room for system on destination disk">
        Message BadSiz,<"Incompatible system size">
        Message Done,<"System transferred">

        global GetSys,SysDrv,GetSysLen
GETSYS      DB      "Insert system disk in drive "
SYSDRV      DB      "A",13,10
            DB      "and strike any key when ready",13,10
GetSysLen   DW  GetSysLen-GetSys

; END SECTION .CONST

SECTION .DATA
; END SECTION .DATA

SECTION .CODE
; DG      GROUP   CODE,CONST,DATA
        ; ASSUME  CS:DG,DS:DG,ES:DG,SS:DG

; END SECTION .CODE
        ; END

