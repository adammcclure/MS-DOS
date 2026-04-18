	  ; PAGE	,132;
	  ; TITLE MODEMES - MESSAGES DISPLAYED ON CONSOLE BY MODE

;ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
;º											  º

;  AC001 - P3976: Need to have all pieces of messages in MODE.SKL so have to
;		  implement the SYSGETMSG method of getting addressability to
;		  the pieces.  This means that the code does a SYSGETMSG call
;		  which returns a pointer (DS:SI) to the message piece.  The
;		  address is then put in the sublist block for the message
;		  being issued.

;º											  º
;ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ  P R O L O G  ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼

SECTION .PRINTF_CODE
	  ; ASSUME CS:PRINTF_CODE,DS:PRINTF_CODE
;
CR	  EQU	13	;CARRIAGE RETURN
LF	  EQU	10	;LINE FEED
BEEP	  EQU	7	;AUDIBLE TONE
EOM	  EQU	0	;NULL TERMINATOR, REQUIRED BY PRINTF

%if 1  ; IF1 - pass-specific
   %warning including  MODESUBS.INC
   %warning including  MODEDEFS.INC
%endif
%include "MODESUBS.INC"
%include "MODEDEFS.INC"

;
global first_sublist
global number_of_sublists

 global MOVED_MSG, ERR1, ERR2, PT80, PT80N, PT132, PT132N
 global PTLINES, RATEMSG, INITMSG, REDIRMSG, SHIFT_MSG, sublist_shift_msg
 global NOTREMSG, RETPARTO, sublist_retparto, CANT_SHIFT, sublist_cant_shift
 global NUMBERS,;AC001;INF_OR_NO_ptr
 global Invalid_number_of_parameters, COM1_or_COM2, net_error
 global Invalid_parameter, not_supported, offending_parameter
 global offending_parameter_ptr
 global INITMSG, device,pbaud,pparity,pdata,pstop,pparm,pbaud,baud_19200
 global pstop_ptr
 global pparity_ptr
	       global CPMSG1
		global CPMSG2,CPMSGLST2DEV
		global CPMSG3
		global CPMSG4
		global CPMSG5
		global CPMSG6,CPMSGLST6CP,CPMSGLST6DEV
		global CPMSG7,CPMSGLST7DEV
;AC001; 	PUBLIC CPMSGLST8HD
		global sublist_cpmsg8
		global CPMSG8
		global CPMSG8_HW
;AC001; 	PUBLIC CPMSG8_PR
		global CPMSG9,CPMSGLST9CP
		global CPMSG10
		global sublist_cpmsg10
;AC001; 	PUBLIC CPMSGLST10FUN
;AC001; 	PUBLIC CPMSG10_QUERY
;AC001; 	PUBLIC CPMSG10_DES
;AC001; 	PUBLIC CPMSG10_REFRESH
;AC001; 	PUBLIC CPMSG10_SELECT
;AC001; 	PUBLIC CPMSG10_GLOBAL
		global CPMSG12
		global CPMSG13
		global CPMSGLST13CP
		global CPMSGLST13TYP
;AC001; 	PUBLIC CPMSG13_ACT
;AC001; 	PUBLIC CPMSG13_SYS
		global CPMSG14
		global CPMSG15
		global CPMSG16
		global CPMSG17
		global sublist_CPMSG17
;AC001; 	PUBLIC CPMSGLST17FUN
;AC001; 	PUBLIC CPMSG17_QUERY
;AC001; 	PUBLIC CPMSG17_PREP
;AC001; 	PUBLIC CPMSG17_REFRESH
;AC001; 	PUBLIC CPMSG17_ACT
;AC001; 	PUBLIC CPMSG17_WRIT
		global CPMSG18
		global CPMSG19
		global CPMSG20
		global CPMSG21
		global dev_name_size;used by invoke for msg srv
		global stat_dev_ptr;used by invoke for msg srv
		global long_underline;used by invoke for msg srv
		global five_char_underline;used by invoke for msg srv
		global four_char_underline;used by invoke for msg srv
		global row_ptr
		global status_for_device
		global notredpt
;AC001; 	PUBLIC noretry
;AC001; 	PUBLIC LEFT
;AC001; 	PUBLIC RIGHT
		global row_type
		global lines_equal_msg;used by analyze_and_invoke, "LINES=%1" definition
		global redcom
;AC001; 	PUBLIC	rightmost
;AC001; 	PUBLIC	leftmost
;AC001; 	PUBLIC	infinite
		global REDPT
		global PBAUD_PTR
;		PUBLIC BLINK_type
		global COLUMNS_ptr
		global COLUMNS_equal_msg
		global columns_type
		global delay_type
		global delay_ptr
		global rate_ptr
		global rate_type
		global function_not_supported
		global Required_font_not_loaded
		global ANSI_not_loaded
		global Baud_rate_required
		global RETRY_type_ptr
		global RETRY_equal
		global Baud_rate_required
		global not_supported_ptr
		global Illegal_device_ptr
		global syntax_error
		global syntax_error_ptr
		global rate_and_delay_together
		global CRLF
		global Invalid_switch
		global rightmost
		global leftmost
		global noretry
		global infinite
		global left
		global right
		global cpmsg8_pr
		global cpmsgxx_query
		global cpmsgxx_prep
		global cpmsgxx_select
		global cpmsgxx_refresh
		global cpmsg17_writ
		global cpmsg13_act
		global cpmsg13_sys

; END SECTION .PRINTF_CODE
		; END
