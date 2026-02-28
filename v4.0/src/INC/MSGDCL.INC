; This Macro was removed from sysmsg.inc. We had to remove this
; macro and put it into it's own include file in order to clear up
; some assembly errors. MS MASM will not allow a public declaration
; during the second pass of the assembler. IBM MASM will allow this.
;
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;	$M_DECLARE	     Macro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;
%macro $M_DECLARE 1;
   $M_DCOUNT = 0		       ;
   %rep numcls;
     $M_DCOUNT =  $M_DCOUNT + 1        ;
     $M_DECLARE2  %$M_DCOUNT	       ;
   %endmacro;

  %if COMR
    IFNDEF $M_RT2			;  If Resident table is not in this assembly,
	extern $M_RT2;     Must be external
    %else
	global $M_RT2
    %endif;
  %else
    IFNDEF $M_RT			;  If Resident table is not in this assembly,
	extern $M_RT;     Must be external
    %else
	global $M_RT
    %endif;
  %endif

  $M_CHECK $M_GET_MSG_ADDRESS	      ;  If this subroutine is not in this assembly,
  $M_CHECK $M_MSGSERV_1 	      ;  If this subroutine is not in this assembly,
  $M_CHECK $M_MSGSERV_2 	      ;  If this subroutine is not in this assembly,

%endmacro;
				       ;
%macro $M_DECLARE2 1;
  %if NOT COMR; IF Not resident COMMAND.COM
    %if NOT COMT; IF Not transient COMMAND.COM
      IFNDEF  $M_CLS_&innum		 ; IF class is not in this assembly,
	%if FARmsg;
	  extern $M_CLS_&innum;    Must be external
	%else;
	  extern $M_CLS_&innum;    Must be external
	%endif;
      %else; ELSE
	global $M_CLS_&innum;    Label PUBLIC
      %endif;
    %else; ELSE
      %ifnidn <$M_CLS_&innum>,<$M_CLS_1>; IF NOT $M_CLS_1 or
	%ifnidn <$M_CLS_&innum>,<$M_CLS_2>;   IF NOT $M_CLS_2 then
	  IFNDEF  $M_CLS_&innum 	 ;     IF class is not in this assembly,
	    %if FARmsg;
	      extern $M_CLS_&innum;	 Must be external
	    %else;
	      extern $M_CLS_&innum;	 Must be external
	    %endif;
	  %else;     ELSE
	    global $M_CLS_&innum;	 Label PUBLIC
	  %endif;
	%endif;
      %endif;
    %endif;
  %else; ELSE
    %ifnidn <$M_CLS_&innum>,<$M_CLS_1>; IF NOT $M_CLS_1 or
      %ifnidn <$M_CLS_&innum>,<$M_CLS_2>;   IF NOT $M_CLS_2 then
	IFNDEF	$M_CLS_&innum		 ;     IF class is not in this assembly,
	  %if FARmsg;
	    extern $M_CLS_&innum;	 Must be external
	  %else;
	    extern $M_CLS_&innum;	 Must be external
	  %endif;
	%else;     ELSE
	  global $M_CLS_&innum;	 Label PUBLIC
	%endif;
      %endif;
    %endif;
  %endif;
%endmacro;
				       ;
%macro $M_CHECK 1;
  %ifndef parm; IF class is not in this assembly,
    %if FARmsg;
      extern parm;    Must be external
    %else;
      extern parm;    Must be external
    %endif;
  %else
    %if COMR
    %else
      global parm
    %endif
  %endif;
%endmacro;
				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				       ;
%if 1  ; IF1 - pass-specific;
  $M_DECLARE %$M_NUM_CLS	       ;  Declare any class not in this assembly
%endif;
				       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

