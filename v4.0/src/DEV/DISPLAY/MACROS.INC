;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; *** MACROS **** MACROS **** MACROS ****
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
%if 1  ; IF1 - pass-specific;
        %warning .               ®MACROS  .INC¯
%endif;
                                        ;
%macro JUMP 1;
        ; LOCAL A;
; .XCREF;
      %ifndef LBL; IS THIS FIRST INVOKATION
A:       JMP     LBL                    ;
      %else;
         %if (LBL&_J GE $) OR ($-LBL&_J GT 126)
A:          JMP     LBL                 ; IS THE JUMP TOO FAR AWAY?
         %else;
A:          JMP     LBL&_J              ; PERFORM SHORT JUMP
         %endif;
      %endif;
LBL&_J=A                                ;
; .CREF;
        %endmacro;
; .XCREF JUMP;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; *** MACROS **** MACROS **** MACROS ****
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
