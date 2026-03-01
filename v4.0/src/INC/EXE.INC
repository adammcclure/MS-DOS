;	SCCSID = @(#)exe.asm	1.1 85/04/10
;	SCCSID = @(#)exe.asm	1.1 85/04/10
BREAK <EXEC and EXE file structures>
;
; EXEC arg block - load/go program
;

;
; The following get used as arguments to the EXEC system call.	They indicate
; whether or not the program is executed or whether or not a program header
; gets created.
;
exec_func_no_execute	EQU 1		; no execute bit
exec_func_overlay	EQU 2		; overlay bit

struc Exec0
Exec0_environ: resw 1; seg addr of environment
Exec0_com_line: resd 1; pointer to asciz command line
Exec0_5C_FCB: resd 1; default fcb at 5C
Exec0_6C_FCB: resd 1; default fcb at 6C
endstruc

struc Exec1
Exec1_environ: resw 1; seg addr of environment
Exec1_com_line: resd 1; pointer to asciz command line
Exec1_5C_FCB: resd 1; default fcb at 5C
Exec1_6C_FCB: resd 1; default fcb at 6C
Exec1_SP: resw 1; stack pointer of program
Exec1_SS: resw 1; stack seg register of program
Exec1_IP: resw 1; entry point IP
Exec1_CS: resw 1; entry point CS
endstruc

struc Exec3
Exec3_load_addr: resw 1; seg address of load point
Exec3_reloc_fac: resw 1; relocation factor
endstruc

;
; Exit codes in upper byte
;
Exit_terminate	    EQU     0
Exit_abort	    EQU     0
Exit_Ctrl_C	    EQU     1
Exit_Hard_Error     EQU     2
Exit_Keep_process   EQU     3

;
; EXE file header
;

struc EXE_file
exe_signature: resw 1; must contain 4D5A  (yay zibo!)
exe_len_mod_512: resw 1; low 9 bits of length
exe_pages: resw 1; number of 512b pages in file
exe_rle_count: resw 1; count of reloc entries
exe_par_dir: resw 1; number of paragraphs before image
exe_min_BSS: resw 1; minimum number of para of BSS
exe_max_BSS: resw 1; max number of para of BSS
exe_SS: resw 1; stack of image
exe_SP: resw 1; SP of image
exe_chksum: resw 1; checksum  of file (ignored)
exe_IP: resw 1; IP of entry
exe_CS: resw 1; CS of entry
exe_rle_table: resw 1; byte offset of reloc table
exe_iov: resw 1; overlay number (0 for root)
exe_sym_tab: resd 1; offset of symbol table in file
endstruc

exe_valid_signature	EQU 5A4Dh
exe_valid_old_signature EQU 4D5Ah

struc symbol_entry
sym_value: resd 1
sym_type: resw 1
sym_len: resb 1
sym_name: resb 255
endstruc
