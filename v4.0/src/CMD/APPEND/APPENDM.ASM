; page	60,120
;      @@04 07/30/86 Fix second APPEND hang		 PTM P0000053
;      @@05 08/13/86 Fix bad parm message		PTM P0000125
;      @@10 08/28/86 Change message for @@05		PTM P0000291
;      @@11 09/10/86 Support message profile and make
;		     msg length variable.	R.G. PTM P0000479
SECTION .cseg
	; assume	cs:cseg

	global bad_append_msg;@@11
	global path_error_msg;@@11
	global parm_error_msg;@@11
	global path_parm_error_msg;@@11
	global no_append_msg;@@11
	global append_assign_msg;@@11
	global append_tv_msg;@@11
	global bad_DOS_msg;@@11
	global second_append_msg;@@11

	global len_bad_append_msg;@@11
	global len_path_error_msg;@@11
	global len_parm_error_msg;@@11
	global len_path_parm_error_msg;@@11
	global len_no_append_msg;@@11
	global len_append_assign_msg;@@11
	global len_append_tv_msg;@@11
	global len_bad_DOS_msg;@@11
	global len_second_append_msg;@@11

cr	equ	13
lf	equ	10

%include "appendm.inc"

; END SECTION .cseg
		; end
