;
; page 60,132
;
; title CP/DOS DosGetCtryInfo mapper

SECTION .Buffer
CountryInfo     db      64
; END SECTION .Buffer

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing
;
;**********************************************************************
;*
;*   MODULE:   dosgetctryinfo
;*
;*   FILE NAME: dos024.asm
;*
;*   CALLING SEQUENCE:
;*
;*       push      word   data area length
;*       push      word   country code
;*       push@     struc  data area
;*       call      dosgetctryinfo
;*
;*   MODULES CALLED:  PC-DOS Int 21h, ah=38h, get cntry info
;*
;*********************************************************************
;
            global dosgetctryinfo
            ; .sall
            %include "macros.inc"

;
struc str
old_bp: resw 1
return: resd 1
ReturnLength: resd 1
BufferPtr: resd 1
CountryCodePtr: resd 1
BufferLength: resw 1
endstruc
;

struc cntry;country info. sturctrue
ctry_code: resw 1
code_page: resw 1
dformat: resw 1
curr_sym: resb 5
thous_sep: resb 2
decimal_sep: resb 2
date_sep: resb 2
time_sep: resb 2
bit_field: resw 1
curr_cents: resw 1
tformat: resw 1
map_call: resd 1
data_sep: resw 1
ra                      times 5 db 0
endstruc
;

struc Doscntry;country info. sturctrue
 Ddformat: resw 1
 Dcurr_sym: resb 5
 Dthous_sep: resb 2
 Ddecimal_sep: resb 2
 Ddate_sep: resb 2
 Dtime_sep: resb 2
 Dbit_field: resb 1
 Dsig_digit: resb 1
 Dtformat: resb 1
 Dmap_call: resd 1
 Ddata_sep: resw 1
 DResv                    times 5 db 0
endstruc


dosgetctryinfo:

        Enter   Dosgetcntryinfo

        lds     si,[bp].CountryCodePtr
        mov     ax,[ds:si]

        cmp     ax,256                ;16 bit country code
        jc      getinfo

        mov     bx,ax                 ;if so, load into bx
        mov     al,0ffH               ;and tell DOS

getinfo:
        mov     dx,seg buffer
        mov     ds,dx
        ; assume  ds:buffer
        mov     dx,CountryInfo

        mov     ah,38h          ; remember: the al value was set above!!!
        int     21h
        jc      ErrorExit
;
        mov     si,CountryInfo
        les     di,[bp].BufferPtr
        cld                            ;string move op.

        mov     cx,[bp].BufferLength  ;length to move

        rep     movsb                 ;copy all to output area

        mov     cx,[bp].BufferLength  ;was buffer larger than pc-dos gave us?
        sub     cx,34
        jc      NoFillNecessary

        les     di,[bp].BufferPtr
        add     di,34

        mov     al,0                  ;fill with zeroes
        rep     stosb
;
NoFillNecessary:
        sub     ax,ax

ErrorExit:
        Mexit

        ret     str_size - 6
;
; ENDP dosgetctryinfo

; END SECTION .dosxxx

            ; end
