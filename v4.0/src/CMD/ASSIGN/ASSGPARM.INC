
 ASS_PARMS:
      dw	ASS_PARMSX
      db	1   ;list of extra delimiters
      db	3   ;0 length
      db	";+="

 ASS_PARMSX:
      db	0,1

;Min 0 - no drive or switch specified
;Max 1 - maximal allowance of drive letters
;repeats

      dw	ASS_POS1  ;positional ctl ptr
      db	1	  ;# of switches
      dw	ASS_SW1   ;switch ptr

  ASS_POS1:
       dw	 2010h	  ;Simple string,
			   ;ignore colon, &
			   ;repeat
			   ;allowed
       dw	 0002h	   ;Cap result by
			   ; character table
       dw	 Result_Val   ;tbl
       dw	 Res_CTLVAL ;value list
       db	 0	   ;no switch or
			   ;keyword synonyms
       db	 0	   ;alternative keyword

 ASS_SW1:
		dw	  0	    ;20010h    ;Simple string,
				    ;ignore colon & repeat
				    ;allowed
		dw	  0002h     ;Cap result by
				    ;character table
		dw	  Result_Valsw ;tbl
		dw	  0	       ; ;value list
		db	  2	       ;switch or
				       ;keyword synonyms
 SW_Syn1	db	  "/STATUS",0  ;alternate keyword
 SW_Syn2	db	  "/STA",0     ;alternate keyword


 Res_CTLVAL:
      db	3	 ;List of simple strings
      db	0	 ;not in range defn.
      db	0	 ;not in numeric defn.
      db	26	 ;# of strings defined
      db	"A"        ;item tag
			 ;value returned
      dw	DRVA_PTR ;string ptr
      db	"B"        ;item tag
			 ;value returned
      dw	DRVB_PTR ;string ptr
      db	"C"        ;item tag
			 ;value returned
      dw	DRVC_PTR ;string ptr
      db	"D"        ;item tag
			 ;value returned
      dw	DRVD_PTR ;string ptr
      db	"E"        ;item tag
			 ;value returned
      dw	DRVE_PTR ;string ptr
      db	"F"        ;item tag
			 ;value returned
      dw	DRVF_PTR ;string ptr
      db	"G"        ;item tag
			 ;value returned
      dw	DRVG_PTR ;string ptr
      db	"H"        ;item tag
			 ;value returned
      dw	DRVH_PTR ;string ptr
      db	"I"        ;item tag
			 ;value returned
      dw	DRVI_PTR ;string ptr
      db	"J"        ;item tag
			 ;value returned
      dw	DRVJ_PTR ;string ptr
      db	"K"        ;item tag
			 ;value returned
      dw	DRVK_PTR ;string ptr
      db	"L"        ;item tag
			 ;value returned
      dw	DRVL_PTR ;string ptr
      db	"M"        ;item tag
			 ;value returned
      dw	DRVM_PTR ;string ptr
      db	"N"        ;item tag
			 ;value returned
      dw	DRVN_PTR ;string ptr
      db	"O"        ;item tag
			 ;value returned
      dw	DRVO_PTR ;string ptr
      db	"P"        ;item tag
			 ;value returned
      dw	DRVP_PTR ;string ptr
      db	"Q"        ;item tag
			 ;value returned
      dw	DRVQ_PTR ;string ptr
      db	"R"        ;item tag
			 ;value returned
      dw	DRVR_PTR ;string ptr
      db	"S"        ;item tag
			 ;value returned
      dw	DRVS_PTR ;string ptr
      db	"T"        ;item tag
			 ;value returned
      dw	DRVT_PTR ;string ptr
      db	"U"        ;item tag
			 ;value returned
      dw	DRVU_PTR ;string ptr
      db	"V"        ;item tag
			 ;value returned
      dw	DRVV_PTR ;string ptr
      db	"W"        ;item tag
			 ;value returned
      dw	DRVW_PTR ;string ptr
      db	"X"        ;item tag
			 ;value returned
      dw	DRVX_PTR ;string ptr
      db	"Y"        ;item tag
			 ;value returned
      dw	DRVY_PTR ;string ptr
      db	"Z"        ;item tag
			 ;value returned
      dw	DRVZ_PTR ;string ptr

 DRVA_PTR:
      db       "A",0

 DRVB_PTR:
      db       "B",0

 DRVC_PTR:
      db       "C",0

 DRVD_PTR:
      db       "D",0

 DRVE_PTR:
      db       "E",0

 DRVF_PTR:
      db       "F",0

 DRVG_PTR:
      db       "G",0

 DRVH_PTR:
      db       "H",0

 DRVI_PTR:
      db       "I",0

 DRVJ_PTR:
      db       "J",0

 DRVK_PTR:
      db       "K",0

 DRVL_PTR:
      db       "L",0

 DRVM_PTR:
      db       "M",0

 DRVN_PTR:
      db       "N",0

 DRVO_PTR:
      db       "O",0

 DRVP_PTR:
      db       "P",0

 DRVQ_PTR:
      db       "Q",0

 DRVR_PTR:
      db       "R",0

 DRVS_PTR:
      db       "S",0

 DRVT_PTR:
      db       "T",0

 DRVU_PTR:
      db       "U",0

 DRVV_PTR:
      db       "V",0

 DRVW_PTR:
      db       "W",0

 DRVX_PTR:
      db       "X",0

 DRVY_PTR:
      db       "Y",0

 DRVZ_PTR:
      db       "Z",0

 RESULT_VAL:
 RESULT_VALSW:

   RES_TYPE  db        0       ;Result_type
   RES_ITAG  db        0       ;Matched
				  ;item tag
   RES_SYN   dw        0       ;synonym
			       ;returned
   RES_SOFF  dw        0       ;drive type
			       ;or beginning
			       ;of string
			       ;may be string
   RES_SEG   dw        0       ;string offset
			    ;if type specified


;=========================================================================
;	Sublist Definition Area
;=========================================================================

Parse_Sublist:

		db	Sublist_Length	;sublist length 			;an002; dms;
		db	Reserved	;reserved for future growth		;an002; dms;
Parse_Sub_Off: dw 0;offset of replaceable parm		;an002; dms;
Parse_Sub_Seg: dw 0;segment of replaceable parm		;an002; dms;
		db	0		;replaceable parm 0			;an002; dms;
		db	Left_Align+Char_Field_ASCIIZ ;				;an002; dms;
		db	40		;max width				;an002; dms;
		db	1		;min width				;an002; dms;
		db	20h		;blank fill				;an002; dms;




