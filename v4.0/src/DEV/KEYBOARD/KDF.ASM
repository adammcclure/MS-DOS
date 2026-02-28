

	; PAGE	,132
	; TITLE	DOS - Keyboard Definition File

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DOS - - NLS Support - Keyboard Definition File
;; (c) Copyright 1988 Microsoft
;;
;; This the file header and table pointers ONLY.
;; The actual tables are contained in seperate source files.
;; These are:
;;	     KDFSP.ASM	- Spanish
;;	     KDFPO.ASM	- Portuguese
;;	     KDFGR.ASM	- German
;;	     KDFIT.ASM	- Italian
;;	     KDFFR.ASM	- French
;;	     KDFSG.ASM	- Swiss German
;;	     KDFSF.ASM	- Swiss French
;;	     KDFDK.ASM	- Danish
;;	     KDFUK.ASM	- English
;;	     KDFBE.ASM	- Belgium
;;	     KDFNL.ASM	- Netherlands
;;	     KDFNO.ASM	- Norway
;;	     KDFLA.ASM	- Latin American
;;	     KDFSV.ASM	- SWEDEN
;;	     KDFSU.ASM	- Finland
;;	     Dummy US	- US
;; Linkage Instructions:
;;	The following instructions are contained in KDFLINK.BAT:
;;
;;	LINK KDF+KDFSP+KDFGE+KDFFR+KDFIT+KDFPO+KDFUK+KDFSG+KDFDK+KDFEOF;
;;	EXE2BIN KDF.EXE KEYBOARD.SYS
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
				       ;;
SECTION .CODE;;
	; ASSUME CS:CODE,DS:CODE;;
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;***************************************
;; File Header
;;***************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
DB   0FFh,'KEYB   '                  ;; signature
times 8 db 0;; reserved
DW   650			     ;; maximum size of Common Xlat Sect
DW   350			     ;; max size of Specific Xlat Sect
DW   400			     ;; max size of State Logic
DD   0				     ;; reserved
DW   17 			     ;; number of languages
DB   'SP'
DW   SP_LANG_ENT,0
DB   'PO'
DW   PO_LANG_ENT,0
DB   'FR'
DW   FR_LANG_ENT,0
DB   'DK'
DW   DK_LANG_ENT,0
DB   'SG'
DW   SG_LANG_ENT,0
DB   'GR'
DW   GE_LANG_ENT,0
DB   'IT'
DW   IT_LANG_ENT,0
DB   'UK'
DW   UK_LANG_ENT,0
DB   'SF'
DW   SF_LANG_ENT,0
DB   'BE'
DW   BE_LANG_ENT,0
DB   'NL'
DW   NL_LANG_ENT,0
DB   'NO'
DW   NO_LANG_ENT,0
DB   'CF'
DW   CF_LANG_ENT,0
DB   'SV'
DW   SV_LANG_ENT,0
DB   'SU'
DW   SV_LANG_ENT,0
DB   'LA'
DW   LA_LANG_ENT,0
DB   'US'
DW   DUMMY_ENT,0
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;***************************************
;; Language Entries
;;***************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
   extern SP_LOGIC;;
   extern SP_437_XLAT;;
   extern SP_850_XLAT;;
				       ;;
SP_LANG_ENT:			       ;; language entry for SPANISH
  DB   'SP'                            ;;
  DW   0			       ;; reserved
  DW   SP_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   437			       ;; code page
  DW   SP_437_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   SP_850_XLAT,0	       ;; table pointer
				       ;;
;****************************************************************************
   extern PO_LOGIC;;
   extern PO_860_XLAT;;
   extern PO_850_XLAT;;
				       ;;
PO_LANG_ENT:			       ;; language entry for POTUGAL
  DB   'PO'                            ;;
  DW   0			       ;; reserved
  DW   PO_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   860			       ;; code page
  DW   PO_860_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   PO_850_XLAT,0	       ;; table pointer
				       ;;
;*****************************************************************************
    extern FR_LOGIC;;
    extern FR_437_XLAT;;
    extern FR_850_XLAT;;
					;;
 FR_LANG_ENT:				;; language entry for POTUGAL
   DB	'FR'                            ;;
   DW	0				;; reserved
   DW	FR_LOGIC,0		;; pointer to LANG kb table
   DW	2				;; number of code pages
   DW	437				;; code page
   DW	FR_437_XLAT,0		;; table pointer
   DW	850				;; code page
   DW	FR_850_XLAT,0		;; table pointer
					;;
;*****************************************************************************
   extern DK_LOGIC;;
   extern DK_865_XLAT;;
   extern DK_850_XLAT;;
					;;
 DK_LANG_ENT:				;; language entry for POTUGAL
   DB	'DK'                            ;;
   DW	0				;; reserved
   DW	DK_LOGIC,0		;; pointer to LANG kb table
   DW	2				;; number of code pages
   DW	865				;; code page
   DW	DK_865_XLAT,0		;; table pointer
   DW	850				;; code page
   DW	DK_850_XLAT,0		;; table pointer
					;;
;*****************************************************************************
   extern SG_LOGIC;;
   extern SG_437_XLAT;;
   extern SG_850_XLAT;;
				       ;;
SG_LANG_ENT:			       ;; language entry for POTUGAL
  DB   'SG'                            ;;
  DW   0			       ;; reserved
  DW   SG_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   437			       ;; code page
  DW   SG_437_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   SG_850_XLAT,0	       ;; table pointer
				       ;;
;*****************************************************************************
   extern SF_LOGIC;;
   extern SF_437_XLAT;;
   extern SF_850_XLAT;;
				       ;;
SF_LANG_ENT:			       ;; language entry for SWISS FRENCH
  DB   'SF'                            ;;
  DW   0			       ;; reserved
  DW   SF_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   437			       ;; code page
  DW   SF_437_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   SF_850_XLAT,0	       ;; table pointer
				       ;;
;*****************************************************************************
   extern GE_LOGIC;;
   extern GE_437_XLAT;;
   extern GE_850_XLAT;;
				       ;;
GE_LANG_ENT:			       ;; language entry for POTUGAL
  DB   'GR'                            ;;
  DW   0			       ;; reserved
  DW   GE_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   437			       ;; code page
  DW   GE_437_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   GE_850_XLAT,0	       ;; table pointer
				       ;;
;*****************************************************************************
    extern IT_LOGIC;;
    extern IT_437_XLAT;;
    extern IT_850_XLAT;;
					;;
 IT_LANG_ENT:				;; language entry for POTUGAL
   DB	'IT'                            ;;
   DW	0				;; reserved
   DW	IT_LOGIC,0		;; pointer to LANG kb table
   DW	2				;; number of code pages
   DW	437				;; code page
   DW	IT_437_XLAT,0		;; table pointer
   DW	850				;; code page
   DW	IT_850_XLAT,0		;; table pointer
					;;
;*****************************************************************************
    extern UK_LOGIC;;
    extern UK_437_XLAT;;
    extern UK_850_XLAT;;
					;;
 UK_LANG_ENT:				;; language entry for POTUGAL
   DB	'UK'                            ;;
   DW	0				;; reserved
   DW	UK_LOGIC,0		;; pointer to LANG kb table
   DW	2				;; number of code pages
   DW	437				;; code page
   DW	UK_437_XLAT,0		;; table pointer
   DW	850				;; code page
   DW	UK_850_XLAT,0		;; table pointer
					;;
;*****************************************************************************
   extern BE_LOGIC;;
   extern BE_437_XLAT;;
   extern BE_850_XLAT;;
				       ;;
BE_LANG_ENT:			       ;; language entry for POTUGAL
  DB   'BE'                            ;;
  DW   0			       ;; reserved
  DW   BE_LOGIC,0	       ;; pointer to LANG kb table
  DW   2			       ;; number of code pages
  DW   437			       ;; code page
  DW   BE_437_XLAT,0	       ;; table pointer
  DW   850			       ;; code page
  DW   BE_850_XLAT,0	       ;; table pointer
					;;
;*****************************************************************************
;*****************************************************************************
     extern NL_LOGIC;;
     extern NL_437_XLAT;;
     extern NL_850_XLAT;;
					 ;;
  NL_LANG_ENT:				 ;; language entry for NETHERLANDS
    DB	 'NL'                            ;;
    DW	 0				 ;; reserved
    DW	 NL_LOGIC,0		 ;; pointer to LANG kb table
    DW	 2				 ;; number of code pages
    DW	 437				 ;; code page
    DW	 NL_437_XLAT,0		 ;; table pointer
    DW	 850				 ;; code page
    DW	 NL_850_XLAT,0		 ;; table pointer
				     ;;
;*****************************************************************************
;*****************************************************************************
     extern NO_LOGIC;;
     extern NO_865_XLAT;;
     extern NO_850_XLAT;;
					 ;;
  NO_LANG_ENT:				 ;; language entry for NORWAY
    DB	 'NO'                            ;;
    DW	 0				 ;; reserved
    DW	 NO_LOGIC,0		 ;; pointer to LANG kb table
    DW	 2				 ;; number of code pages
    DW	 865				 ;; code page
    DW	 NO_865_XLAT,0		 ;; table pointer
    DW	 850				 ;; code page
    DW	 NO_850_XLAT,0		 ;; table pointer
				     ;;
;*****************************************************************************
;*****************************************************************************
     extern SV_LOGIC;;
     extern SV_437_XLAT;;
     extern SV_850_XLAT;;
					 ;;
  SV_LANG_ENT:				 ;; language entry for SWEDEN
    DB	 'SV'                            ;;
    DW	 0				 ;; reserved
    DW	 SV_LOGIC,0		 ;; pointer to LANG kb table
    DW	 2				 ;; number of code pages
    DW	 437				 ;; code page
    DW	 SV_437_XLAT,0		 ;; table pointer
    DW	 850				 ;; code page
    DW	 SV_850_XLAT,0		 ;; table pointer
				     ;;
;*****************************************************************************
;*****************************************************************************
;    EXTRN SU_LOGIC:NEAR		 ;;
;    EXTRN SU_437_XLAT:NEAR		 ;;
;    EXTRN SU_850_XLAT:NEAR		 ;;
;					 ;;
; SU_LANG_ENT:				 ;; language entry for FINLAND
;   DB	 'SU'                            ;;
;   DW	 0				 ;; reserved
;   DW	 OFFSET SU_LOGIC,0		 ;; pointer to LANG kb table
;   DW	 2				 ;; number of code pages
;   DW	 437				 ;; code page
;   DW	 OFFSET SU_437_XLAT,0		 ;; table pointer
;   DW	 850				 ;; code page
;   DW	 OFFSET SU_850_XLAT,0		 ;; table pointer
;				     ;;
;*****************************************************************************
;*****************************************************************************
     extern CF_LOGIC;;
     extern CF_863_XLAT;;
     extern CF_850_XLAT;;
					 ;;
  CF_LANG_ENT:				 ;; language entry for Canadian-French
    DB	 'CF'                            ;;
    DW	 0				 ;; reserved
    DW	 CF_LOGIC,0		 ;; pointer to LANG kb table
    DW	 2				 ;; number of code pages
    DW	 863				 ;; code page
    DW	 CF_863_XLAT,0		 ;; table pointer
    DW	 850				 ;; code page
    DW	 CF_850_XLAT,0		 ;; table pointer
				     ;;
;*****************************************************************************
     extern LA_LOGIC;;
     extern LA_850_XLAT;;
     extern LA_437_XLAT;;
					 ;;
  LA_LANG_ENT:				 ;; language entry for Canadian-French
    DB	 'LA'                            ;;
    DW	 0				 ;; reserved
    DW	 LA_LOGIC,0		 ;; pointer to LANG kb table
    DW	 2				 ;; number of code pages
    DW	 850				 ;; code page
    DW	 LA_850_XLAT,0		 ;; table pointer
    DW	 437				 ;; code page
    DW	 LA_437_XLAT,0		 ;; table pointer
				     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
DUMMY_ENT:			       ;; language entry
  DB   'XX'                            ;;
  DW   0			       ;; reserved
  DW   DUMMY_LOGIC,0	       ;; pointer to LANG kb table
  DW   5			       ;; number of code pages
  DW   437			       ;; code page
  DW   DUMMY_XLAT_437,0	       ;; table pointer
  DW   850			       ;; code page
  DW   DUMMY_XLAT_850,0	       ;; table pointer
  DW   860			       ;; code page
  DW   DUMMY_XLAT_860,0	       ;; table pointer
  DW   863			       ;; code page
  DW   DUMMY_XLAT_863,0	       ;; table pointer
  DW   865			       ;; code page
  DW   DUMMY_XLAT_865,0	       ;; table pointer
				       ;;
DUMMY_LOGIC:			       ;;
   DW  LOGIC_END-$		       ;; length
   DW  0			       ;; special features
   DB  92H,0,0			       ;; EXIT_STATE_LOGIC_COMMAND
LOGIC_END:			       ;;
				       ;;
DUMMY_XLAT_437: 		       ;;
   DW	  6			       ;; length of section
   DW	  437			       ;; code page
   DW	  0			       ;; LAST STATE
				       ;;
DUMMY_XLAT_850: 		       ;;
   DW	  6			       ;; length of section
   DW	  850			       ;; code page
   DW	  0			       ;; LAST STATE
				       ;;
DUMMY_XLAT_860: 		       ;;
   DW	  6			       ;; length of section
   DW	  860			       ;; code page
   DW	  0			       ;; LAST STATE
				       ;;
DUMMY_XLAT_865: 		       ;;
   DW	  6			       ;; length of section
   DW	  865			       ;; code page
   DW	  0			       ;; LAST STATE
				       ;;
DUMMY_XLAT_863: 		       ;;
   DW	  6			       ;; length of section
   DW	  863			       ;; code page
   DW	  0			       ;; LAST STATE
				       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;*****************************************************************************
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;;
; END SECTION .CODE;;
	 ; END;;
