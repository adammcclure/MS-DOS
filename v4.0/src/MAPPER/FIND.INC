; find.inc

        %if 1  ; IF1 - pass-specific
                %warning find.inc
        %endif

struc FileFindBuf
Create_Date: resw 1
Create_Time: resw 1
Access_Date: resw 1
Access_Time: resw 1
Write_Date: resw 1
Write_Time: resw 1
File_Size: resd 1
FAlloc_Size: resd 1
Attributes: resw 1
String_Len: resb 1
File_Name: resb 12
endstruc

;
; dta buffer structure
;

struc dtastr
                resb 21
DTAFileAttrib: resb 1
DTAFileTime: resw 1
DTAFileDate: resw 1
DTAFileSize: resd 1
DTAFileName: resb 13
endstruc

MaxFinds        equ     8
OpenedHandle    equ     08000h

