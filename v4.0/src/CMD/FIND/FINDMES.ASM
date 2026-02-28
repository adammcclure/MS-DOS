      ; title   FIND Messages

%macro Message 2
global sym,sym&_len
sym	db  text
sym&_len db  $-sym
%endmacro

CR	equ	0dh			;A Carriage Return
LF	equ	0ah			;A Line Feed

SECTION .code

	global heading
	message heading,<CR,LF,"---------- ">

; END SECTION .code
	; end
