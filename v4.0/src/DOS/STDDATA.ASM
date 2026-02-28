;	SCCSID = @(#)stddata.asm	1.1 85/04/10
;
; DATA Segment for MS-DOS
;

; .xlist
; .xcref
%include "stdsw.asm"
%include "dosseg.asm"
debug = FALSE                           ; No dossym (too big)
%include "DOSMAC.INC"
%include "SF.INC"
%include "DIRENT.INC"
%include "CURDIR.INC"
%include "DPB.INC"
%include "BUFFER.INC"
%include "ARENA.INC"
%include "VECTOR.INC"
%include "DEVSYM.INC"
%include "PDB.INC"
%include "FIND.INC"
%include "MI.INC"
; .cref
; .list

; TITLE   STDDATA - DATA segment for MS-DOS
; NAME    STDDATA

installed = TRUE

%include "msdata.asm"
%include "msinit.asm"
	; END
