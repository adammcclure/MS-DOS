;      SCCSID = @(#)d_gctrcd.asm        1.1 86/06/03
; .xlist
;  include struc.inc
%include "nlsapi.inc"
; .list

; DGROUP  group   _DATA

SECTION ._TEXT
; END SECTION ._TEXT

SECTION ._DATA
        extern _ApiSel
; END SECTION ._DATA

SECTION ._TEXT

extern W_NLS_APIS

global DOSGETCTRYINFO
DOSGETCTRYINFO:
        ; assume  cs:_TEXT


        mov     AX,BP               ; Add 4 bytes of dummy parameters to the
        mov     BP,SP               ; Stack by copying the return address down 4
        push    [BP+2]
        push    [BP]
        mov     BP,AX

        push    DS
        mov     AX,_DATA
        mov     DS,AX
        mov     AX, SETFILELIST
        mov     DS:_ApiSel,AX
        pop     DS

        jmp     W_NLS_APIS

;       pop     bp
;       ret     14

; ENDP DOSGETCTRYINFO

; END SECTION ._TEXT
        ; END
