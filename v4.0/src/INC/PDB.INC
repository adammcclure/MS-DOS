;	SCCSID = @(#)pdb.asm	1.1 85/04/10
BREAK <Process data block>

;
; Process data block (otherwise known as program header)
;

FilPerProc	    EQU     20

struc Process_data_block
PDB_Exit_Call: resw 1; INT int_abort system terminate
PDB_block_len: resw 1; size of execution block
		    resb 1
PDB_CPM_Call: resb 5; ancient call to system
PDB_Exit: resd 1; pointer to exit routine
PDB_Ctrl_C: resd 1; pointer to ^C routine
PDB_Fatal_abort: resd 1; pointer to fatal error
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
PDB_Parent_PID: resw 1; PID of parent (terminate PID)
PDB_JFN_Table	    DB	FilPerProc DUP (?)
					; indices into system table
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
PDB_environ: resw 1; seg addr of environment
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;									   ;
PDB_User_stack: resd 1; stack of self during system calls
PDB_JFN_Length: resw 1; number of handles allowed
PDB_JFN_Pointer: resd 1; pointer to JFN table
PDB_Next_PDB: resd 1; pointer to nested PDB's
PDB_PAD1	    DB	    14h DUP (?)
;									   ;
;	     C	A  V  E  A  T	  P  R	O  G  R  A  M  M  E  R		   ;
;----+----+----+----+----+----+----+----+----+----+----+----+----+----+----;
PDB_Call_system: resb 5; portable method of system call
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