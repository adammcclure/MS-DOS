;m
	; PAGE	,132;
	; TITLE	MODE COMMAND - MAIN PROCEDURE AND COMMAND PARSING
; .XLIST
   %include "STRUC.INC"
; .LIST
;.SALL


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

;  AC001 - P3976: Need to have all pieces of messages in MODE.SKL so have to
;		  implement the SYSGETMSG method of getting addressability to
;		  the pieces.  This means that the code does a SYSGETMSG call
;		  which returns a pointer (DS:SI) to the message piece.  The
;		  address is then put in the sublist block for the message
;		  being issued.

;  AN002 - P4011: Need to close all open handles before terminating and staying
;		  resident so don't eat into the total available handles for the
;		  system.
;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

%include "SYSMSG.INC"

MSG_UTILNAME <MODE>


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

false	EQU	00H
STDIN	    EQU   0		       ;AN002;handle for standard input device
STDPRN	    EQU   4		       ;AN002;handle for standard printer device
TERMINATE EQU	4CH			;INT 21 "TERMINATE RETURNING CODE" FUNCTION
terminate_and_stay_resident    EQU   31H   ;INT 21 "terminate and remain resident"
truu	 EQU   0FFH

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º


;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


	; PAGE
SECTION .PRINTF_CODE
	; ASSUME	CS:PRINTF_CODE,DS:PRINTF_CODE,SS:PRINTF_CODE


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

global main
global SYSDISPMSG
global SYSGETMSG


;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

extern analyze_and_invoke
extern get_machine_type;get model and sub-model bytes
extern initialize_sublists;see display.asm
extern move_destination;location of res code after it has been moved
extern noerror
extern parse_parameters
extern PRINTF
extern rescode_length;length in paragraphs of the resident code
extern stay_resident;boolean indicating just loaded resident code see 'rescode'

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º


	DB	"The MODE command "
	DB	"--------------------------------------------------------------"

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ	P R O C E D U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

close_handles:;AN002;close all standard device handles
					  ;AN002;
MOV   AH,3EH				  ;AN002;
					  ;AN002;
.FOR BX = STDIN TO STDPRN		  ;AN002;
   INT	 21H				  ;AN002;
.NEXT BX				  ;AN002;
					  ;AN002;
RET					  ;AN002;
					  ;AN002;
; ENDP close_handles;AN002;

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ	P R O C E D U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


;
;-------------------------------------------------------------------------------

MSG_SERVICES <MSGDATA>		    ;define message service data area

MSG_SERVICES <LOADmsg,GETmsg,DISPLAYmsg,CHARmsg,NUMmsg,INPUTmsg>	;AC001;
MSG_SERVICES <mode.cla,mode.clb,mode.cl1,mode.cl2>    ;class B is for messages > 30
;;RPS  MSG_SERVICES <mode.cl1,mode.cl2>


main:

CALL  SYSLOADMSG		    ;load the message text
; .IF NC THEN;IF messages loaded successfully THEN
   CALL  get_machine_type
   CALL  initialize_sublists
   CALL  parse_parameters
   ; .IF <noerror EQ truu> THEN;no problems parsing so continue
      CALL  analyze_and_invoke		  ;semantically analyze the parms and invoke appropriate routine
   ; .ENDIF

   MOV	AH,TERMINATE		       ;assume won't stay resident
   ; .IF <noerror EQ false> THEN
      MOV  AL,1 		       ;had a problem somewhere
   ; .ELSE
      ; .IF   <stay_resident EQ truu> THEN
	 CALL  close_handles		  ;close all standard devices;AN002;
	 MOV  DX,move_destination
	 MOV  CL,4			  ;4 right shifts = divide by 16
	 SAR  DX,CL			  ;DX=offset of start of resident code in paragraphs
					  ;SET END OF RESIDENT CODE FOR "terminate and remain resident"
					  ;TO first usable
	 ADD   DX,rescode_length	  ;BYTE OF PROGRAM segment PREFIX
	 MOV  AH,terminate_and_stay_resident
      ; .ENDIF
      MOV  AL,0 		       ;all went well
   ; .ENDIF
; .ELSE;ABORT

   CALL  SYSDISPMSG			  ;display some "I'm crashing" message

; .ENDIF


INT	21H			 ;TERMINATE RETURNING ERRORLEVEL INDICATING success
RET

%include "msgdcl.inc"

; ENDP main

PRINTF_CODE ENDS
	; END
