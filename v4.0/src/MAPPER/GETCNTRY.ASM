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
old_bp: resw 1
return: resd 1
ReturnLength: resd 1
BufferPtr: resd 1
CountryCodePtr: resd 1
BufferLength: resw 1
endstruc


struc cntry;country info. sturctrue
ctry_code: resw 1
code_page: resw 1
dformat: resw 1
curr_sym: resb 5
thous_sep: resw 1
decimal_sep: resw 1
date_sep: resw 1
time_sep: resw 1
bit_field: resb 1
curr_cents: resb 1
tformat: resb 1
map_call: resd 1
data_sep: resw 1
ra: resb 5
endstruc


struc Doscntry;country info. sturctrue
 Ddformat: resw 1
 Dcurr_sym: resb 5
 Dthous_sep: resw 1
 Ddecimal_sep: resw 1
 Ddate_sep: resw 1
 Dtime_sep: resw 1
 Dbit_field: resb 1
 Dsig_digit: resb 1
 Dtformat: resb 1
 Dmap_call: resd 1
 Ddata_sep: resw 1
 DResv: resb 5
endstruc


dosgetctryinfo:

        Enter   Dosgetcntryinfo       ; save registers

        lds     si,[bp].CountryCodePtr
        mov     ax,[ds:si]            ; get country code pointer

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
        mov     [es:di].dformat,ax
        mov     ax,[si].ddate_sep                ;copy date seperator
        mov     [es:di].date_sep,ax
        mov     ax,[si].dtime_sep                ;copy time separator
        mov     [es:di].time_sep,ax
        mov     al,[si].dtformat                 ;copy time format
        mov     [es:di].tformat,al

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
