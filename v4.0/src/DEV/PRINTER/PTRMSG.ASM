
	; PAGE	,132

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  FILENAME:	  CPS Device Driver -- Message File
;;  MODULE NAME:  PTRMSG1
;;  TYPE:	  Message External File
;;  LINK PROCEDURE:  see CPSPMNN.ASM
;;
;;  INCLUDE FILES:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;;
					;;
SECTION .CSEG;;
	; ASSUME	CS:CSEG;;
	; ASSUME	DS:NOTHING;;
					;;
global msg_no_init_p;;
global msg_no_init;;
global msg_bad_syntax;;
global msg_insuff_mem;;
					;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ************************************
;;  **				      **
;;  **	     Resident Code	      **
;;  **				      **
;;  ************************************
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include "PTRMSG.INC"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; END SECTION .CSEG
	; END
