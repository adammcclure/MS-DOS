SECTION .data

;
;*****************************************************************************
; Macro's
;*****************************************************************************
;


%macro Define_Msg 1;                               ;AN000;
                                                ;
Create_Msg Message_Name,Message_Number,Handle,Sublist,Count,Class,Function,Input;AN000;
                                                ;
        %endmacro;                               ;AN000;

;-----------------------------------------------------------------------------

%macro Create_Msg 8;               ;AN000;

Parm1:;                               ;AN000;
        dw      Parm2                           ;                               ;AN000;
        dw      Parm3                           ;                               ;AN000;
        dw      Parm4                           ;                               ;AN000;
        dw      Parm5                           ;                               ;AN000;
        db      Parm6                           ;                               ;AN000;
        db      Parm7                           ;                               ;AN000;
        dw      Parm8                           ;                               ;AN000;
        %endmacro;                               ;AN000;


;---------------------------                    ;                               ;AN001;
Sublist_msg_parserr:;                               ;AN001;
                                                                                ;AN001;
        db              Sublist_Length          ;11                             ;AN001;
        db              Reserved                ;0                              ;AN001;
parsoff: dw 0;off                            ;AN001;
parseg: dw 0;                               ;AN001;
        db              0                       ;USE PERCENT ZERO               ;AN001;
        db              Left_Align+Char_Field_ASCIIZ ;type of data              ;AN001;
        db              128                     ;max width                      ;AN001;
        db              1                       ;min width                      ;AN001;
        db              Blank                   ;pad char                       ;AN001;
;---------------------------                    ;                               ;AN001;

Sublist_msg_exterror:;AN001;

        db              Sublist_Length                                          ;AN001;
        db              Reserved                                                ;AN001;
FileNamePointer:;AN001;
FileNameOffset: dw 0;AN001;
FileNameSegment: dw 0;AN001;
        db              0                              ; SPECIAL %0 - Extended Errors only ;AN001;
        db              Left_Align+Char_Field_ASCIIZ                            ;AN001;
        db              132                                                     ;AN001;
        db              0                                                       ;AN001;
        db              Blank                                                   ;AN001;
;-----------------------------------------------------------------------------
;
;*****************************************************************************
; Message Retriever equates
;*****************************************************************************
;

Format_Msg              equ     'C'

N_A                     equ     0

Blank                   equ     " "
No_Function             equ     0

No_Input                equ     0


;
;*****************************************************************************
; Message Description Tables
;*****************************************************************************
;

;----------------------                         ;
Message_Number equ 1;                               ;AN000;
Handle equ No_Handle;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgBadDOSVersion        ;                               ;AN000;
;----------------------                         ;
Message_Number equ 2;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgOutOfMemory          ;                               ;AN000;
;----------------------                         ;
Message_Number equ 3;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgLoadFailure          ;                               ;AN000;
;----------------------                         ;
Message_Number equ 4;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgNoAccess             ;                               ;AN000;
;----------------------                         ;
Message_Number equ 5;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgNoConvert            ;                               ;AN000;
;----------------------                         ;
Message_Number equ 6;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgNoFile               ;                               ;AN000;
;----------------------                         ;
Message_Number equ 7;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgFileCreateError      ;                               ;AN000;
;----------------------                         ;
Message_Number equ 8;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ DOS_BUF_KEYB_INP;                               ;AN000;
Input equ INBUF;                               ;AN000;
        Define_Msg      msgFixUp                ;                               ;AN000;
;----------------------                         ;
Message_Number equ 0;                               ;AN001;
Handle equ STDERR;                               ;AN001;
Sublist equ ds:sublist_msg_parserr;                               ;AN001;
Count equ 1;                               ;AN001;
Class equ Parse_Err_Class;                               ;AN001;
Function equ No_Input;                               ;AN001;
Input equ N_A;                               ;AN001;
        Define_Msg      parse_error_msg         ;                               ;AN001;
;----------------------                         ;
Message_Number equ 0;                               ;AN001;
Handle equ STDERR;                               ;AN001;
Sublist equ ds:sublist_msg_exterror;                               ;AN001;
Count equ 1;                               ;AN001;
Class equ ext_Err_Class;                               ;AN001;
Function equ No_Input;                               ;AN001;
Input equ N_A;                               ;AN001;
        Define_Msg      extend_error_msg        ;                               ;AN001;
;----------------------                         ;
Message_Number equ 10;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgNoDiskSpace          ;                               ;AN000;
;----------------------                         ;
Message_Number equ 12;                               ;AN000;
Handle equ STDOUT;                               ;AN000;
Sublist equ No_Replace;                               ;AN000;
Count equ N_A;                               ;AN000;
Class equ Utility_Msg_Class;                               ;AN000;
Function equ No_Input;                               ;AN000;
Input equ N_A;                               ;AN000;
        Define_Msg      msgNoFileName           ;                               ;AN000;
;----------------------                         ;
; END SECTION .data
