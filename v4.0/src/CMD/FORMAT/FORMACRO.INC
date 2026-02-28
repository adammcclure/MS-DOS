






;
;******************************************************************************
; Message Macro Definitions
;******************************************************************************
;

      extern Display_Interface


;-----------------------------------------------------------------------------

%macro Message 1;                               ;AN000;
                                                ;
        mov     dx,Message_Name     ;                               ;AN000;
        call    Display_Interface               ;                               ;AN000;
        %endmacro;                               ;AN000;

;-----------------------------------------------------------------------------

%macro Parse_Message 0;                               ;AN000;

                                                ;
        push    ds
        mov     dx,data
        mov     ds,dx
        mov     word Parse_Error_Msg,ax     ;                               ;AN000;
        mov     dx,Parse_Error_Msg       ;                               ;AN000;
        call    Display_Interface               ;                               ;AN000;
        pop     ds                              ;
        %endmacro;                               ;AN000;

;-----------------------------------------------------------------------------

%macro Extended_Message 0;                               ;AN000;
                                                ;

        push    ds
        mov     dx,data
        mov     ds,dx
        mov     word Extended_Error_Msg,ax       ;                               ;AN000;
        mov     dx,Extended_Error_Msg    ;                               ;AN000;
        call    Display_Interface               ;                               ;AN000;
        pop     ds
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

%macro Popff 0

        jmp     $+3
        iret
        push    cs
        call    $-2

        %endmacro


;-----------------------------------------------------------------------------

%macro Set_Data_Segment 0

        push    ax
        mov     ax,data                         ;Point to data segment
        mov     ds,ax                           ;
        push    ds
        pop     es
        pop     ax

; assume  ds:data,es:data

        %endmacro



