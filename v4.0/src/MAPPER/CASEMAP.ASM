
;
; page 80,132
;
; title CP/DOS DosCaseMap
;
SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   doscasemap
;*
;*
;*   CALLING SEQUENCE:
;*
;*             PUSH     WORD    Length
;*             PUSH@    DWORD   CountryCode
;*             PUSH@    DWORD   BinaryString
;*             DosCaseMap
;*
;*   MODULES CALLED:  none
;*
;*********************************************************************

        global doscasemap
        ; .sall
        %include "macros.inc"

struc str
old_bp: resw 1
return: resd 1
StringPtr: resd 1; binary string pointer
CountryCodePtr: resd 1; country code pointer
StringLength: resw 1; lenght of the string
endstruc

DosCaseMap:

        Enter  DosCaseMap               ; save registers

; Get the country, so we can then get the country case map stuff

        lds     si,[bp].CountryCodePtr
        mov     ax,[ds:si]

; Note: do the country selection later (maybe never)

        lds     si,[bp].StringPtr
        mov     cx,[bp].StringLength

MapLoop:                                ; convert characters to upper case
        lodsb
        cmp     al,'a'
        jc      ThisCharDone

        cmp     al,'z'+1
        jnc     ThisCharDone

        add     al,'A' - 'a'
        mov     [ds:si-1],al

ThisCharDone:
        loop    MapLoop                 ; loop until string is complete

        MExit                           ; pop registers
        ret     str_size - 6            ; return
;
; ENDP DosCaseMap

; END SECTION .dosxxx

        ; end
