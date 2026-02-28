SECTION .PSP;an000;bgb
; END SECTION .PSP;an000;bgb
										;an000;bgb
SECTION .data;an000;bgb
; END SECTION .data;an000;bgb
										;an000;bgb
SECTION .CONST;an000;bgb
; END SECTION .CONST;an000;bgb
										;an000;bgb
SECTION .code;an000;bgb
; END SECTION .code;an000;bgb
										;an000;bgb
SECTION .cstack;an000;bgb
; END SECTION .cstack;an000;bgb
										;an000;bgb
SECTION .lastseg;an000;bgb;AN000;bgb
; END SECTION .lastseg;this is a pointer to the end of the pgm     ;A;an000;bgbN000;bgb
										;an000;bgb;AN000;bgb
; DG	GROUP	data,const,code,CSTACK,lastseg;an000;bgb
; assume	cs:dg,ds:dg,ss:dg,es:dg;an000;bgb
