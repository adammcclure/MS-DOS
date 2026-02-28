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
Exec0_environ: dw 0; seg addr of environment
Exec0_com_line: dd 0; pointer to asciz command line
Exec0_5C_FCB: dd 0; default fcb at 5C
Exec0_6C_FCB: dd 0; default fcb at 6C
endstruc

struc Exec1
Exec1_environ: dw 0; seg addr of environment
Exec1_com_line: dd 0; pointer to asciz command line
Exec1_5C_FCB: dd 0; default fcb at 5C
Exec1_6C_FCB: dd 0; default fcb at 6C
Exec1_SP: dw 0; stack pointer of program
Exec1_SS: dw 0; stack seg register of program
Exec1_IP: dw 0; entry point IP
Exec1_CS: dw 0; entry point CS
endstruc

struc Exec3
Exec3_load_addr: dw 0; seg address of load point
Exec3_reloc_fac: dw 0; relocation factor
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
exe_signature: dw 0; must contain 4D5A  (yay zibo!)
exe_len_mod_512: dw 0; low 9 bits of length
exe_pages: dw 0; number of 512b pages in file
exe_rle_count: dw 0; count of reloc entries
exe_par_dir: dw 0; number of paragraphs before image
exe_min_BSS: dw 0; minimum number of para of BSS
exe_max_BSS: dw 0; max number of para of BSS
exe_SS: dw 0; stack of image
exe_SP: dw 0; SP of image
exe_chksum: dw 0; checksum  of file (ignored)
exe_IP: dw 0; IP of entry
exe_CS: dw 0; CS of entry
exe_rle_table: dw 0; byte offset of reloc table
exe_iov: dw 0; overlay number (0 for root)
exe_sym_tab: dd 0; offset of symbol table in file
endstruc

exe_valid_signature	EQU 5A4Dh
exe_valid_old_signature EQU 4D5Ah

struc symbol_entry
sym_value: dd 0
sym_type: dw 0
sym_len: db 0
sym_name: times 255 db 0
endstruc
