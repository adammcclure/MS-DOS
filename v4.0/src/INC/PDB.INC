;	SCCSID = @(#)pdb.asm	1.1 85/04/10
BREAK <Process data block>

;
; Process data block (otherwise known as program header)
;

FilPerProc	    EQU     20

struc Process_data_block
PDB_Exit_Call: dw 0; INT int_abort system terminate
PDB_block_len: dw 0; size of execution block
		    db 0
PDB_CPM_Call: times 5 db 0; ancient call to system
PDB_Exit: dd 0; pointer to exit routine
PDB_Ctrl_C: dd 0; pointer to ^C routine
PDB_Fatal_abort: dd 0; pointer to fatal error
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
PDB_Parent_PID: dw 0; PID of parent (terminate PID)
PDB_JFN_Table	    DB	FilPerProc DUP (?)
					; indices into system table
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
PDB_environ: dw 0; seg addr of environment
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
PDB_User_stack: dd 0; stack of self during system calls
PDB_JFN_Length: dw 0; number of handles allowed
PDB_JFN_Pointer: dd 0; pointer to JFN table
PDB_Next_PDB: dd 0; pointer to nested PDB's
PDB_PAD1	    DB	    14h DUP (?)
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
PDB_Call_system: times 5 db 0; portable method of system call
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
PDB_PAD2	    DB	    7h DUP (?)
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
endstruc

PDB_InterCon	EQU	byte PDB_PAD1	; 2/12/KK
PDB_Append	EQU	byte PDB_PAD1+1	; 2/12/KK
