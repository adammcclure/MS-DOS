;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; *** DEF-EQU *** DEF-EQU *** DEF-EQU ***
;
;       EQU's, STRUC's, and OTHER
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Modification history *********************************************************
;AN001; D358  New device driver INIT function package             12/07/87 J.K.
;AN002; D493  Undo D358                                           02/24/88 J.K.
;AN003; D4934 Change ANSI 2F function number to 1Ah               05/20/88 F.G.
;******************************************************************************
%if 1  ; IF1 - pass-specific;
        %warning .               ®DEF-EQU .INC¯
%endif;
ZERO    EQU     0H                      ;
ONE     EQU     1H                      ;
TWO     EQU     2H                      ;
THREE   EQU     3H                      ;
FOUR    EQU     4H                      ;
FIVE    EQU     5H                      ;
SIX     EQU     6H                      ;
SEVEN   EQU     7H                      ;
EIGHT   EQU     8H                      ;
NINE    EQU     9H                      ;
TEN     EQU    0AH                      ;
ELEVEN  EQU    0BH                      ;
TWELVE  EQU    0CH                      ;
                                        ;
FAIL    EQU     8000H                   ; fail in designate
                                        ;
NOT_CY  EQU     0FFFEH                  ;
CY      EQU     ONE                     ;
                                        ;
ID_IOCTL       EQU     5                ; MAJOR FNCT # FOR 'other' DEVICE
                                        ;
RH      EQU     ES:[DI]                 ; addressability to Request Header
                                        ;
struc RHC; fields common to all request types
         db 0; length of Request Header
         db 0; unit code (subunit)
RHC_CMD: db 0; command code
RHC_STA: dw 0; status
         dq 0; reserved for DOS
endstruc; end of common portion
                                        ;
CMD_INPUT EQU   4                       ; RHC_CMD is INPUT request
                                        ;
                                        ; Status values for RHC_STA
STAT_DONE EQU   0001H                   ; function complete - high order byte
STAT_CMDERR EQU 8000H                   ; Error code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      DEVICE  Header     DS:[SI]      -- to locate the next CON header
;      NEXT device header ES:[DI]
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HP      EQU     DS:[SI]                 ;
NHD     EQU     ES:[DI]                 ;
                                        ;
NAME_LEN EQU    8                       ;
                                        ;
struc DHS;
DH_NEXTO: dw 0; offset of pointer to next header
DH_NEXTS: dw 0; segment of pointer to next header
        dw 0; attribute
DH_STRAO: dw 0; offset to strategy routine
DH_INTRO: dw 0; offset to interrupt routine
DH_NAME DB      NAME_LEN DUP(0)         ; device name in this header
endstruc; end of common portion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      Request Header for INIT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc RH0;
        DB      (TYPE RHC) DUP (?)      ;
                                        ;
RH0_UNIT: db 0; not used for CHAR devices
RH0_ENDO: dw 0; offset  of ending address
RH0_ENDS: dw 0; segment of ending address
RH0_BPBA: dd 0; POINTER TO BPB FOR CHAR DEVICES
         db 0;
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;      Request Header for IOCTL
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc RH3;
        DB      (TYPE RHC) DUP (?)      ; common portion
                                        ;
                                        ;
        db 0; media descriptor
RH3_DTAO: dw 0; offset  of transfer address
RH3_DTAS: dw 0; segment of transfer address
RH3_CNT: dw 0; byte count
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       IOCTL header format
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc RH_IOCTL;
STATIC_RH: times 13 db 0; STANDARD STATIC REQUEST HEADER
MAJOR_F: db 0; MAJOR FUNCTION CALL (SEE DOS 3.30)
MINOR_F: db 0; MINOR FUNCTION CALL (SEE DOS 3.30)
CONTENT_SI: dw 0; CONTENTS OF SI
CONTENT_DI: dw 0; CONTENTS OF DI
REQUEST_PACKET: dd 0; POINTER TO GENERIC IOCTL REQ. PACKET
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       DESIGNATE BUFFER FORMAT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc DESG_BUFFER;
DESG_CARTRIDGE: dw 0; 0=NO CARTRIDGE, 1=CARTRIDGE
DESG_LENGTH: dw 0; LENGTH OF REMAINING HEADER
DESG_N: dw 0; NUMBER OF CP's DESIGNATED
DESG_CP: dw 0; FIRST CP DESIGNATED
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       INVOKE BUFFER FORMAT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc INVK_BUFFER;
INVK_LENGTH: dw 0; LENGTH OF REMAINING HEADER
INVK_CP: dw 0; CP TO INVOKE
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       QUERY LIST BUFFER FORMAT
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc QLST_BUFFER;
QLST_LENGTH: dw 0; LENGTH OF REMAINING HEADER
QLST_N_HDWR: dw 0; NUMBER OF HARDWARE CP's
QLST_HDWR_CP: dw 0; FIRST HDWR CODE PAGE
QLST_N_DESG: dw 0; NUMBER OF DESIGNATED CP's
QLST_DESG_CP: dw 0; DESINATED CODE PAGES
                                        ; ...there is more data to be
                                        ;    filled in by the DRIVER
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       PARSER STRUC STATEMENTS
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc PARSE_TABLE1; [[[ TABLE 1 ]]]
NUM_DEVICES: dw 0; NUMBER OF DEVICES TO SUPPORT
DEVICE1_OFFSET: dw 0; (hopefully) CON!!!
endstruc;
                                        ;
struc PARSE_TABLE2; [[[ TABLE 2 ]]]
NUM_ITEMS: dw 0; NUMBER OF ITEMS CREATED BY THE
OFFSET_LIST: dw 0; THE 1ST OFFSET OF [ TABLE 2 ]
endstruc; PARSER!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       CODE PAGE POINTER STRUCTURE
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc CP_PNTER_STRUC;
HDWR_CP_STRUC: dw 0;
DESG_CP_STRUC: dw 0;
FONT_CP_STRUC: dw 0;
WRITE_DATA_STRUC: dw 0;
FONT_DATA_STRUC: dw 0;
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; CON data structure  CS:[BX]
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BUF     EQU     CS:[BX]                 ;
                                        ; STATES
struc BUF_DATA;
DEV_HDRO DW     -1                      ; device driver header offset
DEV_HDRS DW     -1                      ;
CON_STRAO DW    -1                      ; dos CON strategy offset
CON_STRAS DW    -1                      ;
CON_INTRO DW    -1                      ; dos CON strategy offset
CON_INTRS DW    -1                      ;
RH_PTRO DW      -1                      ; request header offset
RH_PTRS DW      -1                      ; segment
STATE: dw 0;
STATUS: dw 0;
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;       General  Constants
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INT_2F_LOW EQU  (4*2FH)                 ; INTERRUPT 2FH CON/KEYB COMMUNICATION
INT_2F_HI EQU    (4*2FH)+2              ;
INT_43_LOW EQU  (4*43H)                 ; INTERRUPT 43H 0-255 CHARACTER VECTOR
INT_43_HI EQU    (4*43H)+2              ;
INT_44_LOW EQU  (4*44H)                 ; INTERRUPT 44H 0-255 CHARACTER VECTOR
INT_44_HI EQU    (4*44H)+2              ;
INT_1F_LOW EQU  (4*1FH)                 ; INTERRUPT 1FH EXTENDED CHARACTER SUPPORT
INT_1F_HI EQU    (4*1FH)+2              ;
INT_10_LOW EQU  (4*10H)                 ; INTERRUPT 10H fix FOR PALACE
INT_10_HI EQU    (4*10H)+2              ;
GET_MODE      EQU    0FH                ; WGR                                  ;AN000;
ON            EQU    1                  ; WGR                                  ;AN000;
OFF           EQU    0                  ; WGR                                  ;AN000;
RECALC_ON     EQU    0010H              ; WGR                                  ;AN000;
VIDEO_CTRL    EQU    487H               ; WGR                                  ;AN000;
ANSI_BUF_SIZE EQU    14                 ; WGR                                  ;AN000;
DEFAULT_LEN   EQU    25                 ; WGR                                  ;AN000;
NUMBER        EQU    1                  ; WGR                                  ;AN000;
STRING        EQU    3                  ; WGR                                  ;AN000;
COMPLEX       EQU    4                  ; WGR                                  ;AN000;
RC_EOL        EQU    -1                 ; WGR                                  ;AN000;
RC_NO_ERROR   EQU    0                  ; WGR                                  ;AN000;
FUNC_CALL     EQU    1BH                ; WGR                                  ;AN000;
VGA_FOUND     EQU    00000001B          ; WGR                                  ;AN000;
EGA_FOUND     EQU    00000001B          ; WGR                                  ;AN000;
LCD_FOUND     EQU    00000010B          ; WGR                                  ;AN000;
CGA_FOUND     EQU    00000100B          ; WGR                                  ;AN000;
MONO_FOUND    EQU    00001000B          ; WGR                                  ;AN000;
ALT_SELECT    EQU    12H                ; WGR                                  ;AN000;
EGA_INFO_CALL EQU    10H                ; WGR                                  ;AN000;
GET_SYS_ID    EQU    0C0H               ; WGR                                  ;AN000;
GET_STATUS    EQU    43H                ; WGR                                  ;AN000;
LCD_MODEL     EQU    0F9H               ; WGR                                  ;AN000;
COLOR_ADDRESS EQU    0B800H             ; WGR                                  ;AN000;
MONO_ADDRESS  EQU    0B000H             ; WGR                                  ;AN000;
ERROR_1       EQU    2                  ; WGR                                  ;AN000;
ERROR_2       EQU    12                 ; WGR                                  ;AN000;
ERROR_3       EQU    8                  ; WGR                                  ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; *** INT 2Fh used
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ANSI_2F       EQU    1Ah                ; WGR Muliflex number for ANSI         ;AC003;
;Catagory code
IOCTL_2F      EQU     1h                ;
DA_INFO_2F    EQU     2h                ;J.K. Information passing to ANSI.
;Subfunction code for IOCTL_2F
GET_SUBFUNC   EQU    7FH                ; WGR Same structure as GET_IOCTL(ANSI);AN000;

;Info Struture for DA_INFO_2F. (DS:DX point to this packet)
;J.K. Note: For DOS 4.00, DA_INFO_PACKET is used to signal ANSI.SYS that
;DISPLAY.SYS is calling/finishing INT 10h SET MODE call.  ANSI.SYS needs this
;infomration since it also hooks INT 10h vector.
;For this DA_SETMODE_FLAG purpose, DA_INFO_LEVEL and DA_INFO_DIRECTION should always be
;set to 0.  This can be extended for another information passing scheme between
;DISPLAY.SYS and ANSI.SYS in the future version.
;For DA_SETMODE_FLAG, DISPLAY.SYS should be extremely careful that when it calls
;with DA_SETMODE_FLAG =1, then it should calls with DA_SETMODE_FLAG=0
;when it finished INT 10h function call. Otherwise, the system goes .....
struc DA_INFO_PACKET
DA_INFO_LEVEL       db      0           ; 0 for DA_SETMODE_FLAG,  1 for DA_OPTION_L_STATE query (for OS2 compat. box).
DA_SETMODE_FLAG     db      0           ; 1: DISPLAY.SYS is calling INT 10h call, SET MODE. 0= finished.
DA_OPTION_L_STATE   db      0           ; on return from ANSI, 1 = ANSI /L option active, 0 = inactive.
endstruc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; *** DEF-EQU *** DEF-EQU *** DEF-EQU ***
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Information Block Structure
;    (for functionality call)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc INFO_BLOCK; info block for functionality call    ;AN000;
STATIC_ADDRESS: dd 0; address of static functionality table;AN000;
                times 33 db 0; don't care                           ;AN000;
ACTIVE_DISPLAY: db 0; active display code                  ;AN000;
ALT_DISPLAY: db 0; alternate display code               ;AN000;
                times 3 db 0; don't care                           ;AN000;
CURRENT_SCANS: db 0; current number of scan lines         ;AN000;
                times 2 db 0; don't care                           ;AN000;
MISC_INFO: db 0; miscellaneous state information      ;AN000;
                times 18 db 0; don't care                           ;AN000;
endstruc;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Structure of System ID call return block
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
struc SYS_ID; format of return system config data  ;AN000;
                dw 0; don't care                           ;AN000;
MODEL_BYTE: db 0; model byte                           ;AN000;
endstruc;                                      ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
