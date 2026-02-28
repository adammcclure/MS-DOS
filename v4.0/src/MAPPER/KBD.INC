; KeyData

struc KeyData

Char_Code: db 0
Scan_Code: db 0
Status: db 0
Shift_State: dw 0
Time: dd 0

endstruc



struc KbdStatus

KS_Length: dw 0
Bit_mask: dw 0
Turn_Around_Char: dw 0
Interim_Char_Flags: dw 0
Status_Shift_State: dw 0

endstruc

; Bit_Mask equates

CookedModeOn    equ     8
RawModeOn       equ     4
EchoOff         equ     2
EchoOn          equ     1


        %include "macros.inc"

