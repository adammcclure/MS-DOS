; find.inc

        %if 1  ; IF1 - pass-specific
                %warning find.inc
        %endif

struc FileFindBuf
Create_Date: dw 0
Create_Time: dw 0
Access_Date: dw 0
Access_Time: dw 0
Write_Date: dw 0
Write_Time: dw 0
File_Size: dd 0
FAlloc_Size: dd 0
Attributes: dw 0
String_Len: db 0
File_Name: times 12 db 0
endstruc

;
; dta buffer structure
;

struc dtastr
                times 21 db 0
DTAFileAttrib: db 0
DTAFileTime: dw 0
DTAFileDate: dw 0
DTAFileSize: dd 0
DTAFileName: times 13 db 0
endstruc

MaxFinds        equ     8
OpenedHandle    equ     08000h

