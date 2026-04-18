; Fastxxx equates
FastOpen_ID	   equ	   1
FastSeek_ID	   equ	   2
Fast_yes	   equ	   10000000B	 ; fastxxx flag

;Structure definitions
;
struc Fasttable_Entry; Fastxxx  Entry pointer in DOS
Fast_Entry_Num	    dw	    2		 ; number of entries
FastOpen_Seek: resd 1; fastopen & fastseek entry address
endstruc
;
