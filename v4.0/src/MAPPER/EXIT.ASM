;
; page 60,132
;
; title CP/DOS DosExit mapper
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosexit
;*
;*   FUNCTION:  Exit a process
;*
;*   CALLING SEQUENCE:
;*
;*       push      word   action code
;*       push      word   result code
;*       call      dosexit
;*
;*   MODULES CALLED:  DOS Int 21h, Function 4ch, terminate process
;*
;*********************************************************************

            global dosexit
            ; .sall
            %include "macros.inc"

struc str
old_bp: dw 0
return: dd 0
Result: dw 0; result code
Action: dw 0; action code
endstruc

dosexit:

            Enter    DosExit             ; push registers

            mov      ax,[bp].action      ; set resule code area
            cmp      ax,1                ; check for valid action code
            jg       exit                ; jump if invalid action code

            mov      ax,[bp].result      ; else, set result code

            mov      ah,4ch              ; load opcode
            int      21h                 ; do exit

            xor      ax,ax               ; set good return code

exit:       mexit                        ; pop registers
            ret      str_size - 6        ; return

; ENDP dosexit

; END SECTION .dosxxx

            ; end
