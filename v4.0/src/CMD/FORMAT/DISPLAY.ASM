;

;*****************************************************************************
;*****************************************************************************
;UTILITY NAME: FORMAT.COM
;
;MODULE NAME: DISPLAY.ASM
;
;
; Change List: AN000 - New code DOS 3.3 spec additions
;              AC000 - Changed code DOS 3.3 spec additions
;*****************************************************************************
;*****************************************************************************


;
;*****************************************************************************
; Define Segment ordering
;*****************************************************************************
;


; .SEQ;

SECTION .PSP
; END SECTION .PSP

SECTION .data;
global Test_Data_Start
Test_Data_Start:
; END SECTION .data;

SECTION .stack
        times 62 db "-Stack!-"; (362-80h) is the additionsal IBM ROM
        ; assume ss:stack
; END SECTION .stack


SECTION .code;
        ; assume  cs:code,ds:data;
; END SECTION .code

SECTION .End_Of_Memory;
global Test_End
Test_End:
; END SECTION .End_Of_Memory;


;
;*****************************************************************************
; INCLUDE FILES
;*****************************************************************************
;

; .xlist
%include "FORCHNG.INC"
%include "FOREQU.INC"
%include "FORMSG.INC"
%include "SYSMSG.INC"
; .list

;
;*****************************************************************************
; Message Services
;*****************************************************************************
;


MSG_UTILNAME  <FORMAT>


SECTION .data
Msg_Services    <MSGDATA>
; END SECTION .data

SECTION .code
Msg_Services    <NEARmsg>
Msg_Services    <LOADmsg>
Msg_Services    <DISPLAYmsg,CHARmsg,NUMmsg>
Msg_Services    <FORMAT.CLA,FORMAT.CLB,FORMAT.CLC,FORMAT.CL1,FORMAT.CL2,FORMAT.CTL>
; END SECTION .code

;
;*****************************************************************************
; Public Declarations
;*****************************************************************************
;

        global SysDispMsg
        global SysLoadMsg


;
;***************************************************************************
; Message Structures
;***************************************************************************
;


struc Message_Table;                               ;AN000;
                                                ;
Entry1  dw      0                               ;                               ;AN000;
Entry2  dw      0                               ;                               ;AN000;
Entry3  dw      0                               ;                               ;AN000;
Entry4  dw      0                               ;                               ;AN000;
Entry5  db      0                               ;                               ;AN000;
Entry6  db      0                               ;                               ;AN000;
Entry7  dw      0                               ;                               ;AN000;
                                                ;
endstruc;                               ;AN000;



SECTION .code
;*****************************************************************************
;Routine name&gml Display_Interface
;*****************************************************************************
;
;DescriptioN&gml Save all registers, set up registers required for SysDispMsg
;             routine. This information is contained in a message description
;             table pointed to by the DX register. Call SysDispMsg, then
;             restore registers. This routine assumes that the only time an
;             error will be returned is if an extended error message was
;             requested, so it will ignore error returns
;
;Called Procedures: Message (macro)
;
;Change History&gml Created        4/22/87         MT
;
;Input&gml ES&gmlDX = pointer to message description
;
;Output&gml None
;
;Psuedocode
;----------
;
;       Save all registers
;       Setup registers for SysDispMsg from Message Description Tables
;       CALL SysDispMsg
;       Restore registers
;       ret
;*****************************************************************************

global Display_Interface
Display_Interface:;                               ;AN000;

        push    ds                              ;                               ;AN000;
        push    ax                              ;Save registers                 ;AN000;
        push    bx                              ; "  "    "  "                  ;AN000;
        push    cx                              ; "  "    "  "                  ;AN000;
        push    dx                              ; "  "    "  "                  ;AN000;
        push    si                              ; "  "    "  "                  ;AN000;
        push    di                              ; "  "    "  "                  ;AN000;
        mov     di,dx                           ;Change pointer to table        ;AN000;
        mov     dx,data                         ;Point to data segment
        mov     ds,dx                           ;
        mov     ax,[di].Entry1                  ;Message number                 ;AN000;
        mov     bx,[di].Entry2                  ;Handle                         ;AN000;
        mov     si,[di].Entry3                  ;Sublist                        ;AN000;
        mov     cx,[di].Entry4                  ;Count                          ;AN000;
        mov     dh,[di].Entry5                  ;Class                          ;AN000;
        mov     dl,[di].Entry6                  ;Function                       ;AN000;
        mov     di,[di].Entry7                  ;Input                          ;AN000;
        call    SysDispMsg                      ;Display the message            ;AN000;
        pop     di                              ;Restore registers              ;AN000;
        pop     si                              ; "  "    "  "                  ;AN000;
        pop     dx                              ; "  "    "  "                  ;AN000;
        pop     cx                              ; "  "    "  "                  ;AN000;
        pop     bx                              ; "  "    "  "                  ;AN000;
        pop     ax                              ; "  "    "  "                  ;AN000;
        pop     ds                              ;                               ;AN000;
        ret                                     ;All done                       ;AN000;

; ENDP Display_Interface;                               ;AN000;
; END SECTION .code
        ; end

