; KeyData

struc KeyData

Char_Code: resb 1
Scan_Code: resb 1
Status: resb 1
Shift_State: resw 1
Time: resd 1

endstruc



struc KbdStatus

KS_Length: resw 1
Bit_mask: resw 1
Turn_Around_Char: resw 1
Interim_Char_Flags: resw 1
Status_Shift_State: resw 1

endstruc

; Bit_Mask equates

CookedModeOn    equ     8
RawModeOn       equ     4
EchoOff         equ     2
EchoOn          equ     1


        %include "macros.inc"

