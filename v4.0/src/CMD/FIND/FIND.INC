;;
;;  Long Conditional Jump Macros
;;
%macro lja 1
		; LOCAL Nearlabel
		jna	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljae 1
		; LOCAL Nearlabel
		jnae	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljb 1
		; LOCAL Nearlabel
		jnb	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljc 1
		; LOCAL Nearlabel
		jnc	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljbe 1
		; LOCAL Nearlabel
		jnbe	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro lje 1
		; LOCAL Nearlabel
		jne	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljz 1
		; LOCAL Nearlabel
		jnz	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljg 1
		; LOCAL Nearlabel
		jng	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljge 1
		; LOCAL Nearlabel
		jnge	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljl 1
		; LOCAL Nearlabel
		jnl	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljle 1
		; LOCAL Nearlabel
		jnle	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljnc 1
		; LOCAL Nearlabel
		jc	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljne 1
		; LOCAL Nearlabel
		je	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljnz 1
		; LOCAL Nearlabel
		jz	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljno 1
		; LOCAL Nearlabel
		jo	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
%macro ljo 1
		; LOCAL Nearlabel
		jno	Nearlabel
		jmp	Farlabel
Nearlabel:
		%endmacro
