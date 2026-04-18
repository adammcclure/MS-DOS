
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
    LANGUAGE_PARM: resw 1;;   }  PARAMETER
    CODE_PAGE_PARM: resw 1;;  |	    LIST
    PATH_OFFSET: resw 1;;  |
    PATH_LENGTH     DW	 0	       ;;  /
;*******************CNS******************
    ID_PARM: resw 1;AN000;
;*******************CNS******************
endstruc;;
				       ;;
struc DESIG_CP_STRUC;;
    NUM_DESIGNATES: resw 1;;
    NUM_FONTS: resw 1;;
    NUM_HW_CPS: resw 1;;
    DESIG_CP_ENTRY: resw 1;;
endstruc;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .LIST

