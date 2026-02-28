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
old_bp: dw 0
return: dd 0
ReturnLength: dd 0
BufferPtr: dd 0
CountryCodePtr: dd 0
BufferLength: dw 0
endstruc
;

struc cntry;country info. sturctrue
ctry_code: dw 0
code_page: dw 0
dformat: dw 0
curr_sym: times 5 db 0
thous_sep: times 2 db 0
decimal_sep: times 2 db 0
date_sep: times 2 db 0
time_sep: times 2 db 0
bit_field: dw 0
curr_cents: dw 0
tformat: dw 0
map_call: dd 0
data_sep: dw 0
ra                      times 5 db 0
endstruc
;

struc Doscntry;country info. sturctrue
 Ddformat: dw 0
 Dcurr_sym: times 5 db 0
 Dthous_sep: times 2 db 0
 Ddecimal_sep: times 2 db 0
 Ddate_sep: times 2 db 0
 Dtime_sep: times 2 db 0
 Dbit_field: db 0
 Dsig_digit: db 0
 Dtformat: db 0
 Dmap_call: dd 0
 Ddata_sep: dw 0
 DResv                    times 5 db 0
endstruc


dosgetctryinfo:

        Enter   Dosgetcntryinfo

        lds     si,[bp].CountryCodePtr
        mov     ax,ds:[si]

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
