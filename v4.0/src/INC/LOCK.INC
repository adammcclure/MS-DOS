;
;Equates for LOCK
;
;LOCK functions
;
Lock_all	    equ    0
Unlock_all	    equ    1
Lock_mul_range	    equ    2
Unlock_mul_range    equ    3
Lock_read	    equ    4
Write_unlock	    equ    5
Lock_add	    equ    6

;
;Structure for Lock buffer

struc LockBuf

   Lock_position: dd 0; file position for LOCK
   Lock_length: dd 0; number of bytes to LOCK

endstruc
;
