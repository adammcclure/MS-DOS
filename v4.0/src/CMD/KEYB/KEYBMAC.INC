; .XLIST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOS - NLS Support - Keyboard Definition File
;; (C) Copyright 1988 Microsoft
;;
;; File Name:  KEYBMAC.INC
;; ----------
;;
;; Description:
;; ------------
;;       Include file containing macros for the Keyboard Definition File.
;;
;; Change History:
;; ---------------
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dead key flags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                       ;;
ACUTE               EQU   80H          ;; NLS_FLAG_1
GRAVE               EQU   40H          ;;
DIARESIS            EQU   20H          ;;
CIRCUMFLEX          EQU   10H          ;;
CEDILLA             EQU   08H          ;;
TILDE               EQU   04H          ;;
                                       ;; NLS_FLAG_2 : nothing defined yet
                                       ;;
                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State IDs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                       ;;
DEAD_LOWER          EQU    1           ;; dead keys on lower shift
DEAD_UPPER          EQU    2           ;;
ALPHA_LOWER         EQU    3           ;;
ALPHA_UPPER         EQU    4           ;;
NON_ALPHA_LOWER     EQU    5           ;;
NON_ALPHA_UPPER     EQU    6           ;;
THIRD_SHIFT         EQU    7           ;;
ACUTE_LOWER         EQU    8           ;;
ACUTE_UPPER         EQU    9           ;;
ACUTE_SPACE         EQU   10           ;;
GRAVE_LOWER         EQU   11           ;;
GRAVE_UPPER         EQU   12           ;;
GRAVE_SPACE         EQU   13           ;;
DIARESIS_LOWER      EQU   14           ;;
DIARESIS_UPPER      EQU   15           ;;
DIARESIS_SPACE      EQU   16           ;;
CIRCUMFLEX_LOWER    EQU   17           ;;
CIRCUMFLEX_UPPER    EQU   18           ;;
CIRCUMFLEX_SPACE    EQU   19           ;;
CEDILLA_LOWER       EQU   20           ;;
CEDILLA_UPPER       EQU   21           ;;
CEDILLA_SPACE       EQU   22           ;;
CEDILLA_CEDILLA     EQU   23           ;;
DEAD_THIRD          EQU   24           ;;
ACUTE_ACUTE         EQU   25           ;;
GRAVE_GRAVE         EQU   26           ;;
DIARESIS_DIARESIS   EQU   27           ;;
CIRCUMFLEX_CIRCUMFLEX EQU 28           ;;
FOURTH_SHIFT        EQU   29           ;;
DEAD_FOURTH         EQU   30           ;;
TILDE_LOWER         EQU   31           ;;
TILDE_UPPER         EQU   32           ;;
TILDE_SPACE         EQU   33           ;;
ALT_CASE            EQU   34           ;;
CTRL_CASE           EQU   35           ;;
NUMERIC_PAD         EQU   36           ;;
DIVIDE_SIGN         EQU   37           ;;
                                       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Logic Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                       ;;

UNKNOWN equ 255

%macro FIND_FLAG 1
       %ifidn <FLAG_MASK>,<SCAN_MATCH>
          FLAG_ID equ EXT_KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<EITHER_SHIFT>
          FLAG_ID equ EXT_KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<CAPS_STATE>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<NUM_STATE>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<EITHER_CTL>
          FLAG_ID equ EXT_KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<EITHER_ALT>
          FLAG_ID equ EXT_KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<LEFT_SHIFT>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<RIGHT_SHIFT>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<ALT_SHIFT>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<CTL_SHIFT>
          FLAG_ID equ KB_FLAG_ID
       %else
       %ifidn <FLAG_MASK>,<R_ALT_SHIFT>
          FLAG_ID equ KB_FLAG_3_ID
       %else
       %ifidn <FLAG_MASK>,<R_CTL_SHIFT>
          FLAG_ID equ KB_FLAG_3_ID
       %else
       %ifidn <FLAG_MASK>,<TILDE>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<ACUTE>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<GRAVE>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<DIARESIS>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<CEDILLA>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<CIRCUMFLEX>
          FLAG_ID equ NLS_FLAG_1_ID
       %else
       %ifidn <FLAG_MASK>,<LC_E0>
          FLAG_ID equ KB_FLAG_3_ID
       %else
          FLAG_ID equ UNKNOWN
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
       %endif
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro FLAG 1
       FIND_FLAG FLAG_MASK
       %if (FLAG_ID EQ UNKNOWN)
          %if 1  ; IF2 - pass-specific
              %warning Unknown parameter FLAG_MASK on FLAG MACRO
          %endif
       %else
          DB FLAG_ID
          DB FLAG_MASK
       %endif
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro IFF 2
    MAC_OK equ 1
    %if 0  ; IFB <MASK_TYPE>
         NOT_BIT equ 00000000B
    %else
         %ifidn <MASK_TYPE>,<NOT>
             NOT_BIT equ 00001000B
         %else
             MAC_OK equ 0
             %if 1  ; IF2 - pass-specific
                 %warning Unknown parameter MASK_TYPE on IFF MACRO
             %endif
         %endif
    %endif
    %if MAC_OK
       FIND_FLAG FLAG_MASK
       %if (FLAG_ID EQ UNKNOWN)
          %if 1  ; IF2 - pass-specific
              %warning Unknown parameter FLAG_MASK on IFF MACRO
          %endif
       %else
          DB IFF_COMMAND+NOT_BIT+FLAG_ID
          DB FLAG_MASK
       %endif
    %endif
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro IFKBD 1
       DB IFKBD_COMMAND
       DW SYS
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro ANDF 2
    MAC_OK equ 1
    %if 0  ; IFB <MASK_TYPE>
         NOT_BIT equ 00000000B
    %else
         %ifidn <MASK_TYPE>,<NOT>
             NOT_BIT equ 00001000B
         %else
             MAC_OK equ 0
             %if 1  ; IF2 - pass-specific
                 %warning Unknown parameter MASK_TYPE on ANDF MACRO
             %endif
         %endif
    %endif
    %if MAC_OK
       FIND_FLAG FLAG_MASK
       %if (FLAG_ID EQ UNKNOWN)
          %if 1  ; IF2 - pass-specific
              %warning Unknown parameter FLAG_MASK on ANDF MACRO
          %endif
       %else
          DB ANDF_COMMAND+NOT_BIT+FLAG_ID
          DB FLAG_MASK
       %endif
    %endif
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro ELSEF 0
       DB  ELSEF_COMMAND
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro ENDIFF 0
       DB  ENDIFF_COMMAND
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro XLATT 1
       DB  XLATT_COMMAND
       DB  STATE
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro PUT_ERROR_CHAR 1
       DB  PUT_ERROR_COMMAND
       DB  STATE
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro OPTION 2
    MAC_OK equ 1
    %if 0  ; IFB <MASK_TYPE>
         NOT_BIT equ 00000000B
    %else
         %ifidn <MASK_TYPE>,<NOT>
             NOT_BIT equ 00001000B
         %else
             MAC_OK equ 0
             %if 1  ; IF2 - pass-specific
                 %warning Unknown parameter MASK_TYPE on OPTION MACRO
             %endif
         %endif
    %endif
    %if MAC_OK
       DB  OPTION_COMMAND+NOT_BIT
       DB  MASK
    %endif
    %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro SET_FLAG 1
       DB  SET_FLAG_COMMAND
       DB  STATE
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro RESET_NLS 0
       DB  RESET_NLS_COMMAND
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro BEEP 0
       DB  BEEP_COMMAND
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro GOTO 1
       DB  GOTO_COMMAND
       DW  GOTO_OFFSET-$-2
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro EXIT_INT_9 0
       DB  GOTO_COMMAND+EXIT_INT_9_FLAG
       DW  0
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro EXIT_STATE_LOGIC 0
       DB  GOTO_COMMAND+EXIT_STATE_LOGIC_FLAG
       DW  0
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%macro CHECK_FOR_CORE_KEY 0
       DB  CHECK_CORE_COMMAND
       %endmacro

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .LIST
