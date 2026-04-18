






;
;******************************************************************************
; Message Macro Definitions
;******************************************************************************
;

      extern Display_Interface


;-----------------------------------------------------------------------------

%macro MESSAGE 1;                               ;AN000;
                                                ;
        mov     dx,Message_Name          ;                               ;AN000;
        call    Display_Interface               ;                               ;AN000;
                                                ;
        %endmacro;                               ;AN000;


;
;*****************************************************************************
; General Macro's
;*****************************************************************************
;

%macro Procedure 1

global Proc_Name
Proc_Name:

        %endmacro
;-----------------------------------------------------------------------------

%macro DOS_Call 1

        mov     ah,Function
        int     21h

        %endmacro
;-----------------------------------------------------------------------------

%macro Parse_Message 0;AN000;


        push    ds                                                              ;AN000;
        mov     dx,SEG parse_ptr                                                ;AN000;
        mov     ds,dx                                                           ;AN000;
        ; ASSUME  DS:DATA;AN000;
        ; ASSUME  ES:DATA;AN000;
        mov     word Parse_Error_Msg,ax                                     ;AN000;
        mov     dx,Parse_Error_Msg       ;                               ;AN000;
        call    Display_Interface               ;                               ;AN000;
        pop     ds
        %endmacro;                               ;AN000;

;-----------------------------------------------------------------------------

%macro Extend_Message 0;                               ;AN001;

                                                ;
        push    ds                                                              ;AN001;
        mov     dx,SEG parse_ptr                                                ;AN001;
        mov     ds,dx                                                           ;AN001;
        ; ASSUME  DS:DATA;AN001;
        ; ASSUME  ES:DATA;AN001;
        mov     word Extend_Error_Msg,ax     ;                              ;AN001;
        mov     dx,Extend_Error_Msg       ;                              ;AN001;
        call    Display_Interface               ;                               ;AN001;
        pop     ds                                                              ;AN001;
        %endmacro;                               ;AN001;

;-----------------------------------------------------------------------------

