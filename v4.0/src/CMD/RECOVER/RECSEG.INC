; define the segment ordering						       ;AN000;bgb
									       ;AN000;bgb
SECTION .data;AN000;bgb
; END SECTION .data;put this 1st so that the recmsg works			       ;AN000;bgb
									       ;AN000;bgb
SECTION .code;AN000;bgb
; END SECTION .code;AN000;bgb
									       ;AN000;bgb
SECTION .const;AN000;bgb
; END SECTION .const;AN000;bgb
									       ;AN000;bgb
SECTION .cstack;AN000;bgb
	db	(362 - 80h) + times 256 db 0 ; (362 - 80h) == IBM's ROM requirements ;AN000;bgb
; END SECTION .cstack; (New - Old) == size of growth 				;AN005;bgb
										;AN005;bgb
SECTION .lastseg;AN005;bgb
; END SECTION .lastseg;put last because 'table' writes over memory   ;AN005;bgb
										;AN000;bgb
; dg	group	data,const,code,cstack,lastseg;AN000;bgb
	; assume	cs:dg,ds:dg,es:dg,ss:CSTACK;AN000;bgb
