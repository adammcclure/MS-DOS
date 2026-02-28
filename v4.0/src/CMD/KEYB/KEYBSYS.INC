; .XLIST

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOS - NLS Support - KEYB Command
;; (C) Copyright 1988 Microsoft
;;
;; File Name:  KEYBSYS.INC
;; ----------
;;
;; Root File Name:  KEYB.ASM
;; ---------------
;;
;; Description:
;; ------------
;;	 Include file containing structure definitions and equates
;;	 for the KEYBOARD.SYS file.
;;
;; Change History:
;; ---------------
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; File header - contains pointers to keyboard tables for each language
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
struc KEYBSYS_HEADER;;
				       ;;
KH_SIGNATURE	DB   0FFh,'KEYB   '    ;; signature
KH_RESV_1: times 8 db 0;; reserved
KH_MAX_COM_SZ	DW   0	      ;AN000;**chg  ;; maximum size of Common Xlat Sect
KH_MAX_SPEC_SZ	DW   0	      ;AN000;;**chg   ;; max size of Specific Xlat Sect
KH_MAX_LOGIC_SZ DW   0	      ;AN000;;**chg   ;; max size of State Logic
KH_RESV_2	Dw   0	      ;AN000;;**chg   ;; reserved CNS
KH_NUM_ID	Dw   0		       ;AN000;;; ************* CNS
KH_NUM_LANG	DW   0		       ;; number of languages
KH_LANG_PTRS	DB   0		       ;; language pointers start here
;********************* CNS **********************
;KH_NUM_ID	  DW   0		 ;; number of languages
;KH_ID_PTRS	  DB   0		 ;; id pointers start here
;********************* CNS **********************
endstruc;;
;******************CNS*******************
struc KEYBSYS_ID_PTRS

KP_ID_CODE	DW   0		       ;AN000;
KP_LANG_PTR	DD   0		       ;AN000;

endstruc
				       ;;
;*****************CNS********************
struc KEYBSYS_LANG_PTRS;;
				       ;; Next two entries repeat:
KP_LANG_CODE	DW   0		       ;;   language code
KP_ENTRY_PTR	DD   0		       ;;   language entry pointer
				       ;;
endstruc;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language Entry - pointed to by KH_ENTRY_PTR in KEYBSYS_HEADER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
struc KEYBSYS_LANG_ENTRY;;
				       ;;
KL_LANG_CODE	DW   'XX'              ;; language code
KL_ID_CODE	DW   0		       ;; reserved (ID CODE)
KL_LOGIC_PTR	DD   0	       ;AC000;;**chg  ;; State Logic pointer
KL_NUM_ID	DB   0	       ;AN000;;CNS    ;; number of valid IDs for this lang
KL_NUM_CP	DB   0		       ;; number of valid CPs for this lang
KL_CP_PTRS	DB   0		       ;; CP table pointers start here
				       ;;
endstruc;;
				       ;;
struc KEYBSYS_CP_PTRS;;
				       ;; Next two entries repeat:
KC_CODE_PAGE	DW   0		       ;;  code page
KC_ENTRY_PTR	DD   0		       ;; ptr to Specific Translate Section
				       ;;
endstruc;;
				       ;;
				       ;;
;; Everything from here down is new
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; State Logic - pointed to by KL_LOGIC_PTR in KEYBSYS_LANG_ENTRY
;; Common Translate Section follows immediately after the State Logic.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
struc KEYBSYS_STATE_LOGIC;;
				       ;;
KT_LOGIC_LEN: dw 0;; length of state logic
KT_SPECIAL_FEATURES: dw 0;; Special Features (see KEYBSHAR.INC)
KT_LOGIC_CMDS	DB   0		       ;; state logic commands begin here
				       ;;
endstruc;;
				       ;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Translate Section - Common and Specific Translate Sections
;; are both in this form.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
struc KEYBSYS_XLAT_SECT;;
				       ;;
KX_SECTION_LEN: dw 0;; Length of this section
KX_CP_ID: dw 0;; code page id
KX_FIRST_STATE: db 0;;
				       ;;
endstruc;;
				       ;;
				       ;;
struc KEYBSYS_STATE;;
	     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	     ;; Translate Sections contains multiple States.
	     ;; A State contains the translate tables for a single
	     ;; shift state (IE lower case, upper case ....)
	     ;; The last State is a null State containing only the
	     ;; KX_STATE_LEN field with a value of 0.
	     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KX_STATE_LEN: dw 0;; length of state section
KX_STATE_ID: db 0;; State ID
KX_KBD_TYPE: dw 0;; Keyboard Type
KX_ERROR_CHAR: dw 0;; Buffer entry for error character
KX_FIRST_XLAT: db 0;; XLAT tables begin here
	     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	     ;; Each State consists of multiple translate tables.
	     ;; The last translate table within a state is a null
	     ;; table containing only the
	     ;; KX_XLAT_LEN field with a value of 0.
	     ;; Refer to KEYBSHAR.INC for translate table format.
	     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
endstruc;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .LIST

