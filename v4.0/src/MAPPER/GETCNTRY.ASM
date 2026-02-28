;
; page 60,132
;
; title CP/DOS DosGetCtryInfo mapper

SECTION .Buffer
CountryInfo     db      64
; END SECTION .Buffer

SECTION .dosxxx
        ; assume  cs:dosxxx,ds:nothing,es:nothing,ss:nothing

;**********************************************************************
;*
;*   MODULE:   dosgetctryinfo
;*
;*   FUNCTION:get country information
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

            global dosgetctryinfo
            ; .sall
            %include "macros.inc"


struc str
old_bp: dw 0
return: dd 0
ReturnLength: dd 0
BufferPtr: dd 0
CountryCodePtr: dd 0
BufferLength: dw 0
endstruc


struc cntry;country info. sturctrue
ctry_code: dw 0
code_page: dw 0
dformat: dw 0
curr_sym: times 5 db 0
thous_sep: dw 0
decimal_sep: dw 0
date_sep: dw 0
time_sep: dw 0
bit_field: db 0
curr_cents: db 0
tformat: db 0
map_call: dd 0
data_sep: dw 0
ra: times 5 db 0
endstruc


struc Doscntry;country info. sturctrue
 Ddformat: dw 0
 Dcurr_sym: times 5 db 0
 Dthous_sep: dw 0
 Ddecimal_sep: dw 0
 Ddate_sep: dw 0
 Dtime_sep: dw 0
 Dbit_field: db 0
 Dsig_digit: db 0
 Dtformat: db 0
 Dmap_call: dd 0
 Ddata_sep: dw 0
 DResv: times 5 db 0
endstruc


dosgetctryinfo:

        Enter   Dosgetcntryinfo       ; save registers

        lds     si,[bp].CountryCodePtr
        mov     ax,ds:[si]            ; get country code pointer

        cmp     ax,256                ; 16 bit country code
        jc      getinfo

        mov     bx,ax                 ; if so, load into bx
        mov     al,0ffH               ; and tell DOS it is get country

getinfo:
        mov     dx,seg buffer
        mov     ds,dx
        ; assume  ds:buffer
        mov     dx,CountryInfo

        mov     ah,38h          ; remember: the al value was set above!!!
        int     21h             ; get country information
        jc      ErrorExit

        mov     si,CountryInfo     ;pointer to DOS cntry infor
        les     di,[bp].BufferPtr                ;pointer to return data area

        mov     ax,[si].ddformat                 ;copy date format
        mov     es:[di].dformat,ax
        mov     ax,[si].ddate_sep                ;copy date seperator
        mov     es:[di].date_sep,ax
        mov     ax,[si].dtime_sep                ;copy time separator
        mov     es:[di].time_sep,ax
        mov     al,[si].dtformat                 ;copy time format
        mov     es:[di].tformat,al

        mov     cx,[bp].BufferLength  ;was buffer larger than pc-dos gave us?
        sub     cx,34
        jc      NoFillNecessary       ; no fill necessary

        les     di,[bp].BufferPtr     ; else fill the remaining area
        add     di,34                 ;   with zeros
        mov     al,0
        rep     stosb

NoFillNecessary:
        sub     ax,ax                 ; set good return code

ErrorExit:
        Mexit                         ; pop registers

        ret     str_size - 6          ; return

; ENDP dosgetctryinfo

; END SECTION .dosxxx

            ; end
