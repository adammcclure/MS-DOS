;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	      ;AN000;
;								      ;AN000;
; MORE STRUC AND EQUATES					      ;AN000;
;								      ;AN000;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	      ;AN000;
;								      ;AN000;
ANSI_GET	EQU    440CH					      ;AN000;
GET_SUBFUNC	EQU    037FH					      ;AN000;
EXTENDED	EQU    0					      ;AN000;
TEXT_MODE	EQU    1					      ;AN000;
MORE_MSG	EQU    2					      ;AN000;
FILE_TYPE_MSG	EQU    4					      ;AN001;
DATA_LENGTH	EQU    14					      ;AN000;
;								      ;AN000;
struc ANSI_STR;AN000;
	    resb 1;AN000;
	    resb 1;AN000;
	    resw 1;AN000;
	    resw 1;AN000;
D_MODE: resb 1;AN000;
	    resb 1;AN000;
	    resw 1;AN000;
	    resw 1;AN000;
	    resw 1;AN000;
	    resw 1;AN000;
SCR_ROWS: resw 1;AN000;
endstruc;AN000;

