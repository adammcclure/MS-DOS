
; .XLIST

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOS - NLS Support - KEYB Command
;; (C) Copyright 1988 Microsoft
;;
;; File Name:  KEYBTBBL.INC
;; ----------
;;
;; Description:
;; ------------
;;	 Include file containing structure definitions Shared Data Area
;;	 for the Shared Data Area.
;;	 The Shared Data Area contains data which is required by
;;	 both the resident and transient KEYB code.  The Shared
;;	 Data Area is allocated in the KEYBI2F file and will be
;;	 resident following initial installation.
;;
;; Change History:
;; ---------------
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					       ;;
	extern TABLE_BUILD;;
	extern FIND_CP_TABLE;;
					       ;;
	extern CPN_INVALID;;
	extern SD_LENGTH;;
					       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .LIST
