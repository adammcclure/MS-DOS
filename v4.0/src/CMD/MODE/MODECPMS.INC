;MODECPMS.INC - INCLUDED IN MODECP.SAL 
 %if 1  ; IF1 - pass-specific
 %warning INCLUDE MODECPMS.INC;DESCRIPTIONS OF MESSAGES
 %endif

;$SALUT CP(0,2,9,32)	       ;(set preprocessor columns for indenting)

 extern CPMSG1;"Failure to access Codepage Font File",BEEP,CR,LF,EOM

 extern CPMSG2;"Failure to OPEN device: %S",CR,LF,EOM
 extern CPMSGLST2DEV;FILLED IN WITH PTR TO DEVICE NAME

 extern CPMSG3;"Missing from font file is either device or codepage",BEEP,CR,LF,EOM

 extern CPMSG4;"Font file contents invalid",CR,LF,EOM

 extern CPMSG5;"Previously prepared codepage deleted",BEEP,CR,LF,EOM

 extern CPMSG6;"Active codepage for %S is %D",CR,LF,EOM
 extern CPMSGLST6DEV;FILLED IN BY "QUERY" ROUTINE WITH PTR TO DEVICE NAME
 extern CPMSGLST6CP;FILLED IN BY "QUERY" ROUTINE WITH CODEPAGE ID

 extern CPMSG7;"Device %S not prepared",CR,LF,EOM
 extern CPMSGLST7DEV;FILLED IN BY "QUERY" ROUTINE WITH PTR TO DEVICE NAME

 extern CPMSG8;"%s codepages:",CR,LF,EOM
;AC001; EXTRN  CPMSGLST8HD:WORD       ;OFFSET TO "HARDWARE" OR "PREPARED"
 extern CPMSG8_HW;message number for "hardware ",EOM
 extern CPMSG8_PR;message number for "prepared ",EOM

 extern CPMSG9;"  Codepage %d",CR,LF,EOM
 extern CPMSGLST9CP;FILLED IN BY "QUERY" ROUTINE WITH CODEPAGE ID

 extern CPMSG10;"MODE %S Codepage function completed",CR,LF,EOM
;AC001; EXTRN  CPMSGLST10FUN:WORD     ;FILLED IN TO POINT TO:
 extern CPMSGxx_QUERY;message number for "Query",EOM
 extern CPMSGxx_PREP;message number for "Prepare",EOM
 extern CPMSGxx_REFRESH;message number for "Refresh",EOM
 extern CPMSGxx_SELECT;message number for "Select",EOM

 extern CPMSG12;"Current Codepage settings:",CR,LF,EOM

 extern CPMSG13;"   %D - %S Codepage",CR,LF,EOM
 extern CPMSGLST13CP;FILLED IN WITH CODEPAGE ID
;AC001; EXTRN  CPMSGLST13TYP:WORD     ;FILLED IN TO POINT TO:
 extern CPMSG13_ACT;message number for "Active"
 extern CPMSG13_SYS;message number for "System"

 extern CPMSG14;"  Codepage unprepared",CR,LF,EOM

 extern CPMSG15;"Device not supported for Codepage",BEEP,CR,LF,EOM

 extern CPMSG16;"No codepage has been selected",BEEP,CR,LF,EOM

 extern CPMSG17;"Device error during %S",BEEP,CR,LF,EOM
 extern CPMSG17_WRIT;message number for "write of font file to device",EOM

 extern CPMSG18;"Specified Codepage not prepared",BEEP,CR,LF,EOM

 extern CPMSG19;"Current keyboard does not support this Codepage",BEEP,CR,LF,EOM

 extern CPMSG20;"Error during read of font file",BEEP,CR,LF,EOM

 extern CPMSG21;CR,LF,"Unable to perform REFRESH",BEEP,EOM

;THE FOLLOWING DATA AREAS DEFINING MESSAGES CAN BE FOUND IN "MODEMES.ASM"

;CPMSG1 	DB    "Failure to access Codepage Font File",BEEP,CR,LF,EOM
;CPMSG1     DW	  CPMSG1

;CPMSG2 	DB    "Failure to access device: %S",BEEP,CR,LF,EOM
;CPMSG2     DW	  CPMSG2
;CPMSGLST2DEV	DW    ? 	;FILLED IN WITH PTR TO DEVICE NAME

;CPMSG3 	DB	;"Missing from font file is either device or codepage",BEEP,CR,LF,EOM
;CPMSG3     DW	  CPMSG3

;CPMSG4 	DB    "Font file contents invalid",BEEP,CR,LF,EOM
;CPMSG4     DW	  CPMSG4

;CPMSG5 	DB    "Previous prepared codepage deleted",BEEP,CR,LF,EOM
;CPMSG5     DW	  CPMSG5

;CPMSG6 	DB    "Active codepage for device %S is %D",CR,LF,EOM
;CPMSG6     DW	  CPMSG6
;CPMSGLST6DEV	DW    ? 	;FILLED IN BY "QUERY" ROUTINE WITH PTR TO DEVICE NAME
;CPMSGLST6CP	DW    ? 	;FILLED IN BY "QUERY" ROUTINE WITH CODEPAGE ID

;CPMSG7 	DB    "Device %S not prepared",CR,LF,EOM
;CPMSG7     DW	  CPMSG7
;CPMSGLST7DEV	DW    ? 	;FILLED IN BY "QUERY" ROUTINE WITH PTR TO DEVICE NAME

;CPMSG8 	DB    "%S codepages:",CR,LF,EOM
;CPMSG8     DW	  CPMSG8
;CPMSGLST8HD	DW    ? 	;OFFSET TO "HARDWARE" OR "PREPARED"
;CPMSG8_HW	DB    "hardware",EOM
;CPMSG8_PR	DB    "prepared",EOM

;CPMSG9 	DB    "  Codepage %d",CR,LF,EOM
;CPMSG9     DW	  CPMSG9
;CPMSGLST9CP	DW    ? 	;FILLED IN BY "QUERY" ROUTINE WITH CODEPAGE ID

;CPMSG10	 DB    "MODE %S Codepage function completed",CR,LF,EOM
;CPMSG10     DW    CPMSG10
;CPMSGLST10FUN	 DW    ?	 ;FILLED IN TO POINT TO:
;CPMSG10_QUERY	 DB    "Querry",EOM
;CPMSG10_DES	 DB    "Prepare",EOM
;CPMSG10_SELECT  DB    "Activate",EOM
;CPMSG10_REFRESH DB    "Refresh",EOM
;CPMSG10_GLOBAL  DB    "Global",EOM

;CPMSG11	 DB    "Error %S Global Codepage",CR,LF,EOM
;CPMSG11     DW    CPMSG11
;CPMSGLST11FUN	 DW    ?	;FILLED IN TO POINT TO:
;CPMSG11_SET	 DB    "setting",EOM
;CPMSG11_GET	 DB    "getting",EOM

;CPMSG12	 DB    "Current Codepage settings:",CR,LF,EOM
;CPMSG12     DW    CPMSG12

;CPMSG13	 DB    "   %D - %S Codepage",CR,LF,EOM
;CPMSG13     DW    CPMSG13
;CPMSGLST13CP	 DW    ?	;FILLED IN WITH CODEPAGE ID
;CPMSGLST13TYP	 DW    ?	;FILLED IN TO POINT TO:
;CPMSG13_ACT	 DB    "Active",EOM
;CPMSG13_SYS	 DB    "System",EOM

;CPMSG14	 DB    "  Codepage unprepared",CR,LF,EOM
;CPMSG14     DW    CPMSG14

;CPMSG15	 DB    "Device not supported for Codepage",BEEP,CR,LF,EOM
;CPMSG15     DW    CPMSG15

;CPMSG16	 DB    "No codepage has been selected",BEEP,CR,LF,EOM
;CPMSG16     DW    CPMSG16

;CPMSG17	 DB	"Device error during %S",BEEP,CR,LF,EOM
;CPMSG17     DW     CPMSG17
;CPMSGLST17FUN	 DW	?	;FILLED IN TO POINT TO:
;CPMSG17_QUERY	 DB	"Query",EOM
;CPMSG17_PREP	 DB	"Prepare",EOM
;CPMSG17_REFRESH DB	"Refresh",EOM
;CPMSG17_ACT	 DB	"Activate",EOM

;CPMSG17_WRIT	 DB	"write of font file to device",EOM

;CPMSG18	 DB	"Specified Codepage not prepared",BEEP,CR,LF,EOM
;CPMSG18     DW     CPMSG18

;CPMSG19	 DB	"Current keyboard does not support this Codepage",BEEP,CR,LF,EOM
;CPMSG19     DW     CPMSG19

;CPMSG20	 DB	"Error during read of font file",BEEP,CR,LF,EOM
;CPMSG20     DW     CPMSG20

;CPMSG21	 DB	"Unable to perform REFRESH operation",BEEP,CR,LF,EOM
;CPMSG21     DW     CPMSG21
