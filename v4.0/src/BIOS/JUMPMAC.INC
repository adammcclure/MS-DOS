						  ;;Rev 3.30 Modification
;
; given a label <lbl> either 2 byte jump to another label <lbl>_J
; if it is near enough or 3 byte jump to <lbl>
;

%macro jump 1
	; LOCAL a
; .xcref

	%ifndef lbl;; is this the first invocation
a:
				JMP lbl
	%else
	    %if (lbl&_J GE $) OR ($-lbl&_J GT 126)
a:
				JMP lbl ;; is the jump too far away?
	    %else
a:
			       JMP lbl&_J  ;; do the short one...
	    %endif
	%endif
lbl&_j = a
; .cref
	%endmacro
; .xcref	jump
;REDEFINE THE ABOVE MACRO TO ALWAYS TRY A 3 BYTE NEAR JUMP		 
%macro JUMP 1
					JMP LBL 			 
	%endmacro;;End of Modification
