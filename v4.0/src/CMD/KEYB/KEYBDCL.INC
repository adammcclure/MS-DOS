
; .XLIST

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOS - NLS Support - KEYB Command
;; (C) Copyright 1988 Microsoft
;;
;; File Name:  KEYBDCL.INC
;; ----------
;;
;; Root File Name:  KEYB.ASM
;; ---------------
;;
;; Description:
;; ------------
;;	 Common declarations for structures in procedures for KEYB.COM
;;
;; Change History:
;; ---------------
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
struc PARM_LIST;;
;*******************CNS******************
;*******************CNS******************
    RET_CODE_1	    DB	 0	       ;;  \
    RET_CODE_2	    DB	 0	       ;;  |
    RET_CODE_3	    DB	 0	       ;;  |
;*******************CNS******************
    RET_CODE_4	    DB	 0	       ;;  |;AN000;
;*******************CNS******************
    LANGUAGE_PARM: dw 0;;   }  PARAMETER
    CODE_PAGE_PARM: dw 0;;  |	    LIST
    PATH_OFFSET: dw 0;;  |
    PATH_LENGTH     DW	 0	       ;;  /
;*******************CNS******************
    ID_PARM: dw 0;AN000;
;*******************CNS******************
endstruc;;
				       ;;
struc DESIG_CP_STRUC;;
    NUM_DESIGNATES: dw 0;;
    NUM_FONTS: dw 0;;
    NUM_HW_CPS: dw 0;;
    DESIG_CP_ENTRY: dw 0;;
endstruc;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .LIST

