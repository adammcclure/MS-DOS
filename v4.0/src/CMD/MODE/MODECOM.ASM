; PAGE ,132;														   ;AN000;
; TITLE MODECOM.ASM - RS232 SUPPORT FOR THE MODE COMMAND;AN000;
															   ;AN000;
; .XLIST;AN000;
%include "STRUC.INC";AN000;
; .LIST;AN000;

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
;  AC000 - P2852: Loading resident code trashed CX which was used as a shift
;		  count.

;  AC001 - P3540: PS/2 only parms other than baud not being treated properly.

;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
%macro DISPLAY 1;AN000;
	MOV	DX,MESSAGE											   ;AN000;
	CALL	PRINTF													   ;AN000;
%endmacro;AN000;
															   ;AN000;
;------------------------------------------------------------------------						   ;AN000;
															   ;AN000;
%macro ABORT 0;AN000;
	JMP	ENDIF01 												   ;AN000;
%endmacro;AN000;
															   ;AN000;
															   ;AN000;
;------------------------------------------------------------------------						   ;AN000;
															   ;AN000;
%include "common.stc";contains the following structure								   ;AN000;
															   ;AN000;
															   ;AN000;
;parm_list_entry   STRUC		   ;used by parse_parameters and invoke 					   ;AN000;
;															   ;AN000;
;parm_type	      DB       bogus											   ;AN000;
;item_tag	      DB       0FFH											   ;AN000;
;value1 	      DW       bogus	   ;used only for filespecs and code page numbers				   ;AN000;
;value2 	      DW       bogus	   ;used only for filespecs and code page numbers				   ;AN000;
;keyword_switch_ptr   DW       0											   ;AN000;
;															   ;AN000;
;parm_list_entry   ENDS 												   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ E Q U A T E S ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											º				   ;AN000;
															   ;AN000;

%include "modequat.inc";AN000;include definition of false, machine types

															   ;AN000;
AT_family   EQU 0FCH		 ;model byte for 286 boxes								   ;AN000;
DEV1	    EQU "1"              ;CHAR IN "COM1:"                                                                          ;AN000;
DEV2	    EQU "2"              ;CHAR IN "COM2:"                                                                          ;AN000;
DEV3	    EQU "3"              ;CHAR IN "COM3:"                                                                          ;AN000;
DEV4	    EQU "4"              ;CHAR IN "COM4:"                                                                          ;AN000;
OFFTO	    EQU modeto		 ;OFFSET OF MODETO IN RESIDENT CODE FROM SEGMENT					   ;AN000;
				 ; STORED AT 530H BY MODELOAD								   ;AN000;
not_specified	     EQU   0												   ;AN000;
parm_list	     EQU   [BP] 											   ;AN000;
;Roughrider  EQU 05		  ;sub model byte									    ;AN000;
SPACE	    EQU " "              ;BLANK CHARACTER                                                                          ;AN000;
;Trailboss   EQU 04		  ;sub model byte for 'Trailboss'                                                           ;AN000;
true	    EQU 0FFH													   ;AN000;
;Wrangler    EQU 0F8H		  ;primary model byte									    ;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;

				; BEGINNING OF PROC MODETO)								   ;AN000;
SECTION .ROM;AN000;
    ORG    50H														   ;AN000;
VECT14H:;RS232 CALL, POINTS TO PROC MODETO WHEN 						   ;AN000;
				; WHEN CODE IS RESIDENT 								   ;AN000;
    ORG    400H 													   ;AN000;
SERIAL_BASE:;SERIAL PORT ADDRESSES									   ;AN000;
	ORG	530H													   ;AN000;
RESSEG:;VECTOR OF MODETO, WHEN RESIDENT							   ;AN000;
; END SECTION .ROM;AN000;
; PAGE;AN000;
SECTION .PRINTF_CODE;AN000;
	   ; ASSUME CS:PRINTF_CODE,DS:PRINTF_CODE;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
extern B_item_tag;see modepars										   ;AN000;
extern baud_19200;AN000;
extern busy_retry_active;see invoke.asm									   ;AN000;
extern E_item_tag;see modepars										   ;AN000;
extern eight_item_tag;see modepars										   ;AN000;
extern ERR1;AN000;
extern even_item_tag;see modepars										   ;AN000;
extern error_retry_active;see invoke.asm									   ;AN000;
extern five_item_tag;see modepars										   ;AN000;
extern fourtyeighthundred_item_tag;see modepars.asm								   ;AN000;
extern fourtyeighthundred_str;AN000;
extern illegal_device_ptr;see modesubs.inc									   ;AN000;
extern INITMSG,DEVICE,PPARITY,PDATA,PSTOP,PPARM;AN000;
extern keyword;AN000;
extern machine_type;see 'rescode'                                                                            ;AN000;
extern mark_item_tag;see modepars										   ;AN000;
extern MODELOAD;AN000;
extern MODETO;AN000;
extern new_com_initialize;flag indicating that a PS/2 only parm was specified			   ;AC001;
extern nineteentwohundred_item_tag;see modepars.asm								   ;AN000;
extern nineteentwohundred_str;see modepars.asm								   ;AN000;
extern ninetysixhundred_item_tag;AC001;
extern ninetysixhundred_str;AN000;
extern no_retry_active;see invoke.asm									   ;AN000;
extern noerror;boolean indicating success of previous actions					   ;AN000;
extern none_item_tag;see modepars										   ;AN000;
extern onefifty_str;AN000;
extern oneten_item_tag;see modepars.asm									   ;AN000;
extern oneten_str;AN000;
extern onefifty_item_tag;see modepars.asm									   ;AN000;
extern one_point_five_item_tag;see modepars.asm								   ;AN000;
extern one_point_five_str;see modesubs.inc									   ;AN000;
extern p_item_tag;see modepars.asm									   ;AN000;
extern parm_lst;parm_list_entry  max_pos_parms DUP (<>)						   ;AN000;
extern parms_form;AN000;
extern pstop_ptr;see modedefs.inc									  ;AN000;
extern odd_item_tag;see modepars										   ;AN000;
extern one_item_tag;see modepars										   ;AN000;
extern PBAUD_ptr;see 'modemes'                                                                            ;AN000;
extern PRINTF;AN000;
extern PARM1,PARM2,PARM3,MODE,FLAG;AN000;
;PARM1	DB	10 DUP(0)												   ;AN000;
;PARM2	DB	0													   ;AN000;
;PARM3	DB	0													   ;AN000;
;MODE	DB	0													   ;AN000;
;FLAG	DB	0													   ;AN000;
extern R_item_tag;AN000;
extern RATEMSG;CR,LF,"Invalid baud rate specified",BEEP,CR,LF,"$"                                              ;AN000;
extern ready_retry_active;see invoke.asm									   ;AN000;
;EXTRN	RES_MODEFLAG:ABS	;RETRY FLAG IN RESIDENT CODE, (OFFSET FROM						   ;AN000;
extern res_com_retry_type;retry type flag, displacement from address pointed to by 50:30 when code is resident, see rescode
extern seven_item_tag;see modepars 									   ;AN000;
extern sixhundred_item_tag;see modepars.asm									   ;AN000;
extern sixhundred_str;AN000;
extern six_item_tag;see modepars										   ;AN000;
extern space_item_tag;see modepars										   ;AN000;
extern submodel_byte;see 'rescode'                                                                               ;AN000;
extern threehundred_item_tag;see modepars.asm									   ;AN000;
extern threehundred_str;AN000;
extern twelvehundred_item_tag;see modepars.asm 								   ;AN000;
extern twelvehundred_str;AN000;
extern twentyfourhundred_str;AN000;
extern twentyfourhundred_item_tag;see modepars.asm								   ;AN000;
extern two_item_tag;see modepars										   ;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
global baud_index;holder of the index in the parm list of the baud rate requested			   ;AN000;
global data_bits_index;set by invoke										   ;AN000;
global MODECOM;AN000;
global parity_index;set by invoke										   ;AN000;
global SERIAL_BASE;Make available to RESCODE and MAIN							   ;AN000;
global retry_index;make available to analyze_and_invoke							   ;AN000;
global setcom;get it listed in the link map								   ;AN000;
global setto;get it listed in link map for debugging						   ;AN000;
global stop_bits_index;set by invoke										   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
															   ;AN000;
;THESE FOLLOWING BAUD RATES REPRESENT THE 1ST 2 CHAR									   ;AN000;
baud_index  DW	     TYPE parm_list_entry ;holder of the index into the parm list of the baud rate			   ;AN000;
data_bits_index DW   0	   ;holder of the index into the parm list of the data bits					   ;AN000;
parity_index	DW   0	   ;holder of the index into the parm list of the parity					   ;AN000;
stop_bits_index DW   0	   ;holder of the index into the parm list of the stop bits					   ;AN000;
retry_index	DW   0													   ;AN000;
															   ;AN000;
;INITMSG    DB	  CR,LF 												   ;AN000;
;	    DB	  "COM"                                                                                                    ;AN000;
;DEVICE     DB	  " "                                                                                                      ;AN000;
;	    DB	  ": "             ;SEPARATOR BLANK                                                                        ;AN000;
;PBAUD	    DB	  4 DUP(" ")                                                                                               ;AN000;
;	    DB	  ","    ;SEPARATOR                                                                                        ;AN000;
;PPARITY    DB	  "e"    ;DEFAULT IS EVEN PARITY                                                                           ;AN000;
;	    DB	  ","    ;SEPARATOR                                                                                        ;AN000;
;PDATA	    DB	  "7"    ;DEFAULT IS 7 DATA BITS PER BYTE                                                                  ;AN000;
;	    DB	  ","    ;SEPARATOR                                                                                        ;AN000;
;PSTOP	    DB	  "1"    ;DEFAULT FOR BAUD > 110, CHANGED TO 2 FOR 110                                                     ;AN000;
;	    DB	  ","    ;SEPARATOR                                                                                        ;AN000;
;PPARM	    DB	  " "                                                                                                      ;AN000;
;	    DB	  CR,LF,"$"    ;END OF 'INITMSG'                                                                           ;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
; SUBTTL SET UP FOR SERIAL RETRY;AN000;
; PAGE;AN000;
;
;
;-------------------------------------------------------------------------------
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³									       ³
;³ SETTO								       ³
;³ -----								       ³
;³									       ³
;³  Set the resident retry flag to type of retry active for comx.	       ³
;³									       ³
;³  INPUT:  device - holds '1', '2', '3' or '4' (ascii) for x of lptx.         ³
;³	    retry_index - holds index value for the parsed retry parameter.    ³
;³	    resseg - holds offset of resident code in memory		       ³
;³	    res_com_retry_type - holds offset of com retry flag in resident    ³
;³	      code.							       ³
;³									       ³
;³									       ³
;³  RETURN: pparm - set to 'P', 'B', 'R', 'E', or '-' for type of retry active.³
;³	    flag in resident code set					       ³
;³									       ³
;³									       ³
;³  MESSAGES: none.							       ³
;³									       ³
;³									       ³
;³  REGISTER								       ³
;³  USAGE:	AL - new setting for resident flag. (see RESCODE.SAL for       ³
;³		     format)						       ³
;³		CL - shift bit count					       ³
;³		ES - holds segment of resident code			       ³
;³		BP - offset of parameter list				       ³
;³		DI - offset of retry index within parameter list	       ³
;³		DL - current resident flag setting			       ³
;³									       ³
;³									       ³
;³  PSUEDO CODE:							       ³
;³									       ³
;³	SAVE REGISTERS							       ³
;³	SET UP SEGMENT REGISTER AND BIT MASKS				       ³
;³	IF <RETRY REQUESTED>						       ³
;³	   SET UP PARAMETER LIST STRUCTURE				       ³
;³	   SET BIT MASK FOR TYPE OF RETRY AND SET pparm TO PROPER LETTER       ³
;³	   IF <RESIDENT CODE IS NOT LOADED>				       ³
;³	      LOAD RESIDENT CODE					       ³
;³	   ENDIF							       ³
;³	   GET CURRENT com_lpt_retry_type				       ³
;³	   SET AND STORE NEW com_lpt_retry_type 			       ³
;³	ELSEIF <RESIDENT CODE ALREADY LOADED>				       ³
;³	   GET CURRENT com_lpt_retry_type				       ³
;³	   IF <POSITIONAL PARAMETER SPECIFIED>				       ³
;³	      SET FLAG TO ZERO, SET pparm TO PROPER LETTER		       ³
;³	   ELSE 							       ³
;³	      SET pparm TO PROPER LETTER FOR CURRENT SETTING		       ³
;³	   ENDIF							       ³
;³	ELSE								       ³
;³	   SET pparm TO '-'                                                    ³
;³	ENDIF								       ³
;³	RESTORE REGISTERS						       ³
;³	RETURN								       ³
;³									       ³
;³									       ³
;³									       ³
;³  SIDE EFFECT: Loads resident code if it is needed and has not been loaded.  ³
;³									       ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
;
SETTO:;AN663;
															   ;AN663;
      PUSH ES			;save registers 									   ;AN663;
      PUSH DI														   ;AN663;
      PUSH AX														   ;AN663;
      PUSH DX														   ;AN663;
															   ;AN663;
      XOR  AX,AX		;clear a reg										   ;AN663;
      MOV  ES,AX		;set to segment at 0									   ;AN663;
      MOV  CL,device													   ;AN663;
      AND  CL,07H													   ;AN663;
      DEC  CL														   ;AN663;
      SHL  CL,1 													   ;AN663;
      MOV  DH,11111100B 	;set bit mask to clear old flag setting 						   ;AN663;
      ROL  DH,CL													   ;AN663;
															   ;AN663;
      ; .IF <retry_index NE 0> THEN;retry specified, set						   ;AN663;
							;  byte in resident code					   ;AN663;
	 MOV  DI,retry_index				;  to proper setting.						   ;AN663;
							;  if code is not loaded,					   ;AN663;
	 .SELECT					;  loaded it.							   ;AN663;
	 .WHEN <parm_list[DI].item_tag EQ P_item_tag>									   ;AN663;
	    MOV  AL,busy_retry_active											  ;AN663;
	    MOV  pparm,'p'                                                                                                 ;AN663;
	 .WHEN <parm_list[DI].item_tag EQ E_item_tag>									   ;AN663;
	    MOV  AL,error_retry_active											   ;AN663;
	    MOV  pparm,'e'                                                                                                 ;AN663;
	 .WHEN <parm_list[DI].item_tag EQ B_item_tag>									   ;AN663;
	    MOV  AL,busy_retry_active											   ;AN663;
	    MOV  pparm,'b'                                                                                                 ;AN663;
	 .WHEN <parm_list[DI].item_tag EQ R_item_tag>									   ;AN663;
	    MOV  AL,ready_retry_active											   ;AN663;
	    MOV  pparm,'r'                                                                                                 ;AN663;
	 .ENDSELECT													   ;AN663;
															   ;AN663;
	 ; .IF <<WORD PTR ES:resseg> EQ 0000H> THEN;AN663;
	    PUSH  CX					;save shift count
	    CALL modeload				;load the resident code 					   ;AN663;
	    POP   CX					;restore shift count
	 ; .ENDIF;AN663;
															   ;AN663;
	 MOV  ES,ES:word resseg[2]											   ;AN663;
	 MOV  DL,byte ES:res_com_retry_type 									   ;AN663;
							;get the old setting						   ;AN663;
	 ROL  AL,CL													   ;AN663;
	 AND  DL,DH													   ;AN663;
	 OR   DL,AL													   ;AN663;
	 MOV  byte ES:res_com_retry_type,DL 	;store the new setting						   ;AN663;
															   ;AN663;
      .ELSEIF <<word ES:resseg> NE 0000H> THEN	;if code is loaded but no					   ;AN663;
							;  retry is specified then					   ;AN663;
	 MOV  ES,ES:word resseg[2]											   ;AN663;
	 MOV  DL,byte ES:res_com_retry_type 									   ;AN663;
															   ;AN663;
	 ; .IF <parms_form NE keyword>;if 'NONE' was specified                                           ;AN663;
							;  with positional parameter					   ;AN663;
	    AND  DL,DH					;  set bits to zero						   ;AN663;
	    MOV  byte ES:res_com_retry_type,DL									   ;AN663;
															   ;AN663;
	 ; .ELSE;else update pparm with 					   ;AN663;
							;  current retry type						   ;AN663;
	    NOT  DH													   ;AN663;
	    AND  DL,DH													   ;AN663;
	    SHR  DL,CL													   ;AN663;
															   ;AN663;
	    .SELECT					;set pparm to proper letter					   ;AN663;
	    .WHEN <DL EQ no_retry_active>										   ;AN663;
	       MOV  pparm,'-'                                                                                              ;AN663;
	    .WHEN <DL EQ error_retry_active>										   ;AN663;
	       MOV  pparm,'e'                                                                                              ;AN663;
	    .WHEN <DL EQ busy_retry_active>										   ;AN663;
	       MOV  pparm,'b'                                                                                              ;AN663;
	    .WHEN <DL EQ ready_retry_active>										   ;AN663;
	       MOV  pparm,'r'                                                                                              ;AN663;
	    .ENDSELECT													   ;AN663;
															   ;AN663;
	 ; .ENDIF;AN663;
															   ;AN663;
      ; .ELSE;no retry, no code resident					   ;AN663;
															   ;AN663;
	 MOV  pparm,'-'                                                                                                    ;AN663;
															   ;AN663;
      ; .ENDIF;AN663;
															   ;AN663;
      POP  DX														   ;AN663;
      POP  AX			;restore registers									   ;AN663;
      POP  DI														   ;AN663;
      POP  ES														   ;AN663;
      RET														   ;AN663;
															   ;AN663;
; ENDP SETTO;AN663;



; SUBTTL SET SERIAL PROTOCOL
; PAGE

;------------------------------------------------------------------------------

;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
;³									       ³
;³ SETCOM								       ³
;³ ------								       ³
;³									       ³
;³									       ³
;³									       ³
;³  INPUT:								       ³
;³									       ³
;³									       ³
;³									       ³
;³									       ³
;³									       ³
;³									       ³
;³  RETURN:								       ³
;³									       ³
;³									       ³
;³									       ³
;³  MESSAGES: none.							       ³
;³									       ³
;³									       ³
;³  REGISTER								       ³
;³  USAGE:								       ³
;³									       ³
;³									       ³
;³  ASSUMPTIONS: All parms have been checked for validity as being possible and³
;³		 supported on the machine.				       ³
;³									       ³
;³									       ³
;³									       ³
;³  SIDE EFFECT:							       ³
;³									       ³
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SETCOM:;AN000;
															   ;AN000;
															 ;AN000;
MOV   BP,parm_lst   ;address the parm list via parm_list which is [BP]						;AN000;
MOV    DI,baud_index	    ;DI=index into parm list of the baud rate entry						;AN000;

.SELECT 		   ;prepare AL for old init and CL for new init 						;AC001;

   .WHEN <parm_list[DI].item_tag EQ oneten_item_tag>									;AC001;
      MOV   AL,0													;AN000;
      MOV   CL,0
      MOV   pbaud_ptr,oneten_str 										;AN000;
   .WHEN <parm_list[DI].item_tag EQ onefifty_item_tag> THEN							      ;AN000;
      MOV   AL,00100000B												;AN000;
      MOV   CL,1
      MOV   pbaud_ptr,onefifty_str										;AN000;
   .WHEN <parm_list[DI].item_tag EQ threehundred_item_tag> THEN 						      ;AN000;
      MOV   AL,01000000B												;AN000;
      MOV   CL,2
      MOV   pbaud_ptr,threehundred_str										;AN000;
   .WHEN <parm_list[DI].item_tag EQ sixhundred_item_tag> THEN							      ;AN000;
      MOV   AL,01100000B												;AN000;
      MOV   CL,3
      MOV   pbaud_ptr,sixhundred_str										;AN000;
   .WHEN <parm_list[DI].item_tag EQ twelvehundred_item_tag> THEN						      ;AN000;
      MOV   AL,10000000B												;AN000;
      MOV   CL,4
      MOV   pbaud_ptr,twelvehundred_str										;AN000;
   .WHEN <parm_list[DI].item_tag EQ twentyfourhundred_item_tag> THEN						      ;AN000;
      MOV   AL,10100000B												;AN000;
      MOV   CL,5
      MOV   pbaud_ptr,twentyfourhundred_str									;AN000;
   .WHEN <parm_list[DI].item_tag EQ fourtyeighthundred_item_tag> THEN						      ;AN000;
      MOV   AL,11000000B												;AN000;
      MOV   CL,6
      MOV   pbaud_ptr,fourtyeighthundred_str									;AN000;
   .WHEN <parm_list[DI].item_tag EQ ninetysixhundred_item_tag> THEN							;AN000;
      MOV   AL,11100000B												;AN000;
      MOV   CL,7
      MOV   pbaud_ptr,ninetysixhundred_str									;AN000;
   .WHEN <parm_list[DI].item_tag EQ nineteentwohundred_item_tag> NEAR THEN   ;handle 19200 case if 19, 19200, 19.2 or 19.2K specified
      MOV   CL,8	      ;value for 19200 baud, no old equivalent							;AC001;
      MOV   pbaud_ptr,nineteentwohundred_str									;AC001;

.ENDSELECT													     ;AC001;
;	   AL IS:  XXX00000 for the baud rate, CL has appropriate value for baud

MOV   DI,parity_index												  ;AN000;
; .IF <parm_list[DI].item_tag EQ none_item_tag> THEN;AN000;
   MOV PPARITY,"n"          ;set up message for no PARITY                                                       ;AN000;
   MOV	 BH,0		    ;AL already set properly for old init						  ;AN000;
.ELSEIF <parm_list[DI].item_tag EQ odd_item_tag> THEN								  ;AN000;
   MOV PPARITY,"o"          ;set up message for odd PARITY                                                       ;AN000;
   OR	 AL,08H 	    ;PUT THE 000XX000 BITS TO AL PARM WHERE XX=01 FOR PARITY=ODD			 ;AN000
   MOV	 BH,1		    ;new initialize									 ;AN000;
.ELSEIF <parm_list[DI].item_tag EQ space_item_tag> THEN 							   ;AN000;
   MOV PPARITY,"s"          ;set up message for space PARITY                                                       ;AN000;
   MOV	 BH,4		    ;SPACE not supported in old init							  ;AN000;
.ELSEIF <parm_list[DI].item_tag EQ mark_item_tag> THEN								  ;AN000;
   MOV PPARITY,"m"          ;set up message for mark PARITY                                                       ;AN000;
   MOV	 BH,3		    ;MARK parity not supported in old init						  ;AN000;
; .ELSE;not specified or asked for even							  ;AN000;
   MOV PPARITY,"e"          ;set up message for even PARITY, the default if not specified                        ;AN000;
   OR	 AL,18H 	    ;PUT THE 000XX000 BITS TO AL PARM WHERE XX=11 FOR PARITY=EVEN			 ;AN000
   MOV	 BH,2			 ;even parity for new initialize						 ;AN000;
; .ENDIF;AN000;

MOV   DI,data_bits_index											  ;AN000;
; .IF <parm_list[DI].item_tag EQ five_item_tag> THEN;AN000;
   MOV	 pdata,"5"            ;set up message for 5 bits                                                         ;AN000;
   MOV	 CH,0		      ;not old init for 5 data bits							  ;AN000;
.ELSEIF <parm_list[DI].item_tag EQ six_item_tag> THEN								  ;AN000;
   MOV	 pdata,"6"            ;set up message for 6 bits                                                         ;AN000;
   MOV	 CH,1		      ;no old init for 6 data bits							  ;AN000;
.ELSEIF <parm_list[DI].item_tag EQ eight_item_tag> THEN 							  ;AN000;
   MOV	 pdata,"8"            ;set up message for 8 bits                                                         ;AN000;
   OR	 AL,03H 	    ;IN THE 000000XX POSITION, SET XX=11 TO MEAN 8 DATA BITS				     ;AN000;
   MOV	 CH,3													  ;AN000;
; .ELSE;asked for 7 or skipped the parm and will get 7 as default			  ;AN000;
   OR	 AL,02H 	    ;IN THE 000000XX POSITION, SET XX=10 TO MEAN 7 DATA BITS				     ;AN000;
   MOV	 CH,2		      ;message already set up for 7 bits						  ;AN000;
; .ENDIF;AN000;

;PUT THE NO. STOP BITS TO AL PARM IN THE 00000X00 POSITION and BL for new init						     ;AN000
MOV   DI,stop_bits_index											  ;AN000;
MOV   BL,0		      ;assume stop bits was 1, message already set up				      ;AN000;
.SELECT
														  ;AN000;
   .WHEN <parm_list[DI].item_tag EQ two_item_tag>							;AN000;
      MOV   pstop,"2"         ;set up message for 2 stop bits                                         ;AN000;
      MOV   BL,1	      ;value for two or 1.5								    ;AN000;

   .WHEN <parm_list[DI].item_tag EQ one_point_five_item_tag>		     ;AN000;				  ;AN000;
      MOV   pstop_ptr,one_point_five_str 	       ;set up message for 1.5 stop bits		  ;AN000;
      MOV   BL,1	      ;new init for 1.5 								;AN000;

   .WHEN <stop_bits_index EQ not_specified>		 ;if stop bits not specified			   ;AN000;
      MOV   DI,baud_index												;AC000;
      ; .IF <parm_list[DI].item_tag EQ oneten_item_tag>;BAUD=110 SPECIFIED THEN SET DEFAULT STOP BITS TO TWO 	;AC000;
	 OR    AL,04H		  ;TURN ON BIT IN 00000X00 POSITION TO REQUEST 2 STOP BITS		 ;AN000;
	 MOV   pstop,"2"         ;set up message for 2 stop bits                                         ;AN000;
      ; .ENDIF;FOR STOPBITS=1, LEAVE THAT BIT OFF, message already set by modecom	;AN000;

;  .OTHERWISE specified 1, everything set up

.ENDSELECT		   ;IF not 1.5 or two, already set up for 1						;AN000;
														  ;AN000;
; .IF <new_com_initialize EQ true> THEN;AC001;
   XOR	 AL,AL		   ;ask for no break									     ;AN000;
   MOV	 AH,4		   ;new set baud BIOS call								     ;AN001;
; .ELSE;old style com initialization						    ;AN000;	 ;AC001;
   XOR	 AH,AH		   ;AH=0 requests initialization								 ;AC001;
; .ENDIF;AC001;

														      ;AN000;
;SET DX PARM TO REQUEST WHICH COM DEVICE									   ;AN000;
 XOR   DX,DX													   ;AN000;
 MOV   DL,DEVICE	       ;device set by modepars in first_parm_case:					   ;AN000;
 AND   DL,07		       ;convert to binary 1 thru 4							   ;AN000;
 DEC   DL		       ;put in BIOS digestable 0 thru 3 						   ;AN000;
;	    AH ALREADY IS 0 or 4, WHICH REQUESTS								      ;AN000;
;	    INITIALIZATION OF THE RS232 									      ;AN000;
;	    ACCORDING TO PARMS IN AL and/or BX and CX.								      ;AN000;
 ; .IF <noerror EQ true> THEN;AN000;
    INT 14H		       ;INIT THE RS232									      ;AN000;
;														      ;AN000;
;	    NOW THAT THE RS232 IS INITIALIZED,									      ;AN000;
    CALL    SETTO	 ;LOOK AT P PARM, MAYBE TIMEOUT TO BE RETRIED						      ;AN000;
;														      ;AN000;
    DISPLAY INITMSG	       ;TELL USER RS232 IS INITIALIZED							      ;AN000;
 ; .ENDIF;AN000;

     RET														   ;AN000;
; ENDP SETCOM;AN000;
															   ;AN000;
															   ;AN000;
; SUBTTL;AN000;
; PAGE;AN000;
															   ;AN000;
															   ;AN000;

MODECOM:


       MOV    AL,DEVICE 	  ;AL= DEVICE ID OF "1", "2", "3" or "4"
       AND    AL,07		  ;TRANSLATE TO BINARY
       DEC    AL		  ;PUT IN ZERO BASE
       SAL    AL,1		  ;POSITION OF PORT ADDRESS WORD (2*AL)
       XOR    AH,AH		  ;CLEAR AH
       MOV    SI,AX
       XOR    AL,AL		  ;CLEAR AX
       PUSH   DS
       MOV    DS,AX
       CMP    word DS:SERIAL_BASE[SI],0	  ;SEE IF THE COM PORT EXISTS
       POP    DS
       JNE    THEN01A
	  MOV	DI,0			  ;the device name is always the first parm					    ;AN000;
	  MOV	BP,parm_lst   ;address the parm list via parm_list which is [BP] 				 ;AN000;
	  MOV	CX,parm_list[DI].value1 						    ;AN000;
	  MOV  illegal_device_ptr,CX
	  DISPLAY err1			 ;AN000;"Illegal device name - COMX"
	  MOV  noerror,false		  ;AN000;
	 ABORT
;
THEN01A:

;		     DEFINE DEFAULTS:
	 MOV PSTOP,"1"            ;ONE STOP BIT, OK FOR BAUD>110
	 MOV PDATA,"7"            ;7 DATA BITS
	 MOV PPARM,"-"            ;NO SERIAL TIMEOUT RETRY
;

;WE HAVE THE INFORMATION NEEDED TO INITIALIZE THE RS232 DEVICE
;
	 CALL SETCOM		  ;SET THE RS232 DEVICE
;
;    : ELSE ,SINCE COUNT WAS NOT BIG ENUF
ENDIF01:			 ;jump to here if the port does not exist
     RET			  ;RETURN TO MODE MAIN ROUTINE
; ENDP MODECOM
; END SECTION .PRINTF_CODE
    ; END
