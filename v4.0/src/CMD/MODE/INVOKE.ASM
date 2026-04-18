															   ;AN000;
;m															   ;AN000;
	; PAGE	,132;										   ;AN000;
	; TITLE	ANALYZE_AND_INVOKE - call appropriate routine based on request;AN000;
; .XLIST;AN000;
   %include "STRUC.INC";AN000;
; .LIST;AN000;
;.SALL															   ;AN000;


;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
;  AC000 - P2944: Was displaying the lines and column settings for CON even
;		  though couldn't get them when ANSI.SYS isn't loaded.  Now
;		  check if ANSI loaded before trying to display the settings.

;  AC002 - P3331: ES was getting zeroed, which caused problems later in MODECP.

;  AC003 - P3541: The retry status routine was assuming different format than
;		  the retry type byte was in.  I fixed the status checking
;		  routine.

;  AX004 - P3982: The screen was being cleared after the "Unable to shift
;		  screen ..." message.

;  AC005 - P4934: The multiplex number for ANSI.SYS was changed due to a
;     5/20/88	  conflict with a Microsoft product that has already been
;		  shipped.

;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
%macro GET_EXTENDED_ERROR 0;AN000;
															   ;AN000;
MOV   BX,0		;level for 3.00 to 4.00 									   ;AN000;
MOV   AH,59H		;function number for get extended error 							   ;AN000;
INT   21H														   ;AN000;
															   ;AN000;
%endmacro;AN000;
															   ;AN000;
															   ;AN000;
%macro BREAK 1;AN000;
   JMP	   endcase_&X													   ;AN000;
%endmacro;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
%macro DISPLAY 1;AN000;
	MOV	DX,MESSAGE											   ;AN000;
	CALL	PRINTF													   ;AN000;
%endmacro;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  M A C R O S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
%include "modequat.inc";AN000;
															   ;AN000;
ANSIINT2F   EQU   1AH	   ;INT 2F multiplex number for ANSI.SYS							   ;AC005;
ASCII_0  EQU   "0"         ;change one based binary printer number into ASCII printer number                               ;AN000;
ASCII_1  EQU   "1"                                                                                                         ;AN000;
B	 EQU   2	   ;retry setting										   ;AN000;
blink	 EQU   0000H	  ;value for flags field of IOCTL data block							   ;AN000;
busy_retry_active	EQU   2     ;indicates bust retry is active							   ;AN000;
check_installed   EQU	0  ;request installed state for INT2F (ANSI)							   ;AN000;
;COLUMNS	   EQU	 00000010B   ;											    ;AN000;
com1_retry_type_status	EQU   0     ;request for retry status on com1							   ;AN000;
com2_retry_type_status	EQU   2     ;request for retry status on com2							   ;AN000;
com3_retry_type_status	EQU   4     ;request for retry status on com3							   ;AN000;
com4_retry_type_status	EQU   6     ;request for retry status on com4							   ;AN000;
display_device EQU   3	   ;type of device, used for calls to IOCTL 0C function 					   ;AN000;
E	 EQU   1	   ;retry setting										   ;AN000;
error_retry_active	EQU   1     ;indicates error retry is active							   ;AN000;
false	 EQU   00H													   ;AN000;
font_not_loaded      EQU   31	    ;return from IOCTL 0C (via ext err) indicating DISPLAY.SYS don't have necessary font loaded
get_current_settings EQU   07FH     ;request for IOCTL 0C call								   ;AN000;
installed	     EQU   0FFH     ;return from get_installed_state function						   ;AN000;
intense  EQU   0001H	  ;value for flags field of IOCTL data block							   ;AN000;
IOCTL0C  EQU   [SI]													   ;AN000;
;LINES		   EQU	 00000001B   ;flag for IOCTL0C_functions_requested						    ;AN000;
lowercase	     EQU   020H     ;when ORed with char value it changes it to lowercase				  ;AN000;
LPT1		     EQU   1	    ;mask for input to display_device_reroute_status, see modeecho			   ;AN000;
LPT2		     EQU   2	    ;mask for input to display_device_reroute_status, see modeecho			   ;AN000;
LPT3		     EQU   4	    ;mask for input to display_device_reroute_status, see modeecho			   ;AN000;
lpt1_retry_type_status	EQU   0     ;request for retry status on lpt1							   ;AN000;
lpt2_retry_type_status	EQU   1     ;request for retry status on lpt2							   ;AN000;
lpt3_retry_type_status	EQU   2     ;request for retry status on lpt3							   ;AN000;
MODE_INT2F_MULTIPLEX_NUMBER   EQU   0											   ;AN000;
no_retry       EQU   3	   ;retry setting										   ;AN000;
no_retry_active 	EQU   0     ;indicates no retry active on device						   ;AN000;
not_supported_on_machine   EQU	 29 ;return from IOCTL 0C (via ext err) indicating hardware don't support the function     ;AN000;
parm_list_BX   EQU   [BX]												   ;AN000;
prn_ports_attached	EQU   CL    ;used in printer_reroute_case and check_prn_ports_attached
R	 EQU   3	   ;retry setting for com ports 								   ;AN000;
ready_retry_active	EQU   3     ;indicates ready retry is active							   ;AN000;
redirected		EQU   2     ;network puts a 2 in printer address word for printers redirected
rerouted_printer_mask	EQU   BL    ;holds the mask to check ptsflag1 with, see modeecho.asm
returned_retry_type	EQU   AL    ;holds the returned status value							   ;AN000;
set_display_characteristics   EQU   05FH  ;request for IOCTL 0C call							   ;AN000;
status	 EQU   0		    ;request for modecp 								   ;AN000;
StdOut			equ	1											   ;AN000;
text	 EQU   01	   ;mode field of IOCTL 0C call indicating screen mode type (vs APA mode)			   ;AN000;
true	 EQU   0FFH													   ;AN000;
unspecified		EQU   0FFH  ;state of item_tags in parm_list if the positonal parm was not specified		   ;AN664;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E Q U A T E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
															   ;AN000;
struc des_strt_packet;AN000;
   des_strt_pkfl  DW	0000	       ;assume a filename specified							   ;AN000;
   des_strt_pklen DW	02	       ;start with size of 'des_strt_pknum'                                                ;AN000;
   des_strt_pknum DW	0	       ;number of cp numbers in the packet						   ;AN000;
   des_strt_pkcp1 DW	-1	       ;code page number for 1st slot							   ;AN000;
   des_strt_pkcp2 DW	-1												   ;AN000;
   des_strt_pkcp3 DW	-1												   ;AN000;
   des_strt_pkcp4 DW	-1												   ;AN000;
   des_strt_pkcp5 DW	-1												   ;AN000;
   des_strt_pkcp6 DW	-1												   ;AN000;
   des_strt_pkcp7 DW	-1												   ;AN000;
   des_strt_pkcp8 DW	-1												   ;AN000;
   des_strt_pkcp9 DW	-1												   ;AN000;
   des_strt_pkcpA DW	-1												   ;AN000;
   des_strt_pkcpB DW	-1												   ;AN000;
   des_strt_pkcpC DW	-1	       ;code page number for 12th slot							   ;AN000;
endstruc;AN000;
															   ;AN000;
;The info_level is 0 on input, and contains a return code on exit. If carry set 					   ;AN000;
;and 2 then the requested function is not supported on this machine.  If carry						   ;AN000;
;set and 3 then DISPLAY.SYS does not have the appropriate RAM font loaded to						   ;AN000;
;support the requested function.											   ;AN000;
															   ;AN000;
struc IOCTL0C_def;AN000;
															   ;AN000;
info_level  DB	  0	;return code: 0 on input, 1 ?, 2 or 3 as returns						   ;AN000;
	    resb 1;reserved											   ;AN000;
data_length DW	  14	;length of the data block not including this field						   ;AN000;
flags	    DW	  0	;filled with intense or blink									   ;AN000;
mode	    DB	  text	;filled with text, may be returned as 2 which means APA 					   ;AN000;
	    resb 1;reserved											   ;AN000;
colors	    DW	  16	;0 means monochrome										   ;AN000;
	    resw 1;width in pixels for APA modes									   ;AN000;
	    resw 1;length in pixels for APA modes 								   ;AN000;
cols	    DW	  bogus ;nubmer of text columns 									   ;AN000;
rows	    DW	  bogus ;number of text rows										   ;AN000;
															   ;AN000;
endstruc;AN000;
															   ;AN000;
%include "COMMON.STC";includes the following strucs									   ;AN000;
															   ;AN000;
;codepage_parms STRUC													   ;AN000;
;   cp_device	   DW	 ?												   ;AN000;
;   des_pack_ptr   DW	 ?												   ;AN000;
;   font_filespec  DW	 ?												   ;AN000;
;   request_typ    DW	 ?												   ;AN000;
;codepage_parms ENDS													   ;AN000;
															   ;AN000;
															   ;AN000;
;parm_list_entry   STRUC		   ;used by parse_parameters and invoke 					   ;AN000;
															   ;AN000;
;parm_type	      DB       bogus											   ;AN000;
;item_tag	      DB       0FFH											   ;AN000;
;value1 	      DW       bogus	   ;used only for filespecs and code page numbers				   ;AN000;
;value2 	      DW       bogus	   ;used only for filespecs and code page numbers				   ;AN000;
;keyword_switch_ptr   DW    0												   ;AN000;
															   ;AN000;
;parm_list_entry   ENDS 												   ;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  S T R U C T U R E S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
SECTION .ROM;AN000;
	ORG	530H													   ;AN000;
resseg:;location of resident mode code vector							   ;AN000;
; END SECTION .ROM;AN000;
															   ;AN000;
															   ;AN000;
	; PAGE;AN000;
SECTION .PRINTF_CODE;AN000;
	; ASSUME	CS:PRINTF_CODE,DS:PRINTF_CODE,SS:PRINTF_CODE;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
global analyze_and_invoke;make available to "MAIN"                                                                 ;AN000;
global busy_retry_active;used by modecom									   ;AN000;
global cp_cb;modepars needs to set the font file name						   ;AN000;
global error_retry_active;used by modecom 								   ;AN000;
global initialize_printer_port_case;AN000;
global no_retry_active;used by modecom									   ;AN000;
global parm_list_holder;used by modeprin									   ;AN664;
global ready_retry_active;used by modecom 								   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P U B L I C S  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
extern ANSI_not_loaded;see modedefs.inc									   ;AN000;
extern BAUD_equal;the string "BAUD=", see modepars                                          ;AN000;
extern BAUD_index;see modecom.asm							   ;AN000;
extern B_str;see MODEPARS.ASM								   ;AN000;
extern BW40;see modedefs.inc 									   ;AN000;
extern BW40_item_tag;see MODEPARS.ASM								   ;AN000;
extern BW80;see modedefs.inc 									   ;AN000;
extern BW80_item_tag;see MODEPARS.ASM								   ;AN000;
extern busy_status
extern close;EQU  3EH   ;CLOSE A FILE HANDLE,see modecpeq.inc 					   ;AN000;
extern columns_ptr;see modesubs.inc								   ;AN000;
extern CO40;see modedefs.inc 									   ;AN000;
extern CO40_item_tag;see MODEPARS.ASM								   ;AN000;
extern CO80;see modedefs.inc 									   ;AN000;
extern CO80_item_tag;see MODEPARS.ASM								   ;AN000;
extern codepage_index_holder;see MODEPARS.ASM								   ;AN000;
extern codepage_item_tag;see MODEPARS.ASM								   ;AN000;
extern columns_equal;see MODEPARS.ASM								   ;AN000;
extern columns_equal_msg;see MODEdefS.inc								   ;AN000;
extern columns_holder;holder for printer chars per line (binary) value, see modeprin		   ;AN000;
extern COLS_equal;see MODEPARS.ASM								   ;AN000;
extern columns_item_tag;see MODEPARS.ASM								   ;AN000;
extern COM1_str;see MODEPARS.ASM								   ;AN000;
extern COM2_str;see MODEPARS.ASM								   ;AN000;
extern COM3_str;see MODEPARS.ASM								   ;AN000;
extern COM4_str;see MODEPARS.ASM								   ;AN000;
extern COMX;one of two possible values for "device_type"
extern CON_str;"CON"see MODEPARS.ASM                                                        ;AN000;
extern CRLF;see MODEDEFS.ASM, used before "Invalid parameter - " for consistent spacing      ;AN000;
extern data_bits_index;see modecom.asm								   ;AN000;
extern DATA_equal;see MODEPARS.ASM							   ;AN000;
extern DELAY_equal;see MODEPars.asm								   ;AN000;
extern DEL_equal;see MODEPARS.ASM								   ;AN000;
extern des_start_packet;AX000; des_strt_packet <>, see modepars 					   ;AN000;
extern device;holder of com number for invoke and modeecho					   ;AN000;
extern device_name;AN000;
extern device_type;see MODEPARS.ASM								;AN000;
extern dev_name_size;see MODEPARS.ASM								   ;AN000;
extern dev_open_mode;read write access								   ;AN000;
extern display_printer_reroute_status;see modeecho.asm
extern eighty_item_tag;see MODEPARS.ASM								   ;AN000;
extern eighty_str;see MODEPARS.ASM								   ;AN000;
extern error_status;see MODEPRIN
extern five_char_underline;see modedefs.inc								   ;AN000;
extern four_char_underline;see modedefs.inc								   ;AN000;
extern function_not_supported;see modedefs.inc							   ;AN000;
extern err1;see modedefs.inc
extern E_str;see MODEPARS.ASM								   ;AN000;
extern fourty_item_tag;see MODEPARS.ASM								   ;AN000;
extern fourty_str;see MODEPARS.ASM								   ;AN000;
extern handle_40_or_80;see modescrn								   ;AN000;
extern illegal_device_ptr;see modesubs.inc
extern keyword;see MODEPARS								   ;AN000;
extern invalid_number_of_parameters;AN000;
;EXTRN	  invalid_parameter:WORD      ;<CR><LF>"Invalid parameter '????'",beep                                              ;AN000;
extern len_COMX_str;see MODEPARS.ASM								   ;AN000;
extern len_CON_str;see MODEPARS.ASM								   ;AN000;
extern len_LPTX_str;see MODEPARS.ASM								   ;AN000;
extern L_item_tag;see MODEPARS.ASM								   ;AN000;
extern LINES_equal;see MODEPARS.ASM								   ;AN000;
extern LINES_equal_msg;see MODEDEFS.INC							   ;AN000;
extern lines_item_tag;see MODEPARS.ASM								   ;AN000;
extern long_underline;see modedefs.inc								   ;AN000;
extern lptno;holder of printer number for invoke and modeecho				   ;AN000;
extern lpt1_retry_type;see RESCODE
extern LPT1_str;see MODEPARS.ASM								   ;AN000;
extern LPT2_str;see MODEPARS.ASM								   ;AN000;
extern LPT3_str;see MODEPARS.ASM								   ;AN000;
extern notredpt;printer number in "LPTn not rerouted"
extern max_request_type;see MODEPARS.ASM								   ;AN000;
extern modecom;AN000;
extern modecp;AN000;
extern modeecho;AN000;
extern modeecno;AN000;
extern modeprin;AN000;
extern modify_resident_code;see modeprin							   ;AN000;
extern MONO;see modedefs.inc 									   ;AN000;
extern MONO_item_tag;see MODEPARS.ASM								   ;AN000;
extern no_retry_flag;see MODEPRIN
extern noerror;AN000;
extern none_item_tag;see modepars.asm								   ;AN000;
extern none_str;see MODEPARS.ASM								   ;AN000;
extern offending_parameter;see MODEMES									   ;AN000;
extern OFF_item_tag;see pares.asm								   ;AN000;
extern off_str;see MODEPARS.ASM								   ;AN000;
extern onethirtytwo_item_tag;see modepars.asm								   ;AN000;
extern ON_item_tag;see pares.asm								   ;AN000;
extern on_str;see MODEPARS.ASM								   ;AN000;
extern open;open a device handle, see modecpeq.inc						   ;AN000;
extern parity_equal;see modepars.asm									   ;AN000;
extern parity_index;see modecom									   ;AN000;
extern parm2;see MODEPRIN.ASM									   ;AN000;
extern parm3;see MODEPARS.ASM									   ;AN000;
;EXTRN	  parm_lst:BYTE 	     ;parm_list_entry  max_pos_parms DUP (<>), see MODEPARS.ASM 			   ;AN000;
extern parms_form;indicator of whether the parameters were entered as positionals or as keywords	   ;AN000;
extern pbaud_ptr;AN000;;pointer to the baud rate string in the initialization message for COM, see modesubs.inc
extern pdata;see modesubs.inc								   ;AN000;
extern pparity_ptr;see modesubs.inc								   ;AN000;
extern pparm;used by modecom and for message, see modesubs.inc				   ;AN000;
extern prepare;AN000;
extern prepare_item_tag;see MODEPARS.ASM								   ;AN000;
extern PRINTR;PRINTER BASE (40:8), HOLDS PORT ADDRESSES OF PRINTER CARDS
extern pstop_ptr;see modesubs.inc								   ;AN000;
extern PRINTF;AN000;
extern rate_equal;see MODEPARS.ASM 								   ;AN000;
extern ready_status;see modeprin
extern redpt;printer number (n) in message "LPTn rerouted to COMm"
extern refresh;AN000;
extern retry_item_tag;see MODEPARS.ASM								   ;AN000;
extern request_type;see "MODEPARS.ASM"                                                                 ;AN000;
extern retry_equal;see MODEDEFS.INC								   ;AN000;
extern retry_equal_str;AN000;
extern retry_index;see MODECOM.ASM 								   ;AN000;
extern retry_type_ptr;see MODESUBS.INC								   ;AN000;
extern row_ptr;see modesubs.inc							   ;AN000;
extern row_type;see modesubs.inc							   ;AN000;
extern R_item_tag;see MODEPARS.ASM								   ;AN000;
extern R_str;see MODEPARS.ASM								   ;AN000;
extern Required_font_not_loaded;see modedefs.asm								   ;AN000;
extern res_com_retry_type;see RESCODE.SAL								   ;AN000;
;EXTRN	  res_lpt_retry_type:ABS	      ;see RESCODE.SAL								    ;AN000;
extern select;request type for 'modecp'                                                   ;AN000;
extern select_item_tag;see MODEPARS.ASM								   ;AN000;
extern serial_base;see modecom								   ;AN000;
extern set_con_features;AN000;
extern set_retry_type;see modeprin								   ;AN000;
extern shift_screen;see modescrn								   ;AN000;
extern stat_dev_ptr;see modedefs.inc								   ;AN000;
extern status_for_device;"Status for device %1:" see modedefs.inc                                     ;AN000;
extern status_for_everything;AN000;
extern stop_bits_index;see modecom.asm								   ;AN000;
extern stop_equal;"STOP=", see modepars                                                        ;AN000;
extern typamat;see "typamat.asm"                                                                  ;AN000;
															   ;AN000;
;possible values of "request_type"                                                                                         ;AN000;
															   ;AN000;
extern all_con_status;AN000;
extern codepage_prepare;AN000;
extern codepage_refresh;AN000;
extern codepage_select;AN000;
extern codepage_status;AN000;
extern codepage_prepared_status;AN000;
extern codepage_selected_status;AN000;
extern com_status;AN000;
;EXTRN	  con_status:ABS												   ;AN000;
extern initialize_com_port;AN000;
extern initialize_printer_port;AN000;
extern old_initialize_printer_port;AN000;
extern old_video_mode_set;AN000;
extern printer_reroute;AN000;
extern printer_status;AN000;
extern turn_off_reroute;AN000;
															   ;AN000;
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  E X T R N S	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
															   ;AN000;
;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»				   ;AN000;
;º											  º				   ;AN000;
															   ;AN000;
ANSI_installed		DB    false	  ;boolean indicator of whether ANSI.SYS is installed				   ;AN000;
columns_specified	DB    false	  ;indicates if columns= was on the command line, see set_con_features_case;AN000;
code_page_numbers_encountered	 DB    0										   ;AN000;
cp_cb			codepage_parms <> ;codepage subroutine parameter block						   ;AN000;
com_ports_attached	DB    0 	  ;number of com ports in the machine
current_packet_cp_number   DW	 -2	  ;adjustment for accessing current 'des_strt_pkcp?' in 'des_start_packet'         ;AN000;
delay_holder		DB    1 	  ;holder for binary form of delay requested					   ;AN000;
device_request: db 0;holds device request value							   ;AN000;
max_pknum		EQU	 ($ - des_start_packet.des_strt_pkcp1)/2        ;most cp numbers can send at once   ;AN000;
;IOCTL0C_functions_requested   DB 0	   ;for displaying messages, flag byte indicating IOCTL functions requested	    ;AN000;
need_typamat_call	DB	 false	  ;boolean for saving up delay and rate settings				   ;AN000;
need_IOCTL0C		DB	 false	  ;boolean for saving up parts of an IOCTL 0CH call				   ;AN000;
parm_list_holder	DW    bogus	  ;holder for address of parsed parameter list for when BX is needed elsewhere	   ;AN000;
parm_list_index_holder	DW    bogus	  ;holder for index of parsed parameter list for when DI is needed elsewhere	   ;AN000;
i			DB    0 	  ;index for status loop							   ;AN000;
rate_holder		DB    32	  ;holder for binary form of rate value 					   ;AN000;
row_value: db 0;holder for binary form of row value during status display			   ;AN000;
															   ;AN000;
IOCTL0C_data_block   IOCTL0C_def<>											   ;AN000;

global IOCTL0C_data_block
															   ;AN000;
;º											  º				   ;AN000;
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  D A T A	ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼				   ;AN000;
															   ;AN000;
check_ANSI_installed:;See if ANSI.SYS is installed 						;AC001;

   MOV	 AH,ANSIINT2F													;AC001;
   MOV	 AL,check_installed												;AC001;
   INT	 2FH														;AC001;
   ; .IF <AL EQ installed> THEN;AC001;
      MOV   ANSI_installed,true 	  ;initialized to false, so no ELSE needed					;AC001;
   ; .ENDIF

; ENDP check_ANSI_installed;AC001;

;------------------------------------------------------------------------------



setup_device_name:;AN000;
															   ;AN000;
MOV   DX,device_name	      ;DX=pointer to ASCIIZ device name 							   ;AN000;
MOV   cp_cb.cp_device,DX	 ;Set the pointer to the device name ASCIIZ in the parameter block for 'modecp'.           ;AN000;
															   ;AN000;
RET															   ;AN000;
															   ;AN000;
; ENDP setup_device_name;AN000;
															   ;AN000;
;-------------------------------------------------------------------------------					   ;AN000;
															   ;AN000;
															   ;AN000;
do_IOCTL0C:;AN000;
global DO_IOCTL0C;AN000;
      MOV   AH,open		 ;open device										   ;AN000;
      MOV   AL,dev_open_mode	 ;AL=open mode for devices, see modecpeq.inc						   ;AN000;
      MOV   DX,CON_str	 ;know that CON is being opened, avoid using user input and having to remove colon	   ;AN000;
      INT   21H 													   ;AN000;
															   ;AN000;
      MOV   BX,AX		 ;BX=handle of CON									   ;AN000;
      MOV   AX,440CH													   ;AN000;
      MOV   CH,display_device	 ;type of device									   ;AN000;
      MOV   DX,IOCTL0C_data_block										   ;AN000;
      INT   21H 			  ;the IOCTL data block is filled with the current settings			   ;AN000;
      PUSHF				  ;save result of the IOCTL							   ;AN000;
															   ;AN000;
      MOV   AH,3EH		 ;assume that BX still has the handle							   ;AN000;
      INT   21H 		 ;close CON, open and close each time because if error may not be back to close 	   ;AN000;
															   ;AN000;
      POPF			 ;restore result of the IOCTL								   ;AN000;
															   ;AN000;
      RET														   ;AN000;
															   ;AN000;
; ENDP do_IOCTL0C;AN000;
															   ;AN000;
;-------------------------------------------------------------------------------					   ;AN000;
															   ;AN000;
display_columns_status:;AN000;
															   ;AN000;
MOV   CL,get_current_settings												   ;AN000;
CALL  do_IOCTL0C		    ;get current settings of CON							   ;AN000;
; .IF <IOCTL0C_data_block.mode EQ text> THEN;AN000;
   ; .IF <IOCTL0C_data_block.cols EQ 80> THEN;AN000;
      MOV columns_ptr,eighty_str      ;set up message block with pointer to "80"                                    ;AN000;
   ; .ELSE;AN000;
      MOV columns_ptr,fourty_str 										   ;AN000;
   ; .ENDIF;AN000;
; .ELSE;AN000;
   MOV columns_ptr,NONE_str											   ;AN000;
; .ENDIF;AN000;
display  COLUMNS_equal_msg												   ;AN000;
															   ;AN000;
RET															   ;AN000;
															   ;AN000;
; ENDP display_columns_status;AN000;
															   ;AN000;
;-------------------------------------------------------------------------------					   ;AN000;
															   ;AN000;
display_lines_status:;AN000;
															   ;AN000;
MOV   CL,get_current_settings												   ;AN000;
CALL  do_IOCTL0C		    ;get current settings of CON							   ;AN000;
; .IF <IOCTL0C_data_block.mode EQ text> THEN;AN000;
   MOV	 AX,IOCTL0C_data_block.rows											   ;AN000;
   MOV	 row_value,AL			 ;row_value=binary row value							   ;AN000;
   MOV	 row_type,right_align+unsgn_bin_byte  ;set up sublist so msg ret knows it is a binary byte			   ;AN000;
   MOV	 row_ptr,row_value	 ;set up LINES_equal sublist							   ;AN000;
; .ELSE;AN000;
   MOV	 row_ptr,NONE_str											   ;AN000;
; .ENDIF;AN000;
display  LINES_equal_msg												   ;AN000;
															   ;AN000;
RET															   ;AN000;
															   ;AN000;
; ENDP display_lines_status;AN000;

;-------------------------------------------------------------------------------

old_video_mode_set_IOCTL:;AN004;

MOV   CL,set_display_characteristics									    ;AN000;
CALL do_IOCTL0C 											    ;AN000;
; .IF C THEN;AN000;
   get_extended_error											    ;AN000;
   ; .IF <AX EQ not_supported_on_machine> THEN;AN000;
      DISPLAY Function_not_supported									    ;AN000;
   .ELSEIF <AX EQ font_not_loaded> THEN 								    ;AN000;
      DISPLAY Required_font_not_loaded									    ;AN000;
   ; .ENDIF;AN000;
   MOV	 noerror,false											    ;AN000;
; .ENDIF;AN000;carry 								    ;AN000;

RET
								;AN004;
; ENDP old_video_mode_set_IOCTL;AN004;

															   ;AN000;
;-------------------------------------------------------------------------------					   ;AN000;
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
;³
;³ CHECK_COM_PORTS_ATTACHED
;³ ------------------------
;³
;³  Return the number of com ports in the machine.
;³
;³  INPUT: none
;³
;³
;³  RETURN: com_ports_attached - number of com ports
;³
;³
;³  MESSAGES: none
;³
;³  REGISTER
;³  USAGE:	SI - index of the FOR loop and displacement from serial_base
;³		ES - holds segment of ROM data area
;³
;³
;³  ASSUMPTIONS: The user has initialized com_ports_attached to zero.
;³
;³
;³  SIDE EFFECT: ES is lost
;³		 SI is lost
;³															   ;AN000;
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;

check_com_ports_attached:

MOV   SI,0
MOV   ES,SI	  ;now ES:SERIAL_BASE addresses 40:0=0:400

.FOR SI = 0 TO 6 STEP 2

   ; .IF <<WORD PTR ES:SERIAL_BASE[SI]> NE 0> THEN;SEE IF THE COM PORT EXISTS
      INC   com_ports_attached
   ; .ENDIF

.NEXT SI

RET

; ENDP check_com_ports_attached


;-------------------------------------------------------------------------------					   ;AN000;
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
;³
;³ CHECK_PRN_PORTS_ATTACHED
;³ ------------------------
;³
;³  Return the number of printer ports in the machine. The network will put a 2
;³  in th address word if the printer is redirected, so for the printer to
;³  actually exist the address must be greater than 2 ("redirected").  Since
;³  can't have infinite retry on redirected printers only want to count ports
;³  with >2 for addresses.
;³
;³  INPUT: none
;³
;³
;³  RETURN: prn_ports_attached - number of printer ports
;³
;³
;³  MESSAGES: none
;³
;³  REGISTER
;³  USAGE:	SI - index of the FOR loop and displacement from printr
;³		ES - holds segment of ROM data area (0 in this case)
;³
;³
;³  ASSUMPTIONS: All valid printer port addresses are >2.
;³
;³
;³  SIDE EFFECT: ES is lost
;³		 SI is lost
;³															   ;AN000;
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;

check_prn_ports_attached:


MOV   SI,0
MOV   ES,SI	  ;now ES:printr addresses 40:8=0:408

.FOR SI = 0 TO 4 STEP 2       ;for each of 3 printer port address holder words

   ; .IF <<WORD PTR ES:printr[SI]> GT redirected> THEN;SEE IF THE PORT EXISTS
      INC   prn_ports_attached
   ; .ENDIF

.NEXT SI

RET

; ENDP check_prn_ports_attached


;-------------------------------------------------------------------------------					   ;AN000;
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
;³															   ;AN000;
;³ GET_DEVICE_RETRY_TYPE												   ;AN000;
;³ ---------------------												   ;AN000;
;³															   ;AN000;
;³  Return the type of retry active for comX or lptX.									   ;AN000;
;³															   ;AN000;
;³  INPUT: device_request - scalar indicating what status the user requested.						   ;AN000;
;³		use the following equates:										   ;AN000;
;³															   ;AN000;
;³		    com1_retry_type_status   EQU  0									   ;AN000;
;³		    com2_retry_type_status   EQU  2									   ;AN000;
;³		    com3_retry_type_status   EQU  4									   ;AN000;
;³		    com4_retry_type_status   EQU  6									   ;AN000;
;³		    lpt1_retry_type_status										   ;AN000;
;³		    lpt2_retry_type_status										   ;AN000;
;³		    lpt3_retry_type_status										   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  RETURN: returned_retry_type - scalar indicating type of retry active for						   ;AN000;
;³		 the requested device. compare with the following equates:						   ;AN000;
;³															   ;AN000;
;³		    no_retry_flag											   ;AN000;
;³		    error_status										    ;AN000;
;³		    busy_status 										     ;AN000;
;³		    ready_status										    ;AN000;
;³															   ;AN000;
;³	     retry_type_ptr - set to proper string									   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  MESSAGES: none													   ;AN000;
;³															   ;AN000;
;³  REGISTER														   ;AN000;
;³  USAGE:	CL - For com ports it serves as bit shift count for the retry type byte.
;³															   ;AN000;
;³		AL - On exit holds retry type scalar on exit (returned_retry_type)					  ;AN000;
;³															   ;AN000;
;³		ES - holds segment of resident mode code								   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  CONVENTIONS: The value in device_request is used as an index into the LPTX						   ;AN000;
;³		  array of retry type flags, or as a bit shift count for the						   ;AN000;
;³		  COM retry type byte.											;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  ASSUMPTIONS: The user has initialized device_request on entry with						      ;AN000;
;³		 the equates provided.											   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  SIDE EFFECT: none.													   ;AN000;
;³															   ;AN000;
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
															   ;AN000;
get_device_retry_type:;AN665;

global get_device_retry_type

PUSH BX 								;AN665;
PUSH ES 								;AN665;

XOR  BX,BX								;AN665;
MOV  ES,BX			       ;set segment to zero		;AN665;

; .IF <<ES:WORD PTR resseg> NE 0000H> THEN;IF code resident THEN	;AN665;
   MOV	ES,ES:word resseg[2]	    ;ES=seg of resident code	;AN665;
   ; .IF <device_type EQ COMx> THEN
      MOV   CL,device_request		     ;CL has 0, 2, 4 or 6 for COM 1, 2, 3 or 4 respectively		      ;AC003;
      MOV   returned_retry_type,byte ES:res_com_retry_type		 ;AL=the status byte for all 4 com ports	    ;AN665;
      SHR   returned_retry_type,CL	 ;AL=XXXXXX??, where ?? is the retry bits for port in question		     ;AC003;
      AND   returned_retry_type,00000011B ;AL=000000??, where ?? is the retry bits for port in question 	      ;AC003;
   ; .ELSE;AN665;
      MOV  BL,device_request		       ;BX=index into retry bytes in resident code  ;AN665;
      MOV  returned_retry_type,byte ES:lpt1_retry_type[BX]		;AN665;
   ; .ENDIF;AN665;
; .ELSE;AN665;
   MOV	returned_retry_type,no_retry_flag				;AN665;
; .ENDIF;AN665;

; .IF <returned_retry_type EQ B> OR;COM form of busy flag	;AN665;
; .IF <returned_retry_type EQ busy_status> THEN;AN665;
   MOV	 retry_type_ptr,B_str					;AN665;
.ELSEIF <returned_retry_type EQ E> OR		;COM form of error flag     ;AN665;
; .IF <returned_retry_type EQ error_status> THEN;AN665;
   MOV	 retry_type_ptr,E_str					;AN665;
.ELSEIF <returned_retry_type EQ R> OR		;COM form of ready flag     ;AN665;
; .IF <returned_retry_type EQ ready_status> THEN;AN665;
   MOV	 retry_type_ptr,R_str					;AN665;
; .ELSE;AN665;
   MOV	 retry_type_ptr,NONE_str    ;not E, B or R.		;AN665;
; .ENDIF;AN665;

POP  ES 								;AN665;
POP  BX 								;AN665;
RET									;AN665;

; ENDP get_device_retry_type;AN665;
															   ;AN000;
;ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
;³															   ;AN000;
;³ ANALYZE_AND_INVOKE													   ;AN000;
;³ ------------------													   ;AN000;
;³															   ;AN000;
;³ The command line is boken down into pieces by "parse_parameters".  Each piece                                           ;AN000;
;³ is analyzed here, and the appropriate routine called to setup and/or execute 					   ;AN000;
;³ the requested function.												   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  INPUT: request_type - scalar indicating what operation the user requested.						   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  RETURN: none													   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  MESSAGES: none													   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  REGISTER														   ;AN000;
;³  USAGE:	 DI - index into the list of parsed parms, the array parm_list. 					   ;AN000;
;³															   ;AN000;
;³		 CX - temporary holder for memory to memory MOVs							   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  CONVENTIONS:													   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  ASSUMPTIONS: All the input are valid. The parm_list entry past the last one 					   ;AN000;
;³		 has a parm_type of bogus.										   ;AN000;
;³															   ;AN000;
;³		 The lines and columns values are in binary for request_type=						   ;AN000;
;³		 set_con_features											   ;AN000;
;³															   ;AN000;
;³		 The codepage numbers were put into des_start_packet.							   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;³  SIDE EFFECT:													   ;AN000;
;³															   ;AN000;
;³															   ;AN000;
;ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ					   ;AN000;
															   ;AN000;
analyze_and_invoke:;AX000;										   ;AN000;
															   ;AN000;
															   ;AN000;
;CASE request_type=													   ;AN000;
															   ;AN000;
   MOV	 cp_cb.des_pack_ptr,des_start_packet	;AX000;In case a codepage request				   ;AN000;
															   ;AN000;
   MOV	 DI,0	   ;initialize index into the list of parsed parameters 						   ;AN000;
															   ;AN000;
   ;calculate the displacement for the jump to the jump 								   ;AN000;
   MOV	 parm_list_holder,BX	       ;save parm_list_BX								   ;AN000;
   XOR	 BX,BX			    ;AX000;										   ;AN000;
   MOV	 BL,max_request_type	    ;AX000;										   ;AN000;
   SUB	 BL,request_type	    ;AX000;see the list of equates for request_type					   ;AN000;
   SHL	 BX,1			    ;AX000;BX=word displacement into jump table 					   ;AN000;
   JMP	 jump_table1[BX]	    ;AX000;jump to appropriate jump							   ;AN000;
															   ;AN000;
   jump_table1:;the order of the following entries is critical					   ;AN000;
															   ;AN000;
   DW	all_con_status_case											   ;AN000;
   DW	codepage_prepare_case											   ;AN000;
   DW	codepage_refresh_case											   ;AN000;
   DW	codepage_select_case											   ;AN000;
   DW	codepage_status_case											   ;AN000;
   DW	codepage_prepared_status_case										   ;AN000;
   DW	codepage_selected_status_case										   ;AN000;
   DW	com_status_case												   ;AN000;
   DW	initialize_com_port_case 										   ;AN000;
   DW	initialize_printer_port_case										   ;AN000;
   DW	old_initialize_printer_port_case 									   ;AN000;
   DW	old_video_mode_set_case											   ;AN000;
   DW	printer_reroute_case											   ;AN000;
   DW	printer_status_case											   ;AN000;
   DW	set_con_features_case											   ;AN000;
   DW	status_for_everything_case										   ;AN000;
   DW	turn_off_reroute_case											   ;AN000;
															   ;AN000;
															   ;AN000;
   all_con_status_case: 	       ;know that all con status is requested						   ;AN000;
															   ;AN000;
															   ;AN000;
      MOV      stat_dev_ptr,CON_str	;set up msg ser input							   ;AN000;
      MOV      dev_name_size,len_CON_str	;set up for msg service, see MODEPARS.ASM				   ;AN000;
      display  status_for_device											   ;AN000;
      display  long_underline	       ;Status for device CON:								   ;AN000;
      display  four_char_underline     ;----------------------								   ;AN000;
															   ;AN000;
      CAll  check_ANSI_installed       ;see if ANSI.SYS is installed							   ;AC001;
      ; .IF   <ANSI_installed EQ true> THEN;IF can get info on settings THEN display them ELSE don't display them
	 CALL  display_columns_status										       ;AN000;
	 CALL  display_lines_status										     ;AN000;
      ; .ENDIF;AC001;
      MOV   cp_cb.request_typ,status	     ;set up variables for modecp						   ;AN000;
      MOV   cp_cb.cp_device,CON_str										   ;AN000;
															   ;AN000;
      CALL  modecp			  ;display codepage status							   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
   codepage_prepare_case:												   ;AN000;
															   ;AN000;
      MOV   cp_cb.request_typ,prepare											   ;AN000;
      CALL  setup_device_name	     ;Set the pointer to the device name ASCIIZ in the parameter block for 'modecp'.       ;AN000;
															   ;AN000;
      call  modecp													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
   codepage_refresh_case:												   ;AN000;
															   ;AN000;
      MOV   cp_cb.request_typ,refresh											   ;AN000;
      CALL  setup_device_name	     ;Set the pointer to the device name ASCIIZ in the parameter block for 'modecp'.       ;AN000;
															   ;AN000;
      call  modecp													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
   codepage_select_case:												   ;AN000;
															   ;AN000;
      MOV   cp_cb.request_typ,select											   ;AN000;
      CALL  setup_device_name	     ;Set the pointer to the device name ASCIIZ in the parameter block for 'modecp'.       ;AN000;
      MOV   des_start_packet.des_strt_pknum,1	   ;one cp number							   ;AN000;
      MOV   des_start_packet.des_strt_pklen,4	   ;bytes for count (word) and one number (word)			   ;AN000;
      MOV   BX,parm_list_holder 			;restore parm_list_BX						   ;AN000;
      MOV   DI,codepage_index_holder			;DI=index in parm list of the entry for the codepage to be selected;AN000;
      MOV   AX,parm_list_BX[DI].value1		      ;AX=codepage number in binary form				   ;AN000;
      MOV   des_start_packet.des_strt_pkcp1,AX	   ;setup parm block with the (single) cp number			   ;AN000;
															   ;AN000;
      CALL  modecp													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
   codepage_status_case:												   ;AN000;
   codepage_prepared_status_case:											   ;AN000;
   codepage_selected_status_case:											   ;AN000;
															   ;AN000;
      MOV   cp_cb.request_typ,status											   ;AN000;
      CALL  setup_device_name	     ;Set the pointer to the device name ASCIIZ in the parameter block for 'modecp'.       ;AN000;
															   ;AN000;
      CALL  modecp													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
   com_status_case:													   ;AN000;
															   ;AN000;
	     ; INPUT: device_type = COMx
	     ;	      device	  = ASCII COM number


      CALL  check_com_ports_attached	     ;return number of com ports in com_ports_attached				   ;AN000;
															   ;AN000;
      ; .IF <device_name EQ <OFFSET COM1_str>> AND;AN000;
      ; .IF <com_ports_attached GE 1> THEN;COM1 exists
	 MOV   BL,COM1													   ;AN000;
	 MOV   stat_dev_ptr,COM1_str	 ;set up msg ser input							;AN000;
	 MOV   device_request,com1_retry_type_status									   ;AN000;
      .ELSEIF <device_name EQ <COM2_str>> AND									   ;AN000;
      ; .IF <com_ports_attached GE 2> THEN;COM2 exists
	 MOV   BL,COM2													   ;AN000;
	 MOV   stat_dev_ptr,COM2_str	 ;set up msg ser input							;AN000;
	 MOV   device_request,com2_retry_type_status									   ;AN000;
      .ELSEIF <device_name EQ <COM3_str>> AND									   ;AN000;
      ; .IF <com_ports_attached GE 3> THEN;COM3 exists
	 MOV   BL,COM3													   ;AN000;
	 MOV   stat_dev_ptr,COM3_str	 ;set up msg ser input							;AN000;
	 MOV   device_request,com3_retry_type_status									   ;AN000;
      .ELSEIF <device_name EQ <COM4_str>> AND									   ;AN000;
      ; .IF <com_ports_attached EQ 4> THEN;COM4 exists
	 MOV   BL,COM4													   ;AN000;
	 MOV   stat_dev_ptr,COM4_str	 ;set up msg ser input							;AN000;
	 MOV   device_request,com4_retry_type_status									   ;AN000;
      ; .ELSE;device does not exist						   ;AN000;
	  MOV  CX,device_name								   ;AN000;			  ;AN000;
	  MOV  illegal_device_ptr,CX	  ;put pointer to com port string in message					   ;AN000;
	  DISPLAY err1			 ;AN000;"Illegal device name - COMX"                                               ;AN000;
	  MOV  noerror,false			;set flag for displaying status to be skipped
      ; .ENDIF;AN000;
      ; .IF <noerror EQ true> THEN
	 MOV	  dev_name_size,len_COMX_str	   ;set up for msg service, see MODEPARS.ASM				      ;AN000;
	 display  status_for_device		   ;"Status for device COM?:"                                                 ;AN000;
	 display  long_underline		   ;"------------------"                                                      ;AN000;
	 display  five_char_underline		;has CRLF on it       "-----"                                                 ;AN000;
	 call  get_device_retry_type											      ;AN000;
	 display  retry_equal												      ;AN000;
      ; .ENDIF
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
;  con_status_case:	;don't know which con status is requested                                                          ;AN000;
															   ;AN000;
;     MOV   request_type,all_con_status   ;AC000;DCR76									   ;AN000;
;     CALL  analyze_and_invoke		  ;AC000;DCR76									   ;AN000;
															   ;AN000;
;     MOV      dev_name_size,len_CON_str       ;set up for msg service, see MODEPARS.ASM				   ;AN000;
;     MOV      stat_dev_ptr,OFFSET CON_str	;set up msg ser input							   ;AN000;
;     display  status_for_device											   ;AN000;
;     display  long_underline	       ;Status for device CON:								   ;AN000;
;     display  four_char_underline     ;----------------------								   ;AN000;
;															   ;AN000;
;     MOV   DI,0													   ;AN000;
;															   ;AN000;
;     .WHILE <parm_list_BX[DI].parm_type NE bogus> DO	   ;the entry after the last has parm_type of bogus		   ;AN000;
;															   ;AN000;
;	 ;CASE parm_list_BX[DI].item_tag=										   ;AN000;
;															   ;AN000;
;	    ;CODEPAGE,													   ;AN000;
;	    ;PREPARE,													   ;AN000;
;	    ;SELECT:													   ;AN000;
;															   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ CODEPAGE_item_tag> OR						   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ SELECT_item_tag> OR 						   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ PREPARE_item_tag> THEN						   ;AN000;
;															   ;AN000;
;	       MOV   cp_cb.request_typ,status										   ;AN000;
;	       MOV   cp_cb.cp_device,OFFSET CON_str									   ;AN000;
;	       CALL  modecp			   ;display codepage status						   ;AN000;
;															   ;AN000;
;	       BREAK 2													   ;AN000;
;															   ;AN000;
;		  .ENDIF												   ;AN000;
;															   ;AN000;
;	    ;BLINK:													   ;AN000;
;															   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ BLINK_item_tag> THEN						   ;AN000;
;															   ;AN000;
;	       CALL  display_blink_status										   ;AN000;
;															   ;AN000;
;	       BREAK 2													   ;AN000;
;															   ;AN000;
;		  .ENDIF												   ;AN000;
;															   ;AN000;
;															   ;AN000;
;	    ;COLUMNS:													   ;AN000;
;															   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ COLUMNS_item_tag> THEN						   ;AN000;
;															   ;AN000;
;	       CALL  display_COLUMNS_status										   ;AN000;
;															   ;AN000;
;	       BREAK 2													   ;AN000;
;															   ;AN000;
;		  .ENDIF												   ;AN000;
;															   ;AN000;
;															   ;AN000;
;	    ;LINES:													   ;AN000;
;															   ;AN000;
;		  .IF <parm_list_BX[DI].item_tag EQ LINES_item_tag> THEN						   ;AN000;
;															   ;AN000;
;	       CALL  display_lines_status										   ;AN000;
;															   ;AN000;
;	       BREAK 2													   ;AN000;
;															   ;AN000;
;		  .ENDIF												   ;AN000;
;															   ;AN000;
;	 ENDCASE_2:													   ;AN000;
;															   ;AN000;
;	 ADD   DI,TYPE parm_list_entry											   ;AN000;
;															   ;AN000;
;     .ENDWHILE 													   ;AN000;
															   ;AN000;
;     BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
   initialize_com_port_case:												   ;AN000;
															   ;AN000;

      MOV   BX,parm_list_holder 		;restore parm_list_BX							;AN000;

      ; .IF <parms_form EQ keyword> THEN;IF the parms were input as keywords THEN 				   ;AN000;
															   ;AN000;
	 MOV   DI,TYPE parm_list_entry		;skip COMN parm 							   ;AN000;
															   ;AN000;
	 ; .WHILE <parm_list_BX[DI].parm_type NE bogus> DO NEAR;the entry after the last has parm_type of bogus		   ;AN000;
															   ;AN000;
	    ;CASE parm_list_BX[DI].keyword_switch_ptr=									   ;AN000;
															   ;AN000;
	       ;BAUD_equal:												   ;AN000;
															   ;AN000;
		     ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET BAUD_equal>> THEN;AN000;
															   ;AN000;
		  MOV	AX,parm_list_BX[DI].value1  ;AX= pointer to the baud rate string				   ;AN000;
		  MOV	pbaud_ptr,AX		    ;set pointer to the baud rate string in the messge			   ;AN000;
		  MOV	baud_index,DI			   ;set index into parm list for setcom 			   ;AN000;
		  BREAK 3												   ;AN000;
															   ;AN000;
		     ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	       ;PARITY_equal:												   ;AN000;
															   ;AN000;
		     ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET PARITY_equal>> THEN;AN000;
															   ;AN000;
		  MOV	SI,parm_list_BX[DI].value1    ;AX= pointer to the parity string 				   ;AN000;
		  MOV	pparity_ptr,SI		      ;set pointer to the parity string in the messge			   ;AN000;
		  OR	byte [SI],lowercase 	;convert to lowercase for compatibility with previous versions
		  MOV	parity_index,DI 	      ;set index into parm list for setcom				   ;AN000;
		  BREAK 3												   ;AN000;
															   ;AN000;
		     ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	       ;DATA_equal:												   ;AN000;
															   ;AN000;
		     ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET DATA_equal>> THEN;AN000;
															   ;AN000;
		  MOV	BP,parm_list_BX[DI].value1    ;BP= pointer to the data bits string				   ;AN000;
		  MOV	AL,[BP] 		      ;AL= data bits character						   ;AN000;
		  MOV	pdata,AL		      ;set the data bits string in the messge				   ;AN000;
		  MOV	data_bits_index,DI		 ;set index into parm list for setcom				   ;AN000;
		  BREAK 3												   ;AN000;
															   ;AN000;
		     ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	       ;STOP_equal:												   ;AN000;
															   ;AN000;
		     ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET STOP_equal>> THEN;AN000;
															   ;AN000;
		  MOV	AX,parm_list_BX[DI].value1    ;AX= pointer to the stop bit string				   ;AN000;
		  MOV	pstop_ptr,AX		      ;set pointer to the parity string in the messge			   ;AN000;
		  MOV	stop_bits_index,DI		 ;set index into parm list for setcom				   ;AN000;
		  BREAK 3												   ;AN000;
															   ;AN000;
		     ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	       ;RETRY_equal:												   ;AN000;
															   ;AN000;
		     ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET RETRY_equal_str>> THEN;AN000;
															   ;AN000;
		  MOV	retry_index,DI	     ;indicate to modecom which parm is retry					   ;AN000;
;		  BREAK 3												   ;AN000;
															   ;AN000;
		     ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ENDCASE_3:													   ;AN000;
															   ;AN000;
	    ADD   DI,TYPE parm_list_entry										   ;AN000;
															   ;AN000;
															   ;AN000;
	 .ENDWHILE													   ;AN000;
															   ;AN000;
      ; .ELSE;the parms were entered as positionals (the old form)				   ;AN000;
															   ;AN000;
	 MOV   baud_index,TYPE parm_list_entry										   ;AN000;
	 MOV   DI,2 * (TYPE parm_list_entry)									 ;AN000;
	 ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;IF stopbits requested THEN
	    MOV   parity_index,DI								      ;AN000;
	 ; .ENDIF
	 MOV   DI,3 * (TYPE parm_list_entry)								      ;AN000;
	 ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;IF stopbits requested THEN
	    MOV   data_bits_index,DI											;AN000;
	 ; .ENDIF
	 MOV   DI,4 * (TYPE parm_list_entry)						   ;DI=stopbits index  ;AN000;
	 ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;IF stopbits requested THEN
	    MOV   stop_bits_index,DI								    ;AN000;
	 ; .ENDIF
	 MOV   DI,5 * (TYPE parm_list_entry)		      ;AN000;DI=index of retry parm
	 ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;IF retry requested THEN
	    MOV   retry_index,DI							   ;AN000;set up index for modecom
	 ; .ENDIF;AN000;
															   ;AN000;
      ; .ENDIF;AN000;
															   ;AN000;
      CALL  modecom													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;

															   ;AN000;
															   ;AN000;
   old_initialize_printer_port_case:   ;Assume that parms not specified have an entry in parm_list that is in initial state;AN000;

				       ;printer_no has ASCII form of printer number					   ;AN000;
				       ;need to put binary form of columns in columns_holder (80 or 132)		   ;AN000;
				       ;need to put "6" or "8" in parm2                                                    ;AN000;
				       ;need to set retry_index 							   ;AN000;


global old_initialize_printer_port_case

      MOV   BX,parm_list_holder 	     ;restore parm_list_BX							;AN000;
      MOV   DI,TYPE parm_list_entry	     ;skip LPTN parm, point at chars per line				  ;AN000;

      ; .IF <parm_list_BX[DI].item_tag EQ onethirtytwo_item_tag> THEN;AN000;
	 MOV   columns_holder,132										  ;AN000;
      .ELSEIF <parm_list_BX[DI].item_tag EQ eighty_item_tag> THEN						;AN000;
	 MOV   columns_holder,80										  ;AN000;
      ; .ENDIF;if not 80 or 132 modeprin assumes not specified, and makes no change;AN000;
      ADD   DI,TYPE parm_list_entry	     ;look at lines per inch							   ;AN000;

      ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;IF chars per line specified THEN	      ;AN000;
	 MOV   SI,parm_list_BX[DI].value1	  ;SI=>"6" or "8"                                         ;AN000;
	 MOV   AL,byte [DS:SI]										     ;AN000;
	 MOV   parm2,AL 		      ;parm2="6" or "8"                                                 ;AN000;
      ; .ENDIF;otherwise leave parm2=0FFH (unspecified)  ;AN000;

      ADD   DI,TYPE parm_list_entry	     ;look at retry request							  ;AN000;
      ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;
	 MOV   retry_index,DI		     ;AN000;let modeprin know retry was requested and the index of it.
      ; .ENDIF;AN000;

      CALL  modeecno													   ;AN000;
      CALL  modeprin													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;



   initialize_printer_port_case:    ;printer_no has ASCII form of printer number					   ;AN000;
				    ;need to put binary form of columns in columns_holder (80 or 132)			   ;AN000;
				    ;need to put "6" or "8" in parm2                                                       ;AN000;
				    ;need to set retry_index								   ;AN000;
															   ;AN000;
      MOV   BX,parm_list_holder 		;restore parm_list_BX							   ;AN000;
      MOV   DI,TYPE parm_list_entry	     ;skip LPTN parm								   ;AN000;

      ; .WHILE <parm_list_BX[DI].parm_type NE bogus> DO;the entry after the last has parm_type of bogus		   ;AN000;
															   ;AN000;
	 ;CASE parm_list_BX[DI].keyword_switch_ptr=									   ;AN000;
															   ;AN000;
															   ;AN000;
	    ;LINES_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET LINES_equal>> THEN;AN000;
															   ;AN000;
	       MOV   SI,parm_list_BX[DI].value1 	;SI=>"6" or "8"                                                    ;AN000;
	       MOV   AL,byte [DS:SI]										   ;AN000;
	       MOV   parm2,AL				;parm2="6" or "8"                                                  ;AN000;
	       BREAK 4													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ;COLUMNS_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET COLUMNS_equal>> OR;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET COLS_equal>> THEN;AN000;
															   ;AN000;
	       ; .IF <parm_list_BX[DI].item_tag EQ onethirtytwo_item_tag> THEN;AN000;
		  MOV	columns_holder,132										   ;AN000;
	       ; .ELSE;AN000;
		  MOV	columns_holder,80										   ;AN000;
	       ; .ENDIF;AN000;
	       BREAK 4													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ;RETRY_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET RETRY_equal_str>> THEN;AN000;

	       MOV   retry_index,DI											   ;AN664;
	       BREAK 4													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	 ENDCASE_4:													   ;AN000;
															   ;AN000;
	 ADD   DI,TYPE parm_list_entry											   ;AN000;
															   ;AN000;
															   ;AN000;
      .ENDWHILE 													   ;AN000;

      CALL  modeecno	   ;turn of rerouting										   ;AN000;
      CALL  modeprin													   ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
   old_video_mode_set_case:												   ;AN000;
															   ;AN000;
   global old_video_mode_set_case;AN000;
															   ;AN000;
															   ;AN000;
      ;first see if ANSI.SYS is loaded										     ;AN000;
      CALL  check_ANSI_installed										     ;AC001;
      ; .IF <ANSI_installed EQ true> THEN;AC001;
	 MOV   CL,get_current_settings										     ;AN000;
	 PUSH  BX			  ;save parm_list							     ;AN000;
	 CALL  do_IOCTL0C		     ;get current settings of CON					     ;AN000;
	 POP   BX				  ;restore parm_list						     ;AN000;
	 MOV   IOCTL0C_data_block.mode,text									     ;AN000;
      ; .ENDIF;AN000;ANSI installed							     ;AN000;
      MOV   BX,parm_list_holder 		;restore parm_list_BX							   ;AN000;
      PUSH  DI					;save parm list index							   ;AN000;
      ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN
	 ; .IF <parm_list_BX[DI].item_tag EQ BW40_item_tag> THEN;IF BW40 REQUESTED					      ;AN000;
	    CALL BW40													      ;AN000;
	 .ELSEIF <parm_list_BX[DI].item_tag EQ BW80_item_tag> THEN ;IF BW80 REQUESTED					      ;AN000;
	    CALL  BW80													      ;AN000;
	 .ELSEIF <parm_list_BX[DI].item_tag EQ CO40_item_tag> THEN ;IF CO40 REQUESTED					      ;AN000;
	    CALL  CO40													      ;AN000;
	 .ELSEIF <parm_list_BX[DI].item_tag EQ CO80_item_tag> THEN ;IF CO80 REQUESTED					      ;AN000;
	    CALL  CO80													      ;AN000;
	 .ELSEIF <parm_list_BX[DI].item_tag EQ MONO_item_tag> THEN ;IF MONO REQUESTED					      ;AN000;
	    CALL  MONO													      ;AN000;
	 ; .ELSE;AN000;
	    ; .IF <ANSI_installed EQ true> THEN;AN000;
;AC004;        MOV   need_IOCTL0C,true			     ;use IOCTL if possible to retain lines setting  ;AN000;
	       ; .IF <parm_list_BX[DI].value1 EQ <OFFSET fourty_str>> THEN;AN000;
		  MOV	IOCTL0C_data_block.cols,40	;setup IOCTL input block with the columns requested	   ;AN000;
	       ; .ELSE
		  MOV	IOCTL0C_data_block.cols,80	;setup IOCTL input block with the columns requested	      ;AN000;
	       ; .ENDIF;AN000;
	       CALL  old_video_mode_set_IOCTL			;AN004;use IOCTL if possible to retain lines setting  ;AN000;
	    ; .ELSE
	       ; .IF <parm_list_BX[DI].item_tag EQ fourty_item_tag> THEN;IF 40 REQUESTED 				   ;AN000;
		   MOV	BL,40					    ;set up for handle_40_or_80 			   ;AN000;
	       ; .ELSE;AN000;
		   MOV	BL,80					    ;set up for handle_40_or_80 			   ;AN000;
	       ; .ENDIF;AN000;
	       CALL HANDLE_40_OR_80											;AN000;
	    ; .ENDIF
	 ; .ENDIF;AN000;
      ; .ENDIF

dummy9:
global dummy9
															   ;AN000;
      POP   DI					;restore parm list index						   ;AN000;

      ; .IF <NOERROR EQ TRUE> AND;process ,r ³ l,[T]							 ;AN000;
      MOV   BX,parm_list_holder 		;restore parm_list_BX							   ;AN000;
      ADD   DI,TYPE parm_list_entry	  ;process second parm, shift direction 					   ;AN000;
      ; .IF <parm_list_BX[DI].item_tag NE unspecified> THEN;AN000;
	 ; .IF <parm_list_BX[DI].item_tag EQ R_item_tag> OR;AN000;
	 ; .IF <parm_list_BX[DI].item_tag EQ L_item_tag> THEN;AN000;
	    MOV   CL,parm_list_BX[DI].item_tag										   ;AN000;
	    MOV   PARM2,CL	    ;set up for SHIFT_SCREEN								   ;AN000;
	    ADD   DI,TYPE parm_list_entry	;look at third parm							   ;AN000;
	    MOV   CL,parm_list_BX[DI].item_tag	;CL=T_item_tag or bogus 						;AN000;
	    MOV   PARM3,CL	    ;may be bogus, but shift_screen will handle it correctly				   ;AN000;
	    CALL  SHIFT_SCREEN												   ;AN000;
	 ; .ELSE;AN000;must be a rows value
	    ; .IF <ANSI_installed EQ true> THEN;AN000;
;AC004;        MOV   need_IOCTL0C,true			     ;use IOCTL if possible to retain lines setting  ;AN000;
	       MOV   DX,parm_list_BX[DI].value1 									   ;AN000;
	       MOV   IOCTL0C_data_block.rows,DX 	;the IOCTL input block has the columns requested		   ;AN000;
	       CALL  old_video_mode_set_IOCTL		     ;AN004;use IOCTL if possible to retain lines setting  ;AN000;
	    ; .ELSE;AN000;ANSI not installed							   ;AN000;
	       DISPLAY ANSI_not_loaded											   ;AN000;
	       MOV   noerror,false											   ;AN000;
	    ; .ENDIF;AN000;ANSI installed 							   ;AN000;
	 ; .ENDIF;AN000;
      ; .ENDIF;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;


															   ;AN000;
global printer_reroute_case
															   ;AN000;
   printer_reroute_case:
			;INPUT:lptno=zero based printer number OUTPUT:;AH=printer number mask: lpt1=1, lpt2=2, lpt3=4	   ;AN000;
			      ;device=COM number in ASCII form	      ;SI=printer number value (one based)		  ;AN000;
								      ;AL=com number character				   ;AN000;
      XOR   CX,CX
      MOV   CL,lptno	      ;lptno always <= 255
      MOV   SI,CX	      ;SI=zero based printer number (0, 1, or 2)						 ;AN000;
      INC   SI		      ;SI=one based printer number (1, 2, or 3) 						;AN000;
      MOV   AH,1													   ;AN000;
      SAL   AH,CL	      ;AH=2**SI,AH=printer number mask for MODEECHO						   ;AN000;
      MOV   DH,CL
      ADD   DH,ASCII_1	      ;DH=ASCII printer number									   ;AN000;
      MOV   AL,device	      ;AL=ASCII form of com device number	;AN000;
      MOV   REDPT,DH	      ;PUT n OF LPTn IN REDIRECT MESSAGE
      MOV   NOTREDPT,DH       ;AND INTO NOT REDIRECTED MSG
      CALL  modeecho											 ;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
															   ;AN000;
   printer_status_case: 												   ;AN000;

global printer_status_case

	     ; INPUT: device_type = LPTx
	     ;	      device	  = ASCII printer number
	     ;	      lptno	  = ASCII printer number
	     ;	      device_name = offset of printer string
															   ;AN000;

      MOV   cp_cb.request_typ,status											   ;AN000;
      MOV   AX,device_name												   ;AN000;
      MOV   stat_dev_ptr,AX		;AC665;set up msg ser input							   ;AN000;
      MOV   dev_name_size,len_LPTX_str	;AN000;set up for msg service, see MODEPARS.ASM 				   ;AN000;
      MOV   cp_cb.cp_device,AX	       ;AN665;set up for call to modecp 						   ;AN000;
															   ;AN000;
      ; .IF <device_name EQ <OFFSET LPT1_str>> THEN;AN000;
	 MOV   device_request,lpt1_retry_type_status									   ;AN000;
	 MOV   rerouted_printer_mask,LPT1
	 MOV   redpt,"1"                                ;set up for reroute message
	 MOV   notredpt,"1"                             ;set up for not rerouted message
      .ELSEIF <device_name EQ <LPT2_str>> THEN									   ;AN000;
	 MOV   device_request,lpt2_retry_type_status									   ;AN000;
	 MOV   rerouted_printer_mask,LPT2
	 MOV   redpt,"2"                                ;set up for reroute message
	 MOV   notredpt,"2"                             ;set up for not rerouted message
      .ELSEIF <device_name EQ <LPT3_str>> THEN									   ;AN000;
	 MOV   device_request,lpt3_retry_type_status									   ;AN000;
	 MOV   rerouted_printer_mask,LPT3
	 MOV   redpt,"3"                                ;set up for reroute message
	 MOV   notredpt,"3"                             ;set up for not rerouted message
      ; .ENDIF;AN000;
															   ;AN000;
      PUSH  ES				     ;save ES, used in MODECP							   ;AC002;
;AC002;PUSH  AX 	 ;AN000;save
															   ;AN000;
      display  status_for_device											   ;AN000;
      display  long_underline				      "Status for device LPTX?"                                    ;AN000;
      display  five_char_underline	     ;has CRLF on it   -----------------------					   ;AN000;
      call  display_printer_reroute_status		 ;see modeecho.asm					       ;AN000;
;AC002;POP   AX 					 ;restore "device_request"                                          ;AN000;
      XOR   CX,CX	      ;initialize prn_ports_attached								   ;AN000;
      CALL  check_prn_ports_attached   ;return number of printer cards in prn_ports_attached				   ;AN000;
      POP   ES				     ;restore ES								   ;AC002;
      ADD   prn_ports_attached,ASCII_0	      ;CX=ASCII form of last printer number					   ;AN000;
      ; .IF <prn_ports_attached GE redpt> THEN;IF the printer exists THEN						   ;AN000;
	 call  get_device_retry_type											   ;AN000;
	 display  retry_equal												   ;AN000;
	 CALL  modecp			     ;display codepage status							   ;AN000;
      ; .ENDIF;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
;m															   ;AN000;
   set_con_features_case:	 ;the command line was nothing but con keywords 					   ;AN000;
															   ;AN000;
      ;first see if ANSI.SYS is loaded											   ;AN000;
      CALL  check_ANSI_installed											   ;AC001;
      ; .IF <ANSI_installed EQ true> THEN;AC001;
	 MOV   CL,get_current_settings											   ;AN000;
	 CALL  do_IOCTL0C		     ;get current settings of CON						   ;AN000;
	 ;MOV	SI,OFFSET IOCTL0C_data_block  ;set up IOCTL0C, addressablitiy to the IOCTL data block			   ;AN000;
															   ;AN000;
	 MOV   IOCTL0C_data_block.mode,text										   ;AN000;
															   ;AN000;
      ; .ENDIF;ANSI.SYS installed											   ;AN000;
															   ;AN000;
      MOV   BX,parm_list_holder 		;restore parm_list_BX							   ;AN000;
      ADD   DI,TYPE parm_list_entry		;skip CON parm								   ;AN000;
      ; .WHILE <parm_list_BX[DI].parm_type NE bogus> DO NEAR;the entry after the last has parm_type of bogus		   ;AN000;
															   ;AN000;
	 ;CASE parm_list_BX[DI].keyword_switch_ptr=									   ;AN000;
															   ;AN000;
															   ;AN000;
	    ;LINES_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET LINES_equal>> THEN;AN000;
															   ;AN000;
	       MOV   DX,parm_list_BX[DI].value1 									   ;AN000;
	       MOV   IOCTL0C_data_block.rows,DX 	;the IOCTL input block has the columns requested		   ;AN000;
	       MOV   need_IOCTL0C,true											   ;AN000;
	       BREAK 1													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ;COLUMNS_equal:	  ;the value is binary									   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET COLUMNS_equal>> OR;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET COLS_equal>> THEN;AN000;
															   ;AN000;
	       ; .IF <ANSI_installed EQ true> THEN;AN000;
		  MOV	need_IOCTL0C,true			;use IOCTL if possible to retain lines setting	;AN000;
		  MOV	DX,parm_list_BX[DI].value1									      ;AN000;
		  MOV	IOCTL0C_data_block.cols,DX	   ;the IOCTL input block has the columns requested		      ;AN000;
	       ; .ELSE
		  ; .IF <parm_list_BX[DI].item_tag EQ fourty_item_tag> THEN;IF 40 REQUESTED				      ;AN000;
		      MOV  columns_specified,40 				      ;set up for handle_40_or_80	      ;AN000;
		  ; .ELSE;AN000;
		      MOV  columns_specified,80 				      ;set up for handle_40_or_80   ;AN000;
		  ; .ENDIF;AN000;
	       ; .ENDIF
	       BREAK 1												;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ;RATE_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET RATE_equal>> THEN;AN000;
															   ;AN000;
	       MOV   AL,byte parm_list_BX[DI].value1       ;save the rate requested in binary form, always <255	   ;AN000;
	       MOV   rate_holder,AL											   ;AN000;
	       MOV   need_typamat_call,true										   ;AN000;
	       BREAK 1													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
															   ;AN000;
	    ;DELAY_equal:												   ;AN000;
															   ;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET DELAY_equal>> OR;AN000;
		  ; .IF <parm_list_BX[DI].keyword_switch_ptr EQ <OFFSET DEL_equal>> THEN;AN000;
															   ;AN000;
	       MOV   AL,byte parm_list_BX[DI].value1      ;save delay requested (binary), always <255		   ;AN000;
	       MOV   delay_holder,AL											   ;AN000;
	       MOV   need_typamat_call,true										   ;AN000;
	       BREAK 1													   ;AN000;
															   ;AN000;
		  ; .ENDIF;AN000;
															   ;AN000;
	 ENDCASE_1:													   ;AN000;
															   ;AN000;
	 ADD   DI,TYPE parm_list_entry	     ;address next parm 							   ;AN000;
															   ;AN000;
      .ENDWHILE 													   ;AN000;
															   ;AN000;
DUMMY3: 														   ;AN000;
global DUMMY3;AN000;
															   ;AN000;
      ; .IF <need_IOCTL0C EQ true> THEN;AN000;
	 ; .IF <ANSI_installed EQ true> THEN;AN000;
	    MOV   CL,set_display_characteristics									   ;AN000;
	    CALL do_IOCTL0C												   ;AN000;
	    ; .IF C THEN;AN000;
	       get_extended_error											   ;AN000;
	       ; .IF <AX EQ not_supported_on_machine> THEN;AN000;
		  DISPLAY Function_not_supported									   ;AN000;
	       .ELSEIF <AX EQ font_not_loaded> THEN									   ;AN000;
		  DISPLAY Required_font_not_loaded									   ;AN000;
	       ; .ENDIF;AN000;
	       MOV   noerror,false											   ;AN000;
	    ; .ENDIF;AN000;
	 ; .ELSE;AN000;
	    DISPLAY ANSI_not_loaded											   ;AN000;
	    MOV   noerror,false 											   ;AN000;
	 ; .ENDIF;AN000;
      .ELSEIF <columns_specified NE false> THEN 									   ;AN000;
	 MOV   BL,columns_specified			;set up for call to handle_40_or_80				   ;AN000;
	 CALL  HANDLE_40_OR_80												   ;AN000;
      ; .ENDIF;AN000;

      ; .IF <need_typamat_call EQ true> THEN;AN000;
	 MOV   BL,rate_holder												   ;AN000;
	 MOV   BH,delay_holder												   ;AN000;
	 CALL  typamat													   ;AN000;
      ; .ENDIF;AN000;
															   ;AN000;
      BREAK 0														   ;AN000;
															   ;AN000;
															   ;AN000;
   status_for_everything_case:												   ;AN000;
															   ;AN000;
      MOV   request_type,printer_status 	;status routine for printers						   ;AN000;
      MOV   device_name,LPT1_str 	;will display the reroute						   ;AN000;
      CALL  analyze_and_invoke			;status for the printer whether 					   ;AN000;
      MOV   device_name,LPT2_str 	;it exists or not, so call for						   ;AN000;
      CALL  analyze_and_invoke			;all of them								   ;AN000;
      MOV   device_name,LPT3_str 										   ;AN000;
      CALL  analyze_and_invoke												   ;AN000;
															   ;AN000;
      MOV   request_type,all_con_status 										   ;AN000;
      CALL  analyze_and_invoke												   ;AN000;

      CALL  check_com_ports_attached	     ;return number of com ports in com_ports_attached				   ;AN000;

      MOV   request_type,com_status											   ;AN000;
      MOV   CL,com_ports_attached											   ;AN000;
      .FOR  i = 1 TO CL 												   ;AN000;

	 .SELECT													   ;AN000;

	    .WHEN <i EQ 1>												   ;AN000;
	       MOV   device_name,COM1_str							      ;AN000;	   ;AN000;

	    .WHEN <i EQ 2>												   ;AN000;
	       MOV   device_name,COM2_str									   ;AN000;

	    .WHEN <i EQ 3>												   ;AN000;
	       MOV   device_name,COM3_str									   ;AN000;

	    .WHEN <i EQ 4>												   ;AN000;
	       MOV   device_name,COM4_str								       ;AN0;AN000;

	 .ENDSELECT													   ;AN000;

	 CALL  analyze_and_invoke										 ;AN000;   ;AN000;
      .NEXT i														   ;AN000;

      BREAK 0												      ;AN000;



   turn_off_reroute_case:		;user specified only LPTx[:]					    ;AN000;
			;INPUT:lptno=ASCII printer number



      CALL  modeecno	;turn off rerouting										   ;AN000;
      XOR   CX,CX	      ;initialize prn_ports_attached
      CALL  check_prn_ports_attached   ;return number of printer cards in prn_ports_attached
      ADD   prn_ports_attached,ASCII_0	      ;CX=ASCII form of last printer number
      ; .IF <prn_ports_attached GE LPTNO> THEN;IF the printer exists THEN
	 CALL  set_retry_type			;turn off infinit retry 						   ;AN000;
	 CALL  modify_resident_code		;modify resident code to reflect retry turned off			   ;AN000;
      ; .ENDIF

      BREAK 0														   ;AN000;

															   ;AN000;
ENDCASE_0:														   ;AN000;
															   ;AN000;
RET															   ;AN000;
															   ;AN000;
; ENDP analyze_and_invoke;AN000;
															   ;AN000;
															   ;AN000;
; END SECTION .PRINTF_CODE;AN000;
	; END;AN000;
