; Some modules really want TRUE to be 0FFH.  Best to let them have their way.
%ifndef TRUE
	TRUE	   EQU	   0FFFFh
%endif
%ifndef TRUEBYTE
	TRUEBYTE   EQU     0FFh
%endif
%ifndef FALSE
	FALSE	   EQU	   0
%endif

;
; Use the following switches to control cmacros.inc
;
?PLM equ 0
?WIN equ 0

memS       EQU     1			; Small model
;
; Use the switches below to produce the standard Microsoft version or the IBM
; version of the operating system
;
; The below chart will indicate how to set the switches to build the various
; versions
;
;                     IBMVER          IBMCOPYRIGHT
; --------------------------------------------------------
;  IBM Version   |     TRUE              TRUE
; --------------------------------------------------------
;  MS Version    |     FALSE             FALSE
; --------------------------------------------------------
;  Clone Version |     TRUE              FALSE
;
IBMVER     EQU     TRUE
IBMCOPYRIGHT EQU   FALSE

BUFFERFLAG	EQU	~IBMCOPYRIGHT

%ifndef MSVER
MSVER      EQU     ~IBMVER
%endif
IBM	   EQU	   IBMVER
;
;
  %if 1  ; IF1 - pass-specific
	%if IBMVER
	    %if IBMCOPYRIGHT
              %warning ... IBM version build switch on ...
	    %else
	      %warning ... CLONE version build switch on ...
	    %endif
	%else
	    %if ~IBMCOPYRIGHT
	      %warning ... MS version build switch on ...
	    %else
	      %warning !!!!!!!!!  VERSION SWITCHES SET INCORECTLY  !!!!!!!!!
	      %warning !!!!!!!!! CHECK SETTINGS IN INC\VERSION.INC !!!!!!!!!
	    %endif
	%endif
  %endif
;
;
;***************************************************************************
;*          The following switches are for DBCS or SBCS support            *
;*                                                                         *
;*                     Set INTERNAT EQU TRUE FOR DBCS                      *
;*                     Set INTERNAT EQU FALSE FOR SBCS                     *
;*                                                                         *
;***************************************************************************
;
IBMJAPVER  EQU	   FALSE		;If TRUE set KANJI true also

;
; Switch INTERNAT for DBCS support
;
INTERNAT   EQU	   FALSE
;
	%if INTERNAT
KANJI	   EQU	   TRUE
IBMJAPAN   EQU	   TRUE
	%else
KANJI	   EQU	   FALSE
IBMJAPAN   EQU	   FALSE
	%endif

%ifndef altvect; avoid jerking off vector.inc
ALTVECT    EQU	   FALSE		;Switch to build ALTVECT version
%endif

;
; Country code switches
; The default contry code is assumed as USA.
;
	%if INTERNAT
 KOREA	   EQU	   TRUE
 JAPAN	   EQU	   FALSE
	%else
 KOREA	   EQU	   FALSE
 JAPAN	   EQU	   FALSE
	%endif
;
	%if 1  ; IF1 - pass-specific
		%if INTERNAT
%warning Internat(ECS) version build switch on
		%endif
	%endif
