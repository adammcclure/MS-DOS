;*******************************************************************
; Parser Options set for IBMBIO SYSCONF module
;*******************************************************************
;
;**** Default assemble swiches definition **************************

%ifndef FarSW
FarSW	equ	0	; Near call expected
%endif

%ifndef DateSW
DateSW	equ	0	; Check date format
%endif

%ifndef TimeSW
TimeSW	equ	0	; Check time format
%endif

%ifndef FileSW
FileSW	equ	1	; Check file specification
%endif

%ifndef CAPSW
CAPSW	equ	0	; Perform CAPS if specified
%endif

%ifndef CmpxSW
CmpxSW	equ	0	; Check complex list
%endif

%ifndef NumSW
NumSW	equ	1	; Check numeric value
%endif

%ifndef KeySW
KeySW	equ	0	; Support keywords
%endif

%ifndef SwSW
SwSW	equ	1	; Support switches
%endif

%ifndef Val1SW
Val1SW	equ	1	; Support value definition 1
%endif

%ifndef Val2SW
Val2SW	equ	0	; Support value definition 2
%endif

%ifndef Val3SW
Val3SW	equ	1	; Support value definition 3
%endif

%ifndef DrvSW
DrvSW	equ	1	; Support drive only format
%endif

%ifndef QusSW
QusSW	equ	0	; Support quoted string format
%endif

