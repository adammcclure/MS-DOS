;
; Macro file for MSDOS.
;

; SUBTTL BREAK a listing into pages and give new subtitles
; PAGE
%macro BREAK 1
 ; SUBTTL subtitle
 ; PAGE
%endmacro

BREAK <I_NEED: declare a variable external, if necessary, and allocate a size>

;
; declare a variable external and allocate a size
;
%macro I_NEED 2
 SECTION .DATA
 %ifidn <len>,<WORD>
 extern &sym
 %else
 %ifidn <len>,<DWORD>
 extern &sym
 %else
 extern &sym
 %endif
 %endif
 ; END SECTION .DATA
%endmacro

;
; call a procedure that may be external. The call will be short.
;
%macro invoke 1
; .xcref
 %if 1  ; IF2 - pass-specific
 %ifndef name
 extern name
 %endif
 %endif
; .cref
 CALL name
%endmacro

; PAGE
;
; jump to a label that may be external. The jump will be near.
;
%macro transfer 1
; .xcref
 %if 1  ; IF2 - pass-specific
 %ifndef name
 extern name
 %endif
 %endif
; .cref
 JUMP name
%endmacro

;
; get a short address in a word
;
%macro short_addr 1
 %ifnidn <name>,<?>
; .xcref
 %if 1  ; IF2 - pass-specific
 %ifndef name
 extern name
 %endif
 %endif
; .cref
 DW name
 %else
 dw 0
 %endif
%endmacro

;
; get a long address in a dword
;
%macro long_addr 1
; .xcref
 %if 1  ; IF2 - pass-specific
 %ifndef name
 extern name
 %endif
; .cref
 DD name
%endmacro

;
; declare a PROC near or far but PUBLIC nonetheless
;
%macro procedure 2
 global name
; name PROC distance
%endmacro

; PAGE
;
; define a data item to be public and of an appropriate size/type
;
%macro I_AM 2
 global name

 %ifidn <size>,<WORD>
; name DW ?
 %else
 %ifidn <size>,<DWORD>
; name DD ?
 %else
 %ifidn <size>,<BYTE>
; name DB ?
 %else
; name DB size DUP (?)
 %endif
 %endif
 %endif
%endmacro

; PAGE
;
; call the macro chain
;
%macro do_ext 0
%endmacro

; PAGE

;
; define an entry in a procedure
;
%macro entry 1
 global name
name:
%endmacro

BREAK <ERROR - print a message and then jump to a label>

%macro error 1
 ; LOCAL a
; .xcref
 MOV AL,code
 transfer SYS_RET_ERR
; .cref
%endmacro

BREAK <JUMP - real jump that links up shortwise>
;
; given a label <lbl> either 2 byte jump to another label <lbl>_J
; if it is near enough or 3 byte jump to <lbl>
;

%macro jump 1
 ; LOCAL a
; .xcref
 a:
 %ifndef lbl;; is this the first invocation
 JMP lbl
 %else
 %if lbl&_J GE $
 JMP lbl
 %else
 %if ($-lbl&_J) GT 126;; is the jump too far away?
 JMP lbl
 %else;; do the short one...
 JMP lbl&_J
 %endif
 %endif
 %endif
 lbl&_j = a
; .cref
%endmacro

BREAK <RETURN - return from a function>

%macro return 0
 ; LOCAL a
; .xcref
a:
 RET
ret_l equ a
; .cref
%endmacro

BREAK <CONDRET - conditional return>

%macro makelab 3
 ; LOCAL a
 j&ncc a ;; j<NCC> a:
 return ;; return
 a: ;; a:
 ret_&cc = ret_l ;; define ret_<CC> to be ret_l
%endmacro

%macro condret 2
 ; LOCAL a,b
 %ifdef ret_l;; if ret_l is defined
 %if (($ - ret_l) le 126) and ($ gt ret_l)
 ;; if ret_l is near enough then
 a: j&cc ret_l ;; a: j<CC> to ret_l
 ret_&cc = a ;; define ret_<CC> to be a:
 %else
 makelab a,cc,ncc
 %endif
 %else
 %ifdef ret_;; if ret_<CC> defined
 %if (($ - ret_&cc) le 126) and ($ gt ret_&cc)
 ;; if ret_<CC> is near enough
 a: j&cc ret_&cc ;; a: j<CC> to ret_<CC>
 ret_&cc = a ;; define ret_<CC> to be a:
 %else
 makelab a,cc,ncc
 %endif
 %else
 makelab a,cc,ncc
 %endif
 %endif
%endmacro
;condret macro cc,ncc
; local a,b
; ifdef ret_l ; if ret_l is defined
; if (($ - ret_l) le 126) and ($ gt ret_l)
; ; if ret_l is near enough then
; a: j&cc ret_l ; a: j<CC> to ret_l
; ret_&cc = a ; define ret_<CC> to be a:
; exitm
; endif
; endif
; ifdef ret_&cc ; if ret_<CC> defined
; if (($ - ret_&cc) le 126) and ($ gt ret_&cc)
; ; if ret_<CC> is near enough
; a: j&cc ret_&cc ; a: j<CC> to ret_<CC>
; ret_&cc = a ; define ret_<CC> to be a:
; exitm
; endif
; endif
; j&ncc a ; j<NCC> a:
; return ; return
; a: ; a:
; ret_&cc = ret_l ; define ret_<CC> to be ret_l
;endm
;
BREAK <RETZ - return if zero, links up shortwise if necessary>

%macro retz 0
 condret z,nz
%endmacro

BREAK <RETNZ - return if not zero, links up shortwise if necessary>

%macro retnz 0
 condret nz,z
%endmacro

BREAK <RETC - return if carry set, links up shortwise if necessary>

%macro retc 0
 condret c,nc
%endmacro

BREAK <RETNC - return if not carry, links up shortwise if necessary>

%macro retnc 0
 condret nc,c
%endmacro

BREAK <CONTEXT - set the DOS context to a particular register>

%macro context 1
 PUSH SS
 POP r
 ; ASSUME r:DOSGROUP
%endmacro
