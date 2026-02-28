;       Static Name Aliases
;
        ; TITLE   bootrec.asm - master boot record images for fdisk

SECTION ._TEXT
; END SECTION ._TEXT
SECTION ._DATA
; END SECTION ._DATA
SECTION .CONST
; END SECTION .CONST
SECTION ._BSS
; END SECTION ._BSS

; DGROUP  GROUP     CONST,  _BSS,   _DATA
        ; ASSUME  CS: _TEXT, DS: DGROUP, SS: DGROUP, ES: DGROUP

SECTION ._DATA

;
;               extern  struct struct-name BootRecordData;
;
;
;


global _master_boot_record
        global _master_boot_record
_master_boot_record:

%include "fdboot.inc"
%include "fdboot.inc"

; END SECTION ._DATA

; END
