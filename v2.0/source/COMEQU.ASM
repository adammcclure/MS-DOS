;*************************************
; COMMAND EQUs which are not switch dependant

%ifdef IBM
        %include "IFEQU.ASM"
%endif


SYM     EQU     ">"

LINPERPAG       EQU     23
NORMPERLIN      EQU     1
WIDEPERLIN      EQU     5
COMBUFLEN       EQU     128     ; Length of commmand buffer

DRVCHAR         EQU     ":"

FCB     EQU     5CH

struc VARSTRUC
ISDIR: db 0
SIZ: db 0
TTAIL: dw 0
INFO: db 0
BUF     DB      DIRSTRLEN + times 20 db 0
endstruc

WSWITCH EQU     1               ; Wide display during DIR
PSWITCH EQU     2               ; Pause (or Page) mode during DIR
ASWITCH EQU     4               ; ASCII mode during COPY
BSWITCH EQU     8               ; Binary mode during COPY
VSWITCH EQU     10H             ; Verify switch
GOTSWITCH EQU   8000H           ; Meta switch set if switch character encountered
