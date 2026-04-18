; TITLE   MORE Messages

SECTION .CODE
        global MORETXT,BADVER,CRLFTXT,BUFFER

MORETXT DB      13,"-- More --$"
BADVER  DB      "MORE: Incorrect DOS version"
CRLFTXT DB      13,10,"$"
;
; THIS VARIABLE MUST BE DEFINED LAST!
;
BUFFER: times 4098 db 0

; END SECTION .CODE
        ; END

