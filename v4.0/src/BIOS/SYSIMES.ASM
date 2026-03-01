	;SCCSID = @(#)sysimes.asm	 1.2 85/07/25
%warning ...SYSIMES

;==============================================================================
;REVISION HISTORY:
;AN000 - New for DOS Version 4.00 - J.K.
;AC000 - Changed for DOS Version 4.00 - J.K.
;AN00x - PTM number for DOS Version 4.00 - J.K.
;==============================================================================
;AN001 D246, P976 Show "Bad command or parameters - ..." msg        9/22/87 J.K.
;AN002 P1820 New Message SKL file				   10/20/87 J.K.
;AN003 D486 Share installation for large media			   02/24/88 J.K.
;==============================================================================

iTEST equ 0
%include "MSequ.INC"
%include "MSmacro.INC"

SECTION .SYSINITSEG

	global BADOPM,CRLFM,BADSIZ_PRE,BADLD_PRE,BADCOM,SYSSIZE,BADCOUNTRY
;	 PUBLIC  BADLD_POST,BADSIZ_POST,BADMEM,BADBLOCK,BADSTACK
	global BADMEM,BADBLOCK,BADSTACK
	global INSUFMEMORY,BADCOUNTRYCOM
	global BadOrder,Errorcmd;AN000;
	global BadParm;AN001;
	global SHAREWARNMSG;AN003;


;include sysimes.inc
%include "MSbio.cl3";AN002;

SYSSIZE:

PATHEND 	001,SYSMES

; END SECTION .SYSINITSEG
	; END
